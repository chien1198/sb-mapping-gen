# BC3 — SRS extract (nguồn: input/srs_report/BC3_PDTD_DTM_SRS_v1.0.docx)

> Auto-extracted. Dùng để đối chiếu logic SRS (STG_LOS -> báo cáo) với LLD (STG_LOS -> SB_DWH -> STG_DTM -> PDTD_DTM -> báo cáo).

## Use case

- **Tên**: Báo cáo Thông tin phê duyệt
- **Mô tả**: Báo cáo cung cấp các thông tin chung của hồ sơ được phê duyệt (đồng ý/ từ chối) qua Khối PDTD
- **Tác nhân**: Hệ thống BI
- **Trigger**: 
- **Điều kiện trước**: 
- **Điều kiện sau**: User chọn được tham số và xuất báo cáo hiển thị theo đúng yêu cầu

## Business Rules

- **Hoạt động**: Mã BR | Mô tả
- ****: BR 1.1 | Đầu vào: Ngày báo cáo: Cho phép chọn Ngày báo cáo (EXITDATE). Mặc định hiển thị là ngày dữ liệu hiện tại (T-1) Chi nhánh: Cho phép chọn mã chi nhánh (Không bắt buộc). Mặc định hiển thị là Tất cả chi nhánh
- ****: BR 1.2 | Các bảng sử dụng:
- ****: BR 1.3 | Đầu ra: Báo cáo hiển thị các trường thông tin sau:

## Bảng nguồn sử dụng & điều kiện Join (alias map)

> **Lưu ý quan trọng**: nếu có nhiều mục (section) dưới đây (vd. "Nguồn CLOS" / "Nguồn RLOS" / "KPI Khối (RLOS)" / "KPI Khối (CLOS)"), alias (a, b, c...) được TÁI SỬ DỤNG với Ý NGHĨA KHÁC NHAU ở mỗi section — không được tra alias xuyên section.

### Nguồn CLOS

| Alias | Bảng nguồn | Điều kiện Join |
|---|---|---|
| a | SBLOS2.NG_SB_CLOS_ENTRY_EXIT | WHERE a.WORKSTEP in ('CreditApproval',CreditCommittee') AND a.DECISION in ('Submit','Reject','Send to HOSupport,'Send to PostSanction') |
| b | SBLOS2.NG_SB_CLOS_APPROVAL | LEFT JOIN với điều kiện: a.WINAME = b.WI_NAME |
| c | SBLOS2.NG_SB_CLOS_CUST_INFO | LEFT JOIN với điều kiện: a.WINAME = c.WI_NAME |
| d | SBLOS2.NG_SB_CLOS_EXTTABLE | LEFT JOIN với điều kiện: a.WINAME = d.WI_NAME |
| e | SBLOS2.NG_SB_CLOS_CREDITINFO_COMM | LEFT JOIN với điều kiện: a.WINAME = e.WI_NAME |
| f | SBLOS2.NG_SB_CLOS_COLL_CD | LEFT JOIN với điều kiện: a.WINAME = f.WI_NAME |

### Nguồn RLOS

| Alias | Bảng nguồn | Điều kiện Join |
|---|---|---|
| a | SBLOS2.NG_SB_RLOS_ENTRY_EXIT | WHERE a.WORKSTEP in ('CreditApproval',CreditCommittee') AND a.DECISION in ('Submit','Reject','Send to HOSupport,'Send to PostSanction') |
| b | SBLOS2.NG_SB_RLOS_APPROVAL | LEFT JOIN với điều kiện: a.WINAME = b.WI_NAME |
| c | SBLOS2.NG_SB_RLOS_APPLICANT_GENERAL | LEFT JOIN với điều kiện: a.WINAME = c.WI_NAME |
| d | SBLOS2.NG_SB_RLOS_EXTTABLE | LEFT JOIN với điều kiện: a.WINAME = d.WI_NAME |
| e | SBLOS2.NG_SB_RLOS_CREDIT_PROPOSAL | LEFT JOIN với điều kiện: a.WINAME = e.WI_NAME |
| f | SBLOS2.NG_SB_RLOS_COL_REALESTATE | LEFT JOIN với điều kiện: a.WINAME = f.WI_NAME |
| g | SBLOS2.NG_SB_RLOS_COL_TRANSPORT | LEFT JOIN với điều kiện: a.WINAME = g.WI_NAME |
| h | SBLOS2.NG_SB_RLOS_COL_VALPAPER | LEFT JOIN với điều kiện: a.WINAME = h.WI_NAME |
| i | SBLOS2.NG_SB_RLOS_COL_OTHER | LEFT JOIN với điều kiện: a.WINAME = i.WI_NAME |

