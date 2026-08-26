# DIM_PDTD_APPLICATION

Nguồn: docx section "4.3.2 Bảng DIM_PDTD_APPLICATION"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | Y | 18 | PK | Khóa chính của bảng chiều DIM_PDTD_APPLICATION, giữ nguyên DIMENSION_KEY của bảng chiều tương ứng bên DWH_LOS, không sinh sequence mới |
| 2 | WI_NAME | VARCHAR2 | Y | 100 |  | Mã hồ sơ tín dụng |
| 3 | SYSTEM_CODE | VARCHAR2 | Y | 10 |  | Hệ nguồn của bản ghi, CLOS hoặc RLOS |
| 4 | STREAM | VARCHAR2 | N | 200 |  | Luồng nghiệp vụ của hồ sơ |
| 5 | BI_FLOW | VARCHAR2 | N | 50 |  | Luồng nghiệp vụ chuẩn hóa để hiển thị trên báo cáo |
| 6 | CUST_GROUP | VARCHAR2 | N | 100 |  | Nhóm khách hàng |
| 7 | CHANGE_REQUEST | VARCHAR2 | N | 200 |  | Yêu cầu điều chỉnh hồ sơ |
| 8 | LOANCASEID | VARCHAR2 | N | 100 |  | Mã khoản vay gắn với hồ sơ |
| 9 | FIRST_APPROVED_WI_NAME | VARCHAR2 | N | 100 |  | Mã hồ sơ cha đã được phê duyệt |
| 10 | FIRST_APPROVED_DATE | DATE | N |  |  | Ngày hồ sơ cha được phê duyệt |
| 11 | EMPLOYEE_CODE | VARCHAR2 | N | 50 |  | Mã cán bộ quản lý hồ sơ |
| 12 | EMPLOYEE_NAME | VARCHAR2 | N | 200 |  | Tên cán bộ quản lý hồ sơ |
| 13 | APPROVAL_TYPE | VARCHAR2 | N | 200 |  | Loại luồng phê duyệt |
| 14 | CREDIT_PROFILE | VARCHAR2 | N | 50 |  | Cấp tín dụng của hồ sơ |
| 15 | INDUSTRY_LVL1_CODE | VARCHAR2 | N | 200 |  | Mã ngành cấp 1 |
| 16 | INDUSTRY_LVL2_CODE | VARCHAR2 | N | 200 |  | Mã ngành cấp 2 |
| 17 | INDUSTRY_LVL3_CODE | VARCHAR2 | N | 200 |  | Mã ngành cấp 3 |
| 18 | POLICY | VARCHAR2 | N | 200 |  | Chính sách tín dụng áp dụng cho hồ sơ |
| 19 | CAMPAIGN | VARCHAR2 | N | 200 |  | Chương trình bán áp dụng cho hồ sơ |
| 20 | PROOF_OF_INCOME | VARCHAR2 | N | 200 |  | Hình thức chứng minh thu nhập |
| 21 | CUS_SEGMENT | VARCHAR2 | N | 100 |  | Phân khúc khách hàng theo LOS |
| 22 | BI_CUS_SEGMENT | VARCHAR2 | N | 50 |  | Phân khúc khách hàng chuẩn hóa để hiển thị trên báo cáo |
| 23 | COLL_REQUIRE | VARCHAR2 | N | 10 |  | Sản phẩm có yêu cầu tài sản bảo đảm hay không |
| 24 | IS_SEC_PRODUCT | VARCHAR2 | N | 10 |  | Hồ sơ có sản phẩm phụ đi kèm hay không |
| 25 | DEVIATION_FLAG | VARCHAR2 | N | 10 |  | Hồ sơ có ngoại lệ chính sách hay không |
| 26 | CREATION_DATE | DATE | N | 50 |  | Ngày khởi tạo hồ sơ |
| 27 | RESULT_MAIN_CARD_ID | VARCHAR2 | N | 100 |  | Mã thẻ chính do hệ thẻ trả về |
| 28 | ORG_UNIT_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_ORG_UNIT. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 29 | PRODUCT_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_PRODUCT. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 30 | APPROVAL_GROUP_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_APPROVAL_GROUP. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 31 | CUSTOMER_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_CUSTOMER. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 32 | CHANGE_TYPE_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_CHANGE_TYPE. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 33 | CARD_PROMOTION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_PDTD_CARD_PROMOTION. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 34 | EFF_DATE | DATE | Y |  |  | Ngày bắt đầu hiệu lực của bản ghi |
| 35 | EXP_DATE | DATE | N |  |  | Ngày hết hiệu lực của bản ghi |
