# Quyết định đã chốt — BC2 (Báo cáo CLOS APPLICATION)

File câu lệnh: `mapping/BAOCAO/BC2_CLOS_APPLICATION.sql`

## Grain

| Điểm | Quyết định | Ngày | Ghi chú |
|---|---|---|---|
| `FCT_CLOS_COLLATERAL` (9 cờ TSDB_NHOM_0, PTVT, BDS, MMTB, KPT, HTK, TIN_CHAP, TIN_CHAP_TQD, CP_TP) | Cờ theo hồ sơ: `MAX(CASE ...)`, 1 dòng / hồ sơ; `TSDB_NHOM_0` = có dòng `COLLTYPE IS NOT NULL`; hồ sơ không có tài sản → 'NO' | 2026-11-13 | Khớp testcase BA (phần 3) |
| `FCT_CLOS_DEVIATION` (DEV_PROPOSAL) | Nhiều dòng: 1 dòng / ngoại lệ, join trực tiếp, không `LISTAGG` | 2026-11-13 | Khớp testcase BA (phần 1) và alias map SRS. Hồ sơ không có ngoại lệ vẫn ra 1 dòng (LEFT JOIN) |
| LEGAL_REPRESENTATIVE, ADD_ID_REPRESENTATIVE | Lấy từ `FCT_CLOS_APPLICATION` (LLD đã `LISTAGG ';'` theo hồ sơ) | 2026-11-13 | Theo LLD |

## Theo LLD (không cảnh báo)

CUSTOMER_ID qua `DIM_T24_CUSTOMER` / `T24_CUSTOMER_SK` · BRANCH_CODE, BRANCH_NAME, COMPANY_CODE, COMPANY_NAME qua
`DIM_LOS_COMPANY` · BI_FLOW, APPROVAL_TYPE, BI_APPSTATUS, FLAG_AUTO_CAN là cột phái sinh đã tính ở PDTD_DTM ·
ID_NUMBER lấy `DIM_CLOS_CUSTOMER.CUSTOMER_CODE` · LAST_DECISION lấy `a.DECISION_CODE` (nhất quán với BC1).
