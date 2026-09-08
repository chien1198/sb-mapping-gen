# FCT_PDTD_APPLICATION_DAILY

Nguồn: docx "Design_Database_PDTD_DTM_v1.0_20260908.docx"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
|  | DAYID | DATE | Y |  | PK | Ngày dữ liệu, dạng số YYYYMMDD |
|  | WI_NAME | VARCHAR2 | Y | 100 | PK | Mã hồ sơ tín dụng |
|  | APPLICATION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_APPLICATION. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
|  | ORG_UNIT_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_ORG_UNIT. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
|  | PRODUCT_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_PRODUCT. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
|  | APPROVAL_GROUP_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_APPROVAL_GROUP. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
|  | CHANGE_TYPE_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_CHANGE_TYPE. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
|  | CARD_PROMOTION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_CARD_PROMOTION. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
|  | CUSTOMER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_CUSTOMER. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
|  | LAST_WORKSTEP_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_WORKSTEP, tham chiếu đến bước hoàn tất gần nhất. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
|  | LAST_WORKSTEP | VARCHAR2 | N | 50 |  | Tên bước hoàn tất gần nhất, đã chuẩn hóa chung hai hệ |
|  | CURRENT_WORKSTEP_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_WORKSTEP, tham chiếu đến bước hiện tại của hồ sơ. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
|  | LAST_DECISION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_DECISION, tham chiếu đến quyết định tại bước hoàn tất gần nhất. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
|  | LAST_USER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_USER. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
|  | RI_USER | VARCHAR2 | N | 100 |  | User khởi tạo hồ sơ |
|  | BRANCH_USER | VARCHAR2 | N | 100 |  | Tên tài khoản của cán bộ xử lý ở bước BranchSupport, lấy USERNAME của lần HOÀN TẤT GẦN NHẤT tại bước đó trên… |
|  | DDE_USER | VARCHAR2 | N | 100 |  | Tên tài khoản của cán bộ xử lý ở bước DetailDataEntry, lấy USERNAME của lần HOÀN TẤT GẦN NHẤT tại bước đó trên… |
|  | QC_USER | VARCHAR2 | N | 100 |  | Tên tài khoản của cán bộ xử lý ở bước DataInputerChecker, lấy USERNAME của lần HOÀN TẤT GẦN NHẤT tại bước đó trên… |
|  | UND_MAKER_USER | VARCHAR2 | N | 100 |  | Tên tài khoản của cán bộ xử lý ở bước UnderwriterMaker, lấy USERNAME của lần HOÀN TẤT GẦN NHẤT tại bước đó trên… |
|  | UND_CHECKER_USER | VARCHAR2 | N | 100 |  | Tên tài khoản của cán bộ xử lý ở bước UnderwriterChecker, lấy USERNAME của lần HOÀN TẤT GẦN NHẤT tại bước đó trên… |
|  | PHV_USER | VARCHAR2 | N | 100 |  | Tên tài khoản của cán bộ xử lý ở bước PhoneVerification, lấy USERNAME của lần HOÀN TẤT GẦN NHẤT tại bước đó trên… |
|  | FA_USER | VARCHAR2 | N | 100 |  | User Chuyên viên Thực địa |
|  | APPROVER_USER | VARCHAR2 | N | 100 |  | Tên tài khoản của cán bộ xử lý ở bước CreditApproval, lấy USERNAME của lần HOÀN TẤT GẦN NHẤT tại bước đó trên… |
|  | COMMITTEE_USER | VARCHAR2 | N | 100 |  | User Hội đồng tín dụng |
|  | HOS_USER | VARCHAR2 | N | 100 |  | User Hỗ trợ phê duyệt |
|  | DATASOURCE | VARCHAR2 | Y | 10 |  | RLOS hoặc CLOS |
|  | HAS_ACTION_IN_DAY | VARCHAR2 | Y | 1 |  | Hồ sơ có phát sinh xử lý trong ngày dữ liệu hay không |
|  | PROCESSED_DATE | DATE | N | 5 |  | Ngày xử lý của hồ sơ |
|  | PROCESSED_DATE_UWM | DATE | N | 8,4 |  | Ngày chốt của chu kỳ thẩm định hiện hành |
|  | BI_APPSTATUS | VARCHAR2 | N | 50 |  | Trạng thái hồ sơ chuẩn hóa để hiển thị trên báo cáo |
|  | BI_FLOW | VARCHAR2 | N | 50 |  | Luồng nghiệp vụ chuẩn hóa để hiển thị trên báo cáo |
|  | CREATION_DATE | DATE | N | 20,2 |  | Ngày khởi tạo hồ sơ |
|  | LAST_ENTRYDATE | TIMESTAMP | N | 20,2 |  | Thời điểm vào bước của sự kiện hoàn tất gần nhất |
|  | LAST_EXITDATE | TIMESTAMP | N | 1 |  | Thời điểm ra bước của sự kiện hoàn tất gần nhất |
|  | LAST_REMARKS | VARCHAR2 | N | 4000 |  | Ghi chú của sự kiện hoàn tất gần nhất |
|  | LAST_APPROVAL_DATE | DATE | N | 1 |  | Ngày phê duyệt gần nhất |
|  | MIN_UWM | TIMESTAMP | N | 5 |  | Thời điểm vào bước thẩm định lần đầu |
|  | MIN_APP | TIMESTAMP | N | 5 |  | Thời điểm vào bước phê duyệt lần đầu |
|  | HAS_REACHED_UWM | VARCHAR2 | N | 1 |  | Hồ sơ đã tới bước thẩm định hay chưa |
|  | LOAN_AMOUNT | NUMBER | N | 20,2 |  | Số tiền vay |
|  | LOAN_TERM | NUMBER | N | 5 |  | Kỳ hạn vay |
|  | INTEREST_RATE | NUMBER | N | 8,4 |  | Lãi suất |
|  | TOTAL_INCOME | NUMBER | N | 20,2 |  | Tổng thu nhập của khách hàng |
|  | LOAN_TO_VALUE | NUMBER | N | 8,4 |  | Tỷ lệ cho vay trên giá trị tài sản bảo đảm |
|  | CREDIT_LIMIT_APPROVAL | NUMBER | N | 20,2 |  | Hạn mức do chuyên gia phê duyệt |
|  | CREDIT_LIMIT_COMMITTEE | NUMBER | N | 20,2 |  | Hạn mức do hội đồng phê duyệt |
|  | TSBD_BDS | VARCHAR2 | N | 1 |  | Hồ sơ có bất động sản hay không |
|  | TSBD_PTVT | VARCHAR2 | N | 1 |  | Hồ sơ có phương tiện vận tải hay không |
|  | TSBD_GTCG | VARCHAR2 | N | 1 |  | Hồ sơ có giấy tờ có giá hay không |
|  | DEVIATION_CNT | NUMBER | N | 5 |  | Số ngoại lệ chính sách của hồ sơ |
|  | RETURN_CNT_DATAENTRY | NUMBER | N | 5 |  | Số lần hồ sơ bị trả về ở khâu nhập liệu |
|  | RETURN_CNT_UNDERWRITING | NUMBER | N | 5 |  | Số lần hồ sơ bị trả về ở khâu thẩm định |
|  | RETURN_CNT_APPROVAL | NUMBER | N | 5 |  | Số lần hồ sơ bị trả về ở khâu phê duyệt |
|  | LAST_UWM_ENTRYDATE | TIMESTAMP | N | 1 |  | Ngày hồ sơ vào bước thẩm định gần nhất |
|  | FIRST_APPROVAL_DATE | DATE | N | 1 |  | Ngày phê duyệt lần đầu |
|  | AUTO_CANCEL_DATE | DATE | N | 1 |  | Ngày hồ sơ bị hệ thống tự hủy |
|  | CANCEL_USER_DATE | DATE | N | 1 |  | Ngày người dùng hủy hồ sơ |
|  | BI_CAN_DATE | DATE | N | 18 |  | Ngày hồ sơ vào bước hủy hoặc thu hồi |
|  | LAST_ACTION_DATE | DATE | Y | 18 |  | Ngày hồ sơ phát sinh xử lý gần nhất |
|  | INACTIVE_DAY_CNT | NUMBER | Y | 5 |  | Số ngày hồ sơ không phát sinh xử lý |
|  | PRE_WORKSTEP_CODE | VARCHAR2 | N | 200 |  | Bước xử lý liền trước |
|  | FLAG_AUTO_CANCEL | VARCHAR2 | N | 10 |  | Hồ sơ có bị hệ thống tự hủy hay không |
|  | LAST_REMARK_DDE | VARCHAR2 | N | 4000 |  | Ghi chú ở bước nhập liệu chi tiết |
|  | LAST_CAN_REMARKS | VARCHAR2 | N | 4000 |  | Ghi chú tại lần hủy hồ sơ |
|  | HAS_REACHED_DDE | VARCHAR2 | N | 1 |  | Hồ sơ đã tới bước nhập liệu chi tiết hay chưa |
|  | HAS_REACHED_QC | VARCHAR2 | N | 1 |  | Hồ sơ đã tới bước kiểm soát nhập liệu hay chưa |
|  | HAS_REACHED_UWC | VARCHAR2 | N | 1 |  | Hồ sơ đã tới bước kiểm soát thẩm định hay chưa |
|  | HAS_REACHED_APPROVAL | VARCHAR2 | N | 1 |  | Hồ sơ đã tới bước phê duyệt hay chưa |
|  | PROPOSED_AMT | NUMBER | N | 20,2 |  | Số tiền đề xuất |
|  | APPROVED_AMT_FINAL | NUMBER | N | 20,2 |  | Hạn mức phê duyệt cuối cùng của hồ sơ |
|  | APPROVED_TERM | NUMBER | N | 5 |  | Kỳ hạn phê duyệt |
|  | INTEREST_RATE_PCT | NUMBER | N | 8,4 |  | Lãi suất phê duyệt, đơn vị phần trăm |
|  | INTEREST_RATE_DESC | VARCHAR2 | N | 1600 |  | Diễn giải lãi suất theo nguyên văn hệ nguồn |
|  | LOAN_OBJECTIVE | VARCHAR2 | N | 200 |  | Mục đích vay |
|  | CURRENCY_CODE | VARCHAR2 | N | 10 |  | Loại tiền của khoản vay |
|  | COLLATERAL_CNT | NUMBER | N | 5 |  | Số tài sản bảo đảm của hồ sơ |
|  | COLLATERAL_CNT_BDS | NUMBER | N | 5 |  | Số bất động sản của hồ sơ |
|  | COLLATERAL_CNT_PTVT | NUMBER | N | 5 |  | Số phương tiện vận tải của hồ sơ |
|  | COLLATERAL_CNT_GTCG | NUMBER | N | 5 |  | Số giấy tờ có giá của hồ sơ |
|  | COLLATERAL_CNT_MMTB | NUMBER | N | 5 |  | Số máy móc thiết bị của hồ sơ |
|  | COLLATERAL_CNT_HTK | NUMBER | N | 5 |  | Số hàng tồn kho của hồ sơ |
|  | COLLATERAL_CNT_KPT | NUMBER | N | 5 |  | Số khoản phải thu của hồ sơ |
|  | COLLATERAL_CNT_CPTP | NUMBER | N | 5 |  | Số cổ phiếu và trái phiếu của hồ sơ |
|  | COLLATERAL_CNT_TINCHAP | NUMBER | N | 5 |  | Số tài sản thuộc nhóm tín chấp của hồ sơ |
|  | COLLATERAL_CNT_TINCHAP_TQD | NUMBER | N | 5 |  | Số tài sản tín chấp theo quy định của hồ sơ |
|  | SALARYFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ lương hay không |
|  | CARFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ cho thuê phương tiện hay không |
|  | HOUSEFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ cho thuê nhà hay không |
|  | ENTERPRISSEFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ lợi nhuận doanh nghiệp hay không |
|  | DIVINGFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ cổ tức hay không |
|  | FAIMILYFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ kinh doanh hộ gia đình hay không |
|  | NONLICFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ kinh doanh không đăng ký hay không |
|  | WAGESFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ tiền công hay không |
|  | PENSIONFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ lương hưu hoặc phụ cấp hay không |
|  | OTHERFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu khác hay không |
|  | INCOME_SOURCE_CNT | NUMBER | N | 5 |  | Số nguồn thu nhập của hồ sơ |
|  | REPAYMENT_SOURCE | VARCHAR2 | N | 500 |  | Danh sách nguồn trả nợ của hồ sơ |
|  | FLAG_BUSINESS_INCOME | VARCHAR2 | N | 10 |  | Hồ sơ có thu nhập từ kinh doanh hay không |
|  | FLAG_FTR | VARCHAR2 | N | 20 |  | Hồ sơ có vi phạm nguyên tắc First Time Right hay không |
|  | FIRST_WORKSTEP_RETURN | VARCHAR2 | N | 200 |  | Bước xử lý phát sinh trả về đầu tiên |
|  | PHAN_LOAI_DDE | VARCHAR2 | N | 100 |  | Phân loại nguyên nhân trả về ở khâu nhập liệu |
|  | KPI_VOLUME | NUMBER | N | 5,2 |  | Điểm khối lượng công việc của hồ sơ |
