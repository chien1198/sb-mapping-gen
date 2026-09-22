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

## RV — Alias 1-2 ký tự vẫn lọt vào công thức phức tạp nhiều bảng self-correlate

**Lỗi đã phát hiện (review 2026-09-22, `FCT_CLOS_EXCEPTION.CHECK_FTR`):**
khi viết lại công thức phức tạp (subquery `NOT EXISTS` self-correlate 4
bảng: chính driving table + 3 bảng JOIN thêm), đã tự cho phép dùng alias
1-2 ký tự (`E2`, `H`, `D`, `F`) với lý do "cần thiết vì self-correlate
nhiều bảng" ghi ngay trong `note` — đây là ngoại lệ tự đặt ra, vi phạm
đúng quy tắc "không alias rút gọn" đã áp dụng cho mọi dòng khác trong
cùng file. Độ phức tạp của công thức không phải lý do hợp lệ để nới lỏng
quy tắc đặt tên — thực ra công thức càng phức tạp càng cần alias có ý
nghĩa để người đọc còn theo dõi được.

**Quy ước:** không có ngoại lệ cho quy tắc "không alias rút gọn" dù công
thức dài/nhiều bảng self-correlate đến đâu. Khi 1 bảng phải tự tham chiếu
lại chính nó bên trong 1 subquery con (self-correlate), đặt alias có tiền
tố mô tả rõ vai trò (VD `LOOP_` cho vòng lặp con so sánh lại chính driving
table) + giữ nguyên tên bảng gốc phía sau, KHÔNG rút gọn thành chữ cái đơn
— dù phải gõ lại tên dài nhiều lần trong cùng 1 dòng CSV.

**Cách kiểm tra khi self-review:** quét toàn bộ `etl_logic` tìm pattern
alias 1-2 ký tự hoa đứng trước dấu chấm (VD ` H.`, ` D.`, ` F.`, ` E2.`)
— đặc biệt để ý các công thức DÀI/PHỨC TẠP (subquery lồng nhiều tầng,
nhiều bảng JOIN cùng lúc) vì đây chính là chỗ dễ "tặc lưỡi" viết tắt cho
gọn nhất.

**Test case đối chiếu:**

```
input (etl_logic sai — alias 1-2 ký tự dù đã ghi chú biện minh trong note):
... FROM NG_SB_CLOS_EXCEPTION E2 LEFT JOIN NG_SB_CLOS_ENTRY_EXIT H
ON H.WINAME = E2.WI_NAME LEFT JOIN NG_SB_CLOS_MAS_EXCEPTION D
ON H.WORKSTEP = D.ACTIVITYNAME ...

output đúng (alias đầy đủ, có ý nghĩa):
... FROM NG_SB_CLOS_EXCEPTION LOOP_EXCEPTION
LEFT JOIN NG_SB_CLOS_ENTRY_EXIT LOOP_ENTRY_EXIT
ON LOOP_ENTRY_EXIT.WINAME = LOOP_EXCEPTION.WI_NAME
LEFT JOIN NG_SB_CLOS_MAS_EXCEPTION LOOP_MAS_EXCEPTION
ON LOOP_ENTRY_EXIT.WORKSTEP = LOOP_MAS_EXCEPTION.ACTIVITYNAME ...
```

> Áp dụng lại quy ước này cho MỌI dòng còn alias rút gọn trong các file
> `lld/` đã sinh trước 2026-09-22 khi có dịp sửa/rà soát lại bảng đó —
> chưa cần chủ động quét sửa hàng loạt nếu người dùng không yêu cầu. Kiểm
> tra kỹ đúng những dòng `computed` dài/phức tạp nhất trong 1 bảng trước
> — đây là nơi rủi ro tái phạm cao nhất, kể cả sau khi đã tự nhận thức
> được quy tắc.

## RV — `etl_logic` trộn mô tả văn xuôi với hàm SQL, không parse được thành 1 biểu thức

**Lỗi đã phát hiện (review 2026-09-22, `DIM_RLOS_EXCEPTION_REASON.
EXCEPTION_CODE`):** công thức `REGEXP_SUBSTR(EXCEPTION_CATEGORY, '^[^:]+')
khi chuỗi có dấu hai chấm, NULL khi không có` — phần `khi chuỗi có dấu hai
chấm, NULL khi không có` là mô tả bằng lời, không phải cú pháp SQL, nên cả
biểu thức không parse được thành 1 câu SQL hợp lệ. Cùng lỗi này tồn tại ở
cả 2 bảng chị em (`DIM_CLOS_EXCEPTION_REASON`/`DIM_RLOS_EXCEPTION_REASON`)
trong HLD, nhưng LLD của CLOS đã tự viết đúng cú pháp từ trước — chỉ RLOS
và cả 2 khối HLD còn sai.

**Quy ước:** điều kiện có/không kèm theo 1 phép biến đổi bắt buộc viết
bằng `CASE WHEN <điều kiện SQL> THEN <biểu thức> ELSE NULL END` — không
bao giờ để lại phần điều kiện dưới dạng câu tiếng Việt/Anh xen giữa các
hàm SQL. Đây là lỗi khác với 4 case đã có ở trên (không phải `<current>`,
không phải thiếu mệnh đề JOIN, không phải biến ngày ETL) — cần đọc lại
TOÀN BỘ nội dung `etl_logic` như một câu lệnh SQL thật sự có thể dán vào
trình soạn thảo SQL, không chỉ quét theo 4 mẫu lỗi đã biết.

**Cách kiểm tra khi self-review:** với mỗi dòng `etl_logic`, tự hỏi "nếu
dán chuỗi này vào sau `SELECT` thì có chạy được không, hay có đoạn nào là
câu mô tả bằng ngôn ngữ tự nhiên xen giữa cú pháp SQL?". Các dấu hiệu
thường gặp: chữ "khi", "nếu", "còn lại", "trường hợp" xuất hiện NGAY SAU 1
lời gọi hàm/biểu thức mà không có `CASE WHEN`/`WHERE` đứng trước.

**Test case đối chiếu:**

```
input (etl_logic sai — mô tả văn xuôi trộn hàm SQL):
REGEXP_SUBSTR(EXCEPTION_CATEGORY, '^[^:]+') khi chuỗi có dấu hai chấm,
NULL khi không có

output đúng (CASE WHEN tường minh):
CASE WHEN INSTR(NG_SB_RLOS_MAS_EXCEPTION.EXCEPTION_CATEGORY, ':') > 0
THEN REGEXP_SUBSTR(NG_SB_RLOS_MAS_EXCEPTION.EXCEPTION_CATEGORY, '^[^:]+')
ELSE NULL END
```

> Áp dụng lại quy ước này cho MỌI dòng `etl_logic` còn mô tả kiểu văn xuôi
> xen hàm SQL trong các file `lld/` đã sinh trước 2026-09-22 khi có dịp
> sửa/rà soát lại bảng đó — chưa cần chủ động quét sửa hàng loạt nếu người
> dùng không yêu cầu. Khi rà soát 1 bảng, luôn kiểm tra chéo bảng chị em
> cùng pattern (CLOS↔RLOS) — nếu 1 bên đã tự sửa đúng trước đó mà HLD/bên
> còn lại chưa cập nhật theo, đó là dấu hiệu tài liệu bị lệch cần đồng bộ
> lại cả 2 phía, không chỉ bảng đang xem.

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

