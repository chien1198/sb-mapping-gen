# Slide thiết kế Datamart PDTD (LOS → SB_DWH → PDTD_DTM)
> Nội dung dưới đây viết theo văn phong sẽ trình bày trực tiếp trên slide.

---

## I) Khung nội dung chính

1. Mục tiêu & phạm vi buổi review
2. Giới thiệu về nghiệp vụ
3. Giới thiệu về dữ liệu LOS, cơ chế ghi từ app xuống Database
4. Tìm hiểu về thiết kế hiện tại trên SB_DWH (bộ bảng dim/fact)
5. Trình bày ý tưởng thiết kế
   - Quyết định thiết kế dimension
   - Quyết định thiết kế fact
   - Bảng mô tả báo cáo sử dụng từng bảng tầng PDTD_DTM
6. Thiết kế database chi tiết từng bảng

---

## II) Nội dung chi tiết

### 1) Mục tiêu & phạm vi buổi review

> **Mục tiêu buổi trình bày:**
> - Giới thiệu thiết kế datamart PDTD hiện tại (LOS → SB_DWH → PDTD_DTM) tới các chuyên gia/đối tác review
> - Tiếp nhận góp ý về mức độ phù hợp của thiết kế với hệ thống hiện tại và các điểm cần điều chỉnh (nếu có)
> - Thống nhất phê duyệt để chuyển sang giai đoạn phát triển

---

### 2) Giới thiệu về nghiệp vụ

**Bối cảnh**: Khối PDTD (Phê Duyệt Tín Dụng) cần báo cáo vận hành/KPI cho hồ sơ tín dụng chạy trên 2 hệ nguồn song song — **CLOS** (khách hàng doanh nghiệp/tổ chức) và **RLOS** (khách hàng cá nhân/bán lẻ). Hai hệ dùng chung 1 workflow engine nhưng khác bộ trường, khác cách đặt tên bước xử lý.

**Các nhóm câu hỏi nghiệp vụ cần trả lời**:
- Hồ sơ đang ở đâu, tồn đọng bao lâu, ai đang xử lý, thông tin khách hàng/người liên quan là gì? (Báo cáo BC1, BC2, BC4)
- Hồ sơ được phê duyệt (đồng ý/từ chối) với kết quả, hạn mức, tài sản bảo đảm như thế nào? (Báo cáo BC3)
- Có bao nhiêu ngoại lệ chính sách, hồ sơ bị trả về bao nhiêu lần? (Báo cáo BC6, BC7, BC8)
- SLA từng bước có đạt cam kết không? (Báo cáo BC5)
- Các chỉ tiêu KPI của Khối PDTD đạt được ra sao? (Báo cáo BC9)
- Hồ sơ sau phê duyệt có thực sự giải ngân, dư nợ ra sao? (Báo cáo BC10, BC11)

**Vòng đời một hồ sơ tín dụng — 4 bước chính**:
1. **B1 — ĐVKD / Cụm HTTD / Vận hành tỉnh**: khởi tạo và nhập liệu hồ sơ tại đơn vị kinh doanh
2. **B2 — Phê duyệt tín dụng**: thẩm định và ra quyết định phê duyệt
3. **B3 — Xử lý tín dụng**: hoàn thiện hồ sơ, giải ngân
4. **B4 — Giám sát sau giải ngân**: theo dõi khoản vay sau khi đã giải ngân

Chi tiết từng bước, từng luồng xử lý cụ thể tham khảo sơ đồ luồng riêng.

---

### 3) Giới thiệu về dữ liệu LOS, cơ chế ghi từ app xuống database

Hiện tại toàn bộ bảng trên database LOS đều có chung một cơ chế ghi dữ liệu:

| Thao tác | Cơ chế |
|---|---|
| **Insert** | Ghi bản ghi mới vào database khi có phát sinh |
| **Update** | 2 bước: (1) Xoá dữ liệu liên quan tới hồ sơ được điều chỉnh trong bảng tương ứng; (2) Ghi dữ liệu mới vào bảng |
| **Delete** | Xoá dữ liệu khi có hành động xoá trên giao diện |

Bước từ DB LOS về `STG_LOS` của DWH dùng **CDC qua Oracle GoldenGate**, đọc trực tiếp **redo log** — GoldenGate bắt được **cả sự kiện DELETE lẫn INSERT** như 2 bản ghi log riêng biệt, theo đúng thứ tự transaction đã xảy ra ở nguồn.

