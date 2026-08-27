# DIM_LOS_CARD_PROMOTION

Nguồn: xlsx sheet "DIM_LOS_CARD_PROMOTION" (DATAMODEL_DWH_LOS_20260826.xlsx)

- Loại bảng: DIM - danh mục
- Mô tả: Danh mục chương trình ưu đãi phí áp dụng cho hồ sơ phát hành thẻ tín dụng.
- Lưu gì: Lưu mã và mô tả chương trình ưu đãi. Trường PROMOTION_ID của BC1 thực chất cần phần mô tả chứ không phải mã, và việc đổi tên chương trình theo thời gian không được làm sai lệch dữ liệu lịch sử nên bảng có EFF_DATE và EXP_DATE.
- Grain: 1 dòng = 1 phiên bản của 1 chương trình ưu đãi
- Khóa: DIMENSION_KEY (sequence). NK = PROMOTION_CODE
- Nguồn: NG_SB_RLOS_MAS_CARD_PROMOTIO
- Báo cáo sử dụng: BC1
- Quy tắc load: (chưa khai)

| STT | Tên cột | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng nguồn | Cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | 18 | Y | PK | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Khóa thay thế, sinh từ SEQ_DIM_LOS_CARD_PROMOTION. Mỗi DIM có sẵn một dòng Unknown với DIMENSION_KEY = -1 và các thuộc tính để 'N/A'; mọi lookup không khớp từ fact trỏ về dòng này thay vì để NULL, để phép đếm trên fact không bị hụt. |
| 2 | PROMOTION_CODE | VARCHAR2 | 100 | Y |  | 1:1 + NK | NG_SB_RLOS_MAS_CARD_PROMOTIO | PROMOTION_CODE | (khóa nối) | DA_CHOT | 1:1 + KHÓA TỰ NHIÊN — Nguồn: NG_SB_RLOS_MAS_CARD_PROMOTIO.PROMOTION_CODE. Giữ nguyên tên. Nối với NG_SB_RLOS_CBS.PROMOTION_ID |
| 3 | PROMOTION_DESC | VARCHAR2 | 500 | N |  | 1:1 | NG_SB_RLOS_MAS_CARD_PROMOTIO | DESCRIPTION | BC1.PROMOTION_ID | DA_CHOT | 1:1 — Nguồn: NG_SB_RLOS_MAS_CARD_PROMOTIO.DESCRIPTION (đổi tên để rõ đây là mô tả chương trình). Đây là giá trị mà BC1 hiển thị ở trường PROMOTION_ID |
| 4 | EFF_DATE | DATE |  | Y |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Ngày bắt đầu hiệu lực của phiên bản bản ghi. Do ETL sinh khi phát hiện thuộc tính thay đổi |
| 5 | EXP_DATE | DATE |  | N |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Ngày hết hiệu lực của phiên bản. NULL = bản ghi hiện hành |
