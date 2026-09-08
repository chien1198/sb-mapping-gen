# Changelog: Chuyển SB_DWH sang Star Schema hoàn chỉnh

Áp dụng vào: `input/Design_Database_PDTD_DTM_v1.0_20260907.docx`

**Quyết định (đã thống nhất với BA, 2026-09-07):** `PRODUCT_SK`, `ORG_UNIT_SK`,
`APPROVAL_GROUP_SK`, `CHANGE_TYPE_SK`, `CARD_PROMOTION_SK` là quan hệ **1:1** với
`DIM_LOS_APPLICATION` (mỗi phiên bản hồ sơ chỉ có đúng 1 giá trị tại một thời điểm
hiệu lực). Do đó 5 khóa này được **chuyển từ vị trí outrigger trên DIM_LOS_APPLICATION
xuống làm FK trực tiếp trên các bảng FCT cần dùng**, giữ đúng star schema (Fact nối
thẳng Dimension, không còn cạnh Dimension → Dimension).

**Phạm vi đưa xuống FCT nào chỉ theo truy vết thực tế từ 11 báo cáo**
(`input/Reports_20260907.xlsx`) — không thêm SK vào fact nào không có báo cáo cần:

| FCT | SK cần thêm | Báo cáo truy vết |
|---|---|---|
| FCT_LOS_APPLICATION_DAILY / FCT_PDTD_APPLICATION_DAILY | PRODUCT_SK, ORG_UNIT_SK, APPROVAL_GROUP_SK, CHANGE_TYPE_SK, CARD_PROMOTION_SK | BC1, BC2, BC9 |
| FCT_LOS_SLA_DAILY / FCT_PDTD_SLA_DAILY | PRODUCT_SK, APPROVAL_GROUP_SK | BC5.REF_PRODUCT, BC9.TAT_RLOS |
| FCT_LOS_WORKSTEP_EVENT / FCT_PDTD_WORKSTEP_EVENT | PRODUCT_SK | BC9.TAT_RLOS |

6 bảng FCT còn lại (APPLICATION_PARTY, COLLATERAL, DEVIATION, EXCEPTION,
PARTY_DOCUMENT, SUB_PRODUCT) **không thay đổi** — không có báo cáo nào truy vết
tới 5 DIM này qua các fact đó.

**Lưu ý riêng cho tầng DTM:** `FCT_PDTD_APPLICATION_DAILY` và `FCT_PDTD_SLA_DAILY`
**đã có sẵn** `PRODUCT_SK`/`ORG_UNIT_SK`/`APPROVAL_GROUP_SK` (tự lookup độc lập tới
`DIM_PDTD_xxx.DIMENSION_KEY`, không kế thừa từ DWH) — giữ nguyên cách tham chiếu này,
chỉ **bổ sung cho đủ 5 chiều** ở nơi còn thiếu (`CHANGE_TYPE_SK`, `CARD_PROMOTION_SK`
trên APPLICATION_DAILY; `PRODUCT_SK` trên WORKSTEP_EVENT).

---

## 1. SB_DWH — Mục 4.1.1 Bảng DIM_LOS_APPLICATION

### XÓA 5 dòng (STT 28–32 trong bảng thiết kế hiện tại)

| STT | Tên cột | Lý do xóa |
| --- | --- | --- |
| 28 | PRODUCT_SK | Chuyển xuống FCT_LOS_APPLICATION_DAILY, FCT_LOS_SLA_DAILY, FCT_LOS_WORKSTEP_EVENT |
| 29 | ORG_UNIT_SK | Chuyển xuống FCT_LOS_APPLICATION_DAILY |
| 30 | APPROVAL_GROUP_SK | Chuyển xuống FCT_LOS_APPLICATION_DAILY, FCT_LOS_SLA_DAILY |
| 31 | CHANGE_TYPE_SK | Chuyển xuống FCT_LOS_APPLICATION_DAILY |
| 32 | CARD_PROMOTION_SK | Chuyển xuống FCT_LOS_APPLICATION_DAILY |

