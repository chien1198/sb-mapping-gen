# FCT_PDTD_APPLICATION_DAILY

Nguồn: docx section "4.4.1 Bảng FCT_PDTD_APPLICATION_DAILY"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | DATE | Y |  | PK | Ngày dữ liệu, dạng số YYYYMMDD |
| 2 | WI_NAME | VARCHAR2 | Y | 100 | PK | Mã hồ sơ tín dụng |
| 3 | APPLICATION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_APPLICATION. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 4 | ORG_UNIT_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_ORG_UNIT. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 5 | PRODUCT_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_PRODUCT. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 6 | APPROVAL_GROUP_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_APPROVAL_GROUP. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 7 | CUSTOMER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_CUSTOMER. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 8 | LAST_WORKSTEP_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_WORKSTEP, tham chiếu đến bước hoàn tất gần nhất. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 9 | LAST_WORKSTEP | VARCHAR2 | N | 50 |  | Bước hồ sơ cuối cùng |
| 10 | DATE_SK | NUMBER | Y | 8 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_DATE. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 11 | CURRENT_WORKSTEP_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_WORKSTEP, tham chiếu đến bước hiện tại của hồ sơ. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 12 | LAST_DECISION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_DECISION, tham chiếu đến quyết định tại bước hoàn tất gần nhất. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 13 | RI_USER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_USER, tham chiếu đến người tiếp nhận hồ sơ. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 14 | BRANCH_USER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_USER, tham chiếu đến người xử lý tại chi nhánh. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 15 | DDE_USER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_USER, tham chiếu đến người nhập liệu chi tiết. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 16 | QC_USER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_USER, tham chiếu đến người kiểm soát nhập liệu. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 17 | UND_MAKER_USER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_USER, tham chiếu đến người lập hồ sơ thẩm định. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 18 | UND_CHECKER_USER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_USER, tham chiếu đến người kiểm soát thẩm định. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 19 | PHV_USER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_USER, tham chiếu đến người thẩm định qua điện thoại. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 20 | FA_USER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_USER, tham chiếu đến người thẩm định thực địa. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 21 | APPROVER_USER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_USER, tham chiếu đến chuyên gia phê duyệt. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 22 | COMMITTEE_USER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_USER, tham chiếu đến thành viên hội đồng phê duyệt. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 23 | HOS_USER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_USER, tham chiếu đến người hỗ trợ hội sở. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 24 | SYSTEM_CODE | VARCHAR2 | Y | 10 |  | Hệ nguồn của bản ghi, CLOS hoặc RLOS |
| 25 | HAS_ACTION_IN_DAY | VARCHAR2 | Y | 1 |  | Hồ sơ có phát sinh xử lý trong ngày dữ liệu hay không |
| 26 | PROCESSED_DATE | DATE | N | 5 |  | Ngày xử lý của hồ sơ |
| 27 | PROCESSED_DATE_UWM | DATE | N | 8,4 |  | Ngày chốt của chu kỳ thẩm định hiện hành |
| 28 | BI_APPSTATUS | VARCHAR2 | N | 50 |  | Trạng thái hồ sơ chuẩn hóa để hiển thị trên báo cáo |
| 29 | BI_FLOW | VARCHAR2 | N | 50 |  | Luồng nghiệp vụ chuẩn hóa để hiển thị trên báo cáo |
| 30 | CREATION_DATE | DATE | N | 20,2 |  | Ngày khởi tạo hồ sơ |
| 31 | LAST_ENTRYDATE | TIMESTAMP | N | 20,2 |  | Thời điểm vào bước của sự kiện hoàn tất gần nhất |
| 32 | LAST_EXITDATE | TIMESTAMP | N | 1 |  | Thời điểm ra bước của sự kiện hoàn tất gần nhất |
| 33 | LAST_REMARKS | VARCHAR2 | N | 4000 |  | Ghi chú của sự kiện hoàn tất gần nhất |
| 34 | LAST_APPROVAL_DATE | DATE | N | 1 |  | Ngày phê duyệt gần nhất |
| 35 | MIN_UWM | TIMESTAMP | N | 5 |  | Thời điểm vào bước thẩm định lần đầu |
| 36 | MIN_APP | TIMESTAMP | N | 5 |  | Thời điểm vào bước phê duyệt lần đầu |
| 37 | HAS_REACHED_UWM | VARCHAR2 | N | 1 |  | Hồ sơ đã tới bước thẩm định hay chưa |
| 38 | LOAN_AMOUNT | NUMBER | N | 20,2 |  | Số tiền vay |
| 39 | LOAN_TERM | NUMBER | N | 5 |  | Kỳ hạn vay |
| 40 | INTEREST_RATE | NUMBER | N | 8,4 |  | Lãi suất |
| 41 | TOTAL_INCOME | NUMBER | N | 20,2 |  | Tổng thu nhập của khách hàng |
| 42 | LOAN_TO_VALUE | NUMBER | N | 8,4 |  | Tỷ lệ cho vay trên giá trị tài sản bảo đảm |
| 43 | CREDIT_LIMIT_APPROVAL | NUMBER | N | 20,2 |  | Hạn mức do chuyên gia phê duyệt |
| 44 | CREDIT_LIMIT_COMMITTEE | NUMBER | N | 20,2 |  | Hạn mức do hội đồng phê duyệt |
| 45 | TSBD_BDS | VARCHAR2 | N | 1 |  | Hồ sơ có bất động sản hay không |
| 46 | TSBD_PTVT | VARCHAR2 | N | 1 |  | Hồ sơ có phương tiện vận tải hay không |
| 47 | TSBD_GTCG | VARCHAR2 | N | 1 |  | Hồ sơ có giấy tờ có giá hay không |
| 48 | DEVIATION_CNT | NUMBER | N | 5 |  | Số ngoại lệ chính sách của hồ sơ |
| 49 | RETURN_CNT_DATAENTRY | NUMBER | N | 5 |  | Số lần hồ sơ bị trả về ở khâu nhập liệu |
| 50 | RETURN_CNT_UNDERWRITING | NUMBER | N | 5 |  | Số lần hồ sơ bị trả về ở khâu thẩm định |
| 51 | RETURN_CNT_APPROVAL | NUMBER | N | 5 |  | Số lần hồ sơ bị trả về ở khâu phê duyệt |
| 52 | LAST_UWM_ENTRYDATE | TIMESTAMP | N | 1 |  | Ngày hồ sơ vào bước thẩm định gần nhất |
| 53 | FIRST_APPROVAL_DATE | DATE | N | 1 |  | Ngày phê duyệt lần đầu |
| 54 | AUTO_CANCEL_DATE | DATE | N | 1 |  | Ngày hồ sơ bị hệ thống tự hủy |
| 55 | CANCEL_USER_DATE | DATE | N | 1 |  | Ngày người dùng hủy hồ sơ |
| 56 | BI_CAN_DATE | DATE | N | 18 |  | Ngày hồ sơ vào bước hủy hoặc thu hồi |
| 57 | LAST_ACTION_DATE | DATE | Y | 18 |  | Ngày hồ sơ phát sinh xử lý gần nhất |
| 58 | INACTIVE_DAY_CNT | NUMBER | Y | 5 |  | Số ngày hồ sơ không phát sinh xử lý |
| 59 | PRE_WORKSTEP_CODE | VARCHAR2 | N | 200 |  | Bước xử lý liền trước |
| 60 | FLAG_AUTO_CANCEL | VARCHAR2 | N | 10 |  | Hồ sơ có bị hệ thống tự hủy hay không |
| 61 | LAST_REMARK_DDE | VARCHAR2 | N | 4000 |  | Ghi chú ở bước nhập liệu chi tiết |
| 62 | LAST_CAN_REMARKS | VARCHAR2 | N | 4000 |  | Ghi chú tại lần hủy hồ sơ |
| 63 | HAS_REACHED_DDE | VARCHAR2 | N | 1 |  | Hồ sơ đã tới bước nhập liệu chi tiết hay chưa |
| 64 | HAS_REACHED_QC | VARCHAR2 | N | 1 |  | Hồ sơ đã tới bước kiểm soát nhập liệu hay chưa |
| 65 | HAS_REACHED_UWC | VARCHAR2 | N | 1 |  | Hồ sơ đã tới bước kiểm soát thẩm định hay chưa |
| 66 | HAS_REACHED_APPROVAL | VARCHAR2 | N | 1 |  | Hồ sơ đã tới bước phê duyệt hay chưa |
| 67 | PROPOSED_AMT | NUMBER | N | 20,2 |  | Số tiền đề xuất |
| 68 | APPROVED_AMT_FINAL | NUMBER | N | 20,2 |  | Hạn mức phê duyệt cuối cùng của hồ sơ |
| 69 | APPROVED_TERM | NUMBER | N | 5 |  | Kỳ hạn phê duyệt |
| 70 | INTEREST_RATE_PCT | NUMBER | N | 8,4 |  | Lãi suất phê duyệt, đơn vị phần trăm |
| 71 | INTEREST_RATE_DESC | VARCHAR2 | N | 1600 |  | Diễn giải lãi suất theo nguyên văn hệ nguồn |
| 72 | LOAN_OBJECTIVE | VARCHAR2 | N | 200 |  | Mục đích vay |
| 73 | CURRENCY_CODE | VARCHAR2 | N | 10 |  | Loại tiền của khoản vay |
| 74 | COLLATERAL_CNT | NUMBER | N | 5 |  | Số tài sản bảo đảm của hồ sơ |
| 75 | COLLATERAL_CNT_BDS | NUMBER | N | 5 |  | Số bất động sản của hồ sơ |
| 76 | COLLATERAL_CNT_PTVT | NUMBER | N | 5 |  | Số phương tiện vận tải của hồ sơ |
| 77 | COLLATERAL_CNT_GTCG | NUMBER | N | 5 |  | Số giấy tờ có giá của hồ sơ |
| 78 | COLLATERAL_CNT_MMTB | NUMBER | N | 5 |  | Số máy móc thiết bị của hồ sơ |
| 79 | COLLATERAL_CNT_HTK | NUMBER | N | 5 |  | Số hàng tồn kho của hồ sơ |
| 80 | COLLATERAL_CNT_KPT | NUMBER | N | 5 |  | Số khoản phải thu của hồ sơ |
| 81 | COLLATERAL_CNT_CPTP | NUMBER | N | 5 |  | Số cổ phiếu và trái phiếu của hồ sơ |
| 82 | COLLATERAL_CNT_TINCHAP | NUMBER | N | 5 |  | Số tài sản thuộc nhóm tín chấp của hồ sơ |
| 83 | COLLATERAL_CNT_TINCHAP_TQD | NUMBER | N | 5 |  | Số tài sản tín chấp theo quy định của hồ sơ |
| 84 | SALARYFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ lương hay không |
| 85 | CARFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ cho thuê phương tiện hay không |
| 86 | HOUSEFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ cho thuê nhà hay không |
| 87 | ENTERPRISSEFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ lợi nhuận doanh nghiệp hay không |
| 88 | DIVINGFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ cổ tức hay không |
| 89 | FAIMILYFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ kinh doanh hộ gia đình hay không |
| 90 | NONLICFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ kinh doanh không đăng ký hay không |
| 91 | WAGESFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ tiền công hay không |
| 92 | PENSIONFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu từ lương hưu hoặc phụ cấp hay không |
| 93 | OTHERFLAG | VARCHAR2 | N | 10 |  | Có nguồn thu khác hay không |
| 94 | INCOME_SOURCE_CNT | NUMBER | N | 5 |  | Số nguồn thu nhập của hồ sơ |
| 95 | REPAYMENT_SOURCE | VARCHAR2 | N | 500 |  | Danh sách nguồn trả nợ của hồ sơ |
| 96 | FLAG_BUSINESS_INCOME | VARCHAR2 | N | 10 |  | Hồ sơ có thu nhập từ kinh doanh hay không |
| 97 | FLAG_FTR | VARCHAR2 | N | 20 |  | Hồ sơ có vi phạm nguyên tắc First Time Right hay không |
| 98 | FIRST_WORKSTEP_RETURN | VARCHAR2 | N | 200 |  | Bước xử lý phát sinh trả về đầu tiên |
| 99 | PHAN_LOAI_DDE | VARCHAR2 | N | 100 |  | Phân loại nguyên nhân trả về ở khâu nhập liệu |
| 100 | KPI_VOLUME | NUMBER | N | 5,2 |  | Điểm khối lượng công việc của hồ sơ |
