# DIM_LOS_USER

Nguồn: xlsx sheet "DIM_LOS_USER" (DATAMODEL_DWH_LOS_20260907.xlsx)

- Loại bảng: DIM - danh mục
- Mô tả: Danh mục tài khoản cán bộ xử lý hồ sơ trên workflow.
- Lưu gì: Hiện chỉ có username. Giữ thành chiều riêng để mọi fact tham chiếu bằng khóa tự sinh đúng grain của nó, và để khi bổ sung master nhân sự (mã nhân viên, đơn vị, chức danh) thì chỉ thêm cột vào đây, không phải sửa lại các bảng fact.
- Grain: 1 dòng = 1 phiên bản của 1 tài khoản người dùng
- Khóa: PK = DIMENSION_KEY (Oracle sequence). UNIQUE (USERNAME, EFF_DATE). Có thêm cột USER_SK mang đúng giá trị DIMENSION_KEY theo quy chuẩn đặt tên sẵn có.
- Quy tắc load: SCD TYPE 2 CÓ END-DATE. Đọc delta của ngày :P_DATE theo quy trình A1 ở 00_Doc_STG_LOS: gộp các thao tác trong TỪNG commit rồi lấy commit có COMMIT_SCN lớn nhất, sau đó so với bản đang hiệu lực theo khóa tự nhiên. BỐN TRƯỜNG HỢP. (1) Khóa KHÔNG xuất hiện trong delta: nghĩa là không có gì thay đổi, giữ nguyên, TUYỆT ĐỐI KHÔNG đóng — với CDC delta thì vắng mặt là không đổi, không phải bị xóa. (2) Chỉ có bản ghi I: bản ghi mới, INSERT với EFF_DATE = :P_DATE và EXP_DATE để trống. (3) Có CẢ D VÀ I trong cùng một commit: đây là một lần SỬA, vì app nguồn cập nhật bằng cách xóa rồi chèn lại. Đóng bản đang hiệu lực bằng EXP_DATE = :P_DATE - INTERVAL '1' SECOND, tức 23:59:59 của ngày hôm trước, rồi INSERT bản mới với EFF_DATE = :P_DATE. (4) CHỈ có bản ghi D: gỡ hẳn khỏi nguồn. Đóng bản đang hiệu lực y như trường hợp 3 nhưng KHÔNG mở bản mới. Hai khoảng hiệu lực nối liền nhau, không hở và không chồng lấn. Bản hiện hành là EXP_DATE IS NULL. DIMENSION_KEY sinh bằng Oracle sequence, không tái sử dụng; cột <THỰC THỂ>_SK gán bằng đúng DIMENSION_KEY. Chạy lại ngày D: xóa các bản có EFF_DATE = D, mở lại các bản có EXP_DATE = D - INTERVAL '1' SECOND bằng cách trả EXP_DATE về NULL, rồi nạp lại.
- Nguồn: NG_SB_CLOS_ENTRY_EXIT, NG_SB_RLOS_ENTRY_EXIT
- Báo cáo sử dụng: BC1, BC2, BC3, BC4, BC7, BC8, BC9

| STT | Tên cột | Ý nghĩa | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng nguồn | Cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | Khóa tự sinh của bảng chiều | NUMBER | 18 | Y | PK | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — khóa tự sinh, sinh từ SEQ_DIM_LOS_USER. Có sẵn dòng Unknown DIMENSION_KEY = -1. |
| 2 | USER_SK | Khóa tự sinh của bảng chiều, trùng giá trị với DIMENSION_KEY | NUMBER | 18 | Y |  | KỸ THUẬT | — | — | — | DA_CHOT | KỸ THUẬT — Khóa tự sinh của bảng chiều DIM_LOS_USER, giá trị BẰNG ĐÚNG DIMENSION_KEY của cùng dòng. Sinh thêm theo quy chuẩn đặt tên sẵn có: mỗi bảng chiều mang một cột khóa đặt theo tên thực thể. KHÔNG sinh sequence riêng và KHÔNG tự đánh số — luôn gán bằng DIMENSION_KEY, nếu không hai cột lệch nhau thì fact join vào đâu cũng sai. |
| 3 | USERNAME | Tên tài khoản người xử lý hồ sơ | VARCHAR2 | 100 | Y | NK | 1:1 + NK | NG_SB_CLOS_ENTRY_EXIT / NG_SB_RLOS_ENTRY_EXIT | USERNAME |  | DA_CHOT | 1:1 + KHÓA TỰ NHIÊN — Tên tài khoản của cán bộ xử lý. Nguồn: NG_SB_CLOS_ENTRY_EXIT.USERNAME / NG_SB_RLOS_ENTRY_EXIT.USERNAME. UNIQUE (USERNAME, EFF_DATE). |
| 4 | EFF_DATE | Ngày bắt đầu hiệu lực của phiên bản bản ghi | DATE |  | Y |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Ngày bắt đầu hiệu lực của phiên bản bản ghi, kiểu DATE. Bằng :P_DATE tức 00:00:00 của ngày ETL phát hiện bản ghi mới hoặc phát hiện thuộc tính thay đổi. |
| 5 | EXP_DATE | Thời điểm hết hiệu lực của phiên bản, để trống là bản ghi hiện hành | DATE |  | N |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Thời điểm hết hiệu lực của phiên bản, kiểu DATE. NULL = bản ghi hiện hành. Khi đóng thì gán :P_DATE - INTERVAL '1' SECOND, tức 23:59:59 của ngày hôm trước, để khoảng hiệu lực của bản cũ và bản mới nối liền nhau, không hở và không chồng lấn. Đóng trong hai trường hợp: thuộc tính thay đổi, hoặc bản ghi bị gỡ khỏi nguồn. |
