# DIM_LOS_EXCEPTION_REASON

Nguồn: xlsx sheet "DIM_LOS_EXCEPTION_REASON" (DATAMODEL_DWH_LOS_20260826.xlsx)

- Loại bảng: DIM - danh mục
- Mô tả: Danh mục lý do quyết định và ngoại lệ được cấu hình cho từng bước xử lý.
- Lưu gì: Lưu tổ hợp bước, quyết định và loại lý do được phép phát sinh, kèm mã lý do đã bóc sẵn và cờ vi phạm First Time Right.
- Grain: 1 dòng = 1 tổ hợp bước + quyết định + nhóm lý do + tên lý do
- Khóa: DIMENSION_KEY (sequence). NK = EXCEPTION_REASON_NK - CHƯA CHỐT, xem mô tả cột
- Nguồn: NG_SB_CLOS_MAS_EXCEPTION, NG_SB_RLOS_MAS_EXCEPTION
- Báo cáo sử dụng: BC7, BC8
- Quy tắc load: (chưa khai)

| STT | Tên cột | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng nguồn | Cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | 18 | Y | PK | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Khóa thay thế, sinh từ SEQ_DIM_LOS_EXCEPTION_REASON. Mỗi DIM có sẵn một dòng Unknown với DIMENSION_KEY = -1 và các thuộc tính để 'N/A'; mọi lookup không khớp từ fact trỏ về dòng này thay vì để NULL, để phép đếm trên fact không bị hụt. |
| 2 | EXCEPTION_REASON_NK | VARCHAR2 | 500 | Y |  | CHƯA CHỐT |  |  |  | CHO_RULE_BA | CHƯA CHỐT — Khóa tự nhiên. Metadata đề xuất ghép ACTIVITYNAME + DECISION + EXCEPTION_CATEGORY + EXCEPTION_NAME nhưng đây là khóa suy luận chưa được BA/DEV xác nhận, và bảng phía RLOS còn chưa có trong metadata. Điền chính thức sau khi chốt khóa nguồn và STG_LOS |
| 3 | SYSTEM_CODE | VARCHAR2 | 10 | Y |  | PHÁI SINH |  |  |  | DA_CHOT | PHÁI SINH — Hệ nguồn của bản ghi danh mục, gán theo bảng mà giá trị được lấy ra: 'CLOS' hoặc 'RLOS'. Bắt buộc nằm trong khóa tự nhiên vì hai hệ có thể dùng trùng mã cho hai nghĩa khác nhau |
| 4 | ACTIVITYNAME | VARCHAR2 | 200 | N |  | 1:1 | NG_SB_CLOS_MAS_EXCEPTION / NG_SB_RLOS_MAS_EXCEPTION | ACTIVITYNAME | BC7.ACTIVITYNAME | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_MAS_EXCEPTION.ACTIVITYNAME / NG_SB_RLOS_MAS_EXCEPTION.ACTIVITYNAME. Giữ nguyên tên. Trường ACTIVITYNAME của BC7 |
| 5 | DECISION_CODE | VARCHAR2 | 200 | N |  | 1:1 | NG_SB_CLOS_MAS_EXCEPTION | DECISION | (thành phần khóa) | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_MAS_EXCEPTION.DECISION (đổi tên thêm hậu tố CODE cho thống nhất với DIM_LOS_DECISION) |
| 6 | EXCEPTION_CATEGORY | VARCHAR2 | 500 | N |  | 1:1 | NG_SB_CLOS_MAS_EXCEPTION | EXCEPTION_CATEGORY | BC7.EXCEPTION_CATEGORY | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_MAS_EXCEPTION.EXCEPTION_CATEGORY. Giữ nguyên tên. BA mô tả là phân nhóm các nội dung cần làm rõ hoặc bổ sung |
| 7 | EXCEPTION_NAME | VARCHAR2 | 500 | N |  | 1:1 | NG_SB_CLOS_MAS_EXCEPTION | EXCEPTION_NAME | BC7.EXCEPTION_NAME | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_MAS_EXCEPTION.EXCEPTION_NAME. Giữ nguyên tên. BA mô tả là tên nội dung cần làm rõ hoặc bổ sung |
| 8 | EXCEPTION_CODE | VARCHAR2 | 50 | N |  | PHÁI SINH |  |  |  | DA_CHOT | PHÁI SINH — REGEXP_SUBSTR(EXCEPTION_CATEGORY, '^[^:]+') khi chuỗi có dấu hai chấm, NULL khi không có. Trường EXCEPTION_CODE của BC7. BA lưu ý không phải lý do nào cũng có mã. GIỮ LẠI dù là công thức, vì đây là TRƯỜNG BÁO CÁO thật chứ không phải cờ trợ giúp, và là phép tách chuỗi cố định chứ không phải danh sách giá trị có thể thay đổi. Chỉ đặt ở dimension danh mục này, bảng fact join vào qua EXCEPTION_REASON_SK |
| 9 | EFF_DATE | DATE |  | Y |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Ngày bắt đầu hiệu lực của phiên bản bản ghi. Do ETL sinh khi phát hiện thuộc tính thay đổi |
| 10 | EXP_DATE | DATE |  | N |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Ngày hết hiệu lực của phiên bản. NULL = bản ghi hiện hành |
