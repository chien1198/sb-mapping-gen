# DATAMODEL DWH LOS — Overview nghiệp vụ

Nguồn: `input/DATAMODEL_DWH_LOS_20260903.xlsx`. Tổng hợp từ 3 sheet giải thích
nghiệp vụ (`00_Ly_do_bang`, `00_Van_de_can_chot`, `00_Rule_nghiep_vu`), không
bao gồm các sheet thuần kỹ thuật/vận hành (Muc_luc, Cot_CDC, Phan_loai_nguon,
Doc_STG_LOS, Thu_tu_nap, Chay_lan_dau) và không bao gồm nội dung từng bảng
DIM/FCT (xem `extract/database/*.md` cho mapping logic theo cột).

## 1. Lý do tồn tại của từng bảng

Nguồn sheet: `00_Ly_do_bang`.

Mỗi bảng sinh ra từ một trong ba lý do (cột **Xuất phát từ**): cấu trúc dữ
liệu nguồn ép phải tách; yêu cầu của báo cáo đòi thứ hệ nguồn không lưu; hoặc
nhu cầu chống đếm trùng khi tổng hợp. Cột **Lý do tồn tại** nói rõ bảng cung
cấp gì và vì sao không gộp được vào bảng khác.

| # | Tên bảng | Nhóm | Xuất phát từ | Grain | Lý do tồn tại | Báo cáo dùng |
|---|----------|------|--------------|-------|---------------|--------------|
| 1 | DIM_LOS_APPLICATION | Chiều thực thể | Cấu trúc dữ liệu nguồn | 1 dòng = 1 phiên bản thuộc tính của 1 hồ sơ | Hai hệ nguồn dùng hai bộ cột khác nhau để mô tả cùng một hồ sơ. Chiều này hợp nhất về một danh tính duy nhất và giữ các thuộc tính gắn 1:1 với hồ sơ, tương đối ổn định theo thời gian. Quản lý theo SCD Type 2 để báo cáo kỳ cũ dựng lại được nguyên trạng. | BC1, BC2, BC3, BC4, BC5, BC6, BC7, BC8, BC9, BC10, BC11 |
| 2 | DIM_LOS_APPROVAL_GROUP | Chiều danh mục | Yêu cầu báo cáo | 1 dòng = 1 cấp phê duyệt của 1 hệ nguồn | Danh mục cấp thẩm quyền phê duyệt từ A1 đến C3 và BOD, kèm thứ tự cấp. BC5 tra cam kết SLA theo cấp thẩm quyền của hồ sơ. | BC1, BC2, BC5, BC9 |
| 3 | DIM_LOS_CARD_PROMOTION | Chiều danh mục | Yêu cầu báo cáo | 1 dòng = 1 phiên bản của 1 chương trình ưu đãi | Danh mục chương trình ưu đãi phí cho hồ sơ phát hành thẻ tín dụng. BC1 hiển thị phần mô tả chương trình chứ không phải mã, nên cần danh mục để tra. | BC1 |
| 4 | DIM_LOS_CHANGE_TYPE | Chiều danh mục | Yêu cầu báo cáo | 1 dòng = 1 tổ hợp loại + chi tiết loại thay đổi của 1 hệ nguồn | Danh mục loại thay đổi điều kiện tín dụng. BC5 dùng để nhận biết hồ sơ cơ cấu nợ. | BC1, BC2, BC5 |
| 5 | DIM_LOS_COLLATERAL_TYPE | Chiều danh mục | Cấu trúc dữ liệu nguồn | 1 dòng = 1 loại tài sản bảo đảm của 1 hệ nguồn | Gộp loại tài sản của hai hệ nguồn về một bộ nhóm chung, để BC1 đếm được số tài sản theo từng nhóm. | BC1, BC2, BC3, BC9 |
| 6 | DIM_LOS_DECISION | Chiều danh mục | Yêu cầu báo cáo | 1 dòng = 1 quyết định của 1 hệ nguồn | Danh mục quyết định tại mỗi bước, kèm phân nhóm thành phê duyệt, từ chối, trả về và hủy. Gần như mọi rule lọc của các báo cáo đều dựa trên phân nhóm này. | BC1, BC2, BC3, BC4, BC7, BC8, BC9 |
| 7 | DIM_LOS_EXCEPTION_REASON | Chiều danh mục | Yêu cầu báo cáo | 1 dòng = 1 tổ hợp bước + quyết định + nhóm lý do + tên lý do | Danh mục lý do ngoại lệ theo bước xử lý và quyết định. BC7 dùng để nhận biết các mã vi phạm First Time Right. | BC7, BC8 |
| 8 | DIM_LOS_GEO | Chiều danh mục | Yêu cầu báo cáo | 1 dòng = 1 quận/huyện thuộc 1 tỉnh/thành | Danh mục tỉnh thành và quận huyện. Phục vụ BC1 ghép địa chỉ hiện tại đầy đủ của người vay. | BC1 |
| 9 | DIM_LOS_ORG_UNIT | Chiều danh mục | Yêu cầu báo cáo | 1 dòng = 1 phòng giao dịch | Danh mục đơn vị kinh doanh kèm chi nhánh và khu vực. BC9 loại trừ ba đơn vị khỏi phép tính KPI nên cần danh mục để lọc. | BC1, BC2, BC9 |
| 10 | DIM_LOS_PRODUCT | Chiều danh mục | Yêu cầu báo cáo | 1 dòng = 1 phiên bản của 1 sản phẩm theo hệ nguồn và bộ mã sản phẩm ổn định | Danh mục sản phẩm tín dụng. Là thành phần khóa để BC5 tra cam kết SLA, và là điều kiện phân nhóm KPI của BC9. | BC1, BC2, BC5, BC9 |
| 11 | DIM_LOS_USER | Chiều thực thể | Thiết kế | 1 dòng = 1 phiên bản của 1 tài khoản người dùng | Danh mục tài khoản cán bộ xử lý hồ sơ. Hiện chỉ có username, nhưng giữ thành chiều riêng để khi bổ sung thông tin nhân sự như email, mã nhân viên, đơn vị công tác hay chức danh thì chỉ thêm cột vào đây, các bảng fact đang tham chiếu không phải sửa. | BC1, BC2, BC3, BC4, BC7, BC8, BC9 |
| 12 | DIM_LOS_WORKSTEP | Chiều danh mục | Cấu trúc dữ liệu nguồn | 1 dòng = 1 bước xử lý của 1 hệ nguồn | Danh mục bước xử lý. Hai hệ dùng chung engine nhưng giá trị bước có khi mang tiền tố hệ nguồn; chiều này làm sạch tiền tố đó để báo cáo lọc bằng một bộ mã duy nhất. | BC1, BC2, BC3, BC4, BC5, BC7, BC8, BC9 |
| 13 | FCT_LOS_APPLICATION_DAILY | Bảng nền | Yêu cầu báo cáo | 1 dòng = 1 hồ sơ x 1 ngày dữ liệu | Hệ nguồn chỉ giữ trạng thái hiện tại của hồ sơ và ghi đè khi hồ sơ đi tiếp, nên không trả lời được câu hỏi của BC4 là ngày hôm đó còn bao nhiêu hồ sơ chưa xử lý xong. Bảng này chụp lại trạng thái cuối mỗi ngày của từng hồ sơ, gồm cả hồ sơ đang tồn đọng. Là bảng gốc để mọi báo cáo join các bảng chi tiết vào. | BC1, BC2, BC3, BC4, BC5, BC6, BC7, BC8, BC9, BC10, BC11 |
| 14 | FCT_LOS_APPLICATION_PARTY | Chi tiết theo dòng grid | Cấu trúc dữ liệu nguồn | 1 dòng = 1 người liên quan của 1 hồ sơ, trong ảnh chụp của ngày DAYID | Một hồ sơ có người vay chính, người đồng trả nợ và các vai trò liên quan khác. BC1 và BC2 hiển thị thông tin từng người, nên cần một dòng cho mỗi người trên hồ sơ. | BC1, BC2, BC3, BC4 |
| 15 | FCT_LOS_COLLATERAL | Chi tiết theo dòng grid | Cấu trúc dữ liệu nguồn | 1 dòng = 1 tài sản bảo đảm của 1 hồ sơ, trong ảnh chụp của ngày DAYID | Một hồ sơ có thể thế chấp nhiều tài sản. Ở nguồn, CLOS gộp tài sản vào một bảng còn RLOS tách bốn bảng theo loại: bất động sản, phương tiện vận tải, giấy tờ có giá và tài sản khác. Bảng này hợp nhất năm nguồn đó về một cấu trúc chung, mỗi tài sản một dòng. | BC1, BC2, BC3, BC9 |
| 16 | FCT_LOS_DEVIATION | Chi tiết theo dòng grid | Yêu cầu báo cáo | 1 dòng = 1 ngoại lệ chính sách trong ảnh chụp của ngày DAYID | Ngoại lệ chính sách áp cho hồ sơ. BC5 dùng số lượng ngoại lệ làm một thành phần khóa để tra đúng dòng cam kết SLA; BC9 dùng để phân nhóm KPI. Một hồ sơ có thể có nhiều ngoại lệ nên phải tách dòng. | BC5, BC6, BC9 |
| 17 | FCT_LOS_EXCEPTION | Chi tiết theo dòng grid | Yêu cầu báo cáo | 1 dòng = 1 lần ghi nhận lý do của 1 hồ sơ, trong ảnh chụp của ngày DAYID | Mỗi lần hồ sơ bị trả về hoặc bị yêu cầu bổ sung, hệ thống ghi nhận một lý do. BC7 và BC8 đếm và phân loại các lần ghi nhận đó, nên cần lưu từng lần thay vì chỉ lưu lần gần nhất. | BC7, BC8 |
| 18 | FCT_LOS_PARTY_DOCUMENT | Chi tiết theo dòng grid | Cấu trúc dữ liệu nguồn | 1 dòng = 1 giấy tờ tùy thân của 1 người trên 1 hồ sơ, trong ảnh chụp của ngày DAYID | Một người liên quan có thể có nhiều giấy tờ tùy thân. Tách khỏi bảng người để giữ đúng grain: gộp chung sẽ nhân số dòng người lên theo số giấy tờ của họ. | BC1, BC2 |
| 19 | FCT_LOS_SLA_DAILY | Thời gian xử lý | Yêu cầu báo cáo | 1 dòng = 1 hồ sơ x 1 ngày có action | BC5 cần thời gian xử lý của từng bước riêng biệt, mỗi bước đo theo ba cách: theo lịch, theo giờ làm việc và theo khung giờ cam kết SLA. Ba cách đo nhân bảy bước là hơn hai mươi cột. Tách khỏi bảng xương sống vì phạm vi ghi hẹp hơn, phụ thuộc thêm bốn bảng cam kết SLA nên nạp sau, và chỉ BC5 với BC9 dùng. | BC5, BC9 |
| 20 | FCT_LOS_SUB_PRODUCT | Chi tiết theo dòng grid | Cấu trúc dữ liệu nguồn | 1 dòng = 1 occurrence sản phẩm phụ trong ảnh chụp của ngày DAYID | Sản phẩm phụ đăng ký kèm hồ sơ. Bốn nhóm SeABuy, SeACivil, SeATeacher và SeAWoman mỗi loại tối đa một dòng trên hồ sơ; riêng thẻ tín dụng phụ có thể có nhiều dòng. Sản phẩm chính thuộc về hồ sơ và nằm ở DIM_LOS_PRODUCT, không gộp chung grain. | BC1, BC5 |
| 21 | FCT_LOS_WORKSTEP_EVENT | Bảng nền | Cấu trúc dữ liệu nguồn | 1 dòng = 1 phiên bản của 1 logical event (1 hồ sơ x 1 workstep x 1 lần vào bước theo ENTRYDATE) | Cả CLOS và RLOS chạy trên cùng một workflow engine, ghi nhật ký vào NG_SB_*_ENTRY_EXIT: mỗi lần hồ sơ vào một bước là một dòng, kèm thời điểm vào, thời điểm ra, người xử lý và quyết định. Đây là bảng duy nhất ở hệ nguồn mang chiều thời gian thật. Toàn bộ chỉ tiêu về mốc thời gian, thời gian xử lý, số lần trả về và số nhân sự đều tính từ bảng này. | BC1, BC2, BC3, BC4, BC5, BC7, BC8, BC9, BC10, BC11 |

