# FCT_PDTD_PARTY_DOCUMENT

Nguồn: docx section "4.4.6 Bảng FCT_PDTD_PARTY_DOCUMENT"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | DATE | Y |  | PK | Ngày dữ liệu, dạng số YYYYMMDD |
| 2 | WI_NAME | VARCHAR2 | Y | 100 | PK | Mã hồ sơ tín dụng |
| 3 | PARTY_DOCUMENT_BK | VARCHAR2 | Y | 64 | PK | Khóa nghiệp vụ của dòng, còn để placeholder chờ chốt khóa nguồn |
| 4 | APPLICATION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_APPLICATION. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 5 | APPLICATION_PARTY_BK | VARCHAR2 | Y | 64 | PK | Khóa nghiệp vụ của dòng, còn để placeholder chờ chốt khóa nguồn |
| 6 | CUSTOMER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_CUSTOMER. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 7 | DATASOURCE | VARCHAR2 | Y | 10 |  | RLOS hoặc CLOS |
| 8 | PARTY_ROLE_CODE | VARCHAR2 | N | 30 |  | Vai trò của người trên hồ sơ |
| 9 | ID_TYPE | VARCHAR2 | N | 50 |  | Loại giấy tờ định danh |
| 10 | ID_NUMBER | VARCHAR2 | N | 100 |  | Số giấy tờ định danh |
| 11 | LEGAL_DOC | VARCHAR2 | N | 100 |  | Tên loại giấy tờ pháp lý |
| 12 | OBJ_TYPE | VARCHAR2 | N | 100 |  | Loại đối tượng của giấy tờ pháp lý |
| 13 | LEGAL_TYPE | VARCHAR2 | N | 50 |  | Nhóm vai trò của giấy tờ pháp lý |
| 14 | IS_PRIMARY_ID | VARCHAR2 | N | 1 |  | Có phải giấy tờ định danh chính hay không |
