# Quyết định đã chốt — BC5 (Báo cáo SLA - TAT)

File câu lệnh: `mapping/BAOCAO/BC5_SLA_TAT.sql`

## Quyết định của người dùng

| Điểm | Quyết định | Ngày | Ghi chú |
|---|---|---|---|
| Grain | 1 dòng / hồ sơ (mỗi nhánh CLOS, RLOS) | 2026-11-13 | Khớp SRS và testcase BA |
| Khóa tra `REF_SLA_NLTT` nhánh RLOS | `PRODUCT_LINE = DIM_RLOS_PRODUCT.PRODUCTLINE_NAME` (qua `a.SUB_PRODUCT_SK`) + `SYSTEMNAME='RLOS'` | 2026-11-13 | Không dùng `PRODUCTLINE_CODE` |
| Giá trị TAT | Dùng thẳng `TAT_CALENDAR_HOUR` / `TAT_WORKING_HOUR` / `TAT_CPC_HOUR` của `FCT_*_WORKSTEP_EVENT` (LLD đã tính, buộc treo đến hết ngày batch); không tự tính `get_business_minute` | 2026-11-13 | |

## Giả định đã nêu (không bị phản đối)

- Phạm vi: `FCT_*_APPLICATION` có `DAYID` = ngày báo cáo và `PROCESSED_DATE` trong ngày (BR 1.1); lọc chi nhánh qua `COMPANY_SK`.
- Lịch sử sự kiện: chỉ lấy phiên bản mới nhất theo `WORKSTEP_EVENT_BK`, `DAYID` đến ngày báo cáo.
- `ROUND(..., 2)` cho mọi cột TAT (theo testcase BA). `STEP07_COMMITTEE_*` chỉ có `CL_TAT`, `WK_TAT` (SRS không có CPC).
- `TAT_KHOI_PDTD_*`: RLOS = Phòng thẩm định + `CreditApproval` nếu hồ sơ chưa có `CreditCommittee` (testcase BA); CLOS = cộng cả 4 bước (SRS và BA).
- CLOS: bước nhập liệu gồm cả `CLOS_DetailDataEntry`, `CLOS_DataInputerChecker` (SRS CLOS).
- `REF_SLA_NLTT` nhánh CLOS: `NEW_CHANGE_REQUEST = a.CHANGE_REQUEST`, `PRODUCT_LINE = DIM_CLOS_PRODUCT.PRODUCTLINE_NAME`, nối theo `a.PRODUCTLINE_SK` (không phải `DIMENSION_KEY`; `DIM_CLOS_PRODUCT` có 3 khóa riêng) qua subquery lấy 1 dòng/`PRODUCTLINE_SK` (tên mới nhất theo `PRODUCTLINE_EFF_DATE`) — người dùng chốt phương án (a) 2026-11-13, `SUB_PRODUCT` NULL hoặc bằng `DIM_CLOS_APPLICATION.SUB_PRODUCT` (theo testcase BA).
- `SLA_DE`/`SLA_QC` = cột `SLA_DE_RESULT`/`SLA_QC_RESULT` của `REF_SLA_NLTT` (đó là số giờ cam kết).
- Giữ chính tả `RESUTL` của SRS ở `SLA_MARKER_RESUTL`, `SLA_CHECKER_RESUTL`, `SLA_CO_RESUTL`.

## Theo LLD (không cảnh báo)

`REF_PRODUCT`, `SLA_CREDIT_OFFICER/APPROVER`, `SLA_MARKER`, `SLA_CHECKER` lấy từ `FCT_*_APPLICATION` (LLD đã tra bảng `*_REF_SLA_*`).
