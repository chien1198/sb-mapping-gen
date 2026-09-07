# DIM_PDTD_COLLATERAL_TYPE

Nguồn: docx section "4.3.4 Bảng DIM_PDTD_COLLATERAL_TYPE"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | Y | 18 | PK | Khóa chính của bảng chiều DIM_PDTD_COLLATERAL_TYPE, giữ nguyên DIMENSION_KEY của bảng chiều tương ứng bên DWH_LOS, không sinh sequence mới |
| 2 | SYSTEM_CODE | VARCHAR2 | Y | 10 |  | Hệ nguồn của bản ghi, CLOS hoặc RLOS |
| 3 | COLLATERAL_TYPE_CODE | VARCHAR2 | Y | 100 |  | Mã loại tài sản bảo đảm |
| 4 | COLL_GROUP | VARCHAR2 | N | 50 |  | Nhóm tài sản bảo đảm đã chuẩn hóa chung cho hai hệ |
| 5 | EFF_DATE | DATE | Y |  |  | Ngày bắt đầu hiệu lực của bản ghi |
| 6 | EXP_DATE | DATE | N |  |  | Ngày hết hiệu lực của bản ghi |