## 2. Việc còn treo (chưa chốt)

Nguồn sheet: `00_Van_de_can_chot`. Cửa vào của tài liệu — mọi việc chưa chốt
nằm hết ở đây, đã khử trùng lặp. Chốt xong thì xóa dòng khỏi sheet gốc và sửa
thẳng vào sheet bảng tương ứng.

Phân nhóm: **A** = chặn viết ETL, phải chốt trước khi code · **B** = chặn
đúng số liệu báo cáo · **C** = lệch tài liệu, phát hiện ngay khi chạy thử.

| # | Nhóm | Việc cần chốt | Không chốt thì sao | Ai trả lời | Chốt xong được gì | Chi tiết ở sheet |
|---|------|----------------|----------------------|------------|---------------------|-------------------|
| 1 | A | Hợp đồng dữ liệu CDC cho 29 bảng loại 1: GoldenGate có trả đủ AFTER IMAGE cho mọi UPDATE, BEFORE IMAGE cho DELETE, và cờ phân biệt I/U/D không | Thiếu after image thì UPDATE thưa cột không dựng lại được trạng thái đầy đủ. Toàn bộ quy trình A ở 00_Doc_STG_LOS phụ thuộc câu trả lời này. | Đội CDC | Chốt được payload CDC để viết ETL chuẩn hóa | 00_Doc_STG_LOS |
| 2 | A | Cột nào phá hòa khi nhiều bản ghi loại 1 có cùng COMMIT_SCN | COMMIT_SCN không duy nhất cho từng dòng. Model đang xếp COMMIT_SCN rồi TIME_UPDATE. Nếu TIME_UPDATE cũng trùng thì không xác định được bản ghi nào mới nhất. | Đội CDC | Xác định được thứ tự bản ghi trong cùng một commit | 00_Doc_STG_LOS |
| 3 | A | Mâu thuẫn đơn vị TAT giữa BC5 và BC9. Mô tả BC5 ghi "Working minutes" nhưng công thức lại chia 60, rồi BC9 chia 60 thêm lần nữa. Kết quả cuối cùng là GIỜ hay PHÚT | Sai 60 lần trên toàn bộ chỉ tiêu thời gian xử lý của BC5 và BC9, là nhóm chỉ tiêu chính của hai báo cáo. | BA nghiệp vụ | Chốt đơn vị đầu ra của từng trường TAT. Model đang lưu GIỜ, NUMBER(18,6). | FCT_LOS_SLA_DAILY |
| 4 | A | 18 bảng loại 2: bảng nào thực sự có cột NGÀY DỮ LIỆU ở nguồn | Có cột ngày thì đồng bộ bằng delete+insert theo ngày, STG giữ được nhiều ngày và chạy lại được. Không có thì truncate+insert, STG chỉ có ảnh hiện tại, bỏ lỡ một ngày là mất vĩnh viễn. Rà metadata thì không bảng nào có, nhưng metadata đã nhiều lần thiếu cột. | BA/DEV LOS | Gỡ được ràng buộc không chạy lại được của 18 bảng | 00_Phan_loai_nguon |
| 5 | B | Cột CLOB bị loại khỏi khóa hash: hai dòng khác nhau CHỈ ở nội dung CLOB sẽ ra cùng một khóa và bị gộp làm một | Ảnh hưởng 5 bảng grid có CLOB: NG_SB_RLOS_MANUAL_DEVIATION (REASON), NG_SB_CLOS_CONDITON_CDGRID (AS_REGULAR, DEV_PROPOSAL), NG_SB_CLOS_COLL_CD (COLL_MGMT_APP, DESCRIPTION), NG_SB_RLOS_CREDIT_CARD_APP (COMMENT_CO), NG_SB_RLOS_SENT_CBS_LOG (REQUEST). Hai bảng đầu là nguồn của FCT_LOS_DEVIATION nên gộp nhầm sẽ làm hụt số đếm của BC5, BC6, BC9. | BA/DEV LOS | Biết được có cần cột phụ để phân biệt hay chấp nhận gộp | 00_Doc_STG_LOS |
| 6 | B | COLL_CERTIGRD 1:1 với tài sản và DISB_COL_GRID lặp lại 4 loại tài sản: cột nào là join key về đúng dòng tài sản | Không chốt thì CERTIFICATE_NO và IS_FORMED_FROM_LOAN có thể gắn nhầm tài sản trên hồ sơ có nhiều tài sản cùng loại. | BA/DEV LOS | Nạp đúng CERTIFICATE_NO và IS_FORMED_FROM_LOAN vào FCT_LOS_COLLATERAL | FCT_LOS_COLLATERAL |
| 7 | B | Rule cancel và rule tồn đọng của BC4: hồ sơ ở trạng thái nào thì bị loại khỏi tập tồn đọng | Tập tồn đọng quyết định số dòng của bảng nặng nhất model và quyết định luôn phạm vi ghi của 6 bảng chi tiết dạng B. Rule sai thì số hồ sơ tồn đọng của BC4 sai và khối lượng dữ liệu sai theo. | BA nghiệp vụ | Chốt được APPLICATION_REPORT_SET | FCT_LOS_APPLICATION_DAILY |
| 8 | B | Với 11 cột user theo vai trò của BC1 và BC2: hồ sơ quay lại cùng một bước nhiều lần thì lấy người của lần nào | SRS chỉ ghi "lấy USERNAME tại WORKSTEP = X", không nói lần nào. Hồ sơ bị trả về rồi làm lại sẽ có nhiều người khác nhau ở cùng một bước. Model đang lấy lần HOÀN TẤT GẦN NHẤT. | BA nghiệp vụ | Chốt quy tắc chọn event cho 11 cột user | FCT_LOS_APPLICATION_DAILY |
| 9 | B | FIRST_APPROVED_WI_NAME của BC11 lệch với SRS: SRS ghi "lấy wi_name nhỏ nhất của cùng LOANCASEID", model lấy hồ sơ có event phê duyệt hợp lệ sớm nhất | Hai cách cho kết quả khác nhau khi hồ sơ tạo sớm nhất không phải hồ sơ được duyệt sớm nhất. | BA nghiệp vụ | Chốt định nghĩa hồ sơ cha của BC11 | DIM_LOS_APPLICATION |
| 10 | C | Tên cột khu vực phía CLOS là ZONE hay ZONEE | Sai tên cột thì ETL lỗi ngay lần chạy đầu, dễ phát hiện, không nguy hiểm. | BA/DEV LOS | Chốt nguồn của DIM_LOS_ORG_UNIT.ZONE_NAME_LOS | DIM_LOS_ORG_UNIT |
| 11 | C | NG_SB_RLOS_APPLICANT_DETAIL có cột VEHICLE không | Metadata không liệt kê nhưng danh sách cột của bảng này chưa đầy đủ. Không có thì FCT_LOS_APPLICATION_PARTY.VEHICLE mất nguồn và BC1 mất trường VEHICLES. | BA/DEV LOS | Chốt nguồn của FCT_LOS_APPLICATION_PARTY.VEHICLE | FCT_LOS_APPLICATION_PARTY |
| 12 | C | PRODUCT_NAME có phụ thuộc hàm vào cặp PRODUCT_LINE_CODE + SUB_PRODUCT_CODE không | Hiện giữ PRODUCT_NAME trong khóa tự nhiên theo phương án an toàn. Có phụ thuộc hàm thì gọn được khóa. | Chạy kiểm tra dữ liệu | Gọn khóa tự nhiên của DIM_LOS_PRODUCT còn 3 thành phần | DIM_LOS_PRODUCT |
| 13 | B | Khóa CDC của NG_SB_CLOS_EXCEPTION và NG_SB_RLOS_EXCEPTION không chứa EXCEPTION_NAME. Hai lý do khác tên nhưng cùng hồ sơ, cùng nhóm, cùng người nêu, cùng giây thì có xảy ra không | Nếu có xảy ra thì hai dòng đụng khóa chính của FCT_LOS_EXCEPTION, một trong hai bị mất | BA/DEV LOS | Chốt được khóa chính của FCT_LOS_EXCEPTION: giữ 4 cột theo khóa CDC, hay phải thêm EXCEPTION_NAME | FCT_LOS_EXCEPTION |

