# BC2 — SRS extract (nguồn: input/srs_report/BC2_PDTD_DTM_SRS_v1.0.docx)

> Auto-extracted. Dùng để đối chiếu logic SRS (STG_LOS -> báo cáo) với LLD (STG_LOS -> SB_DWH -> STG_DTM -> PDTD_DTM -> báo cáo).

## Use case

- **Tên**: Báo cáo CLOS APPLICATION
- **Mô tả**: Báo cáo cung cấp các thông tin chung của hồ sơ trình qua PDTD
- **Tác nhân**: Hệ thống BI
- **Trigger**: 
- **Điều kiện trước**: 
- **Điều kiện sau**: User chọn được tham số và xuất báo cáo hiển thị theo đúng yêu cầu

## Business Rules

- **Hoạt động**: Mã BR | Mô tả
- ****: BR 1.1 | Đầu vào: Ngày báo cáo: Cho phép chọn Ngày báo cáo (PROCESSED_DATE). Mặc định hiển thị là ngày dữ liệu hiện tại (T-1) Chi nhánh: Cho phép chọn mã chi nhánh (Không bắt buộc). Mặc định hiển thị là Tất cả chi nhánh
- ****: BR 1.2 | Các bảng sử dụng:
- ****: BR 1.3 | Đầu ra: Báo cáo hiển thị các trường thông tin sau:

## Bảng nguồn sử dụng & điều kiện Join (alias map)

> **Lưu ý quan trọng**: nếu có nhiều mục (section) dưới đây (vd. "Nguồn CLOS" / "Nguồn RLOS" / "KPI Khối (RLOS)" / "KPI Khối (CLOS)"), alias (a, b, c...) được TÁI SỬ DỤNG với Ý NGHĨA KHÁC NHAU ở mỗi section — không được tra alias xuyên section.

### (mặc định)

| Alias | Bảng nguồn | Điều kiện Join |
|---|---|---|
| a | SBLOS2.NG_SB_CLOS_ENTRY_EXIT |  |
| b | SBLOS2.NG_SB_CLOS_CUST_INFO | LEFT JOIN với điều kiện: a.WINAME = b.WI_NAME |
| c | SBLOS2.NG_SB_CLOS_CHANGEREQ | LEFT JOIN với điều kiện: a.WINAME = c.WI_NAME |
| d | SBLOS2.NG_SB_CLOS_CUST_INFO_LEGAL | LEFT JOIN với điều kiện: a.WINAME = d.WI_NAME |
| e | SBLOS2.NG_SB_CLOS_APPROVAL | LEFT JOIN với điều kiện: a.WINAME = e.WI_NAME |
| f | SBLOS2.NG_SB_CLOS_CREDITINFO_COMM | LEFT JOIN với điều kiện: a.WINAME = f.WI_NAME |
| g | SBLOS2.NG_SB_CLOS_COLL_CD | LEFT JOIN với điều kiện: a.WINAME = g.WI_NAME |
| h | SBLOS2.NG_SB_CLOS_CREDITINFO_CD | LEFT JOIN với điều kiện: a.WINAME = h.WI_NAME |
| i | SBLOS2.NG_SB_CLOS_EXTTABLE | LEFT JOIN với điều kiện: a.WINAME = i.WI_NAME |
| j | SBLOS2.NG_SB_CLOS_CONDITON_CDGRID | LEFT JOIN với điều kiện: a.WINAME = j.WI_NAME |
| k | SBLOS2.REF_CLOS_LEGAL | LEFT JOIN với điều kiện: d.OBJ_TYPE = k.OBJ_TYPE |
| l | STG_DTM.STG_DIM_CUSTOMER | LEFT JOIN với điều kiện: REGEXP_REPLACE(d.ID_NUMBER, '\s') = l.LEGAL_ID AND d.LEGAL_DOC = REGEXP_REPLACE(l.LEGAL_DOC_NAME, '\s') AND l.EXP_DATE IS NULL AND l.LEGAL_ID <> '.' |
| m | SBLOS2.NG_SB_CLOS_USER_MAKE_WORK_STEP | LEFT JOIN với điều kiện: a.WINAME = m.WI_NAME and a.WORKSTEP = m.WORK_STEP |

