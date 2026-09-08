# DIM_LOS_COLLATERAL_TYPE

Nguồn: docx "Design_Database_PDTD_DTM_v1.0_20260908.docx"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | Y | 18 | PK | Khóa chính của bảng chiều DIM_LOS_COLLATERAL_TYPE, sinh bằng Oracle sequence |
| 2 | COLLATERAL_TYPE_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_COLLATERAL_TYPE. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 3 | DATASOURCE | VARCHAR2 | Y | 10 |  | Hệ nguồn của bản ghi danh mục, gán theo bảng mà giá trị được lấy ra: 'CLOS' hoặc 'RLOS' |
| 4 | COLLATERAL_TYPE_CODE | VARCHAR2 | Y | 100 |  | Mã loại tài sản bảo đảm |
| 5 | COLL_GROUP | VARCHAR2 | N | 50 |  | Nhóm tài sản bảo đảm đã chuẩn hóa chung cho hai hệ |
| 6 | EFF_DATE | DATE | Y |  |  | Ngày bắt đầu hiệu lực của bản ghi |
| 7 | EXP_DATE | DATE | N |  |  | Ngày hết hiệu lực của bản ghi |
