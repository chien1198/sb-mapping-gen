# DIM_LOS_COLLATERAL_TYPE

Nguồn: xlsx sheet "DIM_LOS_COLLATERAL_TYPE" (DATAMODEL_DWH_LOS_20260826.xlsx)

- Loại bảng: DIM - danh mục
- Mô tả: Danh mục loại tài sản bảo đảm đã chuẩn hóa.
- Lưu gì: Lưu mã loại tài sản của từng hệ và nhóm tài sản chuẩn dùng chung. BC2 hiện sinh 9 cột cờ bằng 9 câu CASE so chuỗi tiếng Việt không dấu trên 11 giá trị COLLTYPE; chuẩn hóa về nhóm ở đây giúp thêm một loại tài sản không phải sửa báo cáo.
- Grain: 1 dòng = 1 loại tài sản bảo đảm của 1 hệ nguồn
- Khóa: DIMENSION_KEY (sequence). NK = COLLATERAL_TYPE_NK
- Nguồn: NG_SB_CLOS_COLL_CD, NG_SB_RLOS_COL_REALESTATE, NG_SB_RLOS_COL_TRANSPORT, NG_SB_RLOS_COL_VALPAPER, NG_SB_RLOS_COL_OTHER
- Báo cáo sử dụng: BC1, BC2, BC3, BC9
- Quy tắc load: (chưa khai)

| STT | Tên cột | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng nguồn | Cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | 18 | Y | PK | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Khóa thay thế, sinh từ SEQ_DIM_LOS_COLLATERAL_TYPE. Mỗi DIM có sẵn một dòng Unknown với DIMENSION_KEY = -1 và các thuộc tính để 'N/A'; mọi lookup không khớp từ fact trỏ về dòng này thay vì để NULL, để phép đếm trên fact không bị hụt. |
| 2 | COLLATERAL_TYPE_NK | VARCHAR2 | 120 | Y |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Khóa tự nhiên do DWH ghép: SYSTEM_CODE || '|' || COLLATERAL_TYPE_CODE |
| 3 | SYSTEM_CODE | VARCHAR2 | 10 | Y |  | PHÁI SINH |  |  |  | DA_CHOT | PHÁI SINH — Hệ nguồn của bản ghi danh mục, gán theo bảng mà giá trị được lấy ra: 'CLOS' hoặc 'RLOS'. Bắt buộc nằm trong khóa tự nhiên vì hai hệ có thể dùng trùng mã cho hai nghĩa khác nhau |
| 4 | COLLATERAL_TYPE_CODE | VARCHAR2 | 100 | Y |  | 1:1 | NG_SB_CLOS_COLL_CD | COLLTYPE | BC3.Types of Collaterals | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_COLL_CD.COLLTYPE phía CLOS (đổi tên thêm hậu tố CODE); phía RLOS gán theo bảng tài sản mà bản ghi đến từ đó. Giữ nguyên giá trị gốc, kể cả chuỗi tiếng Việt không dấu |
| 5 | COLL_GROUP | VARCHAR2 | 50 | N |  | PHÁI SINH |  |  | (đầu vào BC1.TSBD_BDS/PTVT/GTCG; BC2 9 cờ TSDB_*; BC9.TSBD_G2) | DA_CHOT | PHÁI SINH — Chuẩn hóa COLLATERAL_TYPE_CODE về nhóm dùng chung hai hệ: BAT DONG SAN→BDS; PHUONGTIEN VTAI→PTVT; TR.PHIEU TIN PH→CPTP; TAI SAN KHAC - MMTB,DCSX→MMTB; HH LA LINHKIEN / HH LA NLSX / HH TM THANHPHAM→HTK; TAI SAN KHAC - QUYEN DOI NO→KPT; KHÔNG CÓ TÀI SẢN→TINCHAP; TIN CHAP THEO QUY DINH→TINCHAP_TQD; giấy tờ có giá→GTCG; còn lại→KHAC. Là căn cứ cho 9 cờ loại tài sản của BC2 |
| 6 | EFF_DATE | DATE |  | Y |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Ngày bắt đầu hiệu lực của phiên bản bản ghi. Do ETL sinh khi phát hiện thuộc tính thay đổi |
| 7 | EXP_DATE | DATE |  | N |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Ngày hết hiệu lực của phiên bản. NULL = bản ghi hiện hành |
