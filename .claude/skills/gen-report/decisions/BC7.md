# Quyết định đã chốt — BC7 (Báo cáo EXCEPTION - FTR)

File câu lệnh: `mapping/BAOCAO/BC7_EXCEPTION_FTR.sql`

## Quyết định của người dùng

| Điểm | Quyết định | Ngày | Ghi chú |
|---|---|---|---|
| Grain | 1 dòng / (exception × bước), đúng grain `FCT_*_EXCEPTION` (`DAYID`, `EXCEPTION_BK`, `WORKSTEP_CODE`) | 2026-11-13 | Không dùng `ROWNUM = 1` như testcase BA |
| `PROCESSED_DATE` | `TRUNC(RAISED_DATE_TIME)` cho cả CLOS và RLOS | 2026-11-13 | SRS RLOS không ghi TRUNC |
| Phạm vi ngày | `DAYID` = ngày báo cáo (snapshot đầy đủ) và `RAISED_DATE_TIME` trong ngày báo cáo | 2026-11-13 | Người dùng xác nhận một `DAYID` đủ dữ liệu |

## Theo LLD (không cảnh báo)

- `ACTIVITYNAME` = `WORKSTEP_CODE`; `CHECK_FTR` (CLOS theo `CUST_GROUP`, RLOS công thức riêng, đã giản lược theo SRS 28/10); `FIRST_WORKSTEP_RETURN`; `PHAN_LOAI_DDE` đã tính ở LLD.
- `EXCEPTION_CODE` phái sinh tại báo cáo theo SRS; `LOANCASEID` qua `DIM_*_APPLICATION`.
- Lọc chi nhánh qua `FCT_*_APPLICATION.COMPANY_SK` tại cùng `DAYID`.
