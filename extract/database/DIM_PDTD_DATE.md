# DIM_PDTD_DATE

Nguồn: docx section "4.3.1 Bảng DIM_PDTD_DATE"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | DATE | Y | 18 | PK | Ngày dữ liệu, dạng số YYYYMMDD |
| 2 | IS_WORKING_DAY | VARCHAR2 | Y | 1 |  | Có phải ngày làm việc hay không |
| 3 | REPORT_WEEK | VARCHAR2 | Y | 10 |  | Tuần báo cáo, dạng YYYY-WW |
| 4 | YEAR_MONTH | VARCHAR2 | Y | 6 |  | Tháng báo cáo, dạng YYYY-MM |
| 5 | YEAR_ID | NUMBER | Y | 4 |  | Năm của ngày này |
| 6 | DATE_SK | NUMBER | Y | 18 | PK | Khóa tham chiếu đến bảng chiều DIM_PDTD_DATE. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
