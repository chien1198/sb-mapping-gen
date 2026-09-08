# FCT_PDTD_KPI_USER_YEAR

Nguồn: docx "Design_Database_PDTD_DTM_v1.0_20260908.docx"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | DATE | Y |  | PK | Ngày dữ liệu, dạng số YYYYMMDD |
| 2 | KPI_YEAR | NUMBER | Y | 4 | PK | Năm KPI, tập nhân sự được tính lại từ đầu mỗi năm |
| 3 | USERNAME | VARCHAR2 | Y | 100 | PK | Tên tài khoản của cán bộ xử lý hồ sơ |
| 4 | USER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_USER. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 5 | FIRST_ELIGIBLE_TS | TIMESTAMP | Y |  |  | Nhân sự Khối PDTD |
