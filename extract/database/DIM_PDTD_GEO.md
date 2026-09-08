# DIM_PDTD_GEO

Nguồn: docx "Design_Database_PDTD_DTM_v1.0_20260908.docx"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | Y | 18 | PK | Khóa chính của bảng chiều DIM_PDTD_GEO, giữ nguyên DIMENSION_KEY của bảng chiều tương ứng bên DWH_LOS, không sinh sequence mới |
| 2 | GEO_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_GEO. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 3 | CITY_CODE | VARCHAR2 | Y | 50 |  | Mã tỉnh thành |
| 4 | CITY_NAME | VARCHAR2 | N | 200 |  | Tên tỉnh thành |
| 5 | CITY_NAME_VN | VARCHAR2 | N | 200 |  | Tên tỉnh thành tiếng Việt có dấu |
| 6 | DISTRICT_CODE | VARCHAR2 | N | 50 |  | Mã quận huyện |
| 7 | DISTRICT_NAME | VARCHAR2 | N | 200 |  | Tên quận huyện |
| 8 | DISTRICT_NAME_VN | VARCHAR2 | N | 200 |  | Tên quận huyện tiếng Việt có dấu |
| 9 | EFF_DATE | DATE | Y |  |  | Ngày bắt đầu hiệu lực của bản ghi |
| 10 | EXP_DATE | DATE | N |  |  | Ngày hết hiệu lực của bản ghi |
