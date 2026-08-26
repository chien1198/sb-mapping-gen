# DIM_LOS_ORG_UNIT

Nguồn: docx section "4.1.8 Bảng DIM_LOS_ORG_UNIT"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | Y | 18 | PK | Khóa chính của bảng chiều DIM_LOS_ORG_UNIT, sinh bằng Oracle sequence |
| 2 | COMPANY_CODE | VARCHAR2 | Y | 50 |  | Mã đơn vị kinh doanh |
| 3 | COMPANY_NAME | VARCHAR2 | N | 200 |  | Tên đơn vị kinh doanh |
| 4 | BRANCH_CODE | VARCHAR2 | N | 50 |  | Mã chi nhánh |
| 5 | BRANCH_NAME | VARCHAR2 | N | 200 |  | Tên chi nhánh |
| 6 | ZONE_NAME_LOS | VARCHAR2 | N | 100 |  | Tên khu vực theo cách LOS ghi nhận |
| 7 | EFF_DATE | DATE | Y |  |  | Ngày bắt đầu hiệu lực của bản ghi |
| 8 | EXP_DATE | DATE | N |  |  | Ngày hết hiệu lực của bản ghi |
