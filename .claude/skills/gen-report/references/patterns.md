# Mẫu SQL theo 4 loại trường

Các mẫu lấy từ `mapping/BAOCAO/BC1_RLOS_APPLICATION.sql`. Thay tên bảng/cột theo báo cáo cụ thể.

## 1. Cột lấy trực tiếp (pass-through)

Trường SRS có cột PDTD_DTM cùng nguồn gốc (lineage **auto**). Lấy thẳng từ driving hoặc DIM đã join.

```sql
a.CHANGE_REQUEST,
a.LAST_ENTRYDATE,
d.POLICY,                          -- d = PDTD_DTM.DIM_RLOS_APPLICATION
a.APPROVED_AMT_FINAL AS LOAN_AMOUNT,   -- khác tên: đã xác định qua lineage
```

## 2. Trường phái sinh tại tầng báo cáo

SRS mô tả công thức; viết **đúng công thức SRS** trên cột thô PDTD_DTM.

```sql
CASE WHEN cr.CUS_SEGMENT LIKE '%xanh' OR cr.CUS_SEGMENT LIKE '%XANH' THEN 'XANH'
     WHEN cr.CUS_SEGMENT = 'CBNV' THEN 'CBNV'
     ELSE 'THUONG' END AS BI_CUS_SEGMENT,

cr.CURR_HOUSE_NO || ', ' || cr.CURR_WARD || ', ' || cr.DISTRICT_NAME || ', ' || cr.CITY_NAME
    AS CURRENT_RESIDENTIAL_ADDRESS,

SUBSTR(REGEXP_REPLACE(
      CASE WHEN d.SALARYFLAG = 'Yes' THEN 'Lương / ' END
   || CASE WHEN d.CARFLAG    = 'Yes' THEN 'Cho thuê phương tiện / ' END
   -- ... đủ 10 cờ theo SRS
   , ' / $', ''), 1, 200) AS REPAYMENT_SOURCE,

CASE WHEN col.HAS_BDS = 1 THEN 'YES' ELSE 'NO' END AS TSBD_BDS,
```

Giá trị phái sinh đã có sẵn ở PDTD_DTM (ví dụ `PROOF_OF_INCOME` đã CASE ở DIM) thì lấy thẳng, không CASE lại.

## 3. Nhóm 1–N

Xác định theo `decisions/BCn.md`.

**Gộp 1 dòng / hồ sơ (CTE + LISTAGG):**

```sql
-- Tai san bao dam: gop 1 dong / ho so
col AS (
    SELECT cl.WI_NAME,
           MAX(CASE WHEN UPPER(cl.COLLATERAL_TYPE_CODE) = 'REALESTATE' THEN 1 ELSE 0 END) AS HAS_BDS,
           LISTAGG(DISTINCT CASE WHEN UPPER(cl.COLLATERAL_TYPE_CODE) = 'REALESTATE' THEN cl.OWNER_NAME END, ';')
               WITHIN GROUP (ORDER BY CASE WHEN UPPER(cl.COLLATERAL_TYPE_CODE) = 'REALESTATE' THEN cl.OWNER_NAME END)
               AS OWNERSHIP
    FROM   PDTD_DTM.FCT_RLOS_COLLATERAL cl
    JOIN   app ON app.DAYID = cl.DAYID AND app.WI_NAME = cl.WI_NAME
    GROUP  BY cl.WI_NAME
)
```

**Nhiều dòng, gộp ở mức "1 người / 1 đối tượng" (đồng trả nợ):**

```sql
corep AS (
    SELECT cp.WI_NAME, cp.ID_NO_CO,
           MAX(cp.FULL_NAME) AS CO_REPAYER,
           LISTAGG(DISTINCT CASE WHEN cp.ID_TYPE IN ('TCC','CC') THEN cp.ID_NUMBER END, ';')
               WITHIN GROUP (ORDER BY CASE WHEN cp.ID_TYPE IN ('TCC','CC') THEN cp.ID_NUMBER END) AS ADD_ID_COREPAYER
    FROM   PDTD_DTM.FCT_RLOS_COREPAYER cp
    JOIN   app ON app.DAYID = cp.DAYID AND app.WI_NAME = cp.WI_NAME
    GROUP  BY cp.WI_NAME, cp.ID_NO_CO
)
-- FROM ... LEFT JOIN corep cp ON cp.WI_NAME = a.WI_NAME
```

**Nhiều dòng, join trực tiếp (sản phẩm phụ):**

```sql
LEFT JOIN PDTD_DTM.FCT_RLOS_APPLICATION_SECONDPRODUCT sp
       ON sp.WI_NAME = a.WI_NAME AND sp.DAYID = a.DAYID
-- cột: sp.SUB_PRODUCT_LINE AS SAN_PHAM_PHU, sp.SPP_AMOUNT, sp.SPP_TERM
-- ORDER BY a.WI_NAME, cp.ID_NO_CO, sp.SUB_PRODUCT_BK
```

**Applicant 1 dòng đại diện** (khi người dùng chọn): xem Mục 4 của `gen-rules.md`.

## 4. Tra DIM / T24 qua khóa SK

```sql
LEFT JOIN PDTD_DTM.DIM_RLOS_CHANGE_TYPE  ct   ON ct.DIMENSION_KEY   = a.CHANGE_TYPE_SK
LEFT JOIN PDTD_DTM.DIM_RLOS_PRODUCT      pr   ON pr.DIMENSION_KEY   = a.SUB_PRODUCT_SK
LEFT JOIN PDTD_DTM.DIM_T24_CARD          card ON card.DIMENSION_KEY = a.T24_CARD_SK
LEFT JOIN PDTD_DTM.DIM_T24_CUSTOMER      t24c ON t24c.DIMENSION_KEY = cr.T24_CUSTOMER_SK
```

Các bảng T24 thay cho `STG_DIM_*` của SRS: xem bảng ở Mục 1 của `gen-rules.md`.

## Chọn mẫu theo trạng thái của `build_field_map.py`

| Trạng thái | Việc cần làm |
|---|---|
| auto, cột trùng nghĩa | Mẫu 1 |
| auto/candidate, SRS có công thức | Mẫu 2 |
| Cột thuộc bảng FCT khác driving (nhóm 1–N) | Mẫu 3, theo quyết định grain |
| Cột là khóa SK, giá trị nằm ở DIM | Mẫu 4 |
| unresolved | Đọc SRS + `etl_logic` của các cột ứng viên trong LLD; còn mơ hồ thì hỏi |
