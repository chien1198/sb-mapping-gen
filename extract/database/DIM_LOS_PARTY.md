# DIM_LOS_PARTY

Nguồn: docx section "4.1.2 Bảng DIM_LOS_PARTY"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | Y | 18 | PK | Khóa chính của bảng chiều DIM_LOS_PARTY, sinh bằng Oracle sequence |
| 2 | PARTY_NK | VARCHAR2 | Y | 200 |  | Khóa tự nhiên của bảng |
| 3 | SYSTEM_CODE | VARCHAR2 | N | 10 |  | Hệ nguồn của bản ghi, CLOS hoặc RLOS |
| 4 | PARTY_TYPE | VARCHAR2 | N | 20 |  | Loại đối tượng, cá nhân hoặc tổ chức |
| 5 | WI_NAME | VARCHAR2 | Y | 100 |  | Mã hồ sơ tín dụng |
| 6 | PARTY_ROLE_CODE | VARCHAR2 | Y | 30 |  | Vai trò của người trên hồ sơ |
| 7 | PARTY_SEQ | NUMBER | Y | 4 |  | Số thứ tự người trong cùng vai trò của hồ sơ |
| 8 | FULL_NAME | VARCHAR2 | N | 200 |  | Họ tên đầy đủ của người liên quan trên hồ sơ |
| 9 | DATE_OF_BIRTH | DATE | N |  |  | Ngày sinh |
| 10 | GENDER | VARCHAR2 | N | 20 |  | Giới tính |
| 11 | MARRIAGE_STATUS | VARCHAR2 | N | 100 |  | Tình trạng hôn nhân |
| 12 | EDUCATION_LEVEL | VARCHAR2 | N | 100 |  | Trình độ học vấn |
| 13 | VEHICLE | VARCHAR2 | N | 100 |  | Phương tiện đi lại của khách hàng |
| 14 | ORG_LEGAL_ID | VARCHAR2 | N | 100 |  | Số giấy tờ pháp lý của khách hàng tổ chức |
| 15 | PERM_ADDRESS | VARCHAR2 | N | 500 |  | Địa chỉ thường trú |
| 16 | CURR_HOUSE_NO | VARCHAR2 | N | 200 |  | Số nhà thuộc địa chỉ hiện tại |
| 17 | CURR_WARD | VARCHAR2 | N | 100 |  | Phường xã thuộc địa chỉ hiện tại |
| 18 | GEO_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_GEO. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 19 | EFF_DATE | DATE | Y |  |  | Ngày bắt đầu hiệu lực của bản ghi |
| 20 | EXP_DATE | DATE | N |  |  | Ngày hết hiệu lực của bản ghi |
