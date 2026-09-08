# BC5 — TRUY VẾT TỪNG TRƯỜNG BÁO CÁO VỀ DWH VÀ DTM

Nguồn: xlsx sheet "BC5" (Reports_20260907.xlsx)

Trường đích lấy từ SRS bản 25/08, giữ đúng thứ tự. Cột Luồng dữ liệu cho biết trường đó đã có sẵn ở DWH rồi kéo lên, hay phải lên DTM mới tính được.

| STT | Tên cột trên báo cáo | Ý nghĩa cột trên báo cáo | Có ở DWH | Tên cột ở DWH | Tên bảng ở DWH | Có ở DTM | Tên cột ở DTM | Tên bảng ở DTM | Luồng dữ liệu |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | SYSTEMNAME | Hệ thống (CLOS/RLOS) | Có | SYSTEM_CODE | FCT_LOS_APPLICATION_DAILY | Có | SYSTEM_CODE | DIM_PDTD_APPLICATION / FCT_PDTD_APPLICATION_DAILY / FCT_PDTD_APPLICATION_PARTY | Có ở DWH, kéo lên DTM |
| 2 | PROCESSED_DATE | Ngày dữ liệu - Ngày mới nhất của dữ liệu | Có | PROCESSED_DATE | FCT_LOS_APPLICATION_DAILY | Có | PROCESSED_DATE | FCT_PDTD_APPLICATION_DAILY / FCT_PDTD_DEVIATION / FCT_PDTD_EXCEPTION | Có ở DWH, kéo lên DTM |
| 3 | WINAME | Mã hồ sơ | Có | WI_NAME | DIM_LOS_APPLICATION / FCT_LOS_SLA_DAILY | Có | WI_NAME | DIM_PDTD_APPLICATION / FCT_PDTD_APPLICATION_MILESTONE / FCT_PDTD_KPI_APPLICATION | Có ở DWH, kéo lên DTM |
| 4 | BI_APPSTATUS | Trạng thái hồ sơ | Có | BI_APPSTATUS | FCT_LOS_APPLICATION_DAILY | Có | BI_APPSTATUS | FCT_PDTD_APPLICATION_DAILY | Có ở DWH, kéo lên DTM |
| 5 | STEP01_BRANCH_CL_TAT | Tổng thời gian xử lý tại chi nhánh theo Calendar minutes | Có | STEP01_BRANCH_CL_HOUR | FCT_LOS_SLA_DAILY | Có | STEP01_BRANCH_CL_HOUR | FCT_PDTD_SLA_DAILY | Có ở DWH, kéo lên DTM |
| 6 | STEP01_BRANCH_WK_TAT | Tổng thời gian xử lý tại chi nhánh theo Working minutes (loại trừ holidays, chiều thứ 7, cả ngày chủ nhật; thời gian tính từ 8-12 và 13-17) | Có | STEP01_BRANCH_WK_HOUR | FCT_LOS_SLA_DAILY | Có | STEP01_BRANCH_WK_HOUR | FCT_PDTD_SLA_DAILY | Có ở DWH, kéo lên DTM |
| 7 | STEP01_BRANCH_TAT_CPC | Tổng thời gian xử lý tại chi nhánh theo cam kết SLA (loại trừ holidays, chiều thứ 7, cả ngày chủ nhật; thời gian tính từ 8-11:30 và 13:30-16:30) | Có | STEP01_BRANCH_CPC_HOUR | FCT_LOS_SLA_DAILY | Có | STEP01_BRANCH_CPC_HOUR | FCT_PDTD_SLA_DAILY | Có ở DWH, kéo lên DTM |
| 8 | STEP02_DDE_CL_TAT | Tổng thời gian tất cả các bước DetailDataEntry theo Calendar minutes | Có | STEP02_DDE_CL_HOUR | FCT_LOS_SLA_DAILY | Có | STEP02_DDE_CL_HOUR | FCT_PDTD_SLA_DAILY | Có ở DWH, kéo lên DTM |
| 9 | STEP02_DDE_WK_TAT | Tổng thời gian tất cả các bước DetailDataEntry theo Working minutes | Có | STEP02_DDE_WK_HOUR | FCT_LOS_SLA_DAILY | Có | STEP02_DDE_WK_HOUR | FCT_PDTD_SLA_DAILY | Có ở DWH, kéo lên DTM |
| 10 | STEP02_DDE_TAT_CPC | Tổng thời gian tất cả các bước DetailDataEntry theo cam kết SLA | Có | STEP02_DDE_CPC_HOUR | FCT_LOS_SLA_DAILY | Có | STEP02_DDE_CPC_HOUR | FCT_PDTD_SLA_DAILY | Có ở DWH, kéo lên DTM |
| 11 | STEP03_QUALITY_CHECKER_CL_TAT | Tổng thời gian tất cả các bước DataInputerChecker theo Calendar minutes | Có | STEP03_QC_CL_HOUR | FCT_LOS_SLA_DAILY | Có | STEP03_QC_CL_HOUR | FCT_PDTD_SLA_DAILY | Có ở DWH, kéo lên DTM |
| 12 | STEP03_QUALITY_CHECKER_WK_TAT | Tổng thời gian tất cả các bước DataInputerChecker theo Working minutes | Có | STEP03_QC_WK_HOUR | FCT_LOS_SLA_DAILY | Có | STEP03_QC_WK_HOUR | FCT_PDTD_SLA_DAILY | Có ở DWH, kéo lên DTM |
| 13 | STEP03_QUALITY_CHECKER_TAT_CPC | Tổng thời gian tất cả các bước DataInputerChecker theo cam kết SLA | Có | STEP03_QC_CPC_HOUR | FCT_LOS_SLA_DAILY | Có | STEP03_QC_CPC_HOUR | FCT_PDTD_SLA_DAILY | Có ở DWH, kéo lên DTM |
| 14 | STEP04_UNDMAKER_CL_TAT | Tổng thời gian tất cả các bước UnderwriterMaker theo Calendar minutes | Có | STEP04_UNDMAKER_CL_HOUR | FCT_LOS_SLA_DAILY | Có | STEP04_UNDMAKER_CL_HOUR | FCT_PDTD_SLA_DAILY | Có ở DWH, kéo lên DTM |
| 15 | STEP04_UNDMAKER_WK_TAT | Tổng thời gian tất cả các bước UnderwriterMaker theo Working minutes | Có | STEP04_UNDMAKER_WK_HOUR | FCT_LOS_SLA_DAILY | Có | STEP04_UNDMAKER_WK_HOUR | FCT_PDTD_SLA_DAILY | Có ở DWH, kéo lên DTM |
| 16 | STEP04_UNDMAKER_TAT_CPC | Tổng thời gian tất cả các bước UnderwriterMaker theo cam kết SLA | Có | STEP04_UNDMAKER_CPC_HOUR | FCT_LOS_SLA_DAILY | Có | STEP04_UNDMAKER_CPC_HOUR | FCT_PDTD_SLA_DAILY | Có ở DWH, kéo lên DTM |
| 17 | STEP04_UNDCHECKER_CL_TAT | Tổng thời gian tất cả các bước UnderwriterChecker theo Calendar minutes | Có | STEP04_UNDCHECKER_CL_HOUR | FCT_LOS_SLA_DAILY | Có | STEP04_UNDCHECKER_CL_HOUR | FCT_PDTD_SLA_DAILY | Có ở DWH, kéo lên DTM |
| 18 | STEP04_UNDCHECKER_WK_TAT | Tổng thời gian tất cả các bước UnderwriterChecker theo Working minutes | Có | STEP04_UNDCHECKER_WK_HOUR | FCT_LOS_SLA_DAILY | Có | STEP04_UNDCHECKER_WK_HOUR | FCT_PDTD_SLA_DAILY | Có ở DWH, kéo lên DTM |
| 19 | STEP04_UNDCHECKER_TAT_CPC | Tổng thời gian tất cả các bước UnderwriterChecker theo cam kết SLA | Có | STEP04_UNDCHECKER_CPC_HOUR | FCT_LOS_SLA_DAILY | Có | STEP04_UNDCHECKER_CPC_HOUR | FCT_PDTD_SLA_DAILY | Có ở DWH, kéo lên DTM |
| 20 | STEP04_UND_TAT_CPC | Tổng thời gian tất cả các bước UnderwriterMaker và UnderwriterChecker theo cam kết SLA | Có | STEP04_UND_CPC_HOUR | FCT_LOS_SLA_DAILY | Có | STEP04_UND_CPC_HOUR | FCT_PDTD_SLA_DAILY | Có ở DWH, kéo lên DTM |
| 21 | STEP07_APPROVER_CL_TAT | Tổng thời gian tất cả các bước CreditApproval theo Calendar minutes | Có | STEP07_APPROVER_CL_HOUR | FCT_LOS_SLA_DAILY | Có | STEP07_APPROVER_CL_HOUR | FCT_PDTD_SLA_DAILY | Có ở DWH, kéo lên DTM |
| 22 | STEP07_APPROVER_WK_TAT | Tổng thời gian tất cả các bước CreditApproval theo Working minutes | Có | STEP07_APPROVER_WK_HOUR | FCT_LOS_SLA_DAILY | Có | STEP07_APPROVER_WK_HOUR | FCT_PDTD_SLA_DAILY | Có ở DWH, kéo lên DTM |
| 23 | STEP07_APPROVER_TAT_CPC | Tổng thời gian tất cả các bước CreditApproval theo cam kết SLA | Có | STEP07_APPROVER_CPC_HOUR | FCT_LOS_SLA_DAILY | Có | STEP07_APPROVER_CPC_HOUR | FCT_PDTD_SLA_DAILY | Có ở DWH, kéo lên DTM |
| 24 | STEP07_COMMITTEE_CL_TAT | Tổng thời gian tất cả các bước CreditCommittee theo Calendar minutes | Có | STEP07_COMMITTEE_CL_HOUR | FCT_LOS_SLA_DAILY | Có | STEP07_COMMITTEE_CL_HOUR | FCT_PDTD_SLA_DAILY | Có ở DWH, kéo lên DTM |
| 25 | STEP07_COMMITTEE_WK_TAT | Tổng thời gian tất cả các bước CreditCommittee theo Working minutes | Có | STEP07_COMMITTEE_WK_HOUR | FCT_LOS_SLA_DAILY | Có | STEP07_COMMITTEE_WK_HOUR | FCT_PDTD_SLA_DAILY | Có ở DWH, kéo lên DTM |
| 26 | REF_PRODUCT | Nhóm sản phẩm SLA | Có | APPROVAL_LEVEL / COLL_REQUIRE / DEVIATION_CNT | DIM_LOS_APPLICATION / DIM_LOS_APPROVAL_GROUP / DIM_LOS_PRODUCT | Có | APPROVAL_LEVEL / COLL_REQUIRE / DEVIATION_CNT | DIM_PDTD_APPLICATION / DIM_PDTD_APPROVAL_GROUP / DIM_PDTD_PRODUCT | Có ở DWH, kéo lên DTM |
| 27 | SLA_CREDIT_OFFICER | Cam kết SLA của Phòng thẩm định | Không |  |  | Có | SLA_CREDIT_OFFICER | CLOS_REF_SLA_TDKHDNL / CLOS_REF_SLA_TDKHDN_2 / FCT_PDTD_SLA_DAILY | Lên DTM mới tính được |
| 28 | SLA_CREDIT_APPROVER | Cam kết SLA của Chuyên gia phê duyệt | Không |  |  | Có | SLA_CREDIT_APPROVER | CLOS_REF_SLA_TDKHDNL / CLOS_REF_SLA_TDKHDN_2 / FCT_PDTD_SLA_DAILY | Lên DTM mới tính được |
| 29 | SLA_MARKER | Cam kết SLA của Chuyên viên thẩm định | Không |  |  | Có | SLA_MARKER | CLOS_REF_SLA_TDKHDNL / CLOS_REF_SLA_TDKHDN_2 / FCT_PDTD_SLA_DAILY | Lên DTM mới tính được |
| 30 | SLA_CHECKER | Cam kết SLA của Kiểm soát thẩm định | Không |  |  | Có | SLA_CHECKER | CLOS_REF_SLA_TDKHDNL / CLOS_REF_SLA_TDKHDN_2 / FCT_PDTD_SLA_DAILY | Lên DTM mới tính được |
| 31 | SLA_MARKER_RESUTL | Kết quả SLA của Chuyên viên thẩm định | Có | STEP04_UNDMAKER_CPC_HOUR | FCT_LOS_SLA_DAILY | Có | STEP04_UNDMAKER_CPC_HOUR | FCT_PDTD_SLA_DAILY | Có ở DWH, kéo lên DTM |
| 32 | SLA_CHECKER_RESUTL | Kết quả SLA của Kiểm soát thẩm định | Có | STEP04_UNDCHECKER_CPC_HOUR | FCT_LOS_SLA_DAILY | Có | STEP04_UNDCHECKER_CPC_HOUR | FCT_PDTD_SLA_DAILY | Có ở DWH, kéo lên DTM |
| 33 | SLA_CO_RESUTL | Kết quả SLA của Phòng thẩm định | Có | STEP04_UND_CPC_HOUR | FCT_LOS_SLA_DAILY | Có | STEP04_UND_CPC_HOUR | FCT_PDTD_SLA_DAILY | Có ở DWH, kéo lên DTM |
| 34 | SLA_APPROVER_RESULT | Kết quả SLA của Chuyên gia phê duyệt | Có | STEP07_APPROVER_CPC_HOUR | FCT_LOS_SLA_DAILY | Có | STEP07_APPROVER_CPC_HOUR | FCT_PDTD_SLA_DAILY | Có ở DWH, kéo lên DTM |
| 35 | SLA_CO_APPROVER_RESULT | Kết quả SLA của Phòng thẩm định và Chuyên gia phê duyệt | Không |  |  | Có | SLA_CO_APPROVER_RESULT | FCT_PDTD_SLA_DAILY | Lên DTM mới tính được |
| 36 | TAT_PHONG_CL_TAT | Tổng thời gian tất cả các bước UnderwriterMaker và UnderwriterChecker theo Calendar minutes | Có | TAT_PHONG_CL_HOUR | FCT_LOS_SLA_DAILY | Có | TAT_PHONG_CL_HOUR | FCT_PDTD_SLA_DAILY | Có ở DWH, kéo lên DTM |
| 37 | TAT_PHONG_WK_TAT | Tổng thời gian tất cả các bước UnderwriterMaker và UnderwriterChecker theo Working minutes | Có | TAT_PHONG_WK_HOUR | FCT_LOS_SLA_DAILY | Có | TAT_PHONG_WK_HOUR | FCT_PDTD_SLA_DAILY | Có ở DWH, kéo lên DTM |
| 38 | TAT_KHOI_PDTD_CL_TAT | Tổng thời gian tất cả các bước Phòng thẩm định và Chuyên gia phê duyệt theo Calendar minutes | Có | TAT_KHOI_PDTD_CL_HOUR | FCT_LOS_SLA_DAILY | Có | TAT_KHOI_PDTD_CL_HOUR | FCT_PDTD_SLA_DAILY | Có ở DWH, kéo lên DTM |
| 39 | TAT_KHOI_PDTD_WK_TAT | Tổng thời gian tất cả các bước Phòng thẩm định và Chuyên gia phê duyệt theo Working minutes | Có | TAT_KHOI_PDTD_WK_HOUR | FCT_LOS_SLA_DAILY | Có | TAT_KHOI_PDTD_WK_HOUR | FCT_PDTD_SLA_DAILY | Có ở DWH, kéo lên DTM |
| 40 | BI_FLAG_APPROVAL | Phê duyệt lần đầu/ từ lần thứ 2 | Có | BI_FLAG_APPROVAL | FCT_LOS_SLA_DAILY / FCT_LOS_WORKSTEP_EVENT | Có | BI_FLAG_APPROVAL | FCT_PDTD_SLA_DAILY / FCT_PDTD_WORKSTEP_EVENT | Có ở DWH, kéo lên DTM |
| 41 | ENTRYDATE_DDE | Thời gian lần đầu lên bước DetailDataEntry (dd/mm/yyyy) | Có | ENTRYDATE_DDE | FCT_LOS_SLA_DAILY | Có | ENTRYDATE_DDE | FCT_PDTD_SLA_DAILY | Có ở DWH, kéo lên DTM |
| 42 | EXITDATE_DDE | Thời gian kết thúc bước DetailDataEntry (dd/mm/yyyy) | Có | EXITDATE_DDE | FCT_LOS_SLA_DAILY | Có | EXITDATE_DDE | FCT_PDTD_SLA_DAILY | Có ở DWH, kéo lên DTM |
| 43 | SLA_DE | Cam kết SLA của Chuyên viên nhập liệu | Không |  |  | Có | SLA_DE | FCT_PDTD_SLA_DAILY | Lên DTM mới tính được |
| 44 | SLA_QC | Cam kết SLA của Kiểm soát nhập liệu | Không |  |  | Có | SLA_QC | FCT_PDTD_SLA_DAILY | Lên DTM mới tính được |
| 45 | SLA_DE_RESULT | Kết quả SLA của Chuyên viên nhập liệu | Có | STEP02_DDE_CPC_HOUR | FCT_LOS_SLA_DAILY | Có | STEP02_DDE_CPC_HOUR | FCT_PDTD_SLA_DAILY | Có ở DWH, kéo lên DTM |
| 46 | SLA_QC_RESULT | Kết quả SLA của Kiểm soát nhập liệu | Có | STEP03_QC_CPC_HOUR | FCT_LOS_SLA_DAILY | Có | STEP03_QC_CPC_HOUR | FCT_PDTD_SLA_DAILY | Có ở DWH, kéo lên DTM |
| 47 | SLA_DE_TOTAL_RESULT | Kết quả SLA của Nhập liệu tập trung | Không |  |  | Có | SLA_DE_TOTAL_RESULT | FCT_PDTD_SLA_DAILY / REF_SLA_NLTT | Lên DTM mới tính được |
| 48 | QD_DDE | Điểm quy đổi bước DetailDataEntry | Không |  |  | Có | QD_DDE | FCT_PDTD_SLA_DAILY / REF_SLA_NLTT | Lên DTM mới tính được |
| 49 | QD_QC | Điểm quy đổi bước DataInputerChecker | Không |  |  | Có | QD_QC | FCT_PDTD_SLA_DAILY / REF_SLA_NLTT | Lên DTM mới tính được |