**Quy tắc này CHỈ áp dụng khi bảng aggregate KHÁC driving table** (VD
`FIRST_APPROVED_DATE` aggregate trên `NG_SB_CLOS_ENTRY_EXIT`, khác driving
table `NG_SB_CLOS_EXTTABLE` của dòng CSV). Khi phép aggregate/GROUP BY
thực hiện hoàn toàn trên chính driving table (không đọc thêm bảng nào
khác), viết gọn dạng `MAX(<DRIVING_TABLE>.<col>) GROUP BY
<DRIVING_TABLE>.<group_col>` — KHÔNG cần bọc `LEFT JOIN (subquery) alias
ON ...` self-join lại chính driving table, vì driving table đã là nguồn
duy nhất của cả dòng CSV (không có gì để "join" vào). Xem test case 2 bên
dưới (`FIRST_APPROVED_WI_NAME`, review 2026-09-22).

**Cách kiểm tra khi self-review:** với mỗi dòng `etl_logic_type` thuộc
`computed`/`join` có chứa `MAX(`/`MIN(`/`SUM(`/`COUNT(`:
1. Grep chuỗi `<current>` — nếu còn xuất hiện, phải viết lại (không được
   giữ nguyên).
2. Xác định bảng nguồn của aggregate có phải chính driving table của dòng
   CSV đó không:
   - **Khác driving table** → viết theo mẫu `LEFT JOIN (subquery
     aggregate) <TABLE_ALIAS> ON <TABLE_ALIAS>.<col> =
     <DRIVING_TABLE>.<col>` (test case 1).
   - **Chính driving table** → viết gọn `AGG(<DRIVING_TABLE>.<col>) GROUP
     BY <DRIVING_TABLE>.<group_col>`, không JOIN (test case 2).

**Test case 1 — aggregate KHÁC driving table (cần LEFT JOIN + subquery):**

```
input (etl_logic sai):
MAX(EXITDATE) trên NG_SB_CLOS_ENTRY_EXIT WHERE WI_NAME=<current> AND
USERNAME IS NOT NULL AND WORKSTEP IN ('CreditApproval','CreditCommittee')
AND DECISION IN ('Submit','Send To HOSupport','Send To PostSanction')

output đúng (etl_logic sau chuẩn hoá) — driving table của dòng này là
NG_SB_CLOS_EXTTABLE, KHÁC bảng aggregate NG_SB_CLOS_ENTRY_EXIT:
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

**Test case 2 — aggregate NGAY TRÊN chính driving table (viết gọn, KHÔNG
JOIN):**

```
input (etl_logic dài dòng không cần thiết — review 2026-09-22,
DIM_CLOS_APPLICATION.FIRST_APPROVED_WI_NAME, driving table =
NG_SB_CLOS_EXTTABLE):
LEFT JOIN (
    SELECT NG_SB_CLOS_EXTTABLE.LOANCASEID, MIN(NG_SB_CLOS_EXTTABLE.WI_NAME) AS FIRST_APPROVED_WI_NAME
    FROM NG_SB_CLOS_EXTTABLE
    GROUP BY NG_SB_CLOS_EXTTABLE.LOANCASEID
) FIRST_APPROVED_GRP ON FIRST_APPROVED_GRP.LOANCASEID = NG_SB_CLOS_EXTTABLE.LOANCASEID
→ FIRST_APPROVED_GRP.FIRST_APPROVED_WI_NAME

output đúng (gọn hơn — bảng aggregate CHÍNH LÀ driving table của dòng
CSV này, không có gì để JOIN vào):
MIN(NG_SB_CLOS_EXTTABLE.WI_NAME) GROUP BY NG_SB_CLOS_EXTTABLE.LOANCASEID
```

Người dùng chỉ ra: khi nguồn của phép tính GROUP BY/aggregate là chính
driving table, việc bọc thêm `LEFT JOIN (subquery) alias ON alias.col =
DRIVING.col` là thừa — chỉ cần thiết khi phải kéo dữ liệu từ MỘT BẢNG
KHÁC vào (test case 1).

> Áp dụng lại quy ước này cho MỌI dòng `<current>` hoặc dòng aggregate dài
> dòng không cần thiết còn sót trong các file `lld/` đã sinh trước
> 2026-09-22 khi có dịp sửa/rà soát lại bảng đó — chưa cần chủ động quét
> sửa hàng loạt nếu người dùng không yêu cầu.

## RV — `etl_logic_type = "join"` nhưng `etl_logic` không viết mệnh đề JOIN

**Lỗi đã phát hiện (review 2026-09-22, `DIM_CLOS_APPLICATION.STREAM`/
`APPROVAL_TYPE`):** `etl_logic_type` khai đúng là `join`, nhưng cột
`etl_logic` chỉ ghi `NG_SB_CLOS_APPROVAL.STREAM` (dạng `table.column` của
`direct`) — không thể hiện JOIN vào bảng nào theo khóa gì. Thông tin
"LEFT JOIN theo WI_NAME" lại bị giấu trong `note` thay vì nằm trong chính
`etl_logic` — vi phạm nguyên tắc `etl_logic` phải tự đủ để dựng lại câu
SQL, không phụ thuộc đọc thêm `note`.

**Quy ước:** mọi dòng `etl_logic_type = "join"` PHẢI viết mệnh đề JOIN đầy
đủ trong `etl_logic`, theo mẫu:

```
LEFT JOIN <SRC_TABLE> ON <SRC_TABLE>.<join_col> = <DRIVING_TABLE>.<join_col>
→ <SRC_TABLE>.<lookup_col>
```

Chỉ dùng dạng phẳng này khi bảng nguồn đã xác nhận grain 1:1 theo đúng
khóa join (không cần khử trùng lặp) — VD `NG_SB_CLOS_APPROVAL` = 1 dòng/hồ
sơ theo metadata. Nếu bảng nguồn KHÔNG đảm bảo 1:1 (như
`NG_SB_CLOS_CUST_INFO`, grain thật `WI_NAME+EMP_CODE`), phải dùng dạng
subquery khử trùng lặp (xem mục "RV — `etl_logic` dùng ký hiệu `<current>`"
ở trên) chứ không được viết JOIN phẳng — JOIN phẳng vào bảng nhiều dòng/
khóa sẽ làm fan-out (nhân bản dòng) ở tầng SB_DWH.

**Cách kiểm tra khi self-review:** với mỗi dòng có `etl_logic_type =
"join"`, kiểm tra `etl_logic` phải chứa từ khóa `JOIN` (không được chỉ là
`table.column` trần). Nếu thiếu → tra lại grain của bảng nguồn (đọc
metadata hoặc HLD) rồi viết lại theo mẫu JOIN phẳng hoặc JOIN + subquery
tuỳ grain.

**Test case đối chiếu:**

```
input (etl_logic sai — chỉ ghi table.column, JOIN key giấu trong note):
etl_logic       = "NG_SB_CLOS_APPROVAL.STREAM"
etl_logic_type  = "join"
note            = "LEFT JOIN theo WI_NAME. Grain NG_SB_CLOS_APPROVAL = 1 dòng/hồ sơ"

