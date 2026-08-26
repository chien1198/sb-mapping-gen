# DIM_PDTD_CUSTOMER

Nguồn: docx section "4.3.12 Bảng DIM_PDTD_CUSTOMER"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | Y | 18 | PK | Khóa chính của bảng chiều DIM_PDTD_CUSTOMER, giữ nguyên DIMENSION_KEY của bảng chiều tương ứng bên DWH_LOS, không sinh sequence mới |
| 2 | CUSTOMER_ID | VARCHAR2 | Y | 50 |  | Mã khách hàng CIF |
| 3 | SHORT_NAME | VARCHAR2 | N | 200 |  | Tên khách hàng theo T24 |
| 4 | LEGAL_ID | VARCHAR2 | N | 100 |  | Số giấy tờ định danh đã chuẩn hóa |
| 5 | LEGAL_DOC_NAME | VARCHAR2 | N | 100 |  | Loại giấy tờ định danh |
| 6 | DATE_OF_BIRTH | DATE | N |  |  | Ngày sinh |
| 7 | GENDER | VARCHAR2 | N | 20 |  | Giới tính |
| 8 | SEAB_CU_SEGMENT | VARCHAR2 | N | 20 |  | Phân khúc khách hàng theo T24 |
| 9 | EFF_DATE | DATE | Y |  |  | Ngày bắt đầu hiệu lực của bản ghi |
| 10 | EXP_DATE | DATE | N |  |  | Ngày hết hiệu lực của bản ghi |