**Đánh số lại:** STT 33 (EFF_DATE) → 28, STT 34 (EXP_DATE) → 29. Bảng còn lại 29 cột
(từ 34).

**Cập nhật mục "Khóa" ở đầu bảng 4.1.1** — bỏ câu tham chiếu tới 5 SK trên (nếu có).

---

## 2. SB_DWH — Mục 4.2.1 Bảng FCT_LOS_APPLICATION_DAILY

### THÊM 5 dòng mới (chèn ngay sau LAST_USER_SK, trước cột nghiệp vụ đầu tiên)

| STT | Tên cột | Ý nghĩa | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng nguồn | Cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| (mới) | PRODUCT_SK | Khóa tham chiếu đến chiều sản phẩm | NUMBER | 18 | Y |  | KỸ THUẬT | NG_SB_RLOS_APPLICANT_GENERAL / NG_SB_CLOS_CUST_INFO | PRODUCT_LINE / SUB_PRODUCT (RLOS); mã sản phẩm tương ứng (CLOS) | BC1.PRODUCT_LINE; BC1.SUB_PRODUCT; BC2.PRODUCT_LINE; BC2.SUB_PRODUCT | DA_CHOT | KỸ THUẬT — Khóa tới DIM_LOS_PRODUCT của sản phẩm chính. Lookup theo DATASOURCE và bộ mã sản phẩm ổn định tại thời điểm hiệu lực (đúng EFF_DATE của phiên bản hồ sơ tương ứng trên DIM_LOS_APPLICATION); không khớp dùng bản ghi Unknown DIMENSION_KEY = -1. Chuyển từ DIM_LOS_APPLICATION xuống theo quyết định BA ngày 2026-09-07: quan hệ 1:1 với hồ sơ, dùng bởi BC1, BC2, BC9. |
| (mới) | ORG_UNIT_SK | Khóa tham chiếu đến chiều đơn vị kinh doanh | NUMBER | 18 | Y |  | KỸ THUẬT | NG_SB_RLOS_APPLICANT_GENERAL / NG_SB_CLOS_CUST_INFO | ZONE, BRANCH_CODE, BRANCH_NAME, COMPANY_CODE, COMPANY_NAME | BC1/BC2.ZONE, BRANCH_CODE, BRANCH_NAME, COMPANY_CODE, COMPANY_NAME | DA_CHOT | KỸ THUẬT — Khóa tới DIM_LOS_ORG_UNIT, lookup theo COMPANY_CODE tại thời điểm hiệu lực; không khớp dùng -1. Chuyển từ DIM_LOS_APPLICATION xuống theo quyết định BA ngày 2026-09-07, dùng bởi BC1, BC2. |
| (mới) | APPROVAL_GROUP_SK | Khóa tham chiếu đến chiều cấp thẩm quyền phê duyệt | NUMBER | 18 | Y |  | KỸ THUẬT | NG_SB_CLOS_APPROVAL / NG_SB_RLOS_APPROVAL | APP_GRP | BC1.APP_GRP; BC2.APP_GRP | DA_CHOT | KỸ THUẬT — Khóa tới DIM_LOS_APPROVAL_GROUP, lookup theo APP_GRP tại thời điểm hiệu lực; không khớp dùng -1. Chuyển từ DIM_LOS_APPLICATION xuống theo quyết định BA ngày 2026-09-07, dùng bởi BC1, BC2, BC9. |
| (mới) | CHANGE_TYPE_SK | Khóa tham chiếu đến chiều loại thay đổi điều kiện tín dụng | NUMBER | 18 | Y |  | KỸ THUẬT | NG_SB_RLOS_EXTTABLE / NG_SB_CLOS_CHANGEREQ | CHANGE_TYPE | BC1.CHANGE_TYPE; BC1.CHANGE_TYPE_DETAIL; BC2.CHANGE_TYPE | DA_CHOT | KỸ THUẬT — Khóa tới DIM_LOS_CHANGE_TYPE. Chỉ có giá trị với hồ sơ thay đổi điều kiện phê duyệt, còn lại trỏ Unknown -1. Phía RLOS lấy NG_SB_RLOS_EXTTABLE.CHANGE_TYPE, phía CLOS lấy NG_SB_CLOS_CHANGEREQ.CHANGE_TYPE, tra sang DIM_LOS_CHANGE_TYPE theo DATASOURCE + CHANGE_TYPE_CODE. Chuyển từ DIM_LOS_APPLICATION xuống theo quyết định BA ngày 2026-09-07, dùng bởi BC1. |
| (mới) | CARD_PROMOTION_SK | Khóa tham chiếu đến chiều chương trình ưu đãi phí thẻ | NUMBER | 18 | Y |  | KỸ THUẬT | NG_SB_RLOS_CBS | PROMOTION_ID | BC1.PROMOTION_ID | DA_CHOT | KỸ THUẬT — Chương trình khuyến mại của thẻ tín dụng là sản phẩm chính, gắn 1:1 với hồ sơ. Lookup NG_SB_RLOS_CBS.PROMOTION_ID sang DIM_LOS_CARD_PROMOTION.PROMOTION_CODE theo thời điểm hiệu lực; hồ sơ không phải thẻ hoặc không có mã dùng DIMENSION_KEY = -1. Chuyển từ DIM_LOS_APPLICATION xuống theo quyết định BA ngày 2026-09-07, dùng bởi BC1. |