output đúng (etl_logic thể hiện đủ mệnh đề JOIN):
etl_logic = "LEFT JOIN NG_SB_CLOS_APPROVAL ON NG_SB_CLOS_APPROVAL.WI_NAME =
NG_SB_CLOS_EXTTABLE.WI_NAME → NG_SB_CLOS_APPROVAL.STREAM"
note      = "Grain NG_SB_CLOS_APPROVAL = 1 dòng/hồ sơ nên không cần
subquery khử trùng lặp như NG_SB_CLOS_CUST_INFO"
```

> Áp dụng lại quy ước này cho MỌI dòng `etl_logic_type = "join"` còn thiếu
> mệnh đề JOIN trong các file `lld/` đã sinh trước 2026-09-22 khi có dịp
> sửa/rà soát lại bảng đó — chưa cần chủ động quét sửa hàng loạt nếu người
> dùng không yêu cầu.

## RV — Biến tham số ngày ETL phải là `v_batch_date`, không dùng `:ETL_DATE`/`:P_DATE`

**Quy ước đã thống nhất với người dùng (review 2026-09-22,
`DIM_CLOS_APPLICATION`):** mọi công thức `etl_logic` cần tham chiếu "ngày
chạy batch ETL hiện tại" phải dùng tên biến `v_batch_date` — KHÔNG dùng
`:ETL_DATE` hay `:P_DATE` (2 ký hiệu này từng dùng lẫn lộn trong các bảng
sinh trước 2026-09-22, coi như đã lỗi thời).

Áp dụng cho cả 2 tình huống thường gặp:
- **Gán trực tiếp** (VD cột `EFF_DATE` của SCD2 khi phát hiện thay đổi):
  `... gán = v_batch_date` (thay vì `gán = ngày phát hiện thay đổi
  (:P_DATE)`).
- **Lọc cắt lát theo ngày** (STG_DTM tier — cả dạng Dimension 3-ngày lookback
  và dạng Fact 1-ngày): `WHERE <col> = v_batch_date` hoặc
  `WHERE <col> IS NULL OR <col> >= v_batch_date - 3` (thay vì
  `= :ETL_DATE` / `>= :ETL_DATE - 3`).

**Cách kiểm tra khi self-review:** grep `:ETL_DATE` và `:P_DATE` trong cột
`etl_logic` của file đang làm — nếu còn xuất hiện, đổi thành `v_batch_date`
(giữ nguyên phần biểu thức còn lại, chỉ đổi tên biến).

**Test case đối chiếu:**

```
input (etl_logic sai — SB_DWH, gán trực tiếp):
CDC/thay đổi thuộc tính hồ sơ — gán = ngày phát hiện thay đổi (:P_DATE)

output đúng:
CDC/thay đổi thuộc tính hồ sơ — gán = v_batch_date

---

input (etl_logic sai — STG_DTM, lọc cắt lát Dimension):
DIM_CLOS_APPLICATION.DIMENSION_KEY WHERE DIM_CLOS_APPLICATION.EXP_DATE
IS NULL OR DIM_CLOS_APPLICATION.EXP_DATE >= :ETL_DATE - 3

output đúng:
DIM_CLOS_APPLICATION.DIMENSION_KEY WHERE DIM_CLOS_APPLICATION.EXP_DATE
IS NULL OR DIM_CLOS_APPLICATION.EXP_DATE >= v_batch_date - 3
```

> Áp dụng lại quy ước này cho MỌI bảng làm MỚI kể từ 2026-09-22 trở đi —
> LUÔN dùng `v_batch_date` ngay từ đầu, không viết `:ETL_DATE`/`:P_DATE`
> rồi sửa lại sau. Với các file `lld/` đã sinh trước 2026-09-22 (còn dùng
> `:ETL_DATE`/`:P_DATE`), chỉ sửa khi có dịp rà soát lại bảng đó — chưa
> chủ động quét sửa hàng loạt toàn bộ 45 bảng nếu người dùng không yêu cầu.

## RV — Không được đặt mệnh đề `JOIN` bên trong nhánh `CASE WHEN`/`ELSE`

**Lỗi đã phát hiện (review 2026-09-22, `DIM_CLOS_APPLICATION.SLA_CREDIT_OFFICER`/
`SLA_MARKER`/`SLA_CHECKER`/`SLA_CREDIT_APPROVER`, PDTD_DTM):** lần sửa đầu
tiên viết `CASE WHEN APP_GRP = 'C1' THEN 4 ELSE (cùng LEFT JOIN ... như cột
REF_PRODUCT) → <REF_TABLE>.SLA_CREDIT_OFFICER END` — đặt cả mệnh đề `LEFT
JOIN` vào bên trong nhánh `ELSE` của `CASE`. Đây là câu SQL không hợp lệ:
`JOIN` là mệnh đề ở tầng `FROM`, luôn thực hiện trước và áp dụng cho toàn bộ
dòng dữ liệu — không thể "chỉ chạy khi rơi vào nhánh ELSE" của 1 biểu thức
`CASE` nằm ở tầng `SELECT`.

**Quy ước:** khi 1 cột cần vừa JOIN sang bảng khác vừa có ngoại lệ hằng số
cho 1 số dòng (theo điều kiện trên chính driving table, không phụ thuộc kết
quả JOIN), viết theo đúng thứ tự SQL thật:
1. Mệnh đề `JOIN`/`LEFT JOIN` (kể cả multi-hop, CASE chọn bảng nguồn nào)
   viết TRƯỚC, độc lập với `CASE` chọn giá trị output.
2. `CASE WHEN <điều kiện ngoại lệ> THEN <hằng số> ELSE
   <TABLE_ĐÃ_JOIN>.<cột> END` đặt SAU dấu `→`, chỉ dùng để chọn giá trị
   cuối cùng giữa hằng số và cột đã lấy được từ JOIN — không nhét `JOIN`
   vào bên trong nó.

```
❌ CASE WHEN <DRIVING>.APP_GRP = 'C1' THEN 4
   ELSE (LEFT JOIN OTHER_TABLE ON ...) → OTHER_TABLE.COL END   (JOIN lồng trong CASE — sai)

✅ LEFT JOIN OTHER_TABLE ON OTHER_TABLE.key = <DRIVING>.key AND ...
   → CASE WHEN <DRIVING>.APP_GRP = 'C1' THEN 4 ELSE OTHER_TABLE.COL END
   (JOIN luôn chạy trước; hồ sơ APP_GRP='C1' không khớp điều kiện JOIN nên
   OTHER_TABLE.COL tự nhiên là NULL, CASE ở SELECT override NULL đó bằng
   hằng số — không cần "tắt" JOIN theo điều kiện)
