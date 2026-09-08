# DIM_PDTD_WORKSTEP

Nguồn: xlsx sheet "DIM_PDTD_WORKSTEP" (DATAMODEL_DTM_PDTD_20260908.xlsx)

- Loại bảng: DIM - danh mục
- Mô tả: Bảng lưu thông tin các bước xử lý trong quy trình phê duyệt hồ sơ tín dụng.
- Lưu gì: Mã bước, tên bước chuẩn hóa, giai đoạn và cờ thuộc phạm vi Khối PDTD. KHÔNG chứa quyết định: quyết định là chiều riêng DIM_PDTD_DECISION, fact giữ cả WORKSTEP_SK lẫn DECISION_SK.
- Grain: 1 dòng = 1 hệ nguồn x 1 bước xử lý
- Khóa: PK = DIMENSION_KEY (Oracle sequence). UNIQUE (DATASOURCE, WORKSTEP_CODE, EFF_DATE) — dùng thẳng tổ hợp cột tự nhiên, KHÔNG sinh cột WORKSTEP_NK ghép chuỗi: các cột thành phần đã có sẵn trên bảng nên cột ghép chỉ nhân bản dữ liệu và phải giữ đồng bộ. Kế thừa DIMENSION_KEY từ DWH. Có thêm cột WORKSTEP_SK mang đúng giá trị DIMENSION_KEY theo quy chuẩn đặt tên sẵn có.
- Nguồn: DWH.DIM_LOS_WORKSTEP + DWH.DIM_LOS_DECISION + Q_RLOS_REF_WORKSTEP_2SYSTEMS
- Báo cáo sử dụng: BC1, BC2, BC3, BC4, BC5, BC7, BC8, BC9
- Quy tắc load: Bê 1:1 từ DWH.DIM_LOS_WORKSTEP, GIỮ NGUYÊN DIMENSION_KEY và cặp EFF_DATE/EXP_DATE, KHÔNG sinh sequence mới và KHÔNG tự tính lại ngày hiệu lực ở DTM — toàn bộ logic SCD2 đã chạy xong ở tầng DWH, xem Quy tắc load của DIM_LOS_WORKSTEP. Sau khi bê thì LEFT JOIN bảng map để bổ sung cột chuẩn hóa; mọi join vào bảng map phải là 1:1 hoặc 1:0, join làm nhân dòng là lỗi và phải chặn bằng kiểm tra chất lượng. Bản hiện hành là EXP_DATE IS NULL.

| STT | Tên cột | Ý nghĩa | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng/cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | Khóa tự sinh của bảng chiều | NUMBER | 18 | Y | PK | KỸ THUẬT | 1:1 từ DWH.DIM_LOS_WORKSTEP.DIMENSION_KEY |  | DA_CHOT | KỸ THUẬT — Khóa chính. GIỮ NGUYÊN DIMENSION_KEY CỦA DWH, không sinh sequence mới và không lookup lại. Chỉ chiều thực sự mới, không có chiều nguồn tương ứng, mới sinh key riêng. |
| 2 | WORKSTEP_SK | Khóa tự sinh của bảng chiều, trùng giá trị với DIMENSION_KEY | NUMBER | 18 | Y |  | KỸ THUẬT | Bằng đúng DIMENSION_KEY của chính bảng này | — | DA_CHOT | KỸ THUẬT — Khóa tự sinh của bảng chiều DIM_PDTD_WORKSTEP, giá trị BẰNG ĐÚNG DIMENSION_KEY của cùng dòng. Sinh thêm theo quy chuẩn đặt tên sẵn có: mỗi bảng chiều mang một cột khóa đặt theo tên thực thể. KHÔNG sinh sequence riêng và KHÔNG tự đánh số — luôn gán bằng DIMENSION_KEY, nếu không hai cột lệch nhau thì fact join vào đâu cũng sai. |
| 3 | DATASOURCE | Hệ nguồn của bản ghi: CLOS hoặc RLOS | VARCHAR2 | 10 | Y |  | 1:1 | 1:1 từ DWH.DIM_LOS_WORKSTEP.DATASOURCE |  | DA_CHOT | RLOS hoặc CLOS |
| 4 | WORKSTEP_CODE | Mã bước xử lý trên workflow | VARCHAR2 | 200 | Y |  | 1:1 | 1:1 từ DWH.DIM_LOS_WORKSTEP.WORKSTEP_CODE | BC3.WORKSTEP; BC4.WORKSTEP; BC8.WORKSTEP | DA_CHOT | Tên bước theo LOS. Trường WORKSTEP của BC3 và BC8 |
| 5 | IS_PDTD_STEP | Bước có thuộc phạm vi Khối PDTD hay không | VARCHAR2 | 1 | N |  | PHÁI SINH | Tính ở DTM | (đầu vào BC9.NHAN_SU và BC9.NSLD) | DA_CHOT | 'Y' nếu bước thuộc phạm vi Khối PDTD. Rule ở 00_Rule_nghiep_vu ở file model DWH (workbook DWH_LOS) Đầu vào để lọc các bước thuộc phạm vi Khối khi đếm nhân sự cho BC9. |
| 6 | EFF_DATE | Ngày bắt đầu hiệu lực của phiên bản bản ghi | DATE |  | Y |  | KỸ THUẬT | 1:1 từ DWH.DIM_LOS_WORKSTEP.EFF_DATE |  | DA_CHOT | KỸ THUẬT — Ngày bắt đầu hiệu lực của phiên bản bản ghi, kiểu DATE. Bằng :P_DATE tức 00:00:00 của ngày ETL phát hiện bản ghi mới hoặc phát hiện thuộc tính thay đổi. |
| 7 | EXP_DATE | Thời điểm hết hiệu lực của phiên bản, để trống là bản ghi hiện hành | DATE |  | N |  | KỸ THUẬT | 1:1 từ DWH.DIM_LOS_WORKSTEP.EXP_DATE |  | DA_CHOT | KỸ THUẬT — Thời điểm hết hiệu lực của phiên bản, kiểu DATE. NULL = bản ghi hiện hành. Khi đóng thì gán :P_DATE - INTERVAL '1' SECOND, tức 23:59:59 của ngày hôm trước, để khoảng hiệu lực của bản cũ và bản mới nối liền nhau, không hở và không chồng lấn. Đóng trong hai trường hợp: thuộc tính thay đổi, hoặc bản ghi bị gỡ khỏi nguồn. |
