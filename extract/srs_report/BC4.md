# BC4 — SRS extract (nguồn: input/srs_report/BC4_PDTD_DTM_SRS_v1.0.docx)

> Auto-extracted. Dùng để đối chiếu logic SRS (STG_LOS -> báo cáo) với LLD (STG_LOS -> SB_DWH -> STG_DTM -> PDTD_DTM -> báo cáo).

## Use case

- **Tên**: Báo cáo Tuần Chuyên viên Thẩm định
- **Mô tả**: Báo cáo cung cấp các thông tin chung của hồ sơ do Chuyên viên thẩm định xử lý trong tuần
- **Tác nhân**: Hệ thống BI
- **Trigger**: 
- **Điều kiện trước**: 
- **Điều kiện sau**: User chọn được tham số và xuất báo cáo hiển thị theo đúng yêu cầu

## Business Rules

- **Hoạt động**: Mã BR | Mô tả
- ****: BR 1.1 | Đầu vào: Ngày báo cáo: Cho phép chọn Ngày báo cáo (REPORT_DATE). Mặc định hiển thị là ngày dữ liệu hiện tại (T-1) Chi nhánh: Cho phép chọn mã chi nhánh (Không bắt buộc). Mặc định hiển thị là Tất cả chi nhánh
- ****: BR 1.2 | Các bảng sử dụng:
- ****: BR 1.3 | Đầu ra: Báo cáo hiển thị các trường thông tin sau:

## Bảng nguồn sử dụng & điều kiện Join (alias map)

> **Lưu ý quan trọng**: nếu có nhiều mục (section) dưới đây (vd. "Nguồn CLOS" / "Nguồn RLOS" / "KPI Khối (RLOS)" / "KPI Khối (CLOS)"), alias (a, b, c...) được TÁI SỬ DỤNG với Ý NGHĨA KHÁC NHAU ở mỗi section — không được tra alias xuyên section.

### Nguồn CLOS

| Alias | Bảng nguồn | Điều kiện Join |
|---|---|---|
| a | SBLOS2.NG_SB_CLOS_ENTRY_EXIT |  |
| b | SBLOS2.NG_SB_CLOS_CUST_INFO | LEFT JOIN với điều kiện: a.WINAME = b.WI_NAME |
| c | SBLOS2.WFINSTRUMENTTABLE | LEFT JOIN với điều kiện: a.WINAME = c.PROCESSINSTANCEIDand c.CREATEDBY not in ('10000380','10000020','10000420','10000140', '10000100') |

### Nguồn RLOS

| Alias | Bảng nguồn | Điều kiện Join |
|---|---|---|
| a | SBLOS2.NG_SB_RLOS_ENTRY_EXIT |  |
| b | SBLOS2.NG_SB_RLOS_APPLICANT_GENERAL | LEFT JOIN với điều kiện: a.WINAME = b.WI_NAME |
| c | SBLOS2.WFINSTRUMENTTABLE | LEFT JOIN với điều kiện: a.WINAME = c.PROCESSINSTANCEIDand c.CREATEDBY not in ('10000380','10000020','10000420','10000140', '10000100') |

## Danh sách trường báo cáo & logic lấy dữ liệu