```

**Cách kiểm tra khi self-review:** với mỗi dòng `etl_logic` có cả `CASE` và
`JOIN`, xác nhận `JOIN` không nằm trong bất kỳ nhánh `WHEN`/`THEN`/`ELSE`
nào — `JOIN` luôn đứng trước dấu `→` đầu tiên, `CASE` chọn giá trị đứng sau
(hoặc là chính `JOIN ... → CASE ... END` nếu chỉ cần chọn output, không cần
chọn bảng động).

> Áp dụng lại quy ước này khi rà soát các file `lld/` khác có công thức kết
> hợp CASE + JOIN tương tự (VD cột SLA_* dùng hằng số ngoại lệ cho 1 nhóm
> hồ sơ) — chưa cần chủ động quét toàn bộ nếu người dùng không yêu cầu.

## RV — Không được dùng `CASE WHEN ... THEN LEFT JOIN <table_A> ... THEN LEFT JOIN <table_B> END` để "chọn bảng nguồn động"

**Lỗi đã phát hiện (review 2026-09-22, `DIM_CLOS_APPLICATION.REF_PRODUCT`/
`SLA_CREDIT_OFFICER`/`SLA_MARKER`/`SLA_CHECKER`/`SLA_CREDIT_APPROVER`,
PDTD_DTM):** lần sửa thứ nhất (khắc phục lỗi "JOIN lồng trong nhánh ELSE")
vẫn còn giữ nguyên phần đầu công thức dạng `CASE WHEN CUST_GROUP IN (...)
THEN LEFT JOIN CLOS_REF_SLA_TDKHDNL WHEN CUST_GROUP IN (...) THEN LEFT JOIN
CLOS_REF_SLA_TDKHDN END <REF_TABLE> ON ...` — đây vẫn là cú pháp SQL không
hợp lệ: `CASE` là 1 biểu thức trả về **giá trị vô hướng** (số/chuỗi/ngày),
không thể trả về "1 bảng" để JOIN động theo — SQL không có khái niệm chọn
bảng nguồn bằng biểu thức điều kiện tại thời điểm JOIN.

**Quy ước:** khi cần chọn 1 trong N bảng nguồn khác nhau tùy điều kiện trên
driving table (VD chọn `CLOS_REF_SLA_TDKHDNL` hay `CLOS_REF_SLA_TDKHDN`
theo `CUST_GROUP`), viết **N mệnh đề `LEFT JOIN` độc lập, mỗi bảng tự mang
đúng điều kiện phân nhóm của mình trong `ON`** — không dùng `CASE` để chọn
tên bảng. Vì điều kiện phân nhóm loại trừ lẫn nhau (1 dòng chỉ khớp đúng 1
bảng), tại runtime chỉ tối đa 1 JOIN trả kết quả không NULL; dùng
`COALESCE(<table_A>.col, <table_B>.col, ...)` ở cuối công thức (sau dấu
`→`) để lấy đúng giá trị từ bảng đã khớp.

```
❌ CASE WHEN <DRIVING>.CUST_GROUP IN ('NBFI',...) THEN LEFT JOIN TABLE_A
   WHEN <DRIVING>.CUST_GROUP IN ('MSME',...) THEN LEFT JOIN TABLE_B END
   <REF_TABLE> ON <REF_TABLE>.col = ...                    (CASE trả về tên bảng — sai)

✅ LEFT JOIN TABLE_A ON TABLE_A.col = <DRIVING>.col AND <DRIVING>.CUST_GROUP IN ('NBFI',...)
   → LEFT JOIN TABLE_B ON TABLE_B.col = <DRIVING>.col AND <DRIVING>.CUST_GROUP IN ('MSME',...)
   → COALESCE(TABLE_A.target_col, TABLE_B.target_col)
   (2 JOIN độc lập, loại trừ lẫn nhau qua chính điều kiện CUST_GROUP trong ON;
   COALESCE chọn giá trị từ bảng đã khớp)
```

Khi 1 trong N nhóm điều kiện (VD `APP_GRP='C1'`) KHÔNG thuộc điều kiện phân
nhóm của bất kỳ JOIN nào (nên mọi JOIN đều NULL cho nhóm đó) và cần override
bằng hằng số, đặt `CASE WHEN <điều kiện đó> THEN <hằng số> ELSE COALESCE(...)
END` bọc NGOÀI CÙNG, sau `COALESCE` — không trộn vào bên trong từng JOIN.

**Cách kiểm tra khi self-review:** grep `CASE` trong `etl_logic` của mỗi
dòng `etl_logic_type=join` — nếu ngay sau `THEN`/`WHEN` là từ khóa `JOIN`
(không phải 1 giá trị/cột), đây là lỗi "CASE chọn bảng động", phải viết lại
theo mẫu N-JOIN-độc-lập-`COALESCE` ở trên.

> Áp dụng lại quy ước này cho MỌI dòng khác trong `lld/` có nhu cầu "chọn 1
> trong N bảng nguồn tùy điều kiện" — chưa cần chủ động quét toàn bộ nếu
> người dùng không yêu cầu.

## RV — Cột trong `etl_logic` (kể cả `computed` trên chính driving table) thiếu tiền tố `table.`

**Lỗi đã phát hiện (review 2026-09-22, `SB_DWH_DIM_CLOS_EXCEPTION_REASON.
EXCEPTION_CODE`):** `etl_logic = "REGEXP_SUBSTR(EXCEPTION_CATEGORY, '^[^:]+')
..."` — tham chiếu cột `EXCEPTION_CATEGORY` trần, không có tiền tố
`NG_SB_CLOS_MAS_EXCEPTION.` dù `attributes_format.md` đã quy định rõ "mọi
tham chiếu cột trong `etl_logic` phải có tiền tố `<table>.`" (chỉ trừ
literal, hàm SQL không tham số cột, `NULL`, `v_batch_date`). Lỗi này dễ lọt
qua vì trông "gọn gàng hợp lý" — dễ nhầm với cách viết tắt được chấp nhận
cho cột đơn giản trên `direct`, nhưng `attributes_format.md` không có
ngoại lệ nào cho `computed`/hàm SQL có tham số là tên cột.

**Quy ước:** kể cả khi driving table là nguồn DUY NHẤT của công thức
(`computed` thuần trên chính driving table, không JOIN gì thêm), mọi tham
số cột truyền vào hàm SQL (`REGEXP_SUBSTR(...)`, `TRUNC(...)`, `CASE WHEN
... THEN ...`) đều phải viết đủ `<DRIVING_TABLE>.<col>` — không rút gọn
thành `<col>` trần dù không có ambiguity giữa nhiều bảng.

**Cách kiểm tra khi self-review:** với mỗi dòng có `etl_logic_type =
computed`, liệt kê mọi token xuất hiện trong `etl_logic` khớp tên 1 cột đã
khai ở `source_column`/HLD của bảng đó — nếu token đó xuất hiện mà KHÔNG có
tiền tố `<table>.` ngay trước nó (trừ khi nằm trong literal string
`'...'`), phải sửa thành `<source_table>.<col>`.

**Test case đối chiếu:**
```
input (etl_logic sai — thiếu prefix):
REGEXP_SUBSTR(EXCEPTION_CATEGORY, '^[^:]+') khi chuỗi có dấu hai chấm, NULL khi không có

output đúng:
REGEXP_SUBSTR(NG_SB_CLOS_MAS_EXCEPTION.EXCEPTION_CATEGORY, '^[^:]+') khi chuỗi có dấu hai chấm, NULL khi không có
```