## 3. Rule nghiệp vụ (không vật chất hóa thành cột)

Nguồn sheet: `00_Rule_nghiep_vu`. Các rule dưới đây trước kia là cột cờ trong
DWH, nay đã gỡ hết — giữ lại làm tài liệu để tầng DTM áp dụng.

### 3.1 Danh sách rule

| # | Tên cũ trong DWH | Bảng cũ | Nội dung rule | Báo cáo dùng |
|---|--------------------|---------|----------------|---------------|
| 1 | IS_CREDIT_CARD | DIM_LOS_PRODUCT | 'Y' nếu SUB_PRODUCT_CODE chứa 'Phát hành' hoặc 'TTD'. Đối chiếu thêm PRODUCT_NAME khi SUB_PRODUCT_CODE rỗng. BC9 dùng để tách nhóm thẻ khỏi nhóm vay thường khi tính tỷ lệ giải ngân | (đầu vào BC9.SLHS_RLOS, BC9.SLGN_RLOS) |
| 2 | IS_FAST_PRODUCT | DIM_LOS_PRODUCT | 'Y' nếu PRODUCT_NAME thuộc ('SeAHome-Fast','SeAHome-FastTSDB') theo đúng rule BC9. BC9 loại nhóm này khỏi bước đối chiếu giải ngân thực tế | (đầu vào BC9.SLHS_RLOS) |
| 3 | IS_UNSECURED_DEFAULT | DIM_LOS_PRODUCT | 'Y' nếu IS_CREDIT_CARD = 'Y' hoặc PRODUCT_NAME thuộc ('SeABuyHuutri','SeACivil','SeAHome-Buy','SeAHome-Fast','SeAHome-Woman','SeAHome-Teacher','SeAFast_KTSBD_KD','SeAHome-Pro') theo đúng rule BC9. BC9 dùng để gắn cờ SEC/UNSEC khi tính TAT bình quân | (đầu vào BC9.TAT_RLOS) |
| 4 | IS_PDTD_STEP | DIM_LOS_WORKSTEP | 'Y' nếu WORKSTEP_CODE thuộc ('DetailDataEntry','DataInputerChecker','UnderwriterMaker','UnderwriterChecker','PhoneVerification','CreditApproval','CreditCommittee','HOSupport'). BC9 dùng danh sách này để đếm nhân sự Khối PDTD | (đầu vào BC9.NHAN_SU) |
| 5 | IS_APPROVAL_STEP | DIM_LOS_WORKSTEP | 'Y' nếu WORKSTEP_CODE thuộc ('CreditApproval','CreditCommittee','CreditApprovalReview'). Lưu ý BC1, BC2, BC3, BC5, BC9 chỉ tính hai bước đầu, riêng BC10 tính cả CreditApprovalReview khi lấy ngày phê duyệt — bảng map Q_RLOS_REF_WORKSTEP_2SYSTEMS cũng xếp bước này vào nhóm 07.APPROVER. Cờ này lấy định nghĩa rộng; báo cáo nào cần định nghĩa hẹp thì loại thêm CreditApprovalReview ở tầng datamart | (điều kiện lọc BC3; đầu vào BC10.APPROVAL_DATE, BC11.APPROVAL_DATE) |
| 6 | IS_CANCEL_STEP | DIM_LOS_WORKSTEP | 'Y' nếu WORKSTEP_CODE thuộc ('CancelRevoke','CancelPermanent'). CancelRevoke là mốc nghiệp vụ dùng tính ngày hủy; CancelPermanent là trạng thái hệ thống tự chuyển tiếp nếu ĐVKD không tác động, không thay thế mốc ngày CancelRevoke. | (đầu vào BC1.BI_APPSTATUS, BC2.BI_APPSTATUS) |
| 7 | IS_APPROVED | DIM_LOS_DECISION | 'Y' nếu DECISION_CODE thuộc ('Submit','Send To HOSupport','Send To PostSanction','Submit To DisbursementMaker'). Chỉ trở thành sự kiện phê duyệt hợp lệ khi đi cùng WORKSTEP_CODE CreditApproval/CreditCommittee và EXITDATE khác NULL. | (đầu vào PROCESSED_DATE và BI_APPSTATUS; điều kiện lọc BC3) |
| 8 | IS_REJECT | DIM_LOS_DECISION | 'Y' nếu DECISION_CODE='Reject'. Reject vẫn là terminal event tại bước phê duyệt và tham gia ưu tiên 1/PROCESSED_DATE khi đi cùng CreditApproval/CreditCommittee và EXITDATE khác NULL, nhưng BI_APPSTATUS hiển thị Rejected. | (đầu vào BI_APPSTATUS) |
| 9 | IS_RETURN | DIM_LOS_DECISION | 'Y' nếu DECISION_CODE thuộc ('Send_Back','Send_Back to DDE','Send Back DataInputerChecker','Send_Back to BranchSupport','Additional_Doc_Required'). Dùng cho các phép đếm return của BC8 | (đầu vào BC8.sl_return_*; BC7.FIRST_WORKSTEP_RETURN) |
| 10 | IS_CANCEL | DIM_LOS_DECISION | 'Y' nếu DECISION_CODE = 'Cancel' | (đầu vào BC1.CAN_USER_DATE; BC4.REPORT_DATE) |
| 11 | IS_DRAFT_SEND | DIM_LOS_DECISION | 'Y' với các lần gửi dự thảo đề xuất cho chi nhánh, nhận biết qua lý do đi kèm ('Gửi dự thảo đề xuất cho chi nhánh', 'UW-BR-FTR: Gửi dự thảo phê duyệt TD', 'CK-BR: Gửi dự thảo về ĐVKD'). BC8 phải trừ các lần này khỏi số lần return | (đầu vào BC8.sl_return_thamdinh) |
| 12 | IS_EXCLUDED_KPI | DIM_LOS_ORG_UNIT | 'Y' nếu COMPANY_CODE thuộc ('VN0010401','VN0010101','VN0010002'). BC9 loại ba đơn vị này khỏi chỉ tiêu số lượng hồ sơ duyệt và giải ngân | (đầu vào BC9.SLHS_RLOS) |
| 13 | IS_FTR_VIOLATION | DIM_LOS_EXCEPTION_REASON | 'Y' nếu EXCEPTION_CODE chứa hậu tố 'FTR'. Mã dạng UW-BR-FTR nghĩa là bước UnderwriterMaker chuyển hồ sơ về BranchSupport và điều kiện trả về này thuộc danh mục vi phạm First Time Right. Đưa quy tắc CHECK_FTR của BC7 về dữ liệu | (đầu vào BC7.CHECK_FTR) |
| 14 | IS_RESTRUCTURE | DIM_LOS_CHANGE_TYPE | 'Y' nếu CHANGE_TYPE_NAME thuộc ('Cơ cấu nợ thế chấp','Cơ cấu nợ tín chấp'). BC5 xếp nhóm này vào 'Phương án cơ cấu nợ', các loại thay đổi còn lại vào 'Phương án thay đổi điều kiện phê duyệt' | (đầu vào BC5.REF_PRODUCT) |
| 15 | IS_LAST_EVENT | FCT_LOS_WORKSTEP_EVENT | 'Y' cho sự kiện HOÀN TẤT gần nhất sau hai bước: chọn phiên bản mới nhất của từng logical event (WI_NAME, WORKSTEP_CODE, ENTRYDATE) theo DAYID; lọc EXITDATE IS NOT NULL rồi xếp EXITDATE DESC, ENTRYDATE DESC. Event mới nhất nhưng đang mở không được lấy làm LAST_*. | (đầu vào nhóm LAST_* của BC1, BC2) |
| 16 | IS_RETURN_EVENT | FCT_LOS_WORKSTEP_EVENT | 'Y' nếu DECISION_CODE thuộc nhóm trả về (DIM_LOS_DECISION.IS_RETURN = 'Y') | (đầu vào BC7.FIRST_WORKSTEP_RETURN; BC8.sl_return_*) |
| 17 | IS_APPROVAL_EVENT | FCT_LOS_WORKSTEP_EVENT | 'Y' nếu WORKSTEP_CODE thuộc ('CreditApproval','CreditCommittee'), EXITDATE khác NULL và (DIM_LOS_DECISION.IS_APPROVED='Y' hoặc IS_REJECT='Y'). Đây là nhóm terminal approval hợp lệ dùng LAST_APPROVAL_DATE/ưu tiên 1. | (điều kiện lọc BC3; đầu vào LAST_APPROVAL_DATE) |
| 18 | IS_FTR_BREAK | FCT_LOS_EXCEPTION | 'Y' nếu RCTYPE='Raise' và lý do thuộc danh mục vi phạm First Time Right (DIM_LOS_EXCEPTION_REASON.IS_FTR_VIOLATION='Y'). Gộp quy tắc mà CLOS và RLOS đang viết khác nhau về một định nghĩa; là căn cứ cho trường CHECK_FTR của BC7 | (đầu vào BC7.CHECK_FTR) |
| 19 | IS_DRAFT_SEND | FCT_LOS_EXCEPTION | 'Y' nếu EXCEPTION_NAME hoặc EXCEPTION_CATEGORY thuộc nhóm gửi dự thảo ('Gửi dự thảo đề xuất cho chi nhánh', 'UW-BR-FTR: Gửi dự thảo phê duyệt TD', 'CK-BR: Gửi dự thảo về ĐVKD'). BC8 phải trừ các lần này khỏi số lần return tại chốt thẩm định | (đầu vào BC8.sl_return_thamdinh) |
| 20 | IS_PRIMARY_ID | FCT_LOS_PARTY_DOCUMENT | 'Y' nếu ID_TYPE thuộc ('TCC','CC'), 'N' nếu khác. Đúng bằng điều kiện SRS ghi cho BC1: ADD_ID lấy ID_TYPE in ('TCC','CC'), ADD_ID_OTHER lấy not in. Tính sẵn ở DWH để tầng datamart chỉ việc LISTAGG theo cờ này thay vì lặp lại điều kiện ở mọi báo cáo | (tách nhóm TCC/CC khỏi giấy tờ khác cho BC1) |
| 21 | CURR_FULL_ADDRESS | FCT_LOS_APPLICATION_PARTY | CURR_HOUSE_NO \|\| ', ' \|\| CURR_WARD \|\| ', ' \|\| DISTRICT_NAME \|\| ', ' \|\| CITY_NAME, trong đó tên quận/huyện và tỉnh/thành lấy qua GEO_SK. Trường CURRENT_RESIDENTIAL_ADDRESS của BC1 | BC1.CURRENT_RESIDENTIAL_ADDRESS |
| 22 | EXCEPTION_CODE | FCT_LOS_EXCEPTION | REGEXP_SUBSTR(EXCEPTION_CATEGORY, '^[^:]+') khi chuỗi có dấu hai chấm, NULL khi không có. Trường EXCEPTION_CODE của BC7 | BC7.EXCEPTION_CODE |

