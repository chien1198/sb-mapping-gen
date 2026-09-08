# FCT_PDTD_EXCEPTION

Nguồn: docx section "4.4.9 Bảng FCT_PDTD_EXCEPTION"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | DATE | Y |  | PK | Ngày dữ liệu, dạng số YYYYMMDD |
| 2 | WI_NAME | VARCHAR2 | Y | 100 | PK | Mã hồ sơ tín dụng |
| 3 | APPLICATION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_APPLICATION. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 4 | EXCEPTION_REASON_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_EXCEPTION_REASON. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 5 | RAISED_BY_USER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_USER, tham chiếu đến người nêu nội dung cần làm rõ. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 6 | DATASOURCE | VARCHAR2 | Y | 10 | PK | Nhóm lý do quyết định |
| 7 | EXCEPTION_CATEGORY | VARCHAR2 | N | 500 | PK | Phân nhóm nội dung cần làm rõ |
| 8 | EXCEPTION_NAME | VARCHAR2 | N | 500 |  | Tên nội dung cần làm rõ |
| 9 | EXCEPTION_REMARKS | VARCHAR2 | N | 4000 |  | Ghi chú của nội dung cần làm rõ |
| 10 | RAISED_BY | VARCHAR2 | N | 100 | PK | Người nêu nội dung cần làm rõ |
| 11 | RAISED_DATE_TIME | TIMESTAMP | N |  | PK | Thời điểm nêu nội dung cần làm rõ |
| 12 | RCTYPE | VARCHAR2 | N | 20 |  | Loại ghi nhận, nêu vấn đề hay phản hồi |
| 13 | PROCESSED_DATE | DATE | N |  |  | Ngày xử lý của hồ sơ |
| 14 | CHECK_FTR | VARCHAR2 | N | 20 |  | Vi phạm nguyên tắc First Time Right |
| 15 | FIRST_WORKSTEP_RETURN | VARCHAR2 | N | 200 |  | Bước xử lý phát sinh trả về đầu tiên |
| 16 | LOANCASEID | VARCHAR2 | N | 100 |  | Mã khoản vay gắn với hồ sơ |
