# Quyết định đã chốt — BC9 (Báo cáo KPI)

File câu lệnh: `mapping/BAOCAO/BC9_RLOS.sql`, `BC9_CLOS.sql`, `BC9_KPI_KHOI.sql`

## Quyết định của người dùng

| Điểm | Quyết định | Ngày | Ghi chú |
|---|---|---|---|
| Cấu trúc | 3 câu lệnh riêng (RLOS 1 dòng/hồ sơ, CLOS 1 dòng/hồ sơ, KPI Khối 1 dòng/năm) | 2026-11-13 | Bộ cột 3 phần khác nhau |
| Loại tài khoản test | Chỉ lọc ở phần KPI Khối (đã nằm trong bảng tổng hợp); phần RLOS/CLOS không loại | 2026-11-13 | SRS phần hồ sơ không ghi loại trừ |
| Lọc chi nhánh | Phần KPI Khối không lọc chi nhánh (bảng tổng hợp không có chiều chi nhánh); phần hồ sơ lọc qua `COMPANY_SK` | 2026-11-13 | |

## Giả định kỹ thuật

- Phần hồ sơ: `AGG_LOS_KPI_APPLICATION` có `DAYID` = ngày báo cáo, `PROCESSED_DATE` trong ngày, `APPLICATION_STATUS` thuộc `Approved`/`Rejected`/`Cancelled` (tương đương `INNER JOIN` quyết định phê duyệt/hủy của SRS).
- Cột `VOLUME`, `POINT`, `QUY_DOI`, `TSBD_G2`, `INCOM_3`, `BUSINESS_INCOM`, `DEVIATION_G2/G3` đọc nguyên văn từ bảng tổng hợp (LLD đã tính).
- KPI Khối: đọc cột `_YTD` của `AGG_LOS_KPI_YTD_DAILY`; ngày dữ liệu = T-1 (năm hiện tại) hoặc 31/12 (năm quá khứ).
- `TAT_RLOS` = (TAT trung bình UNSEC + TAT trung bình SEC)/2 theo SRS; chia `NULLIF` để tránh chia 0.
- Hạn chế: không có hồ sơ nào ở T-1 thuộc năm trước khi `:p_year` là năm hiện tại và chạy vào ngày 1/1 (ngày dữ liệu rơi vào năm trước).