## Danh sách trường báo cáo & logic lấy dữ liệu

| STT | Trường | Ý nghĩa | Cách lấy dữ liệu |
|---|---|---|---|
|  | BI_FLOW | Phân khúc khách hàng | NG_SB_CLOS_CUST_INFO> + Nếu CUST_GROUP IN ('MSME','SME','USME') gán giá trị 'PDTD_KHDN' + Nếu CUST_GROUP IN ('NBFI','JSC','FDI','BANK','STR','SOC') gán giá trị 'PDTD_KHDNL' + Trường hợp còn lại gán giá trị NULL |
|  | CHANGE_REQUEST | Thay đổi điều kiện (New/Change) | NG_SB_CLOS_CHANGEREQ> CHANGE_REQUEST |
|  | CHANGE_TYPE | Chi tiết loại thay đổi điều kiện | NG_SB_CLOS_CHANGEREQ> CHANGE_TYPE |
|  | APPROVAL_TYPE | Luồng phê duyệt | NG_SB_CLOS_APPROVAL> STREAM Với điều kiện STREAM in ('Phê duyệt tín dụng','Sent to Disbursement Request') |
|  | WINAME | Mã hồ sơ | NG_SB_CLOS_ENTRY_EXIT> WINAME |
|  | PROCESSED_DATE | Ngày dữ liệu báo cáo | NG_SB_CLOS_ENTRY_EXIT> Lấy ngày dữ liệu của mã hồ sơ theo thứ tự ưu tiên sau: Ngày phê duyệt cuối cùng đối với các hồ sơ đã được phê duyệt: Lấy Max(EXITDATE) với điều kiện WORKSTEP in ('CreditCommittee', 'CreditApproval') và DECISION in ('Send To HOSupport', 'Reject', 'Submit', 'Send To PostSanction', 'Submit To DisbursementMaker') Ngày hồ sơ bị Cancel: Lấy NVL( EXITDATE, ENTRYDATE) với điều kiện WORKSTEP = 'CancelRevoke' Ngày thoát bước cuối cùng của các hồ sơ chưa đến bước Phê duyệt và không ở CancelRevoke: Lấy giá trị Max(EXITDATE) |
|  | CREATION_DATE | Ngày hồ sơ khởi tạo | NG_SB_CLOS_ENTRY_EXIT> ENTRYDATE Lấy giá trị Min(ENTRYDATE) của mã hồ sơ |
|  | BI_APPSTATUS | Trạng thái cuối của hồ sơ | NG_SB_CLOS_ENTRY_EXIT> + Nếu DECISION IN ('Submit', 'Send To PostSanction','Submit To DisbursementMaker', 'Send To HOSupport') gán giá trị 'Approved' + Nếu DECISION = 'Reject' gán giá trị 'Rejected' + Nếu WORKSTEP IN ('CancelRevoke','CancelPermanent') gán giá trị 'Cancelled' + Trường hợp còn lại gán giá trị 'Processing' |
|  | INDUSTRY_GROUP | Ngành kinh doanh cấp 1 | NG_SB_CLOS_CUST_INFO> INDUSTRY_CODE_LEVEL_1 |
|  | INDUSTRY_CLASS | Ngành kinh doanh cấp 2 | NG_SB_CLOS_CUST_INFO> INDUSTRY_CODE_LEVEL_2 |
|  | INDUSTRY | Ngành kinh doanh cấp 3 | NG_SB_CLOS_CUST_INFO> INDUSTRY_CODE_LEVEL_3 |
|  | CAP_TIN_DUNG | Hồ sơ tư vấn tín dụng hay cấp tín dụng (TVTD/CTD) | NG_SB_CLOS_EXTTABLE> CREDIT_PROFILE |
|  | CUSTOMER_NAME | Tên doanh nghiệp khách hàng | NG_SB_CLOS_CUST_INFO> CUSTOMER_NAME |
|  | ID_NUMBER | Số ĐKKD / MST doanh nghiệp | NG_SB_CLOS_CUST_INFO_LEGAL> ID_NUMBER Với điều kiện OBJ_TYPE = 'Khách hàng' |
|  | CUSTOMER_ID | ID khách hàng (Mã CIF) | STG_DIM_CUSTOMER l> REF_CLOS_LEGAL k> Lấy giá trị l.CUSTOMER với điều kiện TRIM(k.LEGAL_TYPE) = 'CUSTOMER' |
|  | CUST_GROUP | Nhóm phân loại khách hàng | NG_SB_CLOS_CUST_INFO> CUST_GROUP |
|  | LEGAL_REPRESENTATIVE | Người đại diện pháp luật | NG_SB_CLOS_CUST_INFO_LEGAL> NAMEE Với điều kiện OBJ_TYPE = 'Người đại diện theo pháp luật' |
|  | ADD_ID_REPRESENTATIVE | Số GTTT của người đại diện theo pháp luật | NG_SB_CLOS_CUST_INFO_LEGAL> ID_NUMBER Với điều kiện OBJ_TYPE = 'Người đại diện theo pháp luật' |
|  | EMPLOYEE_CODE | Mã CRO | NG_SB_CLOS_CUST_INFO> EMP_CODE |
|  | EMPLOYEE_NAME | Tên CRO | NG_SB_CLOS_CUST_INFO> EMP_NAME |
|  | ZONE | Khu vực | NG_SB_CLOS_CUST_INFO> ZONEE |
|  | BRANCH_CODE | Mã Chi nhánh | NG_SB_CLOS_CUST_INFO> BRANCH_CODE |
|  | BRANCH_NAME | Tên Chi nhánh | NG_SB_CLOS_CUST_INFO> BRANCH_NAME |
|  | COMPANY_CODE | Mã PGD | NG_SB_CLOS_CUST_INFO> COMPANY_CODE |
|  | COMPANY_NAME | Tên PGD | NG_SB_CLOS_CUST_INFO> COMPANY_NAME |
|  | APP_GRP | Cấp phân quyền phê duyệt | NG_SB_CLOS_APPROVAL> APP_GRP |
|  | PRODUCT_LINE | Dòng sản phẩm | NG_SB_CLOS_CUST_INFO> PRODUCT_LINE |
|  | SUB_PRODUCT | Sản phẩm nhánh | NG_SB_CLOS_CUST_INFO> SUB_PRODUCT |
|  | LAST_WORKSTEP | Bước hồ sơ cuối | NG_SB_CLOS_ENTRY_EXIT> WORKSTEP Lấy WORKSTEP tại dòng có giá trị ENTRYDATE lớn nhất của mã hồ sơ |
|  | PRE_WORKSTEP | Bước hồ sơ trước đó | NG_SB_CLOS_ENTRY_EXIT> WORKSTEP Lấy WORKSTEP tại dòng có giá trị ENTRYDATE lớn thứ hai của mã hồ sơ |
|  | LAST_ENTRYDATE | Thời gian vào bước cuối | NG_SB_CLOS_ENTRY_EXIT> ENTRYDATE Lấy Max(ENTRYDATE) của mã hồ sơ |
|  | LAST_EXITDATE | Thời gian kết thúc bước cuối | NG_SB_CLOS_ENTRY_EXIT> EXITDATE Lấy EXITDATE tại dòng có giá trị ENTRYDATE lớn nhất của mã hồ sơ |
|  | LAST_REMARKS | Ghi chú ý kiến bước cuối | NG_SB_CLOS_ENTRY_EXIT> REMARK Lấy REMARK tại dòng có giá trị ENTRYDATE lớn nhất của mã hồ sơ |
|  | LAST_DECISION | Quyết định bước cuối | NG_SB_CLOS_ENTRY_EXIT> DECISION Lấy DECISION tại dòng có giá trị ENTRYDATE lớn nhất của mã hồ sơ |
|  | UNDERWRITERMAKER_TAKERESPON | CV Thẩm định chịu trách nhiệm | NG_SB_CLOS_EXTTABLE i> NG_SB_CLOS_USER_MAKE_WORK_STEP m> COALESCE(CASE WHEN m.WORK_STEP = 'UnderwriterMaker' THEN m.USER_MAKE END, i.UWMAKERUSER) |
|  | UNDERWRITERCHECKER_TAKERESPON | Kiểm soát thẩm định chịu trách nhiệm | NG_SB_CLOS_EXTTABLE i> NG_SB_CLOS_USER_MAKE_WORK_STEP m> COALESCE(CASE WHEN m.WORK_STEP = 'UnderwriterChecker' THEN m.USER_MAKE END, i.UWCHKRUSER) |
|  | APPROVAL_TAKERESPON | Chuyên gia phê duyệt chịu trách nhiệm | NG_SB_CLOS_APPROVAL e> NG_SB_CLOS_USER_MAKE_WORK_STEP m> COALESCE(m.USER_MAKE, CASE e.APP_GRP WHEN 'A1' THEN 'long.lq' WHEN 'CC' THEN 'UBTD' WHEN 'BOD' THEN 'HDQT' END) |
|  | ST_YEUCAU | Số tiền đề xuất vay | NG_SB_CLOS_CREDITINFO_COMM> PRECREDITLIMIT |
|  | ST_PHEDUYET | Số tiền phê duyệt chính thức | NG_SB_CLOS_CREDITINFO_CD> CREDIT_LIMIT |
|  | CURRENCY | Loại tiền tệ áp dụng | NG_SB_CLOS_CREDITINFO_COMM> CURRENCY |
|  | CREDIT_TERM | Thời hạn cấp tín dụng (tháng) | NG_SB_CLOS_CREDITINFO_COMM> CREDIT_TERM |
|  | INTEREST_RATE | Lãi suất phê duyệt | NG_SB_CLOS_CREDITINFO_COMM> INTEREST_RATE |
|  | TSDB_NHOM_0 | Hồ sơ có Tài sản nhóm 0 (YES/NO) | NG_SB_CLOS_COLL_CD> COLLTYPE + Nếu Mã hồ sơ có COLLTYPE IS NOT NULL thì gán giá trị 'YES' + Trường hợp còn lại gán giá trị 'NO' |
|  | TSDB_PTVT | Hồ sơ có TSBĐ là PTVT (YES/NO) | NG_SB_CLOS_COLL_CD> + Nếu COLLTYPE = 'PHUONGTIEN VTAI' gán giá trị 'YES' + Trường hợp còn lại gán giá trị 'NO' |
|  | TSDB_BDS | Hồ sơ có TSBĐ là BĐS (YES/NO) | NG_SB_CLOS_COLL_CD> + Nếu COLLTYPE = 'BAT DONG SAN' gán giá trị 'YES' + Trường hợp còn lại gán giá trị 'NO' |
|  | TSDB_MMTB | Hồ sơ có TSBĐ là MMTB (YES/NO) | NG_SB_CLOS_COLL_CD> + Nếu COLLTYPE = 'TAI SAN KHAC - MMTB,DCSX' gán giá trị 'YES' + Trường hợp còn lại gán giá trị 'NO' |
|  | TSDB_KPT | Hồ sơ có TSBĐ là KPT (YES/NO) | NG_SB_CLOS_COLL_CD> + Nếu COLLTYPE = 'TAI SAN KHAC - QUYEN DOI NO' gán giá trị 'YES' + Trường hợp còn lại gán giá trị 'NO' |
|  | TSDB_HTK | Hồ sơ có TSBĐ là HTK (YES/NO) | NG_SB_CLOS_COLL_CD> + Nếu COLLTYPE = 'HH LA LINHKIEN' gán giá trị 'YES' + Nếu COLLTYPE = 'HH LA NLSX' gán giá trị 'YES' + Nếu COLLTYPE = 'HH TM THANHPHAM' gán giá trị 'YES' + Trường hợp còn lại gán giá trị 'NO' |
|  | TSDB_TIN_CHAP | Hồ sơ tín chấp (YES/NO) | NG_SB_CLOS_COLL_CD> + Nếu COLLTYPE = 'KHÔNG CÓ TÀI SẢN' gán giá trị 'YES' + Trường hợp còn lại gán giá trị 'NO' |
|  | TIN_CHAP_TQD | Tín chấp theo quy định (YES/NO) | NG_SB_CLOS_COLL_CD> + Nếu COLLTYPE = 'TIN CHAP THEO QUY DINH' gán giá trị 'YES' + Trường hợp còn lại gán giá trị 'NO' |
|  | TSDB_CP_TP | TSBĐ là Cổ phiếu/Trái phiếu (YES/NO) | NG_SB_CLOS_COLL_CD> + Nếu COLLTYPE = 'TR.PHIEU TIN PH' gán giá trị 'YES' + Trường hợp còn lại gán giá trị 'NO' |
|  | DEV_PROPOSAL | Hồ sơ có ngoại lệ (YES/NO) | NG_SB_CLOS_CONDITON_CDGRID> DEV_PROPOSAL |
|  | MIN_UWM | Thời gian hồ sơ lên CV thẩm định | NG_SB_CLOS_ENTRY_EXIT> Lấy giá trị MIN(ENTRYDATE), với điều kiện WORKSTEP = 'UnderwriterMaker' |
|  | MIN_APP | Thời gian hồ sơ lên cấp phê duyệt | NG_SB_CLOS_ENTRY_EXIT> EXITDATE Lấy giá trị Min(ENTRYDATE), với điều kiện WORKSTEP in ('CreditApproval', 'CreditCommittee') |
|  | FLAG_AUTO_CAN | Hồ sơ bị tự động hủy (YES/NO) | + Nếu BI_CAN_DATE (STT 59) IS NOT NULL and LAST_DECISION (STT 36) = 'Auto-Cancel' gán giá trị 'YES' + Trường hợp còn lại gán giá trị 'NO' |
|  | LAST_APPROVAL_DATE | Thời gian phê duyệt cuối cùng | NG_SB_CLOS_ENTRY_EXIT> EXITDATE Lấy giá trị Max(EXITDATE), với điều kiện WORKSTEP in ('CreditApproval', 'CreditCommittee') |
|  | BI_CAN_DATE | Thời gian hồ sơ vào vùng CancelRevoke | NG_SB_CLOS_ENTRY_EXIT> ENTRYDATE Với điều kiện WORKSTEP = 'CancelRevoke' |
|  | RI_USER | User khởi tạo hồ sơ | NG_SB_CLOS_ENTRY_EXIT> USERNAME Với điều kiện WORKSTEP = 'RequestInitiate' |
|  | BRANCH_USER | User Chi nhánh | NG_SB_CLOS_ENTRY_EXIT> USERNAME Với điều kiện WORKSTEP = 'BranchSupport' |
|  | DDE_USER | User Chuyên viên nhập liệu | NG_SB_CLOS_ENTRY_EXIT> USERNAME Với điều kiện WORKSTEP = 'DetailDataEntry' |
|  | QUALITY_CHECKER | User Kiểm soát nhập liệu | NG_SB_CLOS_ENTRY_EXIT> USERNAME Với điều kiện WORKSTEP = 'DataInputerChecker' |
|  | PHV_USER | User Chuyên viên Thẩm định điện thoại | NG_SB_CLOS_ENTRY_EXIT > USERNAME Với điều kiện WORKSTEP = 'PhoneVerification' |
|  | FA_USER | User Chuyên viên Thực địa | NG_SB_CLOS_ENTRY_EXIT > USERNAME Với điều kiện WORKSTEP = 'FieldAssessment' |
|  | UND_MAKER | User Chuyên viên thẩm định | NG_SB_CLOS_ENTRY_EXIT > USERNAME Với điều kiện WORKSTEP = 'UnderwriterMaker' |
|  | UND_CHECKER | User Kiểm soát thẩm định | NG_SB_CLOS_ENTRY_EXIT > USERNAME Với điều kiện WORKSTEP = 'UnderwriterChecker' |
|  | BI_APPROVER | User Chuyên gia phê duyệt | NG_SB_CLOS_ENTRY_EXIT> USERNAME Với điều kiện WORKSTEP = 'CreditApproval' |
|  | BI_COMMITTEE | User Hội đồng tín dụng | NG_SB_CLOS_ENTRY_EXIT> USERNAME Với điều kiện WORKSTEP = 'CreditCommittee' |
|  | BI_HOS_USER | User Hỗ trợ phê duyệt | NG_SB_CLOS_ENTRY_EXIT> USERNAME Với điều kiện WORKSTEP = 'HOSupport' |