**Đánh số lại** các STT phía sau theo đúng thứ tự chèn.

---

## 3. SB_DWH — Mục 4.2.3 Bảng FCT_LOS_SLA_DAILY

### THÊM 2 dòng mới (chèn ngay sau APPLICATION_SK)

| STT | Tên cột | Ý nghĩa | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng nguồn | Cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| (mới) | PRODUCT_SK | Khóa tham chiếu đến chiều sản phẩm | NUMBER | 18 | Y |  | KỸ THUẬT | NG_SB_RLOS_APPLICANT_GENERAL / NG_SB_CLOS_CUST_INFO | PRODUCT_LINE / SUB_PRODUCT | BC5.REF_PRODUCT (thành phần); BC9.TAT_RLOS (thành phần) | DA_CHOT | KỸ THUẬT — Khóa tới DIM_LOS_PRODUCT, cùng logic lookup như trên FCT_LOS_APPLICATION_DAILY (theo hồ sơ tại thời điểm hiệu lực). Chuyển từ DIM_LOS_APPLICATION xuống theo quyết định BA ngày 2026-09-07, dùng bởi BC5 (nhóm sản phẩm SLA), BC9 (TAT_RLOS). |
| (mới) | APPROVAL_GROUP_SK | Khóa tham chiếu đến chiều cấp thẩm quyền phê duyệt | NUMBER | 18 | Y |  | KỸ THUẬT | NG_SB_CLOS_APPROVAL / NG_SB_RLOS_APPROVAL | APP_GRP | BC5.REF_PRODUCT (thành phần) | DA_CHOT | KỸ THUẬT — Khóa tới DIM_LOS_APPROVAL_GROUP, cùng logic lookup như trên FCT_LOS_APPLICATION_DAILY. Chuyển từ DIM_LOS_APPLICATION xuống theo quyết định BA ngày 2026-09-07, dùng bởi BC5. |

---

## 4. SB_DWH — Mục 4.2.2 Bảng FCT_LOS_WORKSTEP_EVENT

### THÊM 1 dòng mới (chèn ngay sau APPLICATION_SK)

