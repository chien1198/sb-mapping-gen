# DIM_LOS_APPLICATION

Nguồn: docx section "4.1.1 Bảng DIM_LOS_APPLICATION"

| STT | Tên cột | Kiểu dữ liệu | Bắt buộc | Độ lớn | Khóa | Mô tả |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | DIMENSION_KEY | NUMBER | Y | 18 | PK | Khóa chính của bảng chiều DIM_LOS_APPLICATION, sinh bằng Oracle sequence |
| 2 | APPLICATION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_APPLICATION. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 3 | WI_NAME | VARCHAR2 | Y | 100 |  | Mã hồ sơ tín dụng |
| 4 | DATASOURCE | VARCHAR2 | Y | 10 |  | Gán theo tuyến bảng nguồn/STG_LOS đã nạp hồ sơ: 'RLOS' hoặc 'CLOS' |
| 5 | LOANCASEID | VARCHAR2 | N | 100 |  | Mã khoản vay gắn với hồ sơ |
| 6 | FIRST_APPROVED_WI_NAME | VARCHAR2 | N | 100 |  | Mã hồ sơ cha đã được phê duyệt |
| 7 | FIRST_APPROVED_DATE | DATE | N |  |  | Ngày hồ sơ cha được phê duyệt |
| 8 | STREAM | VARCHAR2 | N | 200 |  | Luồng nghiệp vụ của hồ sơ |
| 9 | APPROVAL_TYPE | VARCHAR2 | N | 200 |  | Loại luồng phê duyệt |
| 10 | CHANGE_REQUEST | VARCHAR2 | N | 200 |  | Yêu cầu điều chỉnh hồ sơ |
| 11 | CREDIT_PROFILE | VARCHAR2 | N | 50 |  | Cấp tín dụng của hồ sơ |
| 12 | CUST_GROUP | VARCHAR2 | N | 100 |  | Nhóm khách hàng |
| 13 | INDUSTRY_LVL1_CODE | VARCHAR2 | N | 200 |  | Mã ngành cấp 1 |
| 14 | INDUSTRY_LVL2_CODE | VARCHAR2 | N | 200 |  | Mã ngành cấp 2 |
| 15 | INDUSTRY_LVL3_CODE | VARCHAR2 | N | 200 |  | Mã ngành cấp 3 |
| 16 | POLICY | VARCHAR2 | N | 200 |  | Chính sách tín dụng áp dụng cho hồ sơ |
| 17 | CAMPAIGN | VARCHAR2 | N | 200 |  | Chương trình bán áp dụng cho hồ sơ |
| 18 | PROOF_OF_INCOME | VARCHAR2 | N | 200 |  | Hình thức chứng minh thu nhập |
| 19 | CUS_SEGMENT | VARCHAR2 | N | 100 |  | Phân khúc khách hàng theo LOS |
| 20 | BI_CUS_SEGMENT | VARCHAR2 | N | 50 |  | Phân khúc khách hàng chuẩn hóa để hiển thị trên báo cáo |
| 21 | COLL_REQUIRE | VARCHAR2 | N | 10 |  | Sản phẩm có yêu cầu tài sản bảo đảm hay không |
| 22 | IS_SEC_PRODUCT | VARCHAR2 | N | 10 |  | Hồ sơ có sản phẩm phụ đi kèm hay không |
| 23 | DEVIATION_FLAG | VARCHAR2 | N | 10 |  | Hồ sơ có ngoại lệ chính sách hay không |
| 24 | EMPLOYEE_CODE | VARCHAR2 | N | 50 |  | Mã cán bộ quản lý hồ sơ |
| 25 | EMPLOYEE_NAME | VARCHAR2 | N | 200 |  | Tên cán bộ quản lý hồ sơ |
| 26 | CREATION_DATE | DATE | N | 10 |  | Ngày khởi tạo hồ sơ |
| 27 | RESULT_MAIN_CARD_ID | VARCHAR2 | N | 100 |  | Mã thẻ chính do hệ thẻ trả về |
| 28 | PRODUCT_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_PRODUCT. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 29 | ORG_UNIT_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_ORG_UNIT. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 30 | APPROVAL_GROUP_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_APPROVAL_GROUP. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 31 | CHANGE_TYPE_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_CHANGE_TYPE. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 32 | CARD_PROMOTION_SK | NUMBER | Y | 18 |  | Khóa tham chiếu đến bảng chiều DIM_LOS_CARD_PROMOTION. Giá trị mặc định = -1 nếu không có giá trị phù hợp |
| 33 | EFF_DATE | DATE | Y |  |  | Ngày bắt đầu hiệu lực của bản ghi |
| 34 | EXP_DATE | DATE | N |  |  | Ngày hết hiệu lực của bản ghi |
