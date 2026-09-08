# FCT_PDTD_COLLATERAL

Nguồn: docx section "4.4.4 Bảng FCT_PDTD_COLLATERAL"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | DATE | Y |  | PK | Ngày dữ liệu, dạng số YYYYMMDD |
| 2 | WI_NAME | VARCHAR2 | Y | 100 | PK | Mã hồ sơ tín dụng |
| 3 | COLLATERAL_BK | VARCHAR2 | Y | 64 | PK | Khóa nghiệp vụ của dòng, còn để placeholder chờ chốt khóa nguồn |
| 4 | APPLICATION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_APPLICATION. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 5 | COLLATERAL_TYPE_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_COLLATERAL_TYPE. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 6 | DATASOURCE | VARCHAR2 | Y | 10 |  | Loại TSBĐ |
| 7 | COLLATERAL_TYPE_CODE | VARCHAR2 | N | 100 |  | Mã loại tài sản bảo đảm |
| 8 | CERTIFICATE_NO | VARCHAR2 | N | 500 |  | Số giấy chứng nhận của tài sản bảo đảm |
| 9 | DESCRIPTION | VARCHAR2 | N | 4000 |  | Diễn giải tài sản bảo đảm |
| 10 | OWNER_NAME | VARCHAR2 | N | 200 |  | Tên chủ sở hữu tài sản bảo đảm |
| 11 | REL_TO_CUSTOMER | VARCHAR2 | N | 200 |  | Quan hệ giữa chủ tài sản và khách hàng |
| 12 | USING_PURPOSE | VARCHAR2 | N | 255 |  | Mục đích sử dụng của bất động sản |
| 13 | VEHICLE_TYPE | VARCHAR2 | N | 100 |  | Loại phương tiện vận tải |
| 14 | BRAND | VARCHAR2 | N | 200 |  | Hãng của phương tiện vận tải |
| 15 | CONTROL_POSTER | VARCHAR2 | N | 100 |  | Biển số kiểm soát của phương tiện |
| 16 | VALPAPER_TYPE | VARCHAR2 | N | 100 |  | Loại giấy tờ có giá |
| 17 | NUMBERSIGN | VARCHAR2 | N | 200 |  | Số hiệu của giấy tờ có giá |
| 18 | IS_ASSET_FORMED | VARCHAR2 | N | 10 |  | Tài sản đã hình thành hay chưa |
| 19 | COLL_MGMT_METHOD | VARCHAR2 | N | 4000 |  | Phương thức quản lý tài sản |
| 20 | IS_FORMED_FROM_LOAN | VARCHAR2 | N | 10 |  | Tài sản hình thành từ vốn vay hay không |
| 21 | APPRAISED_VALUE | NUMBER | N | 20,2 |  | Giá trị định giá của tài sản |
| 22 | LOAN_RATE_LTV | NUMBER | N | 5,2 |  | Tỷ lệ cho vay trên giá trị tài sản |
