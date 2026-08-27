# DIM_LOS_ORG_UNIT

Nguồn: xlsx sheet "DIM_LOS_ORG_UNIT" (DATAMODEL_DWH_LOS_20260826.xlsx)

- Loại bảng: DIM - danh mục
- Mô tả: Danh mục đơn vị kinh doanh khởi tạo hồ sơ, theo cách LOS ghi nhận.
- Lưu gì: Lưu mã và tên phòng giao dịch, chi nhánh và khu vực, kèm cờ loại trừ khỏi chỉ tiêu KPI.
- Grain: 1 dòng = 1 phòng giao dịch
- Khóa: DIMENSION_KEY (sequence). NK = COMPANY_CODE
- Nguồn: NG_SB_CLOS_CUST_INFO, NG_SB_RLOS_APPLICANT_GENERAL
- Báo cáo sử dụng: BC1, BC2, BC9
- Quy tắc load: (chưa khai)

| STT | Tên cột | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng nguồn | Cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | 18 | Y | PK | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Khóa thay thế, sinh từ SEQ_DIM_LOS_ORG_UNIT. Mỗi DIM có sẵn một dòng Unknown với DIMENSION_KEY = -1 và các thuộc tính để 'N/A'; mọi lookup không khớp từ fact trỏ về dòng này thay vì để NULL, để phép đếm trên fact không bị hụt. |
| 2 | COMPANY_CODE | VARCHAR2 | 50 | Y |  | 1:1 + NK | NG_SB_CLOS_CUST_INFO / NG_SB_RLOS_APPLICANT_GENERAL | COMPANY_CODE | BC1.COMPANY_CODE; BC2.COMPANY_CODE | DA_CHOT | 1:1 + KHÓA TỰ NHIÊN — Nguồn: NG_SB_CLOS_CUST_INFO.COMPANY_CODE / NG_SB_RLOS_APPLICANT_GENERAL.COMPANY_CODE. Giữ nguyên tên. Trường COMPANY_CODE của BC1 và BC2 |
| 3 | COMPANY_NAME | VARCHAR2 | 200 | N |  | 1:1 | NG_SB_CLOS_CUST_INFO / NG_SB_RLOS_APPLICANT_GENERAL | COMPANY_NAME | BC1.COMPANY_NAME; BC2.COMPANY_NAME | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_CUST_INFO.COMPANY_NAME / NG_SB_RLOS_APPLICANT_GENERAL.COMPANY_NAME. Giữ nguyên tên. Trường COMPANY_NAME của BC1 và BC2 |
| 4 | BRANCH_CODE | VARCHAR2 | 50 | N |  | 1:1 | NG_SB_CLOS_CUST_INFO / NG_SB_RLOS_APPLICANT_GENERAL | BRANCH_CODE / BRACH_CODE | BC1.BRANCH_CODE; BC2.BRANCH_CODE | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_CUST_INFO.BRANCH_CODE / NG_SB_RLOS_APPLICANT_GENERAL.BRACH_CODE (tên cột nguồn phía RLOS bị viết thiếu chữ N). Trường BRANCH_CODE của BC1 và BC2 |
| 5 | BRANCH_NAME | VARCHAR2 | 200 | N |  | 1:1 | NG_SB_CLOS_CUST_INFO / NG_SB_RLOS_APPLICANT_GENERAL | BRANCH_NAME | BC1.BRANCH_NAME; BC2.BRANCH_NAME | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_CUST_INFO.BRANCH_NAME / NG_SB_RLOS_APPLICANT_GENERAL.BRANCH_NAME. Giữ nguyên tên. Trường BRANCH_NAME của BC1 và BC2 |
| 6 | ZONE_NAME_LOS | VARCHAR2 | 100 | N |  | 1:1 | NG_SB_CLOS_CUST_INFO / NG_SB_RLOS_APPLICANT_GENERAL | ZONE | BC1.ZONE; BC2.ZONE | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_CUST_INFO.ZONE hoặc ZONEE / NG_SB_RLOS_APPLICANT_GENERAL.ZONE (đổi tên thêm hậu tố LOS). CHƯA CHỐT TÊN CỘT PHÍA CLOS: SRS ghi ZONE, metadata ghi ZONEE hai chữ E với nghĩa khu vực vùng quản lý của đơn vị xử lý. Nhiều khả năng là một cột, chờ xác nhận - xem sheet 00_Lech_tai_lieu dòng 6. Trường ZONE của BC1 và BC2. Lưu ý khu vực chuẩn của BC10 và BC11 lấy từ bảng map TMP_REF_COMPANY_REGION ở tầng datamart, không lấy cột này |
| 7 | EFF_DATE | DATE |  | Y |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Ngày bắt đầu hiệu lực của phiên bản bản ghi. Do ETL sinh khi phát hiện thuộc tính thay đổi |
| 8 | EXP_DATE | DATE |  | N |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Ngày hết hiệu lực của phiên bản. NULL = bản ghi hiện hành |
