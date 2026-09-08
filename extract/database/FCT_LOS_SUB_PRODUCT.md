# FCT_LOS_SUB_PRODUCT

Nguồn: docx section "4.2.7 Bảng FCT_LOS_SUB_PRODUCT"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | DATE | Y |  | PK | Ngày dữ liệu, dạng số YYYYMMDD |
| 2 | WI_NAME | VARCHAR2 | Y | 100 | PK | Mã hồ sơ tín dụng |
| 3 | SUB_PRODUCT_TYPE_CODE | VARCHAR2 | Y | 30 | PK | Mã loại sản phẩm phụ |
| 4 | SUB_PRODUCT_BK | VARCHAR2 | Y | 64 | PK | Khóa nghiệp vụ của dòng, còn để placeholder chờ chốt khóa nguồn |
| 5 | APPLICATION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_APPLICATION. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 6 | PRODUCT_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_PRODUCT. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 7 | DATASOURCE | VARCHAR2 | Y | 10 |  | Gán theo tuyến bảng nguồn/STG_LOS; hiện các bảng sản phẩm phụ trong phạm vi là RLOS |
| 8 | SUB_PRODUCT_LINE | VARCHAR2 | N | 200 |  | Dòng của sản phẩm phụ |
| 9 | CARD_TYPE_CODE | VARCHAR2 | N | 100 |  | Loại thẻ của sản phẩm phụ là thẻ tín dụng |
| 10 | SPP_AMOUNT | NUMBER | N | 20,2 |  | Hạn mức của sản phẩm phụ |
| 11 | SPP_TERM | NUMBER | N | 5 |  | Thời hạn của sản phẩm phụ, đơn vị tháng |
