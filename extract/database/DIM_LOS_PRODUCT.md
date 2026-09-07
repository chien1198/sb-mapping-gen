# DIM_LOS_PRODUCT

Nguồn: docx section "4.1.2 Bảng DIM_LOS_PRODUCT"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | Y | 18 | PK | Khóa chính của bảng chiều DIM_LOS_PRODUCT, sinh bằng Oracle sequence |
| 2 | SYSTEM_CODE | VARCHAR2 | Y | 10 |  | Hệ nguồn của bản ghi, CLOS hoặc RLOS |
| 3 | PRODUCT_LINE_CODE | VARCHAR2 | N | 100 |  | Mã dòng sản phẩm |
| 4 | PRODUCT_LINE_NAME | VARCHAR2 | N | 200 |  | Tên dòng sản phẩm |
| 5 | SUB_PRODUCT_CODE | VARCHAR2 | N | 100 |  | Mã sản phẩm nhánh |
| 6 | PRODUCT_NAME | VARCHAR2 | N | 150 |  | Tên sản phẩm tín dụng |
| 7 | EFF_DATE | DATE | Y |  |  | Ngày bắt đầu hiệu lực của bản ghi |
| 8 | EXP_DATE | DATE | N |  |  | Ngày hết hiệu lực của bản ghi |
