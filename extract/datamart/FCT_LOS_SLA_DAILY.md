# FCT_LOS_SLA_DAILY

Nguồn: xlsx sheet "FCT_LOS_SLA_DAILY" (DATAMODEL_DWH_LOS_20260820.xlsx)

- Loại bảng: FCT - bảng tổng hợp
- Mô tả: Tổng thời gian xử lý hồ sơ theo từng chốt nghiệp vụ, đã cộng sẵn theo ba thang đo.
- Lưu gì: Lưu 25 số đo thời gian ở cấp hồ sơ, cộng từ FCT_LOS_WORKSTEP_EVENT. Toàn bộ đơn vị là PHÚT. Ba lý do tách riêng dù trùng khóa với bảng hồ sơ: (1) FCT_LOS_APPLICATION_DAILY là bảng ghi hằng ngày cho hồ sơ tồn đọng và bị BC4 quét theo DAYID, không nên nhét thêm 28 cột số mà chỉ 2 báo cáo dùng vào đường quét nóng đó; (2) mỗi lần danh sách ngày lễ thay đổi thì toàn bộ TAT theo giờ làm việc và giờ cam kết SLA phải tính lại, trong khi trạng thái hồ sơ và số tiền không đổi - tách ra thì việc nạp lại chỉ chạm bảng 28 cột số thay vì bảng 114 cột có cả cột ghi chú dài; (3) số đo SLA CỘNG ĐƯỢC qua nhiều hồ sơ (BC9 lấy trung bình TAT theo tháng) trong khi phần lớn cột của bảng hồ sơ KHÔNG cộng được, để chung một bảng là mời người khai thác cộng nhầm. DWH chỉ giữ thời gian THỰC TẾ; cam kết SLA và kết quả ĐẠT hay KHÔNG ĐẠT tính ở tầng datamart vì cần bảng map và file cam kết SLA.
- Grain: 1 dòng = 1 hồ sơ x 1 ngày dữ liệu
- Khóa: PK = DAYID + WI_NAME
- Quy tắc ghi: Ghi khi hồ sơ có biến động về thời gian xử lý. Không ghi ảnh chụp hằng ngày vì không báo cáo nào hỏi TAT tại một ngày quá khứ.
- Bảng nguồn CDC: NG_SB_CLOS_ENTRY_EXIT, NG_SB_RLOS_ENTRY_EXIT (qua FCT_LOS_WORKSTEP_EVENT)
- Báo cáo sử dụng: BC5, BC9

