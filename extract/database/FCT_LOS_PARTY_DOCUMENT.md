# FCT_LOS_PARTY_DOCUMENT

Nguồn: docx "Design_Database_PDTD_DTM_v1.0_20260908.docx"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | DATE | Y |  | PK | Ngày dữ liệu, dạng số YYYYMMDD |
| 2 | WI_NAME | VARCHAR2 | Y | 100 | PK | Mã hồ sơ tín dụng |
| 3 | PARTY_DOCUMENT_BK | VARCHAR2 | Y | 64 | PK | Khóa nghiệp vụ của dòng, còn để placeholder chờ chốt khóa nguồn |
| 4 | APPLICATION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_APPLICATION. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 5 | APPLICATION_PARTY_BK | VARCHAR2 | Y | 64 | PK | Khóa nghiệp vụ của dòng, còn để placeholder chờ chốt khóa nguồn |
| 6 | DATASOURCE | VARCHAR2 | Y | 10 |  | Gán theo tuyến bảng giấy tờ nguồn/STG_LOS; hậu tố WI_NAME chỉ dùng kiểm tra |
| 7 | PARTY_ROLE_CODE | VARCHAR2 | N | 30 |  | Vai trò của người trên hồ sơ |
| 8 | ID_TYPE | VARCHAR2 | N | 50 |  | Loại giấy tờ định danh |
| 9 | ID_NUMBER | VARCHAR2 | N | 100 |  | Số giấy tờ định danh |
| 10 | LEGAL_DOC | VARCHAR2 | N | 100 |  | Tên loại giấy tờ pháp lý |
| 11 | OBJ_TYPE | VARCHAR2 | N | 100 |  | Loại đối tượng của giấy tờ pháp lý |
