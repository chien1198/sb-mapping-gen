# TMP_REF_COMPANY_REGION_KHCN

Nguồn: xlsx sheet "TMP_REF_COMPANY_REGION_KHCN" (DATAMODEL_DTM_PDTD_20260908.xlsx)

- Loại bảng: REF - bảng map
- Mô tả: Bảng map đơn vị kinh doanh sang chi nhánh và vùng, dùng cho luồng khách hàng cá nhân.
- Lưu gì: Mỗi mã đơn vị một dòng, kèm tên đơn vị, chi nhánh và vùng.
- Grain: 1 dòng = 1 mã đơn vị kinh doanh
- Khóa: PK = COMPANY_CODE
- Nguồn: MAP_TABLE/tmp_ref_company_region_KHCN.xlsx. Bảng vật lý tạo trên schema PDTD_DTM.
- Báo cáo sử dụng: BC10
- Quy tắc load: Nạp toàn bộ từ tmp_ref_company_region_KHCN.xlsx sheet PDG_CN_VÙNG, 180 dòng dữ liệu.

| STT | Tên cột | Ý nghĩa | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng/cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | COMPANY_CODE | Mã đơn vị kinh doanh | VARCHAR2 | 20 | Y | PK | 1:1 | file.COMPANY_CODE | BC1.COMPANY_CODE; BC2.COMPANY_CODE | DA_CHOT | Mã đơn vị kinh doanh, ví dụ VN0010002 |
| 2 | DVKD | Tên đơn vị kinh doanh, ví dụ Sở Giao Dịch | VARCHAR2 | 50 | Y |  | 1:1 | file.DVKD |  | DA_CHOT | Tên đơn vị kinh doanh, ví dụ Sở Giao Dịch |
| 3 | CHI_NHANH | Tên chi nhánh quản lý đơn vị | VARCHAR2 | 50 | Y |  | 1:1 | file.CHI_NHANH |  | DA_CHOT | Tên chi nhánh quản lý đơn vị |
| 4 | VUNG | Tên vùng, đổ vào trường ZONE của BC10 | VARCHAR2 | 30 | Y |  | 1:1 | file.VUNG |  | DA_CHOT | Tên vùng, đổ vào trường ZONE của BC10 |
