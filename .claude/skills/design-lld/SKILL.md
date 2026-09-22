---
name: design-lld
description: |
  Thiết kế Low-Level Design (LLD) cho từng bảng trong pipeline
  STG_LOS → SB_DWH → STG_DTM → PDTD_DTM của dự án PDTD_DTM Datamart — sinh
  1 file CSV mapping chi tiết theo từng cột (target ↔ source, etl_logic,
  key) cho mỗi cặp (bảng, tầng đích), tương ứng 1 job ETL thật.

  Dùng khi: hld/HLD_Table_Design.md đã có (hoặc đã có phần) thiết kế cột
  chi tiết cho bảng cần làm LLD — người dùng muốn sinh file CSV mapping
  STG_LOS→SB_DWH, SB_DWH→STG_DTM (cắt lát ngày), hoặc STG_DTM→PDTD_DTM cho
  1 hoặc nhiều bảng.

  Output: lld/SB_DWH/SB_DWH_<TABLE_NAME>.csv,
    lld/STG_DTM/STG_DTM_STG_<TABLE_NAME>.csv,
    lld/PDTD_DTM/PDTD_DTM_<TABLE_NAME>.csv
    (11 cột: target_table,target_column,nullable,data_type,key,
     description,etl_logic,etl_logic_type,source_table,source_column,note)

  Input bắt buộc: hld/HLD_Table_Design.md (bảng đã thiết kế xong ở Section
  1+2, không còn PENDING toàn bộ cấu trúc — cột lẻ tẻ PENDING vẫn xử lý
  được, xem etl_logic_type=pending).
---

# Skill: Thiết kế LLD (STG_LOS → SB_DWH → STG_DTM → PDTD_DTM)

Đọc file này TRƯỚC KHI sinh bất kỳ file CSV nào.

## Quan hệ với các skill khác trong dự án

- `design-hld` quyết định **có những cột nào** trên mỗi bảng (kết quả ghi
  vào `hld/HLD_Table_Design.md`) — đây là input bắt buộc của skill này.
  Nếu bảng cần làm LLD chưa có trong HLD hoặc còn PENDING toàn bộ cấu trúc
  → dừng, báo người dùng chạy `design-hld` trước cho bảng đó.
- `mapping-gen` từng sinh Excel mapping rất chi tiết cho các bảng **GỘP CŨ**
  (trước khi tách CLOS/RLOS, VD `mapping/SB_DWH/Mapping_DIM_LOS_APPLICATION.xlsx`)
  — vẫn là tài liệu tham khảo hữu ích cho công thức ETL/JOIN chi tiết
  (nhiều bảng LLD mới kế thừa gần như nguyên vẹn logic từ bảng gộp cũ, chỉ
  bớt cột theo column-optimization rule của HLD), nhưng **không phải nguồn
  quyết định cột nào có mặt** — HLD mới luôn thắng khi 2 nguồn lệch nhau
  (HLD đã tách CLOS/RLOS và loại bỏ/bổ sung nhiều cột so với bản gộp).
- `mapping-extract-input` sinh `extract/SB_DWH/*.md`, `extract/PDTD_DTM/*.md`
  — bản GỘP cũ, dùng tra cứu bổ sung (data type, mô tả gốc), không phải
  nguồn cột.

## Tài nguyên đi kèm

- [`reference/attributes_format.md`](reference/attributes_format.md) — 11
  cột CSV, thứ tự đọc nguồn, cách xác định driving table qua sơ đồ mermaid
  HLD, key convention (chỉ `PK`, không có `FK`), 6 giá trị `etl_logic_type`,
  quy tắc tầng STG_DTM cắt lát theo ngày, quy tắc tầng PDTD_DTM luôn qua
  STG_DTM, quy tắc đặt tên file `{TẦNG}_{TÊN_BẢNG}.csv`
- [`reference/self_review.md`](reference/self_review.md) — khung self-review,
  hiện rỗng có chủ đích — bổ sung mục kiểm tra khi phát hiện lỗi thực tế

**Đọc `reference/attributes_format.md` đầy đủ trước khi điền bất kỳ dòng
CSV nào** — đây là bảng quy tắc chính, SKILL.md chỉ điều phối quy trình.

---

## QUY TRÌNH (BẮT BUỘC)

