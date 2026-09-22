# Self-review checklist — chạy trước khi trình bày mỗi file CSV

Chưa có mục kiểm tra nào được chốt — file này khởi đầu rỗng có chủ đích.
Không dùng bộ TC script Python đối chiếu multi-module như skill mẫu
(`datamart-lld-design`, dự án đó có registry nhiều module để đối chiếu
chéo; dự án này chỉ có 1 nguồn sự thật duy nhất —
`hld/HLD_Table_Design.md`).

Bổ sung mục kiểm tra vào đây **khi phát hiện lỗi thực tế** trong quá trình
làm từng bảng — không định trước số lượng hay nội dung mục kiểm tra khi
chưa có bằng chứng cụ thể cần kiểm tra gì. Đặt tên mục theo lỗi đã phát
hiện (VD "RV — cột `_SK` bị gán nhầm `key=PK` dù không thuộc PK composite"),
không đánh số thứ tự cố định trước.

## RV — `etl_logic` dùng ký hiệu `<current>` thay vì `table_name.column_name`

**Lỗi đã phát hiện (review 2026-09-22, `DIM_CLOS_APPLICATION.FIRST_APPROVED_DATE`):**
công thức `MAX(EXITDATE) trên NG_SB_CLOS_ENTRY_EXIT WHERE WI_NAME=<current>
AND ...` dùng ký hiệu tắt `<current>` để chỉ "dòng đang build của target
table" — đây là pseudo-code, không phải SQL hợp lệ, và không tự giải thích
được alias nào ứng với bảng nào khi có nhiều bảng tham gia.

**Quy ước chuẩn hoá đã thống nhất với người dùng:** với mọi công thức
`etl_logic` dạng lookup/aggregate phụ trợ (không phải driving table chính
của dòng CSV) cần correlate theo khóa của driving table, viết dưới dạng
`LEFT JOIN (subquery aggregate) <alias> ON <alias>.<col> =
<DRIVING_TABLE>.<col>` — trong đó:

- Mọi cột bên trong subquery viết đầy đủ `table_name.column_name`, không
  dùng alias rút gọn kiểu `ee`/`ext`.
- Alias của derived table (bắt buộc phải có theo cú pháp SQL) đặt trùng
  tên với bảng nguồn bên trong nó (VD subquery từ `NG_SB_CLOS_ENTRY_EXIT`
  → alias derived table cũng là `NG_SB_CLOS_ENTRY_EXIT`) — vì bảng gốc chỉ
  tồn tại trong phạm vi subquery, ra ngoài không xung đột tên. Nhờ đó toàn
  bộ công thức vẫn đọc được dưới dạng `table_name.column_name` xuyên suốt,
  không phát sinh alias lạ.
- Điều kiện lọc phụ (VD `WORKSTEP IN (...)`, `DECISION IN (...)`) đặt bên
  trong subquery (WHERE) trước khi GROUP BY, KHÔNG đặt ở ngoài (sau khi
  JOIN) — nếu đặt sai chỗ, LEFT JOIN sẽ biến tướng thành INNER JOIN và làm
  mất các dòng driving không khớp điều kiện (sai ý nghĩa "trả NULL nếu
  hồ sơ chưa qua bước này").
- Không dùng `<current>` hay bất kỳ ký hiệu giữ chỗ nào khác — driving
  table của dòng CSV đó luôn viết tên bảng thật (VD `NG_SB_CLOS_EXTTABLE`)
  trong vế `ON`.

**Cách kiểm tra khi self-review:** với mỗi dòng `etl_logic_type` thuộc
`computed`/`join` có chứa `MAX(`/`MIN(`/`SUM(`/`COUNT(` (tức là aggregate
lookup phụ trợ), grep chuỗi `<current>` — nếu còn xuất hiện, viết lại theo
mẫu `LEFT JOIN (...) <TABLE_ALIAS> ON <TABLE_ALIAS>.<col> =
<DRIVING_TABLE>.<col>` như trên trước khi trình bày file.

**Test case đối chiếu (dùng làm mẫu khi review các bảng tiếp theo):**

```
input (etl_logic sai):
MAX(EXITDATE) trên NG_SB_CLOS_ENTRY_EXIT WHERE WI_NAME=<current> AND
USERNAME IS NOT NULL AND WORKSTEP IN ('CreditApproval','CreditCommittee')
AND DECISION IN ('Submit','Send To HOSupport','Send To PostSanction')

output đúng (etl_logic sau chuẩn hoá):
LEFT JOIN (
    SELECT NG_SB_CLOS_ENTRY_EXIT.WINAME, MAX(NG_SB_CLOS_ENTRY_EXIT.EXITDATE) AS FIRST_APPROVED_DATE
    FROM NG_SB_CLOS_ENTRY_EXIT
    WHERE NG_SB_CLOS_ENTRY_EXIT.USERNAME IS NOT NULL
      AND NG_SB_CLOS_ENTRY_EXIT.WORKSTEP IN ('CreditApproval', 'CreditCommittee')
      AND NG_SB_CLOS_ENTRY_EXIT.DECISION IN ('Submit', 'Send To HOSupport', 'Send To PostSanction')
    GROUP BY NG_SB_CLOS_ENTRY_EXIT.WINAME
) NG_SB_CLOS_ENTRY_EXIT ON NG_SB_CLOS_ENTRY_EXIT.WINAME = NG_SB_CLOS_EXTTABLE.WI_NAME
→ NG_SB_CLOS_ENTRY_EXIT.FIRST_APPROVED_DATE
```

Lưu ý khác biệt tên cột giữa 2 bảng (`WI_NAME` phía driving vs `WINAME`
phía ENTRY_EXIT) — giữ nguyên đúng tên cột thật của từng bảng, không tự ý
đổi cho khớp nhau.

> Áp dụng lại quy ước này cho MỌI dòng `<current>` còn sót trong các file
> `lld/` đã sinh trước 2026-09-22 khi có dịp sửa/rà soát lại bảng đó — chưa
> cần chủ động quét sửa hàng loạt nếu người dùng không yêu cầu.
