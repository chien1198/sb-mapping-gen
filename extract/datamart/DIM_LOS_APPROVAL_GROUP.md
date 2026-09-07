# DIM_LOS_APPROVAL_GROUP

Nguồn: xlsx sheet "DIM_LOS_APPROVAL_GROUP" (DATAMODEL_DWH_LOS_20260903.xlsx)

- Loại bảng: DIM - danh mục
- Mô tả: Danh mục cấp thẩm quyền phê duyệt tín dụng.
- Lưu gì: Lưu mã cấp phê duyệt kèm thứ tự cấp. BA đã cung cấp ý nghĩa đầy đủ: A1 đến C3 là các cấp chuyên gia phê duyệt độc lập theo thứ tự từ cao xuống thấp, BOD là Hội đồng quản trị, CC là Hội đồng tín dụng, SCC là Ủy ban tín dụng, RCC là Hội đồng tín dụng cấp vùng, DEBTCC là Hội đồng tín dụng chuyên trách xử lý nợ.
- Grain: 1 dòng = 1 cấp phê duyệt của 1 hệ nguồn
- Khóa: PK = DIMENSION_KEY (Oracle sequence). UNIQUE (SYSTEM_CODE, APP_GRP_CODE, EFF_DATE) — dùng thẳng tổ hợp cột tự nhiên, KHÔNG sinh cột APPROVAL_GROUP_NK ghép chuỗi: các cột thành phần đã có sẵn trên bảng nên cột ghép chỉ nhân bản dữ liệu và phải giữ đồng bộ.
- Nguồn: NG_SB_CLOS_APPROVAL, NG_SB_RLOS_APPROVAL
- Báo cáo sử dụng: BC1, BC2, BC5, BC9
- Quy tắc load: SCD TYPE 2. Đọc ảnh nguồn tại cutoff của ngày :P_DATE theo đúng quy trình A hoặc B của bảng nguồn (xem 00_Phan_loai_nguon), rồi so khớp theo khóa tự nhiên: bản ghi chưa có thì INSERT với EFF_DATE = :P_DATE và EXP_DATE để trống; thuộc tính đổi thì đóng bản đang hiệu lực bằng EXP_DATE = :P_DATE - 1 rồi mở bản mới; không đổi thì không làm gì. DIMENSION_KEY sinh bằng Oracle sequence, không tái sử dụng. Bản ghi biến mất khỏi nguồn KHÔNG bị xóa và KHÔNG bị đóng: giữ nguyên để fact của ngày cũ vẫn tra được tên. Chạy lại ngày D: xóa các bản có EFF_DATE = D, mở lại các bản bị đóng bằng EXP_DATE = D - 1, rồi nạp lại.

| STT | Tên cột | Ý nghĩa | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng nguồn | Cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | Khóa tự sinh của bảng chiều | NUMBER | 18 | Y | PK | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — khóa tự sinh, sinh từ SEQ_DIM_LOS_APPROVAL_GROUP. Mỗi DIM có sẵn một dòng Unknown với DIMENSION_KEY = -1 và các thuộc tính để 'N/A'; mọi lookup không khớp từ fact trỏ về dòng này thay vì để NULL, để phép đếm trên fact không bị hụt. |
| 2 | SYSTEM_CODE | Hệ nguồn của bản ghi: CLOS hoặc RLOS | VARCHAR2 | 10 | Y |  | PHÁI SINH |  |  |  | DA_CHOT | PHÁI SINH — Hệ nguồn của bản ghi danh mục, gán theo bảng mà giá trị được lấy ra: 'CLOS' hoặc 'RLOS'. Bắt buộc nằm trong khóa tự nhiên vì hai hệ có thể dùng trùng mã cho hai nghĩa khác nhau |
| 3 | APP_GRP_CODE | Mã cấp thẩm quyền phê duyệt | VARCHAR2 | 50 | Y |  | 1:1 | NG_SB_CLOS_APPROVAL / NG_SB_RLOS_APPROVAL | APP_GRP | BC1.APP_GRP; BC2.APP_GRP; (khóa tra BC5.SLA_*, BC9.POINT) | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_APPROVAL.APP_GRP / NG_SB_RLOS_APPROVAL.APP_GRP (đổi tên thêm hậu tố CODE). Trường APP_GRP của BC1 và BC2 |
| 4 | APPROVAL_LEVEL | Thứ tự cấp phê duyệt, số nhỏ là cấp cao | NUMBER | 3 | N |  | PHÁI SINH |  |  | (đầu vào BC5.REF_PRODUCT) | DA_CHOT | PHÁI SINH — Thứ tự cấp phê duyệt theo giải thích của BA, số nhỏ là cấp cao: A1=1, A2=2, B1=3, B2=4, C1=5, C2=6, C3=7; các hội đồng nhận giá trị riêng. BC5 gom nhóm 'CGPD cấp B, C' bằng khoảng giá trị thay vì liệt kê mã |
| 5 | EFF_DATE | Ngày bắt đầu hiệu lực của phiên bản bản ghi | DATE |  | Y |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Ngày bắt đầu hiệu lực của phiên bản bản ghi. Do ETL sinh khi phát hiện thuộc tính thay đổi |
| 6 | EXP_DATE | Ngày hết hiệu lực của phiên bản, để trống là bản ghi hiện hành | DATE |  | N |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Ngày hết hiệu lực của phiên bản. NULL = bản ghi hiện hành |
|  |  |  |  |  |  |  |  |  |  | Ư |  |  |
