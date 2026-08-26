# FCT_LOS_APPLICATION_DAILY

Nguồn: xlsx sheet "FCT_LOS_APPLICATION_DAILY" (DATAMODEL_DWH_LOS_20260820.xlsx)

- Loại bảng: FCT - bảng xương sống
- Mô tả: Trạng thái hồ sơ tín dụng theo ngày, đã tính sẵn toàn bộ trường phái sinh và lũy kế ở cấp hồ sơ.
- Lưu gì: Lưu ảnh chụp trạng thái của một hồ sơ tại một ngày dữ liệu: ngày nghiệp vụ theo ba mức ưu tiên, trạng thái cuối, bước và quyết định cuối, người xử lý ở từng vai trò, số tiền đề xuất và phê duyệt, các số đếm lũy kế và các cờ phái sinh. Tám trong mười một báo cáo bắt đầu từ bảng này.
- Grain: 1 dòng = 1 hồ sơ x 1 ngày dữ liệu
- Khóa: PK = DAYID + WI_NAME
- Quy tắc ghi: Ghi một dòng cho hồ sơ vào ngày D nếu ÍT NHẤT MỘT trong hai điều kiện đúng: (1) hồ sơ CÓ BIẾN ĐỘNG trong ngày D - gồm cả ngày hồ sơ được phê duyệt, từ chối hoặc bị hủy; (2) tại ngày D hồ sơ ĐÃ QUA BƯỚC THẨM ĐỊNH VÀ CHƯA CHỐT (HAS_REACHED_UWM='Y' và BI_APPSTATUS='Processing') - điều kiện này để lấy được hồ sơ tồn đọng nằm im nhiều ngày. Sau ngày chốt thì ngừng ghi theo ngày; hồ sơ chuyển sang giải ngân chỉ còn sinh dòng khi có biến động. KHÔNG cần cột cờ riêng cho phạm vi báo cáo, ba nhóm lọc như sau: BC3 lấy hồ sơ đã được phê duyệt - HAS_REACHED_APPROVAL='Y' và BI_APPSTATUS IN ('Approved','Rejected'); BC4 lấy hồ sơ đã qua thẩm định, gồm cả hồ sơ phát sinh trong ngày lẫn hồ sơ tồn đọng từ ngày trước - DAYID = ngày báo cáo và HAS_REACHED_UWM='Y' và PROCESSED_DATE_UWM = ngày báo cáo (vế cuối vừa giữ lại hồ sơ chốt đúng trong ngày, vừa loại hồ sơ đã chốt từ trước rồi mới chuyển bước giải ngân); các báo cáo còn lại lọc như BC4 nhưng bỏ điều kiện HAS_REACHED_UWM để lấy cả hồ sơ chưa lên thẩm định.
- Bảng nguồn CDC: NG_SB_CLOS_ENTRY_EXIT, NG_SB_RLOS_ENTRY_EXIT, NG_SB_CLOS_CREDITINFO_CD, NG_SB_CLOS_CREDITINFO_COMM, NG_SB_RLOS_CREDIT_PROPOSAL, NG_SB_RLOS_CREDIT_PROPOSAL_APP, NG_SB_RLOS_REPAY_CALC, NG_SB_RLOS_REPAYFLAGS, WFINSTRUMENTTABLE
- Báo cáo sử dụng: BC1, BC2, BC3, BC4, BC5, BC6, BC7, BC8, BC9, BC10, BC11

