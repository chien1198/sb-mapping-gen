# FCT_LOS_EXCEPTION

Nguồn: docx section "4.2.8 Bảng FCT_LOS_EXCEPTION"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | DATE | Y |  | PK | Ngày dữ liệu, dạng số YYYYMMDD |
| 2 | WI_NAME | VARCHAR2 | Y | 100 | PK | Mã hồ sơ tín dụng |
| 3 | EXCEPTION_BK | VARCHAR2 | Y | 300 | PK | Khóa nghiệp vụ của dòng, còn để placeholder chờ chốt khóa nguồn |
| 4 | APPLICATION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_APPLICATION. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 5 | EXCEPTION_REASON_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_EXCEPTION_REASON. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 6 | RAISED_BY_USER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_USER, tham chiếu đến người nêu nội dung cần làm rõ. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 7 | SYSTEM_CODE | VARCHAR2 | Y | 10 |  | Hệ nguồn của bản ghi, CLOS hoặc RLOS |
| 8 | EXCEPTION_CATEGORY | VARCHAR2 | N | 500 |  | Phân nhóm nội dung cần làm rõ |
| 9 | EXCEPTION_NAME | VARCHAR2 | N | 500 |  | Tên nội dung cần làm rõ |
| 10 | EXCEPTION_REMARKS | VARCHAR2 | N | 4000 |  | Ghi chú của nội dung cần làm rõ |
| 11 | RAISED_BY | VARCHAR2 | N | 100 |  | Người nêu nội dung cần làm rõ |
| 12 | RAISED_DATE_TIME | TIMESTAMP | N |  |  | Thời điểm nêu nội dung cần làm rõ |
| 13 | RCTYPE | VARCHAR2 | N | 20 |  | Loại ghi nhận, nêu vấn đề hay phản hồi |
