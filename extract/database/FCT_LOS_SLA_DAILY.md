# FCT_LOS_SLA_DAILY

Nguồn: docx section "4.2.3 Bảng FCT_LOS_SLA_DAILY"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | DATE | Y |  | PK | Ngày dữ liệu, dạng số YYYYMMDD |
| 2 | WI_NAME | VARCHAR2 | Y | 100 | PK | Mã hồ sơ tín dụng |
| 3 | APPLICATION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_APPLICATION. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 4 | SYSTEM_CODE | VARCHAR2 | Y | 10 |  | Hệ nguồn của bản ghi, CLOS hoặc RLOS |
| 5 | STEP01_BRANCH_CL_HOUR | NUMBER | N | 18,6 |  | Thời gian bước chi nhánh theo lịch tự nhiên, đơn vị giờ |
| 6 | STEP01_BRANCH_WK_HOUR | NUMBER | N | 18,6 |  | Thời gian bước chi nhánh theo giờ làm việc, đơn vị giờ |
| 7 | STEP01_BRANCH_CPC_HOUR | NUMBER | N | 18,6 |  | Thời gian bước chi nhánh theo giờ cam kết SLA, đơn vị giờ |
| 8 | STEP02_DDE_CL_HOUR | NUMBER | N | 18,6 |  | Thời gian bước nhập liệu chi tiết theo lịch tự nhiên, đơn vị giờ |
| 9 | STEP02_DDE_WK_HOUR | NUMBER | N | 18,6 |  | Thời gian bước nhập liệu chi tiết theo giờ làm việc, đơn vị giờ |
| 10 | STEP02_DDE_CPC_HOUR | NUMBER | N | 18,6 |  | Thời gian bước nhập liệu chi tiết theo giờ cam kết SLA, đơn vị giờ |
| 11 | STEP03_QC_CL_HOUR | NUMBER | N | 18,6 |  | Thời gian bước kiểm soát nhập liệu theo lịch tự nhiên, đơn vị giờ |
| 12 | STEP03_QC_WK_HOUR | NUMBER | N | 18,6 |  | Thời gian bước kiểm soát nhập liệu theo giờ làm việc, đơn vị giờ |
| 13 | STEP03_QC_CPC_HOUR | NUMBER | N | 18,6 |  | Thời gian bước kiểm soát nhập liệu theo giờ cam kết SLA, đơn vị giờ |
| 14 | STEP04_UNDMAKER_CL_HOUR | NUMBER | N | 18,6 |  | Thời gian bước lập hồ sơ thẩm định theo lịch tự nhiên, đơn vị giờ |
| 15 | STEP04_UNDMAKER_WK_HOUR | NUMBER | N | 18,6 |  | Thời gian bước lập hồ sơ thẩm định theo giờ làm việc, đơn vị giờ |
| 16 | STEP04_UNDMAKER_CPC_HOUR | NUMBER | N | 18,6 |  | Thời gian bước lập hồ sơ thẩm định theo giờ cam kết SLA, đơn vị giờ |
| 17 | STEP04_UNDCHECKER_CL_HOUR | NUMBER | N | 18,6 |  | Thời gian bước kiểm soát thẩm định theo lịch tự nhiên, đơn vị giờ |
| 18 | STEP04_UNDCHECKER_WK_HOUR | NUMBER | N | 18,6 |  | Thời gian bước kiểm soát thẩm định theo giờ làm việc, đơn vị giờ |
| 19 | STEP04_UNDCHECKER_CPC_HOUR | NUMBER | N | 18,6 |  | Thời gian bước kiểm soát thẩm định theo giờ cam kết SLA, đơn vị giờ |
| 20 | STEP04_UND_CPC_HOUR | NUMBER | N | 18,6 |  | Thời gian bước cả khâu thẩm định theo giờ cam kết SLA, đơn vị giờ |
| 21 | STEP07_APPROVER_CL_HOUR | NUMBER | N | 18,6 |  | Thời gian bước chuyên gia phê duyệt theo lịch tự nhiên, đơn vị giờ |
| 22 | STEP07_APPROVER_WK_HOUR | NUMBER | N | 18,6 |  | Thời gian bước chuyên gia phê duyệt theo giờ làm việc, đơn vị giờ |
| 23 | STEP07_APPROVER_CPC_HOUR | NUMBER | N | 18,6 |  | Thời gian bước chuyên gia phê duyệt theo giờ cam kết SLA, đơn vị giờ |
| 24 | STEP07_COMMITTEE_CL_HOUR | NUMBER | N | 18,6 |  | Thời gian bước hội đồng phê duyệt theo lịch tự nhiên, đơn vị giờ |
| 25 | STEP07_COMMITTEE_WK_HOUR | NUMBER | N | 18,6 |  | Thời gian bước hội đồng phê duyệt theo giờ làm việc, đơn vị giờ |
| 26 | TAT_PHONG_CL_HOUR | NUMBER | N | 18,6 |  | Thời gian cả khâu thẩm định theo lịch tự nhiên, đơn vị giờ |
| 27 | TAT_PHONG_WK_HOUR | NUMBER | N | 18,6 |  | Thời gian cả khâu thẩm định theo giờ làm việc, đơn vị giờ |
| 28 | TAT_KHOI_PDTD_CL_HOUR | NUMBER | N | 18,6 |  | Tổng thời gian trong phạm vi Khối PDTD theo lịch tự nhiên, đơn vị giờ |
| 29 | TAT_KHOI_PDTD_WK_HOUR | NUMBER | N | 18,6 |  | Tổng thời gian trong phạm vi Khối PDTD theo giờ làm việc, đơn vị giờ |
| 30 | ENTRYDATE_DDE | TIMESTAMP | N |  |  | Thời điểm vào bước nhập liệu chi tiết |
| 31 | EXITDATE_DDE | TIMESTAMP | N |  |  | Thời điểm ra khỏi bước nhập liệu chi tiết |
| 32 | BI_FLAG_APPROVAL | VARCHAR2 | N | 50 |  | Đánh dấu đây là lần phê duyệt đầu hay lần phê duyệt lại |
