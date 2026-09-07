# DIM_LOS_EXCEPTION_REASON

Nguồn: xlsx sheet "DIM_LOS_EXCEPTION_REASON" (DATAMODEL_DWH_LOS_20260903.xlsx)

- Loại bảng: DIM - danh mục
- Mô tả: Danh mục lý do quyết định và ngoại lệ được cấu hình cho từng bước xử lý.
- Lưu gì: Lưu tổ hợp bước, quyết định và loại lý do được phép phát sinh, kèm mã lý do đã bóc sẵn và cờ vi phạm First Time Right.
- Grain: 1 dòng = 1 tổ hợp bước + quyết định + nhóm lý do + tên lý do
- Khóa: PK = DIMENSION_KEY (Oracle sequence). NK = SYSTEM_CODE + ACTIVITYNAME + DECISION_CODE + EXCEPTION_CATEGORY + EXCEPTION_NAME. Hai bảng nguồn đều thuộc LOẠI 1 và khóa CDC đã khai đủ tổ hợp này nên khai khóa tự nhiên thẳng trên cột gốc, KHÔNG hash.
- Nguồn: NG_SB_CLOS_MAS_EXCEPTION, NG_SB_RLOS_MAS_EXCEPTION
- Báo cáo sử dụng: BC7, BC8
- Quy tắc load: SCD TYPE 2. Đọc ảnh nguồn tại cutoff của ngày :P_DATE theo đúng quy trình A hoặc B của bảng nguồn (xem 00_Phan_loai_nguon), rồi so khớp theo khóa tự nhiên: bản ghi chưa có thì INSERT với EFF_DATE = :P_DATE và EXP_DATE để trống; thuộc tính đổi thì đóng bản đang hiệu lực bằng EXP_DATE = :P_DATE - 1 rồi mở bản mới; không đổi thì không làm gì. DIMENSION_KEY sinh bằng Oracle sequence, không tái sử dụng. Bản ghi biến mất khỏi nguồn KHÔNG bị xóa và KHÔNG bị đóng: giữ nguyên để fact của ngày cũ vẫn tra được tên. Chạy lại ngày D: xóa các bản có EFF_DATE = D, mở lại các bản bị đóng bằng EXP_DATE = D - 1, rồi nạp lại.

| STT | Tên cột | Ý nghĩa | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng nguồn | Cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | Khóa tự sinh của bảng chiều | NUMBER | 18 | Y | PK | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — khóa tự sinh, sinh từ SEQ_DIM_LOS_EXCEPTION_REASON. Mỗi DIM có sẵn một dòng Unknown với DIMENSION_KEY = -1 và các thuộc tính để 'N/A'; mọi lookup không khớp từ fact trỏ về dòng này thay vì để NULL, để phép đếm trên fact không bị hụt. |
| 2 | SYSTEM_CODE | Hệ nguồn của bản ghi: CLOS hoặc RLOS | VARCHAR2 | 10 | Y | NK | PHÁI SINH |  |  |  | DA_CHOT | T PHÁI SINH — Hệ nguồn của bản ghi danh mục, gán theo bảng mà giá trị được lấy ra: 'CLOS' hoặc 'RLOS'. Bắt buộc nằm trong khóa tự nhiên vì hai hệ có thể dùng trùng mã cho hai nghĩa khác nhau |
| 3 | ACTIVITYNAME | Tên bước phát sinh nội dung cần làm rõ | VARCHAR2 | 200 | N | NK | 1:1 | NG_SB_CLOS_MAS_EXCEPTION / NG_SB_RLOS_MAS_EXCEPTION | ACTIVITYNAME | BC7.ACTIVITYNAME | DA_CHOT | T 1:1 — Nguồn: NG_SB_CLOS_MAS_EXCEPTION.ACTIVITYNAME / NG_SB_RLOS_MAS_EXCEPTION.ACTIVITYNAME. Giữ nguyên tên. Trường ACTIVITYNAME của BC7 |
| 4 | DECISION_CODE | Mã quyết định tại bước xử lý | VARCHAR2 | 200 | N | NK | 1:1 | NG_SB_CLOS_MAS_EXCEPTION | DECISION | (thành phần khóa) | DA_CHOT | T 1:1 — Nguồn: NG_SB_CLOS_MAS_EXCEPTION.DECISION (đổi tên thêm hậu tố CODE cho thống nhất với DIM_LOS_DECISION) |
| 5 | EXCEPTION_CATEGORY | Phân nhóm nội dung cần làm rõ | VARCHAR2 | 500 | N | NK | 1:1 | NG_SB_CLOS_MAS_EXCEPTION | EXCEPTION_CATEGORY | BC7.EXCEPTION_CATEGORY | DA_CHOT | T 1:1 — Nguồn: NG_SB_CLOS_MAS_EXCEPTION.EXCEPTION_CATEGORY. Giữ nguyên tên. BA mô tả là phân nhóm các nội dung cần làm rõ hoặc bổ sung |
| 6 | EXCEPTION_NAME | Tên nội dung cần làm rõ | VARCHAR2 | 500 | N | NK | 1:1 | NG_SB_CLOS_MAS_EXCEPTION | EXCEPTION_NAME | BC7.EXCEPTION_NAME | DA_CHOT | T 1:1 — Nguồn: NG_SB_CLOS_MAS_EXCEPTION.EXCEPTION_NAME. Giữ nguyên tên. BA mô tả là tên nội dung cần làm rõ hoặc bổ sung |
| 7 | EXCEPTION_CODE | Mã nội dung cần làm rõ | VARCHAR2 | 50 | N |  | PHÁI SINH |  |  | BC7.EXCEPTION_CODE | DA_CHOT | PHÁI SINH — REGEXP_SUBSTR(EXCEPTION_CATEGORY, '^[^:]+') khi chuỗi có dấu hai chấm, NULL khi không có. Trường EXCEPTION_CODE của BC7. BA lưu ý không phải lý do nào cũng có mã. GIỮ LẠI dù là công thức, vì đây là TRƯỜNG BÁO CÁO thật chứ không phải cờ trợ giúp, và là phép tách chuỗi cố định chứ không phải danh sách giá trị có thể thay đổi. Chỉ đặt ở dimension danh mục này, bảng fact join vào qua EXCEPTION_REASON_SK |
| 8 | EFF_DATE | Ngày bắt đầu hiệu lực của phiên bản bản ghi | DATE |  | Y |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Ngày bắt đầu hiệu lực của phiên bản bản ghi. Do ETL sinh khi phát hiện thuộc tính thay đổi |
| 9 | EXP_DATE | Ngày hết hiệu lực của phiên bản, để trống là bản ghi hiện hành | DATE |  | N |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Ngày hết hiệu lực của phiên bản. NULL = bản ghi hiện hành |