| STT | Tên cột | Ý nghĩa | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng nguồn | Cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| (mới) | PRODUCT_SK | Khóa tham chiếu đến chiều sản phẩm | NUMBER | 18 | Y |  | KỸ THUẬT | NG_SB_RLOS_APPLICANT_GENERAL / NG_SB_CLOS_CUST_INFO | PRODUCT_LINE / SUB_PRODUCT | BC9.TAT_RLOS (thành phần) | DA_CHOT | KỸ THUẬT — Khóa tới DIM_LOS_PRODUCT, cùng logic lookup như trên FCT_LOS_APPLICATION_DAILY. Chuyển từ DIM_LOS_APPLICATION xuống theo quyết định BA ngày 2026-09-07, dùng bởi BC9 (TAT_RLOS join cùng PRODUCT_NAME). |

---

## 5. PDTD_DTM — Mục 4.3.2 Bảng DIM_PDTD_APPLICATION

### XÓA 6 dòng (STT 29–34 trong bảng thiết kế hiện tại)

| STT | Tên cột | Lý do xóa |
| --- | --- | --- |
| 29 | ORG_UNIT_SK | Đồng bộ với DWH: chuyển xuống FCT_PDTD_APPLICATION_DAILY (đã có sẵn) |
| 30 | PRODUCT_SK | Đồng bộ với DWH: chuyển xuống FCT_PDTD_APPLICATION_DAILY, FCT_PDTD_SLA_DAILY (đã có sẵn), FCT_PDTD_WORKSTEP_EVENT (thêm mới) |
| 31 | APPROVAL_GROUP_SK | Đồng bộ với DWH: chuyển xuống FCT_PDTD_APPLICATION_DAILY, FCT_PDTD_SLA_DAILY (đã có sẵn) |
| 32 | CUSTOMER_SK | Xóa hẳn, KHÔNG chuyển đi đâu — xem phân tích riêng ở mục 9: không báo cáo nào dùng qua DIM_PDTD_APPLICATION, FCT_PDTD_APPLICATION_DAILY/PARTY_DOCUMENT/DISBURSEMENT đã có sẵn CUSTOMER_SK đúng grain riêng |
| 33 | CHANGE_TYPE_SK | Đồng bộ với DWH: chuyển xuống FCT_PDTD_APPLICATION_DAILY (thêm mới) |
| 34 | CARD_PROMOTION_SK | Đồng bộ với DWH: chuyển xuống FCT_PDTD_APPLICATION_DAILY (thêm mới) |

**CUSTOMER_SK (STT 32) — XEM MỤC 9:** ban đầu đánh giá là không thuộc phạm vi 5 SK
này nên giữ lại, nhưng truy vết báo cáo ở mục 9 cho thấy CUSTOMER_SK trên
DIM_PDTD_APPLICATION cũng cần xóa (không báo cáo nào dùng qua đường này). Áp dụng
xóa CUSTOMER_SK CÙNG ĐỢT với 5 dòng trên.

**Đánh số lại (đã gộp cả xóa CUSTOMER_SK):** STT 35 (EFF_DATE) → 29, STT 36
(EXP_DATE) → 30. Bảng còn lại 30 cột (từ 36, xóa 6 dòng: 5 SK + CUSTOMER_SK).

---

## 6. PDTD_DTM — Mục 4.4.1 Bảng FCT_PDTD_APPLICATION_DAILY

### GIỮ NGUYÊN 3 dòng đã có (không đổi cách tham chiếu, đã đúng)

| STT hiện tại | Tên cột | Giữ nguyên |
| --- | --- | --- |
| 4 | ORG_UNIT_SK | Giữ mô tả hiện có: "Lookup DIM_PDTD_ORG_UNIT.DIMENSION_KEY" |
| 5 | PRODUCT_SK | Giữ mô tả hiện có: "Lookup DIM_PDTD_PRODUCT.DIMENSION_KEY" |
| 6 | APPROVAL_GROUP_SK | Giữ mô tả hiện có: "Lookup DIM_PDTD_APPROVAL_GROUP.DIMENSION_KEY" |

