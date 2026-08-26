# DIM_LOS_USER

Nguồn: xlsx sheet "DIM_LOS_USER" (DATAMODEL_DWH_LOS_20260820.xlsx)

- Loại bảng: DIM - danh mục
- Mô tả: Danh mục tài khoản người dùng xử lý hồ sơ trên workflow.
- Lưu gì: Lưu tên đăng nhập của cán bộ xử lý ở mọi bước, kèm cờ tài khoản test để mọi báo cáo dùng chung một quy tắc loại trừ.
- Grain: 1 dòng = 1 tài khoản người dùng
- Khóa: DIMENSION_KEY (sequence). NK = USERNAME
- Bảng nguồn CDC: NG_SB_CLOS_ENTRY_EXIT, NG_SB_RLOS_ENTRY_EXIT
- Báo cáo sử dụng: BC1, BC2, BC3, BC4, BC7, BC8, BC9

| STT | Tên cột | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | 18 | Y | PK | KỸ THUẬT — Khóa thay thế, sinh từ SEQ_DIM_LOS_USER |
| 2 | USERNAME | VARCHAR2 | 100 | Y |  | 1:1 + KHÓA TỰ NHIÊN — Nguồn: NG_SB_CLOS_ENTRY_EXIT.USERNAME / NG_SB_RLOS_ENTRY_EXIT.USERNAME. Giữ nguyên tên. Là giá trị hiển thị ở toàn bộ các trường user của BC1, BC2, BC3, BC4 |
| 3 | IS_TEST_ACCOUNT | VARCHAR2 | 1 | N |  | PHÁI SINH — 'Y' nếu USERNAME thuộc danh sách tài khoản test do nghiệp vụ chốt, hiện có hanh.nh2. BC9 loại tài khoản này ở bốn chỗ khác nhau |
| 4 | EFF_DATE | DATE |  | Y |  | KỸ THUẬT — Ngày bắt đầu hiệu lực của phiên bản bản ghi. Do ETL sinh khi phát hiện thuộc tính thay đổi |
| 5 | EXP_DATE | DATE |  | N |  | KỸ THUẬT — Ngày hết hiệu lực của phiên bản. NULL = bản ghi hiện hành |