## Danh sách trường báo cáo & logic lấy dữ liệu

| STT | Trường | Ý nghĩa | Cách lấy dữ liệu |
|---|---|---|---|
| Nguồn CLOS | Nguồn CLOS | Nguồn CLOS | Nguồn CLOS |
|  | SYSTEMNAME | Hệ thống (CLOS/RLOS) | 'CLOS' |
|  | STREAM | Luồng hồ sơ | NG_SB_CLOS_APPROVAL> STREAM |
|  | WINAME | Mã hồ sơ | NG_SB_CLOS_ENTRY_EXIT> WINAME |
|  | CUSTOMER_NAME | Tên khách hàng | NG_SB_CLOS_CUST_INFO> CUSTOMER_NAME |
|  | WORKSTEP | Bước hồ sơ | NG_SB_CLOS_ENTRY_EXIT> WORKSTEP |
|  | DECISION | Quyết định | NG_SB_CLOS_ENTRY_EXIT> DECISION |
|  | BI_APPROVER | User Chuyên gia phê duyệt | NG_SB_CLOS_ENTRY_EXIT> USERNAME Với điều kiện WORKSTEP = 'CreditApproval' |
|  | BI_COMMITTEE | User Hội đồng tín dụng | NG_SB_CLOS_ENTRY_EXIT> USERNAME Với điều kiện WORKSTEP = 'CreditCommittee' |
|  | ENTRYDATE | Thời gian lên bước phê duyệt | NG_SB_CLOS_ENTRY_EXIT> ENTRYDATE |
|  | EXITDATE | Ngày báo cáo /Thời gian kết thúc bước phê duyệt | NG_SB_CLOS_ENTRY_EXIT> EXITDATE |
|  | REMARKS | Ghi chú | NG_SB_CLOS_ENTRY_EXIT> REMARKS |
|  | CREDIT_LIMIT | Số tiền phê duyệt | NG_SB_CLOS_CREDITINFO_COMM> CREDIT_LIMIT |
|  | CURRENCY | Đơn vị tiền tệ | NG_SB_CLOS_CREDITINFO_COMM> CURRENCY |
|  | CREDIT_TERM | Thời hạn phê duyệt | NG_SB_CLOS_CREDITINFO_COMM> CREDIT_TERM |
|  | TYPES_OF_COLLATERALS | Loại TSBĐ | NG_SB_CLOS_COLL_CD> COLLTYPE |
|  | APPRAISED_VALUE | Giá trị định giá | NG_SB_CLOS_COLL_CD> APPRAISED_VAL_FIG |
|  | DESCRIPTION | Mô tả TSBĐ | NG_SB_CLOS_COLL_CD> DESCRIPTION |
|  | OWNER | Chủ TSBĐ | NG_SB_CLOS_COLL_CD> COLL_OWNER |
|  | LTV | Tỷ lệ cho vay của TSBĐ | NG_SB_CLOS_COLL_CD> LTV |
|  | COLLATERA_MANAGEMENT | Phương thức quản lý TSBĐ | NG_SB_CLOS_COLL_CD> COLL_MGMT_APP |
| Nguồn RLOS | Nguồn RLOS | Nguồn RLOS | Nguồn RLOS |
|  | SYSTEMNAME | Hệ thống (CLOS/RLOS) | 'RLOS' |
|  | STREAM | Luồng hồ sơ | NG_SB_RLOS_APPROVAL> STEAM |
|  | WINAME | Mã hồ sơ | NG_SB_RLOS_ENTRY_EXIT> WINAME |
|  | CUSTOMER_NAME | Tên khách hàng | NG_SB_RLOS_APPLICANT_GENERAL> FULL_NAME |
|  | WORKSTEP | Bước hồ sơ | NG_SB_RLOS_ENTRY_EXIT> WORKSTEP |
|  | DECISION | Quyết định | NG_SB_RLOS_ENTRY_EXIT> DECISION |
|  | BI_APPROVER | User Chuyên gia phê duyệt | NG_SB_RLOS_ENTRY_EXIT> USERNAME Với điều kiện WORKSTEP = 'CreditApproval' |
|  | BI_COMMITTEE | User Hội đồng tín dụng | NG_SB_RLOS_ENTRY_EXIT> USERNAME Với điều kiện WORKSTEP = 'CreditCommittee' |
|  | ENTRYDATE | Thời gian lên bước phê duyệt | NG_SB_RLOS_ENTRY_EXIT> ENTRYDATE |
|  | EXITDATE | Ngày báo cáo /Thời gian kết thúc bước phê duyệt | NG_SB_RLOS_ENTRY_EXIT> EXITDATE |
|  | REMARKS | Ghi chú | NG_SB_RLOS_ENTRY_EXIT> REMARKS |
|  | CREDIT_LIMIT | Số tiền phê duyệt | NG_SB_RLOS_CREDIT_PROPOSAL> LOAN_AMOUNT |
|  | CURRENCY | Đơn vị tiền tệ | NG_SB_RLOS_CREDIT_PROPOSAL> LOAN_CURRENCY |
|  | CREDIT_TERM | Thời hạn phê duyệt | NG_SB_RLOS_CREDIT_PROPOSAL> LOAN_TERM |
|  | TYPES_OF_COLLATERALS | Loại TSBĐ | NG_SB_RLOS_COL_REALESTATE f> NG_SB_RLOS_COL_TRANSPORT g > NG_SB_RLOS_COL_VALPAPER h > NG_SB_RLOS_COL_OTHER i > Lấy UNION các giá trị của 4 bảng f.NO_CERTI; g.TYPE_VEHICLE;; h.TYPE1; i.DESCRIBE; |
|  | APPRAISED_VALUE | Giá trị định giá | NG_SB_RLOS_COL_REALESTATE f > NG_SB_RLOS_COL_TRANSPORT g > NG_SB_RLOS_COL_VALPAPER h > NG_SB_RLOS_COL_OTHER i > Lấy UNION giá trị trường PRICINGVALUE của 4 bảng |
|  | DESCRIPTION | Mô tả TSBĐ | NG_SB_RLOS_COL_REALESTATE f > NG_SB_RLOS_COL_TRANSPORT g > NG_SB_RLOS_COL_VALPAPER h > NG_SB_RLOS_COL_OTHER i > Lấy UNION các giá trị của 4 bảng: f.NO_CERTI // ', ' // f.USING_PURPOSE; g.BRAND // ', ' // g.CONTROL_POSTER; h.NUMBERSIGN; i.DESCRIBE; |
|  | OWNER | Chủ TSBĐ | NG_SB_RLOS_COL_REALESTATE f > NG_SB_RLOS_COL_TRANSPORT g > NG_SB_RLOS_COL_VALPAPER h > NG_SB_RLOS_COL_OTHER i > Lấy UNION giá trị trường OWNER của 4 bảng |
|  | LTV | Tỷ lệ cho vay của TSBĐ | NG_SB_RLOS_COL_REALESTATE f > NG_SB_RLOS_COL_TRANSPORT g > NG_SB_RLOS_COL_VALPAPER h > NG_SB_RLOS_COL_OTHER i > Lấy UNION giá trị trường LOANRATE của 4 bảng |
