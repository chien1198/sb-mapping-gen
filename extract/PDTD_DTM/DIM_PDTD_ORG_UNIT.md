# DIM_PDTD_ORG_UNIT

Nguồn: xlsx sheet "DIM_PDTD_ORG_UNIT" (DATAMODEL_DTM_PDTD_20260908.xlsx)

- Loại bảng: DIM - danh mục
- Mô tả: Đơn vị kinh doanh, có thêm khu vực lấy từ bảng map.
- Lưu gì: Lưu mã và tên phòng giao dịch, chi nhánh và khu vực, kèm cờ loại trừ khỏi chỉ tiêu KPI.
- Grain: 1 dòng = 1 đơn vị
- Khóa: DIMENSION_KEY (kế thừa từ DWH). NK = COMPANY_CODE Có thêm cột ORG_UNIT_SK mang đúng giá trị DIMENSION_KEY theo quy chuẩn đặt tên sẵn có.
- Nguồn: DWH.DIM_LOS_ORG_UNIT + TMP_REF_COMPANY_REGION_KHCN / TMP_REF_COMPANY_REGION_KHDN
- Báo cáo sử dụng: BC1, BC2, BC9, BC10, BC11
- Quy tắc load: Bê 1:1 từ DWH.DIM_LOS_ORG_UNIT, GIỮ NGUYÊN DIMENSION_KEY và cặp EFF_DATE/EXP_DATE, KHÔNG sinh sequence mới và KHÔNG tự tính lại ngày hiệu lực ở DTM — toàn bộ logic SCD2 đã chạy xong ở tầng DWH, xem Quy tắc load của DIM_LOS_ORG_UNIT. Sau khi bê thì LEFT JOIN bảng map để bổ sung cột chuẩn hóa; mọi join vào bảng map phải là 1:1 hoặc 1:0, join làm nhân dòng là lỗi và phải chặn bằng kiểm tra chất lượng. Bản hiện hành là EXP_DATE IS NULL.

| STT | Tên cột | Ý nghĩa | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng/cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | Khóa tự sinh của bảng chiều | NUMBER | 18 | Y | PK | KỸ THUẬT | 1:1 từ DWH.DIM_LOS_ORG_UNIT.DIMENSION_KEY |  | DA_CHOT | KỸ THUẬT — Khóa chính. GIỮ NGUYÊN DIMENSION_KEY CỦA DWH, không sinh sequence mới và không lookup lại. Chỉ chiều thực sự mới, không có chiều nguồn tương ứng, mới sinh key riêng. |
| 2 | ORG_UNIT_SK | Khóa tự sinh của bảng chiều, trùng giá trị với DIMENSION_KEY | NUMBER | 18 | Y |  | KỸ THUẬT | Bằng đúng DIMENSION_KEY của chính bảng này | — | DA_CHOT | KỸ THUẬT — Khóa tự sinh của bảng chiều DIM_PDTD_ORG_UNIT, giá trị BẰNG ĐÚNG DIMENSION_KEY của cùng dòng. Sinh thêm theo quy chuẩn đặt tên sẵn có: mỗi bảng chiều mang một cột khóa đặt theo tên thực thể. KHÔNG sinh sequence riêng và KHÔNG tự đánh số — luôn gán bằng DIMENSION_KEY, nếu không hai cột lệch nhau thì fact join vào đâu cũng sai. |
| 3 | COMPANY_CODE | Mã đơn vị kinh doanh | VARCHAR2 | 50 | Y |  | 1:1 + NK | 1:1 từ DWH.DIM_LOS_ORG_UNIT.COMPANY_CODE | BC1.COMPANY_CODE; BC2.COMPANY_CODE | DA_CHOT | Mã phòng giao dịch, khóa tự nhiên |
| 4 | COMPANY_NAME | Tên đơn vị kinh doanh | VARCHAR2 | 200 | N |  | 1:1 | 1:1 từ DWH.DIM_LOS_ORG_UNIT.COMPANY_NAME | BC1.COMPANY_NAME; BC2.COMPANY_NAME | DA_CHOT | Tên phòng giao dịch. Trường COMPANY_NAME của BC1, BC2, BC10, BC11 |
| 5 | BRANCH_CODE | Mã chi nhánh | VARCHAR2 | 50 | N |  | 1:1 | 1:1 từ DWH.DIM_LOS_ORG_UNIT.BRANCH_CODE | BC1.BRANCH_CODE; BC2.BRANCH_CODE | DA_CHOT | Mã chi nhánh |
| 6 | BRANCH_NAME | Tên chi nhánh | VARCHAR2 | 200 | N |  | 1:1 | 1:1 từ DWH.DIM_LOS_ORG_UNIT.BRANCH_NAME | BC1.BRANCH_NAME; BC2.BRANCH_NAME | DA_CHOT | Tên chi nhánh. Trường BRANCH_NAME của BC1, BC2, BC10, BC11 |
| 7 | ZONE_NAME_LOS | Tên khu vực theo LOS | VARCHAR2 | 100 | N |  | 1:1 | 1:1 từ DWH.DIM_LOS_ORG_UNIT.ZONE_NAME_LOS | BC1.ZONE; BC2.ZONE | DA_CHOT | Khu vực THEO CÁCH LOS GHI. Trường ZONE của BC1 và BC2 |
| 8 | EFF_DATE | Ngày bắt đầu hiệu lực của phiên bản bản ghi | DATE |  | Y |  | KỸ THUẬT | 1:1 từ DWH.DIM_LOS_ORG_UNIT.EFF_DATE |  | DA_CHOT | KỸ THUẬT — Ngày bắt đầu hiệu lực của phiên bản bản ghi, kiểu DATE. Bằng :P_DATE tức 00:00:00 của ngày ETL phát hiện bản ghi mới hoặc phát hiện thuộc tính thay đổi. |
| 9 | EXP_DATE | Thời điểm hết hiệu lực của phiên bản, để trống là bản ghi hiện hành | DATE |  | N |  | KỸ THUẬT | 1:1 từ DWH.DIM_LOS_ORG_UNIT.EXP_DATE |  | DA_CHOT | KỸ THUẬT — Thời điểm hết hiệu lực của phiên bản, kiểu DATE. NULL = bản ghi hiện hành. Khi đóng thì gán :P_DATE - INTERVAL '1' SECOND, tức 23:59:59 của ngày hôm trước, để khoảng hiệu lực của bản cũ và bản mới nối liền nhau, không hở và không chồng lấn. Đóng trong hai trường hợp: thuộc tính thay đổi, hoặc bản ghi bị gỡ khỏi nguồn. |
