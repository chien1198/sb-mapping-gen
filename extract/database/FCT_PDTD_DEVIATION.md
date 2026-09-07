# FCT_PDTD_DEVIATION

Nguồn: docx section "4.4.8 Bảng FCT_PDTD_DEVIATION"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | DATE | Y |  | PK | Ngày dữ liệu, dạng số YYYYMMDD |
| 2 | WI_NAME | VARCHAR2 | Y | 100 | PK | Mã hồ sơ tín dụng |
| 3 | DEVIATION_BK | VARCHAR2 | Y | 64 | PK | Khóa nghiệp vụ của dòng, còn để placeholder chờ chốt khóa nguồn |
| 4 | APPLICATION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_APPLICATION. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 5 | SYSTEM_CODE | VARCHAR2 | Y | 10 |  | Hệ nguồn của bản ghi, CLOS hoặc RLOS |
| 6 | PROCESSED_DATE | DATE | N |  |  | Ngày xử lý của hồ sơ |
| 7 | DEVIATION_TYPE_CODE | VARCHAR2 | N | 300 |  | Mã loại lệch chính sách |
| 8 | DEV_PROPOSAL | VARCHAR2 | N | 4000 |  | Đề xuất xử lý lệch chính sách |
| 9 | CHECKING_CONDITION | VARCHAR2 | N | 1000 |  | Điều kiện kiểm tra chính sách |
| 10 | CHECKING_RESULT | VARCHAR2 | N | 200 |  | Kết quả kiểm tra chính sách |
| 11 | DEVIATION_REASON | VARCHAR2 | N | 4000 |  | Lý do lệch chính sách |
| 12 | AS_REGULAR | VARCHAR2 | N | 4000 |  | Quy định chuẩn liên quan tới lệch chính sách |
