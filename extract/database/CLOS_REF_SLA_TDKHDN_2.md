# CLOS_REF_SLA_TDKHDN_2

Nguồn: docx section "4.5.8 Bảng CLOS_REF_SLA_TDKHDN_2"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | REF_PRODUCT | NVARCHAR2 | Y | 200 | UK | Nhóm sản phẩm dùng để tra cam kết SLA |
| 2 | PRODUCT_LINE | NVARCHAR2 | Y | 200 | UK | Dòng sản phẩm |
| 3 | SUB_PRODUCT | NVARCHAR2 | N | 200 | UK | Sản phẩm nhánh |
| 4 | HAVE_ANY_DEVIATION | NVARCHAR2 | Y | 200 | UK | Cờ hạn mức có ngoại lệ/độ lệch so với chính sách chuẩn không — chỉ 2 giá trị |
| 5 | SLA_CREDIT_OFFICER | NUMBER | N | 10,2 |  | Cam kết giờ cho chuyên viên tín dụng |
| 6 | SLA_MARKER | NUMBER | N | 10,2 |  | Cam kết giờ cho bước lập hồ sơ thẩm định |
| 7 | SLA_CHECKER | NUMBER | N | 10,2 |  | Cam kết giờ cho bước kiểm soát thẩm định |
| 8 | SLA_CREDIT_APPROVER | NUMBER | N | 10,2 |  | Cam kết giờ cho cấp phê duyệt |
| 9 | FLAG_APP_GRP | NVARCHAR2 | Y | 200 | UK | Cấp thẩm quyền áp dụng, ví dụ CGPD (A1, A2, B1, B2) |
