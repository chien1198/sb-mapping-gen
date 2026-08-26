# FCT_PDTD_COLLATERAL

Nguồn: docx section "4.4.4 Bảng FCT_PDTD_COLLATERAL"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | DATE | Y |  | PK | Ngày dữ liệu, dạng số YYYYMMDD |
| 2 | WI_NAME | VARCHAR2 | Y | 100 | PK | Mã hồ sơ tín dụng |
| 3 | COLLATERAL_BK | VARCHAR2 | Y | 300 | PK | Khóa nghiệp vụ của dòng, còn để placeholder chờ chốt khóa nguồn |
| 4 | COLLATERAL_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_COLLATERAL. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 5 | APPLICATION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_APPLICATION. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 6 | COLLATERAL_TYPE_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_COLLATERAL_TYPE. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 7 | SYSTEM_CODE | VARCHAR2 | Y | 10 |  | Hệ nguồn của bản ghi, CLOS hoặc RLOS |
| 8 | COLLATERAL_TYPE_CODE | VARCHAR2 | N | 100 |  | Mã loại tài sản bảo đảm |
| 9 | COLLATERAL_SEQ | NUMBER | N | 4 |  | Số thứ tự tài sản trong cùng loại của hồ sơ |
| 10 | APPRAISED_VALUE | NUMBER | N | 20,2 |  | Giá trị định giá của tài sản |
| 11 | LOAN_RATE_LTV | NUMBER | N | 5,2 |  | Tỷ lệ cho vay trên giá trị tài sản |