| STT | Tên cột | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | NUMBER | 8 | Y | PK | KỸ THUẬT — Ngày dữ liệu dạng YYYYMMDD |
| 2 | WI_NAME | VARCHAR2 | 100 | Y | PK | 1:1 — Mã hồ sơ. Nguồn: NG_SB_CLOS_ENTRY_EXIT.WINAME / NG_SB_RLOS_ENTRY_EXIT.WINAME (riêng hai bảng ENTRY_EXIT viết là WINAME, các bảng còn lại viết WI_NAME). Trường WINAME của BC5 |
| 3 | APPLICATION_SK | NUMBER | 18 | Y |  | KỸ THUẬT — Khóa tới DIM_LOS_APPLICATION |
| 4 | SYSTEM_CODE | VARCHAR2 | 10 | Y |  | PHÁI SINH — Suy từ hậu tố mã hồ sơ: 'RLOS' nếu WI_NAME kết thúc bằng RLOS, 'CLOS' nếu kết thúc bằng CLOS |
| 5 | IS_CURRENT_ROW | VARCHAR2 | 1 | Y |  | KỸ THUẬT — 'Y' trên dòng mới nhất của mỗi hồ sơ |
| 6 | STEP01_BRANCH_CL_MIN | NUMBER | 12,2 | N |  | LŨY KẾ — SUM(TAT_CALENDAR_MIN) với WORKSTEP_CODE='BranchSupport'. Trường STEP01_BRANCH_CL_TAT của BC5 |
| 7 | STEP01_BRANCH_WK_MIN | NUMBER | 12,2 | N |  | LŨY KẾ — SUM(TAT_WORKING_MIN) với WORKSTEP_CODE='BranchSupport'. Trường STEP01_BRANCH_WK_TAT của BC5 |
| 8 | STEP01_BRANCH_CPC_MIN | NUMBER | 12,2 | N |  | LŨY KẾ — SUM(TAT_CPC_MIN) với WORKSTEP_CODE='BranchSupport'. Trường STEP01_BRANCH_TAT_CPC của BC5 |
| 9 | STEP02_DDE_CL_MIN | NUMBER | 12,2 | N |  | LŨY KẾ — SUM(TAT_CALENDAR_MIN) với WORKSTEP_CODE='DetailDataEntry'. Trường STEP02_DDE_CL_TAT của BC5 |
| 10 | STEP02_DDE_WK_MIN | NUMBER | 12,2 | N |  | LŨY KẾ — SUM(TAT_WORKING_MIN) với WORKSTEP_CODE='DetailDataEntry'. Trường STEP02_DDE_WK_TAT của BC5 |
| 11 | STEP02_DDE_CPC_MIN | NUMBER | 12,2 | N |  | LŨY KẾ — SUM(TAT_CPC_MIN) với WORKSTEP_CODE='DetailDataEntry'. Trường STEP02_DDE_TAT_CPC của BC5, dùng để so với cam kết SLA của chuyên viên nhập liệu |
| 12 | STEP03_QC_CL_MIN | NUMBER | 12,2 | N |  | LŨY KẾ — SUM(TAT_CALENDAR_MIN) với WORKSTEP_CODE='DataInputerChecker'. Trường STEP03_QUALITY_CHECKER_CL_TAT của BC5 |
| 13 | STEP03_QC_WK_MIN | NUMBER | 12,2 | N |  | LŨY KẾ — SUM(TAT_WORKING_MIN) với WORKSTEP_CODE='DataInputerChecker'. Trường STEP03_QUALITY_CHECKER_WK_TAT của BC5 |
| 14 | STEP03_QC_CPC_MIN | NUMBER | 12,2 | N |  | LŨY KẾ — SUM(TAT_CPC_MIN) với WORKSTEP_CODE='DataInputerChecker'. Trường STEP03_QUALITY_CHECKER_TAT_CPC của BC5 |
| 15 | STEP04_UNDMAKER_CL_MIN | NUMBER | 12,2 | N |  | LŨY KẾ — SUM(TAT_CALENDAR_MIN) với WORKSTEP_CODE='UnderwriterMaker'. Trường STEP04_UNDMAKER_CL_TAT của BC5 |
| 16 | STEP04_UNDMAKER_WK_MIN | NUMBER | 12,2 | N |  | LŨY KẾ — SUM(TAT_WORKING_MIN) với WORKSTEP_CODE='UnderwriterMaker'. Trường STEP04_UNDMAKER_WK_TAT của BC5 |
| 17 | STEP04_UNDMAKER_CPC_MIN | NUMBER | 12,2 | N |  | LŨY KẾ — SUM(TAT_CPC_MIN) với WORKSTEP_CODE='UnderwriterMaker'. Trường STEP04_UNDMAKER_TAT_CPC của BC5, dùng để so với cam kết SLA của chuyên viên thẩm định |
| 18 | STEP04_UNDCHECKER_CL_MIN | NUMBER | 12,2 | N |  | LŨY KẾ — SUM(TAT_CALENDAR_MIN) với WORKSTEP_CODE='UnderwriterChecker'. Trường STEP04_UNDCHECKER_CL_TAT của BC5 |
| 19 | STEP04_UNDCHECKER_WK_MIN | NUMBER | 12,2 | N |  | LŨY KẾ — SUM(TAT_WORKING_MIN) với WORKSTEP_CODE='UnderwriterChecker'. Trường STEP04_UNDCHECKER_WK_TAT của BC5 |
| 20 | STEP04_UNDCHECKER_CPC_MIN | NUMBER | 12,2 | N |  | LŨY KẾ — SUM(TAT_CPC_MIN) với WORKSTEP_CODE='UnderwriterChecker'. Trường STEP04_UNDCHECKER_TAT_CPC của BC5 |
| 21 | STEP04_UND_CPC_MIN | NUMBER | 12,2 | N |  | LŨY KẾ — SUM(TAT_CPC_MIN) với WORKSTEP_CODE IN ('UnderwriterMaker','UnderwriterChecker'). Trường STEP04_UND_TAT_CPC của BC5, dùng để so với cam kết SLA của Phòng thẩm định |
| 22 | STEP07_APPROVER_CL_MIN | NUMBER | 12,2 | N |  | LŨY KẾ — SUM(TAT_CALENDAR_MIN) với WORKSTEP_CODE='CreditApproval'. Trường STEP07_APPROVER_CL_TAT của BC5 |
| 23 | STEP07_APPROVER_WK_MIN | NUMBER | 12,2 | N |  | LŨY KẾ — SUM(TAT_WORKING_MIN) với WORKSTEP_CODE='CreditApproval'. Trường STEP07_APPROVER_WK_TAT của BC5, cũng là thành phần của công thức TAT bình quân ở BC9 |
| 24 | STEP07_APPROVER_CPC_MIN | NUMBER | 12,2 | N |  | LŨY KẾ — SUM(TAT_CPC_MIN) với WORKSTEP_CODE='CreditApproval'. Trường STEP07_APPROVER_TAT_CPC của BC5 |
| 25 | STEP07_COMMITTEE_CL_MIN | NUMBER | 12,2 | N |  | LŨY KẾ — SUM(TAT_CALENDAR_MIN) với WORKSTEP_CODE='CreditCommittee'. Trường STEP07_COMMITTEE_CL_TAT của BC5 |
| 26 | STEP07_COMMITTEE_WK_MIN | NUMBER | 12,2 | N |  | LŨY KẾ — SUM(TAT_WORKING_MIN) với WORKSTEP_CODE='CreditCommittee'. Trường STEP07_COMMITTEE_WK_TAT của BC5 |
| 27 | TAT_PHONG_CL_MIN | NUMBER | 12,2 | N |  | LŨY KẾ — STEP04_UNDMAKER_CL_MIN + STEP04_UNDCHECKER_CL_MIN. Trường TAT_PHONG_CL_TAT của BC5 |
| 28 | TAT_PHONG_WK_MIN | NUMBER | 12,2 | N |  | LŨY KẾ — STEP04_UNDMAKER_WK_MIN + STEP04_UNDCHECKER_WK_MIN. Trường TAT_PHONG_WK_TAT của BC5 |
| 29 | TAT_KHOI_PDTD_CL_MIN | NUMBER | 12,2 | N |  | LŨY KẾ — SUM(TAT_CALENDAR_MIN) với WORKSTEP_CODE IN ('UnderwriterMaker','UnderwriterChecker','CreditApproval','CreditCommittee'). Trường TAT_KHOI_PDTD_CL_TAT của BC5 |
| 30 | TAT_KHOI_PDTD_WK_MIN | NUMBER | 12,2 | N |  | LŨY KẾ — SUM(TAT_WORKING_MIN) với WORKSTEP_CODE IN ('UnderwriterMaker','UnderwriterChecker','CreditApproval','CreditCommittee'). Trường TAT_KHOI_PDTD_WK_TAT của BC5; BC9 dùng để tính TAT bình quân theo tháng |
| 31 | ENTRYDATE_DDE | TIMESTAMP |  | N |  | PHÁI SINH — MIN(ENTRYDATE) với WORKSTEP_CODE='DetailDataEntry'. Trường ENTRYDATE_DDE của BC5 |
| 32 | EXITDATE_DDE | TIMESTAMP |  | N |  | PHÁI SINH — MAX(EXITDATE) với WORKSTEP_CODE='DetailDataEntry'. Trường EXITDATE_DDE của BC5 |
| 33 | BI_FLAG_APPROVAL | VARCHAR2 | 50 | N |  | PHÁI SINH — Giá trị BI_FLAG_APPROVAL tại sự kiện phê duyệt gần nhất của hồ sơ: 'First Approval' hoặc 'From Second Approval'. Trường BI_FLAG_APPROVAL của BC5 |
