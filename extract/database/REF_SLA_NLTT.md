# REF_SLA_NLTT

Nguồn: docx "Design_Database_PDTD_DTM_v1.0_20260908.docx"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | REF_PRODUCT | NVARCHAR2 | Y | 200 | UK | Nhóm sản phẩm dùng để tra cam kết SLA |
| 2 | PRODUCT_LINE | NVARCHAR2 | Y | 200 | UK | Dòng sản phẩm |
| 3 | POLICY | NVARCHAR2 | N | 200 | UK | Chính sách tín dụng áp dụng cho hồ sơ |
| 4 | SUB_PRODUCT | NVARCHAR2 | N | 200 | UK | Sản phẩm nhánh |
| 5 | NEW_CHANGE_REQUEST | NVARCHAR2 | Y | 200 | UK | Loại yêu cầu, ví dụ New cho hồ sơ mới |
| 6 | SLA_DE_RESULT | NUMBER | N | 10,2 |  | Kết quả SLA của Chuyên viên nhập liệu |
| 7 | SLA_QC_RESULT | NUMBER | N | 10,2 |  | Kết quả SLA của Kiểm soát nhập liệu |
| 8 | SLA_DE_TOTAL_RESULT | NUMBER | N | 10,2 |  | Kết quả SLA của Nhập liệu tập trung |
| 9 | QD_DDE | NUMBER | N | 10,2 |  | Điểm quy đổi bước DetailDataEntry |
| 10 | QD_QC | NUMBER | N | 10,2 |  | Điểm quy đổi bước DataInputerChecker |
| 11 | SYSTEM_CODE | VARCHAR2 | Y | 10 | UK | Hệ nguồn của bản ghi, CLOS hoặc RLOS |