DB nguồn LOS (transactional) chỉ giữ **trạng thái hiện tại** — record cũ bị xoá thật, không truy vấn lại được trực tiếp trên LOS. Nhờ GoldenGate đọc redo log ở tầng CDC, cặp sự kiện (DELETE cũ + INSERT mới) vẫn được capture đầy đủ trước khi tới `STG_LOS` — đây chính là nguyên liệu để tầng DWH/DTM dựng lại lịch sử qua SCD Type 2 (`EFF_DATE`/`EXP_DATE`). Lịch sử không tồn tại trên DB nguồn, nhưng được bảo toàn nhờ CDC ở redo-log level, và được vật chất hoá thành version trong DIM ở tầng DWH.

Sequence: `App UI` → `LOS DB (transactional, Insert/Update=Del+Ins/Delete)` → `GoldenGate CDC (đọc redo log)` → `STG_LOS` → `SB_DWH (SCD2, batch theo DAYID)` → `PDTD_DTM`.

---

### 4) Tìm hiểu thiết kế hiện tại trên SB_DWH

#### Bảng DIM

| Thành phần | Mô tả |
|---|---|
| `DIMENSION_KEY` | Sequence key, số tự tăng, làm khóa chính (PK) của bảng DIM |
| `<object>_SK` | Cũng là sequence key tương tự `DIMENSION_KEY`. Một số bảng DIM có nhiều level đối tượng, mỗi level có sequence key riêng — vd `DIM_COMPANY`: `REGION_SK > CITY_SK > DISTRICT_SK > BRANCH_SK` |
| `TOTAL` / `TOTAL_NAME` | Giá trị cố định `'TOTAL'` |
| `TOTAL_SK` | Giá trị mặc định cố định theo bảng: `-2` (`DIM_ACCOUNT`) hoặc `-1` (`DIM_LOAN`) |
| `EFF_DATE` / `EXP_DATE` | Ngày hiệu lực bản ghi — còn hiệu lực khi `EXP_DATE IS NULL`. Phục vụ xử lý SCD-2 |
| `INPUTER / DATE_TIME_INPUT / AUTHORISER / DATE_TIME_AUTHORISE` | Nhóm cột maker-checker, xuất hiện ở khá nhiều DIM |
| Cột thuộc tính | Thông tin mô tả gắn với từng đối tượng của DIM |

Ví dụ minh hoạ — `DIM_PDTD_ORG_UNIT` (1 dòng = 1 đơn vị kinh doanh):
- Khóa: `DIMENSION_KEY` (PK, giữ nguyên từ DWH, không sinh sequence mới)
- `<object>_SK`: `ORG_UNIT_SK` — mặc định `-1` nếu không có giá trị phù hợp
- Cột thuộc tính: `COMPANY_CODE, COMPANY_NAME, BRANCH_CODE, BRANCH_NAME, ZONE_NAME_LOS`
- `EFF_DATE / EXP_DATE`: quản lý version theo SCD-2

#### Bảng FACT

| Thành phần | Mô tả |
|---|---|
| `DAYID` | Ngày dữ liệu — grain theo ngày (snapshot), không phải theo giao dịch |
| `DATASOURCE` | Nguồn dữ liệu: `RLOS` / `CLOS` |
| `<object>_SK` | Toàn bộ các cột dạng `%_SK` là FK trỏ tới các bảng DIM tương ứng |
| Measure | Các cột đo lường / số liệu tổng hợp |
| Cột khai thác khác | Phục vụ mục đích truy vấn/báo cáo bổ sung |

Ví dụ minh hoạ — `FCT_PDTD_APPLICATION_DAILY` (bảng nền, 1 dòng = 1 hồ sơ × 1 ngày dữ liệu):
- Khóa: `DAYID + WI_NAME` (PK)
- FK: `APPLICATION_SK, ORG_UNIT_SK, PRODUCT_SK, APPROVAL_GROUP_SK, CHANGE_TYPE_SK, CARD_PROMOTION_SK, CUSTOMER_SK, LAST_WORKSTEP_SK, CURRENT_WORKSTEP_SK, LAST_DECISION_SK, LAST_USER_SK` — 11 chiều cho 1 fact, điển hình star-schema.
- Measure/snapshot: `LOAN_AMOUNT, INTEREST_RATE, DEVIATION_CNT, INACTIVE_DAY_CNT, KPI_VOLUME`...
- Cột khai thác: `BI_APPSTATUS, BI_FLOW` — trạng thái/luồng đã chuẩn hóa sẵn để BI không phải viết CASE WHEN phức tạp lại từ đầu mỗi lần.

