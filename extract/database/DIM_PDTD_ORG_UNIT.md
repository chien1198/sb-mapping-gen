# DIM_PDTD_ORG_UNIT

Nguồn: docx section "4.3.5 Bảng DIM_PDTD_ORG_UNIT"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | Y | 18 | PK | Khóa chính của bảng chiều DIM_PDTD_ORG_UNIT, giữ nguyên DIMENSION_KEY của bảng chiều tương ứng bên DWH_LOS, không sinh sequence mới |
| 2 | ORG_UNIT_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_ORG_UNIT. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 3 | COMPANY_CODE | VARCHAR2 | Y | 50 |  | Mã đơn vị kinh doanh |
| 4 | COMPANY_NAME | VARCHAR2 | N | 200 |  | Tên đơn vị kinh doanh |
| 5 | BRANCH_CODE | VARCHAR2 | N | 50 |  | Mã chi nhánh |
| 6 | BRANCH_NAME | VARCHAR2 | N | 200 |  | Tên chi nhánh |
| 7 | ZONE_NAME_LOS | VARCHAR2 | N | 100 |  | Tên khu vực theo cách LOS ghi nhận |
| 8 | EFF_DATE | DATE | Y |  |  | Ngày bắt đầu hiệu lực của bản ghi |
| 9 | EXP_DATE | DATE | N |  |  | Ngày hết hiệu lực của bản ghi |