| STT | Tên cột | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | NUMBER | 8 | Y | PK | KỸ THUẬT — Ngày dữ liệu dạng YYYYMMDD. Đây là ngày ảnh chụp, KHÔNG phải ngày nghiệp vụ. BC4 gọi là REPORT_DATE, BC10 và BC11 lọc thẳng theo cột này |
| 2 | WI_NAME | VARCHAR2 | 100 | Y | PK | 1:1 — Mã hồ sơ. Nguồn: NG_SB_CLOS_ENTRY_EXIT.WINAME / NG_SB_RLOS_ENTRY_EXIT.WINAME (hai bảng ENTRY_EXIT gọi cột này là WINAME, không có dấu gạch dưới). Trường WINAME của BC1, BC2, BC3 và WI_NAME của BC6, BC7, BC8, BC9 |
| 3 | APPLICATION_SK | NUMBER | 18 | Y |  | KỸ THUẬT — Khóa tới DIM_LOS_APPLICATION, lookup theo WI_NAME và DAYID nằm trong khoảng EFF_DATE đến EXP_DATE |
| 4 | SYSTEM_CODE | VARCHAR2 | 10 | Y |  | PHÁI SINH — CASE WHEN WI_NAME LIKE '%RLOS' THEN 'RLOS' WHEN LIKE '%CLOS' THEN 'CLOS' END. Trường SYSTEMNAME của BC3, BC4, BC5 |
| 5 | IS_CURRENT_ROW | VARCHAR2 | 1 | Y |  | KỸ THUẬT — 'Y' trên dòng mới nhất của mỗi hồ sơ, do ETL duy trì. Nhóm báo cáo sự kiện lọc IS_CURRENT_ROW = 'Y' kết hợp khoảng PROCESSED_DATE, không cần hàm cửa sổ |
| 6 | PROCESSED_DATE | DATE |  | N |  | PHÁI SINH — Ba mức ưu tiên, TRUNC về ngày: (1) LAST_APPROVAL_DATE nếu hồ sơ đã được phê duyệt; (2) tại CancelRevoke lấy EXITDATE, nếu NULL lấy ENTRYDATE; (3) EXITDATE của bước cuối cùng. BC1, BC2, BC5, BC6, BC9 lọc theo cột này |
| 7 | PROCESSED_DATE_UWM | DATE |  | N |  | PHÁI SINH — Ngày dữ liệu theo phạm vi thẩm định, ba mức ưu tiên: (1) LAST_APPROVAL_DATE nếu hồ sơ đã được phê duyệt hoặc từ chối; (2) EXITDATE tại UnderwriterMaker với DECISION='Cancel' nếu hồ sơ bị hủy tại bước thẩm định; (3) chính DAYID nếu hồ sơ chưa chốt. Trường REPORT_DATE của BC4. Do mức (3) luôn bằng ngày ảnh chụp, chỉ cần lọc PROCESSED_DATE_UWM = ngày báo cáo là lấy được đồng thời hồ sơ chốt trong ngày và hồ sơ tồn đọng đến ngày đó, đồng thời loại được hồ sơ đã chốt từ trước |
| 8 | CREATION_DATE | DATE |  | N |  | PHÁI SINH — TRUNC(MIN(ENTRYDATE)) theo WI_NAME. Trường CREATION_DATE của BC1 và BC2 |
| 9 | FIRST_APPROVAL_DATE | DATE |  | N |  | PHÁI SINH — MIN(EXITDATE) tại bước CreditApproval hoặc CreditCommittee với DECISION thuộc nhóm phê duyệt. BC5 dùng làm mức ưu tiên 1 của PROCESSED_DATE và làm mốc phân biệt phê duyệt lần đầu |
| 10 | LAST_APPROVAL_DATE | DATE |  | N |  | PHÁI SINH — MAX(EXITDATE) tại bước CreditApproval hoặc CreditCommittee với DECISION thuộc ('Submit','Send To HOSupport','Send To PostSanction','Reject','Submit To DisbursementMaker'). Trường LAST_APPROVAL_DATE của BC1 và BC2, APPROVAL_DATE của BC10 và BC11 |
| 11 | MIN_UWM | TIMESTAMP |  | N |  | PHÁI SINH — MIN(ENTRYDATE) tại bước UnderwriterMaker, giữ đủ giờ phút giây. Trường MIN_UWM của BC1 và BC2 |
| 12 | MIN_APP | TIMESTAMP |  | N |  | PHÁI SINH — MIN(ENTRYDATE) tại bước CreditApproval hoặc CreditCommittee. Trường MIN_APP của BC1 và BC2 |
| 13 | AUTO_CANCEL_DATE | DATE |  | N |  | PHÁI SINH — MIN(ENTRYDATE) tại bước CancelRevoke với USERNAME, EXITDATE và DECISION đều NULL, kèm điều kiện tồn tại một bản ghi BranchSupport trước đó cũng bỏ trống ba cột này và cách nhau từ 2400 phút làm việc trở lên, và không tồn tại bản ghi DECISION='Cancel' trước đó. Trường AUTO_CAN_DATE của BC1 |
| 14 | CANCEL_USER_DATE | DATE |  | N |  | PHÁI SINH — EXITDATE tại bản ghi có DECISION='Cancel' và USERNAME IS NOT NULL. Trường CAN_USER_DATE của BC1 |
| 15 | BI_CAN_DATE | DATE |  | N |  | PHÁI SINH — ENTRYDATE tại bước CancelRevoke. Trường BI_CAN_DATE của BC2 |
| 16 | LAST_ENTRYDATE | TIMESTAMP |  | N |  | PHÁI SINH — ENTRYDATE tại bản ghi có EVENT_SEQ_DESC = 1 (bản ghi cuối cùng của hồ sơ theo thời gian). Trường LAST_ENTRYDATE của BC1 và BC2 |
| 17 | LAST_EXITDATE | TIMESTAMP |  | N |  | PHÁI SINH — EXITDATE tại bản ghi có EVENT_SEQ_DESC = 1. Trường LAST_EXITDATE của BC1 và BC2 |
| 18 | BI_APPSTATUS | VARCHAR2 | 50 | N |  | PHÁI SINH — CASE WHEN DECISION IN ('Submit','Send To PostSanction','Submit To DisbursementMaker','Send To HOSupport') THEN 'Approved' WHEN DECISION='Reject' THEN 'Rejected' WHEN WORKSTEP IN ('CancelRevoke','CancelPermanent') THEN 'Cancelled' ELSE 'Processing' END. Trường BI_APPSTATUS của BC1, BC2, BC5, BC9 |
| 19 | CURRENT_WORKSTEP_SK | NUMBER | 18 | N |  | KỸ THUẬT — Khóa tới DIM_LOS_WORKSTEP, là bước hồ sơ đang nằm tại ngày DAYID (bản ghi ENTRY_EXIT chưa có EXITDATE), đối chiếu với WFINSTRUMENTTABLE.ACTIVITYNAME. Phục vụ trạng thái FLAG của BC4 |
| 20 | LAST_WORKSTEP_SK | NUMBER | 18 | N |  | KỸ THUẬT — Khóa tới DIM_LOS_WORKSTEP, là bước tại bản ghi có EVENT_SEQ_DESC = 1. Trường LAST_WORKSTEP của BC1 và BC2 |
| 21 | LAST_DECISION_SK | NUMBER | 18 | N |  | KỸ THUẬT — Khóa tới DIM_LOS_DECISION, là quyết định tại bản ghi có EVENT_SEQ_DESC = 1. Trường LAST_DECISION của BC1 và BC2 |
| 22 | PRE_WORKSTEP_CODE | VARCHAR2 | 200 | N |  | PHÁI SINH — LAG(WORKSTEP) OVER (PARTITION BY WI_NAME ORDER BY ENTRYDATE), lấy tại bản ghi cuối. Trường PRE_WORKSTEP của BC1 và BC2 |
| 23 | FLAG_AUTO_CANCEL | VARCHAR2 | 10 | N |  | PHÁI SINH — CASE WHEN AUTO_CANCEL_DATE IS NOT NULL THEN 'YES' ELSE 'NO' END. Trường FLAG_AUTO_CAN của BC1 và BC2 |
| 24 | LAST_REMARKS | VARCHAR2 | 4000 | N |  | 1:1 — Nguồn: REMARKS của bản ghi ENTRY_EXIT có EVENT_SEQ_DESC = 1 (đổi tên thêm tiền tố LAST_ theo cách SRS gọi). Trường LAST_REMARKS của BC1 và BC2 |
| 25 | LAST_REMARK_DDE | VARCHAR2 | 4000 | N |  | 1:1 — Nguồn: REMARKS của bản ghi ENTRY_EXIT tại WORKSTEP='DetailDataEntry'. Trường LAST_REMARK_DDE của BC1 |
| 26 | LAST_CAN_REMARKS | VARCHAR2 | 4000 | N |  | 1:1 — Nguồn: REMARKS của bản ghi ENTRY_EXIT có DECISION='Cancel'. Trường LAST_CAN_REMARKS của BC1 |
| 27 | HAS_REACHED_DDE | VARCHAR2 | 1 | N |  | LŨY KẾ — MAX(CASE WHEN WORKSTEP='DetailDataEntry' THEN 'Y' END) theo hồ sơ. Mức 0.2 của điểm KPI VOLUME ở BC9 |
| 28 | HAS_REACHED_QC | VARCHAR2 | 1 | N |  | LŨY KẾ — MAX(CASE WHEN WORKSTEP='DataInputerChecker' THEN 'Y' END) theo hồ sơ |
| 29 | HAS_REACHED_UWM | VARCHAR2 | 1 | N |  | LŨY KẾ — MAX(CASE WHEN WORKSTEP='UnderwriterMaker' THEN 'Y' END) theo hồ sơ. Là điều kiện phạm vi của BC4 và mức 0.5 của KPI VOLUME |
| 30 | HAS_REACHED_UWC | VARCHAR2 | 1 | N |  | LŨY KẾ — MAX(CASE WHEN WORKSTEP='UnderwriterChecker' THEN 'Y' END) theo hồ sơ. Mức 0.6 của KPI VOLUME |
| 31 | HAS_REACHED_APPROVAL | VARCHAR2 | 1 | N |  | LŨY KẾ — MAX(CASE WHEN WORKSTEP IN ('CreditApproval','CreditCommittee') THEN 'Y' END) theo hồ sơ. Mức 0.8 của KPI VOLUME |
| 32 | RI_USER_SK | NUMBER | 18 | N |  | KỸ THUẬT — Khóa tới DIM_LOS_USER, lấy USERNAME tại WORKSTEP='RequestInitiate'. Trường RI_USER của BC2 |
| 33 | BRANCH_USER_SK | NUMBER | 18 | N |  | KỸ THUẬT — Khóa tới DIM_LOS_USER, lấy USERNAME tại WORKSTEP='BranchSupport'. Trường BRANCH_USER của BC2. Lưu ý BC1 định nghĩa trường cùng tên theo nhóm bước của bảng map nên phải tính ở tầng datamart |
| 34 | DDE_USER_SK | NUMBER | 18 | N |  | KỸ THUẬT — Khóa tới DIM_LOS_USER, lấy USERNAME tại WORKSTEP='DetailDataEntry'. Trường DDE_USER của BC2 |
| 35 | QC_USER_SK | NUMBER | 18 | N |  | KỸ THUẬT — Khóa tới DIM_LOS_USER, lấy USERNAME tại WORKSTEP='DataInputerChecker'. Trường QUALITY_CHECKER của BC2 |
| 36 | UND_MAKER_USER_SK | NUMBER | 18 | N |  | KỸ THUẬT — Khóa tới DIM_LOS_USER, lấy USERNAME tại WORKSTEP='UnderwriterMaker'. Trường UND_MAKER và UNDERWRITERMAKER_TAKERESPON của BC1, BC2, BC4 |
| 37 | UND_CHECKER_USER_SK | NUMBER | 18 | N |  | KỸ THUẬT — Khóa tới DIM_LOS_USER, lấy USERNAME tại WORKSTEP='UnderwriterChecker'. Trường UND_CHECKER và UNDERWRITERCHECKER_TAKERESPON của BC1 và BC2 |
| 38 | PHV_USER_SK | NUMBER | 18 | N |  | KỸ THUẬT — Khóa tới DIM_LOS_USER, lấy USERNAME tại WORKSTEP='PhoneVerification'. Trường PHV_USER của BC1 và BC2 |
| 39 | FA_USER_SK | NUMBER | 18 | N |  | KỸ THUẬT — Khóa tới DIM_LOS_USER, lấy USERNAME tại WORKSTEP='FieldAssessment'. Trường FA_USER của BC2 |
| 40 | APPROVER_USER_SK | NUMBER | 18 | N |  | KỸ THUẬT — Khóa tới DIM_LOS_USER, lấy USERNAME tại WORKSTEP='CreditApproval'. Trường BI_APPROVER của BC1, BC2, BC3 |
| 41 | COMMITTEE_USER_SK | NUMBER | 18 | N |  | KỸ THUẬT — Khóa tới DIM_LOS_USER, lấy USERNAME tại WORKSTEP='CreditCommittee'. Trường BI_COMMITTEE của BC2 và BC3 |
| 42 | HOS_USER_SK | NUMBER | 18 | N |  | KỸ THUẬT — Khóa tới DIM_LOS_USER, lấy USERNAME tại WORKSTEP='HOSupport'. Trường BI_HOS_USER của BC2 |
| 43 | PROPOSED_AMT | NUMBER | 20,2 | N |  | 1:1 — Nguồn: NG_SB_CLOS_CREDITINFO_COMM.PRECREDITLIMIT phía CLOS (đổi tên cho rõ nghĩa), ép kiểu từ text. Trường ST_YEUCAU của BC2 |
| 44 | CREDIT_LIMIT_APPROVAL | NUMBER | 20,2 | N |  | 1:1 — Nguồn: NG_SB_CLOS_CREDITINFO_CD.CREDIT_LIMIT (đổi tên thêm hậu tố APPROVAL vì BA cho biết bảng CD ghi tại bước Chuyên gia phê duyệt), ép kiểu từ text. Trường ST_PHEDUYET của BC2 |
| 45 | CREDIT_LIMIT_COMMITTEE | NUMBER | 20,2 | N |  | 1:1 — Nguồn: NG_SB_CLOS_CREDITINFO_COMM.CREDIT_LIMIT (đổi tên thêm hậu tố COMMITTEE vì BA cho biết bảng COMM ghi tại bước Hội đồng tín dụng), ép kiểu từ text. Trường CREDIT_LIMIT của BC3 |
| 46 | APPROVED_AMT_FINAL | NUMBER | 20,2 | N |  | PHÁI SINH — Phía CLOS: lấy CREDIT_LIMIT_APPROVAL nếu bước phê duyệt cuối là CreditApproval, lấy CREDIT_LIMIT_COMMITTEE nếu là CreditCommittee. Phía RLOS: lấy NG_SB_RLOS_CREDIT_PROPOSAL.LOAN_AMOUNT. Trường LOAN_AMOUNT của BC1 |
| 47 | APPROVED_TERM | NUMBER | 5 | N |  | 1:1 — Nguồn: NG_SB_RLOS_CREDIT_PROPOSAL.LOAN_TERM / NG_SB_CLOS_CREDITINFO_COMM.CREDIT_TERM (đổi tên để dùng chung hai hệ), đơn vị tháng. Trường LOAN_TERM của BC1 và CREDIT_TERM của BC2, BC3 |
| 48 | INTEREST_RATE_PCT | NUMBER | 8,4 | N |  | PHÁI SINH — Ép kiểu số từ NG_SB_RLOS_CREDIT_PROPOSAL.CURRENT_RATE / NG_SB_CLOS_CREDITINFO_COMM.INTEREST_RATE. Chỉ nhận giá trị khi nguồn là một con số; nếu nguồn là mô tả công thức thì để NULL và giữ nguyên văn ở INTEREST_RATE_DESC. Trường INTEREST_RATE của BC1 |
| 49 | INTEREST_RATE_DESC | VARCHAR2 | 1600 | N |  | 1:1 — Nguồn: NG_SB_CLOS_CREDITINFO_COMM.INTEREST_RATE nguyên văn (đổi tên thêm hậu tố DESC). Cần giữ vì BA cho biết phía CLOS đây là trường nhập tự do, có thể là công thức lãi suất nhiều giai đoạn. Trường INTEREST_RATE của BC2 |
| 50 | LOAN_TO_VALUE | NUMBER | 5,2 | N |  | 1:1 — Nguồn: NG_SB_RLOS_CREDIT_PROPOSAL.LOAN_TO_VALUE / NG_SB_RLOS_CREDIT_PROPOSAL_APP.LOAN_TO_VALUE. Giữ nguyên tên, đơn vị phần trăm. Trường LOAN_TO_VALUE của BC1 |
| 51 | LOAN_OBJECTIVE | VARCHAR2 | 200 | N |  | 1:1 — Nguồn: NG_SB_RLOS_CREDIT_PROPOSAL_APP.LOAN_OBJECTIVE. Giữ nguyên tên. Trường Loan Objective của BC1. Lưu ý BA cho biết với hồ sơ mở thẻ tín dụng cột nguồn này mang nghĩa loại thẻ chứ không phải mục đích vay |
| 52 | CURRENCY_CODE | VARCHAR2 | 10 | N |  | 1:1 — Nguồn: NG_SB_RLOS_CREDIT_PROPOSAL.LOAN_CURRENCY / NG_SB_CLOS_CREDITINFO_COMM.CURRENCY (đổi tên để dùng chung hai hệ). Trường CURRENCY của BC2 và BC3 |
| 53 | TOTAL_INCOME | NUMBER | 20,2 | N |  | 1:1 — Nguồn: NG_SB_RLOS_REPAY_CALC.TOT_INC_CALC (đổi tên cho rõ nghĩa). Trường TOTAL_INCOME của BC1 |
| 54 | CREDIT_LIMIT_APPROVAL_RAW | VARCHAR2 | 400 | N |  | 1:1 — Nguồn: NG_SB_CLOS_CREDITINFO_CD.CREDIT_LIMIT giữ nguyên văn dạng text. Cần giữ vì nguồn lưu số tiền dưới dạng chuỗi, dùng để đối soát khi ép kiểu thất bại |
| 55 | CREDIT_LIMIT_COMMITTEE_RAW | VARCHAR2 | 400 | N |  | 1:1 — Nguồn: NG_SB_CLOS_CREDITINFO_COMM.CREDIT_LIMIT giữ nguyên văn dạng text, dùng để đối soát khi ép kiểu thất bại |
| 56 | RETURN_CNT_DATAENTRY | NUMBER | 5 | N |  | LŨY KẾ — SUM(CASE WHEN WORKSTEP='DetailDataEntry' AND DECISION='Send_Back' THEN 1 WHEN WORKSTEP='DataInputerChecker' AND DECISION='Additional_Doc_Required' THEN 1 ELSE 0 END) theo hồ sơ. Trường sl_return_nhaplieu của BC8 |
| 57 | RETURN_CNT_UNDERWRITING | NUMBER | 5 | N |  | LŨY KẾ — SUM(số lần WORKSTEP IN ('UnderwriterMaker','UnderwriterChecker') AND DECISION='Additional_Doc_Required') TRỪ số lần gửi dự thảo (bản ghi FCT_LOS_EXCEPTION có IS_DRAFT_SEND tương ứng). Trường sl_return_thamdinh của BC8 |
| 58 | RETURN_CNT_APPROVAL | NUMBER | 5 | N |  | LŨY KẾ — SUM(CASE WHEN WORKSTEP IN ('CreditApproval','CreditCommittee') AND DECISION='Additional_Doc_Required' THEN 1 ELSE 0 END) theo hồ sơ. Trường sl_return_pheduyet của BC8 |
| 59 | DEVIATION_CNT | NUMBER | 5 | N |  | LŨY KẾ — COUNT(*) trên FCT_LOS_DEVIATION theo hồ sơ. BC9 dùng ngưỡng =2 cho DEVIATION_G2 và >=3 cho DEVIATION_G3; BC5 dùng ngưỡng >=3 khi xếp nhóm sản phẩm SLA |
| 60 | COLLATERAL_CNT | NUMBER | 5 | N |  | LŨY KẾ — COUNT(*) trên FCT_LOS_COLLATERAL theo hồ sơ. BC9 dùng ngưỡng >=2 cho chỉ tiêu TSBD_G2; BC2 dùng >0 cho cờ TSDB_NHOM_0 |
| 61 | COLLATERAL_CNT_BDS | NUMBER | 5 | N |  | LŨY KẾ — COUNT(*) trên FCT_LOS_COLLATERAL theo hồ sơ với COLL_GROUP='BDS'. Căn cứ sinh cờ TSBD_BDS của BC1 và TSDB_BDS của BC2 ở tầng datamart |
| 62 | COLLATERAL_CNT_PTVT | NUMBER | 5 | N |  | LŨY KẾ — COUNT(*) với COLL_GROUP='PTVT'. Căn cứ sinh cờ TSBD_PTVT của BC1 và TSDB_PTVT của BC2 |
| 63 | COLLATERAL_CNT_GTCG | NUMBER | 5 | N |  | LŨY KẾ — COUNT(*) với COLL_GROUP='GTCG'. Căn cứ sinh cờ TSBD_GTCG của BC1 |
| 64 | COLLATERAL_CNT_MMTB | NUMBER | 5 | N |  | LŨY KẾ — COUNT(*) với COLL_GROUP='MMTB'. Căn cứ sinh cờ TSDB_MMTB của BC2 |
| 65 | COLLATERAL_CNT_HTK | NUMBER | 5 | N |  | LŨY KẾ — COUNT(*) với COLL_GROUP='HTK'. Căn cứ sinh cờ TSDB_HTK của BC2 |
| 66 | COLLATERAL_CNT_KPT | NUMBER | 5 | N |  | LŨY KẾ — COUNT(*) với COLL_GROUP='KPT'. Căn cứ sinh cờ TSDB_KPT của BC2 |
| 67 | COLLATERAL_CNT_CPTP | NUMBER | 5 | N |  | LŨY KẾ — COUNT(*) với COLL_GROUP='CPTP'. Căn cứ sinh cờ TSDB_CP_TP của BC2 |
| 68 | COLLATERAL_CNT_TINCHAP | NUMBER | 5 | N |  | LŨY KẾ — COUNT(*) với COLL_GROUP='TINCHAP'. Căn cứ sinh cờ TSDB_TIN_CHAP của BC2 |
| 69 | COLLATERAL_CNT_TINCHAP_TQD | NUMBER | 5 | N |  | LŨY KẾ — COUNT(*) với COLL_GROUP='TINCHAP_TQD'. Căn cứ sinh cờ TIN_CHAP_TQD của BC2 |
| 70 | SALARYFLAG | VARCHAR2 | 10 | N |  | 1:1 — Nguồn: NG_SB_RLOS_REPAYFLAGS.SALARYFLAG. Giữ nguyên tên. Cờ hồ sơ có nguồn thu từ lương, giá trị Yes/No. |
| 71 | CARFLAG | VARCHAR2 | 10 | N |  | 1:1 — Nguồn: NG_SB_RLOS_REPAYFLAGS.CARFLAG. Giữ nguyên tên. Cờ hồ sơ có nguồn thu từ cho thuê phương tiện, giá trị Yes/No. |
| 72 | HOUSEFLAG | VARCHAR2 | 10 | N |  | 1:1 — Nguồn: NG_SB_RLOS_REPAYFLAGS.HOUSEFLAG. Giữ nguyên tên. Cờ hồ sơ có nguồn thu từ cho thuê nhà, giá trị Yes/No. |
| 73 | ENTERPRISSEFLAG | VARCHAR2 | 10 | N |  | 1:1 — Nguồn: NG_SB_RLOS_REPAYFLAGS.ENTERPRISSEFLAG. Giữ nguyên tên. Cờ hồ sơ có nguồn thu từ lợi nhuận doanh nghiệp, giá trị Yes/No. Thuộc nhóm thu nhập từ kinh doanh mà BC9 dùng cho chỉ tiêu BUSINESS_INCOM. Tên cột nguồn viết sai chính tả, giữ nguyên để đối chiếu được với bảng nguồn. |
| 74 | DIVINGFLAG | VARCHAR2 | 10 | N |  | 1:1 — Nguồn: NG_SB_RLOS_REPAYFLAGS.DIVINGFLAG. Giữ nguyên tên. Cờ hồ sơ có nguồn thu từ cổ tức, giá trị Yes/No. Tên cột nguồn viết sai chính tả, giữ nguyên để đối chiếu được với bảng nguồn. |
| 75 | FAIMILYFLAG | VARCHAR2 | 10 | N |  | 1:1 — Nguồn: NG_SB_RLOS_REPAYFLAGS.FAIMILYFLAG. Giữ nguyên tên. Cờ hồ sơ có nguồn thu từ kinh doanh hộ gia đình, giá trị Yes/No. Thuộc nhóm thu nhập từ kinh doanh mà BC9 dùng cho chỉ tiêu BUSINESS_INCOM. Tên cột nguồn viết sai chính tả, giữ nguyên để đối chiếu được với bảng nguồn. |
| 76 | NONLICFLAG | VARCHAR2 | 10 | N |  | 1:1 — Nguồn: NG_SB_RLOS_REPAYFLAGS.NONLICFLAG. Giữ nguyên tên. Cờ hồ sơ có nguồn thu từ kinh doanh không đkkd, giá trị Yes/No. Thuộc nhóm thu nhập từ kinh doanh mà BC9 dùng cho chỉ tiêu BUSINESS_INCOM. |
| 77 | WAGESFLAG | VARCHAR2 | 10 | N |  | 1:1 — Nguồn: NG_SB_RLOS_REPAYFLAGS.WAGESFLAG. Giữ nguyên tên. Cờ hồ sơ có nguồn thu từ tiền công, giá trị Yes/No. |
| 78 | PENSIONFLAG | VARCHAR2 | 10 | N |  | 1:1 — Nguồn: NG_SB_RLOS_REPAYFLAGS.PENSIONFLAG. Giữ nguyên tên. Cờ hồ sơ có nguồn thu từ lương hưu/phụ cấp, giá trị Yes/No. |
| 79 | OTHERFLAG | VARCHAR2 | 10 | N |  | 1:1 — Nguồn: NG_SB_RLOS_REPAYFLAGS.OTHERFLAG. Giữ nguyên tên. Cờ hồ sơ có nguồn thu từ nguồn thu khác, giá trị Yes/No. |
| 80 | INCOME_SOURCE_CNT | NUMBER | 5 | N |  | LŨY KẾ — Đếm số cột cờ trong nhóm 10 cột trên có giá trị 'Yes'. BC9 dùng ngưỡng >=3 cho chỉ tiêu INCOM_3 |
| 81 | REPAYMENT_SOURCE | VARCHAR2 | 500 | N |  | PHÁI SINH — Nối tên tiếng Việt của các nguồn thu đang bật, ngăn cách bằng ' / ', theo đúng thứ tự 10 cột cờ: Lương / Cho thuê phương tiện / Cho thuê nhà / Lợi nhuận doanh nghiệp / Cổ tức / Kinh doanh hộ gia đình / Kinh doanh không ĐKKD / Tiền công / Lương hưu-phụ cấp / Nguồn thu khác. Trường REPAYMENT_SOURCE của BC1, thay cho biểu thức REGEXP_REPLACE dài trong SRS |
| 82 | FLAG_BUSINESS_INCOME | VARCHAR2 | 10 | N |  | PHÁI SINH — 'YES' nếu ít nhất một trong FAIMILYFLAG, ENTERPRISSEFLAG, NONLICFLAG có giá trị 'Yes' VÀ sản phẩm không thuộc nhóm SeAPro hoặc SeALand; ngược lại 'NO'. Trường BUSINESS_INCOM của BC9 |
| 83 | FLAG_FTR | VARCHAR2 | 20 | N |  | PHÁI SINH — 'Not First Time Right' nếu hồ sơ có ít nhất một bản ghi FCT_LOS_EXCEPTION với IS_FTR_BREAK='Y', ngược lại 'First Time Right'. Trường CHECK_FTR của BC7 |
| 84 | FIRST_WORKSTEP_RETURN | VARCHAR2 | 200 | N |  | PHÁI SINH — WORKSTEP của bản ghi trả về đầu tiên, lấy theo ROW_NUMBER() OVER (PARTITION BY WI_NAME ORDER BY EXITDATE ASC) = 1 trong tập bản ghi có IS_RETURN_EVENT='Y'. Trường FIRST_WORKSTEP_RETURN của BC7 |
| 85 | PHAN_LOAI_DDE | VARCHAR2 | 100 | N |  | PHÁI SINH — CASE WHEN WORKSTEP='DataInputerChecker' AND DECISION='Send_Back' THEN 'Lỗi Nhập liệu' WHEN WORKSTEP='DetailDataEntry' AND DECISION='Send_Back' THEN 'Thiếu Checklist' WHEN WORKSTEP='DataInputerChecker' AND DECISION='Additional_Doc_Required' THEN 'Thiếu Checklist' END. Trường PHAN_LOAI_DDE của BC7 |
| 86 | KPI_VOLUME | NUMBER | 5,2 | N |  | PHÁI SINH — 1.0 nếu quyết định cuối thuộc ('Submit','Send To PostSanction','Submit To DisbursementMaker','Send To HOSupport','Reject'); nếu hồ sơ bị hủy thì 0.8 khi HAS_REACHED_APPROVAL='Y', 0.6 khi HAS_REACHED_UWC='Y', 0.5 khi HAS_REACHED_UWM='Y', 0.2 khi HAS_REACHED_DDE='Y'; còn lại NULL. Trường VOLUME của BC9 |
