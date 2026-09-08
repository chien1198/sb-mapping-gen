# DIM_PDTD_PRODUCT

Nguồn: xlsx sheet "DIM_PDTD_PRODUCT" (DATAMODEL_DTM_PDTD_20260908.xlsx)

- Loại bảng: DIM - danh mục
- Mô tả: Sản phẩm tín dụng, có thêm nhóm sản phẩm SLA và cam kết SLA nhập liệu lấy từ file nghiệp vụ.
- Lưu gì: Lưu mã/tên dòng sản phẩm, sản phẩm nhánh và tên sản phẩm chi tiết dùng phân loại BC1, BC2, BC5, BC9. Không lưu PRODUCT_ROLE vì cùng một sản phẩm có thể đóng vai trò chính hoặc phụ ở các hồ sơ khác nhau.
- Grain: 1 dòng = 1 sản phẩm theo hệ nguồn
- Khóa: PK = DIMENSION_KEY (Oracle sequence). UNIQUE (DATASOURCE, PRODUCT_LINE_CODE, SUB_PRODUCT_CODE, PRODUCT_NAME, EFF_DATE) — dùng thẳng tổ hợp cột tự nhiên, KHÔNG sinh cột PRODUCT_NK ghép chuỗi: các cột thành phần đã có sẵn trên bảng nên cột ghép chỉ nhân bản dữ liệu và phải giữ đồng bộ. Kế thừa DIMENSION_KEY từ DWH. Có thêm cột PRODUCT_SK mang đúng giá trị DIMENSION_KEY theo quy chuẩn đặt tên sẵn có.
- Nguồn: DWH.DIM_LOS_PRODUCT + RLOS_REF_SLA_TDKHCN + REF_SLA_NLTT
- Báo cáo sử dụng: BC1, BC2, BC5, BC9
- Quy tắc load: Bê 1:1 từ DWH.DIM_LOS_PRODUCT, GIỮ NGUYÊN DIMENSION_KEY và cặp EFF_DATE/EXP_DATE, KHÔNG sinh sequence mới và KHÔNG tự tính lại ngày hiệu lực ở DTM — toàn bộ logic SCD2 đã chạy xong ở tầng DWH, xem Quy tắc load của DIM_LOS_PRODUCT. Sau khi bê thì LEFT JOIN bảng map để bổ sung cột chuẩn hóa; mọi join vào bảng map phải là 1:1 hoặc 1:0, join làm nhân dòng là lỗi và phải chặn bằng kiểm tra chất lượng. Bản hiện hành là EXP_DATE IS NULL.

