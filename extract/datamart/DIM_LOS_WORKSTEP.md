# DIM_LOS_WORKSTEP

Nguồn: xlsx sheet "DIM_LOS_WORKSTEP" (DATAMODEL_DWH_LOS_20260826.xlsx)

- Loại bảng: DIM - danh mục
- Mô tả: Danh mục bước xử lý trong quy trình BPM của hồ sơ tín dụng.
- Lưu gì: Lưu mã bước cùng giai đoạn và thứ tự trong quy trình, kèm ba cờ phân loại. Đây cũng là nơi làm sạch giá trị lẫn tiền tố hệ nguồn do CLOS và RLOS dùng chung engine BPM.
- Grain: 1 dòng = 1 bước xử lý của 1 hệ nguồn
- Khóa: DIMENSION_KEY (sequence). NK = WORKSTEP_NK
- Nguồn: NG_SB_CLOS_ENTRY_EXIT, NG_SB_RLOS_ENTRY_EXIT, WFINSTRUMENTTABLE
- Báo cáo sử dụng: BC1, BC2, BC3, BC4, BC5, BC7, BC8, BC9
- Quy tắc load: (chưa khai)

| STT | Tên cột | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng nguồn | Cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | 18 | Y | PK | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Khóa thay thế, sinh từ SEQ_DIM_LOS_WORKSTEP. Mỗi DIM có sẵn một dòng Unknown với DIMENSION_KEY = -1 và các thuộc tính để 'N/A'; mọi lookup không khớp từ fact trỏ về dòng này thay vì để NULL, để phép đếm trên fact không bị hụt. |
| 2 | WORKSTEP_NK | VARCHAR2 | 220 | Y |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Khóa tự nhiên do DWH ghép: SYSTEM_CODE || '|' || WORKSTEP_CODE |
| 3 | SYSTEM_CODE | VARCHAR2 | 10 | Y |  | PHÁI SINH |  |  |  | DA_CHOT | PHÁI SINH — Hệ nguồn của bản ghi danh mục, gán theo bảng mà giá trị được lấy ra: 'CLOS' hoặc 'RLOS'. Bắt buộc nằm trong khóa tự nhiên vì hai hệ có thể dùng trùng mã cho hai nghĩa khác nhau |
| 4 | WORKSTEP_CODE | VARCHAR2 | 200 | Y |  | 1:1 | NG_SB_CLOS_ENTRY_EXIT / NG_SB_RLOS_ENTRY_EXIT | WORKSTEP | BC3.WORKSTEP; BC4.WORKSTEP; BC8.WORKSTEP | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_ENTRY_EXIT.WORKSTEP / NG_SB_RLOS_ENTRY_EXIT.WORKSTEP, đã cắt tiền tố hệ nguồn nếu có (metadata ghi nhận giá trị CLOS_DataInputerChecker lẫn trong dữ liệu RLOS). Giữ nguyên tên |
| 5 | STAGE_CODE | VARCHAR2 | 50 | N |  | PHÁI SINH |  |  | (gom nhóm bước) | DA_CHOT | PHÁI SINH — Gom nhóm bước thành giai đoạn: BRANCH, DATA_ENTRY, QUALITY_CHECK, UNDERWRITING, APPROVAL, DISBURSEMENT, CANCEL. Dùng bảng ánh xạ tĩnh do DWH quản lý |
| 6 | STAGE_ORDER | NUMBER | 3 | N |  | PHÁI SINH |  |  | (đầu vào BC9.VOLUME) | DA_CHOT | PHÁI SINH — Thứ tự giai đoạn trong quy trình. Dùng để xác định bước xa nhất hồ sơ đã đi tới, phục vụ điểm KPI VOLUME của BC9 |
| 7 | EFF_DATE | DATE |  | Y |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Ngày bắt đầu hiệu lực của phiên bản bản ghi. Do ETL sinh khi phát hiện thuộc tính thay đổi |
| 8 | EXP_DATE | DATE |  | N |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Ngày hết hiệu lực của phiên bản. NULL = bản ghi hiện hành |
