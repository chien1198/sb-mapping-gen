# DIM_PDTD_CHANGE_TYPE

Nguồn: docx section "4.3.13 Bảng DIM_PDTD_CHANGE_TYPE"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | Y | 18 | PK | Khóa chính của bảng chiều DIM_PDTD_CHANGE_TYPE, giữ nguyên DIMENSION_KEY của bảng chiều tương ứng bên DWH_LOS, không sinh sequence mới |
| 2 | SYSTEM_CODE | VARCHAR2 | Y | 10 |  | Hệ nguồn của bản ghi, CLOS hoặc RLOS |
| 3 | CHANGE_TYPE_CODE | VARCHAR2 | Y | 100 |  | Mã loại thay đổi điều kiện phê duyệt |
| 4 | CHANGE_TYPE_NAME | VARCHAR2 | N | 200 |  | Tên loại thay đổi điều kiện phê duyệt |
| 5 | DETAIL_CHANGE_TYPE_CODE | VARCHAR2 | N | 100 |  | Mã chi tiết loại thay đổi |
| 6 | DETAIL_CHANGE_TYPE_NAME | VARCHAR2 | N | 500 |  | Tên chi tiết loại thay đổi |
| 7 | EFF_DATE | DATE | Y |  |  | Ngày bắt đầu hiệu lực của bản ghi |
| 8 | EXP_DATE | DATE | N |  |  | Ngày hết hiệu lực của bản ghi |
