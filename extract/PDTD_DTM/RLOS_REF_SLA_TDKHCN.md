# RLOS_REF_SLA_TDKHCN

Nguồn: xlsx sheet "RLOS_REF_SLA_TDKHCN" (DATAMODEL_DTM_PDTD_20260908.xlsx)

- Loại bảng: REF - cam kết SLA
- Mô tả: Bảng cam kết SLA cho luồng khách hàng cá nhân của hệ RLOS.
- Lưu gì: Cam kết giờ của bốn vai trò xử lý, theo tổ hợp sản phẩm, loại thay đổi, tình trạng ngoại lệ và cấp thẩm quyền.
- Grain: 1 dòng = 1 tổ hợp REF_PRODUCT + PRODUCT_LINE + CHANGE_TYPE + DEVIATION_G3 + SECONDARY_PRODUCTLINE + APP_GRP
- Khóa: UNIQUE UK_RLOS_REF_SLA_TDKHCN trên 6 cột của grain
- Nguồn: MAP_TABLE/BC5TAT.xlsx sheet RLOS_REF_SLA_TDKHCN. Bảng vật lý tạo trên schema PDTD_DTM.
- Báo cáo sử dụng: BC5, BC9
- Quy tắc load: Nạp toàn bộ từ BC5TAT.xlsx sheet RLOS_REF_SLA_TDKHCN, 285 dòng dữ liệu. Tra cam kết theo PROCESSED_DATE của hồ sơ nếu bảng có hiệu lực theo thời gian.

| STT | Tên cột | Ý nghĩa | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng/cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | REF_PRODUCT | Nhóm sản phẩm dùng để tra cam kết SLA | NVARCHAR2 | 200 | Y | UK | 1:1 | file.REF_PRODUCT | BC5.REF_PRODUCT | DA_CHOT | Nhóm sản phẩm dùng để tra cam kết, ví dụ Unsecured_CreditCard, Unsecured-loan |
| 2 | PRODUCT_LINE | Dòng sản phẩm | NVARCHAR2 | 200 | Y | UK | 1:1 | file.Product_Line | BC1.PRODUCT_LINE; BC2.PRODUCT_LINE | DA_CHOT | Dòng sản phẩm theo cách LOS hiển thị, ví dụ SeAHome-TTD, SeAHome-Buy |
| 3 | CHANGE_TYPE | Loại thay đổi điều kiện phê duyệt | NVARCHAR2 | 200 | N | UK | 1:1 | file.Change_Type | BC1.CHANGE_TYPE; BC2.CHANGE_TYPE | DA_CHOT | Loại thay đổi điều kiện phê duyệt. Để trống nghĩa là áp cho mọi loại thay đổi |
| 4 | DEVIATION_G3 | Hồ sơ có từ 3 ngoại lệ chính sách trở lên | VARCHAR2 | 10 | N | UK | 1:1 | file.DEVIATION_G3 | BC9.DEVIATION_G3 | DA_CHOT | Hồ sơ có từ 3 ngoại lệ trở lên hay không. Để trống nghĩa là áp cho mọi tình trạng |
| 5 | SECONDARY_PRODUCTLINE | Sản phẩm phụ đi kèm | VARCHAR2 | 10 | N | UK | 1:1 | file.SECONDARY_PRODUCTLINE | BC1.SECONDARY_PRODUCTLINE | DA_CHOT | Hồ sơ có sản phẩm phụ đi kèm hay không. Để trống nghĩa là áp cho mọi trường hợp |
| 6 | SLA_CREDIT_OFFICER | Cam kết giờ cho chuyên viên tín dụng | NUMBER | 10,2 | N |  | 1:1 | file.SLA_CREDIT_OFFICER | BC5.SLA_CREDIT_OFFICER | DA_CHOT | Cam kết giờ cho chuyên viên tín dụng, ĐƠN VỊ GIỜ |
| 7 | SLA_MARKER | Cam kết giờ cho bước lập hồ sơ thẩm định | NUMBER | 10,2 | N |  | 1:1 | file.SLA_MARKER | BC5.SLA_MARKER | DA_CHOT | Cam kết giờ cho bước lập hồ sơ thẩm định, ĐƠN VỊ GIỜ |
| 8 | SLA_CHECKER | Cam kết giờ cho bước kiểm soát thẩm định | NUMBER | 10,2 | N |  | 1:1 | file.SLA_CHECKER | BC5.SLA_CHECKER | DA_CHOT | Cam kết giờ cho bước kiểm soát thẩm định, ĐƠN VỊ GIỜ |
| 9 | SLA_CREDIT_APPROVER | Cam kết giờ cho cấp phê duyệt | NUMBER | 10,2 | N |  | 1:1 | file.SLA_CREDIT_APPROVER | BC5.SLA_CREDIT_APPROVER | DA_CHOT | Cam kết giờ cho cấp phê duyệt, ĐƠN VỊ GIỜ |
| 10 | APP_GRP | Cấp thẩm quyền áp dụng, ví dụ CGPD cấp B,C | NVARCHAR2 | 200 | Y | UK | 1:1 | file.APP_GRP | BC1.APP_GRP; BC2.APP_GRP | DA_CHOT | Cấp thẩm quyền áp dụng, ví dụ CGPD cấp B,C (B1, B2, C1, C2) |