Fact này là **daily snapshot fact** (grain = 1 hồ sơ × 1 ngày), không phải transaction fact (grain = 1 lần xử lý). Lý do:

1. DB nguồn (transactional) chỉ trả lời được "hồ sơ này đang ở đâu ngay bây giờ". Khi hồ sơ tiếp tục đi bước hoặc đóng lại, bản ghi ở bước cũ bị xoá thật theo cơ chế Update = Delete+Insert — nên không còn cách nào truy vấn ngược lại "ngày 15/8, hồ sơ này đang ở bước nào" một khi nó đã đi qua ngày đó.
2. Vì vậy, câu hỏi "cuối ngày 15/8 có bao nhiêu hồ sơ tồn đọng, đang treo ở bước nào" không thể trả lời bằng cách query lại DB nguồn tại thời điểm hiện tại — dữ liệu hiện trạng của ngày đó không còn tồn tại ở đâu nữa.
3. `FCT_PDTD_APPLICATION_DAILY` chủ động chụp và lưu lại 1 dòng cho mỗi hồ sơ vào đúng cuối mỗi DAYID, theo 2 lý do sinh dòng phục vụ 2 nhóm báo cáo khác nhau:
   - **Có phát sinh xử lý trong ngày** (`HAS_ACTION_IN_DAY = 'Y'`) — đây là điều kiện phạm vi cho **BC1, BC2** và các báo cáo chỉ lấy hồ sơ phát sinh trong ngày.
   - **Hồ sơ đang trong chu kỳ thẩm định chưa chốt** tại cuối ngày D (dù không có action trong ngày) — dòng này chỉ được sinh để duy trì tập tồn đọng phục vụ **BC4**.
4. Đánh đổi: dung lượng phình theo (số ngày × số hồ sơ), cần chiến lược partition theo `DAYID` và archive/purge dữ liệu cũ.

---

### 5) Ý tưởng thiết kế

#### 5.0) Tổng quan mô hình 3 tầng

Sơ đồ: LOS (nguồn giao dịch, 2 hệ CLOS/RLOS) → SB_DWH (kho chuẩn hóa toàn hàng) → PDTD_DTM (datamart chuyên đề Khối PDTD). *[Ảnh sơ đồ tổng quan — placeholder, sẽ cập nhật]*

#### 5.1) Quyết định thiết kế Dimension

**Cách suy luận thiết kế**: xuất phát từ (các) bảng nguồn trên LOS cùng mô tả 1 đối tượng nghiệp vụ → hợp nhất thành 1 chiều duy nhất ở tầng SB_DWH (`DIM_LOS_*`) → xem thuộc tính chính có phải loại tương đối ổn định, dùng để phân loại/gắn nhãn hay không → nếu đúng, kết luận tạo DIM, và PDTD_DTM bê nguyên 1-1 từ DIM_LOS tương ứng.

