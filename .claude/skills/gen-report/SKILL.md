---
name: gen-report
description: |
  Sinh câu lệnh SQL cho báo cáo BCn (PDTD_DTM, Oracle 19c) từ SRS + LLD, rồi cross-check
  kết quả với SRS và lineage LLD. Một skill, 3 phase: (1) bản đồ trường báo cáo → cột
  PDTD_DTM bằng lineage sinh từ LLD, (2) gen câu lệnh báo cáo, (3) cross-check và trả
  kết quả ngay trong hội thoại (không tạo file báo cáo).

  Dùng khi: người dùng yêu cầu gen / viết lại / kiểm tra câu lệnh báo cáo BC1..BC11 từ
  PDTD_DTM, hoặc cross-check câu lệnh báo cáo với SRS.

  Output: mapping/BAOCAO/BCn_<tên>.sql. Phase 3 trả kết quả trong hội thoại.

  Input bắt buộc: extract/srs_report/BCn.md (SRS), lld/pdtd_dtm|stg_dtm|sb_dwh/*.csv (LLD).
  Testcase BA (input/testcaseBC/testcase_BCn.sql) là nguồn tham khảo, không bắt buộc.
---

# Skill: Gen câu lệnh báo cáo + cross-check

Đọc file này TRƯỚC KHI gen hoặc kiểm tra bất kỳ câu lệnh báo cáo nào.

## Thứ tự tin cậy của nguồn

1. **SRS** (`extract/srs_report/BCn.md`) — logic nghiệp vụ của từng trường.
2. **LLD theo từng bảng** (`lld/pdtd_dtm|stg_dtm|sb_dwh/*.csv`) — cột nào có thật, ETL ra sao. Coi là đáng tin;
   **không** cảnh báo logic nằm trong LLD, kể cả chỗ LLD khác chữ SRS.
3. **Quyết định đã chốt** (`decisions/BCn.md`) — ghi đè mọi nguồn khác khi có mâu thuẫn.
4. **HLD** (`hld/HLD_*_review.md`) và `lld/BCn.csv` — **chỉ tham khảo**, có thể cũ. Không dùng làm căn cứ ánh xạ.
5. Testcase BA — tham khảo. Không liệt kê lỗi của BA; chỗ BA khác SRS chỉ dùng để nhận ra điểm SRS mơ hồ.

Các quy tắc cố định (STG → DIM_T24, snapshot DAYID, `LISTAGG`...) nằm ở `references/gen-rules.md`.

## Script (đặt ở `scripts/` của repo, skill gọi trực tiếp)

| Script | Việc |
|---|---|
| `scripts/build_lineage.py [--check]` | Sinh lineage chuỗi PDTD_DTM ← STG_DTM ← SB_DWH ← SBLOS2 từ LLD vào `output/lineage/`. `--check` báo FRESH/STALE theo hash file LLD |
| `scripts/build_field_map.py BCn` | Phase 1: bản đồ trường SRS → cột PDTD_DTM (auto / candidate / unresolved) và nhóm 1–N |
| `scripts/check_report.py BCn <file.sql>` | Phase 3: kiểm tra cơ học câu lệnh báo cáo |

Cả hai script Phase 1 và 3 tự chạy `build_lineage.py --check` và sinh lại lineage nếu STALE.
Chạy từ gốc repo, ví dụ `python3 scripts/build_field_map.py BC1`.

## Phase 1 — Bản đồ trường báo cáo

1. Đảm bảo `extract/srs_report/BCn.md` có (nếu chưa, dùng skill `mapping-extract-input`).
2. Chạy `python3 scripts/build_field_map.py BCn`. Script in bảng trường (không tạo file):
   - **auto**: có cột PDTD_DTM với lineage về đúng cột nguồn SRS ghi (hoặc trùng tên trên bảng hồ sơ).
   - **candidate**: chỉ khớp được bảng nguồn.
   - **unresolved**: không khớp (trường phái sinh, nguồn ngoài lineage).
   - **Nhóm 1–N**: bảng FCT khác bảng hồ sơ, có PK khác → báo cáo có thể ra nhiều dòng / hồ sơ.
3. Tự giải quyết candidate / unresolved trước: đọc logic SRS của trường và `etl_logic`/`description` trong
   `lld/pdtd_dtm/PDTD_DTM_<bảng>.csv`; xem `references/patterns.md` cho 4 loại trường.
4. Đọc `decisions/BCn.md` (nếu có): điểm nào đã chốt thì áp dụng, không hỏi lại.

**Điểm dừng 1** — chỉ dừng hỏi người dùng khi sau bước 3–4 vẫn còn:
- trường candidate / unresolved mà SRS + LLD không đủ để chọn cột;
- nhóm 1–N chưa có quyết định về grain trong `decisions/BCn.md`.

Mỗi câu hỏi nêu rõ lựa chọn và đề xuất của bạn. Nếu không còn gì, đi thẳng sang Phase 2.

## Phase 2 — Gen câu lệnh báo cáo

1. Đọc `references/gen-rules.md` và `references/patterns.md`.
2. Sinh `mapping/BAOCAO/BCn_<tên>.sql` theo bản đồ trường + logic SRS + `decisions/BCn.md`.
   - Tên cột đầu ra = tên trường SRS (alias), đúng thứ tự SRS.
   - Chỉ tham chiếu bảng PDTD_DTM; **không** tham chiếu `STG_*`.
   - Khi sửa file đã có, giữ phần đã chốt trong `decisions/BCn.md`.
3. Chưa có go-ahead của người dùng thì không ghi đè file câu lệnh đã tồn tại — hỏi trước.

## Phase 3 — Cross-check, trả kết quả trong hội thoại

1. Chạy `python3 scripts/check_report.py BCn <file.sql>`.
   Exit code 1 = có lỗi cơ học (thiếu/thừa cột, cột không tồn tại, còn `STG_`).
2. Đọc tay phần ngữ nghĩa theo `references/crosscheck-method.md` (join đúng bảng/khóa, điều kiện lọc,
   literal, hàm gộp, grain) — script không làm thay được.
3. Trả kết quả **trong hội thoại, không tạo file**, theo đúng thứ tự:
   1. **Điểm cần bạn chốt** — đứng đầu, mỗi điểm kèm lựa chọn và đề xuất.
   2. **Gen lệch SRS/LLD** — mỗi mục nêu trường, chuẩn (SRS/LLD), gen hiện tại (dòng trong file), mức, cách sửa.
   3. **Tóm tắt** — phủ cột và số trường theo từng mức (exact / table / mismatch / no-trace / no-ref).
   Bỏ qua điểm đã có trong `decisions/BCn.md`. Không có mục "BA lệch".
4. Người dùng trả lời → sửa gen → chạy lại Phase 3 trong cùng phiên.

## Thư mục `decisions/`

`decisions/BCn.md` ghi những điểm người dùng đã chốt cho báo cáo BCn (bảng: Điểm | Quyết định | Ngày | Ghi chú).
- Chỉ ghi khi người dùng chốt một điểm; cập nhật khi họ đổi ý.
- Phase 2 đọc để gen đúng; Phase 3 đọc để không báo lại điều đã chốt.
- Sang phiên mới, file này giữ nguyên quyết định; Phase 2 chỉ hỏi các điểm chưa có trong đó.

## Không làm

- Không cảnh báo logic trong LLD hoặc lệch giữa LLD và HLD/`lld/BCn.csv`.
- Không tự quyết grain khi `decisions/BCn.md` chưa ghi — luôn hỏi.
- Không dán dữ liệu khách hàng thật vào hội thoại; chỉ dùng cấu trúc và dữ liệu synthetic.
- Mọi câu lệnh sinh ra là **draft cần human review** và qua code review/CI như code thông thường.
