# DIM_PDTD_COLLATERAL

Nguồn: docx section "4.3.5 Bảng DIM_PDTD_COLLATERAL"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | Y | 18 | PK | Khóa chính của bảng chiều DIM_PDTD_COLLATERAL, giữ nguyên DIMENSION_KEY của bảng chiều tương ứng bên DWH_LOS, không sinh sequence mới |
| 2 | COLLATERAL_NK | VARCHAR2 | Y | 300 |  | Khóa tự nhiên của bảng |
| 3 | WI_NAME | VARCHAR2 | N | 100 |  | Mã hồ sơ tín dụng |
| 4 | SYSTEM_CODE | VARCHAR2 | N | 10 |  | Hệ nguồn của bản ghi, CLOS hoặc RLOS |
| 5 | COLLATERAL_SEQ | NUMBER | N | 4 |  | Số thứ tự tài sản trong cùng loại của hồ sơ |
| 6 | CERTIFICATE_NO | VARCHAR2 | N | 500 |  | Số giấy chứng nhận của tài sản bảo đảm |
| 7 | DESCRIPTION | VARCHAR2 | N | 4000 |  | Diễn giải tài sản bảo đảm |
| 8 | OWNER_NAME | VARCHAR2 | N | 200 |  | Tên chủ sở hữu tài sản bảo đảm |
| 9 | REL_TO_CUSTOMER | VARCHAR2 | N | 200 |  | Quan hệ giữa chủ tài sản và khách hàng |
| 10 | USING_PURPOSE | VARCHAR2 | N | 255 |  | Mục đích sử dụng của bất động sản |
| 11 | VEHICLE_TYPE | VARCHAR2 | N | 100 |  | Loại phương tiện vận tải |
| 12 | BRAND | VARCHAR2 | N | 200 |  | Hãng của phương tiện vận tải |
| 13 | CONTROL_POSTER | VARCHAR2 | N | 100 |  | Biển số kiểm soát của phương tiện |
| 14 | VALPAPER_TYPE | VARCHAR2 | N | 100 |  | Loại giấy tờ có giá |
| 15 | NUMBERSIGN | VARCHAR2 | N | 200 |  | Số hiệu của giấy tờ có giá |
| 16 | COLLATERAL_TYPE_CODE | VARCHAR2 | N | 100 |  | Mã loại tài sản bảo đảm |
| 17 | IS_ASSET_FORMED | VARCHAR2 | N | 10 |  | Tài sản đã hình thành hay chưa |
| 18 | COLL_MGMT_METHOD | VARCHAR2 | N | 4000 |  | Phương thức quản lý tài sản |
| 19 | IS_FORMED_FROM_LOAN | VARCHAR2 | N | 10 |  | Tài sản hình thành từ vốn vay hay không |
| 20 | COLLATERAL_TYPE_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_COLLATERAL_TYPE. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 21 | EFF_DATE | DATE | Y |  |  | Ngày bắt đầu hiệu lực của bản ghi |
| 22 | EXP_DATE | DATE | N |  |  | Ngày hết hiệu lực của bản ghi |