> Áp dụng lại quy ước này cho MỌI dòng `computed`/`join` khác trong `lld/`
> đã sinh trước 2026-09-22 khi có dịp rà soát lại bảng đó — chưa chủ động
> quét sửa hàng loạt nếu người dùng không yêu cầu.

## RV — Điều kiện rẽ nhánh viết bằng văn xuôi ("khi X, Y khi không") thay vì `CASE WHEN...END` thực thi được

**Lỗi đã phát hiện (review 2026-09-22, `SB_DWH_DIM_CLOS_EXCEPTION_REASON.
EXCEPTION_CODE`):** `etl_logic = "REGEXP_SUBSTR(EXCEPTION_CATEGORY,
'^[^:]+') khi chuỗi có dấu hai chấm, NULL khi không có"` — hàm
`REGEXP_SUBSTR` viết đúng cú pháp, nhưng điều kiện rẽ nhánh ("khi chuỗi có
dấu hai chấm... khi không có...") lại viết bằng lời văn nối vào sau, không
phải mệnh đề SQL. Đây là biến thể khác của nhóm lỗi "trộn văn xuôi vào
etl_logic": không phải chọn bảng (đã có 2 mục RV riêng ở trên), mà là chọn
GIÁ TRỊ output tuỳ điều kiện — vẫn phải là `CASE WHEN <đk> THEN <biểu thức>
ELSE <biểu thức khác> END`, không phải hàm SQL + câu mô tả điều kiện đặt
sau nó.

Ngoài lỗi cú pháp, bản thân điều kiện còn SAI NGỮ NGHĨA nếu implement ngây
thơ: pattern `'^[^:]+'` của `REGEXP_SUBSTR` khi chuỗi KHÔNG có dấu `:` vẫn
khớp và trả về TOÀN BỘ chuỗi gốc (không tự nhiên trả NULL) — nên "NULL khi
không có dấu hai chấm" phải ép bằng `CASE`/`INSTR` tường minh, không thể
trông chờ hàm tự xử lý.

**Quy ước:** mọi điều kiện rẽ nhánh trong `etl_logic` (dù đơn giản 2 nhánh
hay phức tạp) phải viết `CASE WHEN <table>.<col> <operator> <value> THEN
<biểu thức 1> ELSE <biểu thức 2> END` — không diễn giải bằng lời ("khi X",
"nếu Y thì", "trường hợp còn lại") rồi để nguyên trong `etl_logic`. Diễn
giải bằng lời (nếu cần) đặt trong `description`/`note`, không thay thế cho
cú pháp SQL.

**Test case đối chiếu:**
```
input (etl_logic sai — hàm SQL đúng nhưng điều kiện viết bằng lời):
REGEXP_SUBSTR(NG_SB_CLOS_MAS_EXCEPTION.EXCEPTION_CATEGORY, '^[^:]+') khi chuỗi có dấu hai chấm, NULL khi không có

output đúng (CASE WHEN tường minh, dùng INSTR để test tồn tại dấu ':'):
CASE WHEN INSTR(NG_SB_CLOS_MAS_EXCEPTION.EXCEPTION_CATEGORY, ':') > 0
     THEN REGEXP_SUBSTR(NG_SB_CLOS_MAS_EXCEPTION.EXCEPTION_CATEGORY, '^[^:]+')
     ELSE NULL END
```

**Cách kiểm tra khi self-review:** grep các cụm tiếng Việt chỉ điều kiện
("khi ", "nếu ", "trường hợp ", "còn lại") xuất hiện NGOÀI dấu ngoặc kép
literal trong cột `etl_logic` — nếu thấy, viết lại thành `CASE WHEN...END`
tường minh, đồng thời kiểm tra lại ngữ nghĩa hàm SQL có tự nhiên tạo ra kết
quả đúng ở nhánh ELSE không (như case `REGEXP_SUBSTR` ở trên) hay cần ép
bằng hàm phụ trợ (`INSTR`, `NULLIF`...).

> Áp dụng lại quy ước này cho MỌI dòng `computed` khác trong `lld/` có điều
> kiện rẽ nhánh diễn giải bằng lời — chưa chủ động quét toàn bộ nếu người
> dùng không yêu cầu.

## RV — Quy tắc tổng quát: `etl_logic` phải là SQL syntax chuẩn thực thi được, TRỪ dòng `generated`

**Bối cảnh:** 4 mục RV phía trên (`<current>`, join thiếu mệnh đề JOIN,
JOIN lồng trong CASE, CASE chọn bảng động, thiếu prefix `table.`, điều kiện
rẽ nhánh viết bằng lời) đều là biến thể của CÙNG 1 lỗi gốc: `etl_logic`
không phải câu SQL thực thi được mà là mô tả/pseudo-code lẫn với SQL. Mục
này chốt lại thành 1 quy tắc bao trùm để tự kiểm tra nhanh, không cần nhớ
riêng từng biến thể.

**Quy tắc bắt buộc:** MỌI dòng CSV có `etl_logic_type` thuộc
`direct`/`computed`/`join`/`scd2` — cột `etl_logic` phải là biểu thức SQL
chuẩn, đọc vào là dựng lại được câu SQL thật ngay (JOIN, CASE, hàm, toán
tử, literal), không lẫn bất kỳ câu mô tả bằng lời nào thay thế cho cú pháp
(không `<current>`, không "khi X thì Y khi không thì Z", không CASE trả về
tên bảng, không JOIN nhét trong nhánh CASE, không cột thiếu prefix
`table.`). Diễn giải bằng lời (lý do, ngữ cảnh nghiệp vụ, cảnh báo
PENDING...) chỉ được đặt ở `description`/`note`, không bao giờ trộn vào
`etl_logic`.

**NGOẠI LỆ DUY NHẤT — dòng `etl_logic_type = generated`:** theo
`attributes_format.md` (bảng 6 giá trị `etl_logic_type`), cột `generated`
(mọi `DIMENSION_KEY` sinh bằng sequence, mọi cột `_SK` bằng đúng
`DIMENSION_KEY` cùng dòng, khóa hash `_BK` khi nguồn không khai CDC key)
quy ước **để trống `etl_logic`**, cách sinh ghi trong `description`/`note`
— đây KHÔNG phải vi phạm quy tắc "phải là SQL", vì bản chất `generated`
không map từ 1 nguồn cụ thể để viết thành biểu thức SQL (sequence/tham
chiếu nội bộ cùng dòng, không phải phép biến đổi dữ liệu từ cột nguồn).
Không áp dụng cách viết `= DIMENSION_KEY (cùng dòng)` bằng lời cho các
`etl_logic_type` khác — chỉ `generated` được miễn.

**`etl_logic_type = scd2` KHÔNG được miễn — vẫn phải là SQL chuẩn:**
- `EXP_DATE`: `etl_logic` luôn là literal `NULL` (không phải mô tả "để
  trống khi bản ghi hiện hành") — đã quy định ở `attributes_format.md`.
- `EFF_DATE`: phải là biểu thức gán được (`v_batch_date`,
  `<SOURCE_TABLE>.EFF_DATE`...), không viết văn xuôi kiểu "gán = ngày phát
  hiện thay đổi" trộn lẫn placeholder — xem mục "RV — Biến tham số ngày
  ETL" ở trên (test case `:P_DATE` → `v_batch_date` cũng áp dụng nguyên
  vẹn cho `scd2`, không phải ngoại lệ).

**Cách kiểm tra khi self-review (chạy 1 lượt cho toàn bộ file trước khi
trình bày):**
1. Lọc mọi dòng có `etl_logic_type != generated`.
2. Với mỗi dòng đó, đọc `etl_logic` như thể sắp copy-paste thành câu SQL
   thật — nếu gặp bất kỳ cụm tiếng Việt mô tả điều kiện/lý do, ký hiệu giữ
   chỗ (`<current>`, `<...>` không phải alias thật), hoặc cấu trúc SQL
   không hợp lệ (CASE trả về bảng, JOIN trong CASE, cột thiếu prefix) →
   FAIL, viết lại theo đúng mẫu ở mục RV tương ứng phía trên.
3. Dòng `generated` bỏ qua bước 2 (etl_logic để trống là đúng quy ước),
   nhưng vẫn kiểm tra `description`/`note` có giải thích rõ cách sinh
   không (không được để trống hoàn toàn không giải thích gì).

> Đây là mục "tổng kết" — khi phát hiện thêm 1 biến thể MỚI của lỗi
> "etl_logic không phải SQL thuần", vẫn thêm mục RV riêng chi tiết (kèm
> test case cụ thể) như các mục phía trên, đồng thời có thể dẫn chiếu về
> mục tổng quát này thay vì lặp lại toàn bộ giải thích.

## RV — Dùng `JOIN` trần thay vì `LEFT JOIN` khi HLD/mermaid ghi rõ quan hệ là LEFT JOIN

**Lỗi đã phát hiện (review 2026-09-22, `SB_DWH_DIM_LOS_ORG_UNIT.BRANCH_CODE`/
`BRANCH_NAME`/`CITY`/`DISTRICT`/`REGION_CODE`/`REGION_NAME`):** cả 6 dòng
`etl_logic_type=join` viết `JOIN NG_SB_RLOS_MAS_BRANCH ON ...` (JOIN trần,
tương đương INNER JOIN) trong khi mermaid Section 1 của chính bảng này ghi
rõ nhãn `"LEFT JOIN theo BRANCH_ID — bổ sung tên/địa bàn Chi nhánh"` và
`"LEFT JOIN theo REGION_CODE..."`. Đây không phải khác biệt văn phong —
`JOIN` (INNER) sẽ LÀM RỚT MẤT dòng driving (`NG_SB_RLOS_MAS_COMPANY`) nếu
`BRANCH_ID` không khớp được dòng nào trên `MAS_BRANCH`, trong khi ý đồ
thiết kế thật (theo HLD) là "vẫn giữ dòng Company, chỉ để NULL các cột bổ
sung từ Branch/Region nếu không khớp" — đúng ngữ nghĩa `LEFT JOIN`.

**Quy ước:** mọi `etl_logic_type=join` lookup bổ sung thuộc tính từ 1 bảng
khác (không phải bảng bắt buộc phải tồn tại quan hệ) mặc định dùng `LEFT
JOIN`, không viết `JOIN` trần — trừ khi HLD xác nhận rõ ràng đây là quan hệ
bắt buộc tồn tại (inner join đúng nghĩa, hiếm gặp ở tầng Dimension lookup).
Khi mermaid Section 1 đã có nhãn `LEFT JOIN theo ...` trên mũi tên, `etl_logic`
PHẢI dùng đúng từ khóa `LEFT JOIN`, không rút gọn thành `JOIN`.

**Cách kiểm tra khi self-review:** grep `"JOIN "` (có khoảng trắng, không
phải `LEFT JOIN`) trong cột `etl_logic` của mọi dòng `etl_logic_type=join`
— nếu bắt được `JOIN` không có tiền tố `LEFT`/`INNER` ngay trước, đối chiếu
lại nhãn mermaid Section 1 của bảng đó: nếu mermaid ghi "LEFT JOIN" (hầu
hết trường hợp lookup bổ sung thuộc tính) → sửa thành `LEFT JOIN`.

**Test case đối chiếu:**
```
input (etl_logic sai — JOIN trần, rớt dòng driving nếu BRANCH_ID không khớp):
JOIN NG_SB_RLOS_MAS_BRANCH ON NG_SB_RLOS_MAS_BRANCH.BRANCH_ID = NG_SB_RLOS_MAS_COMPANY.BRANCH_ID
→ NG_SB_RLOS_MAS_BRANCH.BRANCH_ID

output đúng (khớp nhãn mermaid "LEFT JOIN theo BRANCH_ID"):
LEFT JOIN NG_SB_RLOS_MAS_BRANCH ON NG_SB_RLOS_MAS_BRANCH.BRANCH_ID = NG_SB_RLOS_MAS_COMPANY.BRANCH_ID
→ NG_SB_RLOS_MAS_BRANCH.BRANCH_ID
```

> Áp dụng lại quy ước này cho MỌI dòng `etl_logic_type=join` khác trong
> `lld/` đã sinh trước 2026-09-22 dùng `JOIN` trần khi có dịp rà soát lại
> bảng đó — chưa chủ động quét sửa hàng loạt nếu người dùng không yêu cầu.

## RV — `DISTINCT <table>.<col>` viết như hàm/toán tử trước cột, không phải mệnh đề SELECT

**Lỗi đã phát hiện (review 2026-09-22, `SB_DWH_DIM_RLOS_DECISION.
DECISION_CODE`):** `etl_logic = "DISTINCT NG_SB_RLOS_MAS_DECISION.DECISION"`
— viết `DISTINCT` như thể là 1 hàm/toán tử áp trước tên cột (giống cú pháp
`MAX(col)`/`TRUNC(col)`), nhưng `DISTINCT` trong SQL thật là 1 từ khóa
thuộc mệnh đề `SELECT` (`SELECT DISTINCT <col> FROM <table>`), áp dụng cho
toàn bộ danh sách cột được chọn — không đứng trước 1 cột đơn lẻ như hàm.

**Quy ước:** khi công thức cần lấy danh sách giá trị duy nhất từ 1 bảng
danh mục gộp nhiều dòng/1 giá trị (VD `MAS_DECISION` gộp `WORKSTEP+DECISION`
dạng N-N, DIM chỉ cần `DISTINCT DECISION`), viết đủ dạng
`SELECT DISTINCT <table>.<col>` — không viết `DISTINCT <table>.<col>` trần
(thiếu từ khóa `SELECT` phía trước).

**Test case đối chiếu:**
```
input (etl_logic sai — DISTINCT viết như hàm trước cột):
DISTINCT NG_SB_RLOS_MAS_DECISION.DECISION

output đúng:
SELECT DISTINCT NG_SB_RLOS_MAS_DECISION.DECISION
```

**Cách kiểm tra khi self-review:** grep `DISTINCT` trong `etl_logic` của
mọi dòng `etl_logic_type=direct`/`computed` — nếu ngay trước `DISTINCT`
không có từ khóa `SELECT`, thêm `SELECT ` vào đầu.

> Áp dụng lại quy ước này cho MỌI dòng khác trong `lld/` dùng `DISTINCT`
> viết thiếu `SELECT` phía trước khi có dịp rà soát lại bảng đó — chưa chủ
> động quét sửa hàng loạt nếu người dùng không yêu cầu.

## RV — Cột B chỉ kiểm tra "cột A IS NOT NULL" thay vì viết lại đúng điều kiện gốc của A, khi A đã là công thức phức tạp

**Lỗi đã phát hiện (review 2026-09-22, `FCT_CLOS_APPLICATION_DAILY.
FLAG_AUTO_CANCEL`):** cột `FLAG_AUTO_CANCEL` viết `CASE WHEN
FCT_CLOS_APPLICATION_DAILY.AUTO_CANCEL_DATE IS NOT NULL THEN 'YES' ELSE
NULL END` — tham chiếu tới cột `AUTO_CANCEL_DATE` cùng dòng đích, vốn dĩ tự
nó là 1 pattern hợp lệ (nhiều cột khác trong cùng bảng cũng làm vậy, VD
`INACTIVE_DAY_CNT` tham chiếu `LAST_ACTION_DATE`). Nhưng sau khi
`AUTO_CANCEL_DATE` được viết lại thành công thức phức tạp (`CASE` bọc
1 subquery lấy `LAST_DECISION`), `FLAG_AUTO_CANCEL` giờ chỉ kiểm tra "kết
quả đó có NULL hay không" thay vì đọc lại đúng **điều kiện gốc** của SRS
(`BI_CAN_DATE IS NOT NULL AND LAST_DECISION='Auto-Cancel'`) — về mặt toán
học kết quả tương đương, nhưng che giấu nguồn sự thật (người đọc phải lần
ngược qua công thức của A mới hiểu B thật sự kiểm tra gì) và tạo phụ thuộc
vòng vo không cần thiết giữa 2 dòng CSV vốn độc lập trong tài liệu nguồn
(SRS định nghĩa `FLAG_AUTO_CAN` bằng điều kiện riêng, không nói "khác NULL
của cột khác"). Ngoài ra bản cũ còn sai giá trị nhánh ELSE (NULL thay vì
'NO' theo đúng SRS).

**Quy ước:** khi HLD/SRS mô tả 2 cột bằng 2 điều kiện riêng biệt (dù có vẻ
liên quan/kéo theo nhau), viết `etl_logic` của MỖI cột độc lập theo đúng
điều kiện gốc trong tài liệu nguồn — không suy luận tắt "cột B = cột A IS
NOT NULL" trừ khi chính tài liệu nguồn định nghĩa B đúng bằng cách đó (VD
`attributes_format.md` mẫu `EXP_DATE`/`FLAG` chỉ nên tham chiếu cột khác
cùng dòng khi công thức của A đơn giản và bản thân nguồn xác nhận B phái
sinh trực tiếp từ A, không phải khi A là 1 subquery/CASE phức tạp).

