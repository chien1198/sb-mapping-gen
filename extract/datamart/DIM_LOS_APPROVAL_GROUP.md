# DIM_LOS_APPROVAL_GROUP

Nguồn: xlsx sheet "DIM_LOS_APPROVAL_GROUP" (DATAMODEL_DWH_LOS_20260826.xlsx)

- Loại bảng: DIM - danh mục
- Mô tả: Danh mục cấp thẩm quyền phê duyệt tín dụng.
- Lưu gì: Lưu mã cấp phê duyệt kèm thứ tự cấp. BA đã cung cấp ý nghĩa đầy đủ: A1 đến C3 là các cấp chuyên gia phê duyệt độc lập theo thứ tự từ cao xuống thấp, BOD là Hội đồng quản trị, CC là Hội đồng tín dụng, SCC là Ủy ban tín dụng, RCC là Hội đồng tín dụng cấp vùng, DEBTCC là Hội đồng tín dụng chuyên trách xử lý nợ.
- Grain: 1 dòng = 1 cấp phê duyệt của 1 hệ nguồn
- Khóa: DIMENSION_KEY (sequence). NK = APPROVAL_GROUP_NK
- Nguồn: NG_SB_CLOS_APPROVAL, NG_SB_RLOS_APPROVAL
- Báo cáo sử dụng: BC1, BC2, BC5, BC9
- Quy tắc load: (chưa khai)

| STT | Tên cột | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng nguồn | Cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | 18 | Y | PK | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Khóa thay thế, sinh từ SEQ_DIM_LOS_APPROVAL_GROUP. Mỗi DIM có sẵn một dòng Unknown với DIMENSION_KEY = -1 và các thuộc tính để 'N/A'; mọi lookup không khớp từ fact trỏ về dòng này thay vì để NULL, để phép đếm trên fact không bị hụt. |
| 2 | APPROVAL_GROUP_NK | VARCHAR2 | 70 | Y |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Khóa tự nhiên do DWH ghép: SYSTEM_CODE || '|' || APP_GRP_CODE |
| 3 | SYSTEM_CODE | VARCHAR2 | 10 | Y |  | PHÁI SINH |  |  |  | DA_CHOT | PHÁI SINH — Hệ nguồn của bản ghi danh mục, gán theo bảng mà giá trị được lấy ra: 'CLOS' hoặc 'RLOS'. Bắt buộc nằm trong khóa tự nhiên vì hai hệ có thể dùng trùng mã cho hai nghĩa khác nhau |
| 4 | APP_GRP_CODE | VARCHAR2 | 50 | Y |  | 1:1 | NG_SB_CLOS_APPROVAL / NG_SB_RLOS_APPROVAL | APP_GRP | BC1.APP_GRP; BC2.APP_GRP; (khóa tra BC5.SLA_*, BC9.POINT) | DA_CHOT | 1:1 — Nguồn: NG_SB_CLOS_APPROVAL.APP_GRP / NG_SB_RLOS_APPROVAL.APP_GRP (đổi tên thêm hậu tố CODE). Trường APP_GRP của BC1 và BC2 |
| 5 | APPROVAL_LEVEL | NUMBER | 3 | N |  | PHÁI SINH |  |  | (đầu vào BC5.REF_PRODUCT) | DA_CHOT | PHÁI SINH — Thứ tự cấp phê duyệt theo giải thích của BA, số nhỏ là cấp cao: A1=1, A2=2, B1=3, B2=4, C1=5, C2=6, C3=7; các hội đồng nhận giá trị riêng. BC5 gom nhóm 'CGPD cấp B, C' bằng khoảng giá trị thay vì liệt kê mã |
| 6 | EFF_DATE | DATE |  | Y |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Ngày bắt đầu hiệu lực của phiên bản bản ghi. Do ETL sinh khi phát hiện thuộc tính thay đổi |
| 7 | EXP_DATE | DATE |  | N |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Ngày hết hiệu lực của phiên bản. NULL = bản ghi hiện hành |
