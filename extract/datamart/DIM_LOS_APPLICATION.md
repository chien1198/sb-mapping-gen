# DIM_LOS_APPLICATION

Nguồn: xlsx sheet "DIM_LOS_APPLICATION" (DATAMODEL_DWH_LOS_20260820.xlsx)

- Loại bảng: DIM - thực thể (SCD Type 2)
- Mô tả: Danh mục hồ sơ tín dụng của cả hai hệ CLOS và RLOS, hợp nhất về một danh tính duy nhất.
- Lưu gì: Lưu thuộc tính mô tả của hồ sơ theo thời gian: hệ nguồn, sản phẩm, đơn vị khởi tạo, cán bộ phụ trách, luồng và cấp phê duyệt, chính sách, chương trình. Mỗi lần một thuộc tính đổi (ví dụ hồ sơ được bàn giao sang cán bộ khác) sinh một phiên bản mới thay vì ghi đè.
- Grain: 1 dòng = 1 phiên bản thuộc tính của 1 hồ sơ
- Khóa: DIMENSION_KEY (sequence). NK = WI_NAME. UNIQUE (WI_NAME, EFF_DATE)
- Bảng nguồn CDC: NG_SB_CLOS_CUST_INFO, NG_SB_CLOS_APPROVAL, NG_SB_CLOS_EXTTABLE, NG_SB_CLOS_CHANGEREQ, NG_SB_RLOS_APPLICANT_GENERAL, NG_SB_RLOS_APPLICANT_DETAIL, NG_SB_RLOS_APPROVAL, NG_SB_RLOS_EXTTABLE
- Báo cáo sử dụng: BC1, BC2, BC3, BC4, BC5, BC6, BC7, BC8, BC9, BC10, BC11

