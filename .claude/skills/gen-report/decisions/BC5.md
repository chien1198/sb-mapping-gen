# Quyết định đã chốt — BC5 (Báo cáo SLA - TAT)

File câu lệnh: `mapping/BAOCAO/BC5_SLA_TAT.sql`

## Quyết định của người dùng

| Điểm | Quyết định | Ngày | Ghi chú |
|---|---|---|---|
| Grain | Tối đa 2 dòng / hồ sơ (mỗi nhánh CLOS, RLOS): `BI_FLAG_APPROVAL` = 'First Approval' (lần PD đầu hoặc chưa PD) / 'From Second Approval' (đã PD lần 1 và quay lại bước PDTD; PD lần 3 trở đi gộp chung) | 2026-11-25 | Thay quyết định 1 dòng/hồ sơ ngày 2026-11-13 theo BA mới; hồ sơ chỉ ở BranchSupport không lên báo cáo |
| Nguồn dòng lần PD đầu | Bảng `AGG_LOS_SLA_TAT_APPROVAL` (append-only, 1 dòng/hồ sơ, chỉ lần duyệt đầu Approved/Rejected); BC5 UNION ALL bảng này (lọc `PROCESSED_DATE` trong khoảng) với phần tính trực tiếp từ `FCT_*_APPLICATION` + `FCT_*_WORKSTEP_EVENT` | 2026-11-25 | Phần tính trực tiếp giữ `DAYID = :p_date_to` như cũ (không dùng MAX(DAYID)). Dòng 'Second' có `processed_date` là ngày PD gần nhất nên chỉ hiện khi `:p_date_to` từ ngày hồ sơ bị trả về trở đi |
| Phần đọc bảng mới | Chỉ lọc `PROCESSED_DATE`, không cần lọc `DAYID` | 2026-11-25 | Người dùng chốt: bảng chỉ chứa hồ sơ đã Approved/Rejected nên không cần lọc `DAYID` (bỏ điều kiện `t.DAYID <= :p_date_to` đề xuất). Lưu ý kỹ thuật: chỉ khi chạy lại cho `:p_date_to` quá khứ mà hồ sơ được hệ thống thấy duyệt sau ngày đó (dữ liệu về trễ) thì phần live còn 'Processing' trong khi bảng đã có dòng 'Approved' |
| Trạng thái dòng 'From Second Approval' | 'Processing' nếu `LAST_WORKSTEP` thuộc bước PDTD và `LAST_ENTRYDATE >= PROCESSED_DATE` (hồ sơ đang ở bước PDTD sau lần phê duyệt gần nhất); còn lại `APPLICATION_STATUS` (gồm 'Cancelled' khi hồ sơ đã Approved/Rejected rồi bị hủy tại bước PDTD — FCT xử lý sẵn) | 2026-11-25 (chỉnh lần 2 cùng ngày) | BC1/BC2 lấy thẳng `FCT_*_APPLICATION.APPLICATION_STATUS` (Cancelled khi duyệt/kháng nghị rồi bị hủy tại bước PDTD; trả về PDTD chờ duyệt lại vẫn Approved/Rejected); BC5 chỉ thêm Processing. Không thêm cột FCT. Thay cách cũ (PRE_WORKSTEP_CODE + đếm event INFLIGHT_CNT ở tầng report) |
| Khóa tra `REF_SLA_NLTT` nhánh CLOS, `SUB_PRODUCT` | Dòng khớp `SUB_PRODUCT` cụ thể thắng dòng mặc định (`SUB_PRODUCT IS NULL`): join 2 lần + `COALESCE`, cùng quy ước `FCT_CLOS_APPLICATION.REF_PRODUCT/SLA_*` | 2026-11-25 | Seed `REF_SLA_NLTT` có 4 nhóm (New/Change Request × 'Cấp tín dụng ngắn hạn'/'Hạn mức') có cả 2 loại dòng; join theo chữ SRS/testcase BA (NULL hoặc khớp) sẽ nhân dòng. Bổ sung ngoài chữ SRS — người dùng đã chốt 2026-11-25 |
| Khóa tra `REF_SLA_NLTT` nhánh RLOS | `PRODUCT_LINE = DIM_RLOS_PRODUCT.PRODUCTLINE_NAME` (qua `a.SUB_PRODUCT_SK`) + `SYSTEMNAME='RLOS'` | 2026-11-13 | Không dùng `PRODUCTLINE_CODE` |
| Giá trị TAT | Dùng thẳng `TAT_CALENDAR_HOUR` / `TAT_WORKING_HOUR` / `TAT_CPC_HOUR` của `FCT_*_WORKSTEP_EVENT` (LLD đã tính, buộc treo đến hết ngày batch); không tự tính `get_business_minute` | 2026-11-13 | |

