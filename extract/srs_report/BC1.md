# BC1 — SRS extract (nguồn: input/srs_report/BC1_PDTD_DTM_SRS_v1.0.docx)

> Auto-extracted. Dùng để đối chiếu logic SRS (STG_LOS -> báo cáo) với LLD (STG_LOS -> SB_DWH -> STG_DTM -> PDTD_DTM -> báo cáo).

## Use case

- **Tên**: Báo cáo RLOS APPLICATION
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
| a | SBLOS2.NG_SB_RLOS_ENTRY_EXIT |  |
| b | SBLOS2.NG_SB_RLOS_APPLICANT_GENERAL | LEFT JOIN với điều kiện: a.WINAME = b.WI_NAME |
| c | SBLOS2.NG_SB_RLOS_APPLICANT_DETAIL | LEFT JOIN với điều kiện: a.WINAME = c.WI_NAME |
| d | SBLOS2.NG_SB_RLOS_COREPAYER_GENERAL | LEFT JOIN với điều kiện: a.WINAME = d.WI_NAME |
| e | SBLOS2.NG_SB_RLOS_COREP_IDGRID | LEFT JOIN với điều kiện: d.WI_NAME = e.WI_NAME and d.ID_NO_CO = e.PIN |
| f | SBLOS2.NG_SB_RLOS_SUB_PRODUCT | LEFT JOIN với điều kiện: a.WINAME = f.WI_NAME |
| g | SBLOS2.NG_SB_RLOS_EXTTABLE | LEFT JOIN với điều kiện: a.WINAME = g.WI_NAME |
| k | SBLOS2.NG_SB_RLOS_CREDIT_PROPOSAL | LEFT JOIN với điều kiện: a.WINAME = k.WI_NAME |
| l | SBLOS2.NG_SB_RLOS_APPROVAL | LEFT JOIN với điều kiện: a.WINAME = l.WI_NAME |
| m | SBLOS2.NG_SB_RLOS_REPAYFLAGS | LEFT JOIN với điều kiện: a.WINAME = m.WI_NAME |
| n | SBLOS2.NG_SB_RLOS_SENT_CBS_LOG | LEFT JOIN với điều kiện: a.WINAME = n.WI_NAME |
| o | SBLOS2.RLOS_REF_FLOW | LEFT JOIN với điều kiện: l.STREAM = o.STREAM |
| p | SBLOS2.NG_SB_RLOS_REPAY_CALC | LEFT JOIN với điều kiện: a.WINAME = p.WI_NAME |
| z | SBLOS2.NG_SB_RLOS_DISB_COL_GRID | LEFT JOIN với điều kiện: a.WINAME = z.WI_NAME |
| h | SBLOS2.NG_SB_RLOS_COL_REALESTATE | LEFT JOIN với điều kiện: z.WI_NAME = h.WI_NAME AND UPPER(z.COL_TYPE) = 'REALSTATE' AND UPPER(z.OWNER) = UPPER(h.OWNER) AND UPPER(z.RELATION) = UPPER(h.REL_CUSTOMER) |
| i | SBLOS2.NG_SB_RLOS_COL_OTHER | LEFT JOIN với điều kiện: z.WI_NAME = i.WI_NAME AND UPPER(z.COL_TYPE) = 'OTHER' AND UPPER(z.OWNER) = UPPER(i.OWNER) AND UPPER(z.RELATION) = UPPER(i.RELATION_CUSTOMER) |
| q | SBLOS2.NG_SB_RLOS_COL_TRANSPORT | LEFT JOIN với điều kiện: z.WI_NAME = q.WI_NAME AND UPPER(z.COL_TYPE) = 'TRANSPORT' AND UPPER(z.OWNER) = UPPER(q.OWNER) AND UPPER(z.RELATION) = UPPER(q.RELATION_CUSTOMER) |
| r | SBLOS2.NG_SB_RLOS_COL_VALPAPER | LEFT JOIN với điều kiện: z.WI_NAME = r.WI_NAME AND UPPER(z.COL_TYPE) = 'VALPAPER' AND UPPER(z.OWNER) = UPPER(r.OWNER) AND UPPER(z.RELATION) = UPPER(r.RELATION_CUSTOMER) |
| j1 | SBLOS2.NG_SB_RLOS_COLL_CERTIGRD | LEFT JOIN với điều kiện: q.WI_NAME = j1.WI_NAME AND UPPER(q.OWNER) = UPPER(j1.OWNER) AND UPPER(q.RELATION_CUSTOMER) = UPPER(j1.RELATIONSHIP) |
| j2 | SBLOS2.NG_SB_RLOS_COLL_CERTIGRD | LEFT JOIN với điều kiện: r.WI_NAME = j2.WI_NAME AND UPPER(r.OWNER) = UPPER(j2.OWNER) AND UPPER(r.RELATION_CUSTOMER) = UPPER(j2.RELATIONSHIP) |
| s | SBLOS2.NG_SB_RLOS_MAS_CITY | LEFT JOIN với điều kiện: c.CITY_CURR_RES = s.CITY_CODE |
| t | SBLOS2.NG_SB_RLOS_MAS_DISTRICT | LEFT JOIN với điều kiện: c.DISTRICT_CURR_RES = t.DISTRICT_CODE |
| u | SBLOS2.NG_SB_RLOS_APPLICANT_IDGRID | LEFT JOIN với điều kiện: a.WINAME = u.WI_NAME |
| w | SBLOS2.NG_SB_RLOS_CBS | LEFT JOIN với điều kiện: a.WINAME = w.WI_NAME |
| x | SBLOS2.Q_RLOS_REF_WORKSTEP_2SYSTEMS | LEFT JOIN với điều kiện: a.WORKSTEP = x.WORKSTEP |
| y | SBLOS2.SB_RLOS_MAS_CHANGE_TYPE | LEFT JOIN với điều kiện: g.CHANGE_TYPE = y.CHANGE_TYPE_NAME |
| aa | SBLOS2.NG_SB_RLOS_MAS_CARD_PROMOTIO | LEFT JOIN với điều kiện: w.PROMOTION_ID = aa.PROMOTION_CODE |
| ac | STG_DTM.STG_DIM_CUSTOMER | LEFT JOIN với điều kiện: u.ID_NUMBER = ac.LEGAL_ID and u.ID_TYPE = ac.LEGAL_DOC_NAME |
| ad | STG_DTM.STG_DIM_CARD | LEFT JOIN với điều kiện: n.RESULT_SEAB_MAIN_CARD_ID = ad.MAIN_ID |
| ae | STG_DTM.STG_DIM_SEAB_MAIN_CARD | LEFT JOIN với điều kiện: n.RESULT_SEAB_MAIN_CARD_ID = ae.RECID |
| af | SBLOS2.NG_SB_RLOS_CREDIT_CARD_APP | LEFT JOIN với điều kiện: f.WI_NAME = af.WI_NAME and f.SUB_PRODUCT_LINE = 'Thẻ tín dụng' |
| ag | SBLOS2.NG_SB_RLOS_SEABUY_APP | LEFT JOIN với điều kiện: f.WI_NAME = ag.WI_NAME and f.SUB_PRODUCT_LINE = 'SeABuy' |
| ah | SBLOS2.NG_SB_RLOS_CIVIL_APP | LEFT JOIN với điều kiện: f.WI_NAME = ah.WI_NAME and f.SUB_PRODUCT_LINE = 'SeACivil' |
| ai | SBLOS2.NG_SB_RLOS_TEACHER_APP | LEFT JOIN với điều kiện: f.WI_NAME = ai.WI_NAME and f.SUB_PRODUCT_LINE = 'SeATeacher' |
| aj | SBLOS2.NG_SB_RLOS_WOMAN_APP | LEFT JOIN với điều kiện: f.WI_NAME = aj.WI_NAME and f.SUB_PRODUCT_LINE = 'SeAWoman' |
| ak | SBLOS2.NG_SB_RLOS_USER_MAKE_WORK_STEP | LEFT JOIN với điều kiện: a.WINAME = ak.WI_NAME and a.WORKSTEP = ak.WORK_STEP |

