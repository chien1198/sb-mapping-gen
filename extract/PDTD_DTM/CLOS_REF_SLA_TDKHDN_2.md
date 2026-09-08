# CLOS_REF_SLA_TDKHDN_2

Nguồn: xlsx sheet "CLOS_REF_SLA_TDKHDN_2" (DATAMODEL_DTM_PDTD_20260908.xlsx)

- Loại bảng: REF - cam kết SLA
- Mô tả: Bảng cam kết SLA cho luồng khách hàng doanh nghiệp lớn của hệ CLOS, luồng 2.
- Lưu gì: Cam kết giờ của bốn vai trò xử lý, theo tổ hợp sản phẩm, sản phẩm nhánh, tình trạng ngoại lệ và cấp thẩm quyền.
- Grain: 1 dòng = 1 tổ hợp REF_PRODUCT + PRODUCT_LINE + SUB_PRODUCT + HAVE_ANY_DEVIATION + FLAG_APP_GRP
- Khóa: UNIQUE UK_CLOS_REF_SLA_TDKHDN_2 trên 5 cột của grain
- Nguồn: MAP_TABLE/BC5TAT.xlsx sheet CLOS_REF_SLA_TDKHDN_2. Bảng vật lý tạo trên schema PDTD_DTM.
- Báo cáo sử dụng: BC5, BC9
- Quy tắc load: Nạp toàn bộ từ BC5TAT.xlsx sheet CLOS_REF_SLA_TDKHDN_2, 36 dòng dữ liệu. CHỜ RULE BA: hai bảng TDKHDNL và TDKHDN_2 có CÙNG cấu trúc và cùng khóa nhưng dữ liệu khác nhau, chưa có quy tắc chọn dùng bảng nào cho hồ sơ nào.

| STT | Tên cột | Ý nghĩa | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng/cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | REF_PRODUCT | Nhóm sản phẩm dùng để tra cam kết SLA | NVARCHAR2 | 200 | Y | UK | 1:1 | file.REF_PRODUCT | BC5.REF_PRODUCT | DA_CHOT | Nhóm sản phẩm dùng để tra cam kết, ví dụ Cấp tín dụng món ngắn hạn, Hạn mức STK |
| 2 | PRODUCT_LINE | Dòng sản phẩm | NVARCHAR2 | 200 | Y | UK | 1:1 | file.Product_Line | BC1.PRODUCT_LINE; BC2.PRODUCT_LINE | DA_CHOT | Dòng sản phẩm, ví dụ Cấp tín dụng ngắn hạn, Hạn mức |
| 3 | SUB_PRODUCT | Sản phẩm nhánh | NVARCHAR2 | 200 | N | UK | 1:1 | file.Sub_Product | BC1.SUB_PRODUCT; BC2.SUB_PRODUCT | DA_CHOT | Sản phẩm nhánh, ví dụ Vay cầm cố GTCG theo món. Để trống nghĩa là áp cho mọi sản phẩm nhánh |
| 4 | HAVE_ANY_DEVIATION | Hồ sơ có ngoại lệ hay không | NVARCHAR2 | 200 | Y | UK | 1:1 | file.Have_any_deviation |  | DA_CHOT | Hồ sơ có ngoại lệ hay không. Giá trị quan sát được: Có, Không |
| 5 | SLA_CREDIT_OFFICER | Cam kết giờ cho chuyên viên tín dụng | NUMBER | 10,2 | N |  | 1:1 | file.SLA_CREDIT_OFFICER | BC5.SLA_CREDIT_OFFICER | DA_CHOT | Cam kết giờ cho chuyên viên tín dụng, ĐƠN VỊ GIỜ |
| 6 | SLA_MARKER | Cam kết giờ cho bước lập hồ sơ thẩm định | NUMBER | 10,2 | N |  | 1:1 | file.SLA_MARKER | BC5.SLA_MARKER | DA_CHOT | Cam kết giờ cho bước lập hồ sơ thẩm định, ĐƠN VỊ GIỜ |
| 7 | SLA_CHECKER | Cam kết giờ cho bước kiểm soát thẩm định | NUMBER | 10,2 | N |  | 1:1 | file.SLA_CHECKER | BC5.SLA_CHECKER | DA_CHOT | Cam kết giờ cho bước kiểm soát thẩm định, ĐƠN VỊ GIỜ |
| 8 | SLA_CREDIT_APPROVER | Cam kết giờ cho cấp phê duyệt | NUMBER | 10,2 | N |  | 1:1 | file.SLA_CREDIT_APPROVER | BC5.SLA_CREDIT_APPROVER | DA_CHOT | Cam kết giờ cho cấp phê duyệt, ĐƠN VỊ GIỜ |
| 9 | FLAG_APP_GRP | Cấp thẩm quyền áp dụng, ví dụ CGPD | NVARCHAR2 | 200 | Y | UK | 1:1 | file.FLAG_APP_GRP |  | DA_CHOT | Cấp thẩm quyền áp dụng, ví dụ CGPD (A1, A2, B1, B2) |
