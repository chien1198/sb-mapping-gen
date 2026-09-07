# DIM_LOS_ORG_UNIT

Nguồn: xlsx sheet "DIM_LOS_ORG_UNIT" (DATAMODEL_DWH_LOS_20260903.xlsx)

- Loại bảng: DIM - danh mục
- Mô tả: Danh mục đơn vị kinh doanh khởi tạo hồ sơ, theo cách LOS ghi nhận.
- Lưu gì: Lưu mã và tên phòng giao dịch, chi nhánh và khu vực, kèm cờ loại trừ khỏi chỉ tiêu KPI.
- Grain: 1 dòng = 1 phòng giao dịch
- Khóa: DIMENSION_KEY (sequence). NK = COMPANY_CODE
- Nguồn: NG_SB_CLOS_CUST_INFO, NG_SB_RLOS_APPLICANT_GENERAL
- Báo cáo sử dụng: BC1, BC2, BC9
- Quy tắc load: SCD TYPE 2. Đọc ảnh nguồn tại cutoff của ngày :P_DATE theo đúng quy trình A hoặc B của bảng nguồn (xem 00_Phan_loai_nguon), rồi so khớp theo khóa tự nhiên: bản ghi chưa có thì INSERT với EFF_DATE = :P_DATE và EXP_DATE để trống; thuộc tính đổi thì đóng bản đang hiệu lực bằng EXP_DATE = :P_DATE - 1 rồi mở bản mới; không đổi thì không làm gì. DIMENSION_KEY sinh bằng Oracle sequence, không tái sử dụng. Bản ghi biến mất khỏi nguồn KHÔNG bị xóa và KHÔNG bị đóng: giữ nguyên để fact của ngày cũ vẫn tra được tên. Chạy lại ngày D: xóa các bản có EFF_DATE = D, mở lại các bản bị đóng bằng EXP_DATE = D - 1, rồi nạp lại.

| STT | Tên cột | Ý nghĩa | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng nguồn | Cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | Khóa tự sinh của bảng chiều | NUMBER | 18 | Y | PK | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — khóa tự sinh, sinh từ SEQ_DIM_LOS_ORG_UNIT. Mỗi DIM có sẵn một dòng Unknown với DIMENSION_KEY = -1 và các thuộc tính để 'N/A'; mọi lookup không khớp từ fact trỏ về dòng này thay vì để NULL, để phép đếm trên fact không bị hụt. |
| 2 | COMPANY_CODE | Mã đơn vị kinh doanh | VARCHAR2 | 50 | Y |  | 1:1 + NK | NG_SB_CLOS_CUST_INFO / NG_SB_RLOS_APPLICANT_GENERAL | COMPANY_CODE | BC1.COMPANY_CODE; BC2.COMPANY_CODE | DA_CHOT | 1:1 + KHÓA TỰ NHIÊN — Nguồn: NG_SB_CLOS_CUST_INFO.COMPANY_CODE / NG_SB_RLOS_APPLICANT_GENERAL.COMPANY_CODE. Giữ nguyên tên. Trường COMPANY_CODE của BC1 và BC2 |
| 3 | COMPANY_NAME | Tên đơn vị kinh doanh | VARCHAR2 | 200 | N |  | 1:1 | NG_SB_CLOS_CUST_INFO / NG_SB_RLOS_APPLICANT_GENERAL | COMPANY_NAME | BC1.COMPANY_NAME; BC2.COMPANY_NAME | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_CUST_INFO.COMPANY_NAME / NG_SB_RLOS_APPLICANT_GENERAL.COMPANY_NAME. Giữ nguyên tên. Trường COMPANY_NAME của BC1 và BC2 |
| 4 | BRANCH_CODE | Mã chi nhánh | VARCHAR2 | 50 | N |  | 1:1 | NG_SB_CLOS_CUST_INFO / NG_SB_RLOS_APPLICANT_GENERAL | BRANCH_CODE / BRACH_CODE | BC1.BRANCH_CODE; BC2.BRANCH_CODE | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_CUST_INFO.BRANCH_CODE / NG_SB_RLOS_APPLICANT_GENERAL.BRACH_CODE (tên cột nguồn phía RLOS bị viết thiếu chữ N). Trường BRANCH_CODE của BC1 và BC2 |
| 5 | BRANCH_NAME | Tên chi nhánh | VARCHAR2 | 200 | N |  | 1:1 | NG_SB_CLOS_CUST_INFO / NG_SB_RLOS_APPLICANT_GENERAL | BRANCH_NAME | BC1.BRANCH_NAME; BC2.BRANCH_NAME | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_CUST_INFO.BRANCH_NAME / NG_SB_RLOS_APPLICANT_GENERAL.BRANCH_NAME. Giữ nguyên tên. Trường BRANCH_NAME của BC1 và BC2 |
| 6 | ZONE_NAME_LOS | Tên khu vực theo LOS | VARCHAR2 | 100 | N |  | 1:1 | NG_SB_CLOS_CUST_INFO / NG_SB_RLOS_APPLICANT_GENERAL | ZONE | BC1.ZONE; BC2.ZONE | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_CUST_INFO.ZONE hoặc ZONEE / NG_SB_RLOS_APPLICANT_GENERAL.ZONE (đổi tên thêm hậu tố LOS). CHƯA CHỐT TÊN CỘT PHÍA CLOS: SRS ghi ZONE, metadata ghi ZONEE hai chữ E với nghĩa khu vực vùng quản lý của đơn vị xử lý. Nhiều khả năng là một cột, chờ xác nhận - xem sheet 00_Van_de_can_chot dòng 6. Trường ZONE của BC1 và BC2. Lưu ý khu vực chuẩn của BC10 và BC11 lấy từ bảng map TMP_REF_COMPANY_REGION ở tầng datamart, không lấy cột này |
| 7 | EFF_DATE | Ngày bắt đầu hiệu lực của phiên bản bản ghi | DATE |  | Y |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Ngày bắt đầu hiệu lực của phiên bản bản ghi. Do ETL sinh khi phát hiện thuộc tính thay đổi |
| 8 | EXP_DATE | Ngày hết hiệu lực của phiên bản, để trống là bản ghi hiện hành | DATE |  | N |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Ngày hết hiệu lực của phiên bản. NULL = bản ghi hiện hành |