### THÊM 2 dòng mới (chèn ngay sau APPROVAL_GROUP_SK, trước CUSTOMER_SK)

| STT | Tên cột | Ý nghĩa | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng/cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| (mới) | CHANGE_TYPE_SK | Khóa tham chiếu đến chiều loại thay đổi điều kiện tín dụng | NUMBER | 18 | Y |  | KỸ THUẬT | 1:1 từ DWH.FCT_LOS_APPLICATION_DAILY.CHANGE_TYPE_SK | BC1.CHANGE_TYPE; BC1.CHANGE_TYPE_DETAIL; BC2.CHANGE_TYPE | DA_CHOT | Khóa tới DIM_PDTD_CHANGE_TYPE. Chỉ có giá trị với hồ sơ thay đổi điều kiện phê duyệt, còn lại Unknown -1. Bổ sung theo quyết định BA ngày 2026-09-07 để đủ 5 chiều tương ứng DWH. |
| (mới) | CARD_PROMOTION_SK | Khóa tham chiếu đến chiều chương trình ưu đãi phí thẻ | NUMBER | 18 | Y |  | KỸ THUẬT | 1:1 từ DWH.FCT_LOS_APPLICATION_DAILY.CARD_PROMOTION_SK | BC1.PROMOTION_ID | DA_CHOT | Khóa tới DIM_PDTD_CARD_PROMOTION. Hồ sơ không phải thẻ hoặc không có mã dùng DIMENSION_KEY = -1. Bổ sung theo quyết định BA ngày 2026-09-07 để đủ 5 chiều tương ứng DWH. |

---

## 7. PDTD_DTM — Mục 4.4.3 Bảng FCT_PDTD_SLA_DAILY

**Không thay đổi.** Đã có sẵn đúng `PRODUCT_SK` và `APPROVAL_GROUP_SK` — đủ theo
truy vết báo cáo (BC5, BC9), không cần thêm cột nào.

---

## 8. PDTD_DTM — Mục 4.4.2 Bảng FCT_PDTD_WORKSTEP_EVENT

### THÊM 1 dòng mới (chèn ngay sau WORKSTEP_SK)

| STT | Tên cột | Ý nghĩa | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng/cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| (mới) | PRODUCT_SK | Khóa tham chiếu đến chiều sản phẩm | NUMBER | 18 | Y |  | KỸ THUẬT | 1:1 từ DWH.FCT_LOS_WORKSTEP_EVENT.PRODUCT_SK | BC9.TAT_RLOS (thành phần) | DA_CHOT | Khóa tới DIM_PDTD_PRODUCT. Bổ sung theo quyết định BA ngày 2026-09-07 để đủ chiều tương ứng DWH. |

---

## 9. PDTD_DTM — Mục 4.3.2 Bảng DIM_PDTD_APPLICATION — XÓA THÊM CUSTOMER_SK (STT 32)

**Phát hiện qua truy vết `Reports_20260907.xlsx` (toàn bộ 11 báo cáo):** không có
báo cáo nào join `DIM_PDTD_CUSTOMER` qua `DIM_PDTD_APPLICATION.CUSTOMER_SK`. Mọi
field liên quan khách hàng đều truy vết về:
- `DIM_PDTD_CUSTOMER` trực tiếp (BC1.CUSTOMER_ID, BC2.CUSTOMER_ID, BC10/BC11.CUSTOMER_ID + SHORT_NAME)
- `FCT_PDTD_APPLICATION_PARTY` (BC1/BC2/BC3/BC4.CUSTOMER_NAME, BC1.DATE_OF_BIRTH/GENDER)

Cả hai đường trên đều **không đi qua `DIM_PDTD_APPLICATION`**.