| STT | Trường | Ý nghĩa | Cách lấy dữ liệu |
|---|---|---|---|
| Nguồn CLOS | Nguồn CLOS | Nguồn CLOS | Nguồn CLOS |
|  | REPORT_WEEK | Tuần báo cáo | Tuần tương ứng với ngày báo cáo: Từ Thứ 2 đến Chủ nhật, định dạng YYYMMDD-YYMMDD |
|  | REPORT_DATE | Ngày báo cáo | NG_SB_CLOS_ENTRY_EXIT> Lấy ngày dữ liệu của mã hồ sơ theo thứ tự ưu tiên sau: Ngày phê duyệt cuối cùng đối với các hồ sơ đã được phê duyệt: Lấy Max(EXITDATE) với điều kiện WORKSTEP in ('CreditCommittee', 'CreditApproval') và DECISION in ('Send To HOSupport', 'Reject', 'Submit', 'Send To PostSanction', 'Submit To DisbursementMaker') Ngày hồ sơ bị Cancel tại bước UnderwriterMaker: Lấy EXITDATE với điều kiện WORKSTEP = 'UnderwriterMaker' và Decision = 'Cancel' Các hồ sơ đã hoặc đang ở bước UnderwriterMaker và chưa được Phê duyệt/Cancel Lấy ngày dữ liệu của hệ thống |
|  | SYSTEMNAME | Hệ thống (CLOS/RLOS) | 'CLOS' |
|  | WINAME | Mã hồ sơ | NG_SB_CLOS_ENTRY_EXIT> WINAME Lấy hồ sơ đã có bước WORKSTEP = 'UnderwriterMaker' |
|  | CUSTOMER_NAME | Tên khách hàng | NG_SB_CLOS_CUST_INFO> CUSTOMER_NAME |
|  | WORKSTEP | Bước hồ sơ | NG_SB_CLOS_ENTRY_EXIT> WORKSTEP |
|  | UND_MAKER | User Chuyên viên thẩm định | NG_SB_CLOS_ENTRY_EXIT> USERNAME, với điều kiện WORKSTEP = 'UnderwriterMaker' |
|  | ENTRYDATE | Thời gian lên bước thẩm định | NG_SB_CLOS_ENTRY_EXIT> ENTRYDATE Lấy MIN(ENTRYDATE) với điều kiện WORKSTEP IN ('UnderwriterMaker', 'UnderwriterChecker') |
|  | EXITDATE | Ngày báo cáo/Thời gian kết thúc bước thẩm định | NG_SB_CLOS_ENTRY_EXIT> EXITDATE Lấy MAX(EXITDATE) với điều kiện WORKSTEP IN ('UnderwriterMaker', 'UnderwriterChecker') |
|  | FLAG | Trạng thái | NG_SB_CLOS_ENTRY_EXIT a> WFINSTRUMENTTABLE c > Nếu a.WORKSTEP IN ('CreditApproval','CreditCommittee') và a.DECISION IN ('Send To HOSupport','Reject','Submit','Send To PostSanction') thì gán giá trị 'Hồ sơ đã chuyển sang bước cấp PD và đã được phê duyệt' Nếu c.PROCESSNAME = 'CLOS' và c.ACTIVITYNAME IN ('CreditApproval','CreditCommittee') gán giá trị 'Hồ sơ đã chuyển sang bước của cấp phê duyệt nhưng chưa PD' Nếu a.WORKSTEP = 'UnderwriterMaker' và a.DECISION = 'Cancel' gán giá trị 'Hồ sơ CVTĐ đã xử lý và chốt trạng thái tại bước của CVTĐ' Nếu c.PROCESSNAME = 'CLOS' và c.ACTIVITYNAME = 'UnderwriterMaker' gán giá trị 'Hồ sơ CVTĐ đang/phải xử lý' Nếu a.WORKSTEP = 'UnderwriterMaker' và a.DECISION IN ('Send_Back to DDE','Additional_Doc_Required','Send_Back to BranchSupport','Send Back DataInputerChecker','Send To Legal or FI or Phone Verification') gán giá trị 'Hồ sơ CVTĐ đã xử lý nhưng chuyển/trả lại các bộ phận để bổ sung/làm rõ' |
|  | REMARKS | Ghi chú | NG_SB_CLOS_ENTRY_EXIT> REMARKS |
| Nguồn RLOS | Nguồn RLOS | Nguồn RLOS | Nguồn RLOS |
|  | REPORT_WEEK | Tuần báo cáo | Tuần tương ứng với ngày báo cáo: Từ Thứ 2 đến Chủ nhật, định dạng YYYMMDD-YYMMDD |
|  | REPORT_DATE | Ngày báo cáo | NG_SB_RLOS_ENTRY_EXIT> Lấy ngày dữ liệu của mã hồ sơ theo thứ tự ưu tiên sau: Ngày phê duyệt cuối cùng đối với các hồ sơ đã được phê duyệt: Lấy Max(EXITDATE) với điều kiện WORKSTEP in ('CreditCommittee', 'CreditApproval') và DECISION in ('Send To HOSupport', 'Reject', 'Submit', 'Send To PostSanction', 'Submit To DisbursementMaker') Ngày hồ sơ bị Cancel tại bước UnderwriterMaker: Lấy EXITDATE với điều kiện WORKSTEP = 'UnderwriterMaker' và Decision = 'Cancel' Các hồ sơ đã hoặc đang ở bước UnderwriterMaker và chưa được Phê duyệt/Cancel Lấy ngày dữ liệu của hệ thống |
|  | SYSTEMNAME | Hệ thống (CLOS/RLOS) | 'RLOS' |
|  | WINAME | Mã hồ sơ | NG_SB_RLOS_ENTRY_EXIT> WINAME Lấy hồ sơ đã có bước WORKSTEP = 'UnderwriterMaker' |
|  | CUSTOMER_NAME | Tên khách hàng | NG_SB_RLOS_APPLICANT_GENERAL> FULL_NAME |
|  | WORKSTEP | Bước hồ sơ | NG_SB_RLOS_ENTRY_EXIT> WORKSTEP |
|  | UND_MAKER | User Chuyên viên thẩm định | NG_SB_RLOS_ENTRY_EXIT> USERNAME, với điều kiện WORKSTEP = 'UnderwriterMaker' |
|  | ENTRYDATE | Thời gian lên bước thẩm định | NG_SB_RLOS_ENTRY_EXIT> ENTRYDATE Lấy MIN(ENTRYDATE) với điều kiện WORKSTEP IN ('UnderwriterMaker', 'UnderwriterChecker') |
|  | EXITDATE | Ngày báo cáo/Thời gian kết thúc bước thẩm định | NG_SB_RLOS_ENTRY_EXIT> EXITDATE Lấy MAX(EXITDATE) với điều kiện WORKSTEP IN ('UnderwriterMaker', 'UnderwriterChecker') |
|  | FLAG | Trạng thái | NG_SB_RLOS_ENTRY_EXIT a> WFINSTRUMENTTABLE c > Nếu a.WORKSTEP IN ('CreditApproval','CreditCommittee') và a.DECISION IN ('Send To HOSupport','Reject','Submit','Send To PostSanction') gán giá trị 'Hồ sơ đã chuyển sang bước cấp PD và đã được phê duyệt' Nếu c.PROCESSNAME = 'RLOS' và c.ACTIVITYNAME IN ('CreditApproval','CreditCommittee') gán giá trị 'Hồ sơ đã chuyển sang bước của cấp phê duyệt nhưng chưa PD' Nếu a.WORKSTEP = 'UnderwriterMaker' và a.DECISION = 'Cancel' gán giá trị 'Hồ sơ CVTĐ đã xử lý và chốt trạng thái tại bước của CVTĐ' Nếu (c.PROCESSNAME = 'RLOS' và c.ACTIVITYNAME = 'UnderwriterMaker') hoặc (a.WORKSTEP = 'UnderwriterMaker' và a.DECISION = 'Send to UWChecker') gán giá trị 'Hồ sơ CVTĐ đang/phải xử lý' Nếu a.WORKSTEP = 'UnderwriterMaker' và a.DECISION IN ('Legal_Assessment','Additional_Doc_Required','Send_Back','Send_Back to DDE','Send Back DataInputerChecker','Send To Legal or FI or Phone Verification') gán giá trị 'Hồ sơ CVTĐ đã xử lý nhưng chuyển/trả lại các bộ phận để bổ sung/làm rõ' |
|  | REMARKS | Ghi chú | NG_SB_RLOS_ENTRY_EXIT> REMARKS |
