# Quyết định đã chốt — BC8 (Báo cáo RETURN)

File câu lệnh: `mapping/BAOCAO/BC8_RETURN.sql` (đã gen 2026-11-13 sau khi LLD/HLD có 3 cột `RETURN_CNT_*`)

## Quyết định của người dùng

| Điểm | Quyết định | Ngày | Ghi chú |
|---|---|---|---|
| Grain | 1 dòng / sự kiện (dòng `FCT_*_WORKSTEP_EVENT` có `WORKSTEP_CODE` thuộc 6 bước và `DECISION_CODE` thuộc nhóm trả về/hủy); `SL_RETURN_*` lặp lại giá trị của hồ sơ | 2026-11-13 | Khớp testcase BA |
| `PROCESSED_DATE` | `TRUNC(EXITDATE)` | 2026-11-13 | Nhất quán BC7 |
| Phạm vi đếm `SL_RETURN_*` | Đếm toàn bộ lịch sử đến ngày báo cáo, thực hiện bằng **cột đếm lũy kế trên `FCT_*_APPLICATION`** (không đếm report-time) | 2026-11-13 | Người dùng chốt phương án cột lũy kế |
| Tên cột | `RETURN_CNT_DATAENTRY`, `RETURN_CNT_UNDERWRITING`, `RETURN_CNT_APPROVAL` (ánh xạ sang `SL_RETURN_NHAPLIEU`, `SL_RETURN_THAMDINH`, `SL_RETURN_PHEDUYET` ở báo cáo) | 2026-11-13 | Trùng tên HLD cũ |
| Phần trừ exception | Lấy từ lát cắt `STG_FCT_*_EXCEPTION` (không từ `FCT_*_EXCEPTION`) để tránh vòng phụ thuộc job | 2026-11-13 | `FCT_*_EXCEPTION` đọc `FCT_*_APPLICATION` nên phải chạy sau |
| Đối soát định kỳ | Không cần job đối soát; chấp nhận cột đếm không tự phục hồi nếu bỏ lỡ ngày batch | 2026-11-13 | |

## Thiết kế ETL đã chốt (người dùng tự bổ sung vào LLD)

Mẫu C (cộng dồn): `RETURN_CNT_x = NVL(PREV.RETURN_CNT_x, 0) + <số sự kiện return phát sinh lần đầu trong lát cắt hôm nay>`, `PREV` = `FCT_*_APPLICATION_PREV`.
- Sự kiện mới = dòng `STG_FCT_*_WORKSTEP_EVENT` có `EXITDATE IS NOT NULL` và `NOT EXISTS` dòng cùng `WORKSTEP_EVENT_BK` ở `DAYID` nhỏ hơn đã có `EXITDATE` (chống đếm trùng, chạy lại cùng ngày cho kết quả cũ).
- Exception mới = dòng `STG_FCT_*_EXCEPTION` có `EXCEPTION_BK` chưa xuất hiện ở `FCT_*_EXCEPTION` tại `DAYID` nhỏ hơn; đếm `DISTINCT EXCEPTION_BK`.
- Nạp lịch sử lần đầu (go-live) từ toàn bộ `NG_SB_*_ENTRY_EXIT` và exception.
- Đồng bộ HLD: `HLD_FCT_SB_DWH_review.md:529`, `HLD_FCT_PDTD_DTM_review.md` (dòng 230, 823).

## Khi gen BC8 sau khi LLD có 3 cột

Câu lệnh đọc 3 cột từ `FCT_*_APPLICATION` tại `DAYID` = ngày báo cáo, ghép với các sự kiện return có `EXITDATE` trong ngày (`DAYID` = ngày báo cáo, `WORKSTEP_CODE` thuộc 6 bước, `DECISION_CODE` thuộc nhóm trả về/hủy), 1 dòng/sự kiện, `PROCESSED_DATE = TRUNC(EXITDATE)`, lọc chi nhánh qua `COMPANY_SK`, ghép CLOS và RLOS bằng `UNION ALL`.


