# BC5 — SRS extract (nguồn: input/srs_report/BC5_PDTD_DTM_SRS_v1.0.docx)

> Auto-extracted. Dùng để đối chiếu logic SRS (STG_LOS -> báo cáo) với LLD (STG_LOS -> SB_DWH -> STG_DTM -> PDTD_DTM -> báo cáo).

## Use case

- **Tên**: BÁO CÁO SLA - TAT
- **Mô tả**: Báo cáo cung cấp kết quả SLA – TAT của hồ sơ trình qua Khối PDTD
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

### Nguồn CLOS

| Alias | Bảng nguồn | Điều kiện Join |
|---|---|---|
| a | SBLOS2.NG_SB_CLOS_ENTRY_EXIT |  |
| b | SBLOS2.NG_SB_CLOS_CUST_INFO | LEFT JOIN với điều kiện: a.WINAME = b.WI_NAME |
| c | SBLOS2.NG_SB_CLOS_MAS_PRO_LINE | LEFT JOIN với điều kiện: b.PRODUCT_LINE = c.PRODUCT_LINE_CODE |
| d | SBLOS2.NG_SB_CLOS_APPROVAL | LEFT JOIN với điều kiện: a.WINAME = d.WI_NAME |
| e | SBLOS2.NG_SB_CLOS_CREDITINFO_COMM | LEFT JOIN với điều kiện: a.WINAME = e.WI_NAME |
| f | SBLOS2.NG_SB_CLOS_CHANGEREQ | LEFT JOIN với điều kiện: a.WINAME = f.WI_NAME |
| - | BC5TAT - sheet cam kết SLA TDKHDN luồng 1/ sheet cam kết SLA TDKHDN luồng 2 (file1) (file chỉ có thông tin về REF_PRODUCT) | LEFT JOIN với điều kiện: b.CUST_GROUP IN ('MSME','SME','USME') Và xét các điều kiện sau: 1. Điều kiện cột Product Line 1.1. f.CHANGE_REQUEST = 'Change Request' tương ứng với file1."Product Line" = 'Trường Change Request' 1.2. Xét f.CHANGE_REQUEST <> 'Change Request' và file1."Product Line" = c.PRODUCT_LINE_NAME 2. Điều kiện cột Sub Product: Xét file1."Sub Product" = b.SUB_PRODUCT Nếu file1."Sub Product" NULL thì không xét điều kiện này |
| - | BC5TAT - sheet cam kết SLA TDKHDN luồng 2 (file2) | LEFT JOIN với điều kiện điều kiện: b.CUST_GROUP IN ('MSME','SME','USME') Và xét các điều kiện sau: 1. Điều kiện cột FLAG (APP_GRP): d.APP_GRP in ('A1', 'A2', 'B1', 'B2') tương ứng với file2."FLAG (APP_GRP)" = 'CGPD' d.APP_GRP in ('BOD', 'CC', 'SCC', 'RCC') tương ứng với file2."FLAG (APP_GRP)" = 'HDTD' 2. Điều kiện cột Have any deviation: Xét file2."Have any deviation" = e.HAVE_ANY_DEVIATION 3. Điều kiện cột Product Line 3.1. f.CHANGE_REQUEST = 'Change Request' tương ứng với file2."Product Line" = 'Trường Change Request' 3.2. Xét f.CHANGE_REQUEST <> 'Change Request' và file2."Product Line" = c.PRODUCT_LINE_NAME 4. Điều kiện cột Sub Product: Xét file2."Sub Product" = b.SUB_PRODUCT Nếu file2."Sub Product" NULL thì không xét điều kiện này |
| - | BC5TAT - sheet cam kết SLA TDKHDNL (file3) | LEFT JOIN với điều kiện: b.CUST_GROUP IN ('NBFI','JSC','FDI','BANK','STR','SOC') Và xét các điều kiện sau: 1. Điều kiện cột FLAG (APP_GRP): d.APP_GRP in ('A1', 'A2', 'B1', 'B2') tương ứng với file3."FLAG (APP_GRP)" = 'CGPD' d.APP_GRP in ('BOD', 'CC', 'SCC', 'RCC') tương ứng với file."FLAG (APP_GRP)" = 'HDTD' 2. Điều kiện cột Have any deviation: Xét file3."Have any deviation" = e.HAVE_ANY_DEVIATION 3. Điều kiện cột Product Line 3.1. f.CHANGE_REQUEST = 'Change Request' tương ứng với file3."Product Line" = 'Trường Change Request' 3.2. Xét f.CHANGE_REQUEST <> 'Change Request' và file3."Product Line" = c.PRODUCT_LINE_NAME 4. Điều kiện cột Sub Product: Xét file3."Sub Product" = b.SUB_PRODUCT Nếu file3."Sub Product" NULL thì không xét điều kiện này |
| - | BC5TAT - sheet cam kết SLA NLTT (CLOS) (file4) | LEFT JOIN theo các điều kiện sau: 1. Điều kiện cột New/Change Request: Xét f.CHANGE_REQUEST = file4."New/Change Request" 2. Điều kiện cột Product Line: Xét file4."Product Line" = c.PRODUCT_LINE_NAME 3. Điều kiện cột Sub Product: Xét file4."Sub Product" = b.SUB_PRODUCT Nếu file4."Sub Product" NULL thì không xét điều kiện này |