**Cách kiểm tra khi self-review:** với mỗi dòng có `etl_logic` tham chiếu
tới `<TARGET_TABLE>.<cột khác cùng dòng đích>`, kiểm tra 2 điều:
1. Cột được tham chiếu (A) có công thức đơn giản (literal, 1 hàm, 1 JOIN
   phẳng) hay phức tạp (subquery/CASE nhiều nhánh)? Nếu A phức tạp, ưu
   tiên viết lại B độc lập theo đúng điều kiện gốc của tài liệu nguồn thay
   vì chỉ test "A IS NOT NULL"/"A = X".
2. Tài liệu nguồn (SRS/HLD) có định nghĩa B bằng chính điều kiện của A hay
   bằng 1 tổ hợp điều kiện riêng? Nếu riêng, bám sát tài liệu nguồn.

**Test case đối chiếu:**
```
input (etl_logic sai — B chỉ test A IS NOT NULL, A đã là CASE+subquery phức tạp):
FLAG_AUTO_CANCEL = CASE WHEN FCT_CLOS_APPLICATION_DAILY.AUTO_CANCEL_DATE IS NOT NULL THEN 'YES' ELSE NULL END

output đúng (viết lại độc lập theo đúng điều kiện gốc SRS BC2 field FLAG_AUTO_CAN):
FLAG_AUTO_CANCEL = CASE WHEN FCT_CLOS_APPLICATION_DAILY.BI_CAN_DATE IS NOT NULL
     AND (SELECT NG_SB_CLOS_ENTRY_EXIT.DECISION FROM NG_SB_CLOS_ENTRY_EXIT
          WHERE NG_SB_CLOS_ENTRY_EXIT.WINAME = FCT_CLOS_APPLICATION_DAILY.WI_NAME
          ORDER BY NG_SB_CLOS_ENTRY_EXIT.ENTRYDATE DESC FETCH FIRST 1 ROW ONLY) = 'Auto-Cancel'
     THEN 'YES' ELSE 'NO' END
```

