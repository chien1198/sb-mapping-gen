# BC8 — SRS extract (nguồn: input/srs_report/BC8_PDTD_DTM_SRS_v1.0.docx)

> Auto-extracted. Dùng để đối chiếu logic SRS (STG_LOS -> báo cáo) với LLD (STG_LOS -> SB_DWH -> STG_DTM -> PDTD_DTM -> báo cáo).

## Use case

- **Tên**: Báo cáo RETURN
- **Mô tả**: Báo cáo cung cấp các thông tin lý do của hồ sơ trình qua Khối PDTD và có bước trả về/ bổ sung/ từ chối/ hủy
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
| a | SBLOS2.NG_SB_CLOS_ENTRY_EXIT | WHERE WORKSTEP in ('DetailDataEntry', 'DataInputerChecker', 'UnderwriterMaker', 'UnderwriterChecker', 'CreditApproval', 'CreditCommittee') and DECISION in ('Send_Back', 'Send_Back to DDE', 'Send Back DataInputerChecker', 'Send Back to DataInputerChecker', 'Additional_Doc_Required', 'Cancel', 'Reject') |
| b | SBLOS2.NG_SB_CLOS_EXCEPTION | LEFT JOIN với điều kiện: a.WINAME = b.WI_NAME |

### Nguồn RLOS

| Alias | Bảng nguồn | Điều kiện Join |
|---|---|---|
| a | SBLOS2.NG_SB_RLOS_ENTRY_EXIT | WHERE WORKSTEP in ('DetailDataEntry', 'DataInputerChecker', 'UnderwriterMaker', 'UnderwriterChecker', 'CreditApproval', 'CreditCommittee') and DECISION in ('Send_Back', 'Send_Back to DDE', 'Send Back DataInputerChecker', 'Send Back to DataInputerChecker', 'Additional_Doc_Required', 'Cancel', 'Reject') |
| b | SBLOS2.NG_SB_CLOS_EXCEPTION | LEFT JOIN với điều kiện: a.WINAME = b.WI_NAME |

## Danh sách trường báo cáo & logic lấy dữ liệu

