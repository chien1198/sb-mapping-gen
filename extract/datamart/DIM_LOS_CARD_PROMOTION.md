# DIM_LOS_CARD_PROMOTION

Nguồn: xlsx sheet "DIM_LOS_CARD_PROMOTION" (DATAMODEL_DWH_LOS_20260903.xlsx)

- Loại bảng: DIM - danh mục
- Mô tả: Danh mục chương trình ưu đãi phí áp dụng cho hồ sơ phát hành thẻ tín dụng.
- Lưu gì: Lưu mã và mô tả chương trình ưu đãi. Trường PROMOTION_ID của BC1 thực chất cần phần mô tả chứ không phải mã, và việc đổi tên chương trình theo thời gian không được làm sai lệch dữ liệu lịch sử nên bảng có EFF_DATE và EXP_DATE.
- Grain: 1 dòng = 1 phiên bản của 1 chương trình ưu đãi
- Khóa: DIMENSION_KEY (sequence). NK = PROMOTION_CODE
- Nguồn: NG_SB_RLOS_MAS_CARD_PROMOTIO
- Báo cáo sử dụng: BC1
- Quy tắc load: SCD TYPE 2. Đọc ảnh nguồn tại cutoff của ngày :P_DATE theo đúng quy trình A hoặc B của bảng nguồn (xem 00_Phan_loai_nguon), rồi so khớp theo khóa tự nhiên: bản ghi chưa có thì INSERT với EFF_DATE = :P_DATE và EXP_DATE để trống; thuộc tính đổi thì đóng bản đang hiệu lực bằng EXP_DATE = :P_DATE - 1 rồi mở bản mới; không đổi thì không làm gì. DIMENSION_KEY sinh bằng Oracle sequence, không tái sử dụng. Bản ghi biến mất khỏi nguồn KHÔNG bị xóa và KHÔNG bị đóng: giữ nguyên để fact của ngày cũ vẫn tra được tên. Chạy lại ngày D: xóa các bản có EFF_DATE = D, mở lại các bản bị đóng bằng EXP_DATE = D - 1, rồi nạp lại.

| STT | Tên cột | Ý nghĩa | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng nguồn | Cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | Khóa tự sinh của bảng chiều | NUMBER | 18 | Y | PK | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — khóa tự sinh, sinh từ SEQ_DIM_LOS_CARD_PROMOTION. Mỗi DIM có sẵn một dòng Unknown với DIMENSION_KEY = -1 và các thuộc tính để 'N/A'; mọi lookup không khớp từ fact trỏ về dòng này thay vì để NULL, để phép đếm trên fact không bị hụt. |
| 2 | PROMOTION_CODE | Mã chương trình ưu đãi phí thẻ | VARCHAR2 | 100 | Y |  | 1:1 + NK | NG_SB_RLOS_MAS_CARD_PROMOTIO | PROMOTION_CODE | (khóa nối) | DA_CHOT | 1:1 + KHÓA TỰ NHIÊN — Nguồn: NG_SB_RLOS_MAS_CARD_PROMOTIO.PROMOTION_CODE. Giữ nguyên tên. Nối với NG_SB_RLOS_CBS.PROMOTION_ID |
| 3 | PROMOTION_DESC | Tên chương trình ưu đãi phí thẻ | VARCHAR2 | 500 | N |  | 1:1 | NG_SB_RLOS_MAS_CARD_PROMOTIO | DESCRIPTION | BC1.PROMOTION_ID | DA_CHOT | 1:1 — Nguồn: NG_SB_RLOS_MAS_CARD_PROMOTIO.DESCRIPTION (đổi tên để rõ đây là mô tả chương trình). Đây là giá trị mà BC1 hiển thị ở trường PROMOTION_ID |
| 4 | EFF_DATE | Ngày bắt đầu hiệu lực của phiên bản bản ghi | DATE |  | Y |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Ngày bắt đầu hiệu lực của phiên bản bản ghi. Do ETL sinh khi phát hiện thuộc tính thay đổi |
| 5 | EXP_DATE | Ngày hết hiệu lực của phiên bản, để trống là bản ghi hiện hành | DATE |  | N |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Ngày hết hiệu lực của phiên bản. NULL = bản ghi hiện hành |
