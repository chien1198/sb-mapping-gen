# FCT_PDTD_SLA_DAILY

Nguồn: docx section "4.4.3 Bảng FCT_PDTD_SLA_DAILY"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | DATE | Y |  | PK | Ngày dữ liệu, dạng số YYYYMMDD |
| 2 | WI_NAME | VARCHAR2 | Y | 100 | PK | Mã hồ sơ tín dụng |
| 3 | APPLICATION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_APPLICATION. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 4 | PRODUCT_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_PRODUCT. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 5 | ORG_UNIT_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_ORG_UNIT. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 6 | APPROVAL_GROUP_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_APPROVAL_GROUP. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 7 | SYSTEM_CODE | VARCHAR2 | Y | 10 |  | Hệ nguồn của bản ghi, CLOS hoặc RLOS |
| 8 | PROCESSED_DATE | DATE | N |  |  | Ngày xử lý của hồ sơ |
| 9 | BI_APPSTATUS | VARCHAR2 | N | 50 |  | Trạng thái hồ sơ chuẩn hóa để hiển thị trên báo cáo |
| 10 | DEVIATION_FLAG | VARCHAR2 | N | 10 |  | Hồ sơ có ngoại lệ chính sách hay không |
| 11 | STEP01_BRANCH_CL_TAT | NUMBER | N | 18,6 |  | Thời gian bước chi nhánh theo lịch tự nhiên, đơn vị giờ |
| 12 | STEP01_BRANCH_WK_TAT | NUMBER | N | 18,6 |  | Thời gian bước chi nhánh theo giờ làm việc, đơn vị giờ |
| 13 | STEP01_BRANCH_TAT_CPC | NUMBER | N | 18,6 |  | Thời gian bước chi nhánh theo giờ cam kết SLA, đơn vị giờ |
| 14 | STEP02_DDE_CL_TAT | NUMBER | N | 18,6 |  | Thời gian bước nhập liệu chi tiết theo lịch tự nhiên, đơn vị giờ |
| 15 | STEP02_DDE_WK_TAT | NUMBER | N | 18,6 |  | Thời gian bước nhập liệu chi tiết theo giờ làm việc, đơn vị giờ |
| 16 | STEP02_DDE_TAT_CPC | NUMBER | N | 18,6 |  | Thời gian bước nhập liệu chi tiết theo giờ cam kết SLA, đơn vị giờ |
| 17 | STEP03_QUALITY_CHECKER_CL_TAT | NUMBER | N | 18,6 |  | Thời gian bước kiểm soát nhập liệu theo lịch tự nhiên, đơn vị giờ |
| 18 | STEP03_QUALITY_CHECKER_WK_TAT | NUMBER | N | 18,6 |  | Thời gian bước kiểm soát nhập liệu theo giờ làm việc, đơn vị giờ |
| 19 | STEP03_QUALITY_CHECKER_TAT_CPC | NUMBER | N | 18,6 |  | Thời gian bước kiểm soát nhập liệu theo giờ cam kết SLA, đơn vị giờ |
| 20 | STEP04_UNDMAKER_CL_TAT | NUMBER | N | 18,6 |  | Thời gian bước lập hồ sơ thẩm định theo lịch tự nhiên, đơn vị giờ |
| 21 | STEP04_UNDMAKER_WK_TAT | NUMBER | N | 18,6 |  | Thời gian bước lập hồ sơ thẩm định theo giờ làm việc, đơn vị giờ |
| 22 | STEP04_UNDMAKER_TAT_CPC | NUMBER | N | 18,6 |  | Thời gian bước lập hồ sơ thẩm định theo giờ cam kết SLA, đơn vị giờ |
| 23 | STEP04_UNDCHECKER_CL_TAT | NUMBER | N | 18,6 |  | Thời gian bước kiểm soát thẩm định theo lịch tự nhiên, đơn vị giờ |
| 24 | STEP04_UNDCHECKER_WK_TAT | NUMBER | N | 18,6 |  | Thời gian bước kiểm soát thẩm định theo giờ làm việc, đơn vị giờ |
| 25 | STEP04_UNDCHECKER_TAT_CPC | NUMBER | N | 18,6 |  | Thời gian bước kiểm soát thẩm định theo giờ cam kết SLA, đơn vị giờ |
| 26 | STEP07_APPROVER_CL_TAT | NUMBER | N | 18,6 |  | Thời gian bước chuyên gia phê duyệt theo lịch tự nhiên, đơn vị giờ |
| 27 | STEP07_APPROVER_WK_TAT | NUMBER | N | 18,6 |  | Thời gian bước chuyên gia phê duyệt theo giờ làm việc, đơn vị giờ |
| 28 | STEP07_APPROVER_TAT_CPC | NUMBER | N | 18,6 |  | Thời gian bước chuyên gia phê duyệt theo giờ cam kết SLA, đơn vị giờ |
| 29 | STEP07_COMMITTEE_CL_TAT | NUMBER | N | 18,6 |  | Thời gian bước hội đồng phê duyệt theo lịch tự nhiên, đơn vị giờ |
| 30 | STEP07_COMMITTEE_WK_TAT | NUMBER | N | 18,6 |  | Thời gian bước hội đồng phê duyệt theo giờ làm việc, đơn vị giờ |
| 31 | STEP04_UND_TAT_CPC | NUMBER | N | 18,6 |  | Thời gian cả khâu thẩm định theo giờ cam kết SLA, đơn vị giờ |
| 32 | TAT_PHONG_CL_TAT | NUMBER | N | 18,6 |  | Thời gian cả khâu thẩm định theo lịch tự nhiên, đơn vị giờ |
| 33 | TAT_PHONG_WK_TAT | NUMBER | N | 18,6 |  | Thời gian cả khâu thẩm định theo giờ làm việc, đơn vị giờ |
| 34 | TAT_KHOI_PDTD_CL_TAT | NUMBER | N | 18,6 |  | Tổng thời gian trong phạm vi Khối PDTD theo lịch tự nhiên, đơn vị giờ |
| 35 | TAT_KHOI_PDTD_WK_TAT | NUMBER | N | 18,6 |  | Tổng thời gian trong phạm vi Khối PDTD theo giờ làm việc, đơn vị giờ |
| 36 | ENTRYDATE_DDE | TIMESTAMP | N |  |  | Thời điểm vào bước nhập liệu chi tiết |
| 37 | EXITDATE_DDE | TIMESTAMP | N |  |  | Thời điểm ra khỏi bước nhập liệu chi tiết |
| 38 | REF_PRODUCT | VARCHAR2 | N | 150 |  | Nhóm sản phẩm dùng để tra cam kết SLA |
| 39 | SLA_CREDIT_OFFICER | NUMBER | N | 9,2 |  | Cam kết giờ cho chuyên viên tín dụng |
| 40 | SLA_CREDIT_APPROVER | NUMBER | N | 9,2 |  | Cam kết giờ cho cấp phê duyệt |
| 41 | SLA_MARKER | NUMBER | N | 9,2 |  | Cam kết giờ cho bước lập hồ sơ thẩm định |
| 42 | SLA_CHECKER | NUMBER | N | 9,2 |  | Cam kết giờ cho bước kiểm soát thẩm định |
| 43 | SLA_DE | NUMBER | N | 9,2 |  | Cam kết giờ cho bước nhập liệu |
| 44 | SLA_QC | NUMBER | N | 9,2 |  | Cam kết giờ cho bước kiểm soát nhập liệu |
| 45 | QD_DDE | NUMBER | N | 9,4 |  | Điểm quy đổi bước DetailDataEntry |
| 46 | QD_QC | NUMBER | N | 9,4 |  | Điểm quy đổi bước DataInputerChecker |
| 47 | SLA_MARKER_RESULT | VARCHAR2 | N | 20 |  | Kết quả so thời gian thực tế với cam kết SLA: DAT hoặc KHONG DAT |
| 48 | SLA_CHECKER_RESULT | VARCHAR2 | N | 20 |  | Kết quả so thời gian thực tế với cam kết SLA: DAT hoặc KHONG DAT |
| 49 | SLA_CO_RESULT | VARCHAR2 | N | 20 |  | Kết quả so thời gian thực tế với cam kết SLA: DAT hoặc KHONG DAT |
| 50 | SLA_APPROVER_RESULT | VARCHAR2 | N | 20 |  | Kết quả SLA của Chuyên gia phê duyệt |
| 51 | SLA_DE_RESULT | VARCHAR2 | N | 20 |  | Kết quả SLA của Chuyên viên nhập liệu |
| 52 | SLA_QC_RESULT | VARCHAR2 | N | 20 |  | Kết quả SLA của Kiểm soát nhập liệu |
| 53 | SLA_CO_APPROVER_RESULT | VARCHAR2 | N | 20 |  | Kết quả SLA của Phòng thẩm định và Chuyên gia phê duyệt |
| 54 | SLA_DE_TOTAL_RESULT | VARCHAR2 | N | 20 |  | Kết quả SLA của Nhập liệu tập trung |
