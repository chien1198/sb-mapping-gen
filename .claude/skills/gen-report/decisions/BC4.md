# Quyết định đã chốt — BC4 (Báo cáo Tuần Chuyên viên Thẩm định)

File câu lệnh: `mapping/BAOCAO/BC4_UW_WEEKLY.sql`

## Grain và phạm vi

| Điểm | Quyết định | Ngày | Ghi chú |
|---|---|---|---|
| Grain | 1 dòng / hồ sơ (mỗi nhánh CLOS, RLOS). `WORKSTEP`, `UND_MAKER`, `REMARKS` lấy từ dòng sự kiện `UnderwriterMaker` mới nhất; `ENTRYDATE`/`EXITDATE` là MIN/MAX cả hồ sơ tại `UnderwriterMaker` + `UnderwriterChecker` | 2026-11-13 | Khớp SRS và testcase BA |
| `FLAG` | Cấp hồ sơ, thứ tự ưu tiên 5 nhánh SRS (nhánh nhỏ hơn thắng): nhánh theo **quyết định** (đã phê duyệt / CVTĐ chốt / chuyển-trả lại) lấy từ mọi dòng sự kiện; nhánh theo **trạng thái workflow** (chưa PD / đang-phải xử lý) chỉ lấy từ **dòng mới nhất** (`DAYID`, `ENTRYDATE` lớn nhất) | 2026-11-13 | `WORKSTEP_FLAG` ở LLD tính theo từng dòng; dòng cũ giữ `WF_ACTIVITYNAME` lúc ghi nên không dùng cho nhánh trạng thái (khớp SRS/BA: trạng thái hiện tại trên `WFINSTRUMENTTABLE`) |
| Phạm vi ngày | `REPORT_DATE` (= `PROCESSED_DATE` của sự kiện) đúng bằng ngày báo cáo chọn; `REPORT_WEEK` chỉ hiển thị tuần chứa ngày đó | 2026-11-13 | Giống BC1–BC3 |

## Theo LLD / quyết định trước (không cảnh báo)

- `REPORT_DATE` = `FCT_*_WORKSTEP_EVENT.PROCESSED_DATE` (LLD đã tính theo quy tắc BC4).
- `REPORT_WEEK` **tính trực tiếp trong câu lệnh báo cáo** (môi trường không có bảng `DIM_DATE`, người dùng xác nhận 2026-11-13):
  `TO_CHAR(TRUNC(REPORT_DATE,'IW'),'YYYYMMDD') || '-' || TO_CHAR(TRUNC(REPORT_DATE,'IW') + 6,'YYYYMMDD')` (Thứ 2 – Chủ nhật, tuần ISO).
  Không dùng `DIM_DATE.REPORT_WEEK` dù LLD có cột này.
- Phạm vi hồ sơ: `FCT_*_APPLICATION.HAS_UWM_FLAG = 'Y'` (ghi chú LLD, thay `EXISTS`).
- `CUSTOMER_NAME` nhánh RLOS: `FCT_RLOS_CUSTOMER.FULL_NAME` qua 1 dòng đại diện (nhất quán BC3).

## Giả định kỹ thuật (đã nêu với người dùng)

- Dòng sự kiện trong phạm vi: `DAYID` = ngày báo cáo và `PROCESSED_DATE` trong ngày (hồ sơ đang treo được carry-forward theo LLD).
- `ENTRYDATE`/`EXITDATE`/`FLAG`/dòng `UnderwriterMaker` mới nhất đọc lịch sử sự kiện: chỉ lấy phiên bản mới nhất theo `WORKSTEP_EVENT_BK` (`NOT EXISTS`), `DAYID` đến ngày báo cáo.
