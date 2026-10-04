# BC7 — SRS extract (nguồn: input/srs_report/BC7_PDTD_DTM_SRS_v1.0.docx)

> Auto-extracted. Dùng để đối chiếu logic SRS (STG_LOS -> báo cáo) với LLD (STG_LOS -> SB_DWH -> STG_DTM -> PDTD_DTM -> báo cáo).

## Use case

- **Tên**: Báo cáo EXCEPTION - FTR
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
| a | SBLOS2.NG_SB_CLOS_EXCEPTION |  |
| b | SBLOS2.NG_SB_CLOS_ENTRY_EXIT | LEFT JOIN với điều kiện: a.WI_NAME = b.WINAME |
| c | SBLOS2.NG_SB_CLOS_EXTTABLE | LEFT JOIN với điều kiện: a.WI_NAME = c.WI_NAME |
| d | SBLOS2.NG_SB_CLOS_MAS_EXCEPTION | LEFT JOIN với điều kiện: a.EXCEPTION_CATEGORY = d.EXCEPTION_CATEGORY and a.EXCEPTION_NAME = d.EXCEPTION_NAME |
| f | SBLOS2.NG_SB_CLOS_CUST_INFO | LEFT JOIN với điều kiện: a.WI_NAME = f.WI_NAME |
| g | REF_PHAN_LOAI_DDE | LEFT JOIN với điều kiện: a.EXCEPTION_CATEGORY = g.EXCEPTION_CATEGORY and g.SYSTEMNAME = 'CLOS' |

### Nguồn RLOS

| Alias | Bảng nguồn | Điều kiện Join |
|---|---|---|
| a | SBLOS2.NG_SB_RLOS_EXCEPTION |  |
| b | SBLOS2.NG_SB_RLOS_MAS_EXCEPTION | LEFT JOIN với điều kiện: a.EXCEPTION_CATEGORY = b.EXCEPTION_CATEGORY and a.EXCEPTION_NAME = b.EXCEPTION_NAME |
| c | SBLOS2.NG_SB_RLOS_EXTTABLE | LEFT JOIN với điều kiện: a.WI_NAME = c.WI_NAME |
| d | SBLOS2.NG_SB_RLOS_ENTRY_EXIT | LEFT JOIN với điều kiện: a.WI_NAME = d.WINAME |
| f | SBLOS2.NG_SB_RLOS_APPLICANT_GENERAL | LEFT JOIN với điều kiện: a.WI_NAME = f.WI_NAME |
| g | REF_PHAN_LOAI_DDE | LEFT JOIN với điều kiện: a.EXCEPTION_CATEGORY = g.EXCEPTION_CATEGORY and g.SYSTEMNAME = 'RLOS' |

## Danh sách trường báo cáo & logic lấy dữ liệu

