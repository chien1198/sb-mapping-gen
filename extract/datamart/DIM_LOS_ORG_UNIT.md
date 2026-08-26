# DIM_LOS_ORG_UNIT

Nguồn: xlsx sheet "DIM_LOS_ORG_UNIT" (DATAMODEL_DWH_LOS_20260820.xlsx)

- Loại bảng: DIM - danh mục
- Mô tả: Danh mục đơn vị kinh doanh khởi tạo hồ sơ, theo cách LOS ghi nhận.
- Lưu gì: Lưu mã và tên phòng giao dịch, chi nhánh và khu vực, kèm cờ loại trừ khỏi chỉ tiêu KPI.
- Grain: 1 dòng = 1 phòng giao dịch
- Khóa: DIMENSION_KEY (sequence). NK = COMPANY_CODE
- Bảng nguồn CDC: NG_SB_CLOS_CUST_INFO, NG_SB_RLOS_APPLICANT_GENERAL
- Báo cáo sử dụng: BC1, BC2, BC9

| STT | Tên cột | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | 18 | Y | PK | KỸ THUẬT — Khóa thay thế, sinh từ SEQ_DIM_LOS_ORG_UNIT |
| 2 | COMPANY_CODE | VARCHAR2 | 50 | Y |  | 1:1 + KHÓA TỰ NHIÊN — Nguồn: NG_SB_CLOS_CUST_INFO.COMPANY_CODE / NG_SB_RLOS_APPLICANT_GENERAL.COMPANY_CODE. Giữ nguyên tên. Trường COMPANY_CODE của BC1 và BC2 |
| 3 | COMPANY_NAME | VARCHAR2 | 200 | N |  | 1:1 — Nguồn: NG_SB_CLOS_CUST_INFO.COMPANY_NAME / NG_SB_RLOS_APPLICANT_GENERAL.COMPANY_NAME. Giữ nguyên tên. Trường COMPANY_NAME của BC1 và BC2 |
| 4 | BRANCH_CODE | VARCHAR2 | 50 | N |  | 1:1 — Nguồn: NG_SB_CLOS_CUST_INFO.BRANCH_CODE / NG_SB_RLOS_APPLICANT_GENERAL.BRACH_CODE (tên cột nguồn phía RLOS bị viết thiếu chữ N). Trường BRANCH_CODE của BC1 và BC2 |
| 5 | BRANCH_NAME | VARCHAR2 | 200 | N |  | 1:1 — Nguồn: NG_SB_CLOS_CUST_INFO.BRANCH_NAME / NG_SB_RLOS_APPLICANT_GENERAL.BRANCH_NAME. Giữ nguyên tên. Trường BRANCH_NAME của BC1 và BC2 |
| 6 | ZONE_NAME_LOS | VARCHAR2 | 100 | N |  | 1:1 — Nguồn: NG_SB_CLOS_CUST_INFO.ZONE / NG_SB_RLOS_APPLICANT_GENERAL.ZONE (đổi tên thêm hậu tố LOS). Trường ZONE của BC1 và BC2. Lưu ý khu vực chuẩn của BC10 và BC11 lấy từ bảng map TMP_REF_COMPANY_REGION ở tầng datamart, không lấy cột này |
| 7 | IS_EXCLUDED_KPI | VARCHAR2 | 1 | N |  | PHÁI SINH — 'Y' nếu COMPANY_CODE thuộc ('VN0010401','VN0010101','VN0010002'). BC9 loại ba đơn vị này khỏi chỉ tiêu số lượng hồ sơ duyệt và giải ngân |
| 8 | EFF_DATE | DATE |  | Y |  | KỸ THUẬT — Ngày bắt đầu hiệu lực của phiên bản bản ghi. Do ETL sinh khi phát hiện thuộc tính thay đổi |
| 9 | EXP_DATE | DATE |  | N |  | KỸ THUẬT — Ngày hết hiệu lực của phiên bản. NULL = bản ghi hiện hành |
