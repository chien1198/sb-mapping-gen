# LLD Attributes CSV — Reference

## Header (11 cột)

```
target_table,target_column,nullable,data_type,key,description,etl_logic,etl_logic_type,source_table,source_column,note
```

So với khung 15 cột của skill mẫu (`datamart-lld-design`): bỏ hẳn
`source_entity`/`target_entity`/`target_attribute`/`data_domain` (dự án
này không có tầng Atomic logic name, tên bảng vật lý = tên logic luôn;
`data_domain` gộp thẳng vào `data_type`), đổi `datamart_table` →
`target_table`, `datamart_column` → `target_column`, `atomic_table` →
`source_table`, `atomic_column` → `source_column`, và thêm `note` để giữ
lại mọi cảnh báo/PENDING lấy nguyên văn từ HLD mà không nhồi vào
`description` (xem quy tắc `description` bên dưới).

Export encoding: **UTF-8 BOM** (`utf-8-sig`). Mọi giá trị `etl_logic` và
`description` có dấu phẩy phải được bao double-quote.

---

## Nguồn sự thật — thứ tự đọc bắt buộc

1. **`hld/HLD_Table_Design.md`** — nguồn chính. Với 1 bảng ở tầng SB_DWH: đọc
   Section 1 (mục lineage của đúng bảng đó, dưới đúng heading
   CHUNG/CLOS/RLOS/REF_) + Section 2 (bảng cột chi tiết cùng heading). Với 1
   bảng ở tầng PDTD_DTM: cũng đọc đúng heading tương ứng ở PDTD_DTM (2.x) —
   **note quan trọng:** phần lớn bảng PDTD_DTM ghi "bê 1:1 từ SB_DWH" + một số
   cột bổ sung riêng — phải đọc CẢ HAI mục SB_DWH và PDTD_DTM của bảng đó để
   có đủ danh sách cột (cột kế thừa + cột bổ sung tại PDTD_DTM).

   **Xác định nguồn bằng sơ đồ mermaid ở Section 1 (căn cứ duy nhất cho
   driving table + mọi nguồn khác):** mỗi bảng trong Section 1 có 1 sơ đồ
   `flowchart` mermaid vẽ đúng các bảng nguồn thật sự đổ vào bảng đích, kèm
   nhãn trên mỗi mũi tên mô tả quan hệ (`1:1`, `PHÁI SINH`, `LEFT JOIN...`).
   Đọc trực tiếp sơ đồ này để biết bảng nào là nguồn, không suy đoán qua văn
   bản mô tả grain hay thứ tự liệt kê. Chi tiết cách xác định driving table
   cụ thể từ sơ đồ này ở mục "Xác định Driving Table" bên dưới.
2. **`extract/SB_DWH/<OLD_TABLE>.md`** hoặc **`extract/PDTD_DTM/<OLD_TABLE>.md`**
   — bản STT/Tên cột/Kiểu dữ liệu/Độ lớn/Khóa/Nguồn/Mô tả chi tiết hơn của
   bảng GỘP cũ (trước khi tách CLOS/RLOS). Dùng để lấy `data_type`/`Độ lớn`
   chính xác cho cột đã tồn tại từ trước, và để đọc "Cách lấy dữ liệu"/"Trường
   đích trên báo cáo" đầy đủ hơn HLD tóm tắt. **Không dùng để suy ra cột mới**
   — HLD là nguồn quyết định cột nào có/không có trên bảng đã tách.
3. **`input/srs_report/*.docx`** — khi HLD ghi công thức PHÁI SINH nhưng
   không đủ chi tiết (điều kiện lọc, giá trị cụ thể), tra lại đúng báo cáo BCx
   được nhắc trong mô tả cột để lấy công thức nguyên văn.
4. **`input/DS_BANG_202608.xlsx`** (sheet `DS_bang`) — tra `KEY CDC` của bảng
   nguồn STG_LOS khi cần xác định khóa nghiệp vụ có phải hash hay không.
