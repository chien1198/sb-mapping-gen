# Quy tắc cố định khi gen câu lệnh báo cáo

## 1. Nguồn dữ liệu

- Chỉ đọc từ **PDTD_DTM** (`PDTD_DTM.FCT_*`, `PDTD_DTM.DIM_*`, `PDTD_DTM.REF_*`). Cột phải tồn tại trong
  `lld/pdtd_dtm/PDTD_DTM_<BẢNG>.csv` (cột `target_column`).
- **Không bao giờ tham chiếu `STG_*`** (STG_DTM là vùng đệm cắt lát theo ngày dữ liệu → thiếu dữ liệu DIM).
  Khi SRS ghi bảng `STG_DIM_X`, thay bằng bảng PDTD_DTM tương ứng:

| SRS ghi | Dùng trong câu lệnh | Cách nối |
|---|---|---|
| `STG_DIM_CUSTOMER` | `PDTD_DTM.DIM_T24_CUSTOMER` | `DIMENSION_KEY = FCT_?LOS_CUSTOMER.T24_CUSTOMER_SK` |
| `STG_DIM_CARD` | `PDTD_DTM.DIM_T24_CARD` | `DIMENSION_KEY = FCT_?LOS_APPLICATION.T24_CARD_SK` |
| `STG_DIM_SEAB_MAIN_CARD` | `PDTD_DTM.DIM_T24_SEAB_MAIN_CARD` | `DIMENSION_KEY = FCT_?LOS_APPLICATION.T24_SEAB_MAIN_CARD_SK` |

  Quy tắc chung: `STG_DIM_X` → `DIM_T24_X`; kiểm tra tồn tại trong `lld/pdtd_dtm` và tìm cột khóa `*_SK` trên FCT.
- **Bảng có trong LLD chưa chắc có trong môi trường báo cáo** (ví dụ `DIM_DATE` không có). Khi một trường cần bảng như vậy
  (ngày/tuần/tháng), tính trực tiếp bằng hàm Oracle trong câu lệnh (ví dụ tuần Thứ 2–Chủ nhật:
  `TO_CHAR(TRUNC(d,'IW'),'YYYYMMDD') || '-' || TO_CHAR(TRUNC(d,'IW')+6,'YYYYMMDD')`), và hỏi người dùng nếu bảng LLD là nguồn duy nhất.
- Lookup DIM luôn qua khóa SK trên FCT: `LEFT JOIN PDTD_DTM.DIM_X d ON d.DIMENSION_KEY = a.X_SK`.
- Tên cột có dạng khác nhau giữa SRS và PDTD_DTM là bình thường (ví dụ SRS `EMPLOYEE_CODE` ↔ PDTD_DTM
  `CREATE_EMPLOYEE_CODE`). Dùng lineage (`output/lineage/lineage_chain.csv`) để xác định đúng cột, không đoán theo tên.

## 2. Bảng driving, snapshot và tham số

- Bảng driving là `FCT_RLOS_APPLICATION` / `FCT_CLOS_APPLICATION` (1 hồ sơ × 1 ngày dữ liệu, full snapshot theo `DAYID`).
- Tham số lấy từ SRS, mục Business Rules BR x.1 (ví dụ BC1: Ngày báo cáo = `PROCESSED_DATE`, mặc định T-1;
  Chi nhánh tùy chọn, NULL = tất cả). Dùng bind variable (`:p_report_date`, `:p_branch_code`) — **không** dùng `v_batch_date`,
  đó là biến của ETL.
- Mẫu lọc BC1 (cùng mẫu BC9): `DAYID = rpt_date` **và** `PROCESSED_DATE >= rpt_date AND < rpt_date + 1`.
  Báo cáo khác: đọc SRS và LLD của driving table để xác định điều kiện thật.
- Join các bảng con (`FCT_*_CUSTOMER`, `*_COREPAYER`, `*_COLLATERAL`, ...) với driving theo **`DAYID` và `WI_NAME`**.

## 3. Cột đầu ra

- Alias cột = **tên trường SRS** (đúng chính tả, đúng thứ tự trong bảng "Danh sách trường & logic lấy dữ liệu").
- Số cột = số trường SRS, không thêm, không bớt.
- Logic phái sinh (CASE, ghép chuỗi, gộp cờ) viết đúng công thức SRS trên cột thô trong PDTD_DTM.
  Trường SRS đã mô tả công thức thì **không** tự đổi.

## 4. Grain (nhiều dòng / hồ sơ)

- Mỗi báo cáo có các nhóm 1–N (giấy tờ, đồng trả nợ, tài sản bảo đảm, sản phẩm phụ...). **Không tự quyết grain.**
  Xem `decisions/BCn.md`; chưa ghi thì hỏi người dùng (nêu lựa chọn + đề xuất).
