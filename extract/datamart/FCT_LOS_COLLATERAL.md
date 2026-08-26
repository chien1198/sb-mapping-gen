# FCT_LOS_COLLATERAL

Nguồn: xlsx sheet "FCT_LOS_COLLATERAL" (DATAMODEL_DWH_LOS_20260820.xlsx)

- Loại bảng: FCT - bảng chi tiết
- Mô tả: Giá trị định giá của từng tài sản bảo đảm gắn với hồ sơ.
- Lưu gì: Lưu phần số đo biến động của tài sản: giá trị định giá và tỷ lệ cho vay. Phần mô tả tài sản nằm ở DIM_LOS_COLLATERAL. Tách như vậy để tài sản được định giá lại chỉ sinh một dòng số đo mới chứ không bị hiểu nhầm thành một tài sản mới - đúng lỗi mà cách đánh khóa hiện tại ở nguồn đang gây ra.
- Grain: 1 dòng = 1 tài sản bảo đảm x 1 ngày dữ liệu
- Khóa: PK = DAYID + WI_NAME + COLLATERAL_BK
- Quy tắc ghi: Ghi khi tài sản mới xuất hiện hoặc giá trị định giá thay đổi.
- Bảng nguồn CDC: NG_SB_RLOS_COL_REALESTATE, NG_SB_RLOS_COL_TRANSPORT, NG_SB_RLOS_COL_VALPAPER, NG_SB_RLOS_COL_OTHER, NG_SB_CLOS_COLL_CD
- Báo cáo sử dụng: BC1, BC2, BC3, BC9

| STT | Tên cột | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | NUMBER | 8 | Y | PK | KỸ THUẬT — Ngày dữ liệu dạng YYYYMMDD |
| 2 | WI_NAME | VARCHAR2 | 100 | Y | PK | 1:1 — Mã hồ sơ mà tài sản được thế chấp cho. Nguồn: WI_NAME của các bảng tài sản |
| 3 | COLLATERAL_BK | VARCHAR2 | 300 | Y | PK | CHƯA CHỐT — Khóa nghiệp vụ định danh một tài sản trong hồ sơ. Ba bảng RLOS đã chốt khóa (WI_NAME + NO_CERTI cho bất động sản, + CONTROL_POSTER cho phương tiện, + NUMBERSIGN cho giấy tờ có giá). COL_OTHER và CLOS_COLL_CD chưa có; danh sách CDC đang hỏi BA/DEV về việc dùng RECID. Ràng buộc bắt buộc: KHÔNG đưa giá trị định giá hay tỷ lệ LTV vào khóa. Điền chính thức sau khi chốt khóa nguồn và STG_LOS |
| 4 | COLLATERAL_SK | NUMBER | 18 | N |  | KỸ THUẬT — Khóa tới DIM_LOS_COLLATERAL, phần mô tả của tài sản |
| 5 | APPLICATION_SK | NUMBER | 18 | Y |  | KỸ THUẬT — Khóa tới DIM_LOS_APPLICATION |
| 6 | COLLATERAL_TYPE_SK | NUMBER | 18 | N |  | KỸ THUẬT — Khóa tới DIM_LOS_COLLATERAL_TYPE |
| 7 | SYSTEM_CODE | VARCHAR2 | 10 | Y |  | PHÁI SINH — Suy từ hậu tố mã hồ sơ: 'RLOS' nếu WI_NAME kết thúc bằng RLOS, 'CLOS' nếu kết thúc bằng CLOS |
| 8 | IS_CURRENT_ROW | VARCHAR2 | 1 | Y |  | KỸ THUẬT — 'Y' trên dòng mới nhất của mỗi tài sản |
| 9 | COLL_TYPE_CODE | VARCHAR2 | 100 | N |  | 1:1 — Nguồn: NG_SB_CLOS_COLL_CD.COLLTYPE phía CLOS; phía RLOS gán theo bảng tài sản mà bản ghi đến từ đó. Trường Types of Collaterals của BC3 |
| 10 | COLL_SEQ | NUMBER | 4 | N |  | PHÁI SINH — ROW_NUMBER() OVER (PARTITION BY WI_NAME, COLL_TYPE_CODE ORDER BY khóa nguồn). Do DWH sinh để phân biệt các tài sản cùng loại trong một hồ sơ |
| 11 | APPRAISED_VALUE | NUMBER | 20,2 | N |  | 1:1 — Nguồn: NG_SB_CLOS_COLL_CD.APPRAISED_VAL_FIG phía CLOS; PRICING_VALUE của COL_REALESTATE hoặc PRICINGVALUE của ba bảng tài sản RLOS còn lại (đổi tên để dùng chung hai hệ). Ép kiểu số từ text. Trường Appraised Value của BC3 |
| 12 | LOAN_RATE_LTV | NUMBER | 5,2 | N |  | 1:1 — Nguồn: NG_SB_CLOS_COLL_CD.LTV phía CLOS; LOANRATE của 4 bảng tài sản RLOS (đổi tên để dùng chung hai hệ). Ép kiểu số từ text, đơn vị phần trăm. Trường LTV của BC3 |
| 13 | APPRAISED_VALUE_RAW | VARCHAR2 | 200 | N |  | 1:1 — Nguồn: NG_SB_CLOS_COLL_CD.APPRAISED_VAL_FIG / PRICING_VALUE của COL_REALESTATE / PRICINGVALUE của ba bảng tài sản RLOS còn lại, giữ nguyên văn dạng text trước khi ép kiểu. Cần giữ vì metadata ghi nhận nguồn lưu số tiền dưới dạng chuỗi không chuẩn hóa |
| 14 | LTV_RAW | VARCHAR2 | 200 | N |  | 1:1 — Nguồn: NG_SB_CLOS_COLL_CD.LTV / LOANRATE của 4 bảng tài sản RLOS, giữ nguyên văn. Cần giữ vì metadata ghi nhận nguồn có cả giá trị phần trăm lẫn mô tả điều kiện áp dụng bằng chữ |
