# Quyết định đã chốt — BC3 (Báo cáo Thông tin phê duyệt)

File câu lệnh: `mapping/BAOCAO/BC3_APPROVAL_INFO.sql`

## Grain

| Điểm | Quyết định | Ngày | Ghi chú |
|---|---|---|---|
| Sự kiện phê duyệt (`FCT_CLOS_WORKSTEP_EVENT`, `FCT_RLOS_WORKSTEP_EVENT`) × tài sản (`FCT_CLOS_COLLATERAL`, `FCT_RLOS_COLLATERAL`) | Nhiều dòng: 1 dòng / (sự kiện phê duyệt × tài sản), không gộp; hồ sơ không có tài sản vẫn ra 1 dòng (LEFT JOIN) | 2026-11-13 | Khớp SRS (alias map) và testcase BA |

## Điều kiện lọc

| Điểm | Quyết định | Ngày | Ghi chú |
|---|---|---|---|
| `DECISION` của sự kiện phê duyệt | So sánh không phân biệt hoa thường: `UPPER(DECISION_CODE) IN ('SUBMIT','REJECT','SEND TO HOSUPPORT','SEND TO POSTSANCTION')`; không thêm `Submit To DisbursementMaker` | 2026-11-13 | SRS BC3 ghi `'Send to ...'` (khác BC1/BC2 `'Send To ...'`); đặt ở điều kiện lọc sự kiện, cả 2 nhánh |

## Nguồn cột

| Điểm | Quyết định | Ngày | Ghi chú |
|---|---|---|---|
| `CUSTOMER_NAME` nhánh RLOS | `FCT_RLOS_CUSTOMER.FULL_NAME` qua 1 dòng đại diện / hồ sơ (`ROW_NUMBER`, ưu tiên giấy tờ TCC/CC), đúng nguồn SRS `APPLICANT_GENERAL.FULL_NAME` | 2026-11-13 | Không dùng `DIM_RLOS_APPLICATION.CUSTOMER_NAME` (nguồn `EXTTABLE`); nhất quán với BC1 |

## Giả định kỹ thuật (đã nêu với người dùng)

- Ngày báo cáo = `EXITDATE` của sự kiện (BR 1.1 BC3), không phải `PROCESSED_DATE`. Lọc chi nhánh qua `COMPANY_SK` của snapshot hồ sơ.
- Phiên bản sự kiện: chỉ lấy phiên bản mới nhất theo `WORKSTEP_EVENT_BK` (`NOT EXISTS` DAYID lớn hơn), giới hạn đến ngày báo cáo.
- UNION ALL hai nhánh: các cột khác kiểu giữa CLOS và RLOS (`APPRAISED_VALUE`, `LTV`, `CREDIT_TERM`, `CURRENCY`) ép về `NVARCHAR2` (nhánh RLOS dùng `TO_NCHAR`).
- `COLLATERA_MANAGEMENT` chỉ có ở SRS CLOS; nhánh RLOS để `NULL`.
