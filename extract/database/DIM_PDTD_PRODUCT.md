# DIM_PDTD_PRODUCT

Nguồn: docx section "4.3.8 Bảng DIM_PDTD_PRODUCT"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | Y | 18 | PK | Khóa chính của bảng chiều DIM_PDTD_PRODUCT, giữ nguyên DIMENSION_KEY của bảng chiều tương ứng bên DWH_LOS, không sinh sequence mới |
| 2 | PRODUCT_NK | VARCHAR2 | Y | 450 |  | Khóa tự nhiên của bảng |
| 3 | SYSTEM_CODE | VARCHAR2 | Y | 10 |  | Hệ nguồn của bản ghi, CLOS hoặc RLOS |
| 4 | PRODUCT_LINE_CODE | VARCHAR2 | N | 100 |  | Mã dòng sản phẩm |
| 5 | SUB_PRODUCT_CODE | VARCHAR2 | N | 100 |  | Mã sản phẩm nhánh |
| 6 | PRODUCT_NAME | VARCHAR2 | N | 150 |  | Tên sản phẩm tín dụng |
| 7 | IS_CREDIT_CARD | VARCHAR2 | N | 1 |  | Có phải sản phẩm thẻ tín dụng hay không |
| 8 | IS_FAST_PRODUCT | VARCHAR2 | N | 1 |  | Có thuộc nhóm sản phẩm giải ngân nhanh hay không |
| 9 | PRODUCT_LINE_NAME | VARCHAR2 | N | 200 |  | Tên dòng sản phẩm |
| 10 | EFF_DATE | DATE | Y |  |  | Ngày bắt đầu hiệu lực của bản ghi |
| 11 | EXP_DATE | DATE | N |  |  | Ngày hết hiệu lực của bản ghi |