5. **`input/CLOS - Metadata.xlsx` / `input/RLOS - Metadata.xlsx`** (sheet "3.
   Column Review") — khi cần xác nhận 1 cột nguồn có thực sự tồn tại trên
   bảng STG_LOS hay không (đối chiếu DQ giống cách `design-hld` đã làm).

> ❌ Không đoán `source_table`/`source_column`. Mọi mapping phải truy ngược
> được tới đúng mũi tên trong sơ đồ mermaid Section 1, hoặc đúng dòng trong
> bảng cột Section 2, hoặc đúng dòng SRS field-list — không suy diễn từ tên
> cột.

---

## Output — naming & thư mục

```
lld/SB_DWH/SB_DWH_<TABLE_NAME>.csv
lld/STG_DTM/STG_DTM_<STG_TABLE_NAME>.csv
lld/PDTD_DTM/PDTD_DTM_<TABLE_NAME>.csv
```

- Vẫn giữ subfolder theo tầng (`lld/{TẦNG}/`), **cộng thêm** tiền tố tầng lặp
  lại ngay trong tên file, nối bằng dấu `_`: `{TẦNG}_{TÊN_BẢNG}.csv`. VD
  `DIM_CLOS_WORKSTEP` ở tầng SB_DWH → `lld/SB_DWH/SB_DWH_DIM_CLOS_WORKSTEP.csv`.
- `<TABLE_NAME>` = tên bảng vật lý đúng như HLD ghi (`DIM_CLOS_APPLICATION`,
  `FCT_RLOS_LOAN_DISBURSEMENT`, `REF_LOS_KPI_USER_YEAR`...) — không đặt lại,
  không thêm tiền tố module khác ngoài tiền tố tầng ở trên.
- **Tầng STG_DTM dùng tên bảng đã có prefix `STG_`** (VD `STG_DIM_CLOS_WORKSTEP`,
  `STG_FCT_LOAN`) — tên file là `lld/STG_DTM/STG_DTM_STG_DIM_CLOS_WORKSTEP.csv`
  (tiền tố tầng `STG_DTM_` + tên bảng vật lý `STG_DIM_CLOS_WORKSTEP`, tên bảng
  đã tự mang `STG_` sẵn nên không rút gọn/bỏ trùng).
- **1 file = 1 job ETL = 1 cặp (bảng, tầng đích).** Một bảng LOS đầy đủ vòng
  đời đi qua **3 tầng đích** — SB_DWH, STG_DTM, PDTD_DTM — sinh ra **3 file
  khác nhau**, ví dụ với `DIM_CLOS_WORKSTEP`:
  - `lld/SB_DWH/SB_DWH_DIM_CLOS_WORKSTEP.csv` (job STG_LOS→SB_DWH)
  - `lld/STG_DTM/STG_DTM_STG_DIM_CLOS_WORKSTEP.csv` (job SB_DWH→STG_DTM, cắt
    lát theo ngày, xem mục "Tầng STG_DTM — cắt lát theo ngày" bên dưới)
  - `lld/PDTD_DTM/PDTD_DTM_DIM_CLOS_WORKSTEP.csv` (job STG_DTM→PDTD_DTM, xem
    mục "Tầng PDTD_DTM luôn qua STG_DTM" bên dưới)
- **`MAP_*` và `REF_*` không có file LLD riêng của chính nó** — đây là bảng
  nguồn (driving table hoặc bảng join_atomic), không phải target table của
  skill này. `MAP_*` xuất hiện trong `source_table`/`etl_logic` của file
  DIM mà nó cấp dữ liệu (VD `MAP_CLOS_WORKSTEP` xuất hiện trong
  `SB_DWH_DIM_CLOS_WORKSTEP.csv`); `REF_*` xuất hiện trong `source_table`/
  `etl_logic` của cột `join_atomic` join tới nó. Không tạo
  `lld/SB_DWH/SB_DWH_MAP_CLOS_WORKSTEP.csv` hay
  `lld/PDTD_DTM/PDTD_DTM_CLOS_REF_SLA_TDKHDNL.csv`.

---

## Tầng STG_DTM — cắt lát theo ngày

**STG_DTM là 1 job LLD riêng** (không còn coi là bảng nguồn trung gian ẩn
như trước) — mỗi bảng SB_DWH đã "sẵn sàng" trong Plan đều có thêm 1 job
SB_DWH→STG_DTM, sinh `lld/STG_DTM/STG_DTM_STG_<TÊN_BẢNG_SB_DWH>.csv`.
Driving table (và source duy nhất) của job này luôn là chính bảng SB_DWH
gốc — không cần đọc thêm sơ đồ mermaid nào khác ngoài sơ đồ đã dùng cho job
SB_DWH. Tên bảng đích luôn nối thêm tiền tố `STG_` vào đúng tên bảng SB_DWH
(`DIM_CLOS_WORKSTEP` → `STG_DIM_CLOS_WORKSTEP`).

**Quy tắc lọc theo loại bảng** — điều kiện lọc là ràng buộc **cấp bảng**
(ảnh hưởng số dòng được chọn, áp dụng như nhau cho mọi cột), nên chỉ ghi
**đúng 1 lần ở dòng `key = PK`** (không lặp lại ở các cột khác):

| Loại bảng đích | Điều kiện cắt lát | Ghi ở dòng PK |
|---|---|---|
| Fact (`FCT_*`) | Chỉ lấy đúng 1 ngày = ngày ETL chạy (`etl_date`) | `etl_logic = <TÊN_BẢNG_SB_DWH>.<CỘT_PK> WHERE <cột ngày nghiệp vụ> = :ETL_DATE (hoặc tương đương DAYID/created ngày ETL)`; `note = "Cắt lát Fact: ..."` |
| Dimension (`DIM_*`) | Lấy toàn bộ bản ghi đang hiệu lực (`EXP_DATE IS NULL`) **cộng thêm** mọi bản ghi có `EXP_DATE` rơi trong 3 ngày quá khứ gần nhất tính từ `etl_date` (để vẫn còn nhìn thấy version vừa đóng gần đây) | `etl_logic = <TÊN_BẢNG_SB_DWH>.<CỘT_PK> WHERE <TÊN_BẢNG_SB_DWH>.EXP_DATE IS NULL OR <TÊN_BẢNG_SB_DWH>.EXP_DATE >= :ETL_DATE - 3`; `note = "Cắt lát Dim: ..."` |

Mỗi cột `direct` từ SB_DWH sang STG_DTM giữ nguyên `etl_logic =
<TÊN_BẢNG_SB_DWH>.<CỘT>` (copy nguyên giá trị, không biến đổi) —
`etl_logic_type = direct` cho toàn bộ cột trừ khi HLD nói khác. Không tự
thêm cột kỹ thuật ngoài các cột đã có trên bảng SB_DWH gốc.

**Điều kiện lọc (WHERE) chỉ ghi 1 lần ở dòng `key = PK`** — đây là ràng
buộc cấp bảng (ảnh hưởng số dòng được chọn), áp dụng như nhau cho mọi cột,
nên không lặp lại ở `etl_logic` của từng cột còn lại (các cột đó giữ
nguyên dạng sạch `<TÊN_BẢNG_SB_DWH>.<CỘT>`, không kèm `WHERE`). Dòng PK ghi
`etl_logic = <TÊN_BẢNG_SB_DWH>.<CỘT_PK> WHERE <điều kiện lọc theo bảng
"Quy tắc lọc theo loại bảng">`, và `note` diễn giải lại ngắn gọn bằng lời +
câu "Điều kiện lọc này áp dụng chung cho toàn bộ bảng".

---

## Tầng PDTD_DTM luôn qua STG_DTM — không join thẳng SB_DWH

**HLD viết tắt lineage SB_DWH → PDTD_DTM, nhưng thực tế luôn đi qua STG_DTM
(1 lát cắt theo ngày của SB_DWH, xem mục trên).** Khi sinh file
`lld/PDTD_DTM/PDTD_DTM_<TABLE>.csv`:

- **Trường hợp bảng SB_DWH bê 1:1 lên PDTD_DTM** (đa số DIM/FCT LOS, VD
  `DIM_CLOS_WORKSTEP`, `FCT_CLOS_APPLICATION_DAILY`): `source_table` không
  ghi tên bảng SB_DWH trực tiếp — ghi **`STG_<TÊN_BẢNG_SB_DWH>`**, là bảng
  ở tầng STG_DTM chứa lát cắt 1 ngày của bảng SB_DWH đó (VD driving table
  của `PDTD_DTM_DIM_CLOS_WORKSTEP.csv` là `STG_DIM_CLOS_WORKSTEP`, không
  phải `DIM_CLOS_WORKSTEP`).
- **Trường hợp bảng T24** (`DIM_T24_*`, `FCT_*_LOAN_DISBURSEMENT`): vốn HLD
  đã ghi rõ nguồn là vùng chìa `STG_DTM.STG_DIM_*`/`STG_FCT_LOAN` — giữ
  nguyên, không đổi gì thêm (đây là trường hợp bảng T24 luôn qua STG_DTM,
  không phải "bê 1:1 từ SB_DWH" theo nghĩa LOS).
- **Trường hợp join sang bảng khác cũng ở PDTD_DTM tầng ngang** (VD
  `FCT_CLOS_LOAN_DISBURSEMENT` self-join `STG_FCT_LOAN` để lấy
  `NO_DAYS_OVERDUE`, hoặc join `STG_DIM_COMPANY` để lấy `COMPANY_SK`, rồi từ
  `STG_DIM_COMPANY` join tiếp `TMP_REF_COMPANY_REGION_*` để lấy `ZONE`): mọi
  bảng trong chuỗi JOIN này đều là bảng **STG_DTM** (`STG_DIM_COMPANY`,
  `STG_FCT_LOAN`), không phải bảng SB_DWH gốc — ghi đúng tên `STG_*` trong
  `source_table`/`etl_logic`, kể cả các hop trung gian của multi-hop JOIN.
  `TMP_REF_COMPANY_REGION_KHCN`/`_KHDN` là bảng REF_ tĩnh, giữ nguyên tên
  (không có prefix `STG_` vì đây không phải bản sao của bảng SB_DWH nào).

Ghi rõ trong `note` của cột đầu tiên mỗi bảng T24/self-join phức tạp:
`"Nguồn qua vùng chìa STG_DTM, không qua CDC LOS trực tiếp"` khi cần làm rõ.

---

## Xác định Driving Table

**Căn cứ duy nhất: sơ đồ mermaid ở Section 1 của HLD.** Driving table là
bảng nguồn quyết định grain của bảng đích, xác định bằng cách đọc đúng sơ đồ
`flowchart` mermaid của bảng đó — không suy từ mô tả grain bằng văn xuôi,
không suy từ thứ tự liệt kê trong "Nguồn". Nếu sơ đồ có nhiều bảng nguồn,
driving table là bảng mà nhãn mũi tên ghi rõ nhất quan hệ cấp business
key/PK chính (thường là mũi tên đầu tiên, nhãn `1:1 + NK` hoặc tương đương
— đọc đúng nhãn, không đoán theo thứ tự vẽ).

| Tầng đích | Driving table (đọc từ mermaid Section 1) |
|---|---|
| SB_DWH (từ STG_LOS) | Bảng STG_LOS trong sơ đồ có nhãn cấp business key/NK chính của bảng đích |
| SB_DWH, driving table là `MAP_*` | Chính bảng `MAP_*` trong sơ đồ — chỉ cần tên cột `MAP_*` dùng trong `etl_logic` của DIM đích (business key, `EFF_DATE`...), không cần đọc/thể hiện toàn bộ cấu trúc cột của `MAP_*`. Không tạo file LLD riêng cho `MAP_*` (xem mục Output) |
| STG_DTM (từ SB_DWH) | Chính bảng SB_DWH gốc cùng tên (bỏ tiền tố `STG_`) — không cần đọc lại mermaid riêng, dùng đúng sơ đồ đã dùng cho job SB_DWH của bảng đó (xem mục "Tầng STG_DTM — cắt lát theo ngày") |
| PDTD_DTM, bảng "bê 1:1" | `STG_<TÊN_BẢNG_SB_DWH>` (xem mục "Tầng PDTD_DTM luôn qua STG_DTM") |
| PDTD_DTM, bảng T24 (`DIM_T24_*`, `FCT_*_LOAN_DISBURSEMENT`) | Bảng vùng chìa `STG_DTM.STG_DIM_*`/`STG_FCT_LOAN` theo đúng sơ đồ mermaid |
| PDTD_DTM, `REF_*` tĩnh (2.4.x) | Không có driving table — nguồn là file Excel/CSV BA cung cấp, nạp thủ công. Ghi `note = "Nạp thủ công từ file BA, không qua ETL tự động"` cho mọi cột |

Ghi rõ Driving Table trong `description` của dòng `key = PK` theo dạng
ngắn gọn `"PK — Driving: <table>"` (không kèm giải thích SCD/grain dài
dòng — xem mục quy tắc `description`).

---

## `data_type`

Suy trực tiếp từ cột **Kiểu dữ liệu** đã ghi trong HLD/extract, giữ nguyên
độ lớn khi HLD có ghi rõ — không tự bịa kiểu hay độ lớn khác:

| Kiểu dữ liệu HLD | `data_type` |
|---|---|
| `NUMBER` | `number` |
| `VARCHAR2(n)` | `string(n)` |
| `DATE` | `date` |
| `TIMESTAMP` | `timestamp` |

---

## Cột `key` — chỉ 1 giá trị PK (không có FK)

> **Quy ước:** `key` chỉ đánh dấu **PK** (cột/nhóm cột làm khóa chính) —
> không có giá trị FK nào cả. Vai trò khóa ngoại (cột `_SK` tra sang 1 DIM
> khác trên Fact) thể hiện qua `etl_logic_type = join` và mô tả trong
> `description`, không đánh dấu riêng trong `key`.

| Giá trị | Ý nghĩa | Dùng trên |
|---|---|---|
| `PK` | Khóa chính — trên Dimension chỉ đúng 1 dòng, cột `DIMENSION_KEY`; trên Fact là **mọi** cột thuộc tổ hợp khóa composite | Dimension (chỉ `DIMENSION_KEY`), Fact, REF_/MAP_ (nếu HLD có khai PK kỹ thuật riêng) |
| *(trống)* | Mọi cột khác — cột `<ENTITY>_SK`, cột `_SK` tra sang DIM khác trên Fact, business key thật (VD `WORKSTEP_CODE`, `WI_NAME`), cột mô tả/đo lường, `EFF_DATE`/`EXP_DATE` | Mọi loại |

**PK lấy từ đâu:** đọc đúng cột **`Khóa`** trong bảng cột chi tiết của
Section 2 (HLD) của mỗi bảng — HLD đã đánh dấu `PK` trực tiếp trên đúng
dòng/tổ hợp dòng làm khóa chính. Không tự suy PK từ tên cột.

**Ràng buộc:**
- Dimension: đúng 1 dòng `key = PK` — cột được HLD đánh `PK` (luôn là
  `DIMENSION_KEY`). Cột `<ENTITY>_SK` để `key` trống,
  `etl_logic_type = generated`. Business key thật (VD `WORKSTEP_CODE`) để
  `key` trống — nêu rõ vai trò join-anchor trong `description`.
- Fact: PK **composite** — mọi cột HLD đánh `PK` trên Section 2 đều
  `key = PK` (VD `DAYID` + `WI_NAME`). Cột `_SK` tra sang DIM khác (VD
  `PRODUCT_SK`) để `key` trống dù đóng vai trò khóa ngoại — vai trò đó nêu
  rõ trong `description` (VD `"Khóa ngoại — tra DIM_CLOS_PRODUCT"`), trừ
  khi chính cột đó cũng được HLD đánh `PK` (thuộc tổ hợp khóa) thì ghi `PK`.
- `REF_*` tĩnh (2.4.x) và `MAP_*`: nếu HLD không khai `DIMENSION_KEY`/PK kỹ
  thuật riêng cho bảng đó thì không có dòng `PK` nào — khóa thật là tổ hợp
  UNIQUE đã khai trong HLD, `key` để trống, ghi rõ trong `note`.

❌ `nullable = true` cho bất kỳ dòng `key = PK`.
❌ Đánh `PK` cho business key thật trên Dimension (chỉ `DIMENSION_KEY` mới
là `PK` ở Dimension).
❌ Tự suy PK từ tên cột thay vì đọc đúng cột `Khóa` ở Section 2 HLD.

---

## `etl_logic_type` — 6 giá trị

| `etl_logic_type` | Khi dùng | `etl_logic` format |
|---|---|---|
| `direct` | Map thẳng 1 cột nguồn có sẵn trên **driving table**, không biến đổi | `source_table.source_column` |
| `computed` | Cần tính toán trên chính driving table (CASE WHEN, arithmetic, TRUNC, hàm string, hash bằng `STANDARD_HASH`...) — mọi input đều từ driving table | `CASE WHEN driving.col = 'X' THEN ... END` |
| `join` | Cần JOIN sang 1 bảng khác driving table để lấy thêm thông tin (kể cả LEFT JOIN, EXISTS, self-join, UNION nhiều bảng, join sang `REF_*`) | `JOIN other_table ON other_table.key = driving.key → other_table.target_col` |
| `pending` | Chưa xác định được nguồn/công thức (HLD còn đánh dấu PENDING hoặc "⚠️ cần xác nhận BA") | *(để trống)*, `note` ghi rõ lý do PENDING lấy nguyên văn từ HLD Section 3 |
| `generated` | Cột tự sinh, không map trực tiếp 1 nguồn cụ thể — dùng cho **mọi** cột `DIMENSION_KEY` (sequence) và **mọi** cột `_SK` (kể cả `<ENTITY>_SK` bằng đúng `DIMENSION_KEY` cùng dòng, và cột khóa nghiệp vụ hash như `COLLATERAL_BK` trên Fact khi nguồn không khai CDC key) | *(để trống)*, ghi rõ cách sinh trong `description`/`note` |
| `scd2` | Cột `EFF_DATE`/`EXP_DATE` trên Dimension | `EFF_DATE`: `source_table.EFF_DATE` (hoặc `:P_DATE` tùy nguồn); `EXP_DATE`: luôn literal `NULL` (xem mục riêng bên dưới) |

**Quy tắc bắt buộc `table.column` prefix:** mọi tham chiếu cột trong
`etl_logic` phải có tiền tố `<table>.` — trừ literal value, hàm SQL
(`TRUNC(...)`, `COUNT(...)`), `NULL`, tham số runtime ETL (`:P_DATE`).

**Quy tắc thứ tự JOIN trong `etl_logic` (khi `etl_logic_type = join`):**
JOIN clause viết trước, dấu `→`, cột giá trị cuối cùng sau `→`:
```
✅ JOIN DIM_CLOS_WORKSTEP ON DIM_CLOS_WORKSTEP.WORKSTEP_CODE = driving.WORKSTEP_CODE
   AND :P_DATE BETWEEN DIM_CLOS_WORKSTEP.EFF_DATE AND NVL(DIM_CLOS_WORKSTEP.EXP_DATE, :P_DATE)
   → DIM_CLOS_WORKSTEP.WORKSTEP_SK
❌ DIM_CLOS_WORKSTEP.WORKSTEP_SK JOIN DIM_CLOS_WORKSTEP ON ...  (đọc ngược)
```

**Multi-hop JOIN (2 tầng trở lên):** nối các JOIN clause liên tiếp bằng
dấu `→` trước hop kế tiếp, chỉ hop cuối cùng dẫn ra cột giá trị:
```
JOIN STG_DIM_COMPANY ON STG_DIM_COMPANY.COMPANY_CODE = driving.CO_CODE
  AND STG_DIM_COMPANY.COMPANY_EXP_DATE IS NULL
→ LEFT JOIN TMP_REF_COMPANY_REGION_KHDN ON TMP_REF_COMPANY_REGION_KHDN.COMPANY_CODE = driving.CO_CODE
→ TMP_REF_COMPANY_REGION_KHDN.VUNG
```
`source_table`/`source_column` trong trường hợp multi-hop ghi bảng/cột của
**hop cuối cùng** (nơi giá trị thực sự lấy ra).

**Lookup sang DIM có hiệu lực theo thời gian (SCD2):** mọi `join` sang 1
`DIM_*` để lấy `_SK` đều phải có điều kiện thời gian
`:P_DATE BETWEEN EFF_DATE AND NVL(EXP_DATE, :P_DATE)` trong JOIN — không chỉ
so khớp business key trần, trừ khi HLD nói rõ đây là lookup "current state
only" (VD `STG_DIM_COMPANY` lookup `COMPANY_EXP_DATE IS NULL`).

---

## `EXP_DATE` — `etl_logic` luôn là literal `NULL`

Trên mọi Dimension, cột `EXP_DATE` (SCD2, hết hiệu lực) có `etl_logic =
NULL` (giá trị mặc định khi INSERT dòng mới — bản ghi hiện hành), không để
trống. `etl_logic_type = scd2`. Chi tiết "khi nào bị đóng, gán = seed_date
- 1 giây" ghi trong `note`, không đưa vào `etl_logic` (đó là logic UPDATE
khi đóng bản cũ, không phải giá trị khởi tạo khi INSERT).