## Giả định đã nêu (không bị phản đối)

- Phạm vi (2026-11-20, khoảng ngày `:p_date_from`/`:p_date_to`): `FCT_*_APPLICATION` có `DAYID = d_to` và `PROCESSED_DATE` trong `[d_from, d_to]` (BR 1.1); lọc chi nhánh qua `COMPANY_SK`.
- Lịch sử sự kiện: chỉ lấy phiên bản mới nhất theo `WORKSTEP_EVENT_BK`, `DAYID <= d_to`, **không chặn dưới** theo `d_from` vì TAT cộng toàn bộ các bước của hồ sơ. Từ 2026-11-25: hồ sơ đã PD lần 1 chỉ lấy event SAU lần duyệt đầu (`NVL(EXITDATE, ENTRYDATE) > MIN_APP_EXITDATE`) cho dòng 'From Second Approval'; thêm `PhoneVerification` vào danh sách bước chỉ để xét "quay lại PDTD" (không có cột TAT riêng).
- `ROUND(..., 2)` cho mọi cột TAT (theo testcase BA). `STEP07_COMMITTEE_*` chỉ có `CL_TAT`, `WK_TAT` (SRS không có CPC).
- `TAT_KHOI_PDTD_*`: RLOS = Phòng thẩm định + `CreditApproval` nếu hồ sơ chưa có `CreditCommittee` (testcase BA); CLOS = cộng cả 4 bước (SRS và BA).
- CLOS: bước nhập liệu gồm cả `CLOS_DetailDataEntry`, `CLOS_DataInputerChecker` (SRS CLOS).
- `REF_SLA_NLTT` nhánh CLOS: `NEW_CHANGE_REQUEST = a.CHANGE_REQUEST`, `PRODUCT_LINE = DIM_CLOS_PRODUCT.PRODUCTLINE_NAME`, nối theo `a.PRODUCTLINE_SK` (không phải `DIMENSION_KEY`; `DIM_CLOS_PRODUCT` có 3 khóa riêng) qua subquery lấy 1 dòng/`PRODUCTLINE_SK` (tên mới nhất theo `PRODUCTLINE_EFF_DATE`) — người dùng chốt phương án (a) 2026-11-13, `SUB_PRODUCT`: dòng khớp `DIM_CLOS_APPLICATION.SUB_PRODUCT` thắng dòng mặc định NULL (bản 2026-11-13 là "NULL hoặc khớp" theo testcase BA, đã thay ngày 2026-11-25, xem bảng trên).
- `SLA_DE`/`SLA_QC` = cột `SLA_DE_RESULT`/`SLA_QC_RESULT` của `REF_SLA_NLTT` (đó là số giờ cam kết).
- Giữ chính tả `RESUTL` của SRS ở `SLA_MARKER_RESUTL`, `SLA_CHECKER_RESUTL`, `SLA_CO_RESUTL`.

## Theo LLD (không cảnh báo)

`REF_PRODUCT`, `SLA_CREDIT_OFFICER/APPROVER`, `SLA_MARKER`, `SLA_CHECKER` lấy từ `FCT_*_APPLICATION` (LLD đã tra bảng `*_REF_SLA_*`).
