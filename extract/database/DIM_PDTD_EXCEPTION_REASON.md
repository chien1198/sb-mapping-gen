# DIM_PDTD_EXCEPTION_REASON

Nguồn: docx section "4.3.12 Bảng DIM_PDTD_EXCEPTION_REASON"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | Y | 18 | PK | Khóa chính của bảng chiều DIM_PDTD_EXCEPTION_REASON, giữ nguyên DIMENSION_KEY của bảng chiều tương ứng bên DWH_LOS, không sinh sequence mới |
| 2 | EXCEPTION_REASON_NK | VARCHAR2 | Y | 64 |  | Khóa tự nhiên của bảng |
| 3 | SYSTEM_CODE | VARCHAR2 | Y | 10 |  | Hệ nguồn của bản ghi, CLOS hoặc RLOS |
| 4 | ACTIVITYNAME | VARCHAR2 | N | 200 |  | Tên bước phát sinh nội dung cần làm rõ |
| 5 | DECISION_CODE | VARCHAR2 | N | 200 |  | Mã quyết định tại bước xử lý |
| 6 | EXCEPTION_CATEGORY | VARCHAR2 | N | 500 |  | Phân nhóm nội dung cần làm rõ |
| 7 | EXCEPTION_NAME | VARCHAR2 | N | 500 |  | Tên nội dung cần làm rõ |
| 8 | EXCEPTION_CODE | VARCHAR2 | N | 50 |  | Mã nội dung cần làm rõ |
| 9 | EFF_DATE | DATE | Y |  |  | Ngày bắt đầu hiệu lực của bản ghi |
| 10 | EXP_DATE | DATE | N |  |  | Ngày hết hiệu lực của bản ghi |
