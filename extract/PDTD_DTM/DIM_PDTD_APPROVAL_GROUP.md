# DIM_PDTD_APPROVAL_GROUP

Nguồn: xlsx sheet "DIM_PDTD_APPROVAL_GROUP" (DATAMODEL_DTM_PDTD_20260908.xlsx)

- Loại bảng: DIM - danh mục
- Mô tả: Cấp thẩm quyền phê duyệt tín dụng.
- Lưu gì: Lưu mã cấp phê duyệt kèm thứ tự cấp. BA đã cung cấp ý nghĩa đầy đủ: A1 đến C3 là các cấp chuyên gia phê duyệt độc lập theo thứ tự từ cao xuống thấp, BOD là Hội đồng quản trị, CC là Hội đồng tín dụng, SCC là Ủy ban tín dụng, RCC là Hội đồng tín dụng cấp vùng, DEBTCC là Hội đồng tín dụng chuyên trách xử lý nợ.
- Grain: 1 dòng = 1 cấp thẩm quyền của 1 hệ nguồn
- Khóa: PK = DIMENSION_KEY (Oracle sequence). UNIQUE (DATASOURCE, APP_GRP_CODE, EFF_DATE) — dùng thẳng tổ hợp cột tự nhiên, KHÔNG sinh cột APPROVAL_GROUP_NK ghép chuỗi: các cột thành phần đã có sẵn trên bảng nên cột ghép chỉ nhân bản dữ liệu và phải giữ đồng bộ. Kế thừa DIMENSION_KEY từ DWH. Có thêm cột APPROVAL_GROUP_SK mang đúng giá trị DIMENSION_KEY theo quy chuẩn đặt tên sẵn có.
- Nguồn: DWH.DIM_LOS_APPROVAL_GROUP
- Báo cáo sử dụng: BC1, BC2, BC5, BC9
- Quy tắc load: Bê 1:1 từ DWH.DIM_LOS_APPROVAL_GROUP, GIỮ NGUYÊN DIMENSION_KEY và cặp EFF_DATE/EXP_DATE, KHÔNG sinh sequence mới và KHÔNG tự tính lại ngày hiệu lực ở DTM — toàn bộ logic SCD2 đã chạy xong ở tầng DWH, xem Quy tắc load của DIM_LOS_APPROVAL_GROUP. Sau khi bê thì LEFT JOIN bảng map để bổ sung cột chuẩn hóa; mọi join vào bảng map phải là 1:1 hoặc 1:0, join làm nhân dòng là lỗi và phải chặn bằng kiểm tra chất lượng. Bản hiện hành là EXP_DATE IS NULL.

| STT | Tên cột | Ý nghĩa | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng/cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | Khóa tự sinh của bảng chiều | NUMBER | 18 | Y | PK | KỸ THUẬT | 1:1 từ DWH.DIM_LOS_APPROVAL_GROUP.DIMENSION_KEY |  | DA_CHOT | KỸ THUẬT — Khóa chính. GIỮ NGUYÊN DIMENSION_KEY CỦA DWH, không sinh sequence mới và không lookup lại. Chỉ chiều thực sự mới, không có chiều nguồn tương ứng, mới sinh key riêng. |
| 2 | APPROVAL_GROUP_SK | Khóa tự sinh của bảng chiều, trùng giá trị với DIMENSION_KEY | NUMBER | 18 | Y |  | KỸ THUẬT | Bằng đúng DIMENSION_KEY của chính bảng này | — | DA_CHOT | KỸ THUẬT — Khóa tự sinh của bảng chiều DIM_PDTD_APPROVAL_GROUP, giá trị BẰNG ĐÚNG DIMENSION_KEY của cùng dòng. Sinh thêm theo quy chuẩn đặt tên sẵn có: mỗi bảng chiều mang một cột khóa đặt theo tên thực thể. KHÔNG sinh sequence riêng và KHÔNG tự đánh số — luôn gán bằng DIMENSION_KEY, nếu không hai cột lệch nhau thì fact join vào đâu cũng sai. |
| 3 | DATASOURCE | Hệ nguồn của bản ghi: CLOS hoặc RLOS | VARCHAR2 | 10 | Y |  | 1:1 | 1:1 từ DWH.DIM_LOS_APPROVAL_GROUP.DATASOURCE |  | DA_CHOT | RLOS hoặc CLOS |
| 4 | APP_GRP_CODE | Mã cấp thẩm quyền phê duyệt | VARCHAR2 | 100 | N |  | 1:1 | 1:1 từ DWH.DIM_LOS_APPROVAL_GROUP.APP_GRP_CODE | BC1.APP_GRP; BC2.APP_GRP; (khóa tra BC5.SLA_*, BC9.POINT) | DA_CHOT | Mã cấp thẩm quyền. Trường APP_GRP của BC1 |
| 5 | APPROVAL_LEVEL | Thứ tự cấp phê duyệt, số nhỏ là cấp cao | NUMBER | 3 | N |  | PHÁI SINH | 1:1 từ DWH.DIM_LOS_APPROVAL_GROUP.APPROVAL_LEVEL | (đầu vào BC5.REF_PRODUCT) | DA_CHOT | Thứ tự cấp phê duyệt theo giải thích của BA, số nhỏ là cấp cao: A1=1, A2=2, B1=3, B2=4, C1=5, C2=6, C3=7; các hội đồng nhận giá trị riêng. BC5 gom nhóm 'CGPD cấp B, C' bằng khoảng giá trị thay vì liệt kê mã |
| 6 | EFF_DATE | Ngày bắt đầu hiệu lực của phiên bản bản ghi | DATE |  | Y |  | KỸ THUẬT | 1:1 từ DWH.DIM_LOS_APPROVAL_GROUP.EFF_DATE |  | DA_CHOT | KỸ THUẬT — Ngày bắt đầu hiệu lực của phiên bản bản ghi, kiểu DATE. Bằng :P_DATE tức 00:00:00 của ngày ETL phát hiện bản ghi mới hoặc phát hiện thuộc tính thay đổi. |
| 7 | EXP_DATE | Thời điểm hết hiệu lực của phiên bản, để trống là bản ghi hiện hành | DATE |  | N |  | KỸ THUẬT | 1:1 từ DWH.DIM_LOS_APPROVAL_GROUP.EXP_DATE |  | DA_CHOT | KỸ THUẬT — Thời điểm hết hiệu lực của phiên bản, kiểu DATE. NULL = bản ghi hiện hành. Khi đóng thì gán :P_DATE - INTERVAL '1' SECOND, tức 23:59:59 của ngày hôm trước, để khoảng hiệu lực của bản cũ và bản mới nối liền nhau, không hở và không chồng lấn. Đóng trong hai trường hợp: thuộc tính thay đổi, hoặc bản ghi bị gỡ khỏi nguồn. |