### 3.2 Bốn rule phê duyệt khác nhau — khác là có chủ ý, theo SRS từng báo cáo

Bốn chỗ dùng bốn định nghĩa "phê duyệt" khác nhau. Đây **không phải mâu
thuẫn**: mỗi cái chép đúng rule SRS của báo cáo đó. Ghi lại một chỗ để không
ai gộp nhầm thành một công thức chung.

| # | Chọn bản ghi nào | WORKSTEP | DECISION | Cột trong model |
|---|---------------------|----------|----------|-------------------|
| 1 | MAX(EXITDATE) — lần CUỐI | CreditApproval, CreditCommittee | Submit, Send To HOSupport, Send To PostSanction, Reject, Submit To DisbursementMaker (5 — CÓ Reject) | FCT_LOS_APPLICATION_DAILY.LAST_APPROVAL_DATE |
| 2 | EXITDATE mới nhất — lần CUỐI | CreditApprovalReview, CreditApproval, CreditCommittee (3 — THÊM CreditApprovalReview) | Submit, Send To HOSupport, Send To PostSanction, Submit To DisbursementMaker (4 — KHÔNG Reject) | Không có cột riêng. Tính ở DTM từ FCT_LOS_WORKSTEP_EVENT vì chỉ là lọc trên bảng sự kiện |
| 3 | EXITDATE của lần ĐẦU theo ENTRYDATE tăng dần, và của HỒ SƠ CHA trong cùng LOANCASEID | CreditApproval, CreditCommittee | Submit, Send To HOSupport, Send To PostSanction (3) + USERNAME IS NOT NULL | DIM_LOS_APPLICATION.FIRST_APPROVED_WI_NAME và FIRST_APPROVED_DATE |
| 4 | Có tồn tại ít nhất một sự kiện thỏa | CreditApproval, CreditCommittee | Submit, Send To HOSupport, Send To PostSanction, Submit To DisbursementMaker (4 — KHÔNG Reject, vì Reject là 'Rejected') | FCT_LOS_APPLICATION_DAILY.BI_APPSTATUS |
