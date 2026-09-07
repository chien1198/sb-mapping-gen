# DIM_PDTD_WORKSTEP

Nguồn: docx section "4.3.7 Bảng DIM_PDTD_WORKSTEP"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | Y | 18 | PK | Khóa chính của bảng chiều DIM_PDTD_WORKSTEP, giữ nguyên DIMENSION_KEY của bảng chiều tương ứng bên DWH_LOS, không sinh sequence mới |
| 2 | SYSTEM_CODE | VARCHAR2 | Y | 10 |  | Hệ nguồn của bản ghi, CLOS hoặc RLOS |
| 3 | WORKSTEP_CODE | VARCHAR2 | Y | 200 |  | Mã bước xử lý trên workflow |
| 4 | IS_PDTD_STEP | VARCHAR2 | N | 1 |  | Bước có thuộc phạm vi Khối PDTD hay không |
| 5 | EFF_DATE | DATE | Y |  |  | Ngày bắt đầu hiệu lực của bản ghi |
| 6 | EXP_DATE | DATE | N |  |  | Ngày hết hiệu lực của bản ghi |
