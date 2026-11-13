# Quyết định đã chốt — BC6 (Báo cáo Ngoại lệ)

File câu lệnh: `mapping/BAOCAO/BC6_CLOS_DEVIATION.sql`, `mapping/BAOCAO/BC6_RLOS_DEVIATION.sql` (2 câu lệnh riêng vì bộ cột CLOS và RLOS khác nhau)

## Grain

| Điểm | Quyết định | Ngày | Ghi chú |
|---|---|---|---|
| `FCT_CLOS_DEVIATION`, `FCT_RLOS_DEVIATION` | 1 dòng / dòng ngoại lệ, không gộp (giống testcase BA) | 2026-11-13 | Bảng ngoại lệ là bảng chính |

## Giả định kỹ thuật

- Phạm vi: `DAYID` = ngày báo cáo và `PROCESSED_DATE` (tính sẵn ở SB_DWH theo 3 mức ưu tiên của SRS) trong ngày; lọc chi nhánh qua `FCT_*_APPLICATION.COMPANY_SK` tại cùng `DAYID`.
- Kiểm tra: `python3 scripts/check_report.py BC6 <file.sql> "Nguồn CLOS"|"Nguồn RLOS"` (đối chiếu từng mục SRS).
