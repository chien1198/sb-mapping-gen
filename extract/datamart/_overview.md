# Tổng quan DATAMODEL_DWH_LOS_20260820.xlsx

## 00_Muc_luc

- DATA MODEL DWH_LOS — KHỐI PDTD
- Phạm vi | Tầng DWH tối thiểu đủ để dựng datamart PDTD_DTM và 11 báo cáo BC1–BC11 (bỏ sheet BC2–BS). Không dựng bảng cho nguồn mà 11 báo cáo không đọc tới.
- Quy mô | 14 bảng DIM + 8 bảng FCT = 22 bảng. Toàn bộ 43 bảng nguồn trong danh sách CDC đều được sử dụng — xem sheet 00_Nguon_CDC.
- Phạm vi lấy hồ sơ | Ba nhóm báo cáo lọc bằng các cột đã có sẵn trên FCT_LOS_APPLICATION_DAILY, không cần cột cờ riêng. BC3 lấy hồ sơ đã được phê duyệt: HAS_REACHED_APPROVAL='Y' và BI_APPSTATUS thuộc Approved/Rejected. BC4 lấy hồ sơ đã qua bước thẩm định, gồm cả hồ sơ phát sinh trong ngày lẫn hồ sơ tồn đọng từ những ngày trước: DAYID = ngày báo cáo, HAS_REACHED_UWM='Y' và PROCESSED_DATE_UWM = ngày báo cáo. Các báo cáo còn lại lọc như BC4 nhưng bỏ điều kiện HAS_REACHED_UWM để lấy cả hồ sơ chưa lên thẩm định.
- Quy ước DIM | DIMENSION_KEY là khóa thay thế sinh bằng Oracle sequence. Kèm một cột NK là khóa tự nhiên để FCT tham chiếu và ETL lookup. Có EFF_DATE và EXP_DATE; EXP_DATE NULL nghĩa là bản ghi hiện hành. Ngoài các cột này không có thêm trường kỹ thuật nào.
- Quy ước FCT | PK luôn là DAYID (YYYYMMDD) cộng khóa nghiệp vụ duy nhất trong ngày. FCT giữ đồng thời khóa nghiệp vụ (để đối soát ngược về nguồn) và các cột *_SK đã lookup sang DIMENSION_KEY. Không sinh khóa thay thế cho FCT.
- Quy ước khóa chưa chốt | Bảng nào chưa có khóa nghiệp vụ được BA/DEV LOS xác nhận thì dùng một cột placeholder đặt tên <THỰC_THỂ>_BK (ở FCT) hoặc <THỰC_THỂ>_NK (ở DIM). Cột vẫn có mô tả đầy đủ và ghi rõ phương án dự phòng; tên và thành phần khóa sẽ điền chính thức sau khi chốt được khóa ở bảng nguồn và STG_LOS. Các ô này được tô nền vàng nhạt.
- Quy ước đơn vị | Mọi số đo thời gian lưu bằng PHÚT, hậu tố _MIN. Lý do: cột TAT ở nguồn có đơn vị giây (BA xác nhận), trong khi BC5 phần RLOS tính ra giờ còn phần CLOS tính ra phút dưới cùng một tên cột.
- Ranh giới với datamart | DWH chỉ tính những gì suy ra được từ riêng dữ liệu LOS. Những trường cần bảng map (RLOS_REF_FLOW, Q_RLOS_REF_WORKSTEP_2SYSTEMS, REF_SLA_KHCN_HO_NEW_2022, REF_CLOS_LEGAL, TMP_REF_COMPANY_REGION), file cam kết SLA BC5TAT, hoặc dữ liệu T24 (stg_fct_loan, stg_dim_*) đều tính ở PDTD_DTM.
- STT | Tên bảng | Loại | Số cột | Mô tả ngắn | Báo cáo sử dụng
- 1 | DIM_LOS_APPLICATION | DIM | 30 | Danh mục hồ sơ tín dụng của cả hai hệ CLOS và RLOS, hợp nhất về một danh tính duy nhất. | BC1, BC2, BC3, BC4, BC5, BC6, BC7, BC8, BC9, BC10, BC11
- 2 | DIM_LOS_PARTY | DIM | 21 | Danh mục người và tổ chức liên quan tới hồ sơ tín dụng. | BC1, BC2, BC3, BC4
- 3 | DIM_LOS_COLLATERAL | DIM | 22 | Danh mục tài sản bảo đảm gắn với hồ sơ tín dụng. | BC1, BC2, BC3, BC9
- 4 | DIM_LOS_PRODUCT | DIM | 13 | Danh mục sản phẩm tín dụng của cả hai hệ, gồm cả sản phẩm chính và sản phẩm phụ. | BC1, BC2, BC5, BC9
- 5 | DIM_LOS_WORKSTEP | DIM | 11 | Danh mục bước xử lý trong quy trình BPM của hồ sơ tín dụng. | BC1, BC2, BC3, BC4, BC5, BC7, BC8, BC9
- 6 | DIM_LOS_DECISION | DIM | 12 | Danh mục quyết định có thể phát sinh tại một bước xử lý. | BC1, BC2, BC3, BC4, BC7, BC8, BC9
- 7 | DIM_LOS_APPROVAL_GROUP | DIM | 7 | Danh mục cấp thẩm quyền phê duyệt tín dụng. | BC1, BC2, BC5, BC9
- 8 | DIM_LOS_ORG_UNIT | DIM | 9 | Danh mục đơn vị kinh doanh khởi tạo hồ sơ, theo cách LOS ghi nhận. | BC1, BC2, BC9
- 9 | DIM_LOS_USER | DIM | 5 | Danh mục tài khoản người dùng xử lý hồ sơ trên workflow. | BC1, BC2, BC3, BC4, BC7, BC8, BC9
- 10 | DIM_LOS_EXCEPTION_REASON | DIM | 11 | Danh mục lý do quyết định và ngoại lệ được cấu hình cho từng bước xử lý. | BC7, BC8
- 11 | DIM_LOS_COLLATERAL_TYPE | DIM | 7 | Danh mục loại tài sản bảo đảm đã chuẩn hóa. | BC1, BC2, BC3, BC9
- 12 | DIM_LOS_GEO | DIM | 10 | Danh mục địa giới hành chính tỉnh/thành và quận/huyện. | BC1
- 13 | DIM_LOS_CHANGE_TYPE | DIM | 10 | Danh mục loại thay đổi điều kiện phê duyệt. | BC1, BC2, BC5
- 14 | DIM_LOS_CARD_PROMOTION | DIM | 5 | Danh mục chương trình ưu đãi phí áp dụng cho hồ sơ phát hành thẻ tín dụng. | BC1
- 15 | FCT_LOS_APPLICATION_DAILY | FCT | 86 | Trạng thái hồ sơ tín dụng theo ngày, đã tính sẵn toàn bộ trường phái sinh và lũy kế ở cấp hồ sơ. | BC1, BC2, BC3, BC4, BC5, BC6, BC7, BC8, BC9, BC10, BC11
- 16 | FCT_LOS_WORKSTEP_EVENT | FCT | 27 | Nhật ký xử lý hồ sơ ở mức nguyên tử: từng lần hồ sơ vào một bước. | BC1, BC2, BC3, BC4, BC5, BC7, BC8, BC9, BC10, BC11
- 17 | FCT_LOS_SLA_DAILY | FCT | 33 | Tổng thời gian xử lý hồ sơ theo từng chốt nghiệp vụ, đã cộng sẵn theo ba thang đo. | BC5, BC9
- 18 | FCT_LOS_COLLATERAL | FCT | 14 | Giá trị định giá của từng tài sản bảo đảm gắn với hồ sơ. | BC1, BC2, BC3, BC9
- 19 | FCT_LOS_APPLICATION_PARTY | FCT | 15 | Quan hệ giữa hồ sơ và những người liên quan tới hồ sơ đó. | BC1, BC2, BC3, BC4
- 20 | FCT_LOS_SUB_PRODUCT | FCT | 15 | Sản phẩm phụ đăng ký kèm sản phẩm chính của hồ sơ, bao gồm cả thẻ tín dụng. | BC1, BC5
- 21 | FCT_LOS_EXCEPTION | FCT | 17 | Từng lần ghi nhận lý do khi hồ sơ chuyển bước, bị trả về hoặc yêu cầu bổ sung. | BC7, BC8
- 22 | FCT_LOS_DEVIATION | FCT | 12 | Các điều kiện chính sách bị lệch được ghi nhận trên hồ sơ. | BC5, BC6, BC9