| STT | Tên cột | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | 18 | Y | PK | KỸ THUẬT — Khóa thay thế, sinh từ SEQ_DIM_LOS_APPLICATION |
| 2 | WI_NAME | VARCHAR2 | 100 | Y |  | 1:1 — Mã hồ sơ. Nguồn: NG_SB_RLOS_APPLICANT_GENERAL.WI_NAME / NG_SB_CLOS_CUST_INFO.WI_NAME (bảng ENTRY_EXIT gọi cùng giá trị này là WINAME). Giữ nguyên tên cột nguồn WI_NAME |
| 3 | SYSTEM_CODE | VARCHAR2 | 10 | Y |  | PHÁI SINH — CASE WHEN WI_NAME LIKE '%RLOS' THEN 'RLOS' WHEN WI_NAME LIKE '%CLOS' THEN 'CLOS' END. Chính là trường SYSTEMNAME của BC3, BC4, BC5 |
| 4 | LOANCASEID | VARCHAR2 | 100 | N |  | 1:1 — Nguồn: NG_SB_CLOS_EXTTABLE.LOANCASEID / NG_SB_RLOS_EXTTABLE.LOANCASEID. Giữ nguyên tên |
| 5 | ROOT_WI_NAME | VARCHAR2 | 100 | N |  | PHÁI SINH — MIN(WI_NAME) OVER (PARTITION BY LOANCASEID). Các hồ sơ con sinh sau phê duyệt mang chung LOANCASEID với hồ sơ gốc, hồ sơ gốc là bản ghi có mã nhỏ nhất. Chính là trường APPROVAL_WINAME_LOS của BC11 |
| 6 | PRODUCT_SK | NUMBER | 18 | N |  | KỸ THUẬT — Khóa tới DIM_LOS_PRODUCT (sản phẩm chính), lookup theo SYSTEM_CODE + PRODUCT_LINE + SUB_PRODUCT của nguồn |
| 7 | ORG_UNIT_SK | NUMBER | 18 | N |  | KỸ THUẬT — Khóa tới DIM_LOS_ORG_UNIT, lookup theo COMPANY_CODE của nguồn |
| 8 | APPROVAL_GROUP_SK | NUMBER | 18 | N |  | KỸ THUẬT — Khóa tới DIM_LOS_APPROVAL_GROUP, lookup theo APP_GRP của nguồn |
| 9 | CHANGE_TYPE_SK | NUMBER | 18 | N |  | KỸ THUẬT — Khóa tới DIM_LOS_CHANGE_TYPE. Chỉ có giá trị với hồ sơ thay đổi điều kiện phê duyệt |
| 10 | STREAM | VARCHAR2 | 200 | N |  | 1:1 — Nguồn: NG_SB_CLOS_APPROVAL.STREAM / NG_SB_RLOS_APPROVAL.STREAM. Giữ nguyên tên. Trường STREAM của BC1, BC2, BC3 |
| 11 | APPROVAL_TYPE | VARCHAR2 | 200 | N |  | 1:1 — Nguồn: NG_SB_CLOS_APPROVAL.STREAM đọc theo nghĩa luồng phê duyệt tại bước kiểm soát nhập liệu. Trường APPROVAL_TYPE của BC2 |
| 12 | CHANGE_REQUEST | VARCHAR2 | 200 | N |  | 1:1 — Nguồn: NG_SB_CLOS_CHANGEREQ.CHANGE_REQUEST / NG_SB_RLOS_EXTTABLE.REQ_TYPE. Giữ nguyên tên phía CLOS. Trường CHANGE_REQUEST của BC1, BC2 |
| 13 | CREDIT_PROFILE | VARCHAR2 | 50 | N |  | 1:1 — Nguồn: NG_SB_CLOS_EXTTABLE.CREDIT_PROFILE. Giữ nguyên tên. Trường CAP_TIN_DUNG của BC2 (tư vấn tín dụng TVTD hay cấp tín dụng CTD) |
| 14 | CUST_GROUP | VARCHAR2 | 100 | N |  | 1:1 — Nguồn: NG_SB_CLOS_CUST_INFO.CUST_GROUP. Giữ nguyên tên. Trường CUST_GROUP của BC2 và BC11 |
| 15 | INDUSTRY_LVL1_CODE | VARCHAR2 | 200 | N |  | 1:1 — Nguồn: NG_SB_CLOS_CUST_INFO.INDUSTRY_CODE_LEVEL_1 (đổi tên cho ngắn). Trường INDUSTRY_GROUP của BC2 |
| 16 | INDUSTRY_LVL2_CODE | VARCHAR2 | 200 | N |  | 1:1 — Nguồn: NG_SB_CLOS_CUST_INFO.INDUSTRY_CODE_LEVEL_2 (đổi tên cho ngắn). Trường INDUSTRY_CLASS của BC2 |
| 17 | INDUSTRY_LVL3_CODE | VARCHAR2 | 200 | N |  | 1:1 — Nguồn: NG_SB_CLOS_CUST_INFO.INDUSTRY_CODE_LEVEL_3 (đổi tên cho ngắn). Trường INDUSTRY của BC2 |
| 18 | POLICY | VARCHAR2 | 200 | N |  | 1:1 — Nguồn: NG_SB_RLOS_APPLICANT_GENERAL.POLICY. Giữ nguyên tên. Trường POLICY của BC1 |
| 19 | CAMPAIGN | VARCHAR2 | 200 | N |  | 1:1 — Nguồn: NG_SB_RLOS_APPLICANT_GENERAL.CAMPAIGN. Giữ nguyên tên. Trường CAMPAIGN của BC1 |
| 20 | PROOF_OF_INCOME | VARCHAR2 | 200 | N |  | PHÁI SINH — CASE WHEN NG_SB_RLOS_APPLICANT_GENERAL.PROOF_OF_INCOME = 'proofincome01' THEN 'CHUNGTU_CHUNGMINH_THUNHAP' WHEN = 'proofincome02' THEN 'BANGKE_THUNHAP' END. Trường PROOF_OF_INCOME của BC1 |
| 21 | CUS_SEGMENT | VARCHAR2 | 100 | N |  | 1:1 — Nguồn: NG_SB_RLOS_APPLICANT_DETAIL.CUS_SEGMENT. Giữ nguyên tên và giữ nguyên giá trị gốc, chưa chuẩn hóa |
| 22 | BI_CUS_SEGMENT | VARCHAR2 | 50 | N |  | PHÁI SINH — CASE WHEN UPPER(CUS_SEGMENT) LIKE '%XANH' THEN 'XANH' WHEN CUS_SEGMENT = 'CBNV' THEN 'CBNV' ELSE 'THUONG' END. Trường BI_CUS_SEGMENT của BC1 |
| 23 | COLL_REQUIRE | VARCHAR2 | 10 | N |  | PHÁI SINH — CASE WHEN NG_SB_RLOS_APPLICANT_GENERAL.COLLREQUIRE = 'true' THEN 'YES' ELSE 'NO' END. Chuẩn hóa từ true/false sang YES/NO đúng cách BC5 dùng để tra cam kết SLA |
| 24 | IS_SEC_PRODUCT | VARCHAR2 | 10 | N |  | 1:1 — Nguồn: NG_SB_RLOS_APPLICANT_GENERAL.IS_SEC_PRODUCT. Giữ nguyên tên. Trường SECONDARY_PRODUCTLINE của BC1; BC5 dùng để cộng thêm thời gian SLA khi hồ sơ có sản phẩm phụ |
| 25 | DEVIATION_FLAG | VARCHAR2 | 10 | N |  | 1:1 — Nguồn: NG_SB_RLOS_APPLICANT_GENERAL.DEVIATION_FLAG. Giữ nguyên tên. Trường DEVIATION của BC1 |
| 26 | EMPLOYEE_CODE | VARCHAR2 | 50 | N |  | 1:1 — Nguồn: NG_SB_RLOS_APPLICANT_GENERAL.EMPLOYEE_CODE / NG_SB_CLOS_CUST_INFO.EMP_CODE. Giữ tên phía RLOS. Trường EMPLOYEE_CODE của BC1 và BC2 |
| 27 | EMPLOYEE_NAME | VARCHAR2 | 200 | N |  | 1:1 — Nguồn: NG_SB_RLOS_APPLICANT_GENERAL.EMPLOYEE_NAME / NG_SB_CLOS_CUST_INFO.EMP_NAME. Giữ tên phía RLOS. Trường EMPLOYEE_NAME của BC1 và BC2 |
| 28 | CREATION_DATE | DATE |  | N |  | PHÁI SINH — MIN(ENTRYDATE) theo WI_NAME trên bảng ENTRY_EXIT, TRUNC về ngày. Trường CREATION_DATE của BC1 và BC2 |
| 29 | EFF_DATE | DATE |  | Y |  | KỸ THUẬT — Ngày bắt đầu hiệu lực của phiên bản bản ghi. Do ETL sinh khi phát hiện thuộc tính thay đổi |
| 30 | EXP_DATE | DATE |  | N |  | KỸ THUẬT — Ngày hết hiệu lực của phiên bản. NULL = bản ghi hiện hành |
