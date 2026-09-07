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
| 7 | LAST_USER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_USER. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 8 | RI_USER | VARCHAR2 | N | 100 |  | User khởi tạo hồ sơ |
| 9 | BRANCH_USER | VARCHAR2 | N | 100 |  | Tên tài khoản của cán bộ xử lý ở bước BranchSupport, lấy USERNAME của lần HOÀN TẤT GẦN NHẤT tại bước đó trên… |
| 10 | DDE_USER | VARCHAR2 | N | 100 |  | Tên tài khoản của cán bộ xử lý ở bước DetailDataEntry, lấy USERNAME của lần HOÀN TẤT GẦN NHẤT tại bước đó trên… |
| 11 | QC_USER | VARCHAR2 | N | 100 |  | Tên tài khoản của cán bộ xử lý ở bước DataInputerChecker, lấy USERNAME của lần HOÀN TẤT GẦN NHẤT tại bước đó trên… |
| 12 | UND_MAKER_USER | VARCHAR2 | N | 100 |  | Tên tài khoản của cán bộ xử lý ở bước UnderwriterMaker, lấy USERNAME của lần HOÀN TẤT GẦN NHẤT tại bước đó trên… |
| 13 | UND_CHECKER_USER | VARCHAR2 | N | 100 |  | Tên tài khoản của cán bộ xử lý ở bước UnderwriterChecker, lấy USERNAME của lần HOÀN TẤT GẦN NHẤT tại bước đó trên… |
| 14 | PHV_USER | VARCHAR2 | N | 100 |  | Tên tài khoản của cán bộ xử lý ở bước PhoneVerification, lấy USERNAME của lần HOÀN TẤT GẦN NHẤT tại bước đó trên… |
| 15 | FA_USER | VARCHAR2 | N | 100 |  | User Chuyên viên Thực địa |
| 16 | APPROVER_USER | VARCHAR2 | N | 100 |  | Tên tài khoản của cán bộ xử lý ở bước CreditApproval, lấy USERNAME của lần HOÀN TẤT GẦN NHẤT tại bước đó trên… |
| 17 | COMMITTEE_USER | VARCHAR2 | N | 100 |  | User Hội đồng tín dụng |
| 18 | HOS_USER | VARCHAR2 | N | 100 |  | User Hỗ trợ phê duyệt |
| 19 | SYSTEM_CODE | VARCHAR2 | Y | 10 |  | Hệ nguồn của bản ghi, CLOS hoặc RLOS |
| 20 | PROCESSED_DATE | DATE | N | 1 |  | Ngày xử lý của hồ sơ |
| 21 | LAST_UWM_ENTRYDATE | TIMESTAMP | N |  |  | Ngày hồ sơ vào bước thẩm định gần nhất |
| 22 | PROCESSED_DATE_UWM | DATE | N | 5 |  | Ngày chốt của chu kỳ thẩm định hiện hành |
| 23 | CREATION_DATE | DATE | N | 18 |  | Ngày khởi tạo hồ sơ |
| 24 | FIRST_APPROVAL_DATE | DATE | N | 18 |  | Ngày phê duyệt lần đầu |
| 25 | LAST_APPROVAL_DATE | DATE | N | 18 |  | Ngày phê duyệt gần nhất |
| 26 | MIN_UWM | TIMESTAMP | N | 200 |  | Thời điểm vào bước thẩm định lần đầu |
| 27 | MIN_APP | TIMESTAMP | N | 10 |  | Thời điểm vào bước phê duyệt lần đầu |
| 28 | AUTO_CANCEL_DATE | DATE | N | 4000 |  | Ngày hồ sơ bị hệ thống tự hủy |
| 29 | CANCEL_USER_DATE | DATE | N | 4000 |  | Ngày người dùng hủy hồ sơ |
| 30 | BI_CAN_DATE | DATE | N | 4000 |  | Ngày hồ sơ vào bước hủy hoặc thu hồi |
| 31 | LAST_ENTRYDATE | TIMESTAMP | N | 1 |  | Thời điểm vào bước của sự kiện hoàn tất gần nhất |
| 32 | LAST_EXITDATE | TIMESTAMP | N | 1 |  | Thời điểm ra bước của sự kiện hoàn tất gần nhất |
| 33 | BI_APPSTATUS | VARCHAR2 | N | 50 |  | Trạng thái hồ sơ chuẩn hóa để hiển thị trên báo cáo |
| 34 | HAS_ACTION_IN_DAY | VARCHAR2 | Y | 1 |  | Hồ sơ có phát sinh xử lý trong ngày dữ liệu hay không |
| 35 | LAST_ACTION_DATE | DATE | Y | 1 |  | Ngày hồ sơ phát sinh xử lý gần nhất |
| 36 | INACTIVE_DAY_CNT | NUMBER | Y | 5 |  | Số ngày hồ sơ không phát sinh xử lý |
| 37 | PRE_WORKSTEP_CODE | VARCHAR2 | N | 200 |  | Bước xử lý liền trước |
| 38 | FLAG_AUTO_CANCEL | VARCHAR2 | N | 10 |  | Hồ sơ có bị hệ thống tự hủy hay không |
| 39 | LAST_REMARKS | VARCHAR2 | N | 4000 |  | Ghi chú của sự kiện hoàn tất gần nhất |
| 40 | LAST_REMARK_DDE | VARCHAR2 | N | 4000 |  | Ghi chú ở bước nhập liệu chi tiết |
| 41 | LAST_CAN_REMARKS | VARCHAR2 | N | 4000 |  | Ghi chú tại lần hủy hồ sơ |
| 42 | HAS_REACHED_DDE | VARCHAR2 | N | 1 |  | Hồ sơ đã tới bước nhập liệu chi tiết hay chưa |
| 43 | HAS_REACHED_QC | VARCHAR2 | N | 1 |  | Hồ sơ đã tới bước kiểm soát nhập liệu hay chưa |
| 44 | HAS_REACHED_UWM | VARCHAR2 | N | 1 |  | Hồ sơ đã tới bước thẩm định hay chưa |
| 45 | HAS_REACHED_UWC | VARCHAR2 | N | 1 |  | Hồ sơ đã tới bước kiểm soát thẩm định hay chưa |
| 46 | HAS_REACHED_APPROVAL | VARCHAR2 | N | 1 |  | Hồ sơ đã tới bước phê duyệt hay chưa |
| 47 | PROPOSED_AMT | NUMBER | N | 20,2 |  | Số tiền đề xuất |
| 48 | CREDIT_LIMIT_APPROVAL | NUMBER | N | 20,2 |  | Hạn mức do chuyên gia phê duyệt |
| 49 | CREDIT_LIMIT_COMMITTEE | NUMBER | N | 20,2 |  | Hạn mức do hội đồng phê duyệt |
| 50 | APPROVED_AMT_FINAL | NUMBER | N | 20,2 |  | Hạn mức phê duyệt cuối cùng của hồ sơ |
| 51 | APPROVED_TERM | NUMBER | N | 5 |  | Kỳ hạn phê duyệt |
| 52 | INTEREST_RATE_PCT | NUMBER | N | 8,4 |  | Lãi suất phê duyệt, đơn vị phần trăm |
| 53 | INTEREST_RATE_DESC | VARCHAR2 | N | 1600 |  | Diễn giải lãi suất theo nguyên văn hệ nguồn |
| 54 | LOAN_TO_VALUE | NUMBER | N | 5,2 |  | Tỷ lệ cho vay trên giá trị tài sản bảo đảm |
| 55 | LOAN_OBJECTIVE | VARCHAR2 | N | 200 |  | Mục đích vay |
| 56 | CURRENCY_CODE | VARCHAR2 | N | 10 |  | Loại tiền của khoản vay |
| 57 | TOTAL_INCOME | NUMBER | N | 20,2 |  | Tổng thu nhập của khách hàng |
| 58 | RETURN_CNT_DATAENTRY | NUMBER | N | 5 |  | Số lần hồ sơ bị trả về ở khâu nhập liệu |
| 59 | RETURN_CNT_UNDERWRITING | NUMBER | N | 5 |  | Số lần hồ sơ bị trả về ở khâu thẩm định |
| 60 | RETURN_CNT_APPROVAL | NUMBER | N | 5 |  | Số lần hồ sơ bị trả về ở khâu phê duyệt |
| 61 | DEVIATION_CNT | NUMBER | N | 5 |  | Số ngoại lệ chính sách của hồ sơ |
| 62 | COLLATERAL_CNT | NUMBER | N | 5 |  | Số tài sản bảo đảm của hồ sơ |
| 63 | COLLATERAL_CNT_BDS | NUMBER | N | 5 |  | Số bất động sản của hồ sơ |
| 64 | COLLATERAL_CNT_PTVT | NUMBER | N | 5 |  | Số phương tiện vận tải của hồ sơ |
| 65 | COLLATERAL_CNT_GTCG | NUMBER | N | 5 |  | Số giấy tờ có giá của hồ sơ |
| 66 | COLLATERAL_CNT_MMTB | NUMBER | N | 5 |  | Số máy móc thiết bị của hồ sơ |
| 67 | COLLATERAL_CNT_HTK | NUMBER | N | 5 |  | Số hàng tồn kho của hồ sơ |
| 68 | COLLATERAL_CNT_KPT | NUMBER | N | 5 |  | Số khoản phải thu của hồ sơ |
| 69 | COLLATERAL_CNT_CPTP | NUMBER | N | 5 |  | Số cổ phiếu và trái phiếu của hồ sơ |
| 70 | COLLATERAL_CNT_TINCHAP | NUMBER | N | 5 |  | Số tài sản thuộc nhóm tín chấp của hồ sơ |
| 71 | COLLATERAL_CNT_TINCHAP_TQD | NUMBER | N | 5 |  | Số tài sản tín chấp theo quy định của hồ sơ |
| 72 | SALARYFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ lương hay không |
| 73 | CARFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ cho thuê phương tiện hay không |
| 74 | HOUSEFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ cho thuê nhà hay không |
| 75 | ENTERPRISSEFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ lợi nhuận doanh nghiệp hay không |
| 76 | DIVINGFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ cổ tức hay không |
| 77 | FAIMILYFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ kinh doanh hộ gia đình hay không |
| 78 | NONLICFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ kinh doanh không đăng ký hay không |
| 79 | WAGESFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ tiền công hay không |
| 80 | PENSIONFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ lương hưu hoặc phụ cấp hay không |
| 81 | OTHERFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu khác hay không |
| 82 | INCOME_SOURCE_CNT | NUMBER | N | 5 |  | Số nguồn thu nhập của hồ sơ |
| 83 | REPAYMENT_SOURCE | VARCHAR2 | N | 500 |  | Danh sách nguồn trả nợ của hồ sơ |
| 84 | FLAG_BUSINESS_INCOME | VARCHAR2 | N | 10 |  | Hồ sơ có thu nhập từ kinh doanh hay không |
| 85 | FLAG_FTR | VARCHAR2 | N | 20 |  | Hồ sơ có vi phạm nguyên tắc First Time Right hay không |
| 86 | FIRST_WORKSTEP_RETURN | VARCHAR2 | N | 200 |  | Bước xử lý phát sinh trả về đầu tiên |
| 87 | PHAN_LOAI_DDE | VARCHAR2 | N | 100 |  | Phân loại nguyên nhân trả về ở khâu nhập liệu |
| 88 | KPI_VOLUME | NUMBER | N | 5,2 |  | Điểm khối lượng công việc của hồ sơ |
