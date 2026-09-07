# DIM_LOS_APPROVAL_GROUP

Nguồn: docx section "4.1.6 Bảng DIM_LOS_APPROVAL_GROUP"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | Y | 18 | PK | Khóa chính của bảng chiều DIM_LOS_APPROVAL_GROUP, sinh bằng Oracle sequence |
| 2 | SYSTEM_CODE | VARCHAR2 | Y | 10 |  | Hệ nguồn của bản ghi, CLOS hoặc RLOS |
| 3 | APP_GRP_CODE | VARCHAR2 | Y | 50 |  | Mã cấp thẩm quyền phê duyệt |
| 4 | APPROVAL_LEVEL | NUMBER | N | 3 |  | Thứ tự cấp phê duyệt, số nhỏ là cấp cao |
| 5 | EFF_DATE | DATE | Y |  |  | Ngày bắt đầu hiệu lực của bản ghi |
| 6 | EXP_DATE | DATE | N |  |  | Ngày hết hiệu lực của bản ghi |