## Ghi chú cho điều chỉnh thiết kế: bổ sung 3 cột đếm lũy kế

**Hiện trạng thiết kế:** `RETURN_CNT_DATAENTRY/UNDERWRITING/APPROVAL` không còn ETL sẵn. `HLD_FCT_PDTD_DTM_review.md` (dòng 230 và 823) ghi BC8 "tự SUM/COUNT report-time từ `FCT_*_WORKSTEP_EVENT`". `HLD_FCT_SB_DWH_review.md:529` còn ghi cột này ở SB_DWH (mô tả cũ, cần đồng bộ). Không có cột nào trong `lld/` hoặc `Scripts_Golive/ddl/`.

**Vấn đề:** đếm lịch sử trên `FCT_*_WORKSTEP_EVENT` (phân vùng theo `DAYID`, khóa chính `(WORKSTEP_EVENT_BK, DAYID)`, chỉ mục `(WI_NAME, WORKSTEP_CODE, ENTRYDATE)`) phải quét nhiều phân vùng và lọc phiên bản mới nhất bằng `NOT EXISTS`; chi phí tăng theo độ dài lịch sử.

**Đề xuất (phương án B):** thêm 3 cột vào `FCT_RLOS_APPLICATION` và `FCT_CLOS_APPLICATION`, carry-forward cộng dồn theo ngày cùng cơ chế `*_PREV` đang dùng cho `FIRST_WORKSTEP_RETURN`, `MIN_UWM`... Báo cáo chỉ đọc 1 dòng/hồ sơ.

| Cột đề xuất | Kiểu | Công thức theo SRS BC8 (đếm trên sự kiện đã kết thúc, phiên bản mới nhất theo `WORKSTEP_EVENT_BK`) |
|---|---|---|
| `SL_RETURN_NHAPLIEU` | NUMBER | `DetailDataEntry` + `Send_Back`, cộng `DataInputerChecker` + `Additional_Doc_Required` |
| `SL_RETURN_PHEDUYET` | NUMBER | `CreditApproval` / `CreditCommittee` + `Additional_Doc_Required` |
| `SL_RETURN_THAMDINH` | NUMBER | CLOS: `UnderwriterMaker` + `Additional_Doc_Required` trừ số exception có `EXCEPTION_CATEGORY = 'Gửi dự thảo đề xuất cho chi nhánh'`, cộng `UnderwriterChecker` + `Additional_Doc_Required` (không trừ). RLOS: (`UnderwriterMaker` + `Additional_Doc_Required` trừ `COUNT(DISTINCT EXCEPTION_BK)` có `EXCEPTION_NAME = 'UW-BR-FTR: Gửi dự thảo phê duyệt TD'`) cộng (`UnderwriterChecker` + `Additional_Doc_Required` trừ `COUNT(DISTINCT EXCEPTION_BK)` có `EXCEPTION_CATEGORY = 'CK-BR: Gửi dự thảo về ĐVKD'`) |

**Cần cân nhắc khi thiết kế ETL:**
- Cộng dồn theo delta cần tránh đếm trùng: sự kiện đổi phiên bản qua các `DAYID` (mở ngày 1, đóng ngày 2 = 2 dòng), nên chỉ đếm khi sự kiện chuyển sang trạng thái đã có quyết định lần đầu, hoặc tính lại từ phiên bản mới nhất.
- Nhánh carry-forward hồ sơ treo copy dòng sự kiện sang `DAYID` mới: phải loại bản copy khỏi phép đếm (cùng `WORKSTEP_EVENT_BK`).
- Phần trừ exception phụ thuộc `FCT_*_EXCEPTION` (đếm `DISTINCT EXCEPTION_BK` vì một exception có thể sinh nhiều dòng theo `WORKSTEP_CODE`), nên job đếm phải chạy sau `FCT_*_EXCEPTION`.
- Sau khi có cột, cập nhật `BC8_RETURN.sql` để đọc 3 cột từ `FCT_*_APPLICATION` và chạy lại `check_report.py`.