---

## Quy tắc `description`

`description` chỉ mô tả **ý nghĩa nghiệp vụ** của cột — không nhồi công
thức ETL chi tiết (công thức đã có ở `etl_logic`), không nhồi KPI ID, không
nhồi tên báo cáo BCx dài dòng (ghi 1-2 mã BC ngắn nếu cần định vị, chi tiết
để trong `note`).

- Dòng `key = PK`: cho phép cụm ngắn `"PK — Driving: <table>"`.
- Cột `_SK` đóng vai trò khóa ngoại trên Fact: nêu rõ `"Khóa ngoại — tra
  <DIM_đích>"`.
- Mọi cảnh báo PENDING/lệch tài liệu/"cần BA xác nhận" copy từ HLD → đặt
  trong cột `note`, **không** trong `description`.

---

## Xử lý bảng nguồn không khai CDC key (hash khóa nghiệp vụ)

Trước khi thiết kế cột khóa nghiệp vụ cho bất kỳ bảng nào sourced trực
tiếp từ 1 bảng STG_LOS, kiểm tra `input/DS_BANG_202608.xlsx` (sheet
`DS_bang`, cột `KEY CDC`):

- **Có khai CDC key** → khóa nghiệp vụ = đúng tổ hợp cột đó,
  `etl_logic_type = direct` (hoặc `join` nếu gồm cột từ >1 bảng).