### Nguồn RLOS

| Alias | Bảng nguồn | Điều kiện Join |
|---|---|---|
| a | SBLOS2.NG_SB_RLOS_ENTRY_EXIT |  |
| b | SBLOS2.NG_SB_RLOS_APPLICANT_GENERAL | LEFT JOIN với điều kiện: a.WINAME = b.WI_NAME |
| c | SBLOS2.NG_SB_RLOS_APPROVAL | LEFT JOIN với điều kiện: a.WINAME = c.WI_NAME |
| d | SBLOS2.NG_SB_RLOS_EXTTABLE | LEFT JOIN với điều kiện: a.WINAME = d.WI_NAME |
| e | SBLOS2.NG_SB_RLOS_MANUAL_DEVIATION | LEFT JOIN với điều kiện: a.WINAME = e.WI_NAME |
| - | BC5TAT - sheet cam kết SLA TDKHCN (file1) | LEFT JOIN theo các điều kiện sau: 1. Điều kiện cột APP_GRP: file1.APP_GRP tương ứng với các giá trị c.APP_GRP 2. Điều kiện cột Product Line: 2.1. Nếu file1."Product Line" = 'Trường Change Request': Xét file1."Change Type" = d.CHANGE_TYPE 2.1 Nếu file1."Product Line" <> 'Trường Change Request': Xét file1."Product Line" = b.PRODUCT_LINE 3. Điều kiện cột DEVIATION_G3: Count số dòng (sl) của mỗi WI_NAME trong bảng NG_SB_RLOS_MANUAL_DEVIATION sl >= 3 tương ứng với file1."DEVIATION_G3" = 'YES' sl < 3 tương ứng với file1."DEVIATION_G3" = 'NO' Nếu file1."DEVIATION_G3" NULL thì không xét điều kiện này 4. Điều kiện cột SECONDARY_PRODUCTLINE: b.IS_SEC_PRODUCT = 'Không' tương ứng với file1."SECONDARY_PRODUCTLINE" = 'NO' b.IS_SEC_PRODUCT = 'Có' tương ứng với file1."SECONDARY_PRODUCTLINE" = 'YES' Nếu file1."SECONDARY_PRODUCTLINE" NULL thì không xét điều kiện này |
| - | BC5TAT - sheet cam kết SLA NLTT (RLOS) (file2) | LEFT JOIN với điều kiện: file2."Product Line" = b.PRODUCT_LINE |

## Danh sách trường báo cáo & logic lấy dữ liệu