| Bảng nguồn LOS (ý nghĩa) | Đối tượng mô tả | Thuộc tính chính | DIM tầng SB_DWH | DIM tầng PDTD_DTM |
|---|---|---|---|---|
| CLOS: `NG_SB_CLOS_CUST_INFO` (thông tin tổng quan hồ sơ: sản phẩm vay, khách hàng, đơn vị xử lý)<br>RLOS: `NG_SB_RLOS_APPLICANT_GENERAL` (thông tin chung hồ sơ: sản phẩm đăng ký, chi nhánh phụ trách), `NG_SB_RLOS_SUB_PRODUCT` (sản phẩm phụ: thẻ tín dụng, SeAFast, SeABuy...) | Sản phẩm tín dụng | Mã/tên dòng sản phẩm, sản phẩm nhánh, cờ phân loại | `DIM_LOS_PRODUCT` | → `DIM_PDTD_PRODUCT` |
| CLOS: `NG_SB_CLOS_APPROVAL` (luồng/cấp phê duyệt định trước theo hạn mức: A1, A2, B1, B2, BOD, C1, SCC...)<br>RLOS: `NG_SB_RLOS_APPROVAL` (nhóm/luồng phê duyệt, CVTĐ chọn tại bước Thẩm định theo hồ sơ rủi ro) | Cấp thẩm quyền phê duyệt | Mã cấp, thứ tự cấp | `DIM_LOS_APPROVAL_GROUP` | → `DIM_PDTD_APPROVAL_GROUP` |
| CLOS: `NG_SB_CLOS_ENTRY_EXIT` (lịch sử xử lý hồ sơ theo từng bước: người thực hiện, thời gian, quyết định)<br>RLOS: `NG_SB_RLOS_ENTRY_EXIT` (tương đương, bảng giao dịch dùng nhiều nhất, nguồn chính tính SLA/TAT) | Quyết định tại bước xử lý | Mã quyết định, nhóm quyết định | `DIM_LOS_DECISION` | → `DIM_PDTD_DECISION` |
| CLOS: `NG_SB_CLOS_CHANGEREQ` (yêu cầu thay đổi hạn mức/điều kiện tín dụng với hồ sơ đã tồn tại) | Loại thay đổi điều kiện phê duyệt | Mã/tên loại và chi tiết loại thay đổi | `DIM_LOS_CHANGE_TYPE` | → `DIM_PDTD_CHANGE_TYPE` |
| CLOS: `NG_SB_CLOS_COLL_CD` (tài sản đảm bảo, 11 loại đặc thù cho vay doanh nghiệp)<br>RLOS: `NG_SB_RLOS_COL_REALESTATE` (bất động sản), `NG_SB_RLOS_COL_TRANSPORT` (phương tiện vận tải), `NG_SB_RLOS_COL_VALPAPER` (giấy tờ có giá), `NG_SB_RLOS_COL_OTHER` (tài sản khác) — 4 bảng tài sản bảo đảm theo loại | Loại tài sản bảo đảm | Mã loại TSBĐ, nhóm chuẩn hóa chung 2 hệ | `DIM_LOS_COLLATERAL_TYPE` | → `DIM_PDTD_COLLATERAL_TYPE` |
| CLOS: `NG_SB_CLOS_MAS_EXCEPTION` (danh mục master ngoại lệ: tổ hợp bước + quyết định + loại ngoại lệ được phép)<br>RLOS: tương đương *(chưa có trong metadata đã review, cần xác nhận thêm)* | Lý do ngoại lệ chính sách | Tổ hợp bước + quyết định + loại lý do | `DIM_LOS_EXCEPTION_REASON` | → `DIM_PDTD_EXCEPTION_REASON` |
| RLOS: `H_NG_SB_RLOS_MAS_CITY` (danh mục tỉnh/thành MDM, 63 bản ghi), `H_NG_SB_RLOS_MAS_DISTRICT` (danh mục quận/huyện MDM, 710 bản ghi) — dùng chung cho cả 2 hệ | Địa bàn hành chính | Mã/tên tỉnh thành, quận huyện | `DIM_LOS_GEO` | → `DIM_PDTD_GEO` |
| CLOS: `NG_SB_CLOS_CUST_INFO`, RLOS: `NG_SB_RLOS_APPLICANT_GENERAL` — 2 bảng thông tin hồ sơ "wide table" (mỗi bảng phục vụ nhiều DIM khác nhau tùy nhóm cột); ở đây chỉ lấy đúng nhóm cột `COMPANY_CODE/COMPANY_NAME` (mã/tên đơn vị kinh doanh), `BRANCH_CODE/BRANCH_NAME` (mã/tên chi nhánh), `ZONE`/`ZONEE` (khu vực) — **không phải nhóm cột thông tin khách hàng** trên cùng 2 bảng đó | Đơn vị kinh doanh | Mã/tên đơn vị, chi nhánh, khu vực | `DIM_LOS_ORG_UNIT` | → `DIM_PDTD_ORG_UNIT` |
| RLOS Online: `CARD_INFOMATION` (phát hành/gia hạn thẻ qua kênh trực tuyến, kèm chương trình khuyến mãi/miễn phí thường niên) | Chương trình ưu đãi phí thẻ | Mã/mô tả chương trình | `DIM_LOS_CARD_PROMOTION` | → `DIM_PDTD_CARD_PROMOTION` |
| CLOS: `NG_SB_CLOS_ENTRY_EXIT`, RLOS: `NG_SB_RLOS_ENTRY_EXIT` (mã bước tại mỗi lần vào/ra), `WFINSTRUMENTTABLE` (trạng thái tức thời mọi workflow instance BPM, dùng chung mọi luồng, phân biệt bằng `PROCESSNAME`) | Bước xử lý trên workflow | Mã bước, giai đoạn, thứ tự | `DIM_LOS_WORKSTEP` | → `DIM_PDTD_WORKSTEP` |
| CLOS: `NG_SB_CLOS_ENTRY_EXIT`, RLOS: `NG_SB_RLOS_ENTRY_EXIT` — mang theo username người thực hiện tại mỗi bước | Tài khoản cán bộ xử lý | Username | `DIM_LOS_USER` | → `DIM_PDTD_USER` |
| Sử dụng thông tin khách hàng T24 từ `SB_DWH.DIM_CUSTOMER`, nối sang hồ sơ LOS qua số giấy tờ định danh để xác định cùng 1 khách hàng | Khách hàng | Mã CIF, giấy tờ định danh (LOS lookup sang T24), tên, ngày sinh, giới tính, phân khúc | `DIM_CUSTOMER` | → `DIM_PDTD_CUSTOMER` |
| CLOS: `NG_SB_CLOS_CUST_INFO`, `NG_SB_CLOS_APPROVAL`, `NG_SB_CLOS_EXTTABLE`, `NG_SB_CLOS_CHANGEREQ`<br>RLOS: `NG_SB_RLOS_APPLICANT_GENERAL`, `NG_SB_RLOS_APPLICANT_DETAIL`, `NG_SB_RLOS_APPROVAL`, `NG_SB_RLOS_EXTTABLE` — tập hợp tất cả thông tin tổng quát của hồ sơ | Hồ sơ tín dụng | Luồng nghiệp vụ, phân khúc, chính sách, ngày khởi tạo, cán bộ quản lý | `DIM_LOS_APPLICATION` | → `DIM_PDTD_APPLICATION` |

