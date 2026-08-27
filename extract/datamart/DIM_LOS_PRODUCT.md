# DIM_LOS_PRODUCT

Nguồn: xlsx sheet "DIM_LOS_PRODUCT" (DATAMODEL_DWH_LOS_20260826.xlsx)

- Loại bảng: DIM - danh mục
- Mô tả: Danh mục sản phẩm tín dụng hợp nhất CLOS/RLOS. Một sản phẩm chỉ có một danh tính trong phạm vi hệ nguồn; vai trò sản phẩm chính hay sản phẩm phụ được xác định tại quan hệ với hồ sơ, không nhân đôi dimension.
- Lưu gì: Lưu mã/tên dòng sản phẩm, sản phẩm nhánh và tên sản phẩm chi tiết dùng phân loại BC1, BC2, BC5, BC9. Không lưu PRODUCT_ROLE vì cùng một sản phẩm có thể đóng vai trò chính hoặc phụ ở các hồ sơ khác nhau.
- Grain: 1 dòng = 1 phiên bản của 1 sản phẩm theo hệ nguồn và bộ mã sản phẩm ổn định
- Khóa: DIMENSION_KEY (Oracle sequence). NK = PRODUCT_NK = SYSTEM_CODE + PRODUCT_LINE_CODE + SUB_PRODUCT_CODE + PRODUCT_NAME. UNIQUE (PRODUCT_NK, EFF_DATE).
- Nguồn: NG_SB_CLOS_MAS_PRO_LINE, NG_SB_CLOS_CUST_INFO, NG_SB_CLOS_EXTTABLE, NG_SB_RLOS_APPLICANT_GENERAL, NG_SB_RLOS_EXTTABLE, NG_SB_RLOS_SUB_PRODUCT
- Báo cáo sử dụng: BC1, BC2, BC5, BC9
- Quy tắc load: (chưa khai)

| STT | Tên cột | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng nguồn | Cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | 18 | Y | PK | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Khóa thay thế, sinh từ SEQ_DIM_LOS_PRODUCT. Mỗi DIM có sẵn một dòng Unknown với DIMENSION_KEY = -1 và các thuộc tính để 'N/A'; mọi lookup không khớp từ fact trỏ về dòng này thay vì để NULL, để phép đếm trên fact không bị hụt. |
| 2 | PRODUCT_NK | VARCHAR2 | 450 | Y |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Khóa tự nhiên do DWH ghép: SYSTEM_CODE || '|' || PRODUCT_LINE_CODE || '|' || SUB_PRODUCT_CODE || '|' || PRODUCT_NAME. CHỌN PHƯƠNG ÁN AN TOÀN, có PRODUCT_NAME trong khóa. Lý do: dimension này KHÔNG dựng từ một bảng danh mục sản phẩm thật, mà dựng bằng DISTINCT trên dữ liệu theo hồ sơ - PRODUCT_LINE và SUB_PRODUCT lấy từ NG_SB_CLOS_CUST_INFO / NG_SB_RLOS_APPLICANT_GENERAL, còn PRODUCT_NAME lấy từ NG_SB_CLOS_EXTTABLE / NG_SB_RLOS_EXTTABLE, đều là bảng theo hồ sơ. Chưa có gì bảo đảm cặp mã quyết định được tên. Nếu bỏ PRODUCT_NAME khỏi khóa mà thực tế một cặp mã ứng với nhiều tên, dimension sẽ có giá trị mâu thuẫn và SCD2 đẻ phiên bản mới mỗi lần gặp tên khác - lỗi này ÂM THẦM. Để tên trong khóa thì trường hợp xấu nhất là dư dòng dimension, lỗi này NHÌN THẤY ĐƯỢC và sửa được. BC9 phân loại sản phẩm bằng chính PRODUCT_NAME nên độ tin cậy của cột này là bắt buộc. Chạy DQ-13 trước khi chốt: nếu mỗi cặp mã chỉ ứng một tên thì có thể bỏ PRODUCT_NAME khỏi khóa sau. |
| 3 | SYSTEM_CODE | VARCHAR2 | 10 | Y |  | PHÁI SINH |  |  |  | DA_CHOT | PHÁI SINH — Hệ nguồn của sản phẩm, gán theo bảng mà giá trị được lấy ra: 'CLOS' hoặc 'RLOS'. Bắt buộc nằm trong khóa tự nhiên vì hai hệ dùng bộ mã sản phẩm khác nhau |
| 4 | PRODUCT_LINE_CODE | VARCHAR2 | 100 | N |  | 1:1 | NG_SB_CLOS_CUST_INFO / NG_SB_RLOS_APPLICANT_GENERAL | PRODUCT_LINE | BC1.PRODUCT_LINE; BC2.PRODUCT_LINE; (đầu vào BC5.REF_PRODUCT) | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_CUST_INFO.PRODUCT_LINE / NG_SB_RLOS_APPLICANT_GENERAL.PRODUCT_LINE (đổi tên thêm hậu tố CODE để phân biệt với tên). Trường PRODUCT_LINE của BC1 và BC2 |
| 5 | PRODUCT_LINE_NAME | VARCHAR2 | 200 | N |  | 1:1 | NG_SB_CLOS_MAS_PRO_LINE | PRODUCT_LINE | (đầu vào BC5.REF_PRODUCT phía CLOS) | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_MAS_PRO_LINE.PRODUCT_LINE, tra theo PRODUCT_LINE_CODE. Chỉ có phía CLOS; phía RLOS mã đã là tên nên gán bằng chính mã |
| 6 | SUB_PRODUCT_CODE | VARCHAR2 | 100 | N |  | 1:1 | NG_SB_CLOS_CUST_INFO / NG_SB_RLOS_APPLICANT_GENERAL | SUB_PRODUCT | BC1.SUB_PRODUCT; BC2.SUB_PRODUCT; (đầu vào BC5.REF_PRODUCT) | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_CUST_INFO.SUB_PRODUCT / NG_SB_RLOS_APPLICANT_GENERAL.SUB_PRODUCT (đổi tên thêm hậu tố CODE). Trường SUB_PRODUCT của BC1 và BC2 |
| 7 | PRODUCT_NAME | VARCHAR2 | 150 | N |  | 1:1 | NG_SB_CLOS_EXTTABLE / NG_SB_RLOS_EXTTABLE | PRODUCT_NAME | (đầu vào BC9.POINT, BC9.TAT_RLOS, BC9.BUSINESS_INCOM, BC9.SLHS_RLOS) | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_EXTTABLE.PRODUCT_NAME / NG_SB_RLOS_EXTTABLE.PRODUCT_NAME. Giữ nguyên tên. Metadata mô tả là tên sản phẩm vay, ĐẦY ĐỦ HƠN SUB_PRODUCT bên bảng thông tin hồ sơ. BC9 dùng chính cột này ở BỐN chỗ: tra điểm POINT theo file BC5TAT, gắn cờ SEC/UNSEC khi tính TAT, loại SeAPro và SeALand khỏi BUSINESS_INCOM, và loại sản phẩm nhanh khỏi SLHS_RLOS |
| 8 | EFF_DATE | DATE |  | Y |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Ngày bắt đầu hiệu lực của phiên bản bản ghi. Do ETL sinh khi phát hiện thuộc tính thay đổi |
| 9 | EXP_DATE | DATE |  | N |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Ngày hết hiệu lực của phiên bản. NULL = bản ghi hiện hành |
