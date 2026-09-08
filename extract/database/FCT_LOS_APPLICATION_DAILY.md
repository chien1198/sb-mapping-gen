# FCT_LOS_APPLICATION_DAILY

Nguồn: docx "Design_Database_PDTD_DTM_v1.0_20260908.docx"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | DATE | Y |  | PK | Ngày dữ liệu, dạng số YYYYMMDD |
| 2 | WI_NAME | VARCHAR2 | Y | 100 | PK | Mã hồ sơ tín dụng |
| 3 | APPLICATION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_APPLICATION. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 4 | CURRENT_WORKSTEP_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_WORKSTEP, tham chiếu đến bước hiện tại của hồ sơ. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 5 | LAST_WORKSTEP_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_WORKSTEP, tham chiếu đến bước hoàn tất gần nhất. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 6 | LAST_DECISION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_DECISION, tham chiếu đến quyết định tại bước hoàn tất gần nhất. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 7 | LAST_USER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_USER. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 8 | PRODUCT_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_PRODUCT. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 9 | ORG_UNIT_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_ORG_UNIT. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 10 | APPROVAL_GROUP_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_APPROVAL_GROUP. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 11 | CHANGE_TYPE_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_CHANGE_TYPE. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 12 | CARD_PROMOTION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_CARD_PROMOTION. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 13 | RI_USER | VARCHAR2 | N | 100 |  | User khởi tạo hồ sơ |
| 14 | BRANCH_USER | VARCHAR2 | N | 100 |  | Tên tài khoản của cán bộ xử lý ở bước BranchSupport, lấy USERNAME của lần HOÀN TẤT GẦN NHẤT tại bước đó trên… |
| 15 | DDE_USER | VARCHAR2 | N | 100 |  | Tên tài khoản của cán bộ xử lý ở bước DetailDataEntry, lấy USERNAME của lần HOÀN TẤT GẦN NHẤT tại bước đó trên… |
| 16 | QC_USER | VARCHAR2 | N | 100 |  | Tên tài khoản của cán bộ xử lý ở bước DataInputerChecker, lấy USERNAME của lần HOÀN TẤT GẦN NHẤT tại bước đó trên… |
| 17 | UND_MAKER_USER | VARCHAR2 | N | 100 |  | Tên tài khoản của cán bộ xử lý ở bước UnderwriterMaker, lấy USERNAME của lần HOÀN TẤT GẦN NHẤT tại bước đó trên… |
| 18 | UND_CHECKER_USER | VARCHAR2 | N | 100 |  | Tên tài khoản của cán bộ xử lý ở bước UnderwriterChecker, lấy USERNAME của lần HOÀN TẤT GẦN NHẤT tại bước đó trên… |
| 19 | PHV_USER | VARCHAR2 | N | 100 |  | Tên tài khoản của cán bộ xử lý ở bước PhoneVerification, lấy USERNAME của lần HOÀN TẤT GẦN NHẤT tại bước đó trên… |
| 20 | FA_USER | VARCHAR2 | N | 100 |  | User Chuyên viên Thực địa |
| 21 | APPROVER_USER | VARCHAR2 | N | 100 |  | Tên tài khoản của cán bộ xử lý ở bước CreditApproval, lấy USERNAME của lần HOÀN TẤT GẦN NHẤT tại bước đó trên… |
| 22 | COMMITTEE_USER | VARCHAR2 | N | 100 |  | User Hội đồng tín dụng |
| 23 | HOS_USER | VARCHAR2 | N | 100 |  | User Hỗ trợ phê duyệt |
| 24 | DATASOURCE | VARCHAR2 | Y | 10 |  | CASE WHEN WI_NAME LIKE '%RLOS' THEN 'RLOS' WHEN LIKE '%CLOS' THEN 'CLOS' END |
| 25 | PROCESSED_DATE | DATE | N | 1 |  | Ngày xử lý của hồ sơ |
| 26 | LAST_UWM_ENTRYDATE | TIMESTAMP | N |  |  | Ngày hồ sơ vào bước thẩm định gần nhất |
| 27 | PROCESSED_DATE_UWM | DATE | N | 5 |  | Ngày chốt của chu kỳ thẩm định hiện hành |
| 28 | CREATION_DATE | DATE | N | 18 |  | Ngày khởi tạo hồ sơ |
| 29 | FIRST_APPROVAL_DATE | DATE | N | 18 |  | Ngày phê duyệt lần đầu |
| 30 | LAST_APPROVAL_DATE | DATE | N | 18 |  | Ngày phê duyệt gần nhất |
| 31 | MIN_UWM | TIMESTAMP | N | 200 |  | Thời điểm vào bước thẩm định lần đầu |
| 32 | MIN_APP | TIMESTAMP | N | 10 |  | Thời điểm vào bước phê duyệt lần đầu |
| 33 | AUTO_CANCEL_DATE | DATE | N | 4000 |  | Ngày hồ sơ bị hệ thống tự hủy |
| 34 | CANCEL_USER_DATE | DATE | N | 4000 |  | Ngày người dùng hủy hồ sơ |
| 35 | BI_CAN_DATE | DATE | N | 4000 |  | Ngày hồ sơ vào bước hủy hoặc thu hồi |
| 36 | LAST_ENTRYDATE | TIMESTAMP | N | 1 |  | Thời điểm vào bước của sự kiện hoàn tất gần nhất |
| 37 | LAST_EXITDATE | TIMESTAMP | N | 1 |  | Thời điểm ra bước của sự kiện hoàn tất gần nhất |
| 38 | BI_APPSTATUS | VARCHAR2 | N | 50 |  | Trạng thái hồ sơ chuẩn hóa để hiển thị trên báo cáo |
| 39 | HAS_ACTION_IN_DAY | VARCHAR2 | Y | 1 |  | Hồ sơ có phát sinh xử lý trong ngày dữ liệu hay không |
| 40 | LAST_ACTION_DATE | DATE | Y | 1 |  | Ngày hồ sơ phát sinh xử lý gần nhất |
| 41 | INACTIVE_DAY_CNT | NUMBER | Y | 5 |  | Số ngày hồ sơ không phát sinh xử lý |
| 42 | PRE_WORKSTEP_CODE | VARCHAR2 | N | 200 |  | Bước xử lý liền trước |
| 43 | FLAG_AUTO_CANCEL | VARCHAR2 | N | 10 |  | Hồ sơ có bị hệ thống tự hủy hay không |
| 44 | LAST_REMARKS | VARCHAR2 | N | 4000 |  | Ghi chú của sự kiện hoàn tất gần nhất |
| 45 | LAST_REMARK_DDE | VARCHAR2 | N | 4000 |  | Ghi chú ở bước nhập liệu chi tiết |
| 46 | LAST_CAN_REMARKS | VARCHAR2 | N | 4000 |  | Ghi chú tại lần hủy hồ sơ |
| 47 | HAS_REACHED_DDE | VARCHAR2 | N | 1 |  | Hồ sơ đã tới bước nhập liệu chi tiết hay chưa |
| 48 | HAS_REACHED_QC | VARCHAR2 | N | 1 |  | Hồ sơ đã tới bước kiểm soát nhập liệu hay chưa |
| 49 | HAS_REACHED_UWM | VARCHAR2 | N | 1 |  | Hồ sơ đã tới bước thẩm định hay chưa |
| 50 | HAS_REACHED_UWC | VARCHAR2 | N | 1 |  | Hồ sơ đã tới bước kiểm soát thẩm định hay chưa |
| 51 | HAS_REACHED_APPROVAL | VARCHAR2 | N | 1 |  | Hồ sơ đã tới bước phê duyệt hay chưa |
| 52 | PROPOSED_AMT | NUMBER | N | 20,2 |  | Số tiền đề xuất |
| 53 | CREDIT_LIMIT_APPROVAL | NUMBER | N | 20,2 |  | Hạn mức do chuyên gia phê duyệt |
| 54 | CREDIT_LIMIT_COMMITTEE | NUMBER | N | 20,2 |  | Hạn mức do hội đồng phê duyệt |
| 55 | APPROVED_AMT_FINAL | NUMBER | N | 20,2 |  | Hạn mức phê duyệt cuối cùng của hồ sơ |
| 56 | APPROVED_TERM | NUMBER | N | 5 |  | Kỳ hạn phê duyệt |
| 57 | INTEREST_RATE_PCT | NUMBER | N | 8,4 |  | Lãi suất phê duyệt, đơn vị phần trăm |
| 58 | INTEREST_RATE_DESC | VARCHAR2 | N | 1600 |  | Diễn giải lãi suất theo nguyên văn hệ nguồn |
| 59 | LOAN_TO_VALUE | NUMBER | N | 5,2 |  | Tỷ lệ cho vay trên giá trị tài sản bảo đảm |
| 60 | LOAN_OBJECTIVE | VARCHAR2 | N | 200 |  | Mục đích vay |
| 61 | CURRENCY_CODE | VARCHAR2 | N | 10 |  | Loại tiền của khoản vay |
| 62 | TOTAL_INCOME | NUMBER | N | 20,2 |  | Tổng thu nhập của khách hàng |
| 63 | RETURN_CNT_DATAENTRY | NUMBER | N | 5 |  | Số lần hồ sơ bị trả về ở khâu nhập liệu |
| 64 | RETURN_CNT_UNDERWRITING | NUMBER | N | 5 |  | Số lần hồ sơ bị trả về ở khâu thẩm định |
| 65 | RETURN_CNT_APPROVAL | NUMBER | N | 5 |  | Số lần hồ sơ bị trả về ở khâu phê duyệt |
| 66 | DEVIATION_CNT | NUMBER | N | 5 |  | Số ngoại lệ chính sách của hồ sơ |
| 67 | COLLATERAL_CNT | NUMBER | N | 5 |  | Số tài sản bảo đảm của hồ sơ |
| 68 | COLLATERAL_CNT_BDS | NUMBER | N | 5 |  | Số bất động sản của hồ sơ |
| 69 | COLLATERAL_CNT_PTVT | NUMBER | N | 5 |  | Số phương tiện vận tải của hồ sơ |
| 70 | COLLATERAL_CNT_GTCG | NUMBER | N | 5 |  | Số giấy tờ có giá của hồ sơ |
| 71 | COLLATERAL_CNT_MMTB | NUMBER | N | 5 |  | Số máy móc thiết bị của hồ sơ |
| 72 | COLLATERAL_CNT_HTK | NUMBER | N | 5 |  | Số hàng tồn kho của hồ sơ |
| 73 | COLLATERAL_CNT_KPT | NUMBER | N | 5 |  | Số khoản phải thu của hồ sơ |
| 74 | COLLATERAL_CNT_CPTP | NUMBER | N | 5 |  | Số cổ phiếu và trái phiếu của hồ sơ |
| 75 | COLLATERAL_CNT_TINCHAP | NUMBER | N | 5 |  | Số tài sản thuộc nhóm tín chấp của hồ sơ |
| 76 | COLLATERAL_CNT_TINCHAP_TQD | NUMBER | N | 5 |  | Số tài sản tín chấp theo quy định của hồ sơ |
| 77 | SALARYFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ lương hay không |
| 78 | CARFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ cho thuê phương tiện hay không |
| 79 | HOUSEFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ cho thuê nhà hay không |
| 80 | ENTERPRISSEFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ lợi nhuận doanh nghiệp hay không |
| 81 | DIVINGFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ cổ tức hay không |
| 82 | FAIMILYFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ kinh doanh hộ gia đình hay không |
| 83 | NONLICFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ kinh doanh không đăng ký hay không |
| 84 | WAGESFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ tiền công hay không |
| 85 | PENSIONFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ lương hưu hoặc phụ cấp hay không |
| 86 | OTHERFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu khác hay không |
| 87 | INCOME_SOURCE_CNT | NUMBER | N | 5 |  | Số nguồn thu nhập của hồ sơ |
| 88 | REPAYMENT_SOURCE | VARCHAR2 | N | 500 |  | Danh sách nguồn trả nợ của hồ sơ |
| 89 | FLAG_BUSINESS_INCOME | VARCHAR2 | N | 10 |  | Hồ sơ có thu nhập từ kinh doanh hay không |
| 90 | FLAG_FTR | VARCHAR2 | N | 20 |  | Hồ sơ có vi phạm nguyên tắc First Time Right hay không |
| 91 | FIRST_WORKSTEP_RETURN | VARCHAR2 | N | 200 |  | Bước xử lý phát sinh trả về đầu tiên |
| 92 | PHAN_LOAI_DDE | VARCHAR2 | N | 100 |  | Phân loại nguyên nhân trả về ở khâu nhập liệu |
| 93 | KPI_VOLUME | NUMBER | N | 5,2 |  | Điểm khối lượng công việc của hồ sơ |
