# REF_CLOS_LEGAL

Nguồn: xlsx sheet "REF_CLOS_LEGAL" (DATAMODEL_DTM_PDTD_20260908.xlsx)

- Loại bảng: REF - bảng map
- Mô tả: Bảng map vai trò pháp lý của người liên quan sang nhóm dùng để tra CIF khách hàng.
- Lưu gì: Mỗi giá trị OBJ_TYPE một dòng và nhóm vai trò tương ứng.
- Grain: 1 dòng = 1 giá trị OBJ_TYPE
- Khóa: PK = OBJ_TYPE
- Nguồn: MAP_TABLE/REF_CLOS_LEGAL.xlsx. Bảng vật lý tạo trên schema PDTD_DTM.
- Báo cáo sử dụng: BC2
- Quy tắc load: Nạp toàn bộ từ REF_CLOS_LEGAL.xlsx, 5 dòng dữ liệu.

| STT | Tên cột | Ý nghĩa | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng/cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | OBJ_TYPE | Loại đối tượng của giấy tờ pháp lý | VARCHAR2 | 50 | Y | PK | 1:1 | file.OBJ_TYPE |  | DA_CHOT | Loại đối tượng của giấy tờ pháp lý, ví dụ Người đại diện theo pháp luật, Khách hàng |
| 2 | LEGAL_TYPE | Nhóm vai trò của giấy tờ pháp lý | VARCHAR2 | 50 | Y |  | 1:1 | file.LEGAL_TYPE |  | DA_CHOT | Nhóm vai trò. BC2 lọc LEGAL_TYPE = 'CUSTOMER' để chỉ lấy giấy tờ của chính khách hàng khi tra CIF |
