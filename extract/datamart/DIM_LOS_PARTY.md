# DIM_LOS_PARTY

Nguồn: xlsx sheet "DIM_LOS_PARTY" (DATAMODEL_DWH_LOS_20260820.xlsx)

- Loại bảng: DIM - thực thể (SCD Type 2)
- Mô tả: Danh mục người và tổ chức liên quan tới hồ sơ tín dụng.
- Lưu gì: Lưu thông tin nhân thân và pháp lý của người vay chính, người đồng trả nợ, người đại diện theo pháp luật và khách hàng doanh nghiệp. Tách riêng khỏi hồ sơ vì một người xuất hiện ở nhiều hồ sơ và có thể giữ nhiều vai trò.
- Grain: 1 dòng = 1 phiên bản thuộc tính của 1 người hoặc 1 tổ chức
- Khóa: DIMENSION_KEY (sequence). NK = PARTY_NK - CHƯA CHỐT, xem mô tả cột
- Bảng nguồn CDC: NG_SB_RLOS_APPLICANT_GENERAL, NG_SB_RLOS_APPLICANT_DETAIL, NG_SB_RLOS_APPLICANT_IDGRID, NG_SB_RLOS_COREPAYER_GENERAL, NG_SB_RLOS_COREP_IDGRID, NG_SB_CLOS_CUST_INFO, NG_SB_CLOS_CUST_INFO_LEGAL
- Báo cáo sử dụng: BC1, BC2, BC3, BC4

