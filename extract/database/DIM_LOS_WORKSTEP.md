# DIM_LOS_WORKSTEP

Nguồn: docx section "4.1.3 Bảng DIM_LOS_WORKSTEP"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | Y | 18 | PK | Khóa chính của bảng chiều DIM_LOS_WORKSTEP, sinh bằng Oracle sequence |
| 2 | SYSTEM_CODE | VARCHAR2 | Y | 10 |  | Hệ nguồn của bản ghi, CLOS hoặc RLOS |
| 3 | WORKSTEP_CODE | VARCHAR2 | Y | 200 |  | Mã bước xử lý trên workflow |
| 4 | EFF_DATE | DATE | Y |  |  | Ngày bắt đầu hiệu lực của bản ghi |
| 5 | EXP_DATE | DATE | N |  |  | Ngày hết hiệu lực của bản ghi |
