# DIM_LOS_EXCEPTION_REASON

Nguồn: xlsx sheet "DIM_LOS_EXCEPTION_REASON" (DATAMODEL_DWH_LOS_20260820.xlsx)

- Loại bảng: DIM - danh mục
- Mô tả: Danh mục lý do quyết định và ngoại lệ được cấu hình cho từng bước xử lý.
- Lưu gì: Lưu tổ hợp bước, quyết định và loại lý do được phép phát sinh, kèm mã lý do đã bóc sẵn và cờ vi phạm First Time Right.
- Grain: 1 dòng = 1 tổ hợp bước + quyết định + nhóm lý do + tên lý do
- Khóa: DIMENSION_KEY (sequence). NK = EXCEPTION_REASON_NK - CHƯA CHỐT, xem mô tả cột
- Bảng nguồn CDC: NG_SB_CLOS_MAS_EXCEPTION, NG_SB_RLOS_MAS_EXCEPTION
- Báo cáo sử dụng: BC7, BC8

| STT | Tên cột | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | 18 | Y | PK | KỸ THUẬT — Khóa thay thế, sinh từ SEQ_DIM_LOS_EXCEPTION_REASON |
| 2 | EXCEPTION_REASON_NK | VARCHAR2 | 500 | Y |  | CHƯA CHỐT — Khóa tự nhiên. Metadata đề xuất ghép ACTIVITYNAME + DECISION + EXCEPTION_CATEGORY + EXCEPTION_NAME nhưng đây là khóa suy luận chưa được BA/DEV xác nhận, và bảng phía RLOS còn chưa có trong metadata. Điền chính thức sau khi chốt khóa nguồn và STG_LOS |
| 3 | SYSTEM_CODE | VARCHAR2 | 10 | Y |  | PHÁI SINH — Hệ nguồn của bản ghi danh mục, gán theo bảng mà giá trị được lấy ra: 'CLOS' hoặc 'RLOS'. Bắt buộc nằm trong khóa tự nhiên vì hai hệ có thể dùng trùng mã cho hai nghĩa khác nhau |
| 4 | ACTIVITYNAME | VARCHAR2 | 200 | N |  | 1:1 — Nguồn: NG_SB_CLOS_MAS_EXCEPTION.ACTIVITYNAME / NG_SB_RLOS_MAS_EXCEPTION.ACTIVITYNAME. Giữ nguyên tên. Trường ACTIVITYNAME của BC7 |
| 5 | DECISION_CODE | VARCHAR2 | 200 | N |  | 1:1 — Nguồn: NG_SB_CLOS_MAS_EXCEPTION.DECISION (đổi tên thêm hậu tố CODE cho thống nhất với DIM_LOS_DECISION) |
| 6 | EXCEPTION_CATEGORY | VARCHAR2 | 500 | N |  | 1:1 — Nguồn: NG_SB_CLOS_MAS_EXCEPTION.EXCEPTION_CATEGORY. Giữ nguyên tên. BA mô tả là phân nhóm các nội dung cần làm rõ hoặc bổ sung |
| 7 | EXCEPTION_NAME | VARCHAR2 | 500 | N |  | 1:1 — Nguồn: NG_SB_CLOS_MAS_EXCEPTION.EXCEPTION_NAME. Giữ nguyên tên. BA mô tả là tên nội dung cần làm rõ hoặc bổ sung |
| 8 | EXCEPTION_CODE | VARCHAR2 | 50 | N |  | PHÁI SINH — REGEXP_SUBSTR(EXCEPTION_CATEGORY, '^[^:]+') khi chuỗi có dấu hai chấm, NULL khi không có. Trường EXCEPTION_CODE của BC7. BA lưu ý không phải lý do nào cũng có mã |
| 9 | IS_FTR_VIOLATION | VARCHAR2 | 1 | N |  | PHÁI SINH — 'Y' nếu EXCEPTION_CODE chứa hậu tố 'FTR'. Theo giải thích của BA, mã dạng UW-BR-FTR nghĩa là bước UnderwriterMaker chuyển hồ sơ về BranchSupport và điều kiện trả về này thuộc danh mục vi phạm First Time Right. Đưa quy tắc CHECK_FTR của BC7 về dữ liệu |
| 10 | EFF_DATE | DATE |  | Y |  | KỸ THUẬT — Ngày bắt đầu hiệu lực của phiên bản bản ghi. Do ETL sinh khi phát hiện thuộc tính thay đổi |
| 11 | EXP_DATE | DATE |  | N |  | KỸ THUẬT — Ngày hết hiệu lực của phiên bản. NULL = bản ghi hiện hành |
