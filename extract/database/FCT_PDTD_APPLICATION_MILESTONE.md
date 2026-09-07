# FCT_PDTD_APPLICATION_MILESTONE

Nguồn: docx section "4.4.12 Bảng FCT_PDTD_APPLICATION_MILESTONE"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | DATE | Y |  | PK | Ngày dữ liệu, dạng số YYYYMMDD |
| 2 | WI_NAME | VARCHAR2 | Y | 100 | PK | Mã hồ sơ tín dụng |
| 3 | MILESTONE_CODE | VARCHAR2 | Y | 30 | PK | Loại mốc của hồ sơ: phê duyệt hợp lệ lần đầu hoặc giải ngân lần đầu |
| 4 | APPLICATION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_APPLICATION. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 5 | PRODUCT_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_PRODUCT. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 6 | ORG_UNIT_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_ORG_UNIT. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 7 | SYSTEM_CODE | VARCHAR2 | Y | 10 |  | Hệ nguồn của bản ghi, CLOS hoặc RLOS |
| 8 | MILESTONE_TS | TIMESTAMP | Y |  |  | Thời điểm hồ sơ đạt mốc lần đầu tiên |
