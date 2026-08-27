# DIM_LOS_DECISION

Nguồn: xlsx sheet "DIM_LOS_DECISION" (DATAMODEL_DWH_LOS_20260826.xlsx)

- Loại bảng: DIM - danh mục
- Mô tả: Danh mục quyết định có thể phát sinh tại một bước xử lý.
- Lưu gì: Lưu mã quyết định kèm nhóm quyết định đã phân loại sẵn, thay cho việc mỗi báo cáo tự viết một danh sách IN (...) để phân biệt duyệt, từ chối, trả về hay hủy.
- Grain: 1 dòng = 1 quyết định của 1 hệ nguồn
- Khóa: DIMENSION_KEY (sequence). NK = DECISION_NK
- Nguồn: NG_SB_CLOS_ENTRY_EXIT, NG_SB_RLOS_ENTRY_EXIT
- Báo cáo sử dụng: BC1, BC2, BC3, BC4, BC7, BC8, BC9
- Quy tắc load: (chưa khai)

| STT | Tên cột | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng nguồn | Cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | 18 | Y | PK | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Khóa thay thế, sinh từ SEQ_DIM_LOS_DECISION. Mỗi DIM có sẵn một dòng Unknown với DIMENSION_KEY = -1 và các thuộc tính để 'N/A'; mọi lookup không khớp từ fact trỏ về dòng này thay vì để NULL, để phép đếm trên fact không bị hụt. |
| 2 | DECISION_NK | VARCHAR2 | 220 | Y |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Khóa tự nhiên do DWH ghép: SYSTEM_CODE || '|' || DECISION_CODE |
| 3 | SYSTEM_CODE | VARCHAR2 | 10 | Y |  | PHÁI SINH |  |  |  | DA_CHOT | PHÁI SINH — Hệ nguồn của bản ghi danh mục, gán theo bảng mà giá trị được lấy ra: 'CLOS' hoặc 'RLOS'. Bắt buộc nằm trong khóa tự nhiên vì hai hệ có thể dùng trùng mã cho hai nghĩa khác nhau |
| 4 | DECISION_CODE | VARCHAR2 | 200 | Y |  | 1:1 | NG_SB_CLOS_ENTRY_EXIT / NG_SB_RLOS_ENTRY_EXIT | DECISION | BC3.DECISION; BC8.decision | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_ENTRY_EXIT.DECISION / NG_SB_RLOS_ENTRY_EXIT.DECISION. Giữ nguyên tên và giá trị. Trường DECISION của BC3 và BC8 |
| 5 | DECISION_GROUP | VARCHAR2 | 50 | N |  | PHÁI SINH |  |  | (đầu vào BI_APPSTATUS của BC1, BC2, BC5, BC9) | DA_CHOT | PHÁI SINH — APPROVED nếu IS_APPROVED='Y'; REJECTED nếu IS_REJECT='Y'; CANCEL nếu IS_CANCEL='Y'; RETURN nếu IS_RETURN='Y'; còn lại FORWARD |
| 6 | EFF_DATE | DATE |  | Y |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Ngày bắt đầu hiệu lực của phiên bản bản ghi. Do ETL sinh khi phát hiện thuộc tính thay đổi |
| 7 | EXP_DATE | DATE |  | N |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Ngày hết hiệu lực của phiên bản. NULL = bản ghi hiện hành |
