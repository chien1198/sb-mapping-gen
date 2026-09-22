# Đề xuất tách bảng theo nghiệp vụ CLOS/RLOS

**Tài liệu gốc đánh giá:** `input/Design_Database_PDTD_DTM_v1.0_20260908.docx`
**Căn cứ phạm vi sử dụng:** `input/srs_report/BC1..BC11_PDTD_DTM_SRS_v1.0.docx`
**Căn cứ ý nghĩa bảng nguồn:** `input/CLOS - Metadata.xlsx`, `input/RLOS - Metadata.xlsx`
**Căn cứ bộ key nguồn:** `input/DS_BANG_202608.xlsx`
**Ngày đánh giá:** 2026-09-10

## Tiêu chí tách

Tách theo **mặt nghiệp vụ**: CLOS (tín dụng doanh nghiệp/tổ chức) và RLOS (tín dụng
bán lẻ/cá nhân) là hai quy trình nghiệp vụ khác nhau (tài liệu thiết kế gốc cũng mô
tả riêng ở mục "2.1 Quy trình nghiệp vụ CLOS" và "2.2 Quy trình nghiệp vụ RLOS").
Dữ liệu **dùng chung của ngân hàng** (danh mục địa lý, đơn vị kinh doanh, khách hàng
CIF từ T24...) được **giữ gộp** vì không thuộc riêng nghiệp vụ nào.

**Bằng chứng chính dùng để quyết định:**
1. Cột `DATASOURCE` ('RLOS'/'CLOS') có mặt hay không trên từng bảng — bảng có cột
   này đang nạp trộn dữ liệu 2 hệ vào cùng 1 bảng vật lý.
2. Logic ETL/mapping trong SRS: nhiều trường đích phải viết `NG_SB_RLOS_x >
   ...` **hoặc** `NG_SB_CLOS_y > ...` tùy `DATASOURCE` — tức mapping đã rẽ nhánh
   theo hệ ngay trong lúc gộp, không có logic dùng chung thật sự.
3. Phạm vi sử dụng thực tế theo 11 báo cáo SRS: **BC1 = "Báo cáo RLOS APPLICATION"**
   (22 bảng nguồn, toàn bộ là `NG_SB_RLOS_*`, không đụng CLOS), **BC2 = "Báo cáo CLOS
   APPLICATION"** (10 bảng nguồn, toàn bộ `NG_SB_CLOS_*`) — hai báo cáo đầu vào đã
   tách sẵn theo hệ ngay từ khâu đặc tả yêu cầu. Tương tự **BC10 (Giải ngân/Quá hạn
   KHCN)** và **BC11 (...KHDN)** tách theo cá nhân/doanh nghiệp.