#### 5.2) Quyết định thiết kế Fact

**Cách suy luận thiết kế**: xuất phát từ (các) bảng nguồn trên LOS cùng mô tả 1 đối tượng nghiệp vụ phát sinh theo giao dịch/thời gian → hợp nhất thành 1 fact duy nhất ở tầng SB_DWH (`FCT_LOS_*`) → xem grain có ổn định, có phải chốt lại thành "1 dòng = ?" rõ ràng hay không → nếu đúng, kết luận tạo FACT, và PDTD_DTM bê nguyên 1-1 từ FCT_LOS tương ứng.

| Bảng nguồn LOS (ý nghĩa) | Đối tượng mô tả | Grain / thuộc tính chính | FACT tầng SB_DWH | FACT tầng PDTD_DTM |
|---|---|---|---|---|
| CLOS: `NG_SB_CLOS_ENTRY_EXIT` (lịch sử xử lý theo bước), `NG_SB_CLOS_CREDITINFO_CD` (hạn mức tín dụng — 4 thuộc tính cơ bản: mục đích, kỳ hạn, loại tiền), `NG_SB_CLOS_CREDITINFO_COMM` (hạn mức tín dụng — bản mở rộng nhiều thuộc tính hơn: cờ TSBĐ, cờ hạn mức đặc biệt, hạn mức con)<br>RLOS: `NG_SB_RLOS_ENTRY_EXIT` (lịch sử xử lý theo bước), `NG_SB_RLOS_CREDIT_PROPOSAL` (đề xuất tín dụng: số tiền, kỳ hạn, lãi suất, phương thức trả nợ), `NG_SB_RLOS_CREDIT_PROPOSAL_APP` (đề xuất tín dụng — bản mở rộng chi tiết hơn: LTV), `NG_SB_RLOS_REPAY_CALC` (tính năng lực trả nợ DTI), `NG_SB_RLOS_REPAYFLAGS` (cờ chọn nguồn thu)<br>Dùng chung: `WFINSTRUMENTTABLE` (trạng thái hiện tại của mọi hồ sơ trên engine BPM LOS — hồ sơ đang ở bước nào, ai đang phụ trách; dùng chung cho mọi luồng CLOS/RLOS, phân biệt bằng cột `PROCESSNAME`) | Trạng thái hồ sơ cuối mỗi ngày | 1 hồ sơ × 1 ngày dữ liệu, sinh khi có action hoặc còn backlog | `FCT_LOS_APPLICATION_DAILY` | → `FCT_PDTD_APPLICATION_DAILY` |
| CLOS: `NG_SB_CLOS_ENTRY_EXIT`<br>RLOS: `NG_SB_RLOS_ENTRY_EXIT`<br>Nhật ký workflow mức nguyên tử, giữ hết mọi sự kiện, không xóa/không chép lại mỗi ngày | Mỗi lần hồ sơ vào 1 bước xử lý | 1 phiên bản của 1 logical event (hồ sơ × bước × lần vào bước) | `FCT_LOS_WORKSTEP_EVENT` | → `FCT_PDTD_WORKSTEP_EVENT` |
| CLOS: `NG_SB_CLOS_ENTRY_EXIT`<br>RLOS: `NG_SB_RLOS_ENTRY_EXIT`<br> | Thời gian xử lý lũy kế theo workstep/nhóm xử lý | 1 hồ sơ × 1 ngày có action | `FCT_LOS_SLA_DAILY` | → `FCT_PDTD_SLA_DAILY` |
| CLOS: `NG_SB_CLOS_CUST_INFO`, `NG_SB_CLOS_CUST_INFO_LEGAL` (người/đối tượng liên quan pháp lý)<br>RLOS: `NG_SB_RLOS_APPLICANT_GENERAL`, `NG_SB_RLOS_COREPAYER_GENERAL` (thông tin nhân thân người đồng trả nợ) | Người liên quan tới hồ sơ (vay chính, đồng trả nợ...) | 1 người liên quan × 1 hồ sơ, ảnh chụp theo DAYID | `FCT_LOS_APPLICATION_PARTY` | → `FCT_PDTD_APPLICATION_PARTY` |
| RLOS: `NG_SB_RLOS_APPLICANT_IDGRID` (giấy tờ người vay chính), `NG_SB_RLOS_COREP_IDGRID` (giấy tờ người đồng trả nợ)<br>CLOS: `NG_SB_CLOS_CUST_INFO_LEGAL` | Giấy tờ tùy thân của người liên quan | 1 giấy tờ × 1 người × 1 hồ sơ, ảnh chụp theo DAYID | `FCT_LOS_PARTY_DOCUMENT` | → `FCT_PDTD_PARTY_DOCUMENT` |
| CLOS: `NG_SB_CLOS_COLL_CD` (tài sản đảm bảo CLOS)<br>RLOS: `NG_SB_RLOS_COL_REALESTATE` (bất động sản), `NG_SB_RLOS_COL_TRANSPORT` (phương tiện vận tải), `NG_SB_RLOS_COL_VALPAPER` (giấy tờ có giá), `NG_SB_RLOS_COL_OTHER` (tài sản khác) | Tài sản bảo đảm của hồ sơ | 1 tài sản × 1 hồ sơ, ảnh chụp theo DAYID | `FCT_LOS_COLLATERAL` | → `FCT_PDTD_COLLATERAL` |
| CLOS: `NG_SB_CLOS_CONDITON_CDGRID` (điều kiện phê duyệt/độ lệch so với chính sách chuẩn)<br>RLOS: `NG_SB_RLOS_MANUAL_DEVIATION` (trường hợp lệch chính sách và kết quả xét duyệt ngoại lệ) | Ngoại lệ chính sách trên hồ sơ | 1 ngoại lệ chính sách × 1 hồ sơ, ảnh chụp theo DAYID | `FCT_LOS_DEVIATION` | → `FCT_PDTD_DEVIATION` |
| CLOS: `NG_SB_CLOS_EXCEPTION` (log ngoại lệ phát sinh thực tế, khác bảng danh mục `MAS_EXCEPTION`)<br>RLOS: `NG_SB_RLOS_EXCEPTION` (hồ sơ bị đánh dấu có vấn đề, cơ chế Raise/Clear) | Lần ghi nhận lý do khi hồ sơ chuyển bước/trả về/yêu cầu bổ sung | 1 lần ghi nhận lý do × 1 hồ sơ, ảnh chụp theo DAYID | `FCT_LOS_EXCEPTION` | → `FCT_PDTD_EXCEPTION` |
| RLOS: `NG_SB_RLOS_SUB_PRODUCT` (sản phẩm phụ đăng ký), `NG_SB_RLOS_CREDIT_CARD_APP` (chi tiết thẻ tín dụng phụ), `NG_SB_RLOS_SEABUY_APP` (chi tiết SeABuy), `NG_SB_RLOS_CIVIL_APP` (chi tiết SeACivil), `NG_SB_RLOS_TEACHER_APP` (chi tiết SeATeacher), `NG_SB_RLOS_WOMAN_APP` (chi tiết SeAWoman), `NG_SB_RLOS_SENT_CBS_LOG` (log gửi T24) | Sản phẩm phụ đăng ký kèm hồ sơ | 1 occurrence sản phẩm phụ, ảnh chụp theo DAYID | `FCT_LOS_SUB_PRODUCT` | → `FCT_PDTD_SUB_PRODUCT` |
| Nguồn ngoài LOS — core T24: `SB_DWH.FCT_LOAN` (khoản vay đã giải ngân: số tiền, dư nợ, số ngày quá hạn), `SB_DWH.DIM_LOAN` (ngày giải ngân, ngày đáo hạn, trạng thái hợp đồng), `SB_DWH.DIM_COMPANY`, `SB_DWH.DIM_SEAB_PRODUCTS_DE` (sản phẩm T24), bổ sung thêm bảng map `TMP_REF_COMPANY_REGION_KHCN`/`KHDN` (quy vùng miền) và tra `DIM_PDTD_APPLICATION` để nối về hồ sơ LOS qua `SEAB_LOS_ID` | Khoản vay đã giải ngân | 1 hợp đồng khoản vay × 1 ngày dữ liệu (khác grain hồ sơ — 1 hồ sơ duyệt có thể sinh nhiều hợp đồng) | `FCT_LOAN` | → `FCT_PDTD_DISBURSEMENT` |
| Tính từ `FCT_PDTD_APPLICATION_DAILY` + các bảng SLA cam kết | Chỉ tiêu KPI tính riêng ở tầng DTM (khối lượng, luỹ kế theo ngày/năm) | 1 hồ sơ × 1 ngày; 1 username × 1 năm; 1 ngày × toàn Khối | *(đây là các fact tổng hợp từ PDTD_DTM)* | → `FCT_PDTD_KPI_APPLICATION`, `FCT_PDTD_KPI_USER_YEAR`, `FCT_PDTD_KPI_YTD_DAILY` |
| Tính từ `FCT_PDTD_APPLICATION_DAILY` (mốc phê duyệt lần đầu) + `FCT_PDTD_DISBURSEMENT` | Mốc hồ sơ đạt được lần đầu (phê duyệt, giải ngân) | 1 hồ sơ × 1 loại mốc, chỉ ghi khi đạt mốc lần đầu — tránh đếm trùng khi hồ sơ qua duyệt/giải ngân nhiều lần | *(đây là các fact tổng hợp từ PDTD_DTM)* | → `FCT_PDTD_APPLICATION_MILESTONE` |

