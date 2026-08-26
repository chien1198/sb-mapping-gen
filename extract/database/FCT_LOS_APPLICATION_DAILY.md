# FCT_LOS_APPLICATION_DAILY

Nguồn: docx section "4.2.1 Bảng FCT_LOS_APPLICATION_DAILY"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | DATE | Y |  | PK | Ngày dữ liệu, dạng số YYYYMMDD |
| 2 | WI_NAME | VARCHAR2 | Y | 100 | PK | Mã hồ sơ tín dụng |
| 3 | APPLICATION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_APPLICATION. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 4 | CURRENT_WORKSTEP_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_WORKSTEP, tham chiếu đến bước hiện tại của hồ sơ. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 5 | LAST_WORKSTEP_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_WORKSTEP, tham chiếu đến bước hoàn tất gần nhất. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 6 | LAST_DECISION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_DECISION, tham chiếu đến quyết định tại bước hoàn tất gần nhất. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 7 | RI_USER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_USER, tham chiếu đến người tiếp nhận hồ sơ. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 8 | BRANCH_USER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_USER, tham chiếu đến người xử lý tại chi nhánh. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 9 | DDE_USER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_USER, tham chiếu đến người nhập liệu chi tiết. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 10 | QC_USER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_USER, tham chiếu đến người kiểm soát nhập liệu. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 11 | UND_MAKER_USER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_USER, tham chiếu đến người lập hồ sơ thẩm định. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 12 | UND_CHECKER_USER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_USER, tham chiếu đến người kiểm soát thẩm định. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 13 | PHV_USER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_USER, tham chiếu đến người thẩm định qua điện thoại. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 14 | FA_USER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_USER, tham chiếu đến người thẩm định thực địa. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 15 | APPROVER_USER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_USER, tham chiếu đến chuyên gia phê duyệt. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 16 | COMMITTEE_USER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_USER, tham chiếu đến thành viên hội đồng phê duyệt. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 17 | HOS_USER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_USER, tham chiếu đến người hỗ trợ hội sở. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 18 | SYSTEM_CODE | VARCHAR2 | Y | 10 |  | Hệ nguồn của bản ghi, CLOS hoặc RLOS |
| 19 | PROCESSED_DATE | DATE | N | 1 |  | Ngày xử lý của hồ sơ |
| 20 | LAST_UWM_ENTRYDATE | TIMESTAMP | N |  |  | Ngày hồ sơ vào bước thẩm định gần nhất |
| 21 | PROCESSED_DATE_UWM | DATE | N | 5 |  | Ngày chốt của chu kỳ thẩm định hiện hành |
| 22 | CREATION_DATE | DATE | N | 18 |  | Ngày khởi tạo hồ sơ |
| 23 | FIRST_APPROVAL_DATE | DATE | N | 18 |  | Ngày phê duyệt lần đầu |
| 24 | LAST_APPROVAL_DATE | DATE | N | 18 |  | Ngày phê duyệt gần nhất |
| 25 | MIN_UWM | TIMESTAMP | N | 200 |  | Thời điểm vào bước thẩm định lần đầu |
| 26 | MIN_APP | TIMESTAMP | N | 10 |  | Thời điểm vào bước phê duyệt lần đầu |
| 27 | AUTO_CANCEL_DATE | DATE | N | 4000 |  | Ngày hồ sơ bị hệ thống tự hủy |
| 28 | CANCEL_USER_DATE | DATE | N | 4000 |  | Ngày người dùng hủy hồ sơ |
| 29 | BI_CAN_DATE | DATE | N | 4000 |  | Ngày hồ sơ vào bước hủy hoặc thu hồi |
| 30 | LAST_ENTRYDATE | TIMESTAMP | N | 1 |  | Thời điểm vào bước của sự kiện hoàn tất gần nhất |
| 31 | LAST_EXITDATE | TIMESTAMP | N | 1 |  | Thời điểm ra bước của sự kiện hoàn tất gần nhất |
| 32 | BI_APPSTATUS | VARCHAR2 | N | 50 |  | Trạng thái hồ sơ chuẩn hóa để hiển thị trên báo cáo |
| 33 | HAS_ACTION_IN_DAY | VARCHAR2 | Y | 1 |  | Hồ sơ có phát sinh xử lý trong ngày dữ liệu hay không |
| 34 | LAST_ACTION_DATE | DATE | Y | 1 |  | Ngày hồ sơ phát sinh xử lý gần nhất |
| 35 | INACTIVE_DAY_CNT | NUMBER | Y | 5 |  | Số ngày hồ sơ không phát sinh xử lý |
| 36 | PRE_WORKSTEP_CODE | VARCHAR2 | N | 200 |  | Bước xử lý liền trước |
| 37 | FLAG_AUTO_CANCEL | VARCHAR2 | N | 10 |  | Hồ sơ có bị hệ thống tự hủy hay không |
| 38 | LAST_REMARKS | VARCHAR2 | N | 4000 |  | Ghi chú của sự kiện hoàn tất gần nhất |
| 39 | LAST_REMARK_DDE | VARCHAR2 | N | 4000 |  | Ghi chú ở bước nhập liệu chi tiết |
| 40 | LAST_CAN_REMARKS | VARCHAR2 | N | 4000 |  | Ghi chú tại lần hủy hồ sơ |
| 41 | HAS_REACHED_DDE | VARCHAR2 | N | 1 |  | Hồ sơ đã tới bước nhập liệu chi tiết hay chưa |
| 42 | HAS_REACHED_QC | VARCHAR2 | N | 1 |  | Hồ sơ đã tới bước kiểm soát nhập liệu hay chưa |
| 43 | HAS_REACHED_UWM | VARCHAR2 | N | 1 |  | Hồ sơ đã tới bước thẩm định hay chưa |
| 44 | HAS_REACHED_UWC | VARCHAR2 | N | 1 |  | Hồ sơ đã tới bước kiểm soát thẩm định hay chưa |
| 45 | HAS_REACHED_APPROVAL | VARCHAR2 | N | 1 |  | Hồ sơ đã tới bước phê duyệt hay chưa |
| 46 | PROPOSED_AMT | NUMBER | N | 20,2 |  | Số tiền đề xuất |
| 47 | CREDIT_LIMIT_APPROVAL | NUMBER | N | 20,2 |  | Hạn mức do chuyên gia phê duyệt |
| 48 | CREDIT_LIMIT_COMMITTEE | NUMBER | N | 20,2 |  | Hạn mức do hội đồng phê duyệt |
| 49 | APPROVED_AMT_FINAL | NUMBER | N | 20,2 |  | Hạn mức phê duyệt cuối cùng của hồ sơ |
| 50 | APPROVED_TERM | NUMBER | N | 5 |  | Kỳ hạn phê duyệt |
| 51 | INTEREST_RATE_PCT | NUMBER | N | 8,4 |  | Lãi suất phê duyệt, đơn vị phần trăm |
| 52 | INTEREST_RATE_DESC | VARCHAR2 | N | 1600 |  | Diễn giải lãi suất theo nguyên văn hệ nguồn |
| 53 | LOAN_TO_VALUE | NUMBER | N | 5,2 |  | Tỷ lệ cho vay trên giá trị tài sản bảo đảm |
| 54 | LOAN_OBJECTIVE | VARCHAR2 | N | 200 |  | Mục đích vay |
| 55 | CURRENCY_CODE | VARCHAR2 | N | 10 |  | Loại tiền của khoản vay |
| 56 | TOTAL_INCOME | NUMBER | N | 20,2 |  | Tổng thu nhập của khách hàng |
| 57 | RETURN_CNT_DATAENTRY | NUMBER | N | 5 |  | Số lần hồ sơ bị trả về ở khâu nhập liệu |
| 58 | RETURN_CNT_UNDERWRITING | NUMBER | N | 5 |  | Số lần hồ sơ bị trả về ở khâu thẩm định |
| 59 | RETURN_CNT_APPROVAL | NUMBER | N | 5 |  | Số lần hồ sơ bị trả về ở khâu phê duyệt |
| 60 | DEVIATION_CNT | NUMBER | N | 5 |  | Số ngoại lệ chính sách của hồ sơ |
| 61 | COLLATERAL_CNT | NUMBER | N | 5 |  | Số tài sản bảo đảm của hồ sơ |
| 62 | COLLATERAL_CNT_BDS | NUMBER | N | 5 |  | Số bất động sản của hồ sơ |
| 63 | COLLATERAL_CNT_PTVT | NUMBER | N | 5 |  | Số phương tiện vận tải của hồ sơ |
| 64 | COLLATERAL_CNT_GTCG | NUMBER | N | 5 |  | Số giấy tờ có giá của hồ sơ |
| 65 | COLLATERAL_CNT_MMTB | NUMBER | N | 5 |  | Số máy móc thiết bị của hồ sơ |
| 66 | COLLATERAL_CNT_HTK | NUMBER | N | 5 |  | Số hàng tồn kho của hồ sơ |
| 67 | COLLATERAL_CNT_KPT | NUMBER | N | 5 |  | Số khoản phải thu của hồ sơ |
| 68 | COLLATERAL_CNT_CPTP | NUMBER | N | 5 |  | Số cổ phiếu và trái phiếu của hồ sơ |
| 69 | COLLATERAL_CNT_TINCHAP | NUMBER | N | 5 |  | Số tài sản thuộc nhóm tín chấp của hồ sơ |
| 70 | COLLATERAL_CNT_TINCHAP_TQD | NUMBER | N | 5 |  | Số tài sản tín chấp theo quy định của hồ sơ |
| 71 | SALARYFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ lương hay không |
| 72 | CARFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ cho thuê phương tiện hay không |
| 73 | HOUSEFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ cho thuê nhà hay không |
| 74 | ENTERPRISSEFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ lợi nhuận doanh nghiệp hay không |
| 75 | DIVINGFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ cổ tức hay không |
| 76 | FAIMILYFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ kinh doanh hộ gia đình hay không |
| 77 | NONLICFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ kinh doanh không đăng ký hay không |
| 78 | WAGESFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ tiền công hay không |
| 79 | PENSIONFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ lương hưu hoặc phụ cấp hay không |
| 80 | OTHERFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu khác hay không |
| 81 | INCOME_SOURCE_CNT | NUMBER | N | 5 |  | Số nguồn thu nhập của hồ sơ |
| 82 | REPAYMENT_SOURCE | VARCHAR2 | N | 500 |  | Danh sách nguồn trả nợ của hồ sơ |
| 83 | FLAG_BUSINESS_INCOME | VARCHAR2 | N | 10 |  | Hồ sơ có thu nhập từ kinh doanh hay không |
| 84 | FLAG_FTR | VARCHAR2 | N | 20 |  | Hồ sơ có vi phạm nguyên tắc First Time Right hay không |
| 85 | FIRST_WORKSTEP_RETURN | VARCHAR2 | N | 200 |  | Bước xử lý phát sinh trả về đầu tiên |
| 86 | PHAN_LOAI_DDE | VARCHAR2 | N | 100 |  | Phân loại nguyên nhân trả về ở khâu nhập liệu |
| 87 | KPI_VOLUME | NUMBER | N | 5,2 |  | Điểm khối lượng công việc của hồ sơ |
