# DIM_LOS_CHANGE_TYPE

Nguồn: xlsx sheet "DIM_LOS_CHANGE_TYPE" (DATAMODEL_DWH_LOS_20260903.xlsx)

- Loại bảng: DIM - danh mục
- Mô tả: Danh mục loại thay đổi điều kiện phê duyệt.
- Lưu gì: Lưu loại và chi tiết loại thay đổi điều kiện, kèm cờ tách nhánh cơ cấu nợ phục vụ cách BC5 xếp nhóm sản phẩm để tra cam kết SLA.
- Grain: 1 dòng = 1 tổ hợp loại + chi tiết loại thay đổi của 1 hệ nguồn
- Khóa: PK = DIMENSION_KEY (Oracle sequence). UNIQUE (SYSTEM_CODE, CHANGE_TYPE_CODE, DETAIL_CHANGE_TYPE_CODE, EFF_DATE) — dùng thẳng tổ hợp cột tự nhiên, KHÔNG sinh cột CHANGE_TYPE_NK ghép chuỗi: các cột thành phần đã có sẵn trên bảng nên cột ghép chỉ nhân bản dữ liệu và phải giữ đồng bộ.
- Nguồn: SB_RLOS_MAS_CHANGE_TYPE, NG_SB_CLOS_CHANGEREQ, NG_SB_RLOS_EXTTABLE
- Báo cáo sử dụng: BC1, BC2, BC5
- Quy tắc load: SCD TYPE 2. Đọc ảnh nguồn tại cutoff của ngày :P_DATE theo đúng quy trình A hoặc B của bảng nguồn (xem 00_Phan_loai_nguon), rồi so khớp theo khóa tự nhiên: bản ghi chưa có thì INSERT với EFF_DATE = :P_DATE và EXP_DATE để trống; thuộc tính đổi thì đóng bản đang hiệu lực bằng EXP_DATE = :P_DATE - 1 rồi mở bản mới; không đổi thì không làm gì. DIMENSION_KEY sinh bằng Oracle sequence, không tái sử dụng. Bản ghi biến mất khỏi nguồn KHÔNG bị xóa và KHÔNG bị đóng: giữ nguyên để fact của ngày cũ vẫn tra được tên. Chạy lại ngày D: xóa các bản có EFF_DATE = D, mở lại các bản bị đóng bằng EXP_DATE = D - 1, rồi nạp lại.

| STT | Tên cột | Ý nghĩa | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng nguồn | Cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | Khóa tự sinh của bảng chiều | NUMBER | 18 | Y | PK | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — khóa tự sinh, sinh từ SEQ_DIM_LOS_CHANGE_TYPE. Mỗi DIM có sẵn một dòng Unknown với DIMENSION_KEY = -1 và các thuộc tính để 'N/A'; mọi lookup không khớp từ fact trỏ về dòng này thay vì để NULL, để phép đếm trên fact không bị hụt. |
| 2 | SYSTEM_CODE | Hệ nguồn của bản ghi: CLOS hoặc RLOS | VARCHAR2 | 10 | Y |  | PHÁI SINH |  |  |  | DA_CHOT | PHÁI SINH — Hệ nguồn của bản ghi danh mục, gán theo bảng mà giá trị được lấy ra: 'CLOS' hoặc 'RLOS'. Bắt buộc nằm trong khóa tự nhiên vì hai hệ có thể dùng trùng mã cho hai nghĩa khác nhau |
| 3 | CHANGE_TYPE_CODE | Mã loại thay đổi điều kiện phê duyệt | VARCHAR2 | 100 | Y |  | 1:1 | SB_RLOS_MAS_CHANGE_TYPE / NG_SB_CLOS_CHANGEREQ | CHANGE_TYPE_CODE / CHANGE_TYPE | BC1.CHANGE_TYPE; BC2.CHANGE_TYPE | DA_CHOT | 1:1 — Nguồn: SB_RLOS_MAS_CHANGE_TYPE.CHANGE_TYPE_CODE / NG_SB_CLOS_CHANGEREQ.CHANGE_TYPE. Giữ tên phía RLOS |
| 4 | CHANGE_TYPE_NAME | Tên loại thay đổi điều kiện phê duyệt | VARCHAR2 | 200 | N |  | 1:1 | SB_RLOS_MAS_CHANGE_TYPE | CHANGE_TYPE_NAME | BC1.CHANGE_TYPE; BC2.CHANGE_TYPE | DA_CHOT | 1:1 — Nguồn: SB_RLOS_MAS_CHANGE_TYPE.CHANGE_TYPE_NAME. Giữ nguyên tên. Trường CHANGE_TYPE của BC1 và BC2 |
| 5 | DETAIL_CHANGE_TYPE_CODE | Mã chi tiết loại thay đổi | VARCHAR2 | 100 | N |  | 1:1 | SB_RLOS_MAS_CHANGE_TYPE | DETAIL_CHANGE_TYPE_CODE | (khóa nối) | DA_CHOT | 1:1 — Nguồn: SB_RLOS_MAS_CHANGE_TYPE.DETAIL_CHANGE_TYPE_CODE. Giữ nguyên tên |
| 6 | DETAIL_CHANGE_TYPE_NAME | Tên chi tiết loại thay đổi | VARCHAR2 | 500 | N |  | 1:1 | SB_RLOS_MAS_CHANGE_TYPE | DETAIL_CHANGE_TYPE_NAME | BC1.CHANGE_TYPE_DETAIL | DA_CHOT | 1:1 — Nguồn: SB_RLOS_MAS_CHANGE_TYPE.DETAIL_CHANGE_TYPE_NAME. Giữ nguyên tên. Trường CHANGE_TYPE_DETAIL của BC1 |
| 7 | EFF_DATE | Ngày bắt đầu hiệu lực của phiên bản bản ghi | DATE |  | Y |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Ngày bắt đầu hiệu lực của phiên bản bản ghi. Do ETL sinh khi phát hiện thuộc tính thay đổi |
| 8 | EXP_DATE | Ngày hết hiệu lực của phiên bản, để trống là bản ghi hiện hành | DATE |  | N |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Ngày hết hiệu lực của phiên bản. NULL = bản ghi hiện hành |
