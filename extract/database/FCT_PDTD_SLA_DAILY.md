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
| 7 | DATASOURCE | VARCHAR2 | Y | 10 |  | Hệ thống (CLOS/RLOS) |
| 8 | PROCESSED_DATE | DATE | N |  |  | Ngày xử lý của hồ sơ |
| 9 | BI_FLAG_APPROVAL | VARCHAR2 | N | 50 |  | Đánh dấu đây là lần phê duyệt đầu hay lần phê duyệt lại |
| 10 | BI_APPSTATUS | VARCHAR2 | N | 50 |  | Trạng thái hồ sơ chuẩn hóa để hiển thị trên báo cáo |
| 11 | DEVIATION_FLAG | VARCHAR2 | N | 10 |  | Hồ sơ có ngoại lệ chính sách hay không |
| 12 | STEP01_BRANCH_CL_HOUR | NUMBER | N | 18,6 |  | Thời gian bước chi nhánh theo lịch tự nhiên, đơn vị giờ |
| 13 | STEP01_BRANCH_WK_HOUR | NUMBER | N | 18,6 |  | Thời gian bước chi nhánh theo giờ làm việc, đơn vị giờ |
| 14 | STEP01_BRANCH_CPC_HOUR | NUMBER | N | 18,6 |  | Thời gian bước chi nhánh theo giờ cam kết SLA, đơn vị giờ |
| 15 | STEP02_DDE_CL_HOUR | NUMBER | N | 18,6 |  | Thời gian bước nhập liệu chi tiết theo lịch tự nhiên, đơn vị giờ |
| 16 | STEP02_DDE_WK_HOUR | NUMBER | N | 18,6 |  | Thời gian bước nhập liệu chi tiết theo giờ làm việc, đơn vị giờ |
| 17 | STEP02_DDE_CPC_HOUR | NUMBER | N | 18,6 |  | Thời gian bước nhập liệu chi tiết theo giờ cam kết SLA, đơn vị giờ |
| 18 | STEP03_QC_CL_HOUR | NUMBER | N | 18,6 |  | Thời gian bước kiểm soát nhập liệu theo lịch tự nhiên, đơn vị giờ |
| 19 | STEP03_QC_WK_HOUR | NUMBER | N | 18,6 |  | Thời gian bước kiểm soát nhập liệu theo giờ làm việc, đơn vị giờ |
| 20 | STEP03_QC_CPC_HOUR | NUMBER | N | 18,6 |  | Thời gian bước kiểm soát nhập liệu theo giờ cam kết SLA, đơn vị giờ |
| 21 | STEP04_UNDMAKER_CL_HOUR | NUMBER | N | 18,6 |  | Thời gian bước lập hồ sơ thẩm định theo lịch tự nhiên, đơn vị giờ |
| 22 | STEP04_UNDMAKER_WK_HOUR | NUMBER | N | 18,6 |  | Thời gian bước lập hồ sơ thẩm định theo giờ làm việc, đơn vị giờ |
| 23 | STEP04_UNDMAKER_CPC_HOUR | NUMBER | N | 18,6 |  | Thời gian bước lập hồ sơ thẩm định theo giờ cam kết SLA, đơn vị giờ |
| 24 | STEP04_UNDCHECKER_CL_HOUR | NUMBER | N | 18,6 |  | Thời gian bước kiểm soát thẩm định theo lịch tự nhiên, đơn vị giờ |
| 25 | STEP04_UNDCHECKER_WK_HOUR | NUMBER | N | 18,6 |  | Thời gian bước kiểm soát thẩm định theo giờ làm việc, đơn vị giờ |
| 26 | STEP04_UNDCHECKER_CPC_HOUR | NUMBER | N | 18,6 |  | Thời gian bước kiểm soát thẩm định theo giờ cam kết SLA, đơn vị giờ |
| 27 | STEP07_APPROVER_CL_HOUR | NUMBER | N | 18,6 |  | Thời gian bước chuyên gia phê duyệt theo lịch tự nhiên, đơn vị giờ |
| 28 | STEP07_APPROVER_WK_HOUR | NUMBER | N | 18,6 |  | Thời gian bước chuyên gia phê duyệt theo giờ làm việc, đơn vị giờ |
| 29 | STEP07_APPROVER_CPC_HOUR | NUMBER | N | 18,6 |  | Thời gian bước chuyên gia phê duyệt theo giờ cam kết SLA, đơn vị giờ |
| 30 | STEP07_COMMITTEE_CL_HOUR | NUMBER | N | 18,6 |  | Thời gian bước hội đồng phê duyệt theo lịch tự nhiên, đơn vị giờ |
| 31 | STEP07_COMMITTEE_WK_HOUR | NUMBER | N | 18,6 |  | Thời gian bước hội đồng phê duyệt theo giờ làm việc, đơn vị giờ |
| 32 | STEP04_UND_CPC_HOUR | NUMBER | N | 18,6 |  | Thời gian bước cả khâu thẩm định theo giờ cam kết SLA, đơn vị giờ |
| 33 | TAT_PHONG_CL_HOUR | NUMBER | N | 18,6 |  | Thời gian cả khâu thẩm định theo lịch tự nhiên, đơn vị giờ |
| 34 | TAT_PHONG_WK_HOUR | NUMBER | N | 18,6 |  | Thời gian cả khâu thẩm định theo giờ làm việc, đơn vị giờ |
| 35 | TAT_KHOI_PDTD_CL_HOUR | NUMBER | N | 18,6 |  | Tổng thời gian trong phạm vi Khối PDTD theo lịch tự nhiên, đơn vị giờ |
| 36 | TAT_KHOI_PDTD_WK_HOUR | NUMBER | N | 18,6 |  | Tổng thời gian trong phạm vi Khối PDTD theo giờ làm việc, đơn vị giờ |
| 37 | ENTRYDATE_DDE | TIMESTAMP | N |  |  | Thời điểm vào bước nhập liệu chi tiết |
| 38 | EXITDATE_DDE | TIMESTAMP | N |  |  | Thời điểm ra khỏi bước nhập liệu chi tiết |
| 39 | REF_PRODUCT | VARCHAR2 | N | 150 |  | Nhóm sản phẩm dùng để tra cam kết SLA |
| 40 | SLA_CREDIT_OFFICER | NUMBER | N | 9,2 |  | Cam kết giờ cho chuyên viên tín dụng |
| 41 | SLA_CREDIT_APPROVER | NUMBER | N | 9,2 |  | Cam kết giờ cho cấp phê duyệt |
| 42 | SLA_MARKER | NUMBER | N | 9,2 |  | Cam kết giờ cho bước lập hồ sơ thẩm định |
| 43 | SLA_CHECKER | NUMBER | N | 9,2 |  | Cam kết giờ cho bước kiểm soát thẩm định |
| 44 | SLA_DE | NUMBER | N | 9,2 |  | Cam kết giờ cho bước nhập liệu |
| 45 | SLA_QC | NUMBER | N | 9,2 |  | Cam kết giờ cho bước kiểm soát nhập liệu |
| 46 | QD_DDE | NUMBER | N | 9,4 |  | Điểm quy đổi bước DetailDataEntry |
| 47 | QD_QC | NUMBER | N | 9,4 |  | Điểm quy đổi bước DataInputerChecker |
| 48 | SLA_MARKER_RESULT | VARCHAR2 | N | 20 |  | Kết quả SLA của Chuyên viên thẩm định |
| 49 | SLA_CHECKER_RESULT | VARCHAR2 | N | 20 |  | Kết quả SLA của Kiểm soát thẩm định |
| 50 | SLA_CO_RESULT | VARCHAR2 | N | 20 |  | Kết quả SLA của Phòng thẩm định |
| 51 | SLA_APPROVER_RESULT | VARCHAR2 | N | 20 |  | Kết quả SLA của Chuyên gia phê duyệt |
| 52 | SLA_DE_RESULT | VARCHAR2 | N | 20 |  | Kết quả SLA của Chuyên viên nhập liệu |
| 53 | SLA_QC_RESULT | VARCHAR2 | N | 20 |  | Kết quả SLA của Kiểm soát nhập liệu |
| 54 | SLA_CO_APPROVER_RESULT | VARCHAR2 | N | 20 |  | Kết quả SLA của Phòng thẩm định và Chuyên gia phê duyệt |
| 55 | SLA_DE_TOTAL_RESULT | VARCHAR2 | N | 20 |  | Kết quả SLA của Nhập liệu tập trung |