- Lựa chọn thường gặp cho 1 nhóm 1–N:
  - **Nhiều dòng**: `LEFT JOIN` trực tiếp bảng con (hồ sơ không có dòng con vẫn ra 1 dòng). Giữ kiểu dữ liệu gốc.
  - **Gộp 1 dòng/hồ sơ**: CTE `GROUP BY WI_NAME` với `LISTAGG(..., ';')`.
- Khi nhiều nhóm cùng nhiều dòng, số dòng/hồ sơ **nhân tích** (ví dụ 2 người đồng trả nợ × 3 SP phụ = 6 dòng).
  Nêu rõ điều này khi hỏi grain.
- Applicant (người vay chính) trong `FCT_*_CUSTOMER` có grain 1 dòng/giấy tờ. Muốn 1 dòng đại diện/hồ sơ, dùng
  `ROW_NUMBER() OVER (PARTITION BY WI_NAME ORDER BY CASE WHEN ID_TYPE IN ('TCC','CC') THEN 0 ELSE 1 END, ID_TYPE)`
  — chỉ khi `decisions/BCn.md` cho phép.

## 5. `LISTAGG`

- Phân cách `';'`. Dùng `DISTINCT` khi SRS/quyết định yêu cầu loại trùng.
- Thêm `ON OVERFLOW TRUNCATE '...' WITH COUNT` cho mọi `LISTAGG` giữ lại (chống ORA-01489 khi vượt 4000 ký tự).

## 6. Phong cách file SQL

- Oracle 19c. Đầu file có khối comment: tên báo cáo, nguồn thiết kế, tham số, grain, ghi chú snapshot.
- Comment trong SQL viết **không dấu** (ASCII) cho khớp các file `mapping/BAOCAO/*.sql`; literal chuỗi giữ nguyên
  tiếng Việt có dấu đúng như SRS (ví dụ `'Lương / '`).
- CTE đặt tên ngắn có nghĩa (`app`, `cust_rep`, `corep`, `col`); mỗi CTE có 1 dòng comment mục đích.
- `ORDER BY` cuối cùng theo `WI_NAME` và khóa dòng con (nếu có nhiều dòng).

## 7. Báo cáo ghép nhiều nguồn (UNION ALL, ví dụ BC3: CLOS + RLOS)

- Mỗi mục SRS ("Nguồn CLOS", "Nguồn RLOS") là **một nhánh** `SELECT`; ghép bằng `UNION ALL`, thứ tự nhánh theo thứ tự mục SRS.
- Mỗi nhánh dùng alias riêng (alias có thể trùng giữa các nhánh). Tên cột đầu ra giống nhau ở mọi nhánh.
- Trường chỉ có ở một nhánh: nhánh còn lại để `CAST(NULL AS <kiểu>) AS <tên>` cho đủ cột (script coi là cột đệm, không phải lỗi).
- `UNION ALL` yêu cầu **cùng kiểu theo từng cột**; kiểm tra `data_type` ở `lld/pdtd_dtm` của hai nhánh. Khác kiểu thì ép về
  kiểu chuỗi rộng hơn (`TO_NCHAR(...)` cho nhánh số/`VARCHAR2` khi nhánh kia là `NVARCHAR2`), không ép chuỗi về số
  (giá trị gốc có thể không ép được). Ghi chú ép kiểu ở đầu file và trong `decisions/BCn.md`.
- `ORDER BY` cuối dùng tên cột của nhánh đầu (không dùng alias bảng).

## 8. Bảng sự kiện workstep (`FCT_*_WORKSTEP_EVENT`)

- Mỗi sự kiện có thể có nhiều phiên bản (mỗi `DAYID` 1 dòng; mở ngày 1, đóng ngày 2 = 2 dòng). Khi đọc lịch sử qua nhiều
  `DAYID` chỉ lấy phiên bản mới nhất theo `WORKSTEP_EVENT_BK`:
  `AND NOT EXISTS (SELECT 1 FROM ... nv WHERE nv.WORKSTEP_EVENT_BK = e.WORKSTEP_EVENT_BK AND nv.DAYID > e.DAYID AND nv.DAYID <= :rpt_date)`
  và giới hạn `e.DAYID <= :rpt_date`.
- Lấy thông tin hồ sơ (số tiền, kỳ hạn, chi nhánh) từ snapshot `FCT_*_APPLICATION` tại `DAYID = ngày báo cáo`.

## 9. Không làm

- Không dùng HLD hoặc `lld/BCn.csv` làm căn cứ chọn cột.
- Không suy diễn công thức ngoài SRS; mơ hồ thì hỏi (xem Điểm dừng 1 trong SKILL.md).
- Không chỉnh LLD; phát hiện bất thường trong LLD thì không cảnh báo (LLD là nguồn đáng tin).
