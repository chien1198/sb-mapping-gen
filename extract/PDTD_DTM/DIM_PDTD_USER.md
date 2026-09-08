# DIM_PDTD_USER

Nguồn: xlsx sheet "DIM_PDTD_USER" (DATAMODEL_DTM_PDTD_20260907.xlsx)

- Loại bảng: DIM - danh mục
- Mô tả: Danh mục tài khoản cán bộ xử lý hồ sơ trên workflow.
- Lưu gì: Hiện chỉ có username. Giữ thành chiều riêng để mọi fact tham chiếu bằng khóa tự sinh đúng grain của nó, và để khi bổ sung master nhân sự (mã nhân viên, đơn vị, chức danh) thì chỉ thêm cột vào đây, không phải sửa lại các bảng fact.
- Grain: 1 dòng = 1 phiên bản của 1 tài khoản người dùng
- Khóa: PK = DIMENSION_KEY (Oracle sequence). UNIQUE (USERNAME, EFF_DATE). Kế thừa DIMENSION_KEY từ DWH. Có thêm cột USER_SK mang đúng giá trị DIMENSION_KEY theo quy chuẩn đặt tên sẵn có.
- Quy tắc load: Bê 1:1 từ DWH.DIM_LOS_USER, GIỮ NGUYÊN DIMENSION_KEY và cặp EFF_DATE/EXP_DATE, KHÔNG sinh sequence mới và KHÔNG tự tính lại ngày hiệu lực ở DTM — toàn bộ logic SCD2 đã chạy xong ở tầng DWH, xem Quy tắc load của DIM_LOS_USER. Sau khi bê thì LEFT JOIN bảng map để bổ sung cột chuẩn hóa; mọi join vào bảng map phải là 1:1 hoặc 1:0, join làm nhân dòng là lỗi và phải chặn bằng kiểm tra chất lượng. Bản hiện hành là EXP_DATE IS NULL.
- Nguồn: DWH.DIM_LOS_USER
- Báo cáo sử dụng: BC1, BC2, BC3, BC4, BC7, BC8, BC9

| STT | Tên cột | Ý nghĩa | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng/cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | Khóa tự sinh của bảng chiều | NUMBER | 18 | Y | PK | KỸ THUẬT | 1:1 từ DWH.DIM_LOS_USER.DIMENSION_KEY |  | DA_CHOT | KỸ THUẬT — khóa tự sinh, sinh từ SEQ_DIM_PDTD_USER. Có sẵn dòng Unknown DIMENSION_KEY = -1. |
| 2 | USER_SK | Khóa tự sinh của bảng chiều, trùng giá trị với DIMENSION_KEY | NUMBER | 18 | Y |  | KỸ THUẬT | Bằng đúng DIMENSION_KEY của chính bảng này | — | DA_CHOT | KỸ THUẬT — Khóa tự sinh của bảng chiều DIM_PDTD_USER, giá trị BẰNG ĐÚNG DIMENSION_KEY của cùng dòng. Sinh thêm theo quy chuẩn đặt tên sẵn có: mỗi bảng chiều mang một cột khóa đặt theo tên thực thể. KHÔNG sinh sequence riêng và KHÔNG tự đánh số — luôn gán bằng DIMENSION_KEY, nếu không hai cột lệch nhau thì fact join vào đâu cũng sai. |
| 3 | USERNAME | Tên tài khoản người xử lý hồ sơ | VARCHAR2 | 100 | Y | NK | 1:1 + NK | 1:1 từ DWH.DIM_LOS_USER.USERNAME |  | DA_CHOT | 1:1 + KHÓA TỰ NHIÊN — Tên tài khoản của cán bộ xử lý. Nguồn: NG_SB_CLOS_ENTRY_EXIT.USERNAME / NG_SB_RLOS_ENTRY_EXIT.USERNAME. UNIQUE (USERNAME, EFF_DATE). |
| 4 | EFF_DATE | Ngày bắt đầu hiệu lực của phiên bản bản ghi | DATE |  | Y |  | KỸ THUẬT | 1:1 từ DWH.DIM_LOS_USER.EFF_DATE |  | DA_CHOT | KỸ THUẬT — Ngày bắt đầu hiệu lực của phiên bản bản ghi, kiểu DATE. Bằng :P_DATE tức 00:00:00 của ngày ETL phát hiện bản ghi mới hoặc phát hiện thuộc tính thay đổi. |
| 5 | EXP_DATE | Thời điểm hết hiệu lực của phiên bản, để trống là bản ghi hiện hành | DATE |  | N |  | KỸ THUẬT | 1:1 từ DWH.DIM_LOS_USER.EXP_DATE |  | DA_CHOT | KỸ THUẬT — Thời điểm hết hiệu lực của phiên bản, kiểu DATE. NULL = bản ghi hiện hành. Khi đóng thì gán :P_DATE - INTERVAL '1' SECOND, tức 23:59:59 của ngày hôm trước, để khoảng hiệu lực của bản cũ và bản mới nối liền nhau, không hở và không chồng lấn. Đóng trong hai trường hợp: thuộc tính thay đổi, hoặc bản ghi bị gỡ khỏi nguồn. |