## 00_Nguon_CDC — mapping bảng nguồn CDC -> bảng DWH

| STT | Hệ nguồn | Bảng nguồn | Trạng thái khóa | Bảng DWH sử dụng | Dùng để làm gì |
| --- | --- | --- | --- | --- | --- |
| 1 | BPM_LOS | WFINSTRUMENTTABLE | PROCESSINSTANCEID — đã chốt | DIM_LOS_APPLICATION; FCT_LOS_APPLICATION_DAILY | Cấp PROCESSINSTANCEID và bước hồ sơ đang nằm, phục vụ trạng thái tồn đọng của BC4 |
| 2 | CLOS | NG_SB_CLOS_APPROVAL | WI_NAME — đã chốt | DIM_LOS_APPLICATION; DIM_LOS_APPROVAL_GROUP | Luồng phê duyệt (STREAM) và cấp phê duyệt (APP_GRP) |
| 3 | CLOS | NG_SB_CLOS_COLL_CD | CẦN XÁC NHẬN — khóa hiện tại chứa giá trị định giá và LTV; hỏi việc dùng RECID | DIM_LOS_COLLATERAL; FCT_LOS_COLLATERAL; DIM_LOS_COLLATERAL_TYPE | Tài sản bảo đảm phía CLOS. Khóa chưa chốt nên FCT dùng COLLATERAL_BK |
| 4 | CLOS | NG_SB_CLOS_CONDITON_CDGRID | CẦN XÁC NHẬN — chưa có khóa; BA đề xuất thêm AS_REGULAR nhưng là trường nhập tùy biến | FCT_LOS_DEVIATION | Ngoại lệ chính sách phía CLOS. Điểm rủi ro khóa cao nhất model |
| 5 | CLOS | NG_SB_CLOS_CREDITINFO_CD | CẦN XÁC NHẬN — dev DB thấy 1 hồ sơ nhiều dòng, ngược với mô tả 1 hạn mức tổng | FCT_LOS_APPLICATION_DAILY | Hạn mức tại bước Chuyên gia phê duyệt. Đang gộp vào bảng hồ sơ theo hướng 1 hồ sơ 1 hạn mức tổng — nếu BA xác nhận nhiều dòng thì phải tách thành FCT riêng |
| 6 | CLOS | NG_SB_CLOS_CREDITINFO_COMM | CẦN XÁC NHẬN — như trên | FCT_LOS_APPLICATION_DAILY | Hạn mức tại bước Hội đồng tín dụng, cùng số tiền đề xuất, kỳ hạn, lãi suất, loại tiền |
| 7 | CLOS | NG_SB_CLOS_CUST_INFO | CẦN XÁC NHẬN — bàn giao cán bộ sinh dòng mới nên WI_NAME không unique; hỏi việc dùng RECID | DIM_LOS_APPLICATION; DIM_LOS_ORG_UNIT; DIM_LOS_PARTY; DIM_LOS_PRODUCT | Thông tin chung hồ sơ KHDN. Việc sinh nhiều dòng theo cán bộ được xử lý bằng SCD2 của DIM_LOS_APPLICATION |
| 8 | CLOS | NG_SB_CLOS_CUST_INFO_LEGAL | CẦN XÁC NHẬN — hỏi việc bổ sung OBJ_TYPE đã đủ unique chưa | DIM_LOS_PARTY; FCT_LOS_APPLICATION_PARTY | Người liên quan pháp lý. BA đã xác nhận 1 người giữ được nhiều vai trò nên vai trò nằm trong khóa |
| 9 | CLOS | NG_SB_CLOS_CHANGEREQ | WI_NAME — đã chốt | DIM_LOS_APPLICATION; DIM_LOS_CHANGE_TYPE | Yêu cầu thay đổi điều kiện phê duyệt và loại thay đổi |
| 10 | CLOS | NG_SB_CLOS_ENTRY_EXIT | WINAME + WORKSTEP + ENTRYDATE — đã chốt | FCT_LOS_WORKSTEP_EVENT; FCT_LOS_SLA_DAILY; FCT_LOS_APPLICATION_DAILY; DIM_LOS_WORKSTEP; DIM_LOS_DECISION; DIM_LOS_USER | Nhật ký xử lý hồ sơ. Bảng nguồn được nhiều báo cáo dùng nhất |
| 11 | CLOS | NG_SB_CLOS_EXCEPTION | CẦN XÁC NHẬN — chọn giữa tổ hợp 5 cột hay RECID | FCT_LOS_EXCEPTION | Lý do khi hồ sơ chuyển bước hoặc bị trả về |
| 12 | CLOS | NG_SB_CLOS_EXTTABLE | CẦN XÁC NHẬN — dev DB có ITEMINDEX + ITEMTYPE, WI_NAME bị dup | DIM_LOS_APPLICATION | Cấp LOANCASEID và cờ tư vấn/cấp tín dụng |
| 13 | CLOS | NG_SB_CLOS_MAS_PRO_LINE | CẦN XÁC NHẬN — hỏi khóa có phải PRODUCT_LINE_CODE | DIM_LOS_PRODUCT | Danh mục dòng sản phẩm phía CLOS |
| 14 | CLOS | NG_SB_CLOS_MAS_EXCEPTION | CẦN XÁC NHẬN — khóa trong metadata là suy luận | DIM_LOS_EXCEPTION_REASON | Danh mục lý do. Nguồn để bóc bước đẩy đi, bước nhận và cờ vi phạm FTR |
| 15 | RLOS | H_NG_SB_RLOS_MAS_CITY | CẦN XÁC NHẬN — CITY_CODE | DIM_LOS_GEO | Danh mục tỉnh/thành, 63 bản ghi |
| 16 | RLOS | H_NG_SB_RLOS_MAS_DISTRICT | CẦN XÁC NHẬN — DISTRICT_CODE | DIM_LOS_GEO | Danh mục quận/huyện, 710 bản ghi |
| 17 | RLOS | NG_SB_RLOS_APPLICANT_DETAIL | WI_NAME — đã chốt | DIM_LOS_PARTY | Thông tin chi tiết người vay: địa chỉ, hôn nhân, học vấn, phân khúc |
| 18 | RLOS | NG_SB_RLOS_APPLICANT_GENERAL | WI_NAME — đã chốt | DIM_LOS_APPLICATION; DIM_LOS_PARTY; DIM_LOS_ORG_UNIT; DIM_LOS_PRODUCT | Thông tin chung hồ sơ KHCN: sản phẩm, đơn vị, cán bộ, chính sách |
| 19 | RLOS | NG_SB_RLOS_APPLICANT_IDGRID | CẦN XÁC NHẬN — dev DB có RECID | FCT_LOS_APPLICATION_PARTY; DIM_LOS_PARTY | Giấy tờ tùy thân người vay chính |
| 20 | RLOS | NG_SB_RLOS_APPROVAL | WI_NAME — đã chốt | DIM_LOS_APPLICATION; DIM_LOS_APPROVAL_GROUP | Luồng và cấp phê duyệt phía RLOS |
| 21 | RLOS | NG_SB_RLOS_COL_OTHER | CẦN XÁC NHẬN — DESCRIBE là mô tả, khó làm khóa | DIM_LOS_COLLATERAL; FCT_LOS_COLLATERAL | Tài sản bảo đảm khác |
| 22 | RLOS | NG_SB_RLOS_COL_REALESTATE | WI_NAME + NO_CERTI — đã chốt | DIM_LOS_COLLATERAL; FCT_LOS_COLLATERAL | Tài sản bảo đảm là bất động sản |
| 23 | RLOS | NG_SB_RLOS_COL_TRANSPORT | WI_NAME + CONTROL_POSTER — đã chốt | DIM_LOS_COLLATERAL; FCT_LOS_COLLATERAL | Tài sản bảo đảm là phương tiện vận tải |
| 24 | RLOS | NG_SB_RLOS_COL_VALPAPER | WI_NAME + NUMBERSIGN — đã chốt | DIM_LOS_COLLATERAL; FCT_LOS_COLLATERAL | Tài sản bảo đảm là giấy tờ có giá |
| 25 | RLOS | NG_SB_RLOS_COLL_CERTIGRD | CẦN XÁC NHẬN — chưa có trong metadata | DIM_LOS_COLLATERAL | Số giấy chứng nhận tài sản. Phục vụ trường GCN_OTHER của BC1 |
| 26 | RLOS | NG_SB_RLOS_COREP_IDGRID | CẦN XÁC NHẬN — hỏi tổ hợp WI_NAME + ID_NUMBER + ID_TYPE + PIN | FCT_LOS_APPLICATION_PARTY | Giấy tờ tùy thân người đồng trả nợ. PIN có giá trị Corep1 đến Corep4 |
| 27 | RLOS | NG_SB_RLOS_COREPAYER_GENERAL | CẦN XÁC NHẬN — metadata ghi WI_NAME nhưng thực tế lưu hết người đồng trả nợ | DIM_LOS_PARTY; FCT_LOS_APPLICATION_PARTY | Nhân thân người đồng trả nợ. Xác nhận grain nhiều dòng của FCT_LOS_APPLICATION_PARTY |
| 28 | RLOS | NG_SB_RLOS_CREDIT_CARD | CẦN XÁC NHẬN — 1 hồ sơ có thể nhiều dòng thẻ | FCT_LOS_SUB_PRODUCT | Hạn mức và kỳ hạn thẻ tín dụng. Phục vụ SPP_Amount và SPP_Term của BC1 |
| 29 | RLOS | NG_SB_RLOS_CREDIT_PROPOSAL | CẦN XÁC NHẬN — hỏi khóa; 1 hồ sơ chỉ có 1 sản phẩm chính | FCT_LOS_APPLICATION_DAILY | Đề xuất tín dụng sản phẩm chính: số tiền, kỳ hạn, lãi suất, LTV |
| 30 | RLOS | NG_SB_RLOS_CREDIT_PROPOSAL_APP | CẦN XÁC NHẬN — như trên | FCT_LOS_APPLICATION_DAILY | Đề xuất tín dụng chi tiết mở rộng: mục đích vay, phương thức trả nợ |
| 31 | RLOS | NG_SB_RLOS_CBS | CẦN XÁC NHẬN — hỏi bản ghi có bị ghi đè khi thay đổi không | FCT_LOS_SUB_PRODUCT; DIM_LOS_CARD_PROMOTION | Gói dữ liệu đẩy sang T24. Nguồn của PROMOTION_ID (BC1) thay cho bảng DATA_SENT_CBS đã ngừng nạp |
| 32 | RLOS | NG_SB_RLOS_DISB_COL_GRID | CẦN XÁC NHẬN — chưa có trong metadata | DIM_LOS_COLLATERAL | Tài sản hình thành từ vốn vay. Phục vụ trường PROPERTY_FORMED của BC1 |
| 33 | RLOS | NG_SB_RLOS_ENTRY_EXIT | WINAME + WORKSTEP + ENTRYDATE — đã chốt | FCT_LOS_WORKSTEP_EVENT; FCT_LOS_SLA_DAILY; FCT_LOS_APPLICATION_DAILY; DIM_LOS_WORKSTEP; DIM_LOS_DECISION; DIM_LOS_USER | Nhật ký xử lý hồ sơ phía RLOS |
| 34 | RLOS | NG_SB_RLOS_EXCEPTION | CẦN XÁC NHẬN — chọn giữa tổ hợp 4 cột hay RECID | FCT_LOS_EXCEPTION | Lý do khi hồ sơ chuyển bước phía RLOS |
| 35 | RLOS | NG_SB_RLOS_EXTTABLE | CẦN XÁC NHẬN — dev DB có ITEMINDEX + ITEMTYPE, WI_NAME bị dup | DIM_LOS_APPLICATION; DIM_LOS_CHANGE_TYPE | Ảnh chụp trạng thái hồ sơ, cấp LOANCASEID và loại thay đổi điều kiện |
| 36 | RLOS | NG_SB_RLOS_MANUAL_DEVIATION | CẦN XÁC NHẬN — dev DB thấy 1 hồ sơ nhiều dòng cùng CHECKING_CONDITION | FCT_LOS_DEVIATION | Ngoại lệ chính sách phía RLOS |
| 37 | RLOS | NG_SB_RLOS_MAS_CARD_PROMOTIO | CẦN XÁC NHẬN — dev DB nhận PROMOTION_CODE làm khóa | DIM_LOS_CARD_PROMOTION | Danh mục chương trình ưu đãi phí thẻ |
| 38 | RLOS | NG_SB_RLOS_REPAY_CALC | CẦN XÁC NHẬN — hỏi khóa WI_NAME | FCT_LOS_APPLICATION_DAILY | Tổng thu nhập được công nhận. Phục vụ trường TOTAL_INCOME của BC1 |
| 39 | RLOS | NG_SB_RLOS_REPAYFLAGS | WI_NAME — đã chốt | FCT_LOS_APPLICATION_DAILY | 10 cờ nguồn thu nhập giữ nguyên tên cột nguồn, cộng ba trường tính sẵn REPAYMENT_SOURCE, INCOME_SOURCE_CNT và FLAG_BUSINESS_INCOME cho BC1 và BC9 |
| 40 | RLOS | NG_SB_RLOS_SENT_CBS_LOG | WI_NAME + REQID — đã chốt | FCT_LOS_SUB_PRODUCT | Log gửi T24. Lấy mã thẻ chính T24 trả về để BC1 tra loại thẻ |
| 41 | RLOS | NG_SB_RLOS_SUB_PRODUCT | CẦN XÁC NHẬN — FSS xác nhận 1 hồ sơ nhiều sản phẩm phụ nên WI_NAME không unique | FCT_LOS_SUB_PRODUCT; DIM_LOS_PRODUCT | Danh sách sản phẩm phụ đăng ký kèm. Phục vụ trường SAN_PHAM_PHU của BC1 |
| 42 | RLOS | NG_SB_RLOS_MAS_EXCEPTION | CẦN XÁC NHẬN — chưa có trong metadata, dev DB cũng chưa đánh khóa | DIM_LOS_EXCEPTION_REASON | Danh mục lý do phía RLOS. Phục vụ trường ACTIVITYNAME và EXCEPTION_CODE của BC7 |
| 43 | RLOS | SB_RLOS_MAS_CHANGE_TYPE | CẦN XÁC NHẬN — chưa có trong metadata | DIM_LOS_CHANGE_TYPE | Danh mục loại và chi tiết loại thay đổi điều kiện. Phục vụ CHANGE_TYPE_DETAIL của BC1 |

