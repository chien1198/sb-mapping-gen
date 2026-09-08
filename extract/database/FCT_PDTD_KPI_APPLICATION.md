# FCT_PDTD_KPI_APPLICATION

Nguồn: docx section "4.4.11 Bảng FCT_PDTD_KPI_APPLICATION"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | DATE | Y |  | PK | Ngày dữ liệu, dạng số YYYYMMDD |
| 2 | WI_NAME | VARCHAR2 | Y | 100 | PK | Mã hồ sơ tín dụng |
| 3 | APPLICATION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_APPLICATION. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 4 | PRODUCT_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_PRODUCT. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 5 | ORG_UNIT_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_ORG_UNIT. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 6 | DATASOURCE | VARCHAR2 | Y | 10 |  | RLOS hoặc CLOS |
| 7 | PROCESSED_DATE | DATE | N |  |  | Ngày xử lý của hồ sơ |
| 8 | VOLUME | NUMBER | N | 5,2 |  | Mức độ hoàn thành hồ sơ, thang 0 đến 1 |
| 9 | POINT | NUMBER | N | 12,4 |  | Điểm KPI |
| 10 | QUY_DOI | NUMBER | N | 12,4 |  | Điểm KPI quy đổi |
| 11 | TAT_APPLICATION_HOUR | NUMBER | N | 18,6 |  | Tổng thời gian xử lý của cả hồ sơ, đơn vị giờ |
| 12 | TSBD_G2 | VARCHAR2 | N | 10 |  | Hồ sơ có từ 2 tài sản bảo đảm trở lên |
| 13 | INCOM_3 | VARCHAR2 | N | 10 |  | Hồ sơ có từ 3 nguồn thu nhập trở lên |
| 14 | BUSINESS_INCOM | VARCHAR2 | N | 10 |  | Hồ sơ có thu nhập từ kinh doanh |
| 15 | DEVIATION_G2 | VARCHAR2 | N | 10 |  | Hồ sơ có đúng 2 ngoại lệ chính sách |
| 16 | DEVIATION_G3 | VARCHAR2 | N | 10 |  | Hồ sơ có từ 3 ngoại lệ chính sách trở lên |