```
Phase 0 (PLAN):
  Đọc hld/HLD_Table_Design.md Section 1 (toàn bộ layer SB_DWH + PDTD_DTM)
  → liệt kê TOÀN BỘ bảng đã có thiết kế cột (không PENDING toàn bộ cấu trúc)
  → với mỗi bảng: xác định tối đa 3 job cần làm (SB_DWH, STG_DTM, PDTD_DTM
    — STG_DTM luôn làm được ngay khi job SB_DWH đã sẵn sàng, không cần chờ
    gì thêm) → check lld/{TẦNG}/ đã có file chưa (reuse — bỏ qua, báo "đã
    có, không làm lại" trừ khi user yêu cầu làm lại)
  → trình bày Plan dạng bảng (định dạng bên dưới)
  → DỪNG chờ human approve Plan trước khi sinh file đầu tiên

Loop mỗi (bảng, tầng) trong Plan đã duyệt:
  → đọc HLD (sơ đồ mermaid Section 1 + bảng cột Section 2) của đúng bảng
    + tầng (tầng STG_DTM dùng lại đúng sơ đồ của job SB_DWH, xem
    attributes_format.md)
  → đọc extract/{TẦNG}/<OLD_TABLE>.md nếu cần bổ sung data_type/mô tả
  → đọc SRS gốc nếu HLD ghi công thức PHÁI SINH chưa đủ chi tiết
  → xác định driving table từ sơ đồ mermaid (xem attributes_format.md)
  → điền đủ 11 cột cho từng cột đích
  → SELF-REVIEW theo reference/self_review.md (nếu đã có mục nào) → sửa
    nếu FAIL
  → trình bày file
  → DỪNG chờ human duyệt
  → ghi file vào lld/{TẦNG}/{TẦNG}_<TABLE_NAME>.csv
  → chuyển sang (bảng, tầng) tiếp theo trong Plan
```

> **GATE RULE:** Không tự bỏ qua bước dừng chờ duyệt Plan hay chờ duyệt
> từng file. Human chưa trả lời = chưa được phép tiếp tục.

---

## PHASE 0 — PLAN

### Bước P1 — Quét HLD lấy danh sách bảng sẵn sàng

Đọc `hld/HLD_Table_Design.md` Section 1 từ đầu đến hết (SB_DWH rồi
PDTD_DTM). Với mỗi bảng, ghi nhận:

- Tên bảng, tầng (SB_DWH / STG_DTM / PDTD_DTM)
- Trạng thái: đã có cột chi tiết ở Section 2 hay còn PENDING toàn bộ cấu
  trúc (không đủ để làm LLD — HLD chưa quyết định xong cột)
