# DIM_LOS_GEO

Nguồn: docx section "4.1.10 Bảng DIM_LOS_GEO"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | Y | 18 | PK | Khóa chính của bảng chiều DIM_LOS_GEO, sinh bằng Oracle sequence |
| 2 | CITY_CODE | VARCHAR2 | Y | 50 |  | Mã tỉnh thành |
| 3 | CITY_NAME | VARCHAR2 | N | 200 |  | Tên tỉnh thành |
| 4 | CITY_NAME_VN | VARCHAR2 | N | 200 |  | Tên tỉnh thành tiếng Việt có dấu |
| 5 | DISTRICT_CODE | VARCHAR2 | N | 50 |  | Mã quận huyện |
| 6 | DISTRICT_NAME | VARCHAR2 | N | 200 |  | Tên quận huyện |
| 7 | DISTRICT_NAME_VN | VARCHAR2 | N | 200 |  | Tên quận huyện tiếng Việt có dấu |
| 8 | EFF_DATE | DATE | Y |  |  | Ngày bắt đầu hiệu lực của bản ghi |
| 9 | EXP_DATE | DATE | N |  |  | Ngày hết hiệu lực của bản ghi |
