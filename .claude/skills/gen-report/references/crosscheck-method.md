# Phương pháp cross-check (Phase 3)

Mục tiêu: kiểm tra câu lệnh báo cáo đã gen đúng **SRS** và **lineage LLD**. Kết quả trả **trong hội thoại**.

## 1. Kiểm tra cơ học — `scripts/check_report.py BCn <file.sql>`

| Mục | Nội dung | Kết quả xấu |
|---|---|---|
| 1. Phủ cột và thứ tự | Trường SRS ↔ cột SELECT; nếu câu lệnh có `UNION ALL` thì mỗi nhánh đối chiếu với một mục SRS (theo thứ tự). Kiểm cả **thứ tự cột** so với SRS | Thiếu / thừa / sai thứ tự cột → lỗi; cột đệm `NULL` cho UNION chỉ là thông tin |
| 2. Cột tồn tại | Mọi `alias.COLUMN` có trong `lld/pdtd_dtm` (hoặc do CTE tạo ra) | Cột treo → lỗi |
| 3. STG_ | Không tham chiếu `STG_*` | Còn `STG_` → lỗi |
| 4. Chuỗi lineage | Cột gen → nguồn SBLOS2 (qua LLD) → so với nguồn SRS ghi | xem bảng dưới |
| 5. LISTAGG | Có `ON OVERFLOW` | Cảnh báo |
| 6. Literal chuỗi | Literal trong logic SRS (từng trường có logic phái sinh) và trong điều kiện alias map có mặt trong câu lệnh không (không phân biệt hoa thường, phân biệt dấu) | Thông tin, không tính lỗi — đọc tay. Gặp `'REALSTATE'` ≠ `'REALESTATE'` hoặc lỗi gõ literal |

Mục 4, mỗi trường rơi vào một mức:

| Mức | Ý nghĩa | Việc cần làm |
|---|---|---|
| exact | Lineage về đúng cột nguồn SRS | Không cần |
| table | Chỉ khớp bảng nguồn, cột khác hoặc phái sinh | Đọc tay công thức |
| mismatch | Lineage về nguồn **khác** SRS | Đọc tay: là lệch thật, hay LLD cố ý khác SRS? (nếu LLD thì **không cảnh báo**) |
| no-trace | Cột gen không có lineage về SBLOS2 (khóa SK, tính toán) | Đọc tay logic ở LLD |
| literal-ok | Biểu thức là literal và khớp giá trị SRS (ví dụ `'CLOS'`) | Không cần |
| literal-diff | Biểu thức là literal nhưng khác giá trị SRS | Kiểm tra |
| no-ref | Biểu thức không tham chiếu cột PDTD_DTM và không phải literal thuần | Đọc tay |

Exit code 1 chỉ khi có lỗi mục 1–3 (kể cả sai thứ tự cột). Mục 4–6 là thông tin để đọc tay.
Nếu SRS có dòng với số dấu nháy lẻ (lỗi gõ), script báo riêng ở mục 6 và không đối chiếu literal của dòng đó — nên đưa vào "Cần chốt" như một điểm SRS mơ hồ.

## 2. Đọc tay phần ngữ nghĩa

Với mỗi trường thuộc mức table / mismatch / no-trace / no-ref, và mọi trường phái sinh, đối chiếu logic SRS
với câu lệnh gen:

1. **Bảng và khóa join** — SRS alias map (mục "Bảng nguồn sử dụng & điều kiện Join") so với `JOIN ... ON` trong gen
   (qua SK trên PDTD_DTM, hiểu theo `etl_logic` của LLD).
2. **Điều kiện lọc** — `WHERE`/`ON` có đủ điều kiện SRS nêu (`ID_TYPE IN (...)`, `DECISION = '...'`, `WORKSTEP IN (...)`).
3. **Literal** — giá trị chuỗi so sánh (`'REALESTATE'` vs `'REALSTATE'`, `'proofincome01'`...) đúng chính tả và đúng kiểu hoa/thường.
4. **Hàm gộp / chọn dòng** — `MIN/MAX`, "dòng có ENTRYDATE lớn nhất", `ROW_NUMBER`.
5. **Grain** — dòng con nào nhân dòng; có khớp quyết định đã chốt; số dòng nhân tích.
6. **Kiểu dữ liệu** — chuỗi hóa số bằng `TO_CHAR`, `TO_NUMBER`... thay đổi kiểu so với SRS.
7. **Tham số** — điều kiện `DAYID`/`PROCESSED_DATE`, tham số báo cáo đúng BR x.1 của SRS.

## 3. Phân loại kết quả

| Loại | Dùng khi |
|---|---|
| **Cần chốt** | SRS mơ hồ hoặc SRS ≠ LLD ở điểm ảnh hưởng kết quả; hoặc grain chưa có quyết định |
| **Gen lệch** | Gen khác SRS/LLD một cách rõ ràng và có cách sửa |
| **Đã chốt** | Điểm đã có trong `decisions/BCn.md` — bỏ qua, không báo lại |

- **Không** báo lỗi trong LLD, không báo chênh giữa LLD và HLD/`lld/BCn.csv`.
- **Không** có mục lỗi của testcase BA. Nếu BA khác SRS ở một điểm, coi đó là dấu hiệu SRS mơ hồ và đưa vào "Cần chốt".

Mức độ: **Cao** (giá trị sai nhiều khả năng / mất dòng / nhân dòng) · **TB** (sai ở một số trường hợp) · **Thấp** (định dạng, kiểu dữ liệu).

## 4. Khuôn trả lời trong hội thoại

```
## Điểm cần bạn chốt
1. <trường/nhóm> — <vấn đề>. Lựa chọn: (a) ... (b) ... Đề xuất: ...

## Gen lệch SRS/LLD
| Trường | Chuẩn (SRS / LLD) | Gen hiện tại (dòng) | Mức | Cách sửa |

## Tóm tắt
SRS=N trường, gen=N cột. Lineage: exact=…, table=…, mismatch=…, no-trace=…, no-ref=…
Lỗi cơ học: …
```

Mỗi mục trong bảng "Gen lệch" ghi **đường dẫn file + số dòng** của câu lệnh gen.
Mục nào rỗng thì ghi "không có".

## 5. Sau khi người dùng trả lời

- Sửa gen theo quyết định, chạy lại `check_report.py`, báo kết quả ngắn gọn.
- Ghi các điểm vừa chốt vào `decisions/BCn.md` (Điểm | Quyết định | Ngày | Ghi chú).
