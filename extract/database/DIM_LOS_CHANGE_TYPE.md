# DIM_LOS_CHANGE_TYPE

Nguồn: docx section "4.1.11 Bảng DIM_LOS_CHANGE_TYPE"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | Y | 18 | PK | Khóa chính của bảng chiều DIM_LOS_CHANGE_TYPE, sinh bằng Oracle sequence |
| 2 | CHANGE_TYPE_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_CHANGE_TYPE. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 3 | DATASOURCE | VARCHAR2 | Y | 10 |  | Hệ nguồn của bản ghi danh mục, gán theo bảng mà giá trị được lấy ra: 'CLOS' hoặc 'RLOS' |
| 4 | CHANGE_TYPE_CODE | VARCHAR2 | Y | 100 |  | Mã loại thay đổi điều kiện phê duyệt |
| 5 | CHANGE_TYPE_NAME | VARCHAR2 | N | 200 |  | Tên loại thay đổi điều kiện phê duyệt |
| 6 | DETAIL_CHANGE_TYPE_CODE | VARCHAR2 | N | 100 |  | Mã chi tiết loại thay đổi |
| 7 | DETAIL_CHANGE_TYPE_NAME | VARCHAR2 | N | 500 |  | Tên chi tiết loại thay đổi |
| 8 | EFF_DATE | DATE | Y |  |  | Ngày bắt đầu hiệu lực của bản ghi |
| 9 | EXP_DATE | DATE | N |  |  | Ngày hết hiệu lực của bản ghi |
