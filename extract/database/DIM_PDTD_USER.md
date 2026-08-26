# DIM_PDTD_USER

Nguồn: docx section "4.3.11 Bảng DIM_PDTD_USER"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | Y | 18 | PK | Khóa chính của bảng chiều DIM_PDTD_USER, giữ nguyên DIMENSION_KEY của bảng chiều tương ứng bên DWH_LOS, không sinh sequence mới |
| 2 | USERNAME | VARCHAR2 | Y | 100 |  | Tên tài khoản của cán bộ xử lý hồ sơ |
| 3 | EFF_DATE | DATE | Y |  |  | Ngày bắt đầu hiệu lực của bản ghi |
| 4 | EXP_DATE | DATE | N |  |  | Ngày hết hiệu lực của bản ghi |
