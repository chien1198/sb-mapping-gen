# FCT_PDTD_DISBURSEMENT

Nguồn: docx section "4.4.10 Bảng FCT_PDTD_DISBURSEMENT"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | DATE | Y |  | PK | Ngày dữ liệu, dạng số YYYYMMDD |
| 2 | CONTRACT | VARCHAR2 | Y | 100 | PK | Mã hợp đồng khoản vay |
| 3 | CUSTOMER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_CUSTOMER. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 4 | ORG_UNIT_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_ORG_UNIT. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 5 | ZONE | VARCHAR2 | N | 50 |  | Tên vùng của đơn vị kinh doanh |
| 6 | APPLICATION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_APPLICATION. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 7 | SEAB_LOS_ID | VARCHAR2 | N | 100 |  | Mã hồ sơ LOS gắn với hợp đồng |
| 8 | VALUE_DATE | DATE | N |  |  | Ngày giải ngân |
| 9 | MATURITY_DATE | DATE | N |  |  | Ngày đáo hạn |
| 10 | REC_STATUS | VARCHAR2 | N | 20 |  | Trạng thái hợp đồng |
| 11 | DISBURSEMENT_AMT | NUMBER | N | 20,2 |  | Số tiền giải ngân |
| 12 | CUR_BALANCE | NUMBER | N | 20,2 |  | Dư nợ hiện tại |
| 13 | NO_DAYS_OVERDUE | NUMBER | N | 6 |  | Số ngày quá hạn |
| 14 | CUR_BUCKET | NUMBER | N | 2 |  | Nhóm nợ |
| 15 | PRODUCT_T24 | VARCHAR2 | N | 200 |  | Sản phẩm giải ngân theo T24 |
| 16 | CONTRACT_REF | VARCHAR2 | N | 100 |  | Mã hợp đồng tham chiếu |
| 17 | REF_VALUE_DATE | DATE | N |  |  | Ngày hiệu lực của hợp đồng tham chiếu |
| 18 | LIMIT_REFERENCE | VARCHAR2 | N | 100 |  | Mã hạn mức |