4. Một số mô tả cột trong chính tài liệu thiết kế đã ghi nhận thực tế chỉ 1 hệ đang
   dùng (ví dụ `FCT_LOS_SUB_PRODUCT.DATASOURCE`: "hiện các bảng sản phẩm phụ trong
   phạm vi là RLOS").

## Quy ước đặt tên áp dụng

- **Bảng tách theo hệ** (DIM và FCT): đổi tiền tố `LOS`/`PDTD` hiện tại thành
  `CLOS`/`RLOS` — ví dụ `DIM_LOS_APPLICATION` → `DIM_CLOS_APPLICATION` +
  `DIM_RLOS_APPLICATION`; `FCT_LOS_APPLICATION_DAILY` → `FCT_CLOS_APPLICATION_DAILY`
  + `FCT_RLOS_APPLICATION_DAILY`.
- **Tên bảng giống hệt nhau ở cả 2 layer** (SB_DWH và PDTD_DTM) — không còn tiền tố
  `PDTD` để phân biệt layer; hai layer được phân biệt bằng schema/database chứa
  bảng, không phải bằng tên bảng. Khác biệt nội dung giữa 2 layer: bản trên
  `PDTD_DTM` có thêm một số cột map từ 9 bảng `REF_` và dữ liệu T24 phục vụ báo cáo
  (bản trên `SB_DWH` không có các cột này).
- **Bảng dùng chung** (không tách theo hệ): giữ nguyên tiền tố `LOS` ở cả 2 layer
  (bỏ tiền tố `PDTD` trên layer PDTD_DTM, dùng chung tên với bản trên SB_DWH) —
  ví dụ `DIM_LOS_ORG_UNIT` dùng cho cả 2 layer, không có `DIM_PDTD_ORG_UNIT` nữa.
- **Bảng `REF_`:** giữ nguyên tên và cấu trúc theo đúng 9 bảng nguồn tương ứng,
  tạo mới trên layer `PDTD_DTM` (không tồn tại ở SB_DWH).

---

## SB_DWH

### 1. Bộ bảng CHUNG (dữ liệu dùng chung ngân hàng, không phân theo hệ)

**Lưu ý:** tiêu chí "giữ chung" áp dụng đúng cho bảng thực sự KHÔNG gắn với nguồn
dữ liệu của riêng CLOS hay RLOS — không chỉ dựa vào việc bảng có/không cột
`DATASOURCE`. Rà soát lại theo nguồn dữ liệu thực tế: `DIM_LOS_GEO` và
`DIM_LOS_CARD_PROMOTION` tuy không có cột `DATASOURCE` nhưng nguồn dữ liệu
(`NG_SB_RLOS_MAS_CITY/MAS_DISTRICT`, `NG_SB_RLOS_MAS_CARD_PROMOTIO`) đều mang tiền
tố RLOS — nghĩa là 2 bảng này thực chất **thuộc riêng RLOS**, đã chuyển sang mục 3
(Bộ bảng RLOS) thay vì giữ chung.

| Loại | Bảng | Nguyên nhân giữ chung |
| --- | --- | --- |
| DIM | `DIM_LOS_ORG_UNIT` | Không có cột `DATASOURCE`, không gắn với bảng nguồn CLOS/RLOS cụ thể nào trong `DS_BANG_202608`. Đơn vị kinh doanh (chi nhánh, công ty) là danh mục tổ chức của ngân hàng — cùng 1 chi nhánh vật lý xử lý cả hồ sơ CLOS lẫn RLOS trong thực tế nghiệp vụ. |
| DIM | `DIM_LOS_USER` | Không có cột `DATASOURCE`, không gắn với bảng nguồn CLOS/RLOS cụ thể nào. Tài khoản cán bộ xử lý dùng chung hệ thống định danh nhân sự; một cán bộ có thể xử lý cả hồ sơ CLOS lẫn RLOS (đặc biệt ở cấp phê duyệt cao), và BC9 (báo cáo KPI) cần nhìn 1 user xuyên cả 2 hệ để tính năng suất — tách sẽ phá vỡ khả năng này. |
| FCT | *(không có FCT dùng chung ở tầng SB_DWH — toàn bộ FCT_LOS_\* hiện có đều thuộc diện tách, xem mục 3)* | |

### 2. Bộ bảng CLOS

| Loại | Bảng hiện tại | Đổi tên thành | Nguyên nhân tách |
| --- | --- | --- | --- |
| DIM | `DIM_LOS_APPLICATION` | `DIM_CLOS_APPLICATION` | Cột `INDUSTRY_LVL1/2/3_CODE`, `CREDIT_PROFILE` chỉ có ý nghĩa với hồ sơ doanh nghiệp (CLOS); các cột đặc thù cá nhân (`CUS_SEGMENT`, `RESULT_MAIN_CARD_ID`...) luôn NULL phía CLOS. BC2 ("Báo cáo CLOS APPLICATION") chỉ dùng đúng nửa CLOS của bảng. |
| DIM | `DIM_LOS_PRODUCT` | `DIM_CLOS_PRODUCT` | Danh mục sản phẩm tín dụng doanh nghiệp là danh mục riêng, không dùng chung với sản phẩm bán lẻ. |
| DIM | `DIM_LOS_WORKSTEP` | `DIM_CLOS_WORKSTEP` | Workflow CLOS là quy trình BPM độc lập (khác bước, khác tên bước so với RLOS). |
| DIM | `DIM_LOS_DECISION` | `DIM_CLOS_DECISION` | Mã quyết định gắn liền với workflow CLOS riêng, tách đồng bộ với workstep. |
| DIM | `DIM_LOS_APPROVAL_GROUP` | `DIM_CLOS_APPROVAL_GROUP` | Cấp thẩm quyền phê duyệt CLOS (A1, A2, B1, B2, BOD, C1, SCC...) là hệ phân cấp riêng; có 2 bảng SLA riêng theo CLOS (`CLOS_REF_SLA_TDKHDNL`, `CLOS_REF_SLA_TDKHDN_2`) xác nhận tách biệt hoàn toàn với RLOS. |
| DIM | `DIM_LOS_EXCEPTION_REASON` | `DIM_CLOS_EXCEPTION_REASON` | Nguồn `NG_SB_CLOS_MAS_EXCEPTION` là danh mục ngoại lệ độc lập của CLOS, không có ánh xạ tương đương với RLOS. |
| DIM | `DIM_LOS_COLLATERAL_TYPE` | `DIM_CLOS_COLLATERAL_TYPE` | Mã loại TSBĐ gốc (`COLLATERAL_TYPE_CODE`) của CLOS khác hệ mã với RLOS (nguồn `NG_SB_CLOS_COLL_CD`, 11 loại đặc thù doanh nghiệp). |
| DIM | `DIM_LOS_CHANGE_TYPE` (phần CLOS) | *(không tách — gộp vào `DIM_CLOS_APPLICATION`)* | **Cập nhật khi thiết kế HLD:** đối chiếu SRS (BC1, BC2, BC5, BC9, BC11) xác nhận CLOS không có danh mục CHANGE_TYPE gốc nào — `NG_SB_CLOS_CHANGEREQ.CHANGE_TYPE` là chuỗi tự do đa giá trị (nối bằng `~`) đã là tên sẵn, không phải mã cần tra qua bảng danh mục, khác hẳn RLOS có `SB_RLOS_MAS_CHANGE_TYPE` (danh mục gốc thật). Vì vậy không tách `DIM_CLOS_CHANGE_TYPE` — cột `CHANGE_TYPE` giữ trực tiếp trên `DIM_CLOS_APPLICATION` (xem `hld/HLD_Table_Design.md` mục 1.2.1.1 và Section 3 dòng #11). |
| FCT | `FCT_LOS_APPLICATION_DAILY` | `FCT_CLOS_APPLICATION_DAILY` | Bảng ~90 cột, phần lớn cột nghiệp vụ đặc thù RLOS (`SALARYFLAG`, `CARFLAG`, `REPAYMENT_SOURCE`...) sẽ không xuất hiện ở bản CLOS; giảm cột thừa, đơn giản hóa ETL vốn đang phải rẽ nhánh theo `DATASOURCE`. |
| FCT | `FCT_LOS_APPLICATION_PARTY` | `FCT_CLOS_APPLICATION_PARTY` | `ORG_LEGAL_ID` đặc thù tổ chức; nguồn `NG_SB_CLOS_CUST_INFO*` hoàn toàn khác cấu trúc "party" cá nhân bên RLOS. |
| FCT | `FCT_LOS_PARTY_DOCUMENT` | `FCT_CLOS_PARTY_DOCUMENT` | Đi kèm `FCT_CLOS_APPLICATION_PARTY` (cùng khóa `APPLICATION_PARTY_BK`), tách đồng bộ. |
| FCT | `FCT_LOS_COLLATERAL` | `FCT_CLOS_COLLATERAL` | Nguồn TSBĐ CLOS dùng cơ chế riêng (`NG_SB_CLOS_COLL_CD`), khác 4 bảng loại tài sản của RLOS. |
| FCT | `FCT_LOS_EXCEPTION` | `FCT_CLOS_EXCEPTION` | Nguồn `NG_SB_CLOS_EXCEPTION`/`NG_SB_CLOS_MAS_EXCEPTION` là luồng ngoại lệ độc lập của CLOS. |
| FCT | `FCT_LOS_DEVIATION` | `FCT_CLOS_DEVIATION` | Nguồn deviation CLOS (`NG_SB_CLOS_CONDITON_CDGRID`) có cấu trúc/ý nghĩa khác nguồn RLOS. |

### 3. Bộ bảng RLOS

| Loại | Bảng hiện tại | Đổi tên thành | Nguyên nhân tách |
| --- | --- | --- | --- |
| DIM | `DIM_LOS_APPLICATION` | `DIM_RLOS_APPLICATION` | `CUS_SEGMENT`, `BI_CUS_SEGMENT`, `RESULT_MAIN_CARD_ID` chỉ có ý nghĩa với hồ sơ cá nhân (RLOS); các cột đặc thù doanh nghiệp luôn NULL phía RLOS. BC1 ("Báo cáo RLOS APPLICATION") chỉ dùng đúng nửa RLOS của bảng. |
| DIM | `DIM_LOS_PRODUCT` | `DIM_RLOS_PRODUCT` | Danh mục sản phẩm bán lẻ (`IS_CREDIT_CARD`, `IS_FAST_PRODUCT` ở bản PDTD chỉ có ý nghĩa RLOS) là danh mục riêng. |
| DIM | `DIM_LOS_WORKSTEP` | `DIM_RLOS_WORKSTEP` | Workflow RLOS là quy trình BPM độc lập với CLOS. |
| DIM | `DIM_LOS_DECISION` | `DIM_RLOS_DECISION` | Mã quyết định gắn liền với workflow RLOS riêng, tách đồng bộ với workstep. |
| DIM | `DIM_LOS_APPROVAL_GROUP` | `DIM_RLOS_APPROVAL_GROUP` | Cấp thẩm quyền phê duyệt RLOS là hệ phân cấp riêng; có bảng SLA riêng `RLOS_REF_SLA_TDKHCN`. |
| DIM | `DIM_LOS_EXCEPTION_REASON` | `DIM_RLOS_EXCEPTION_REASON` | Nguồn `NG_SB_RLOS_MAS_EXCEPTION` là danh mục ngoại lệ độc lập của RLOS. |
| DIM | `DIM_LOS_COLLATERAL_TYPE` | `DIM_RLOS_COLLATERAL_TYPE` | Mã loại TSBĐ RLOS khác hệ mã CLOS (nguồn 4 bảng `NG_SB_RLOS_COL_*`). |
| DIM | `DIM_LOS_CHANGE_TYPE` | `DIM_RLOS_CHANGE_TYPE` | Nguồn `NG_SB_RLOS_EXTTABLE` + `SB_RLOS_MAS_CHANGE_TYPE` riêng biệt với CLOS. |
| DIM | `DIM_LOS_GEO` | `DIM_RLOS_GEO` | Tuy không có cột `DATASOURCE`, nguồn dữ liệu (`NG_SB_RLOS_MAS_CITY`, `NG_SB_RLOS_MAS_DISTRICT`) mang tiền tố RLOS rõ ràng — danh mục tỉnh/thành, quận/huyện này thực chất được đồng bộ riêng cho RLOS, không có nguồn CLOS tương ứng trong `DS_BANG_202608`. |
| DIM | `DIM_LOS_CARD_PROMOTION` | `DIM_RLOS_CARD_PROMOTION` | Nguồn `NG_SB_RLOS_MAS_CARD_PROMOTIO` — chương trình ưu đãi phí thẻ tín dụng là sản phẩm đặc thù bán lẻ (RLOS), CLOS không có khái niệm này. |
| FCT | `FCT_LOS_APPLICATION_DAILY` | `FCT_RLOS_APPLICATION_DAILY` | Giữ trọn các cột đặc thù cá nhân (`SALARYFLAG`, `CARFLAG`, `HOUSEFLAG`, `REPAYMENT_SOURCE`, các `COLLATERAL_CNT_*`...) mà không cần luôn NULL cho phía CLOS. |
| FCT | `FCT_LOS_APPLICATION_PARTY` | `FCT_RLOS_APPLICATION_PARTY` | `MARRIAGE_STATUS`, `EDUCATION_LEVEL`, `VEHICLE` đặc thù cá nhân; nguồn `NG_SB_RLOS_APPLICANT_*`/`NG_SB_RLOS_COREP*`. |
| FCT | `FCT_LOS_PARTY_DOCUMENT` | `FCT_RLOS_PARTY_DOCUMENT` | Đi kèm `FCT_RLOS_APPLICATION_PARTY`, tách đồng bộ. |
| FCT | `FCT_LOS_COLLATERAL` | `FCT_RLOS_COLLATERAL` | Nguồn TSBĐ RLOS từ 4 bảng riêng theo loại tài sản cá nhân (BĐS, xe, giấy tờ có giá, khác). |
| FCT | `FCT_LOS_SUB_PRODUCT` | `FCT_RLOS_SUB_PRODUCT` | Mô tả cột `DATASOURCE` trong tài liệu thiết kế gốc ghi rõ "hiện các bảng sản phẩm phụ trong phạm vi là RLOS" — bảng này thực chất chỉ có dữ liệu RLOS, đổi tên phản ánh đúng phạm vi thay vì giữ cột `DATASOURCE` dư thừa. Nếu CLOS phát sinh sản phẩm phụ trong tương lai, tạo mới `FCT_CLOS_SUB_PRODUCT` khi đó thay vì gộp lại. |
| FCT | `FCT_LOS_EXCEPTION` | `FCT_RLOS_EXCEPTION` | Nguồn `NG_SB_RLOS_EXCEPTION`/`NG_SB_RLOS_MAS_EXCEPTION` là luồng ngoại lệ độc lập của RLOS. |
| FCT | `FCT_LOS_DEVIATION` | `FCT_RLOS_DEVIATION` | Nguồn `NG_SB_RLOS_MANUAL_DEVIATION` là nguồn deviation rõ ràng và duy nhất trong phạm vi hiện tại cho RLOS. |

**Ghi chú thiết kế khóa khi tách:** các bảng `FCT_*` hiện có cột `DATASOURCE` là 1
phần khóa chính (PK) ở một số bảng (ví dụ `FCT_LOS_EXCEPTION`). Sau khi tách vật lý
theo hệ, cột `DATASOURCE` trở thành thừa (luôn 1 giá trị cố định trong mỗi bảng) và
có thể loại khỏi PK, đơn giản hóa khóa.

---

## PDTD_DTM

Tên bảng ở layer này **giống hệt** tên bảng tương ứng ở SB_DWH (không còn tiền tố
`PDTD`) — phân biệt 2 layer bằng schema/database chứa bảng. Khác biệt nội dung: bản
trên PDTD_DTM có thêm cột map từ 9 bảng `REF_` và dữ liệu T24 phục vụ báo cáo mà bản
SB_DWH không cần.

### 1. Bộ bảng CHUNG

| Loại | Bảng | Nguyên nhân giữ chung |
| --- | --- | --- |
| DIM | `DIM_LOS_ORG_UNIT` | Đồng bộ với SB_DWH — dùng chung toàn ngân hàng. |
| DIM | `DIM_LOS_USER` | Đồng bộ với SB_DWH — tài khoản cán bộ dùng chung. |
| DIM | `DIM_LOS_CUSTOMER` *(trước đây `DIM_PDTD_CUSTOMER`)* | Nguồn là **T24 (core banking)** qua `CUSTOMER_ID` (CIF) — thông tin khách hàng dùng chung toàn ngân hàng bất kể hồ sơ tín dụng thuộc hệ nào; chỉ tồn tại ở layer PDTD_DTM (không có bản SB_DWH). |
| FCT | `FCT_LOS_DISBURSEMENT` *(trước đây `FCT_PDTD_DISBURSEMENT`)* | Nguồn T24 (`PRODUCT_T24`, `CONTRACT`, `CUR_BALANCE`...) dùng chung, không phân theo CLOS/RLOS ở tầng nguồn; chỉ tồn tại ở layer PDTD_DTM. |
| FCT | `FCT_LOS_KPI_USER_YEAR` *(trước đây `FCT_PDTD_KPI_USER_YEAR`)* | Theo dõi nhân sự đủ điều kiện tính KPI theo năm — một user có thể được tính KPI cả CLOS lẫn RLOS; chỉ tồn tại ở layer PDTD_DTM. |
| FCT | `FCT_LOS_KPI_YTD_DAILY` *(trước đây `FCT_PDTD_KPI_YTD_DAILY`)* | Bảng **tổng hợp KPI khối PDTD** — mỗi dòng có cặp cột `*_RLOS_*`/`*_CLOS_*` song song để so sánh năng suất giữa 2 khối (phục vụ BC9); tách sẽ phá vỡ mục đích của bảng. Chỉ tồn tại ở layer PDTD_DTM. |
| FCT | `FCT_LOS_KPI_APPLICATION` *(trước đây `FCT_PDTD_KPI_APPLICATION`)* | Tuy có cột `DATASOURCE`, đây là điểm KPI theo hồ sơ dùng để cộng dồn lên `FCT_LOS_KPI_YTD_DAILY`; logic tính đã tách nhánh theo hệ trong SRS BC9 nhưng **kết quả cần nằm cùng 1 bảng theo grain hồ sơ** để tổng hợp theo ngày/tháng dễ dàng. Giữ gộp, chỉ tồn tại ở layer PDTD_DTM. |
| DIM | `DIM_DATE` | Bảng lịch dùng chung toàn hệ thống, không liên quan CLOS/RLOS. |

### 2. Bộ bảng CLOS

| Loại | Bảng (đồng bộ tên với SB_DWH) | Khác biệt so với bản SB_DWH |
| --- | --- | --- |
| DIM | `DIM_CLOS_APPLICATION` | Cùng cấu trúc gốc + có thể bổ sung cột chuẩn hóa hiển thị báo cáo (map qua `REF_CLOS_LEGAL`, `TMP_REF_COMPANY_REGION_KHDN`...). |
| DIM | `DIM_CLOS_PRODUCT` | Cùng cấu trúc gốc. |
| DIM | `DIM_CLOS_WORKSTEP` | Cùng cấu trúc gốc, có thể map thêm qua bảng `REF_` chuẩn hóa tên bước cho báo cáo. |
| DIM | `DIM_CLOS_DECISION` | Cùng cấu trúc gốc. |
| DIM | `DIM_CLOS_APPROVAL_GROUP` | Có thể bổ sung map SLA từ `CLOS_REF_SLA_TDKHDNL`/`CLOS_REF_SLA_TDKHDN_2`. |
| DIM | `DIM_CLOS_EXCEPTION_REASON` | Cùng cấu trúc gốc. |
| DIM | `DIM_CLOS_COLLATERAL_TYPE` | Cùng cấu trúc gốc. |
| DIM | `DIM_CLOS_CHANGE_TYPE` | Cùng cấu trúc gốc. |
| FCT | `FCT_CLOS_APPLICATION_DAILY` | Bổ sung cột chuẩn hóa cho báo cáo (`BI_FLOW` qua `REF_CLOS_LEGAL`/luồng nghiệp vụ, `ZONE` qua `TMP_REF_COMPANY_REGION_KHDN`) phục vụ BC2, BC11. |
| FCT | `FCT_CLOS_APPLICATION_PARTY` | Cùng cấu trúc gốc, có thể bổ sung `LEGAL_TYPE` map qua `REF_CLOS_LEGAL`. |
| FCT | `FCT_CLOS_PARTY_DOCUMENT` | Bổ sung `LEGAL_TYPE` map qua `REF_CLOS_LEGAL` (tương tự thiết kế `FCT_PDTD_PARTY_DOCUMENT` hiện tại). |
| FCT | `FCT_CLOS_COLLATERAL` | Cùng cấu trúc gốc. |
| FCT | `FCT_CLOS_EXCEPTION` | Cùng cấu trúc gốc. |
| FCT | `FCT_CLOS_DEVIATION` | Cùng cấu trúc gốc. |

### 3. Bộ bảng RLOS

| Loại | Bảng (đồng bộ tên với SB_DWH) | Khác biệt so với bản SB_DWH |
| --- | --- | --- |
| DIM | `DIM_RLOS_APPLICATION` | Bổ sung `BI_FLOW` (map qua `REF_RLOS_FLOW`). |
| DIM | `DIM_RLOS_PRODUCT` | Bổ sung `IS_CREDIT_CARD`, `IS_FAST_PRODUCT`. |
| DIM | `DIM_RLOS_WORKSTEP` | Bổ sung `IS_PDTD_STEP` (map qua `Q_RLOS_REF_WORKSTEP_2SYSTEMS`), cờ bước có thuộc phạm vi Khối PDTD. |
| DIM | `DIM_RLOS_DECISION` | Cùng cấu trúc gốc. |
| DIM | `DIM_RLOS_APPROVAL_GROUP` | Có thể bổ sung map SLA từ `RLOS_REF_SLA_TDKHCN`. |
| DIM | `DIM_RLOS_EXCEPTION_REASON` | Cùng cấu trúc gốc. |
| DIM | `DIM_RLOS_COLLATERAL_TYPE` | Cùng cấu trúc gốc. |
| DIM | `DIM_RLOS_CHANGE_TYPE` | Cùng cấu trúc gốc. |
| DIM | `DIM_RLOS_GEO` | Cùng cấu trúc gốc (nguồn `NG_SB_RLOS_MAS_CITY/MAS_DISTRICT`). |
| DIM | `DIM_RLOS_CARD_PROMOTION` | Cùng cấu trúc gốc (nguồn `NG_SB_RLOS_MAS_CARD_PROMOTIO`). |
| FCT | `FCT_RLOS_APPLICATION_DAILY` | Bổ sung `BI_FLOW` (qua `REF_RLOS_FLOW`), `ZONE` (qua `TMP_REF_COMPANY_REGION_KHCN`), các cột SLA_* chi tiết (qua `RLOS_REF_SLA_TDKHCN`, `REF_SLA_NLTT`) phục vụ BC1, BC9, BC10. |
| FCT | `FCT_RLOS_APPLICATION_PARTY` | Bổ sung `CURR_FULL_ADDRESS` (gộp từ CITY/DISTRICT/WARD/HOUSE_NO, map qua `DIM_LOS_GEO`). |
| FCT | `FCT_RLOS_PARTY_DOCUMENT` | Cùng cấu trúc gốc. |
| FCT | `FCT_RLOS_COLLATERAL` | Cùng cấu trúc gốc. |
| FCT | `FCT_RLOS_SUB_PRODUCT` | Cùng cấu trúc gốc. |
| FCT | `FCT_RLOS_EXCEPTION` | Cùng cấu trúc gốc. |
| FCT | `FCT_RLOS_DEVIATION` | Cùng cấu trúc gốc. |

### 4. Bộ bảng `REF_` (tạo mới trên PDTD_DTM, giữ nguyên tên/cấu trúc theo 9 bảng nguồn)

| Bảng | Thuộc hệ | Ghi chú |
| --- | --- | --- |
| `REF_RLOS_FLOW` | RLOS | Ánh xạ `STREAM` → `BI_FLOW`, dùng cho luồng nghiệp vụ RLOS. |
| `REF_CLOS_LEGAL` | CLOS | Ánh xạ loại đối tượng giấy tờ pháp lý, đặc thù hồ sơ doanh nghiệp CLOS. |
| `TMP_REF_COMPANY_REGION_KHCN` | RLOS (khách hàng cá nhân) | Phục vụ `ZONE` cho BC10 (Giải ngân/Quá hạn KHCN). |
| `TMP_REF_COMPANY_REGION_KHDN` | CLOS (khách hàng doanh nghiệp) | Phục vụ `ZONE` cho BC11 (Giải ngân/Quá hạn KHDN), map theo tên chi nhánh T24. |
| `RLOS_REF_SLA_TDKHCN` | RLOS | Cam kết SLA thẩm định khách hàng cá nhân. |
| `CLOS_REF_SLA_TDKHDNL` | CLOS | Cam kết SLA thẩm định khách hàng doanh nghiệp lớn. |
| `CLOS_REF_SLA_TDKHDN_2` | CLOS | Cam kết SLA thẩm định khách hàng doanh nghiệp (nhóm 2). |
| `REF_SLA_NLTT` | Dùng chung 2 hệ (cột `SYSTEM_CODE` là 1 phần khóa) | Cam kết SLA khâu Nhập liệu tập trung, phục vụ BC9; bảng tham chiếu nhỏ dùng chung, không tách vật lý. |
| `Q_RLOS_REF_WORKSTEP_2SYSTEMS` | Dùng chung 2 hệ (cột `SYSTEM` phân biệt) | Ánh xạ tên bước xử lý chuẩn hóa dùng chung giữa 2 hệ để hiển thị thống nhất trên báo cáo. |

---

## Đối chiếu phạm vi báo cáo (SRS BC1–BC11) theo hệ nguồn

| Báo cáo | Chủ đề | Phạm vi hệ | Bảng nguồn chính (STG_LOS) |
| --- | --- | --- | --- |
| BC1 | Báo cáo RLOS APPLICATION | **RLOS only** | 22 bảng `NG_SB_RLOS_*` |
| BC2 | Báo cáo CLOS APPLICATION | **CLOS only** | 10 bảng `NG_SB_CLOS_*` |
| BC3 | Báo cáo Thông tin phê duyệt | Cả 2 hệ | 5 bảng CLOS + 4 bảng RLOS |
| BC4 | Báo cáo Tuần Chuyên viên Thẩm định | Cả 2 hệ | 2 bảng CLOS + 2 bảng RLOS |
| BC5 | Báo cáo SLA - TAT | Cả 2 hệ | 1 bảng CLOS + 1 bảng RLOS (kết hợp `RLOS_REF_SLA_TDKHCN`, `CLOS_REF_SLA_TDKHDNL/2`) |
| BC6 | Báo cáo ngoại lệ | Cả 2 hệ | 2 bảng CLOS + 1 bảng RLOS |
| BC7 | Báo cáo EXCEPTION - FTR | Cả 2 hệ | 3 bảng CLOS + 3 bảng RLOS |
| BC8 | Báo cáo RETURN | Cả 2 hệ | 1 bảng CLOS + 1 bảng RLOS |
| BC9 | Báo cáo KPI | Cả 2 hệ (tổng hợp/so sánh) | 2 bảng CLOS + 4 bảng RLOS, tính riêng theo mục "Nguồn RLOS"/"Nguồn CLOS" rồi gộp |
| BC10 | Báo cáo Giải ngân/Quá hạn KHCN | **RLOS (cá nhân)** | T24 (`STG_DIM_LOAN`, `STG_DIM_CUSTOMER`...) + `TMP_REF_COMPANY_REGION_KHCN` |
| BC11 | Báo cáo Giải ngân/Quá hạn KHDN | **CLOS (doanh nghiệp)** | T24 + 2 bảng CLOS + `TMP_REF_COMPANY_REGION_KHDN` |

**Nhận xét:** BC1/BC2 và BC10/BC11 là các cặp báo cáo đã tách sẵn theo hệ ngay từ
khâu đặc tả yêu cầu — củng cố đề xuất tách vật lý các bảng `APPLICATION`,
`APPLICATION_PARTY`, `PARTY_DOCUMENT`. Các báo cáo BC3–BC8 tuy dùng cả 2 hệ nhưng
đều có cột `SYSTEMNAME` (CLOS/RLOS) tường minh ngay trên báo cáo để phân biệt dòng
dữ liệu, và BC9 tách hẳn thành cặp cột song song theo hệ (`TAT_RLOS`/`TAT_CLOS`,
`SLHS_RLOS`/`SLHS_CLOS`...) — nghĩa là **tầng báo cáo luôn cần phân biệt được
CLOS/RLOS trên từng dòng dù hiển thị gộp**. Tách bảng nguồn vật lý theo hệ vì vậy
không ảnh hưởng tới khả năng làm báo cáo tổng hợp, chỉ cần lớp truy vấn báo cáo
UNION 2 bảng khi cần nhìn chung (giống cách BC9 đã làm ở tầng đặc tả) — thậm chí
còn loại bỏ được nhu cầu tự suy luận `DATASOURCE` từ hậu tố `WI_NAME` như mô tả
hiện tại của nhiều cột (`FCT_LOS_APPLICATION_PARTY.DATASOURCE`: "hậu tố WI_NAME chỉ
dùng kiểm tra").

**Đối chiếu số lượng trường qua các tầng** (theo `extract/Report/00_Tong_hop.md`,
tổng 337 trường/11 báo cáo): 273 trường đã có sẵn ở tầng SB_DWH (kéo thẳng lên
PDTD_DTM), 62 trường chỉ tính được ở tầng PDTD_DTM (tập trung ở BC9 KPI, BC10/BC11
Giải ngân — đúng nhóm bảng CHUNG ở PDTD_DTM vì đây là tầng tổng hợp/tính toán thêm,
không phải tầng chứa dữ liệu giao dịch gốc theo hệ).

---

## Tổng kết khuyến nghị

- **Tách theo CLOS/RLOS** (tên đồng bộ ở cả 2 layer, đổi tiền tố `LOS`/`PDTD` →
  `CLOS`/`RLOS`): `APPLICATION`, `PRODUCT`, `WORKSTEP`, `DECISION`,
  `APPROVAL_GROUP`, `EXCEPTION_REASON`, `COLLATERAL_TYPE`, `CHANGE_TYPE` (DIM, cả 2
  hệ) + `GEO`, `CARD_PROMOTION` (DIM, RLOS only) và `APPLICATION_DAILY`,
  `APPLICATION_PARTY`, `PARTY_DOCUMENT`, `COLLATERAL`, `EXCEPTION`, `DEVIATION`
  (FCT, cả 2 hệ) + `SUB_PRODUCT` (FCT, RLOS only).
- **Giữ chung** (tên giữ tiền tố `LOS`, không tiền tố `PDTD`): `ORG_UNIT`, `USER`
  (2 layer — không gắn với nguồn CLOS/RLOS cụ thể nào); `CUSTOMER`,
  `DISBURSEMENT`, `KPI_USER_YEAR`, `KPI_YTD_DAILY`, `KPI_APPLICATION` (chỉ layer
  PDTD_DTM); `DIM_DATE`.
- **Bảng `REF_`:** tạo mới trên PDTD_DTM, giữ nguyên tên/cấu trúc theo đúng 9 bảng
  nguồn (`REF_RLOS_FLOW`, `REF_CLOS_LEGAL`, `TMP_REF_COMPANY_REGION_KHCN/KHDN`,
  `RLOS_REF_SLA_TDKHCN`, `CLOS_REF_SLA_TDKHDNL`, `CLOS_REF_SLA_TDKHDN_2`,
  `REF_SLA_NLTT`, `Q_RLOS_REF_WORKSTEP_2SYSTEMS`).

---

## Phụ lục — ý nghĩa bảng nguồn CLOS/RLOS liên quan (theo `CLOS/RLOS - Metadata.xlsx`)

Đối chiếu với bộ bảng nguồn trong `DS_BANG_202608.xlsx` (mục "Key CDC" dùng cho
thiết kế mapping ở bước sau), xác nhận mỗi bảng nguồn STG_LOS chỉ phục vụ đúng 1
hệ — không có bảng nguồn nào dùng chung CLOS/RLOS ở tầng OLTP gốc:

| Nhóm nghiệp vụ | Bảng nguồn CLOS | Bảng nguồn RLOS |
| --- | --- | --- |
| Hồ sơ chính / trạng thái xử lý | `NG_SB_CLOS_EXTTABLE`, `NG_SB_CLOS_ENTRY_EXIT`, `NG_SB_CLOS_CUST_INFO` | `NG_SB_RLOS_EXTTABLE`, `NG_SB_RLOS_ENTRY_EXIT`, `NG_SB_RLOS_APPLICANT_GENERAL`, `NG_SB_RLOS_APPLICANT_DETAIL` |
| Phê duyệt / cấp thẩm quyền | `NG_SB_CLOS_APPROVAL` | `NG_SB_RLOS_APPROVAL` |
| Thay đổi điều kiện | `NG_SB_CLOS_CHANGEREQ` | `NG_SB_RLOS_EXTTABLE` + `SB_RLOS_MAS_CHANGE_TYPE` |
| Ngoại lệ chính sách | `NG_SB_CLOS_EXCEPTION`, `NG_SB_CLOS_MAS_EXCEPTION` | `NG_SB_RLOS_EXCEPTION`, `NG_SB_RLOS_MAS_EXCEPTION` |
| Độ lệch chính sách (deviation) | `NG_SB_CLOS_CONDITON_CDGRID` | `NG_SB_RLOS_MANUAL_DEVIATION` |
| Tài sản bảo đảm | `NG_SB_CLOS_COLL_CD` (11 loại TSBĐ doanh nghiệp) | `NG_SB_RLOS_COL_OTHER/REALESTATE/TRANSPORT/VALPAPER`, `NG_SB_RLOS_COLL_CERTIGRD` |
| Người liên quan / pháp lý | `NG_SB_CLOS_CUST_INFO_LEGAL` (đại diện pháp luật, thành viên góp vốn) | `NG_SB_RLOS_APPLICANT_IDGRID`, `NG_SB_RLOS_COREPAYER_GENERAL`, `NG_SB_RLOS_COREP_IDGRID` (đồng trả nợ) |
| Sản phẩm phụ | *(chưa phát sinh trong phạm vi)* | `NG_SB_RLOS_SUB_PRODUCT` + 4 bảng chi tiết: `CIVIL_APP`, `CREDIT_CARD_APP`, `SEABUY_APP`, `TEACHER_APP`, `WOMAN_APP` |
| Đề xuất tín dụng | `NG_SB_CLOS_CREDITINFO_CD`, `NG_SB_CLOS_CREDITINFO_COMM` | `NG_SB_RLOS_CREDIT_PROPOSAL`, `NG_SB_RLOS_CREDIT_PROPOSAL_APP`, `NG_SB_RLOS_REPAY_CALC` |
| Tích hợp Core Banking (T24) | *(qua CBS chung)* | `NG_SB_RLOS_CBS`, `NG_SB_RLOS_SENT_CBS_LOG` |
| Danh mục dùng chung | — | `NG_SB_RLOS_MAS_CITY`/`MAS_DISTRICT` (địa lý, dùng chung thực chất) |

**Ghi chú:** 6 bảng nguồn trong `DS_BANG_202608.xlsx` chưa được review chi tiết
trong 2 file metadata (`NG_SB_CLOS_MAS_PRO_LINE`, `NG_SB_RLOS_COLL_CERTIGRD`,
`NG_SB_RLOS_DISB_COL_GRID`, `NG_SB_RLOS_MAS_CARD_PROMOTIO`,
`NG_SB_RLOS_MAS_EXCEPTION`, `SB_RLOS_MAS_CHANGE_TYPE`) — tên gọi cho thấy rõ hệ
thuộc về (tiền tố CLOS/RLOS), nhưng nên yêu cầu bổ sung review trước khi chốt thiết
kế mapping chi tiết ở bước tiếp theo.