## 00_Sinh_khoa

- CƠ CHẾ SINH KHÓA CHO CÁC BẢNG NGUỒN CHƯA CÓ KHÓA
- Vấn đề | Nhiều bảng nguồn chưa có khóa nghiệp vụ được BA/DEV LOS xác nhận, việc khảo sát còn đang chạy. Chờ chốt xong mới dựng DWH thì tắc tiến độ; dựng bằng khóa tạm rồi sau đổi thì phải nạp lại toàn bộ lịch sử fact.
- Giải pháp | Tách làm hai lớp. STG_LOS mang theo dấu vết nhận dạng của bản ghi nguồn. DWH cấp khóa BỀN qua một bảng ánh xạ. Nhờ vậy khi khóa nguồn được chốt thì chỉ đổi công thức nhận dạng, còn khóa DWH đã cấp giữ nguyên nên KHÔNG phải nạp lại fact.
- Ở STG_LOS | Mỗi bảng thuộc nhóm chưa chốt khóa bổ sung 2 cột kỹ thuật khi CDC. SRC_ROWID lưu ROWID hoặc RECID của bản ghi nguồn nếu lấy được. SRC_IDENT lưu chuỗi ghép hoặc mã băm của bộ cột định danh đề xuất, dùng khi nguồn không có ROWID.
- Ở DWH | Mỗi thực thể chưa chốt khóa có một bảng ánh xạ bền MAP_LOS_<THỰC THỂ>_KEY gồm bốn cột: khóa DWH đã cấp, WI_NAME, SRC_IDENT, và FIRST_SEEN_DAYID. Bảng này CHỈ THÊM DÒNG, không bao giờ sửa hay xóa.
- Quy trình ETL | Bước 1 đọc STG_LOS và tính SRC_IDENT. Bước 2 tra bảng ánh xạ theo SRC_IDENT. Bước 3 nếu trúng thì lấy lại đúng khóa cũ, nếu trượt thì cấp khóa mới theo công thức ở cột Cách DWH sinh khóa rồi ghi thêm một dòng vào bảng ánh xạ. Bước 4 fact lấy khóa từ bảng ánh xạ, không tự sinh khóa.
- Khi BA chốt khóa | Chỉ đổi công thức tính SRC_IDENT rồi chạy một lần đối sánh lại bảng ánh xạ để gộp những dòng trước đây bị tách nhầm. Khóa đã cấp cho fact giữ nguyên nên lịch sử không phải nạp lại.
- Ràng buộc tuyệt đối | Không đưa giá trị biến động vào bộ cột định danh: số tiền, giá trị định giá, tỷ lệ LTV, ngày định giá, và text mô tả tự do. Bảng NG_SB_CLOS_COLL_CD hiện đang vi phạm điều này ở chính nguồn, hệ quả là định giá lại một tài sản bị hiểu thành một tài sản mới.
- Bảng DWH | Cột khóa | Bảng nguồn | Trạng thái khóa nguồn | Bộ cột định danh cho CDC | Cách DWH sinh khóa | Việc cần hỏi BA/DEV
- FCT_LOS_COLLATERAL | COLLATERAL_BK | NG_SB_RLOS_COL_REALESTATE / COL_TRANSPORT / COL_VALPAPER | ĐÃ CHỐT — WI_NAME + NO_CERTI / CONTROL_POSTER / NUMBERSIGN | Dùng thẳng bộ cột đã chốt, không cần SRC_ROWID | WI_NAME + COLL_TYPE_CODE + số giấy tờ đặc trưng của loại tài sản | Không phải chờ gì
- FCT_LOS_COLLATERAL | COLLATERAL_BK | NG_SB_RLOS_COL_OTHER | CHƯA CHỐT — metadata đề xuất WI_NAME + DESCRIBE nhưng DESCRIBE là mô tả tự do, sửa mô tả sẽ thành tài sản mới | SRC_ROWID; nếu nguồn không có thì hash(WI_NAME, DESCRIBE, PRICINGVALUE, LOANRATE, OWNER) | Tra MAP_LOS_COLLATERAL_KEY. Trượt thì cấp mới: WI_NAME + '|OTHER|' + số thứ tự 3 chữ số | Bảng có RECID không?
- FCT_LOS_COLLATERAL | COLLATERAL_BK | NG_SB_CLOS_COLL_CD | CHƯA CHỐT — khóa hiện tại chứa APPRAISED_VAL_FIG và LTV nên định giá lại bị hiểu thành tài sản mới | SRC_ROWID (danh sách CDC ghi dev DB đã thấy RECID). TUYỆT ĐỐI không đưa giá trị định giá vào bộ cột | Tra MAP_LOS_COLLATERAL_KEY. Trượt thì cấp mới: WI_NAME + '|' + COLLTYPE + '|' + số thứ tự | RECID có giữ nguyên khi tài sản được định giá lại không?
- FCT_LOS_DEVIATION | DEVIATION_BK | NG_SB_CLOS_CONDITON_CDGRID | CHƯA CHỐT — bảng chỉ có 4 cột, không cột nào định danh được dòng. Rủi ro cao nhất model | SRC_ROWID BẮT BUỘC. Dự phòng: hash(WI_NAME, DEVIATION_TYPE, AS_REGULAR, DEV_PROPOSAL) | Tra MAP_LOS_DEVIATION_KEY. Trượt thì cấp mới: WI_NAME + '|D|' + số thứ tự 3 chữ số | AS_REGULAR có cố định không? Nguồn có ROWID nghiệp vụ ẩn không?
- FCT_LOS_DEVIATION | DEVIATION_BK | NG_SB_RLOS_MANUAL_DEVIATION | CHƯA CHỐT — đã kiểm tra trên DB: WI_NAME + CHECKING_CONDITION KHÔNG duy nhất | SRC_ROWID BẮT BUỘC. Dự phòng: hash toàn bộ cột của bảng | Như trên, dùng chung MAP_LOS_DEVIATION_KEY | Trên live có lặp giống môi trường dev không?
- FCT_LOS_EXCEPTION | EXCEPTION_BK | NG_SB_CLOS_EXCEPTION và NG_SB_RLOS_EXCEPTION | HAI PHƯƠNG ÁN — metadata đề xuất tổ hợp 5 cột, dev DB lại sinh RECID | Ưu tiên SRC_ROWID. Dự phòng: hash(WI_NAME, EXCEPTION_CATEGORY, EXCEPTION_NAME, RAISED_BY, RAISED_DATE_TIME) | Tra MAP_LOS_EXCEPTION_KEY. Trượt thì cấp mới: WI_NAME + '|E|' + số thứ tự 4 chữ số | Chọn RECID hay tổ hợp 5 cột?
- FCT_LOS_APPLICATION_PARTY | APPLICATION_PARTY_BK | NG_SB_RLOS_APPLICANT_IDGRID | GẦN CHỐT — bảng đã có sẵn cột RECID | SRC_ROWID = RECID | WI_NAME + '|APPLICANT|' + ID_TYPE + '|' + ID_NUMBER | Xác nhận RECID là khóa của bảng
- FCT_LOS_APPLICATION_PARTY | APPLICATION_PARTY_BK | NG_SB_RLOS_COREP_IDGRID | CHƯA CHỐT — dev DB dùng WI_NAME + ID_NUMBER + ID_TYPE, metadata dùng WI_NAME + PIN + ID_TYPE | hash(WI_NAME, PIN, ID_TYPE, ID_NUMBER) - gộp cả hai phương án cho an toàn | WI_NAME + '|COREPAYER|' + PIN + '|' + ID_TYPE + '|' + ID_NUMBER | Tổ hợp đủ có phải WI_NAME + ID_NUMBER + ID_TYPE + PIN không?
- FCT_LOS_APPLICATION_PARTY | APPLICATION_PARTY_BK | NG_SB_RLOS_COREPAYER_GENERAL | CHƯA CHỐT — metadata ghi WI_NAME nhưng thực tế bảng lưu HẾT người đồng trả nợ | dev DB đề xuất WI_NAME + REL_TO_APPLICANT + ID_NO_CO | WI_NAME + '|COREPAYER|' + ID_NO_CO | Xác nhận tổ hợp. ID_NO_CO có cùng vai trò với PIN bên COREP_IDGRID không?
- FCT_LOS_APPLICATION_PARTY | APPLICATION_PARTY_BK | NG_SB_CLOS_CUST_INFO_LEGAL | GẦN CHỐT — BA đã xác nhận 1 người giữ nhiều vai trò nên phải thêm OBJ_TYPE vào khóa | WI_NAME + OBJ_TYPE + LEGAL_DOC + ID_NUMBER | WI_NAME + '|' + OBJ_TYPE + '|' + ID_NUMBER | Thêm OBJ_TYPE đã đủ duy nhất chưa?
- FCT_LOS_SUB_PRODUCT | SUB_PRODUCT_BK | NG_SB_RLOS_SUB_PRODUCT | CHƯA CHỐT — FSS xác nhận 1 hồ sơ có nhiều sản phẩm phụ nên WI_NAME không đủ | hash(WI_NAME, SUB_PRODUCT_LINE) - bảng nguồn chỉ có đúng 2 cột | WI_NAME + '|' + SUB_PRODUCT_LINE | Xác nhận khóa của bảng
- FCT_LOS_SUB_PRODUCT | SUB_PRODUCT_BK | NG_SB_RLOS_CREDIT_CARD | CHƯA CHỐT — 1 WI_NAME có nhiều dòng, ETL hiện tại né bằng MAX(LIMIT_NO) | hash(WI_NAME, CARD_TYPE, RELEASE) | WI_NAME + '|CARD|' + CARD_TYPE + '|' + RELEASE | Nhiều dòng do nhiều loại thẻ hay do nhiều lần điều chỉnh hạn mức?
- DIM_LOS_PARTY | PARTY_NK | tất cả bảng nhân thân hai hệ | CHƯA CHỐT — RLOS chưa gắn CIF tại thời điểm khởi tạo hồ sơ | Chuẩn hóa số giấy tờ: UPPER(REGEXP_REPLACE(ID_NUMBER, '[^0-9A-Z]', '')) | ID_TYPE + '|' + số giấy tờ đã chuẩn hóa | Chốt quy tắc chuẩn hóa và cách xử lý khi một người đổi CMND sang CCCD
- DIM_LOS_COLLATERAL | COLLATERAL_NK | theo FCT_LOS_COLLATERAL | Theo COLLATERAL_BK | Dùng lại đúng giá trị đã cấp cho COLLATERAL_BK | Bằng COLLATERAL_BK | Theo FCT_LOS_COLLATERAL
- DIM_LOS_EXCEPTION_REASON | EXCEPTION_REASON_NK | NG_SB_CLOS_MAS_EXCEPTION và NG_SB_RLOS_MAS_EXCEPTION | CHƯA CHỐT — metadata suy luận, bảng phía RLOS còn chưa có trong metadata | hash(ACTIVITYNAME, DECISION, EXCEPTION_CATEGORY, EXCEPTION_NAME) | SYSTEM_CODE + '|' + ACTIVITYNAME + '|' + DECISION + '|' + EXCEPTION_CATEGORY + '|' + EXCEPTION_NAME | Xác nhận tổ hợp 4 cột có phải khóa không