| STT | Tên cột | Ý nghĩa | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng/cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | Khóa tự sinh của bảng chiều | NUMBER | 18 | Y | PK | KỸ THUẬT | 1:1 từ DWH.DIM_LOS_PRODUCT.DIMENSION_KEY |  | DA_CHOT | KỸ THUẬT — Khóa chính. GIỮ NGUYÊN DIMENSION_KEY CỦA DWH, không sinh sequence mới và không lookup lại. Chỉ chiều thực sự mới, không có chiều nguồn tương ứng, mới sinh key riêng. |
| 2 | PRODUCT_SK | Khóa tự sinh của bảng chiều, trùng giá trị với DIMENSION_KEY | NUMBER | 18 | Y |  | KỸ THUẬT | Bằng đúng DIMENSION_KEY của chính bảng này | — | DA_CHOT | KỸ THUẬT — Khóa tự sinh của bảng chiều DIM_PDTD_PRODUCT, giá trị BẰNG ĐÚNG DIMENSION_KEY của cùng dòng. Sinh thêm theo quy chuẩn đặt tên sẵn có: mỗi bảng chiều mang một cột khóa đặt theo tên thực thể. KHÔNG sinh sequence riêng và KHÔNG tự đánh số — luôn gán bằng DIMENSION_KEY, nếu không hai cột lệch nhau thì fact join vào đâu cũng sai. |
| 3 | DATASOURCE | Hệ nguồn của bản ghi: CLOS hoặc RLOS | VARCHAR2 | 10 | Y |  | 1:1 | 1:1 từ DWH.DIM_LOS_PRODUCT.DATASOURCE |  | DA_CHOT | RLOS hoặc CLOS |
| 4 | PRODUCT_LINE_CODE | Mã dòng sản phẩm | VARCHAR2 | 100 | N |  | 1:1 | 1:1 từ DWH.DIM_LOS_PRODUCT.PRODUCT_LINE_CODE | BC1.PRODUCT_LINE; BC2.PRODUCT_LINE; (đầu vào BC5.REF_PRODUCT) | DA_CHOT | Dòng sản phẩm. Trường PRODUCT_LINE của BC1 và BC2 |
| 5 | SUB_PRODUCT_CODE | Mã sản phẩm nhánh | VARCHAR2 | 100 | N |  | 1:1 | 1:1 từ DWH.DIM_LOS_PRODUCT.SUB_PRODUCT_CODE | BC1.SUB_PRODUCT; BC2.SUB_PRODUCT; (đầu vào BC5.REF_PRODUCT) | DA_CHOT | Sản phẩm nhánh. Trường SUB_PRODUCT của BC1 và BC2 |
| 6 | PRODUCT_NAME | Tên sản phẩm | VARCHAR2 | 150 | N |  | 1:1 | 1:1 từ DWH.DIM_LOS_PRODUCT.PRODUCT_NAME | (đầu vào BC9.POINT, BC9.TAT_RLOS, BC9.BUSINESS_INCOM, BC9.SLHS_RLOS) | DA_CHOT | Tên sản phẩm chi tiết. BC9 phân loại bằng chính cột này |
| 7 | IS_CREDIT_CARD | Có phải sản phẩm thẻ tín dụng hay không | VARCHAR2 | 1 | N |  | CHƯA CHỐT | Tính ở DTM |  | CHO_RULE_BA | Có phải sản phẩm thẻ tín dụng hay không. CHỜ RULE BA: điều kiện nhóm thẻ hoặc sản phẩm nhanh của BC9 đang có dấu hiệu nhầm AND/OR trong SRS, phải chốt trước khi dùng để lọc. |
| 8 | IS_FAST_PRODUCT | Có thuộc nhóm sản phẩm giải ngân nhanh hay không | VARCHAR2 | 1 | N |  | CHƯA CHỐT | Tính ở DTM |  | CHO_RULE_BA | Có thuộc nhóm sản phẩm giải ngân nhanh hay không. CHỜ RULE BA: điều kiện nhóm thẻ hoặc sản phẩm nhanh của BC9 đang có dấu hiệu nhầm AND/OR trong SRS, phải chốt trước khi dùng để lọc. |
| 9 | PRODUCT_LINE_NAME | Tên dòng sản phẩm | VARCHAR2 | 200 | N |  | 1:1 | 1:1 từ DWH.DIM_LOS_PRODUCT.PRODUCT_LINE_NAME | (đầu vào BC5.REF_PRODUCT phía CLOS) | DA_CHOT | Nguồn: NG_SB_CLOS_MAS_PRO_LINE.PRODUCT_LINE, tra theo PRODUCT_LINE_CODE. Chỉ có phía CLOS; phía RLOS mã đã là tên nên gán bằng chính mã |
| 10 | EFF_DATE | Ngày bắt đầu hiệu lực của phiên bản bản ghi | DATE |  | Y |  | KỸ THUẬT | 1:1 từ DWH.DIM_LOS_PRODUCT.EFF_DATE |  | DA_CHOT | KỸ THUẬT — Ngày bắt đầu hiệu lực của phiên bản bản ghi, kiểu DATE. Bằng :P_DATE tức 00:00:00 của ngày ETL phát hiện bản ghi mới hoặc phát hiện thuộc tính thay đổi. |
| 11 | EXP_DATE | Thời điểm hết hiệu lực của phiên bản, để trống là bản ghi hiện hành | DATE |  | N |  | KỸ THUẬT | 1:1 từ DWH.DIM_LOS_PRODUCT.EXP_DATE |  | DA_CHOT | KỸ THUẬT — Thời điểm hết hiệu lực của phiên bản, kiểu DATE. NULL = bản ghi hiện hành. Khi đóng thì gán :P_DATE - INTERVAL '1' SECOND, tức 23:59:59 của ngày hôm trước, để khoảng hiệu lực của bản cũ và bản mới nối liền nhau, không hở và không chồng lấn. Đóng trong hai trường hợp: thuộc tính thay đổi, hoặc bản ghi bị gỡ khỏi nguồn. |
