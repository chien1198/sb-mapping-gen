# DIM_LOS_COLLATERAL_TYPE

Nguồn: docx section "4.1.11 Bảng DIM_LOS_COLLATERAL_TYPE"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | Y | 18 | PK | Khóa chính của bảng chiều DIM_LOS_COLLATERAL_TYPE, sinh bằng Oracle sequence |
| 2 | COLLATERAL_TYPE_NK | VARCHAR2 | Y | 120 |  | Khóa tự nhiên của bảng |
| 3 | SYSTEM_CODE | VARCHAR2 | Y | 10 |  | Hệ nguồn của bản ghi, CLOS hoặc RLOS |
| 4 | COLLATERAL_TYPE_CODE | VARCHAR2 | Y | 100 |  | Mã loại tài sản bảo đảm |
| 5 | COLL_GROUP | VARCHAR2 | N | 50 |  | Nhóm tài sản bảo đảm đã chuẩn hóa chung cho hai hệ |
| 6 | EFF_DATE | DATE | Y |  |  | Ngày bắt đầu hiệu lực của bản ghi |
| 7 | EXP_DATE | DATE | N |  |  | Ngày hết hiệu lực của bản ghi |