| STT | Trường | Ý nghĩa | Cách lấy dữ liệu |
|---|---|---|---|
| Nguồn CLOS | Nguồn CLOS | Nguồn CLOS | Nguồn CLOS |
|  | PROCESSED_DATE | Ngày dữ liệu | NG_SB_CLOS_EXCEPTION> TRUNC(RAISED_DATE_TIME) |
|  | WI_NAME | Mã hồ sơ | NG_SB_CLOS_EXCEPTION> WI_NAME |
|  | ACTIVITYNAME | Tên bước | NG_SB_CLOS_EXCEPTION a> NG_SB_CLOS_MAS_EXCEPTION d > Lấy giá trị d.ACTIVITYNAME với điều kiện: Tồn tại bản ghi trong bảng NG_SB_CLOS_ENTRY_EXIT (e) thỏa mãn điều kiện e.WINAME = a.WI_NAME AND e.WORKSTEP = d.ACTIVITYNAME AND e.DECISION = d.DECISION |
|  | EXCEPTION_CATEGORY | Nhóm lý do quyết định | NG_SB_CLOS_EXCEPTION> EXCEPTION_CATEGORY |
|  | EXCEPTION_NAME | Tên lý do | NG_SB_CLOS_EXCEPTION> EXCEPTION_NAME |
|  | EXCEPTION_REMARKS | Ý kiến | NG_SB_CLOS_EXCEPTION> EXCEPTION_REMARKS |
|  | RAISED_BY | User tạo lý do | NG_SB_CLOS_EXCEPTION> RAISED_BY |
|  | RAISED_DATE_TIME | Thời gian tạo lý do | NG_SB_CLOS_EXCEPTION> RAISED_DATE_TIME |
|  | EXCEPTION_CODE | Code lý do | NG_SB_CLOS_EXCEPTION> EXCEPTION_CATEGORY + Nếu có mã code trước dấu ':' thì lấy REGEXP_SUBSTR(EXCEPTION_CATEGORY, '^[^:]+') + Nếu không có mã code trước dấu ':' thì gán giá trị NULL |
|  | LOANCASEID | Mã LOANCASEID | NG_SB_CLOS_EXTTABLE> LOANCASEID |
|  | CHECK_FTR | Hồ sơ đạt FTR hay không đạt FTR | NG_SB_CLOS_EXCEPTION a> NG_SB_CLOS_MAS_EXCEPTION d > NG_SB_CLOS_ENTRY_EXIT h> NG_SB_CLOS_CUST_INFO f> Từ bảng NG_SB_CLOS_EXCEPTION, lấy thông tin WI_NAME. Xét các EXCEPTION_CATEGORY, EXCEPTION_NAME của WI_NAME trong bảng NG_SB_CLOS_EXCEPTION (a) và WORKSTEP, DECISION tương ứng trong bảng NG_SB_CLOS_ENTRY_EXIT (h) (join qua điều kiện: h.WINAME = a.WI_NAME and h.WORKSTEP = d.ACTIVITYNAME and h.DECISION = d.DECISION) Các trường hợp Exception được tính là ngoại lệ FTR của KHDN f.CUST_GROUP in ('MSME','SME','USME') 1.1. h.WORKSTEP = 'DetailDataEntry' and h.DECISION = 'Send_Back' + a.EXCEPTION_CATEGORY LIKE N'%DE-BR-NEW: Chất lượng bản scan mờ không thấy thông tin - %' + a.EXCEPTION_CATEGORY = N'DE-BR-NEW: Bổ sung ý kiến tư vấn của bên thứ 3 (pháp chế, chính sách, sản phẩm, thẩm định,…)' + a.EXCEPTION_CATEGORY = N'DE-BR-NEW: Lỗi hệ thống (LOS, T24, XHTD,…)' + a.EXCEPTION_CATEGORY = N'DE-BR-NEW: Lỗi lựa chọn phân luồng, quy trình trên hệ thống' 1.2. h.WORKSTEP = 'DataInputerChecker' and h.DECISION = 'Additional_Doc_Required' + a.EXCEPTION_CATEGORY LIKE N'%BC3-BR-NEW: Chất lượng bản scan mờ không thấy thông tin - %' + a.EXCEPTION_CATEGORY = N'BC3-BR-NEW: Bổ sung ý kiến tư vấn của bên thứ 3 (pháp chế, chính sách, sản phẩm, thẩm định,…)' + a.EXCEPTION_CATEGORY = N'BC3-BR-NEW: Lỗi hệ thống (LOS, T24, XHTD,…)' 1.3. h.WORKSTEP = 'UnderwriterMaker' and h.DECISION = 'Additional_Doc_Required' + a.EXCEPTION_CATEGORY LIKE N'%UW-BR- FTR:Bổ sung hồ sơ%' + a.EXCEPTION_CATEGORY = N'UW-BR-FTR: bổ sung hồ sơ' + a.EXCEPTION_CATEGORY = N'UW-BR-FTR:Giải trình, làm rõ nội dung hồ sơ trường hợp các nội dung yêu cầu giải trình làm rõ ngoài HD thẩm định' 1.4. h.WORKSTEP = 'UnderwriterMaker' and h.DECISION = 'Send_Back to BranchSupport' + a.EXCEPTION_CATEGORY = N'UW-BR: Gửi dự thảo đề xuất cho chi nhánh' Các trường hợp Exception được tính là ngoại lệ FTR của KHDNL, ĐT&ĐCTC: f.CUST_GROUP in ('FDI','SOC','JSC','NBFI', 'BANK','STR') 2.1. h.WORKSTEP = 'DetailDataEntry' and h.DECISION = 'Send_Back' + a.EXCEPTION_CATEGORY LIKE N'%DE-BR-NEW: Chất lượng bản scan mờ không thấy thông tin - %' + a.EXCEPTION_CATEGORY = N'DE-BR-NEW: Bổ sung ý kiến tư vấn của bên thứ 3 (pháp chế, chính sách, sản phẩm, thẩm định,…)' + a.EXCEPTION_CATEGORY = N'DE-BR-NEW: Lỗi hệ thống (LOS, T24, XHTD,…)' + a.EXCEPTION_CATEGORY = N'DE-BR-NEW: Lỗi lựa chọn phân luồng, quy trình trên hệ thống' 2.2. h.WORKSTEP = 'DataInputerChecker' and h.DECISION = 'Additional_Doc_Required' + a.EXCEPTION_CATEGORY LIKE N'%BC3-BR-NEW: Chất lượng bản scan mờ không thấy thông tin - %' + a.EXCEPTION_CATEGORY = N'BC3-BR-NEW: Bổ sung ý kiến tư vấn của bên thứ 3 (pháp chế, chính sách, sản phẩm, thẩm định,…)' + a.EXCEPTION_CATEGORY = N'BC3-BR-NEW: Lỗi hệ thống (LOS, T24, XHTD,…)' 2.3. h.WORKSTEP = 'UnderwriterMaker' and h.DECISION = 'Additional_Doc_Required' + a.EXCEPTION_CATEGORY LIKE N'%UW-BR- FTR:Bổ sung hồ sơ%' + a.EXCEPTION_CATEGORY = N'UW-BR-FTR: bổ sung hồ sơ' + a.EXCEPTION_CATEGORY = N'UW-BR-FTR:Giải trình, làm rõ nội dung hồ sơ trường hợp các nội dung yêu cầu giải trình làm rõ ngoài HD thẩm định' + a.EXCEPTION_CATEGORY = N'UW-BR: Gửi dự thảo đề xuất cho chi nhánh' Logic + Nếu hồ sơ có tất cả các Exception đều là trường hợp ngoại lệ thì gán giá trị 'First Time Right' + Nếu hồ sơ có ít nhất một Exception không thuộc trường hợp ngoại lệ thì gán giá trị 'Not First Time Right' |
|  | FIRST_WORKSTEP_RETURN | Bước trả về lần đầu | NG_SB_CLOS_ENTRY_EXIT>WORKSTEP Lấy giá trị WORKSTEP tại dòng Min(EXITDATE) của mã hồ sơ Với điều kiện: EXITDATE IS NOT NULL AND ((WORKSTEP = 'DetailDataEntry' AND DECISION = 'Send_Back') OR (WORKSTEP IN ( 'DataInputerChecker', 'UnderwriterMaker', 'CreditApproval') AND DECISION = 'Additional_Doc_Required') OR (WORKSTEP = 'UnderwriterMaker' AND DECISION = 'Send_Back to BranchSupport')) |
|  | PHAN_LOAI_DDE | Lỗi Nhập liệu/Thiếu Checklist | REF_PHAN_LOAI_DDE > PHAN_LOAI_DDE |
| Nguồn RLOS | Nguồn RLOS | Nguồn RLOS | Nguồn RLOS |
|  | PROCESSED_DATE | Ngày dữ liệu | NG_SB_RLOS_EXCEPTION> RAISED_DATE_TIME |
|  | WI_NAME | Mã hồ sơ | NG_SB_RLOS_EXCEPTION> WI_NAME |
|  | ACTIVITYNAME | Tên bước | NG_SB_RLOS_EXCEPTION a> NG_SB_RLOS_MAS_EXCEPTION b > Lấy giá trị b.ACTIVITYNAME với điều kiện: Tồn tại bản ghi trong bảng NG_SB_RLOS_ENTRY_EXIT (e) thỏa mãn điều kiện e.WINAME = a.WI_NAME AND e.WORKSTEP = b.ACTIVITYNAME AND e.DECISION = b.DECISION |
|  | EXCEPTION_CATEGORY | Nhóm lý do quyết định | NG_SB_RLOS_EXCEPTION> EXCEPTION_CATEGORY |
|  | EXCEPTION_NAME | Tên lý do | NG_SB_RLOS_EXCEPTION> EXCEPTION_NAME |
|  | EXCEPTION_REMARKS | Ý kiến | NG_SB_RLOS_EXCEPTION> EXCEPTION_REMARKS |
|  | RAISED_BY | User tạo lý do | NG_SB_RLOS_EXCEPTION> RAISED_BY |
|  | RAISED_DATE_TIME | Thời gian tạo lý do | NG_SB_RLOS_EXCEPTION> RAISED_DATE_TIME |
|  | EXCEPTION_CODE | Code lý do | NG_SB_RLOS_EXCEPTION> EXCEPTION_CATEGORY + Nếu có mã code trước dấu ':' thì lấy REGEXP_SUBSTR(EXCEPTION_CATEGORY, '^[^:]+') + Nếu không có mã code trước dấu ':' thì gán giá trị NULL |
|  | LOANCASEID | Mã LOANCASEID | NG_SB_RLOS_EXTTABLE> LOANCASEID |
|  | CHECK_FTR | Hồ sơ đạt FTR hay không đạt FTR | NG_SB_RLOS_EXCEPTION a> NG_SB_RLOS_APPLICANT_GENERAL f> Phân nhóm sản phẩm (BI_SUB_PRODUCT): CASE WHEN f.SUB_PRODUCT LIKE '%Phát hành%' OR f.SUB_PRODUCT LIKE '%TTD%' THEN 'Credit Card' ELSE f.SUB_PRODUCT END Các trường hợp Exception được tính là ngoại lệ FTR Điều kiện a.EXCEPTION_CATEGORY LIKE '%BR%' + a.EXCEPTION_NAME = 'UW-BR-FTR : Hồ sơ Scan mờ không rõ thông tin' AND BI_SUB_PRODUCT = 'Credit Card' + a.EXCEPTION_NAME = 'UW-BR-FTR : Hồ sơ Scan thiếu trang không đúng định dạng' AND NVL(BI_SUB_PRODUCT, 'XX') <> 'Credit Card' + a.EXCEPTION_NAME ='DE-BR-NEW: Chứng từ thiếu thông tin theo checklist' AND NVL(BI_SUB_PRODUCT, 'XX') <> 'Credit Card' + a.EXCEPTION_NAME = 'DE-BR-NEW: Chất lượng bản scan mờ không thấy thông tin' AND a.BI_SUB_PRODUCT = 'Credit Card' + a.EXCEPTION_CATEGORY LIKE '%FTR%' AND a.EXCEPTION_NAME NOT IN ('UW-BR-FTR : Hồ sơ Scan mờ không rõ thông tin', 'UW-BR-FTR : Hồ sơ Scan thiếu trang không đúng định dạng') Logic + Nếu hồ sơ có tất cả các Exception đều là trường hợp ngoại lệ thì gán giá trị 'First Time Right' + Nếu hồ sơ có ít nhất một Exception không thuộc trường hợp ngoại lệ thì gán giá trị 'Not First Time Right' |
|  | FIRST_WORKSTEP_RETURN | Bước trả về lần đầu | NG_SB_RLOS_ENTRY_EXIT>WORKSTEP Lấy giá trị WORKSTEP tại dòng Min(EXITDATE) của mã hồ sơ Với điều kiện EXITDATE IS NOT NULL AND ((WORKSTEP = 'DetailDataEntry' AND DECISION = 'Send_Back') OR (WORKSTEP IN ( 'DataInputerChecker', 'UnderwriterMaker', 'CreditApproval') AND DECISION = 'Additional_Doc_Required') OR (WORKSTEP = 'UnderwriterMaker' AND DECISION = 'Send_Back to BranchSupport')) |
|  | PHAN_LOAI_DDE | Lỗi Nhập liệu/Thiếu Checklist | REF_PHAN_LOAI_DDE > PHAN_LOAI_DDE |
