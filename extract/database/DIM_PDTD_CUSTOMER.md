# DIM_PDTD_CUSTOMER

Nguồn: docx "Design_Database_PDTD_DTM_v1.0_20260908.docx"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | Y | 18 | PK | Khóa chính của bảng chiều DIM_PDTD_CUSTOMER, giữ nguyên DIMENSION_KEY của bảng chiều tương ứng bên DWH_LOS, không sinh sequence mới |
| 2 | CUSTOMER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_CUSTOMER. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 3 | CUSTOMER_ID | VARCHAR2 | Y | 50 |  | Mã khách hàng CIF |
| 4 | SHORT_NAME | VARCHAR2 | N | 200 |  | Tên khách hàng theo T24 |
| 5 | LEGAL_ID | VARCHAR2 | N | 100 |  | Số giấy tờ định danh đã chuẩn hóa |
| 6 | LEGAL_DOC_NAME | VARCHAR2 | N | 100 |  | Loại giấy tờ định danh |
| 7 | DATE_OF_BIRTH | DATE | N |  |  | Ngày sinh |
| 8 | GENDER | VARCHAR2 | N | 20 |  | Giới tính |
| 9 | SEAB_CU_SEGMENT | VARCHAR2 | N | 20 |  | Phân khúc khách hàng theo T24 |
| 10 | EFF_DATE | DATE | Y |  |  | Ngày bắt đầu hiệu lực của bản ghi |
| 11 | EXP_DATE | DATE | N |  |  | Ngày hết hiệu lực của bản ghi |
