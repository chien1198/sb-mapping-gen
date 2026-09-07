# FCT_PDTD_APPLICATION_PARTY

Nguồn: docx section "4.4.5 Bảng FCT_PDTD_APPLICATION_PARTY"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | DATE | Y |  | PK | Ngày dữ liệu, dạng số YYYYMMDD |
| 2 | WI_NAME | VARCHAR2 | Y | 100 | PK | Mã hồ sơ tín dụng |
| 3 | APPLICATION_PARTY_BK | VARCHAR2 | Y | 64 | PK | Khóa nghiệp vụ của dòng, còn để placeholder chờ chốt khóa nguồn |
| 4 | APPLICATION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_APPLICATION. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 5 | GEO_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_GEO. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 6 | SYSTEM_CODE | VARCHAR2 | Y | 10 |  | Hệ nguồn của bản ghi, CLOS hoặc RLOS |
| 7 | PARTY_TYPE | VARCHAR2 | N | 20 |  | Loại đối tượng, cá nhân hoặc tổ chức |
| 8 | PARTY_ROLE_CODE | VARCHAR2 | N | 30 |  | Vai trò của người trên hồ sơ |
| 9 | FULL_NAME | VARCHAR2 | N | 200 |  | Họ tên đầy đủ của người liên quan trên hồ sơ |
| 10 | DATE_OF_BIRTH | DATE | N |  |  | Ngày sinh |
| 11 | GENDER | VARCHAR2 | N | 20 |  | Giới tính |
| 12 | MARRIAGE_STATUS | VARCHAR2 | N | 100 |  | Tình trạng hôn nhân |
| 13 | EDUCATION_LEVEL | VARCHAR2 | N | 100 |  | Trình độ học vấn |
| 14 | VEHICLE | VARCHAR2 | N | 100 |  | Phương tiện đi lại của khách hàng |
| 15 | ORG_LEGAL_ID | VARCHAR2 | N | 100 |  | Số giấy tờ pháp lý của khách hàng tổ chức |
| 16 | PERM_ADDRESS | VARCHAR2 | N | 500 |  | Địa chỉ thường trú |
| 17 | CURR_HOUSE_NO | VARCHAR2 | N | 200 |  | Số nhà thuộc địa chỉ hiện tại |
| 18 | CURR_WARD | VARCHAR2 | N | 100 |  | Phường xã thuộc địa chỉ hiện tại |
| 19 | CURR_FULL_ADDRESS | VARCHAR2 | N | 1000 |  | Địa chỉ hiện tại đầy đủ |
| 20 | OBJ_TYPE | VARCHAR2 | N | 100 |  | Loại đối tượng của giấy tờ pháp lý |
| 21 | REL_TO_APPLICANT | VARCHAR2 | N | 200 |  | Quan hệ với người đề nghị vay |
