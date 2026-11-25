# Quyết định đã chốt — BC9 (Báo cáo KPI)

File câu lệnh: `mapping/BAOCAO/BC9_RLOS.sql`, `BC9_CLOS.sql`, `BC9_KPI_KHOI.sql`

## Quyết định của người dùng

| Điểm | Quyết định | Ngày | Ghi chú |
|---|---|---|---|
| Cấu trúc | 3 câu lệnh riêng (RLOS 1 dòng/hồ sơ, CLOS 1 dòng/hồ sơ, KPI Khối 1 dòng tại `:p_date_to`) | 2026-11-13 | Bộ cột 3 phần khác nhau |
| Tham số ngày | Khoảng ngày `:p_date_from`/`:p_date_to` cho RLOS/CLOS; KPI Khối chỉ `:p_date_to` (thay `:p_year`), đọc `AGG_LOS_KPI_YTD_DAILY` tại `DAYID = d_to` | 2026-11-20 | Người dùng chốt chuyển KPI Khối sang `DAYID`; bảng cộng dồn năm nên không có `p_date_from` |
| Loại tài khoản test | Chỉ lọc ở phần KPI Khối (đã nằm trong bảng tổng hợp); phần RLOS/CLOS không loại | 2026-11-13 | SRS phần hồ sơ không ghi loại trừ |
| Lọc chi nhánh | Phần KPI Khối không lọc chi nhánh (bảng tổng hợp không có chiều chi nhánh); phần hồ sơ lọc qua `COMPANY_SK` | 2026-11-13 | |
| SLHS đếm cả Rejected | `SLHS_RLOS/CLOS` (và `_WTD/_MTD/_QTD/_YTD`) đếm hồ sơ Approved **và** Rejected, mỗi hồ sơ 1 lần/năm; điều kiện `HAS_FINAL_APPROVAL_FLAG = 'Y'` thay cho `APPLICATION_STATUS = 'Approved'` | 2026-11-25 | Theo BA (BC9: SLHS cộng vào năm khi hồ sơ Approved/Rejected, PD lần 2 sang năm sau tính thêm vào năm sau). SLGN giữ `Approved` nên `TY_LE_GN = SLGN/SLHS` thấp hơn. TAT chỉ lần PD đầu (đã đúng từ 2026-11-23). Chỉ đổi LLD `AGG_LOS_KPI_YTD_DAILY`, init, HLD, mapping; SQL BC9 không đổi. |

## Giả định kỹ thuật

- Phần hồ sơ: `AGG_LOS_KPI_APPLICATION` có `DAYID = d_to`, `PROCESSED_DATE` trong `[d_from, d_to]`, `APPLICATION_STATUS` thuộc `Approved`/`Rejected`/`Cancelled` (tương đương `INNER JOIN` quyết định phê duyệt/hủy của SRS).
- Cột `VOLUME`, `POINT`, `QUY_DOI`, `TSBD_G2`, `INCOM_3`, `BUSINESS_INCOM`, `DEVIATION_G2/G3` đọc nguyên văn từ bảng tổng hợp (LLD đã tính).
- KPI Khối: đọc cột `_YTD` của `AGG_LOS_KPI_YTD_DAILY` tại `DAYID = :p_date_to` (mặc định T-1); nhãn `YEAR_MONTH` lấy từ `:p_date_to`.
- `TAT_RLOS` = (TAT trung bình UNSEC + TAT trung bình SEC)/2 theo SRS; chia `NULLIF` để tránh chia 0.
- Đã bỏ hạn chế cũ về `:p_year` (chạy ngày 1/1 với T-1 thuộc năm trước) vì không còn tham số năm; `:p_date_to` ở năm nào thì đọc cộng dồn của năm đó.