| STT | Trường | Ý nghĩa | Cách lấy dữ liệu |
|---|---|---|---|
| Nguồn CLOS | Nguồn CLOS | Nguồn CLOS | Nguồn CLOS |
|  | SYSTEMNAME | Hệ thống (CLOS/RLOS) | 'CLOS' |
|  | PROCESSED_DATE | Ngày dữ liệu - Ngày mới nhất của dữ liệu | NG_SB_CLOS_ENTRY_EXIT Lấy ngày dữ liệu của mã hồ sơ theo thứ tự ưu tiên sau: Ngày phê duyệt cuối cùng đối với các hồ sơ đã được phê duyệt: Lấy Max(EXITDATE) với điều kiện WORKSTEP in ('CreditCommittee', 'CreditApproval') và DECISION in ('Send To HOSupport', 'Reject', 'Submit', 'Send To PostSanction', 'Submit To DisbursementMaker') Ngày hồ sơ bị Cancel: Lấy NVL(EXITDATE, ENTRYDATE) với điều kiện WORKSTEP = 'CancelRevoke' Ngày thoát bước cuối cùng của các hồ sơ chưa đến bước Phê duyệt và không ở CancelRevoke: Lấy giá trị Max(EXITDATE) |
|  | WINAME | Mã hồ sơ | NG_SB_CLOS_ENTRY_EXIT> WINAME |
|  | BI_APPSTATUS | Trạng thái hồ sơ | NG_SB_CLOS_ENTRY_EXIT> CASE WHEN DECISION IN ('Submit', 'Send To PostSanction','Submit To DisbursementMaker', 'Send To HOSupport') THEN 'Approved' WHEN DECISION = 'Reject' THEN 'Rejected' WHEN WORKSTEP IN ('CancelRevoke','CancelPermanent') THEN 'Cancelled' ELSE 'Processing' END |
|  | STEP01_BRANCH_CL_TAT | Tổng thời gian xử lý tại chi nhánh theo Calendar minutes | NG_SB_CLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'BranchSupport' THEN TAT/3600 END),0) |
|  | STEP01_BRANCH_WK_TAT | Tổng thời gian xử lý tại chi nhánh theo Working minutes (loại trừ holidays, chiều thứ 7, cả ngày chủ nhật; thời gian tính từ 8-12 và 13-17) | NG_SB_CLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'BranchSupport' THEN get_business_minute(ENTRYDATE, EXITDATE)/60 END),0) Trong đó get_business_minute(): loại trừ holidays, chiều thứ 7, cả ngày chủ nhật; thời gian tính từ 8-12 và 13-17 |
|  | STEP01_BRANCH_TAT_CPC | Tổng thời gian xử lý tại chi nhánh theo cam kết SLA (loại trừ holidays, chiều thứ 7, cả ngày chủ nhật; thời gian tính từ 8-11:30 và 13:30-16:30) | NG_SB_CLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'BranchSupport' THEN get_business_minute_cpc(ENTRYDATE, EXITDATE)/60 END),0) Trong đó get_business_minute_cpc(): loại trừ holidays, chiều thứ 7, cả ngày chủ nhật; thời gian tính từ 8-11:30 và 13:30-16:30 |
|  | STEP02_DDE_CL_TAT | Tổng thời gian tất cả các bước DetailDataEntry theo Calendar minutes | NG_SB_CLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP IN ('DetailDataEntry','CLOS_DetailDataEntry') THEN TAT/3600 END),0) |
|  | STEP02_DDE_WK_TAT | Tổng thời gian tất cả các bước DetailDataEntry theo Working minutes | NG_SB_CLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP IN ('DetailDataEntry','CLOS_DetailDataEntry') THEN get_business_minute(ENTRYDATE, EXITDATE)/60 END),0) |
|  | STEP02_DDE_TAT_CPC | Tổng thời gian tất cả các bước DetailDataEntry theo cam kết SLA | NG_SB_CLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP IN ('DetailDataEntry','CLOS_DetailDataEntry') THEN get_business_minute_cpc(ENTRYDATE, EXITDATE)/60 END),0) |
|  | STEP03_QUALITY_CHECKER_CL_TAT | Tổng thời gian tất cả các bước DataInputerChecker theo Calendar minutes | NG_SB_CLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP IN ('DataInputerChecker','CLOS_DataInputerChecker') THEN TAT/3600 END),0) |
|  | STEP03_QUALITY_CHECKER_WK_TAT | Tổng thời gian tất cả các bước DataInputerChecker theo Working minutes | NG_SB_CLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP IN ('DataInputerChecker','CLOS_DataInputerChecker') THEN get_business_minute(ENTRYDATE, EXITDATE)/60 END),0) |
|  | STEP03_QUALITY_CHECKER_TAT_CPC | Tổng thời gian tất cả các bước DataInputerChecker theo cam kết SLA | NG_SB_CLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP IN ('DataInputerChecker','CLOS_DataInputerChecker') THEN get_business_minute_cpc(ENTRYDATE, EXITDATE)/60 END),0) |
|  | STEP04_UNDMAKER_CL_TAT | Tổng thời gian tất cả các bước UnderwriterMaker theo Calendar minutes | NG_SB_CLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'UnderwriterMaker' THEN TAT/3600 END),0) |
|  | STEP04_UNDMAKER_WK_TAT | Tổng thời gian tất cả các bước UnderwriterMaker theo Working minutes | NG_SB_CLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'UnderwriterMaker' THEN get_business_minute(ENTRYDATE, EXITDATE)/60 END),0) |
|  | STEP04_UNDMAKER_TAT_CPC | Tổng thời gian tất cả các bước UnderwriterMaker theo cam kết SLA | NG_SB_CLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'UnderwriterMaker' THEN get_business_minute_cpc(ENTRYDATE, EXITDATE)/60 END),0) |
|  | STEP04_UNDCHECKER_CL_TAT | Tổng thời gian tất cả các bước UnderwriterChecker theo Calendar minutes | NG_SB_CLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'UnderwriterChecker' THEN TAT/3600 END),0) |
|  | STEP04_UNDCHECKER_WK_TAT | Tổng thời gian tất cả các bước UnderwriterChecker theo Working minutes | NG_SB_CLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'UnderwriterChecker' THEN get_business_minute(ENTRYDATE, EXITDATE)/60 END),0) |
|  | STEP04_UNDCHECKER_TAT_CPC | Tổng thời gian tất cả các bước UnderwriterChecker theo cam kết SLA | NG_SB_CLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'UnderwriterChecker' THEN get_business_minute_cpc(ENTRYDATE, EXITDATE)/60 END),0) |
|  | STEP04_UND_TAT_CPC | Tổng thời gian tất cả các bước UnderwriterMaker và UnderwriterChecker theo cam kết SLA | NG_SB_CLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP IN ('UnderwriterMaker','UnderwriterChecker') THEN get_business_minute_cpc(ENTRYDATE, EXITDATE)/60 END),0) |
|  | STEP07_APPROVER_CL_TAT | Tổng thời gian tất cả các bước CreditApproval theo Calendar minutes | NG_SB_CLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'CreditApproval' THEN TAT/3600 END), 0) |
|  | STEP07_APPROVER_WK_TAT | Tổng thời gian tất cả các bước CreditApproval theo Working minutes | NG_SB_CLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'CreditApproval' THEN get_business_minute(ENTRYDATE, EXITDATE)/60 END),0) |
|  | STEP07_APPROVER_TAT_CPC | Tổng thời gian tất cả các bước CreditApproval theo cam kết SLA | NG_SB_CLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'CreditApproval' THEN get_business_minute_cpc(ENTRYDATE, EXITDATE)/60 END),0) |
|  | STEP07_COMMITTEE_CL_TAT | Tổng thời gian tất cả các bước CreditCommittee theo Calendar minutes | NG_SB_CLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'CreditCommittee' THEN TAT/3600 END), 0) |
|  | STEP07_COMMITTEE_WK_TAT | Tổng thời gian tất cả các bước CreditCommittee theo Working minutes | NG_SB_CLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'CreditCommittee' THEN get_business_minute(ENTRYDATE, EXITDATE)/60 END),0) |
|  | REF_PRODUCT | Nhóm sản phẩm SLA | BC5TAT – sheet: 1/ cam kết SLA TDKHDN luồng 1/ cam kết SLA TDKHDN luồng 2 (file1) 2/ cam kết SLA TDKHDNL (file3) Lấy giá trị NVL(file1.REF_PRODUCT, file3.REF_PRODUCT) |
|  | SLA_CREDIT_OFFICER | Cam kết SLA của Phòng thẩm định | BC5TAT – sheet: 1/ cam kết SLA TDKHDN luồng 2 (file2) 2/ cam kết SLA TDKHDNL (file3) Lấy giá trị NVL(file2.SLA_CREDIT_OFFICER, file3. SLA_CREDIT_OFFICER) |
|  | SLA_CREDIT_APPROVER | Cam kết SLA của Chuyên gia phê duyệt | BC5TAT – sheet: 1/ cam kết SLA TDKHDN luồng 2 (file2) 2/ cam kết SLA TDKHDNL (file3) + Nếu d.APP_GRP = 'C1' gán giá trị '4,00' + Trường hợp còn lại lấy NVL(file2.SLA_CREDIT_APPROVER, file3.SLA_CREDIT_APPROVER) |
|  | SLA_MARKER | Cam kết SLA của Chuyên viên thẩm định | BC5TAT – sheet: 1/ cam kết SLA TDKHDN luồng 2 (file2) 2/ cam kết SLA TDKHDNL (file3) Lấy giá trị NVL(file2.SLA_MARKER, file3.SLA_MARKER) |
|  | SLA_CHECKER | Cam kết SLA của Kiểm soát thẩm định | BC5TAT – sheet: 1/ cam kết SLA TDKHDN luồng 2 (file2) 2/ cam kết SLA TDKHDNL (file3) Lấy giá trị NVL(file2.SLA_CHECKER, file3.SLA_CHECKER) |
|  | SLA_MARKER_RESUTL | Kết quả SLA của Chuyên viên thẩm định | + Nếu STEP04_UNDMAKER_TAT_CPC > SLA_MARKER giá giá trị 'KHONG DAT' + Nếu STEP04_UNDMAKER_TAT_CPC ≤ SLA_MARKER gán giá trị 'DAT' |
|  | SLA_CHECKER_RESUTL | Kết quả SLA của Kiểm soát thẩm định | + Nếu STEP04_UNDCHECKER_TAT_CPC> SLA_CHECKER gán giá trị 'KHONG DAT' + Nếu STEP04_UNDCHECKER_TAT_CPC ≤ SLA_CHECKER gán giá trị 'DAT' |
|  | SLA_CO_RESUTL | Kết quả SLA của Phòng thẩm định | + Nếu STEP04_UND_TAT_CPC > SLA_CREDIT_OFFICER gán giá trị 'KHONG DAT' + Nếu STEP04_UND_TAT_CPC ≤ SLA_CREDIT_OFFICER gán giá trị 'DAT' |
|  | SLA_APPROVER_RESULT | Kết quả SLA của Chuyên gia phê duyệt | + Nếu STEP07_APPROVER_TAT_CPC > SLA_CREDIT_APPROVER gán giá trị 'KHONG DAT' + Nếu STEP07_APPROVER_TAT_CPC ≤ SLA_CREDIT_APPROVER gán giá trị 'DAT' |
|  | SLA_CO_APPROVER_RESULT | Kết quả SLA của Phòng thẩm định và Chuyên gia phê duyệt | + Nếu (STEP04_UND_TAT_CPC + STEP07_APPROVER_TAT_CPC) > (SLA_CREDIT_OFFICER + SLA_CREDIT_APPROVER) gán giá trị 'KHONG DAT' + Nếu (STEP04_UND_TAT_CPC + STEP07_APPROVER_TAT_CPC) ≤ (SLA_CREDIT_OFFICER + SLA_CREDIT_APPROVER) gán giá trị 'DAT' |
|  | TAT_PHONG_CL_TAT | Tổng thời gian tất cả các bước UnderwriterMaker và UnderwriterChecker theo Calendar minutes | NG_SB_CLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'UnderwriterMaker' THEN TAT/3600 END),0) + NVL(SUM(CASE WHEN WORKSTEP = 'UnderwriterChecker' THEN TAT/3600 END),0) |
|  | TAT_PHONG_WK_TAT | Tổng thời gian tất cả các bước UnderwriterMaker và UnderwriterChecker theo Working minutes | NG_SB_CLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'UnderwriterMaker' THEN get_business_minute(ENTRYDATE, EXITDATE)/60 END),0) + NVL(SUM(CASE WHEN WORKSTEP = 'UnderwriterChecker' THEN get_business_minute(ENTRYDATE, EXITDATE)/60 END),0) |
|  | TAT_KHOI_PDTD_CL_TAT | Tổng thời gian tất cả các bước Phòng thẩm định và Chuyên gia phê duyệt theo Calendar minutes | NG_SB_CLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP IN ('UnderwriterMaker','UnderwriterChecker','CreditApproval','CreditCommittee') THEN TAT/3600 END),0) |
|  | TAT_KHOI_PDTD_WK_TAT | Tổng thời gian tất cả các bước Phòng thẩm định và Chuyên gia phê duyệt theo Working minutes | NG_SB_CLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP IN ('UnderwriterMaker','UnderwriterChecker','CreditApproval','CreditCommittee') THEN get_business_minute(ENTRYDATE, EXITDATE)/60 END),0) |
|  | BI_FLAG_APPROVAL | Phê duyệt lần đầu/ từ lần thứ 2 | NG_SB_CLOS_ENTRY_EXIT> CASE WHEN EXITDATE <= NVL( MIN(CASE WHEN WORKSTEP IN ('CreditApproval', 'CreditCommittee') AND DECISION IN ('Submit', 'Send To HOSupport', 'Send To PostSanction', 'Reject', 'Submit To DisbursementMaker') THEN EXITDATE END) OVER (PARTITION BY WINAME), SYSDATE) THEN 'First Approval' ELSE 'From Second Approval' END |
|  | ENTRYDATE_DDE | Thời gian lần đầu lên bước DetailDataEntry (dd/mm/yyyy) | NG_SB_CLOS_ENTRY_EXIT> Lấy Min(ENTRYDATE) tại WORKSTEP IN ('DetailDataEntry','CLOS_DetailDataEntry') |
|  | EXITDATE_DDE | Thời gian kết thúc bước DetailDataEntry (dd/mm/yyyy) | NG_SB_CLOS_ENTRY_EXIT> Lấy Max(EXITDATE) tại WORKSTEP = 'DetailDataEntry' |
|  | SLA_DE | Cam kết SLA của Chuyên viên nhập liệu | BC5TAT - sheet cam kết SLA NLTT – CLOS > SLA_DE_RESULT |
|  | SLA_QC | Cam kết SLA của Kiểm soát nhập liệu | BC5TAT - sheet cam kết SLA NLTT – CLOS > SLA_QC_RESULT |
|  | SLA_DE_RESULT | Kết quả SLA của Chuyên viên nhập liệu | + Nếu STEP02_DDE_TAT_CPC > SLA_DE gán giá trị 'KHONG DAT' + Nếu STEP02_DDE_TAT_CPC ≤ SLA_DE gán giá trị 'DAT' |
|  | SLA_QC_RESULT | Kết quả SLA của Kiểm soát nhập liệu | + Nếu STEP03_QUALITY_CHECKER_TAT_CPC > SLA_QC gán giá trị 'KHONG DAT' + Nếu STEP03_QUALITY_CHECKER_TAT_CPC ≤ SLA_QC gán giá trị 'DAT' |
|  | SLA_DE_TOTAL_RESULT | Kết quả SLA của Nhập liệu tập trung | + Nếu (STEP02_DDE_TAT_CPC + STEP03_QUALITY_CHECKER_TAT_CPC) > (SLA_DE + SLA_QC) gán giá trị 'KHONG DAT' + Nếu (STEP02_DDE_TAT_CPC + STEP03_QUALITY_CHECKER_TAT_CPC) ≤ (SLA_DE + SLA_QC) gán giá trị 'DAT' |
|  | QD_DDE | Điểm quy đổi bước DetailDataEntry | BC5TAT - sheet cam kết SLA NLTT – CLOS > QD_DDE |
|  | QD_QC | Điểm quy đổi bước DataInputerChecker | BC5TAT - sheet cam kết SLA NLTT – CLOS > QD_QC |
| Nguồn RLOS | Nguồn RLOS | Nguồn RLOS | Nguồn RLOS |
|  | SYSTEMNAME | Hệ thống (CLOS/RLOS) | 'RLOS' |
|  | PROCESSED_DATE | Ngày dữ liệu - Ngày mới nhất của dữ liệu | NG_SB_RLOS_ENTRY_EXIT Lấy ngày dữ liệu của mã hồ sơ theo thứ tự ưu tiên sau: Ngày phê duyệt cuối cùng đối với các hồ sơ đã được phê duyệt: Lấy Max(EXITDATE) với điều kiện WORKSTEP in ('CreditCommittee', 'CreditApproval') và DECISION in ('Send To HOSupport', 'Reject', 'Submit', 'Send To PostSanction', 'Submit To DisbursementMaker') Ngày hồ sơ bị Cancel: Lấy NVL(EXITDATE, ENTRYDATE) với điều kiện WORKSTEP = 'CancelRevoke' Ngày thoát bước cuối cùng của các hồ sơ chưa đến bước Phê duyệt và không ở CancelRevoke: Lấy giá trị Max(EXITDATE) |
|  | WINAME | Mã hồ sơ | NG_SB_RLOS_ENTRY_EXIT> WINAME |
|  | BI_APPSTATUS | Trạng thái hồ sơ | NG_SB_RLOS_ENTRY_EXIT> CASE WHEN DECISION IN ('Submit', 'Send To PostSanction','Submit To DisbursementMaker', 'Send To HOSupport') THEN 'Approved' WHEN DECISION = 'Reject' THEN 'Rejected' WHEN WORKSTEP IN ('CancelRevoke','CancelPermanent') THEN 'Cancelled' ELSE 'Processing' END |
|  | STEP01_BRANCH_CL_TAT | Tổng thời gian xử lý tại chi nhánh theo Calendar minutes | NG_SB_RLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'BranchSupport' THEN TAT/3600 END),0) |
|  | STEP01_BRANCH_WK_TAT | Tổng thời gian xử lý tại chi nhánh theo Working minutes (loại trừ holidays, chiều thứ 7, cả ngày chủ nhật; thời gian tính từ 8-12 và 13-17) | NG_SB_RLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'BranchSupport' THEN get_business_minute(ENTRYDATE, EXITDATE)/60 END),0) Trong đó get_business_minute(): loại trừ holidays, chiều thứ 7, cả ngày chủ nhật; thời gian tính từ 8-12 và 13-17 |
|  | STEP01_BRANCH_TAT_CPC | Tổng thời gian xử lý tại chi nhánh theo cam kết SLA (loại trừ holidays, chiều thứ 7, cả ngày chủ nhật; thời gian tính từ 8-11:30 và 13:30-16:30) | NG_SB_RLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'BranchSupport' THEN get_business_minute_cpc(ENTRYDATE, EXITDATE)/60 END),0) Trong đó get_business_minute_cpc(): loại trừ holidays, chiều thứ 7, cả ngày chủ nhật; thời gian tính từ 8-11:30 và 13:30-16:30 |
|  | STEP02_DDE_CL_TAT | Tổng thời gian tất cả các bước DetailDataEntry theo Calendar minutes | NG_SB_RLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'DetailDataEntry' THEN TAT/3600 END),0) |
|  | STEP02_DDE_WK_TAT | Tổng thời gian tất cả các bước DetailDataEntry theo Working minutes | NG_SB_RLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'DetailDataEntry' THEN get_business_minute(ENTRYDATE, EXITDATE)/60 END),0) |
|  | STEP02_DDE_TAT_CPC | Tổng thời gian tất cả các bước DetailDataEntry theo cam kết SLA | NG_SB_RLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'DetailDataEntry' THEN get_business_minute_cpc(ENTRYDATE, EXITDATE)/60 END),0) |
|  | STEP03_QUALITY_CHECKER_CL_TAT | Tổng thời gian tất cả các bước DataInputerChecker theo Calendar minutes | NG_SB_RLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'DataInputerChecker' THEN TAT/3600 END),0) |
|  | STEP03_QUALITY_CHECKER_WK_TAT | Tổng thời gian tất cả các bước DataInputerChecker theo Working minutes | NG_SB_RLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'DataInputerChecker' THEN get_business_minute(ENTRYDATE, EXITDATE)/60 END),0) |
|  | STEP03_QUALITY_CHECKER_TAT_CPC | Tổng thời gian tất cả các bước DataInputerChecker theo cam kết SLA | NG_SB_RLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'DataInputerChecker' THEN get_business_minute_cpc(ENTRYDATE, EXITDATE)/60 END),0) |
|  | STEP04_UNDMAKER_CL_TAT | Tổng thời gian tất cả các bước UnderwriterMaker theo Calendar minutes | NG_SB_RLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'UnderwriterMaker' THEN TAT/3600 END),0) |
|  | STEP04_UNDMAKER_WK_TAT | Tổng thời gian tất cả các bước UnderwriterMaker theo Working minutes | NG_SB_RLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'UnderwriterMaker' THEN get_business_minute(ENTRYDATE, EXITDATE)/60 END),0) |
|  | STEP04_UNDMAKER_TAT_CPC | Tổng thời gian tất cả các bước UnderwriterMaker theo cam kết SLA | NG_SB_RLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'UnderwriterMaker' THEN get_business_minute_cpc(ENTRYDATE, EXITDATE)/60 END),0) |
|  | STEP04_UNDCHECKER_CL_TAT | Tổng thời gian tất cả các bước UnderwriterChecker theo Calendar minutes | NG_SB_RLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'UnderwriterChecker' THEN TAT/3600 END),0) |
|  | STEP04_UNDCHECKER_WK_TAT | Tổng thời gian tất cả các bước UnderwriterChecker theo Working minutes | NG_SB_RLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'UnderwriterChecker' THEN get_business_minute(ENTRYDATE, EXITDATE)/60 END),0) |
|  | STEP04_UNDCHECKER_TAT_CPC | Tổng thời gian tất cả các bước UnderwriterChecker theo cam kết SLA | NG_SB_RLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'UnderwriterChecker' THEN get_business_minute_cpc(ENTRYDATE, EXITDATE)/60 END),0) |
|  | STEP04_UND_TAT_CPC | Tổng thời gian tất cả các bước UnderwriterMaker và UnderwriterChecker theo cam kết SLA | NG_SB_RLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP IN ('UnderwriterMaker','UnderwriterChecker') THEN get_business_minute_cpc(ENTRYDATE, EXITDATE)/60 END),0) |
|  | STEP07_APPROVER_CL_TAT | Tổng thời gian tất cả các bước CreditApproval theo Calendar minutes | NG_SB_RLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'CreditApproval' THEN TAT/3600 END), 0) |
|  | STEP07_APPROVER_WK_TAT | Tổng thời gian tất cả các bước CreditApproval theo Working minutes | NG_SB_RLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'CreditApproval' THEN get_business_minute(ENTRYDATE, EXITDATE)/60 END),0) |
|  | STEP07_APPROVER_TAT_CPC | Tổng thời gian tất cả các bước CreditApproval theo cam kết SLA | NG_SB_RLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'CreditApproval' THEN get_business_minute_cpc(ENTRYDATE, EXITDATE)/60 END),0) |
|  | STEP07_COMMITTEE_CL_TAT | Tổng thời gian tất cả các bước CreditCommittee theo Calendar minutes | NG_SB_RLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'CreditCommittee' THEN TAT/3600 END), 0) |
|  | STEP07_COMMITTEE_WK_TAT | Tổng thời gian tất cả các bước CreditCommittee theo Working minutes | NG_SB_RLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP = 'CreditCommittee' THEN get_business_minute(ENTRYDATE, EXITDATE)/60 END),0) |
|  | REF_PRODUCT | Nhóm sản phẩm SLA | BC5TAT – sheet: cam kết SLA TDKHCN> REF_PRODUCT |
|  | SLA_CREDIT_OFFICER | Cam kết SLA của Phòng thẩm định | BC5TAT – sheet: cam kết SLA TDKHCN> SLA_CREDIT_OFFICER |
|  | SLA_CREDIT_APPROVER | Cam kết SLA của Chuyên gia phê duyệt | BC5TAT – sheet: cam kết SLA TDKHCN> SLA_CREDIT_APPROVER |
|  | SLA_MARKER | Cam kết SLA của Chuyên viên thẩm định | BC5TAT – sheet: cam kết SLA TDKHCN> SLA_MARKER |
|  | SLA_CHECKER | Cam kết SLA của Kiểm soát thẩm định | BC5TAT – sheet: cam kết SLA TDKHCN> SLA_CHECKER |
|  | SLA_MARKER_RESUTL | Kết quả SLA của Chuyên viên thẩm định | + Nếu STEP04_UNDMAKER_TAT_CPC > SLA_MARKER giá giá trị 'KHONG DAT' + Nếu STEP04_UNDMAKER_TAT_CPC ≤ SLA_MARKER gán giá trị 'DAT' |
|  | SLA_CHECKER_RESUTL | Kết quả SLA của Kiểm soát thẩm định | + Nếu STEP04_UNDCHECKER_TAT_CPC> SLA_CHECKER gán giá trị 'KHONG DAT' + Nếu STEP04_UNDCHECKER_TAT_CPC ≤ SLA_CHECKER gán giá trị 'DAT' |
|  | SLA_CO_RESUTL | Kết quả SLA của Phòng thẩm định | + Nếu STEP04_UND_TAT_CPC > SLA_CREDIT_OFFICER gán giá trị 'KHONG DAT' + Nếu STEP04_UND_TAT_CPC ≤ SLA_CREDIT_OFFICER gán giá trị 'DAT' |
|  | SLA_APPROVER_RESULT | Kết quả SLA của Chuyên gia phê duyệt | + Nếu STEP07_APPROVER_TAT_CPC > SLA_CREDIT_APPROVER gán giá trị 'KHONG DAT' + Nếu STEP07_APPROVER_TAT_CPC ≤ SLA_CREDIT_APPROVER gán giá trị 'DAT' |
|  | SLA_CO_APPROVER_RESULT | Kết quả SLA của Phòng thẩm định và Chuyên gia phê duyệt | + Nếu (STEP04_UND_TAT_CPC + STEP07_APPROVER_TAT_CPC) > (SLA_CREDIT_OFFICER + SLA_CREDIT_APPROVER) gán giá trị 'KHONG DAT' + Nếu (STEP04_UND_TAT_CPC + STEP07_APPROVER_TAT_CPC) ≤ (SLA_CREDIT_OFFICER + SLA_CREDIT_APPROVER) gán giá trị 'DAT' |
|  | TAT_PHONG_CL_TAT | Tổng thời gian tất cả các bước UnderwriterMaker và UnderwriterChecker theo Calendar minutes | NG_SB_RLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP IN ('UnderwriterMaker', 'UnderwriterChecker') THEN TAT/3600 END), 0) |
|  | TAT_PHONG_WK_TAT | Tổng thời gian tất cả các bước UnderwriterMaker và UnderwriterChecker theo Working minutes | NG_SB_RLOS_ENTRY_EXIT> NVL(SUM(CASE WHEN WORKSTEP IN ('UnderwriterMaker', 'UnderwriterChecker') THEN get_business_minute(ENTRYDATE, EXITDATE)/60 END), 0) |
|  | TAT_KHOI_PDTD_CL_TAT | Tổng thời gian tất cả các bước Phòng thẩm định và Chuyên gia phê duyệt theo Calendar minutes | NG_SB_RLOS_ENTRY_EXIT> + Nếu WORKSTEP = 'CreditApproval': NVL(SUM(CASE WHEN WORKSTEP IN ('UnderwriterMaker', 'UnderwriterChecker', 'CreditApproval') THEN TAT/3600 END), 0) + Nếu WORKSTEP = 'CreditCommittee': NVL(SUM(CASE WHEN WORKSTEP IN ('UnderwriterMaker', 'UnderwriterChecker') THEN TAT/3600 END), 0) |
|  | TAT_KHOI_PDTD_WK_TAT | Tổng thời gian tất cả các bước Phòng thẩm định và Chuyên gia phê duyệt theo Working minutes | NG_SB_RLOS_ENTRY_EXIT> + Nếu WORKSTEP = 'CreditApproval': NVL(SUM(CASE WHEN WORKSTEP IN ('UnderwriterMaker', 'UnderwriterChecker', 'CreditApproval') THEN get_business_minute(ENTRYDATE, EXITDATE)/60 END), 0) + Nếu WORKSTEP = 'CreditCommittee': NVL(SUM(CASE WHEN WORKSTEP IN ('UnderwriterMaker', 'UnderwriterChecker') THEN get_business_minute(ENTRYDATE, EXITDATE)/60 END), 0) |
|  | BI_FLAG_APPROVAL | Phê duyệt lần đầu/ từ lần thứ 2 | NG_SB_RLOS_ENTRY_EXIT> CASE WHEN EXITDATE <= NVL( MIN(CASE WHEN WORKSTEP IN ('CreditApproval', 'CreditCommittee') AND DECISION IN ('Submit', 'Send To HOSupport', 'Send To PostSanction', 'Reject', 'Submit To DisbursementMaker') THEN EXITDATE END) OVER (PARTITION BY WINAME), SYSDATE) THEN 'First Approval' ELSE 'From Second Approval' END |
|  | ENTRYDATE_DDE | Thời gian lần đầu lên bước DetailDataEntry (dd/mm/yyyy) | NG_SB_RLOS_ENTRY_EXIT> Lấy Min(ENTRYDATE) tại WORKSTEP = 'DetailDataEntry' |
|  | EXITDATE_DDE | Thời gian kết thúc bước DetailDataEntry (dd/mm/yyyy) | NG_SB_RLOS_ENTRY_EXIT> Lấy Max(EXITDATE) tại WORKSTEP = 'DetailDataEntry' |
|  | SLA_DE | Cam kết SLA của Chuyên viên nhập liệu | BC5TAT - sheet cam kết SLA NLTT – RLOS > SLA_DE_RESULT |
|  | SLA_QC | Cam kết SLA của Kiểm soát nhập liệu | BC5TAT - sheet cam kết SLA NLTT – RLOS > SLA_QC_RESULT |
|  | SLA_DE_RESULT | Kết quả SLA của Chuyên viên nhập liệu | + Nếu STEP02_DDE_TAT_CPC > SLA_DE gán giá trị 'KHONG DAT' + Nếu STEP02_DDE_TAT_CPC ≤ SLA_DE gán giá trị 'DAT' |
|  | SLA_QC_RESULT | Kết quả SLA của Kiểm soát nhập liệu | + Nếu STEP03_QUALITY_CHECKER_TAT_CPC > SLA_QC gán giá trị 'KHONG DAT' + Nếu STEP03_QUALITY_CHECKER_TAT_CPC ≤ SLA_QC gán giá trị 'DAT' |
|  | SLA_DE_TOTAL_RESULT | Kết quả SLA của Nhập liệu tập trung | + Nếu (STEP02_DDE_TAT_CPC + STEP03_QUALITY_CHECKER_TAT_CPC) > (SLA_DE + SLA_QC) gán giá trị 'KHONG DAT' + Nếu (STEP02_DDE_TAT_CPC + STEP03_QUALITY_CHECKER_TAT_CPC) ≤ (SLA_DE + SLA_QC) gán giá trị 'DAT' |
|  | QD_DDE | Điểm quy đổi bước DetailDataEntry | BC5TAT - sheet cam kết SLA NLTT – RLOS > QD_DDE |
|  | QD_QC | Điểm quy đổi bước DataInputerChecker | BC5TAT - sheet cam kết SLA NLTT – RLOS > QD_QC |