## Danh sách trường báo cáo & logic lấy dữ liệu

| STT | Trường | Ý nghĩa | Cách lấy dữ liệu |
|---|---|---|---|
|  | BI_FLOW | Phân khúc hồ sơ | RLOS_REF_FLOW> BI_FLOW |
|  | STREAM | Luồng hồ sơ | NG_SB_RLOS_APPROVAL> STREAM |
|  | CHANGE_REQUEST | Thay đổi điều kiện (New/Change) | NG_SB_RLOS_EXTTABLE> REQ_TYPE |
|  | CHANGE_TYPE | Loại thay đổi điều kiện | NG_SB_RLOS_EXTTABLE> CHANGE_TYPE |
|  | CHANGE_TYPE_DETAIL | Chi tiết loại thay đổi điều kiện | SB_RLOS_MAS_CHANGE_TYPE> DETAIL_CHANGE_TYPE_NAME |
|  | BI_CUS_SEGMENT | Phân khúc khách hàng chuẩn | NG_SB_RLOS_APPLICANT_DETAIL> CUS_SEGMENT + Nếu CUS_SEGMENT LIKE '%xanh' OR CUS_SEGMENT LIKE '%XANH' gán giá trị 'XANH' + Nếu CUS_SEGMENT = 'CBNV' gán giá trị 'CBNV' + Trường hợp còn lại gán giá trị 'THUONG' |
|  | WINAME | Mã hồ sơ vay | NG_SB_RLOS_ENTRY_EXIT> WINAME |
|  | PROCESSED_DATE | Ngày dữ liệu báo cáo | NG_SB_RLOS_ENTRY_EXIT Lấy ngày dữ liệu của mã hồ sơ theo thứ tự ưu tiên sau: Ngày phê duyệt cuối cùng đối với các hồ sơ đã được phê duyệt: Lấy Max(EXITDATE) với điều kiện WORKSTEP in ('CreditCommittee', 'CreditApproval') và DECISION in ('Send To HOSupport', 'Reject', 'Submit', 'Send To PostSanction', 'Submit To DisbursementMaker') Ngày hồ sơ bị Cancel: Lấy NVL( EXITDATE, ENTRYDATE) với điều kiện WORKSTEP = 'CancelRevoke' Ngày thoát bước cuối cùng của các hồ sơ chưa đến bước Phê duyệt và không ở CancelRevoke: Lấy giá trị Max(EXITDATE) |
|  | CREATION_DATE | Ngày khởi tạo hồ sơ | NG_SB_RLOS_ENTRY_EXIT> ENTRYDATE Lấy giá trị Min(ENTRYDATE) của mã hồ sơ |
|  | BI_APPSTATUS | Trạng thái cuối của hồ sơ | NG_SB_RLOS_ENTRY_EXIT> DECISION, WORKSTEP + Nếu DECISION IN ('Submit', 'Send To PostSanction','Submit To DisbursementMaker', 'Send To HOSupport') gán giá trị 'Approved' + Nếu DECISION = 'Reject' gán giá trị 'Rejected' + Nếu WORKSTEP IN ('CancelRevoke','CancelPermanent') gán giá trị 'Cancelled' + Trường hợp còn lại gán giá trị 'Processing' |
|  | CUSTOMER_NAME | Tên khách hàng | NG_SB_RLOS_APPLICANT_GENERAL> FULL_NAME |
|  | ADD_ID | Số "TCC", Số "CC" | NG_SB_RLOS_APPLICANT_IDGRID> ID_NUMBER, với điều kiện ID_TYPE in ('TCC','CC') |
|  | ADD_ID_OTHER | Số GTTT khác | NG_SB_RLOS_APPLICANT_IDGRID> ID_NUMBER, với điều kiện ID_TYPE not in ('TCC','CC') |
|  | CUSTOMER_ID | Mã khách hàng | STG_DIM_CUSTOMER> CUSTOMER |
|  | DATE_OF_BIRTH | Ngày sinh | STG_DIM_CUSTOMER> DATE_OF_BIRTH |
|  | GENDER | Giới tính | STG_DIM_CUSTOMER> GENDER |
|  | PERMANENT_RESIDENCE_ADDRESS | Địa chỉ thường trú | NG_SB_RLOS_APPLICANT_DETAIL> PERM_ADD |
|  | CURRENT_RESIDENTIAL_CITY | Địa chỉ hiện tại (Tỉnh/TP) | NG_SB_RLOS_MAS_CITY> CITY_NAME |
|  | CURRENT_RESIDENTIAL_DISTRICT | Địa chỉ hiện tại (Quận/Huyện) | NG_SB_RLOS_MAS_DISTRICT> DISTRICT_NAME |
|  | CURRENT_RESIDENTIAL_WARD | Địa chỉ hiện tại (Phường/Xã) | NG_SB_RLOS_APPLICANT_DETAIL> WARD_CURR_RES |
|  | CURRENT_RESIDENTIAL_ADDRESS | Địa chỉ hiện tại chi tiết | NG_SB_RLOS_MAS_CITY> CITY_NAME NG_SB_RLOS_MAS_DISTRICT> DISTRICT_NAME NG_SB_RLOS_APPLICANT_DETAIL> WARD_CURR_RES NG_SB_RLOS_APPLICANT_DETAIL> HOUSNO_CURR_RES Ghép chuỗi: HOUSNO_CURR_RES // ', ' // WARD_CURR_RES // ', ' // DISTRICT_NAME // ', ' // CITY_NAME |
|  | MARRIAGE_STATUS | Tình trạng hôn nhân | NG_SB_RLOS_APPLICANT_DETAIL> MARR_STATUS |
|  | EDUCATION_LEVEL | Trình độ học vấn | NG_SB_RLOS_APPLICANT_DETAIL> EDU_LEVEL |
|  | VEHICLES | Phương tiện đi lại | NG_SB_RLOS_APPLICANT_DETAIL> VEHICLE |
|  | OWNERSHIP | Sở hữu nhà ở | NG_SB_RLOS_COL_REALESTATE> OWNER |
|  | CO_REPAYER | Tên người đồng trả nợ | NG_SB_RLOS_COREPAYER_GENERAL> FULL_NAME |
|  | ADD_ID_COREPAYER | Số "TCC" và "CC" của người đồng trả nợ | NG_SB_RLOS_COREP_IDGRID> ID_NUMBER, với điều kiện ID_TYPE in ('TCC','CC') |
|  | ADD_ID_OTHER_COREPAYER | Số GTTT khác của người đồng trả nợ | NG_SB_RLOS_COREP_IDGRID> ID_NUMBER, với điều kiện ID_TYPE not in ('TCC','CC') |
|  | EMPLOYEE_CODE | Mã CRO | NG_SB_RLOS_APPLICANT_GENERAL> EMPLOYEE_CODE |
|  | EMPLOYEE_NAME | Tên CRO | NG_SB_RLOS_APPLICANT_GENERAL> EMPLOYEE_NAME |
|  | ZONE | Khu vực hoạt động | NG_SB_RLOS_APPLICANT_GENERAL> ZONE |
|  | BRANCH_CODE | Mã Chi nhánh | NG_SB_RLOS_APPLICANT_GENERAL> BRACH_CODE |
|  | BRANCH_NAME | Tên Chi nhánh | NG_SB_RLOS_APPLICANT_GENERAL> BRANCH_NAME |
|  | COMPANY_CODE | Mã PGD | NG_SB_RLOS_APPLICANT_GENERAL> COMPANY_CODE |
|  | COMPANY_NAME | Tên PGD | NG_SB_RLOS_APPLICANT_GENERAL> COMPANY_NAME |
|  | APP_GRP | Cấp phân quyền phê duyệt | NG_SB_RLOS_APPROVAL> APP_GRP |
|  | PRODUCT_LINE | Dòng sản phẩm | NG_SB_RLOS_APPLICANT_GENERAL> PRODUCT_LINE |
|  | SUB_PRODUCT | Sản phẩm nhánh | NG_SB_RLOS_APPLICANT_GENERAL> SUB_PRODUCT |
|  | SECONDARY_PRODUCTLINE | Có sản phẩm phụ (YES/NO) | NG_SB_RLOS_APPLICANT_GENERAL> IS_SEC_PRODUCT |
|  | SAN_PHAM_PHU | Sản phẩm phụ chi tiết | NG_SB_RLOS_SUB_PRODUCT> SUB_PRODUCT_LINE |
|  | LAST_WORKSTEP | Bước hồ sơ cuối cùng | NG_SB_RLOS_ENTRY_EXIT> WORKSTEP Lấy WORKSTEP tại dòng có giá trị ENTRYDATE lớn nhất của mã hồ sơ |
|  | PRE_WORKSTEP | Bước hồ sơ trước đó | NG_SB_RLOS_ENTRY_EXIT> WORKSTEP Lấy WORKSTEP tại dòng có giá trị ENTRYDATE lớn thứ hai của mã hồ sơ |
|  | LAST_ENTRYDATE | Thời gian vào bước cuối | NG_SB_RLOS_ENTRY_EXIT> ENTRYDATE Lấy Max(ENTRYDATE) của mã hồ sơ |
|  | LAST_EXITDATE | Thời gian kết thúc bước cuối | NG_SB_RLOS_ENTRY_EXIT> EXITDATE Lấy EXITDATE tại dòng có giá trị ENTRYDATE lớn nhất của mã hồ sơ |
|  | LAST_REMARKS | Ghi chú ý kiến bước cuối | NG_SB_RLOS_ENTRY_EXIT> REMARK Lấy REMARK tại dòng có giá trị ENTRYDATE lớn nhất của mã hồ sơ |
|  | LAST_REMARK_DDE | Ghi chú tại bước nhập liệu DDE | NG_SB_RLOS_ENTRY_EXIT> REMARK Lấy REMARKS tại bước có WORKSTEP = 'DetailDataEntry' |
|  | LAST_DECISION | Quyết định tại bước cuối | NG_SB_RLOS_ENTRY_EXIT> DECISION Lấy DECISION tại dòng có giá trị ENTRYDATE lớn nhất của mã hồ sơ |
|  | UNDERWRITERMAKER_TAKERESPON | CV Thẩm định chịu trách nhiệm | NG_SB_RLOS_EXTTABLE g> NG_SB_RLOS_USER_MAKE_WORK_STEP ak> COALESCE(CASE WHEN ak.WORK_STEP = 'UnderwriterMaker' THEN ak.USER_MAKE END, g.UWMAKERUSER) |
|  | UNDERWRITERCHECKER_TAKERESPON | Kiểm soát thẩm định chịu trách nhiệm | NG_SB_RLOS_EXTTABLE g> NG_SB_RLOS_USER_MAKE_WORK_STEP ak> COALESCE(CASE WHEN ak.WORK_STEP = 'UnderwriterChecker' THEN ak.USER_MAKE END, g.UWCHKRUSER) |
|  | APPROVAL_TAKERESPON | Chuyên gia phê duyệt chịu trách nhiệm | NG_SB_RLOS_EXTTABLE g> NG_SB_RLOS_USER_MAKE_WORK_STEP ak> COALESCE(CASE WHEN ak.WORK_STEP in ('CreditCommittee', ' CreditApproval') THEN ak.USER_MAKE END, g.CREDAPPRUSER, g.CCOMMITUSER) |
|  | TSBD_BDS | Hồ sơ có TSBĐ là BĐS (YES/NO) | NG_SB_RLOS_DISB_COL_GRID z> CASE WHEN UPPER(z.COL_TYPE) = 'REALSTATE' THEN 'YES' ELSE 'NO' END |
|  | TSBD_PTVT | Hồ sơ có TSBĐ là PTVT (YES/NO) | NG_SB_RLOS_DISB_COL_GRID z> CASE WHEN UPPER(z.COL_TYPE) = 'TRANSPORT' THEN 'YES' ELSE 'NO' END |
|  | TSBD_GTCG | Hồ sơ có TSBĐ là GTCG (YES/NO) | NG_SB_RLOS_DISB_COL_GRID z> CASE WHEN UPPER(z.COL_TYPE) = 'VALPAPER' THEN 'YES' ELSE 'NO' END |
|  | GCN_REAL_ESTATE | Số GCN TSBĐ là BĐS | NG_SB_RLOS_COL_REALESTATE> NO_CERTI |
|  | GCN_OTHER | Số GCN TSBĐ là PTVT/Khác | NG_SB_RLOS_COL_VALPAPER r> NG_SB_RLOS_COLL_CERTIGRD j1> NG_SB_RLOS_COLL_CERTIGRD j2> Lấy giá trị tương ứng của 3 bảng: r.NUMBERSIGN j1.CERTIFICATENO j2.CERTIFICATENO |
|  | TSBD_RELATIONSHIP | Mối quan hệ chủ tài sản và KH | NG_SB_RLOS_COL_TRANSPORT q> NG_SB_RLOS_COL_REALESTATE h> NG_SB_RLOS_COL_VALPAPER r> NG_SB_RLOS_COL_OTHER i> Lấy giá trị tương ứng của 4 bảng: q.RELATION_CUSTOMER, h.REL_CUSTOMER, r.RELATION_CUSTOMER, i.RELATION_CUSTOMER |
|  | DEVIATION | Hồ sơ có ngoại lệ (YES/NO) | NG_SB_RLOS_APPLICANT_GENERAL> DEVIATION_FLAG |
|  | POLICY | Chính sách áp dụng | NG_SB_RLOS_APPLICANT_GENERAL> POLICY |
|  | CAMPAIGN | Mã chương trình tiếp thị | NG_SB_RLOS_APPLICANT_GENERAL> CAMPAIGN |
|  | PROOF_OF_INCOME | Nguồn thu nhập | NG_SB_RLOS_APPLICANT_GENERAL> PROOF_OF_INCOME + Nếu PROOF_OF_INCOME = 'proofincome01' gán giá trị 'CHUNGTU_CHUNGMINH_THUNHAP' + Nếu PROOF_OF_INCOME = 'proofincome02' gán giá trị 'BANGKE_THUNHAP' |
|  | REPAYMENT_SOURCE | Loại nguồn thu | NG_SB_RLOS_REPAYFLAGS> Lấy SUBSTR(REGEXP_REPLACE( CASE WHEN SALARYFLAG = 'Yes' THEN 'Lương / ' END // CASE WHEN CARFLAG = 'Yes' THEN 'Cho thuê phương tiện / ' END // CASE WHEN HOUSEFLAG = 'Yes' THEN 'Cho thuê nhà / ' END // CASE WHEN ENTERPRISSEFLAG = 'Yes' THEN 'Lợi nhuận doanh nghiệp / ' END // CASE WHEN DIVINGFLAG = 'Yes' THEN 'Cổ tức / ' END // CASE WHEN FAIMILYFLAG = 'Yes' THEN 'Kinh doanh hộ gia đình / ' END // CASE WHEN NONLICFLAG = 'Yes' THEN 'Kinh doanh không ĐKKD / ' END // CASE WHEN WAGESFLAG = 'Yes' THEN 'Tiền công / ' END // CASE WHEN PENSIONFLAG = 'Yes' THEN 'Lương hưu/phụ cấp / ' END // CASE WHEN OTHERFLAG = 'Yes' THEN 'Nguồn thu khác / ' END, ' / $', ''), 1, 200) |
|  | TOTAL_INCOME | Tổng thu nhập phê duyệt | NG_SB_RLOS_REPAY_CALC> TOT_INC_CALC |
|  | LOAN_TO_VALUE | Tỷ lệ LTV (%) | NG_SB_RLOS_CREDIT_PROPOSAL> LOAN_TO_VALUE |
|  | K_TYPE | Loại thẻ tín dụng | STG_DIM_CARD> K_TYPE |
|  | PROMOTION_ID | Ưu đãi phí | NG_SB_RLOS_MAS_CARD_PROMOTIO> DESCRIPTION |
|  | HOME_ADDRESS | Địa chỉ nhận Pin/Thẻ | STG_DIM_SEAB_MAIN_CARD> HOME_ADDRESS |
|  | LOAN_AMOUNT | Số tiền phê duyệt | NG_SB_RLOS_CREDIT_PROPOSAL> LOAN_AMOUNT |
|  | LOAN_TERM | Thời hạn phê duyệt (tháng) | NG_SB_RLOS_CREDIT_PROPOSAL> LOAN_TERM |
|  | INTEREST_RATE | Lãi suất phê duyệt (%/năm) | NG_SB_RLOS_CREDIT_PROPOSAL> CURRENT_RATE |
|  | MIN_UWM | Thời gian hồ sơ lên CV thẩm định | NG_SB_RLOS_ENTRY_EXIT> ENTRY_DATE Lấy giá trị MIN(ENTRYDATE), với điều kiện WORKSTEP = 'UnderwriterMaker' |
|  | MIN_APP | Thời gian hồ sơ lên CG phê duyệt | NG_SB_RLOS_ENTRY_EXIT> ENTRY_DATE Lấy giá trị MIN(ENTRYDATE), với điều kiện WORKSTEP in ('CreditApproval', 'CreditCommittee') |
|  | LAST_APPROVAL_DATE | Thời gian phê duyệt cuối cùng | NG_SB_RLOS_ENTRY_EXIT> EXITDATE Lấy giá trị Max(EXITDATE), với điều kiện WORKSTEP in ('CreditApproval', 'CreditCommittee') |
|  | CAN_USER_DATE | Thời gian cancel do NSD | NG_SB_RLOS_ENTRY_EXIT> EXITDATE Lấy giá trị EXITDATE với điều kiện DECISION = 'Cancel' AND USERNAME IS NOT NULL |
|  | AUTO_CAN_DATE | Thời gian cancel tự động | Lấy thời gian hệ thống tự động chuyển hồ sơ sang bước CancelRevoke (do quá 5 ngày làm việc hồ sơ ở bước ĐVKD không bổ sung): Lấy Min(ENTRYDATE) Với điều kiện: + WORKSTEP = 'CancelRevoke' and USERNAME IS NULL and EXITDATE IS NULL and DECISION IS NULL + Hồ sơ từng bị treo tại BranchSupport quá 5 ngày làm việc (2400 phút): WORKSTEP = 'BranchSupport' and (ENTRYDATE tại WORKSTEP = 'BranchSupport' < ENTRYDATE tại WORKSTEP = 'CancelRevoke') and EXITDATE IS NULL and DECISION IS NULL and get_business_minute( (ENTRYDATE tại WORKSTEP = 'BranchSupport'), (ENTRYDATE tại WORKSTEP = 'CancelRevoke')) >= 2400 Trong đó: get_business_minute tính thời gian loại trừ holidays, chiều Thứ 7, cả ngày Chủ nhật; thời gian tính từ 8-12 và 13-17 + Hồ sơ không tồn tại bước hủy thủ công trước hoặc cùng thời điểm vào bước CancelRevoke: Không tồn tại dòng thỏa mãn điều kiện DECISION = 'Cancel' and (ENTRYDATE tại DECISION = 'Cancel' < = ENTRYDATE tại WORKSTEP = 'CancelRevoke') |
|  | FLAG_AUTO_CAN | Hồ sơ cancel tự động (YES/NO) | + Nếu AUTO_CAN_DATE IS NOT NULL gán giá trị 'YES' + Trường hợp còn lại gán giá trị 'NO' |
|  | LAST_CAN_REMARKS | Ghi chú hủy hồ sơ | NG_SB_RLOS_ENTRY_EXIT> Lấy REMARKS với điều kiện DECISION = 'Cancel' |
|  | BRANCH_USER | User Chi nhánh | NG_SB_RLOS_ENTRY_EXIT a> Q_RLOS_REF_WORKSTEP_2SYSTEMS x> Lấy a.USERNAME, với điều kiện x.BI_WORKSTEP = '01.Branch' và x.System = 'OF' |
|  | DDE_USER | User Chuyên viên nhập liệu | NG_SB_RLOS_ENTRY_EXIT a> Q_RLOS_REF_WORKSTEP_2SYSTEMS x> Lấy a.USERNAME, với điều kiện x.BI_WORKSTEP = '02.DDE' và x.System = 'OF' |
|  | QUALITY_CHECKER | User Kiểm soát nhập liệu | NG_SB_RLOS_ENTRY_EXIT a> Q_RLOS_REF_WORKSTEP_2SYSTEMS x> Lấy a.USERNAME, với điều kiện x.BI_WORKSTEP = '03.Data Quality check' và x.System = 'OF' |
|  | UND_MAKER | User Chuyên viên thẩm định | NG_SB_RLOS_ENTRY_EXIT> USERNAME, với điều kiện WORKSTEP = 'UnderwriterMaker' |
|  | UND_CHECKER | User Kiểm soát thẩm định | NG_SB_RLOS_ENTRY_EXIT> USERNAME, với điều kiện WORKSTEP = 'UnderwriterCheker' |
|  | PHV_USER | User Chuyên viên Thẩm định điện thoại | NG_SB_RLOS_ENTRY_EXIT> USERNAME, với điều kiện WORKSTEP = 'PhoneVerification' |
|  | BI_APPROVER | User Chuyên gia phê duyệt | NG_SB_RLOS_ENTRY_EXIT> USERNAME, với điều kiện WORKSTEP in ('CreditCommittee', ' CreditApproval') |
|  | LOAN_OBJECTIVE | Mục đích cho vay | NG_SB_RLOS_CREDIT_PROPOSAL > LOAN_OBJECTIVE |
|  | SPP_AMOUNT | Giá trị của sản phẩm phụ | NG_SB_RLOS_CREDIT_CARD_APP af> NG_SB_RLOS_SEABUY_APP ag> NG_SB_RLOS_CIVIL_APP ah> NG_SB_RLOS_TEACHER_APP ai> NG_SB_RLOS_WOMAN_APP aj> Lấy UNION giá trị LIMIT_NO của 5 bảng |
|  | SPP_TERM | Thời hạn của sản phẩm phụ | NG_SB_RLOS_CREDIT_CARD_APP af> NG_SB_RLOS_SEABUY_APP ag> NG_SB_RLOS_CIVIL_APP ah> NG_SB_RLOS_TEACHER_APP ai> NG_SB_RLOS_WOMAN_APP aj> Lấy UNION các giá trị của 5 bảng: af.TERM; ag.TIME_VALID ah.TIME_VALID ai.TIME_VALID aj.TIME_VALID |
