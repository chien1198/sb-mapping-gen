# DIM_LOS_CHANGE_TYPE

Nguồn: xlsx sheet "DIM_LOS_CHANGE_TYPE" (DATAMODEL_DWH_LOS_20260820.xlsx)

- Loại bảng: DIM - danh mục
- Mô tả: Danh mục loại thay đổi điều kiện phê duyệt.
- Lưu gì: Lưu loại và chi tiết loại thay đổi điều kiện, kèm cờ tách nhánh cơ cấu nợ phục vụ cách BC5 xếp nhóm sản phẩm để tra cam kết SLA.
- Grain: 1 dòng = 1 tổ hợp loại + chi tiết loại thay đổi của 1 hệ nguồn
- Khóa: DIMENSION_KEY (sequence). NK = CHANGE_TYPE_NK
- Bảng nguồn CDC: SB_RLOS_MAS_CHANGE_TYPE, NG_SB_CLOS_CHANGEREQ, NG_SB_RLOS_EXTTABLE
- Báo cáo sử dụng: BC1, BC2, BC5

| STT | Tên cột | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | 18 | Y | PK | KỸ THUẬT — Khóa thay thế, sinh từ SEQ_DIM_LOS_CHANGE_TYPE |
| 2 | CHANGE_TYPE_NK | VARCHAR2 | 220 | Y |  | KỸ THUẬT — Khóa tự nhiên do DWH ghép: SYSTEM_CODE || '|' || CHANGE_TYPE_CODE || '|' || DETAIL_CHANGE_TYPE_CODE |
| 3 | SYSTEM_CODE | VARCHAR2 | 10 | Y |  | PHÁI SINH — Hệ nguồn của bản ghi danh mục, gán theo bảng mà giá trị được lấy ra: 'CLOS' hoặc 'RLOS'. Bắt buộc nằm trong khóa tự nhiên vì hai hệ có thể dùng trùng mã cho hai nghĩa khác nhau |
| 4 | CHANGE_TYPE_CODE | VARCHAR2 | 100 | Y |  | 1:1 — Nguồn: SB_RLOS_MAS_CHANGE_TYPE.CHANGE_TYPE_CODE / NG_SB_CLOS_CHANGEREQ.CHANGE_TYPE. Giữ tên phía RLOS |
| 5 | CHANGE_TYPE_NAME | VARCHAR2 | 200 | N |  | 1:1 — Nguồn: SB_RLOS_MAS_CHANGE_TYPE.CHANGE_TYPE_NAME. Giữ nguyên tên. Trường CHANGE_TYPE của BC1 và BC2 |
| 6 | DETAIL_CHANGE_TYPE_CODE | VARCHAR2 | 100 | N |  | 1:1 — Nguồn: SB_RLOS_MAS_CHANGE_TYPE.DETAIL_CHANGE_TYPE_CODE. Giữ nguyên tên |
| 7 | DETAIL_CHANGE_TYPE_NAME | VARCHAR2 | 500 | N |  | 1:1 — Nguồn: SB_RLOS_MAS_CHANGE_TYPE.DETAIL_CHANGE_TYPE_NAME. Giữ nguyên tên. Trường CHANGE_TYPE_DETAIL của BC1 |
| 8 | IS_RESTRUCTURE | VARCHAR2 | 1 | N |  | PHÁI SINH — 'Y' nếu CHANGE_TYPE_NAME thuộc ('Cơ cấu nợ thế chấp','Cơ cấu nợ tín chấp'). BC5 xếp nhóm này vào 'Phương án cơ cấu nợ', các loại thay đổi còn lại vào 'Phương án thay đổi điều kiện phê duyệt' |
| 9 | EFF_DATE | DATE |  | Y |  | KỸ THUẬT — Ngày bắt đầu hiệu lực của phiên bản bản ghi. Do ETL sinh khi phát hiện thuộc tính thay đổi |
| 10 | EXP_DATE | DATE |  | N |  | KỸ THUẬT — Ngày hết hiệu lực của phiên bản. NULL = bản ghi hiện hành |