- **Không khai CDC key** (rỗng) → bảng này KHÔNG đủ điều kiện làm Dimension
  SCD2 thật (xem `design-hld` — "No CDC key → can't be a DIM" rule); nếu HLD
  đã thiết kế bảng đích dạng FCT snapshot với `<ENTITY>_BK = STANDARD_HASH(...)`
  thì dùng `etl_logic_type = generated`, ghi công thức hash đầy đủ trong
  `description`/`note` (liệt kê đúng danh sách cột HLD đã ghi, loại trừ cột
  CLOB).

---

## Cột nối chuỗi nhiều dòng nguồn (concat) — vẫn là 1 dòng CSV

Khi HLD thiết kế 1 cột đích bằng cách **nối chuỗi (concat)** nhiều dòng
nguồn thành 1 giá trị (VD `ADD_ID`/`ADD_ID_OTHER` trên `DIM_RLOS_APPLICANT`
— nối `ID_NUMBER` của nhiều dòng `NG_SB_RLOS_APPLICANT_IDGRID` cùng nhóm
`ID_TYPE` bằng dấu `;`) — đây **vẫn là 1 dòng CSV duy nhất**, không tách
thành nhiều dòng. Dùng `etl_logic_type = computed` (hoặc `join` nếu bảng
nguồn khác driving table), viết công thức LISTAGG/nối chuỗi đầy đủ trong
`etl_logic`, ghi rõ điều kiện lọc nhóm trong `description`. Không có
trường hợp pivot tách 1 attribute HLD thành nhiều dòng CSV trong dự án này.