> Áp dụng lại quy ước này cho MỌI cặp cột "cột B = cột A IS NOT NULL" khác
> trong `lld/` khi rà soát lại và phát hiện A đã/sẽ được viết thành công
> thức phức tạp — chưa cần chủ động quét toàn bộ nếu người dùng không yêu
> cầu.

## RV — Quy ước `etl_logic_type` của cột `_SK` (= DIMENSION_KEY cùng dòng) KHÁC NHAU giữa tầng SB_DWH và tầng STG_DTM/PDTD_DTM — đừng áp nhầm chiều

**Tự sửa sai rồi tự phát hiện lại sai (review 2026-09-22,
`PDTD_DTM_DIM_RLOS_CARD_PROMOTION.CARD_PROMOTION_SK` và
`PDTD_DTM_DIM_RLOS_CHANGE_TYPE.CHANGE_TYPE_SK`):** lần đầu thấy 2 dòng này
khai `etl_logic_type=direct` với `etl_logic=STG_DIM_....<X>_SK`, tôi kết
luận đây là lỗi (so sánh nhầm với quy ước `generated` của TẦNG SB_DWH,
VD `SB_DWH_DIM_CLOS_EXCEPTION_REASON.EXCEPTION_REASON_SK`) và sửa cả 2
thành `generated`, đồng thời áp cùng "sửa" đó lên
`PDTD_DTM_DIM_RLOS_EXCEPTION_REASON.EXCEPTION_REASON_SK`. Một tiến trình
khác đang làm việc song song trên cùng file đã revert đúng sửa đổi ở
`EXCEPTION_REASON_SK` kèm giải thích: đối chiếu 11/11 file PDTD_DTM DIM
khác đều dùng `direct` — bản sửa của tôi mới là hồi quy sai. Xác minh lại
`SB_DWH_DIM_CLOS_EXCEPTION_REASON.EXCEPTION_REASON_SK` (tầng SB_DWH) so
với `PDTD_DTM_DIM_CLOS_EXCEPTION_REASON.EXCEPTION_REASON_SK`/
`PDTD_DTM_DIM_CLOS_DECISION.DECISION_SK` (tầng PDTD_DTM) xác nhận: **2
tầng có quy ước khác nhau cho cùng 1 loại cột `_SK`**, không phải 1 trong
2 là lỗi.