#### 5.3) Bảng mô tả báo cáo sử dụng từng bảng tầng PDTD_DTM

| Báo cáo | Bảng PDTD_DTM sử dụng |
|---|---|
| BC1 | `FCT_PDTD_APPLICATION_DAILY`<br>`FCT_PDTD_APPLICATION_PARTY`<br>`FCT_PDTD_COLLATERAL`<br>`FCT_PDTD_PARTY_DOCUMENT`<br>`FCT_PDTD_SUB_PRODUCT`<br>`DIM_PDTD_APPLICATION`<br>`DIM_PDTD_APPROVAL_GROUP`<br>`DIM_PDTD_CARD_PROMOTION`<br>`DIM_PDTD_CHANGE_TYPE`<br>`DIM_PDTD_COLLATERAL_TYPE`<br>`DIM_PDTD_CUSTOMER`<br>`DIM_PDTD_DECISION`<br>`DIM_PDTD_GEO`<br>`DIM_PDTD_ORG_UNIT`<br>`DIM_PDTD_PRODUCT`<br>`DIM_PDTD_USER`<br>`DIM_PDTD_WORKSTEP` |
| BC2 | `FCT_PDTD_APPLICATION_DAILY`<br>`FCT_PDTD_APPLICATION_PARTY`<br>`FCT_PDTD_PARTY_DOCUMENT`<br>`DIM_PDTD_APPLICATION`<br>`DIM_PDTD_APPROVAL_GROUP`<br>`DIM_PDTD_CHANGE_TYPE`<br>`DIM_PDTD_COLLATERAL_TYPE`<br>`DIM_PDTD_CUSTOMER`<br>`DIM_PDTD_DECISION`<br>`DIM_PDTD_ORG_UNIT`<br>`DIM_PDTD_PRODUCT`<br>`DIM_PDTD_USER`<br>`DIM_PDTD_WORKSTEP` |
| BC3 | `FCT_PDTD_COLLATERAL`<br>`FCT_PDTD_WORKSTEP_EVENT`<br>`DIM_PDTD_APPLICATION`<br>`DIM_PDTD_COLLATERAL_TYPE`<br>`DIM_PDTD_DECISION`<br>`DIM_PDTD_USER`<br>`DIM_PDTD_WORKSTEP` |
| BC4 | `FCT_PDTD_APPLICATION_DAILY`<br>`FCT_PDTD_WORKSTEP_EVENT`<br>`DIM_PDTD_APPLICATION`<br>`DIM_DATE`<br>`DIM_PDTD_DECISION`<br>`DIM_PDTD_USER`<br>`DIM_PDTD_WORKSTEP` |
| BC5 | `FCT_PDTD_APPLICATION_DAILY`<br>`FCT_PDTD_SLA_DAILY`<br>`FCT_PDTD_SUB_PRODUCT`<br>`DIM_PDTD_APPLICATION`<br>`DIM_PDTD_APPROVAL_GROUP`<br>`DIM_PDTD_CHANGE_TYPE`<br>`DIM_PDTD_PRODUCT`<br>`DIM_PDTD_WORKSTEP` |
| BC6 | `FCT_PDTD_APPLICATION_DAILY`<br>`FCT_PDTD_DEVIATION`<br>`DIM_PDTD_APPLICATION` |
| BC7 | `FCT_PDTD_APPLICATION_DAILY`<br>`FCT_PDTD_EXCEPTION`<br>`DIM_PDTD_APPLICATION`<br>`DIM_PDTD_DECISION`<br>`DIM_PDTD_EXCEPTION_REASON`<br>`DIM_PDTD_USER`<br>`DIM_PDTD_WORKSTEP` |
| BC8 | `FCT_PDTD_APPLICATION_DAILY`<br>`FCT_PDTD_WORKSTEP_EVENT`<br>`DIM_PDTD_APPLICATION`<br>`DIM_PDTD_DECISION`<br>`DIM_PDTD_USER`<br>`DIM_PDTD_WORKSTEP` |
| BC9 | `FCT_PDTD_APPLICATION_DAILY`<br>`FCT_PDTD_APPLICATION_MILESTONE`<br>`FCT_PDTD_DEVIATION`<br>`FCT_PDTD_KPI_APPLICATION`<br>`FCT_PDTD_KPI_USER_YEAR`<br>`FCT_PDTD_KPI_YTD_DAILY`<br>`FCT_PDTD_SLA_DAILY`<br>`FCT_PDTD_WORKSTEP_EVENT`<br>`DIM_PDTD_APPLICATION`<br>`DIM_PDTD_APPROVAL_GROUP`<br>`DIM_DATE`<br>`DIM_PDTD_DECISION`<br>`DIM_PDTD_ORG_UNIT`<br>`DIM_PDTD_PRODUCT`<br>`DIM_PDTD_USER`<br>`DIM_PDTD_WORKSTEP` |
| BC10 | `FCT_PDTD_DISBURSEMENT`<br>`DIM_PDTD_APPLICATION`<br>`DIM_PDTD_CUSTOMER`<br>`DIM_PDTD_ORG_UNIT` |
| BC11 | `FCT_PDTD_DISBURSEMENT`<br>`DIM_PDTD_APPLICATION`<br>`DIM_PDTD_CUSTOMER`<br>`DIM_PDTD_ORG_UNIT` |

---

### 6) Thiết kế database chi tiết từng bảng, từng phần

#### 6.1) Tổng quan mô hình
- Diagram SB_DWH: https://dbdiagram.io/d/SB_PDTD_DWH-6a9e8e4c50ad2c46dc5c705f
- Diagram PDTD_DTM: https://dbdiagram.io/d/SB_PDTD_DTM-6a9e68565450bea1be086290

#### 6.2) Thiết kế database vùng SB_DWH
Mở tài liệu thiết kế database (docx).

#### 6.3) Thiết kế database vùng PDTD_DTM
Mở tài liệu thiết kế database (docx).

#### 6.4) Thiết kế database bộ bảng MAP (REF)
Mở tài liệu thiết kế database (docx).
