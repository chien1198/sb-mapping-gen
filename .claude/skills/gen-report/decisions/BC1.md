# Quyết định đã chốt — BC1 (Báo cáo RLOS APPLICATION)

File câu lệnh: `mapping/BAOCAO/BC1_RLOS_APPLICATION.sql`

## Grain

| Điểm | Quyết định | Ngày | Ghi chú |
|---|---|---|---|
| `FCT_RLOS_COREPAYER` (CO_REPAYER, ADD_ID_COREPAYER, ADD_ID_OTHER_COREPAYER) | Nhiều dòng: 1 dòng / người đồng trả nợ (theo `ID_NO_CO`); giấy tờ của cùng một người gộp `;` | 2026-11-13 | Hồ sơ không có người đồng trả nợ vẫn ra 1 dòng (LEFT JOIN) |
| `FCT_RLOS_APPLICATION_SECONDPRODUCT` (SAN_PHAM_PHU, SPP_AMOUNT, SPP_TERM) | Nhiều dòng: 1 dòng / lần đăng ký SP phụ, join trực tiếp, giữ kiểu số, không `LISTAGG` | 2026-11-13 | Số dòng nhân tích với đồng trả nợ (N người × M SP phụ) |
| `FCT_RLOS_CUSTOMER` (ADD_ID, ADD_ID_OTHER) | Giữ nguyên: `LISTAGG(DISTINCT ..., ';')` 1 dòng / hồ sơ, không thêm `ON OVERFLOW TRUNCATE` | 2026-11-13 | Người dùng xác nhận giữ đúng như hiện tại; theo testcase BA và SRS |
| `FCT_RLOS_COLLATERAL` (OWNERSHIP, GCN_REAL_ESTATE, GCN_OTHER, TSBD_RELATIONSHIP) | Nhiều dòng: 1 dòng / tài sản bảo đảm, không gộp (như testcase BA cụm 3A); 3 cờ TSBD_BDS/PTVT/GTCG tính theo hồ sơ | 2026-11-13 | Số dòng nhân tích với đồng trả nợ và SP phụ (N người × M SP phụ × K tài sản). Người dùng xác nhận không thể gộp |
| Applicant (CUSTOMER_NAME, địa chỉ, ngày sinh...) | 1 dòng đại diện / hồ sơ: `ROW_NUMBER` ưu tiên giấy tờ TCC/CC | 2026-11-13 | Theo LLD |

## Giữ nguyên hiện trạng gen

| Điểm | Quyết định | Ngày | Ghi chú |
|---|---|---|---|
| CUSTOMER_ID | Giữ: `DIM_T24_CUSTOMER` qua `T24_CUSTOMER_SK` của dòng đại diện | 2026-11-13 | |
| LAST_DECISION | Giữ: `a.DECISION_CODE` | 2026-11-13 | |
| CURRENT_RESIDENTIAL_ADDRESS | Giữ ghép `CITY_NAME`/`DISTRICT_NAME` (bản không dấu) | 2026-11-13 | Lệch HLD (dùng `*_VN`) — giữ theo chỉ đạo |
| TSBD_GTCG | Giữ cờ theo loại `VALPAPER` (không xét `NUMBERSIGN`) | 2026-11-13 | Khớp testcase BA/SRS |
| PRODUCT_LINE | Giữ `a.PRODUCTLINE_CODE` (bảng `FCT_RLOS_APPLICATION`) | 2026-11-13 | |
| SUB_PRODUCT | Giữ `pr.SUB_PRODUCT_NAME` | 2026-11-13 | |
| OWNERSHIP | Giữ lọc `COLLATERAL_TYPE_CODE = 'REALESTATE'` | 2026-11-13 | `FCT_RLOS_COLLATERAL` gộp 4 nguồn nên phải lọc loại |

## Theo LLD (không cảnh báo)

DATE_OF_BIRTH, GENDER (lấy từ `FCT_RLOS_CUSTOMER`, không qua T24) · BRANCH_CODE, BRANCH_NAME, COMPANY_CODE, COMPANY_NAME
(qua `DIM_LOS_COMPANY`) · INTEREST_RATE (`INTEREST_RATE_PCT`) · CREATION_DATE, PROCESSED_DATE, LAST_DECISION (ETL ở
SB_DWH/PDTD_DTM) — LLD là nguồn đáng tin; các điểm này lineage `check_report.py` có thể hiện `mismatch` so với chữ SRS.
