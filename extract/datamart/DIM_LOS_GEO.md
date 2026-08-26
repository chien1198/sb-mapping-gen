# DIM_LOS_GEO

Nguồn: xlsx sheet "DIM_LOS_GEO" (DATAMODEL_DWH_LOS_20260820.xlsx)

- Loại bảng: DIM - danh mục
- Mô tả: Danh mục địa giới hành chính tỉnh/thành và quận/huyện.
- Lưu gì: Lưu mã và tên tỉnh/thành (63 bản ghi) cùng quận/huyện (710 bản ghi). Đây cũng là nơi làm sạch các giá trị lỗi #NA và #REF! mà metadata ghi nhận còn sót trong cột tên tiếng Việt của quận/huyện.
- Grain: 1 dòng = 1 quận/huyện thuộc 1 tỉnh/thành
- Khóa: DIMENSION_KEY (sequence). NK = GEO_NK
- Bảng nguồn CDC: H_NG_SB_RLOS_MAS_CITY, H_NG_SB_RLOS_MAS_DISTRICT
- Báo cáo sử dụng: BC1

| STT | Tên cột | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | 18 | Y | PK | KỸ THUẬT — Khóa thay thế, sinh từ SEQ_DIM_LOS_GEO |
| 2 | GEO_NK | VARCHAR2 | 110 | Y |  | KỸ THUẬT — Khóa tự nhiên do DWH ghép: CITY_CODE || '|' || DISTRICT_CODE. Danh sách CDC ghi hai bảng nguồn cần BA/DEV xác nhận lại khóa |
| 3 | CITY_CODE | VARCHAR2 | 50 | Y |  | 1:1 — Nguồn: H_NG_SB_RLOS_MAS_CITY.CITY_CODE. Giữ nguyên tên. Nối với NG_SB_RLOS_APPLICANT_DETAIL.CITY_CURR_RES |
| 4 | CITY_NAME | VARCHAR2 | 200 | N |  | 1:1 — Nguồn: H_NG_SB_RLOS_MAS_CITY.CITY_NAME. Giữ nguyên tên. Trường CURRENT_RESIDENTIAL_CITY của BC1 |
| 5 | CITY_NAME_VN | VARCHAR2 | 200 | N |  | 1:1 — Nguồn: H_NG_SB_RLOS_MAS_CITY.CITY_NAME_VN. Giữ nguyên tên. Tên tiếng Việt có dấu |
| 6 | DISTRICT_CODE | VARCHAR2 | 50 | N |  | 1:1 — Nguồn: H_NG_SB_RLOS_MAS_DISTRICT.DISTRICT_CODE. Giữ nguyên tên. Nối với NG_SB_RLOS_APPLICANT_DETAIL.DISTRICT_CURR_RES |
| 7 | DISTRICT_NAME | VARCHAR2 | 200 | N |  | 1:1 — Nguồn: H_NG_SB_RLOS_MAS_DISTRICT.DISTRICT_NAME. Giữ nguyên tên. Trường CURRENT_RESIDENTIAL_DISTRICT của BC1 |
| 8 | DISTRICT_NAME_VN | VARCHAR2 | 200 | N |  | PHÁI SINH — Lấy H_NG_SB_RLOS_MAS_DISTRICT.DISTRICT_NAME_VN nhưng gán NULL với các giá trị lỗi '#NA' và '#REF!' mà metadata ghi nhận còn sót từ khâu import Excel |
| 9 | EFF_DATE | DATE |  | Y |  | KỸ THUẬT — Ngày bắt đầu hiệu lực của phiên bản bản ghi. Do ETL sinh khi phát hiện thuộc tính thay đổi |
| 10 | EXP_DATE | DATE |  | N |  | KỸ THUẬT — Ngày hết hiệu lực của phiên bản. NULL = bản ghi hiện hành |
