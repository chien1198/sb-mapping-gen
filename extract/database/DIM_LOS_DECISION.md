# DIM_LOS_DECISION

Nguồn: docx section "4.1.5 Bảng DIM_LOS_DECISION"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | Y | 18 | PK | Khóa chính của bảng chiều DIM_LOS_DECISION, sinh bằng Oracle sequence |
| 2 | SYSTEM_CODE | VARCHAR2 | Y | 10 |  | Hệ nguồn của bản ghi, CLOS hoặc RLOS |
| 3 | DECISION_CODE | VARCHAR2 | Y | 200 |  | Mã quyết định tại bước xử lý |
| 4 | DECISION_GROUP | VARCHAR2 | N | 50 |  | Nhóm quyết định đã chuẩn hóa |
| 5 | EFF_DATE | DATE | Y |  |  | Ngày bắt đầu hiệu lực của bản ghi |
| 6 | EXP_DATE | DATE | N |  |  | Ngày hết hiệu lực của bản ghi |
