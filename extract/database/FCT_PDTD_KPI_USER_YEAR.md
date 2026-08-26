# FCT_PDTD_KPI_USER_YEAR

Nguồn: docx section "4.4.13 Bảng FCT_PDTD_KPI_USER_YEAR"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | DATE | Y |  | PK | Ngày dữ liệu, dạng số YYYYMMDD |
| 2 | KPI_YEAR | NUMBER | Y | 4 | PK | Năm KPI, tập nhân sự được tính lại từ đầu mỗi năm |
| 3 | USERNAME | VARCHAR2 | Y | 100 | PK | Tên tài khoản của cán bộ xử lý hồ sơ |
| 4 | USER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_USER. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 5 | FIRST_ELIGIBLE_TS | TIMESTAMP | Y |  |  | Thời điểm đầu tiên trong năm người dùng xử lý bước thuộc phạm vi tính nhân sự |