**Khác biệt với 5 SK ở mục 1–8:** không di chuyển CUSTOMER_SK xuống fact nào —
`FCT_PDTD_APPLICATION_DAILY`, `FCT_PDTD_PARTY_DOCUMENT`, `FCT_PDTD_DISBURSEMENT`
đã có sẵn CUSTOMER_SK độc lập, đúng grain của từng bảng:
- `FCT_PDTD_APPLICATION_DAILY` (grain hồ sơ): CUSTOMER_SK = khách hàng chính đại
  diện hồ sơ.
- `FCT_PDTD_PARTY_DOCUMENT` (grain người liên quan): CUSTOMER_SK = khách hàng của
  từng giấy tờ/người liên quan — đây là nguồn sự thật gốc, nơi CUSTOMER_SK được
  xác định lần đầu qua số giấy tờ.
- `FCT_PDTD_DISBURSEMENT` (grain lần giải ngân): CUSTOMER_SK = khách hàng nhận
  giải ngân tại dòng đó.

Đặt thêm CUSTOMER_SK trên `DIM_PDTD_APPLICATION` (grain hồ sơ) là bản sao trùng
lặp không cần thiết của giá trị đã có sẵn trên `FCT_PDTD_APPLICATION_DAILY` (cùng
grain WI_NAME), đồng thời che giấu câu hỏi thiết kế chưa có lời giải: hồ sơ có
nhiều người liên quan (đồng trả nợ, người đại diện pháp luật...) thì chọn CUSTOMER_SK
của người nào làm đại diện — quy tắc này KHÔNG được ghi rõ trong tài liệu.

**Áp dụng:** đã gộp vào bảng xóa 6 dòng ở mục 5 (STT 32 CUSTOMER_SK nằm cùng đợt
xóa với 5 SK kia). Không cần thao tác XÓA riêng — chỉ liệt kê lại lý do ở đây.

**Khuyến nghị riêng, không thuộc phạm vi patch docx:** trước khi chốt xóa, nên hỏi
BA quy tắc chọn CUSTOMER_SK đại diện hiện tại của `FCT_PDTD_APPLICATION_DAILY`
đang áp dụng là gì (vd lấy theo PARTY_ROLE_CODE = 'APPLICANT'?), để xác nhận cột
đó trên fact đang tính đúng — việc xóa khỏi DIM không ảnh hưởng tới rule này vì
DIM chưa từng là nơi tính, chỉ là bản sao.

---

## Tổng hợp việc cần làm khi áp vào Word

1. Mở mục 4.1.1 — xóa 5 dòng, sửa STT các dòng EFF_DATE/EXP_DATE.
2. Mở mục 4.2.1 — chèn 5 dòng mới sau LAST_USER_SK, đánh số lại STT phía sau.
3. Mở mục 4.2.3 — chèn 2 dòng mới sau APPLICATION_SK, đánh số lại STT phía sau.
4. Mở mục 4.2.2 — chèn 1 dòng mới sau APPLICATION_SK, đánh số lại STT phía sau.
5. Mở mục 4.3.2 — xóa 6 dòng (5 SK + CUSTOMER_SK, xem mục 9), sửa STT các dòng còn lại. Bảng còn 30 cột.
6. Mở mục 4.4.1 — chèn 2 dòng mới sau APPROVAL_GROUP_SK, đánh số lại STT phía sau.
7. Mục 4.4.3 — không đổi.
8. Mở mục 4.4.2 — chèn 1 dòng mới sau WORKSTEP_SK, đánh số lại STT phía sau.
9. Mục 4.3.2 — xóa thêm CUSTOMER_SK (xem mục 9 ở trên); không cần thêm ở fact nào
   vì FCT_PDTD_APPLICATION_DAILY/PARTY_DOCUMENT/DISBURSEMENT đã có sẵn.
10. Cập nhật mọi sơ đồ/diagram minh họa (nếu có) trong docx ở các mục 4.1/4.2/4.3/4.4
    để phản ánh cạnh nối mới (FCT → DIM trực tiếp, không còn DIM → DIM).
