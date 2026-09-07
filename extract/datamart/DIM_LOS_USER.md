# DIM_LOS_USER

Nguồn: xlsx sheet "DIM_LOS_USER" (DATAMODEL_DWH_LOS_20260903.xlsx)

- Loại bảng: DIM - danh mục
- Mô tả: Danh mục tài khoản cán bộ xử lý hồ sơ trên workflow.
- Lưu gì: Hiện chỉ có username. Giữ thành chiều riêng để mọi fact tham chiếu bằng khóa tự sinh đúng grain của nó, và để khi bổ sung master nhân sự (mã nhân viên, đơn vị, chức danh) thì chỉ thêm cột vào đây, không phải sửa lại các bảng fact.
- Grain: 1 dòng = 1 phiên bản của 1 tài khoản người dùng
- Khóa: PK = DIMENSION_KEY (Oracle sequence). UNIQUE (USERNAME, EFF_DATE).
- Quy tắc load: SCD2 theo USERNAME. Có sẵn dòng Unknown DIMENSION_KEY = -1.
- Nguồn: NG_SB_CLOS_ENTRY_EXIT, NG_SB_RLOS_ENTRY_EXIT
- Báo cáo sử dụng: BC1, BC2, BC3, BC4, BC7, BC8, BC9

| STT | Tên cột | Ý nghĩa | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng nguồn | Cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | Khóa tự sinh của bảng chiều | NUMBER | 18 | Y | PK | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — khóa tự sinh, sinh từ SEQ_DIM_LOS_USER. Có sẵn dòng Unknown DIMENSION_KEY = -1. |
| 2 | USERNAME | Tên tài khoản người xử lý hồ sơ | VARCHAR2 | 100 | Y | NK | 1:1 + NK | NG_SB_CLOS_ENTRY_EXIT / NG_SB_RLOS_ENTRY_EXIT | USERNAME |  | DA_CHOT | 1:1 + KHÓA TỰ NHIÊN — Tên tài khoản của cán bộ xử lý. Nguồn: NG_SB_CLOS_ENTRY_EXIT.USERNAME / NG_SB_RLOS_ENTRY_EXIT.USERNAME. UNIQUE (USERNAME, EFF_DATE). |
| 3 | EFF_DATE | Ngày bắt đầu hiệu lực của phiên bản bản ghi | DATE |  | Y |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — Ngày bắt đầu hiệu lực của phiên bản. |
| 4 | EXP_DATE | Ngày hết hiệu lực của phiên bản, để trống là bản ghi hiện hành | DATE |  | N |  | KỸ THUẬT |  |  |  | DA_CHOT | KỸ THUẬT — NULL = bản ghi hiện hành. |
