# TMP_REF_COMPANY_REGION_KHDN

Nguồn: xlsx sheet "TMP_REF_COMPANY_REGION_KHDN" (DATAMODEL_DTM_PDTD_20260908.xlsx)

- Loại bảng: REF - bảng map
- Mô tả: Bảng map đơn vị kinh doanh sang trung tâm và vùng, dùng cho luồng khách hàng doanh nghiệp.
- Lưu gì: Mỗi mã đơn vị một dòng, kèm tên chi nhánh theo T24, trung tâm và vùng.
- Grain: 1 dòng = 1 mã đơn vị kinh doanh
- Khóa: PK = COMPANY_CODE
- Nguồn: MAP_TABLE/tmp_ref_company_region_KHDN.xlsx. Bảng vật lý tạo trên schema PDTD_DTM.
- Báo cáo sử dụng: BC11
- Quy tắc load: Nạp toàn bộ từ tmp_ref_company_region_KHDN.xlsx, 56 dòng dữ liệu. File nguồn có nhiều cột phụ ở bên trái, chỉ lấy bốn cột TEN_CN_T24, Trung_tam, Vung, COMPANY_CODE.

| STT | Tên cột | Ý nghĩa | Kiểu dữ liệu | Độ lớn | Notnull | Khóa | Loại | Bảng/cột nguồn | Trường đích trên báo cáo | TRẠNG THÁI THIẾT KẾ | Mô tả |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | COMPANY_CODE | Mã đơn vị kinh doanh | VARCHAR2 | 20 | Y | PK | 1:1 | file.COMPANY_CODE | BC1.COMPANY_CODE; BC2.COMPANY_CODE | DA_CHOT | Mã đơn vị kinh doanh, ví dụ VN0010940 |
| 2 | TEN_CN_T24 | Tên chi nhánh theo cách T24 ghi, ví dụ AN GIANG BRANCH | VARCHAR2 | 50 | Y |  | 1:1 | file.TEN_CN_T24 |  | DA_CHOT | Tên chi nhánh theo cách T24 ghi, ví dụ AN GIANG BRANCH |
| 3 | TRUNG_TAM | Tên trung tâm khách hàng doanh nghiệp, ví dụ TT KHDN An Giang | VARCHAR2 | 50 | Y |  | 1:1 | file.Trung_tam |  | DA_CHOT | Tên trung tâm khách hàng doanh nghiệp, ví dụ TT KHDN An Giang |
| 4 | VUNG | Tên vùng, đổ vào trường ZONE của BC11 | VARCHAR2 | 50 | Y |  | 1:1 | file.Vung |  | DA_CHOT | Tên vùng, đổ vào trường ZONE của BC11. Giá trị: Miền Bắc, Miền Nam, Hà Nội |
