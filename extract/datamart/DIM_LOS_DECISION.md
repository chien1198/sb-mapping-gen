# DIM_LOS_DECISION

Nguồn: xlsx sheet "DIM_LOS_DECISION" (DATAMODEL_DWH_LOS_20260903.xlsx)

- Loại bảng: DIM - danh mục
- Mô tả: Danh mục quyết định có thể phát sinh tại một bước xử lý.
- Lưu gì: Lưu mã quyết định kèm nhóm quyết định đã phân loại sẵn, thay cho việc mỗi báo cáo tự viết một danh sách IN (...) để phân biệt duyệt, từ chối, trả về hay hủy.
- Grain: 1 dòng = 1 quyết định của 1 hệ nguồn
- Khóa: PK = DIMENSION_KEY (Oracle sequence). UNIQUE (SYSTEM_CODE, DECISION_CODE, EFF_DATE) — dùng thẳng tổ hợp cột tự nhiên, KHÔNG sinh cột DECISION_NK ghép chuỗi: các cột thành phần đã có sẵn trên bảng nên cột ghép chỉ nhân bản dữ liệu và phải giữ đồng bộ.
- Nguồn: NG_SB_CLOS_ENTRY_EXIT, NG_SB_RLOS_ENTRY_EXIT
- Báo cáo sử dụng: BC1, BC2, BC3, BC4, BC7, BC8, BC9
- Quy tắc load: SCD TYPE 2. Đọc ảnh nguồn tại cutoff của ngày :P_DATE theo đúng quy trình A hoặc B của bảng nguồn (xem 00_Phan_loai_nguon), rồi so khớp theo khóa tự nhiên: bản ghi chưa có thì INSERT với EFF_DATE = :P_DATE và EXP_DATE để trống; thuộc tính đổi thì đóng bản đang hiệu lực bằng EXP_DATE = :P_DATE - 1 rồi mở bản mới; không đổi thì không làm gì. DIMENSION_KEY sinh bằng Oracle sequence, không tái sử dụng. Bản ghi biến mất khỏi nguồn KHÔNG bị xóa và KHÔNG bị đóng: giữ nguyên để fact của ngày cũ vẫn tra được tên. Chạy lại ngày D: xóa các bản có EFF_DATE = D, mở lại các bản bị đóng bằng EXP_DATE = D - 1, rồi nạp lại.

| STT | Tên cột | Ý nghĩa | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng nguồn | Cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | Khóa tự sinh của bảng chiều | NUMBER | 18 | Y | PK | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — khóa tự sinh, sinh từ SEQ_DIM_LOS_DECISION. Mỗi DIM có sẵn một dòng Unknown với DIMENSION_KEY = -1 và các thuộc tính để 'N/A'; mọi lookup không khớp từ fact trỏ về dòng này thay vì để NULL, để phép đếm trên fact không bị hụt. |
| 2 | SYSTEM_CODE | Hệ nguồn của bản ghi: CLOS hoặc RLOS | VARCHAR2 | 10 | Y |  | PHÁI SINH |  |  |  | DA_CHOT | PHÁI SINH — Hệ nguồn của bản ghi danh mục, gán theo bảng mà giá trị được lấy ra: 'CLOS' hoặc 'RLOS'. Bắt buộc nằm trong khóa tự nhiên vì hai hệ có thể dùng trùng mã cho hai nghĩa khác nhau |
| 3 | DECISION_CODE | Mã quyết định tại bước xử lý | VARCHAR2 | 200 | Y |  | 1:1 | NG_SB_CLOS_ENTRY_EXIT / NG_SB_RLOS_ENTRY_EXIT | DECISION | BC3.DECISION; BC8.decision | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_ENTRY_EXIT.DECISION / NG_SB_RLOS_ENTRY_EXIT.DECISION. Giữ nguyên tên và giá trị. Trường DECISION của BC3 và BC8 |
| 4 | DECISION_GROUP | Nhóm quyết định đã chuẩn hóa | VARCHAR2 | 50 | N |  | PHÁI SINH |  |  | (đầu vào BI_APPSTATUS của BC1, BC2, BC5, BC9) | DA_CHOT | PHÁI SINH — APPROVED nếu IS_APPROVED='Y'; REJECTED nếu IS_REJECT='Y'; CANCEL nếu IS_CANCEL='Y'; RETURN nếu IS_RETURN='Y'; còn lại FORWARD |
| 5 | EFF_DATE | Ngày bắt đầu hiệu lực của phiên bản bản ghi | DATE |  | Y |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Ngày bắt đầu hiệu lực của phiên bản bản ghi. Do ETL sinh khi phát hiện thuộc tính thay đổi |
| 6 | EXP_DATE | Ngày hết hiệu lực của phiên bản, để trống là bản ghi hiện hành | DATE |  | N |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Ngày hết hiệu lực của phiên bản. NULL = bản ghi hiện hành |
