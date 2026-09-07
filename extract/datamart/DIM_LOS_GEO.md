# DIM_LOS_GEO

Nguồn: xlsx sheet "DIM_LOS_GEO" (DATAMODEL_DWH_LOS_20260903.xlsx)

- Loại bảng: DIM - danh mục
- Mô tả: Danh mục địa giới hành chính tỉnh/thành và quận/huyện.
- Lưu gì: Lưu mã và tên tỉnh/thành (63 bản ghi) cùng quận/huyện (710 bản ghi). Đây cũng là nơi làm sạch các giá trị lỗi #NA và #REF! mà metadata ghi nhận còn sót trong cột tên tiếng Việt của quận/huyện.
- Grain: 1 dòng = 1 quận/huyện thuộc 1 tỉnh/thành
- Khóa: PK = DIMENSION_KEY (Oracle sequence). UNIQUE (CITY_CODE, DISTRICT_CODE, EFF_DATE) — dùng thẳng tổ hợp cột tự nhiên, KHÔNG sinh cột GEO_NK ghép chuỗi: các cột thành phần đã có sẵn trên bảng nên cột ghép chỉ nhân bản dữ liệu và phải giữ đồng bộ.
- Nguồn: H_NG_SB_RLOS_MAS_CITY, H_NG_SB_RLOS_MAS_DISTRICT
- Báo cáo sử dụng: BC1
- Quy tắc load: SCD TYPE 2. Đọc ảnh nguồn tại cutoff của ngày :P_DATE theo đúng quy trình A hoặc B của bảng nguồn (xem 00_Phan_loai_nguon), rồi so khớp theo khóa tự nhiên: bản ghi chưa có thì INSERT với EFF_DATE = :P_DATE và EXP_DATE để trống; thuộc tính đổi thì đóng bản đang hiệu lực bằng EXP_DATE = :P_DATE - 1 rồi mở bản mới; không đổi thì không làm gì. DIMENSION_KEY sinh bằng Oracle sequence, không tái sử dụng. Bản ghi biến mất khỏi nguồn KHÔNG bị xóa và KHÔNG bị đóng: giữ nguyên để fact của ngày cũ vẫn tra được tên. Chạy lại ngày D: xóa các bản có EFF_DATE = D, mở lại các bản bị đóng bằng EXP_DATE = D - 1, rồi nạp lại.

| STT | Tên cột | Ý nghĩa | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng nguồn | Cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | Khóa tự sinh của bảng chiều | NUMBER | 18 | Y | PK | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — khóa tự sinh, sinh từ SEQ_DIM_LOS_GEO. Mỗi DIM có sẵn một dòng Unknown với DIMENSION_KEY = -1 và các thuộc tính để 'N/A'; mọi lookup không khớp từ fact trỏ về dòng này thay vì để NULL, để phép đếm trên fact không bị hụt. |
| 2 | CITY_CODE | Mã tỉnh thành | VARCHAR2 | 50 | Y |  | 1:1 | H_NG_SB_RLOS_MAS_CITY | CITY_CODE | (khóa nối) | DA_CHOT | 1:1 — Nguồn: H_NG_SB_RLOS_MAS_CITY.CITY_CODE. Giữ nguyên tên. Nối với NG_SB_RLOS_APPLICANT_DETAIL.CITY_CURR_RES |
| 3 | CITY_NAME | Tên tỉnh thành | VARCHAR2 | 200 | N |  | 1:1 | H_NG_SB_RLOS_MAS_CITY | CITY_NAME | BC1.CURRENT_RESIDENTIAL_CITY | DA_CHOT | 1:1 — Nguồn: H_NG_SB_RLOS_MAS_CITY.CITY_NAME. Giữ nguyên tên. Trường CURRENT_RESIDENTIAL_CITY của BC1 |
| 4 | CITY_NAME_VN | Tên tỉnh thành tiếng Việt có dấu | VARCHAR2 | 200 | N |  | 1:1 | H_NG_SB_RLOS_MAS_CITY | CITY_NAME_VN | (thành phần BC1.CURRENT_RESIDENTIAL_ADDRESS) | DA_CHOT | 1:1 — Nguồn: H_NG_SB_RLOS_MAS_CITY.CITY_NAME_VN. Giữ nguyên tên. Tên tiếng Việt có dấu |
| 5 | DISTRICT_CODE | Mã quận huyện | VARCHAR2 | 50 | N |  | 1:1 | H_NG_SB_RLOS_MAS_DISTRICT | DISTRICT_CODE | (khóa nối) | DA_CHOT | 1:1 — Nguồn: H_NG_SB_RLOS_MAS_DISTRICT.DISTRICT_CODE. Giữ nguyên tên. Nối với NG_SB_RLOS_APPLICANT_DETAIL.DISTRICT_CURR_RES |
| 6 | DISTRICT_NAME | Tên quận huyện | VARCHAR2 | 200 | N |  | 1:1 | H_NG_SB_RLOS_MAS_DISTRICT | DISTRICT_NAME | BC1.CURRENT_RESIDENTIAL_DISTRICT | DA_CHOT | 1:1 — Nguồn: H_NG_SB_RLOS_MAS_DISTRICT.DISTRICT_NAME. Giữ nguyên tên. Trường CURRENT_RESIDENTIAL_DISTRICT của BC1 |
| 7 | DISTRICT_NAME_VN | Tên quận huyện tiếng Việt có dấu | VARCHAR2 | 200 | N |  | PHÁI SINH |  |  | (thành phần BC1.CURRENT_RESIDENTIAL_ADDRESS) | DA_CHOT | PHÁI SINH — Lấy H_NG_SB_RLOS_MAS_DISTRICT.DISTRICT_NAME_VN nhưng gán NULL với các giá trị lỗi '#NA' và '#REF!' mà metadata ghi nhận còn sót từ khâu import Excel |
| 8 | EFF_DATE | Ngày bắt đầu hiệu lực của phiên bản bản ghi | DATE |  | Y |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Ngày bắt đầu hiệu lực của phiên bản bản ghi. Do ETL sinh khi phát hiện thuộc tính thay đổi |
| 9 | EXP_DATE | Ngày hết hiệu lực của phiên bản, để trống là bản ghi hiện hành | DATE |  | N |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Ngày hết hiệu lực của phiên bản. NULL = bản ghi hiện hành |