| STT | Tên cột | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | 18 | Y | PK | KỸ THUẬT — Khóa thay thế, sinh từ SEQ_DIM_LOS_PARTY |
| 2 | PARTY_NK | VARCHAR2 | 200 | Y |  | CHƯA CHỐT — Khóa tự nhiên định danh một người. Đề xuất ghép ID_TYPE với ID_NUMBER đã chuẩn hóa (bỏ khoảng trắng và ký tự đặc biệt). Cần chốt quy tắc chuẩn hóa và cách xử lý khi một người đổi giấy tờ từ CMND sang CCCD. Tên và thành phần khóa điền chính thức sau khi chốt khóa nguồn và STG_LOS |
| 3 | SYSTEM_CODE | VARCHAR2 | 10 | N |  | PHÁI SINH — Hệ nguồn ghi nhận người này lần đầu, suy từ hậu tố mã hồ sơ: 'RLOS' nếu mã kết thúc bằng RLOS, 'CLOS' nếu kết thúc bằng CLOS |
| 4 | PARTY_TYPE | VARCHAR2 | 20 | N |  | PHÁI SINH — 'ORG' nếu bản ghi đến từ NG_SB_CLOS_CUST_INFO (khách hàng doanh nghiệp), 'IND' cho các trường hợp còn lại |
| 5 | FULL_NAME | VARCHAR2 | 200 | N |  | 1:1 — Nguồn: NG_SB_RLOS_APPLICANT_GENERAL.FULL_NAME / NG_SB_RLOS_COREPAYER_GENERAL.FULL_NAME / NG_SB_CLOS_CUST_INFO.CUSTOMER_NAME / NG_SB_CLOS_CUST_INFO_LEGAL.NAMEE. Giữ tên phía RLOS. Trường CUSTOMER_NAME của BC1, BC2, BC3, BC4 và CO_REPAYER, LEGAL_REPRESENTATIVE |
| 6 | DATE_OF_BIRTH | DATE |  | N |  | 1:1 — Nguồn: NG_SB_RLOS_APPLICANT_GENERAL.DOB (đổi tên cho rõ nghĩa). Trường DATE_OF_BIRTH của BC1. Lưu ý SRS hiện lấy trường này từ T24; model lấy từ LOS để không phụ thuộc T24 |
| 7 | GENDER | VARCHAR2 | 20 | N |  | 1:1 — Nguồn: NG_SB_RLOS_APPLICANT_GENERAL.GENDER. Giữ nguyên tên. Trường GENDER của BC1 |
| 8 | MARRIAGE_STATUS | VARCHAR2 | 100 | N |  | 1:1 — Nguồn: NG_SB_RLOS_APPLICANT_DETAIL.MARR_STATUS (đổi tên cho rõ nghĩa). Trường MARRIAGE_STATUS của BC1 |
| 9 | EDUCATION_LEVEL | VARCHAR2 | 100 | N |  | 1:1 — Nguồn: NG_SB_RLOS_APPLICANT_DETAIL.EDU_LEVEL (đổi tên cho rõ nghĩa). Trường EDUCATION_LEVEL của BC1 |
| 10 | VEHICLE | VARCHAR2 | 100 | N |  | 1:1 — Nguồn: NG_SB_RLOS_APPLICANT_DETAIL.VEHICLE. Giữ nguyên tên. Trường VEHICLES của BC1 |
| 11 | ID_TYPE | VARCHAR2 | 50 | N |  | 1:1 — Nguồn: NG_SB_RLOS_APPLICANT_IDGRID.ID_TYPE. Giữ nguyên tên. Loại giấy tờ tùy thân chính của người này |
| 12 | ID_NUMBER | VARCHAR2 | 100 | N |  | 1:1 — Nguồn: NG_SB_RLOS_APPLICANT_IDGRID.ID_NUMBER / NG_SB_CLOS_CUST_INFO_LEGAL.ID_NUMBER. Giữ nguyên tên |
| 13 | LEGAL_DOC | VARCHAR2 | 100 | N |  | 1:1 — Nguồn: NG_SB_CLOS_CUST_INFO_LEGAL.LEGAL_DOC. Giữ nguyên tên. Loại giấy tờ pháp lý phía CLOS |
| 14 | ORG_LEGAL_ID | VARCHAR2 | 100 | N |  | 1:1 — Nguồn: NG_SB_CLOS_CUST_INFO_LEGAL.ID_NUMBER với OBJ_TYPE là doanh nghiệp (đổi tên để phân biệt với giấy tờ cá nhân). Trường ID_NUMBER của BC2 - số ĐKKD hoặc mã số thuế |
| 15 | PERM_ADDRESS | VARCHAR2 | 500 | N |  | 1:1 — Nguồn: NG_SB_RLOS_APPLICANT_DETAIL.PERM_ADD (đổi tên cho rõ nghĩa). Trường PERMANENT_RESIDENCE_ADDRESS của BC1 |
| 16 | CURR_HOUSE_NO | VARCHAR2 | 200 | N |  | 1:1 — Nguồn: NG_SB_RLOS_APPLICANT_DETAIL.HOUSNO_CURR_RES (đổi tên cho rõ nghĩa). Thành phần của địa chỉ hiện tại đầy đủ |
| 17 | CURR_WARD | VARCHAR2 | 100 | N |  | 1:1 — Nguồn: NG_SB_RLOS_APPLICANT_DETAIL.WARD_CURR_RES (đổi tên cho rõ nghĩa). Trường CURRENT_RESIDENTIAL_WARD của BC1 |
| 18 | GEO_SK | NUMBER | 18 | N |  | KỸ THUẬT — Khóa tới DIM_LOS_GEO, lookup theo CITY_CURR_RES + DISTRICT_CURR_RES của NG_SB_RLOS_APPLICANT_DETAIL. Phục vụ CURRENT_RESIDENTIAL_CITY và CURRENT_RESIDENTIAL_DISTRICT của BC1 |
| 19 | CURR_FULL_ADDRESS | VARCHAR2 | 500 | N |  | PHÁI SINH — CURR_HOUSE_NO || ', ' || CURR_WARD || ', ' || DISTRICT_NAME || ', ' || CITY_NAME, trong đó tên quận/huyện và tỉnh/thành lấy qua GEO_SK. Trường CURRENT_RESIDENTIAL_ADDRESS của BC1 |
| 20 | EFF_DATE | DATE |  | Y |  | KỸ THUẬT — Ngày bắt đầu hiệu lực của phiên bản bản ghi. Do ETL sinh khi phát hiện thuộc tính thay đổi |
| 21 | EXP_DATE | DATE |  | N |  | KỸ THUẬT — Ngày hết hiệu lực của phiên bản. NULL = bản ghi hiện hành |
