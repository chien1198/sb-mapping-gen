# RLOS_REF_SLA_TDKHCN

Nguồn: docx section "4.5.6 Bảng RLOS_REF_SLA_TDKHCN"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | REF_PRODUCT | NVARCHAR2 | Y | 200 | UK | Nhóm sản phẩm dùng để tra cam kết SLA |
| 2 | PRODUCT_LINE | NVARCHAR2 | Y | 200 | UK | Dòng sản phẩm |
| 3 | CHANGE_TYPE | NVARCHAR2 | N | 200 | UK | Loại thay đổi điều kiện phê duyệt |
| 4 | DEVIATION_G3 | VARCHAR2 | N | 10 | UK | Hồ sơ có từ 3 ngoại lệ chính sách trở lên |
| 5 | SECONDARY_PRODUCTLINE | VARCHAR2 | N | 10 | UK | Sản phẩm phụ đi kèm |
| 6 | SLA_CREDIT_OFFICER | NUMBER | N | 10,2 |  | Cam kết giờ cho chuyên viên tín dụng |
| 7 | SLA_MARKER | NUMBER | N | 10,2 |  | Cam kết giờ cho bước lập hồ sơ thẩm định |
| 8 | SLA_CHECKER | NUMBER | N | 10,2 |  | Cam kết giờ cho bước kiểm soát thẩm định |
| 9 | SLA_CREDIT_APPROVER | NUMBER | N | 10,2 |  | Cam kết giờ cho cấp phê duyệt |
| 10 | APP_GRP | NVARCHAR2 | Y | 200 | UK | Cấp thẩm quyền áp dụng, ví dụ CGPD cấp B,C (B1, B2, C1, C2) |