**Quy ước đúng — phân biệt theo tầng:**
- **Tầng SB_DWH** (nơi `_SK` lần đầu xuất hiện, không có nguồn nào khác
  ngoài chính `DIMENSION_KEY` cùng dòng vừa được sequence sinh ra):
  `etl_logic_type=generated`, `etl_logic` để trống hoặc `= DIMENSION_KEY
  (cùng dòng)`, `source_table`/`source_column` để trống.
- **Tầng STG_DTM và PDTD_DTM** (nơi `_SK` đã tồn tại sẵn như 1 cột thật
  trên bảng nguồn tầng trước — SB_DWH hoặc STG_DTM — và chỉ cần bê
  nguyên qua vùng chìa, giống hệt cách `DIMENSION_KEY` chính nó cũng bê
  nguyên `direct` chứ không "generated" lại):
  `etl_logic_type=direct`, `etl_logic=<SOURCE_TABLE>.<X>_SK`,
  `source_table`/`source_column` điền đủ như mọi cột `direct` khác.

Bản chất: `generated` mô tả **hành động sinh giá trị lần đầu** (chỉ xảy ra
đúng 1 lần, ở tầng đầu tiên nó xuất hiện); mọi tầng sau chỉ **bê nguyên**
giá trị đã sinh đó — đúng ngữ nghĩa `direct`, không phải sinh lại.

**Cách kiểm tra khi self-review:** trước khi kết luận 1 dòng `_SK` "sai
etl_logic_type", luôn xác định TẦNG của file đang xem (tên file bắt đầu
`SB_DWH_`/`STG_DTM_STG_`/`PDTD_DTM_`) rồi đối chiếu đúng quy ước của
tầng đó — không suy diễn "pattern đã thấy ở bảng khác" mà không kiểm tra
2 bảng đối chiếu có CÙNG TẦNG không. Khi nghi ngờ, grep cùng 1 cột `_SK`
xuyên suốt cả 3 tầng của ít nhất 1 bảng đã biết chắc đúng (VD
`DIM_CLOS_DECISION`/`DIM_CLOS_EXCEPTION_REASON`) làm mẫu đối chiếu.

**Test case đối chiếu:**
```
Tầng SB_DWH (generated — nơi DIMENSION_KEY vừa được sequence sinh):
etl_logic_type = "generated"
etl_logic      = "= DIMENSION_KEY (cùng dòng)"
source_table   = ""
source_column  = ""

Tầng PDTD_DTM (direct — bê nguyên _SK đã tồn tại sẵn từ STG_DTM):
etl_logic_type = "direct"
etl_logic      = "STG_DIM_RLOS_CARD_PROMOTION.CARD_PROMOTION_SK"
source_table   = "STG_DIM_RLOS_CARD_PROMOTION"
source_column  = "CARD_PROMOTION_SK"
```

> Áp dụng lại quy ước này khi rà soát cột `_SK` ở BẤT KỲ tầng nào — luôn
> xác định đúng tầng trước khi so sánh với "pattern đã thấy", không tự ý
> đồng nhất quy ước `generated` của SB_DWH sang STG_DTM/PDTD_DTM.

## RV — `etl_logic_type` khai `direct` nhưng `etl_logic` viết mệnh đề JOIN đầy đủ (mâu thuẫn nội bộ)

**Lỗi đã phát hiện (review 2026-09-22, `SB_DWH_FCT_RLOS_APPLICATION_PARTY.
COREPAYER_SK`):** dòng khai `etl_logic_type="direct"` nhưng `etl_logic`
lại viết `"JOIN DIM_RLOS_COREPAYER ON WI_NAME=<current>.WI_NAME AND
EFF_DATE<=DAYID<EXP_DATE ... → DIMENSION_KEY"` — có đủ mệnh đề `JOIN`
(đúng hình dạng của `etl_logic_type="join"`), mâu thuẫn với chính
`etl_logic_type` đã khai `direct`. Gốc rễ: `DIM_RLOS_COREPAYER` THẬT RA là
driving table của cả dòng CSV (xem PK dòng `DAYID` ghi rõ "Driving:
DIM_RLOS_COREPAYER") — không cần JOIN gì để lấy `DIMENSION_KEY` của chính
driving table, chỉ cần đọc thẳng cột kèm điều kiện lọc SCD2 hiện hành tại
DAYID (`WHERE DAYID BETWEEN EFF_DATE AND NVL(EXP_DATE, DAYID)`, không phải
`JOIN`). Việc trước đó viết `JOIN` phản ánh nhầm lẫn: khi tra cứu SK của
chính driving table, không có gì để "join" vào — cùng bản chất với mục "RV
— `<current>`" (test case 2, aggregate ngay trên driving table không cần
LEFT JOIN self-join), áp dụng tương tự cho lookup PK/SK trên chính driving
table.

**Quy ước:** trước khi viết `etl_logic` cho bất kỳ cột `_SK`/PK nào, xác
định lại: cột nguồn có nằm trên CHÍNH driving table của dòng CSV đó không?
- **Nằm trên chính driving table** → `etl_logic_type="direct"` (hoặc
  `scd2` nếu là EFF_DATE/EXP_DATE), viết dạng `<DRIVING_TABLE>.<col> WHERE
  <điều kiện SCD2 hiện hành>` — không có từ khóa `JOIN`.
- **Nằm trên bảng khác driving table** → `etl_logic_type="join"`, viết đủ
  `LEFT JOIN <table> ON ... → <table>.<col>`.

**Cách kiểm tra khi self-review:** với mỗi dòng `etl_logic_type=direct`,
grep từ khóa `JOIN` trong `etl_logic` — nếu có, đối chiếu lại xem bảng
nguồn của dòng đó có đúng là driving table không; nếu là driving table thì
xóa mệnh đề JOIN thừa (viết gọn lại theo mẫu direct + WHERE SCD2), nếu
không phải driving table thì sửa `etl_logic_type` thành `join`.

**Test case đối chiếu:**
```
input (etl_logic_type=direct nhưng etl_logic có JOIN — mâu thuẫn):
etl_logic_type = "direct"
etl_logic = "JOIN DIM_RLOS_COREPAYER ON WI_NAME=<current>.WI_NAME AND
EFF_DATE<=DAYID<EXP_DATE (hoặc EXP_DATE IS NULL) → DIMENSION_KEY"

output đúng (DIM_RLOS_COREPAYER là chính driving table — không JOIN):
etl_logic_type = "direct"
etl_logic = "DIM_RLOS_COREPAYER.DIMENSION_KEY WHERE FCT_RLOS_APPLICATION_PARTY.DAYID
BETWEEN DIM_RLOS_COREPAYER.EFF_DATE AND NVL(DIM_RLOS_COREPAYER.EXP_DATE, FCT_RLOS_APPLICATION_PARTY.DAYID)"
```

> Áp dụng lại quy ước này cho MỌI dòng `etl_logic_type=direct` khác trong
> `lld/` có `etl_logic` chứa từ khóa `JOIN` khi có dịp rà soát lại bảng đó
> — chưa cần chủ động quét sửa hàng loạt nếu người dùng không yêu cầu.