---

## Bảng đặc thù khác

| Loại bảng | Đặc điểm | Cách xử lý trong CSV |
|---|---|---|
| `REF_LOS_KPI_USER_YEAR` | REF_ nhưng vẫn có ETL tự động (INSERT-if-not-exists) — khác 9 bảng REF_ tĩnh | Sinh file `lld/PDTD_DTM/PDTD_DTM_REF_LOS_KPI_USER_YEAR.csv` bình thường, driving table = UNION `STG_FCT_CLOS_WORKSTEP_EVENT`/`STG_FCT_RLOS_WORKSTEP_EVENT`, `etl_logic_type = join` cho cột `FIRST_ELIGIBLE_TS` |
| `DIM_DATE` | Bê 1:1 từ `SB_DWH.DIM_DATE` qua `STG_DTM.STG_DIM_DATE`, không tự dựng lịch | 1 file duy nhất `lld/PDTD_DTM/PDTD_DTM_DIM_DATE.csv`, mọi cột `etl_logic_type = direct`, `note = "Bê 1:1 toàn bộ khi lịch thay đổi — không phải nạp incremental theo DAYID"` |

---

## Ví dụ minh họa 1 dòng mỗi etl_logic_type

```csv
"target_table","target_column","nullable","data_type","key","description","etl_logic","etl_logic_type","source_table","source_column","note"
"DIM_CLOS_WORKSTEP","DIMENSION_KEY","false","number","PK","PK — Driving: MAP_CLOS_WORKSTEP","","generated","","",""
"DIM_CLOS_WORKSTEP","WORKSTEP_SK","false","number","","Bằng đúng DIMENSION_KEY cùng dòng — dùng để Fact lookup vào DIM này","= DIMENSION_KEY (cùng dòng)","generated","","",""
"DIM_CLOS_WORKSTEP","WORKSTEP_CODE","false","string(200)","","Business key — mã bước xử lý trên workflow CLOS, dùng làm join-anchor. UNIQUE (WORKSTEP_CODE, EFF_DATE)","MAP_CLOS_WORKSTEP.WORKSTEP_CODE","direct","MAP_CLOS_WORKSTEP","WORKSTEP_CODE",""
"DIM_CLOS_WORKSTEP","EFF_DATE","false","date","","Ngày bắt đầu hiệu lực của phiên bản bản ghi (SCD Type 2)","MAP_CLOS_WORKSTEP.EFF_DATE","scd2","MAP_CLOS_WORKSTEP","EFF_DATE","Bằng đúng EFF_DATE khai báo tay trên MAP_CLOS_WORKSTEP — người sửa nhập trực tiếp ngày hiệu lực thực tế, không phải ngày ETL chạy (:P_DATE)"
"DIM_CLOS_WORKSTEP","EXP_DATE","true","date","","Ngày hết hiệu lực của phiên bản bản ghi; NULL = bản ghi hiện hành","NULL","scd2","","","Đóng bằng EFF_DATE(seed mới) - 1 giây khi phát hiện thay đổi/khóa mới ở MAP_CLOS_WORKSTEP — đây là logic UPDATE khi đóng bản cũ, không phải giá trị khởi tạo khi INSERT"
"DIM_CLOS_APPLICATION","APP_GRP","true","string(50)","","Cấp thẩm quyền phê duyệt hồ sơ (A1-C3, BOD, CC...)","NG_SB_CLOS_APPROVAL.APP_GRP","direct","NG_SB_CLOS_APPROVAL","APP_GRP",""
"DIM_CLOS_APPLICATION","CREATION_DATE","true","date","","Ngày khởi tạo hồ sơ","TRUNC(MIN(NG_SB_CLOS_ENTRY_EXIT.ENTRYDATE)) theo WI_NAME","computed","NG_SB_CLOS_ENTRY_EXIT","ENTRYDATE",""
"FCT_CLOS_APPLICATION_DAILY","PRODUCT_SK","false","number","","Khóa ngoại — tra DIM_CLOS_PRODUCT","JOIN DIM_CLOS_PRODUCT ON DIM_CLOS_PRODUCT.PRODUCT_LINE_CODE = driving.PRODUCT_LINE_CODE AND :P_DATE BETWEEN DIM_CLOS_PRODUCT.EFF_DATE AND NVL(DIM_CLOS_PRODUCT.EXP_DATE,:P_DATE) → DIM_CLOS_PRODUCT.PRODUCT_SK","join","DIM_CLOS_PRODUCT","PRODUCT_SK",""
"FCT_CLOS_COLLATERAL","COLLATERAL_BK","false","string","PK","Khóa nghiệp vụ của dòng tài sản, hash toàn bộ cột vì nguồn không khai CDC key","STANDARD_HASH(NG_SB_CLOS_COLL_CD.COLLTYPE || ... , 'SHA256')","generated","NG_SB_CLOS_COLL_CD","(toàn bộ cột không phải CLOB)","Nguồn NG_SB_CLOS_COLL_CD không khai KEY CDC trong DS_BANG_202608.xlsx (LOẠI 2)"
"DIM_CLOS_APPLICATION","CREDIT_PROFILE","true","string(50)","","Cấp tín dụng của hồ sơ (TVTD/CTD)","","pending","NG_SB_CLOS_EXTTABLE","CREDIT_PROFILE","DQ-11 — SRS BC2 chỉ đích danh cột này nhưng metadata Column Review không liệt kê; nếu HLD đã ĐÃ GIẢI QUYẾT thì không dùng pending nữa, đây chỉ là ví dụ minh họa format"
```