| STT | Trường | Ý nghĩa | Cách lấy dữ liệu |
|---|---|---|---|
| Nguồn CLOS | Nguồn CLOS | Nguồn CLOS | Nguồn CLOS |
|  | PROCESSED_DATE | Ngày dữ liệu | NG_SB_CLOS_ENTRY_EXIT> EXITDATE |
|  | WI_NAME | Mã hồ sơ | NG_SB_CLOS_ENTRY_EXIT> WINAME |
|  | WORKSTEP | Bước hồ sơ | NG_SB_CLOS_ENTRY_EXIT> WORKSTEP |
|  | DECISION | Quyết định | NG_SB_CLOS_ENTRY_EXIT> DECISION |
|  | EXITDATE | Thời gian tạo quyết định => thời gian eu tạo quyết định tương ứng | NG_SB_CLOS_ENTRY_EXIT> EXITDATE |
|  | SL_RETURN_NHAPLIEU | Số lần return tại Nhập liệu => đếm số lần hồ sơ có Decision = Send Back tại bước Detail Data Entry + Decision = Additional Doc Required tại bước Data Inputer Checker | NG_SB_CLOS_ENTRY_EXIT a> SUM(CASE WHEN (a.WORKSTEP = 'DetailDataEntry' AND a.DECISION = 'Send_Back') THEN 1 WHEN (a.WORKSTEP = 'DataInputerChecker' AND a.DECISION = 'Additional_Doc_Required') THEN 1 ELSE 0 END) Group by WINAME |
|  | SL_RETURN_THAMDINH | Số lần return tại Thẩm định => Cộng tổng số lần return tại bước Underwriter Maker + Underwriter Checker | NG_SB_CLOS_ENTRY_EXIT a> NG_SB_CLOS_EXCEPTION b> Tổng UnderwriterMaker + UnderwriterChecker UnderwriterMaker COUNT(a.WORKSTEP = 'UnderwriterMaker' AND a.DECISION = 'Additional_Doc_Required') - COUNT(b.EXCEPTION_CATEGORY = 'Gửi dự thảo đề xuất cho chi nhánh') 2. UnderwriterChecker COUNT(a. WORKSTEP = 'UnderwriterChecker' AND a.DECISION = 'Additional_Doc_Required') Group by WINAME |
|  | SL_RETURN_PHEDUYET | Số lần return tại Cấp Phê duyệt | NG_SB_CLOS_ENTRY_EXIT a> SUM(CASE WHEN (a.WORKSTEP IN ('CreditApproval', 'CreditCommittee') AND a.DECISION = 'Additional_Doc_Required') THEN 1 ELSE 0 END) Group by WINAME |
| Nguồn RLOS | Nguồn RLOS | Nguồn RLOS | Nguồn RLOS |
|  | PROCESSED_DATE | Ngày dữ liệu | NG_SB_RLOS_ENTRY_EXIT> EXITDATE |
|  | WI_NAME | Mã hồ sơ | NG_SB_RLOS_ENTRY_EXIT> WINAME |
|  | WORKSTEP | Bước hồ sơ | NG_SB_RLOS_ENTRY_EXIT> WORKSTEP |
|  | DECISION | Quyết định | NG_SB_RLOS_ENTRY_EXIT> DECISION |
|  | EXITDATE | Thời gian tạo quyết định => thời gian eu tạo quyết định tương ứng | NG_SB_RLOS_ENTRY_EXIT> EXITDATE |
|  | SL_RETURN_NHAPLIEU | Số lần return tại Nhập liệu => đếm số lần hồ sơ có Decision = Send Back tại bước Detail Data Entry + Decision = Additional Doc Required tại bước Data Inputer Checker | NG_SB_RLOS_ENTRY_EXIT a> SUM(CASE WHEN (a.WORKSTEP = 'DetailDataEntry' AND a.DECISION = 'Send_Back') THEN 1 WHEN (a.WORKSTEP = 'DataInputerChecker' AND a.DECISION = 'Additional_Doc_Required') THEN 1 ELSE 0 END) Group by WINAME |
|  | SL_RETURN_THAMDINH | Số lần return tại Thẩm định => Cộng tổng số lần return tại bước Underwriter Maker + Underwriter Checker | NG_SB_RLOS_ENTRY_EXIT a> NG_SB_CLOS_EXCEPTION b> Tổng Underwriter Maker + Underwriter Checker UnderwriterMaker SUM(CASE WHEN a.WORKSTEP = 'UnderwriterMaker' AND a.DECISION = 'Additional_Doc_Required' THEN 1 ELSE 0 END) - COUNT(DISTINCT CASE WHEN b.EXCEPTION_NAME = 'UW-BR-FTR: Gửi dự thảo phê duyệt TD' THEN b.WI_NAME // '/' // TO_CHAR(b.RAISED_DATE_TIME, 'YYYYMMDDHH24MISS') END) UnderwriterChecker SUM( CASE WHEN a.WORKSTEP = 'UnderwriterChecker' AND a.DECISION = 'Additional_Doc_Required' THEN 1 ELSE 0 END) - COUNT(DISTINCT CASE WHEN b.EXCEPTION_CATEGORY = 'CK-BR: Gửi dự thảo về ĐVKD' THEN b.WI_NAME // '/' // TO_CHAR(b.RAISED_DATE_TIME, 'YYYYMMDDHH24MISS') END) Group by WINAME |
|  | SL_RETURN_PHEDUYET | Số lần return tại Cấp Phê duyệt | NG_SB_RLOS_ENTRY_EXIT a> SUM(CASE WHEN (a.WORKSTEP IN ('CreditApproval', 'CreditCommittee') AND a.DECISION = 'Additional_Doc_Required') THEN 1 ELSE 0 END) Group by WINAME |
