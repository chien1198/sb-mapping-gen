# MẪU THỬ (2 bảng) — để bạn duyệt văn phong trước khi nhân rộng ra ~67 bảng

---

### Bảng DIM_CLOS_CUSTOMER

- Bảng lưu thông tin doanh nghiệp khách hàng chính CLOS, gồm tên khách hàng cùng các thuộc tính mô tả cố hữu (phân khúc, loại hình pháp lý, ngành nghề kinh doanh).

- Khóa chính của bảng (PK): **CUSTOMER_CODE + ACTIVE_DATE.**

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | CUSTOMER_CODE | VARCHAR2 | N | 100 | PK | Số ĐKKD/CMND của khách hàng |
| 2 | CUSTOMER_NAME | NVARCHAR2 | N | 200 |  | Tên doanh nghiệp khách hàng |
| 3 | CUST_GROUP | NVARCHAR2 | N | 200 |  | Phân khúc khách hàng doanh nghiệp (SME/MSME/USME/STR/JSC/SOC/BANK/FDI/NBFI) |
| 4 | CUST_CATEGORY | NVARCHAR2 | N | 200 |  | Phân loại khách hàng |
| 5 | PRECUSTGROUP | NVARCHAR2 | N | 300 |  | Phân khúc khách hàng trước xử lý |
| 6 | INDUSTRY_LVL1_CODE | VARCHAR2 | N | 200 |  | Mã ngành kinh doanh cấp 1 |
| 7 | INDUSTRY_LVL2_CODE | VARCHAR2 | N | 200 |  | Mã ngành kinh doanh cấp 2 |
| 8 | INDUSTRY_LVL3_CODE | VARCHAR2 | N | 200 |  | Mã ngành kinh doanh cấp 3 |
| 9 | ACTIVE_DATE | DATE | Y |  | PK | Ngày bắt đầu hiệu lực |
| 10 | TIME_UPDATE | TIMESTAMP(6) | Y |  |  | Thời gian cập nhật dữ liệu |

---

### Bảng FCT_CLOS_COLLATERAL

- Bảng lưu trữ ảnh số liệu thay đổi theo ngày của từng tài sản bảo đảm thuộc hồ sơ tín dụng doanh nghiệp (CLOS).

- Khóa chính của bảng (PK): **DAYID + COLLATERAL_BK.**

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DAYID | DATE | Y |  | PK | Ngày dữ liệu |
| 2 | COLLATERAL_BK | VARCHAR2 | Y | 64 | PK | Khóa nghiệp vụ của dòng tài sản |
| 3 | WI_NAME | NVARCHAR2 | Y | 100 | FK | Mã hồ sơ tín dụng CLOS — khóa liên kết tới DIM_CLOS_APPLICATION |
| 4 | COLLATERAL_TYPE_CODE | NVARCHAR2 | N | 100 |  | Loại tài sản bảo đảm |
| 5 | DESCRIPTION | CLOB | N |  |  | Diễn giải tài sản bảo đảm |
| 6 | OWNER_NAME | NVARCHAR2 | N | 100 |  | Chủ sở hữu tài sản |
| 7 | COLL_MGMT_METHOD | CLOB | N |  |  | Phương thức quản lý tài sản |
| 8 | APPRAISED_VALUE | NUMBER | N | 20,2 |  | Giá trị định giá của tài sản |
| 9 | LOAN_RATE_LTV | NVARCHAR2 | N | 100 |  | Tỷ lệ cho vay trên giá trị tài sản |
| 10 | TIME_UPDATE | TIMESTAMP(6) | Y |  |  | Thời gian cập nhật dữ liệu |