- Mỗi bảng SB_DWH đã sẵn sàng luôn kéo theo đúng 3 job: SB_DWH, STG_DTM
  (cắt lát ngày, làm ngay không cần chờ gì thêm), PDTD_DTM (nếu bảng "bê
  1:1" hoặc có thiết kế PDTD_DTM riêng theo Section 2 → 2.x)
- `MAP_*` (STG_LOS) và `REF_*` (PDTD_DTM) **không xuất hiện trong Plan** —
  đây là bảng nguồn, không phải target table của skill này (xem mục
  "Output" trong `attributes_format.md`)

### Bước P2 — Đối chiếu với `lld/` đã có

```bash
ls lld/SB_DWH/ lld/STG_DTM/ lld/PDTD_DTM/ 2>/dev/null
```

Bảng đã có file → đánh dấu "đã có" trong Plan, không sinh lại trừ khi
người dùng nói rõ muốn làm lại (VD sau khi HLD của bảng đó vừa được cập
nhật).

### Bước P3 — Trình bày Plan

```
## Plan thiết kế LLD

| STT | Bảng | Tầng | Trạng thái HLD | Job cần làm | File dự kiến | Đã có file? |
|-----|------|------|-----------------|-------------|--------------|-------------|
| 1   | DIM_CLOS_APPLICATION | SB_DWH  | Sẵn sàng | STG_LOS→SB_DWH  | SB_DWH_DIM_CLOS_APPLICATION.csv | Chưa |
| 2   | DIM_CLOS_APPLICATION | STG_DTM | Sẵn sàng | SB_DWH→STG_DTM (cắt lát ngày) | STG_DTM_STG_DIM_CLOS_APPLICATION.csv | Chưa |
| 3   | DIM_CLOS_APPLICATION | PDTD_DTM| Sẵn sàng | STG_DTM→PDTD_DTM | PDTD_DTM_DIM_CLOS_APPLICATION.csv | Chưa |
| 4   | DIM_CLOS_WORKSTEP    | SB_DWH  | Sẵn sàng | STG_LOS→SB_DWH  | SB_DWH_DIM_CLOS_WORKSTEP.csv | Chưa |
| ... | ...                  | ...     | ...      | ...             | ... | ...  |
| N   | <bảng còn PENDING toàn bộ cấu trúc> | — | PENDING (chưa làm HLD xong) | — bỏ qua | — | — |

Tổng: [X] job sẵn sàng | [Y] job đã có file (bỏ qua) | [Z] bảng còn PENDING HLD (bỏ qua)

→ Xác nhận Plan — làm theo đúng thứ tự trên, hay chỉ định lại thứ tự/tập con?
```

> **GATE — bắt buộc dừng:** chờ human approve Plan (toàn bộ hoặc 1 tập con
> họ chỉ định) trước khi sinh bất kỳ file nào.

---

## VÒNG LẶP CHÍNH — mỗi (bảng, tầng)

### Bước 1 — Đọc nguồn

Theo đúng thứ tự "Nguồn sự thật" trong `reference/attributes_format.md`:
sơ đồ mermaid HLD Section 1 + bảng cột Section 2 của đúng bảng+tầng →
extract cũ (bổ sung data_type/mô tả) → SRS gốc nếu cần →
`DS_BANG_202608.xlsx` nếu cần xác định hash khóa nghiệp vụ → metadata
CLOS/RLOS nếu cần xác nhận cột tồn tại thật.

### Bước 2 — Xác định driving table

Đọc đúng sơ đồ mermaid Section 1 của bảng — driving table là bảng nguồn
mà nhãn mũi tên ghi rõ nhất quan hệ cấp business key/PK chính. Không suy
từ mô tả grain bằng văn xuôi, không suy từ thứ tự liệt kê "Nguồn". Với
bảng ở tầng STG_DTM, driving table luôn là chính bảng SB_DWH gốc (xem
"Tầng STG_DTM — cắt lát theo ngày"). Với bảng ở tầng PDTD_DTM, nhớ áp dụng
quy tắc "luôn qua STG_DTM" (đổi tên `STG_<TÊN_BẢNG_SB_DWH>`) — xem
`attributes_format.md`. Ghi rõ trong `description` của dòng `key = PK`.

### Bước 3 — Điền 11 cột cho từng cột đích

Theo đúng header, `data_type` mapping, key convention (chỉ `PK`), và bộ 6
giá trị `etl_logic_type` đã mô tả trong `attributes_format.md`. Copy mọi
cảnh báo PENDING/lệch tài liệu từ HLD vào `note` (không nhồi vào
`description`).

### Bước 4 — Self-review

Chạy các mục hiện có trong `reference/self_review.md` (có thể chưa có mục
nào — file khởi đầu rỗng có chủ đích, xem ghi chú trong file đó). Khi phát
hiện lỗi trong lúc làm, thêm ngay 1 mục self-review mới vào file đó trước
khi sửa lỗi, để lần sau tự động kiểm tra lại.

### Bước 5 — Trình bày & chờ duyệt

Trình bày file (đường dẫn `lld/{TẦNG}/{TẦNG}_<TABLE_NAME>.csv`, VD
`lld/STG_DTM/STG_DTM_STG_DIM_CLOS_WORKSTEP.csv`). Dừng chờ human duyệt.
Sau khi duyệt → ghi file, báo "Đã ghi [path], [N] dòng" → chuyển (bảng,
tầng) tiếp theo trong Plan.

---

## Khi phát hiện HLD chưa đủ để làm LLD

Nếu 1 bảng trong Plan hóa ra vẫn còn cột PENDING toàn bộ cấu trúc (không
chỉ 1-2 cột lẻ mà cả hướng thiết kế chưa chốt) khi bắt đầu đọc chi tiết —
dừng, báo người dùng: bảng này cần `design-hld` xử lý tiếp trước, không tự
suy diễn cấu trúc cột thay HLD.

## Sau khi hoàn thành 1 job

Báo ngắn gọn: bảng, tầng, số dòng, driving table dùng, số cột `pending`
(nếu có, kèm lý do ngắn), rồi hỏi có tiếp tục job kế tiếp trong Plan không.
