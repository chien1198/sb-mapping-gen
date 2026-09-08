# seabank-mapping-gen

Gen tài liệu mapping dim/fact (Excel) từ tài liệu thiết kế database (docx) và
thiết kế datamart (excel), dựa theo template mapping có sẵn.

## Cấu trúc thư mục

```
seabank-mapping-gen/
├── input/         # tài liệu đầu vào gốc: docx (database design), xlsx (datamart/report design)
├── extract/       # bản convert của input sang dạng file native (markdown/json) — tối ưu token khi đọc
│   ├── database/  # từ docx thiết kế database (schema CLOS/RLOS gốc)
│   ├── SB_DWH/    # từ DATAMODEL_DWH_LOS_*.xlsx (lineage/logic cho phase SB_DWH)
│   ├── PDTD_DTM/  # từ DATAMODEL_DTM_PDTD_*.xlsx (lineage/logic cho phase PDTD_DTM)
│   └── Report/    # từ Reports_*.xlsx (truy vết trường báo cáo BC1-BC11 về DWH/DTM)
├── references/    # template mapping mẫu có sẵn (2 tài liệu tham chiếu)
└── mapping/       # file đích: kết quả mapping được generate ra
```

- **input/**: đặt file `.docx` (thiết kế database) và `.xlsx` (thiết kế datamart/report) gốc
  vào đây (trực tiếp, không đệ quy). `input/oldversions/` giữ các phiên bản tài liệu cũ đã
  thay thế — không bao giờ dùng làm nguồn extract. `input/srs_report/` giữ các SRS chi tiết
  từng báo cáo (docx), chưa được extract tự động.
- **extract/**: nội dung đã convert từ input/ sang dạng dễ đọc (markdown/json), dùng thay
  cho việc đọc lại docx/xlsx gốc mỗi lần.
- **references/**: 2 tài liệu template mapping mẫu có sẵn, dùng làm chuẩn đối chiếu khi gen.
- **mapping/**: file mapping đích được tạo ra từ input + references.

> **Lưu ý bảo mật**: `input/`, `extract/`, `mapping/` đều được commit vào repo (private)
> để giữ lịch sử thay đổi tài liệu/mapping qua git. Vì repo private nên tài liệu thiết
> kế nội bộ của ngân hàng trong `input/` được chấp nhận lưu ở đây — không đẩy repo này
> thành public hoặc chia sẻ ra ngoài phạm vi được phép.

## Skills

- **mapping-extract-input** (`.claude/skills/mapping-extract-input/`): convert `input/*.docx`
  và `input/*.xlsx` (chỉ file nằm trực tiếp trong `input/`, không đệ quy vào
  `input/oldversions/` hay `input/srs_report/`) thành các file Markdown nhỏ
  theo từng bảng trong `extract/database/`, `extract/SB_DWH/`,
  `extract/PDTD_DTM/`, `extract/Report/`, kèm `_index.json` mỗi thư mục để
  tra nhanh bảng nào ở file nào. Chạy lại skill này mỗi khi upload/đổi file
  trong `input/`.

  Chạy trực tiếp (không qua skill):
  ```bash
  python3 -m venv .venv && .venv/bin/pip install python-docx openpyxl
  .venv/bin/python scripts/extract_input.py
  ```

- **mapping-gen** (`.claude/skills/mapping-gen/`): sinh file mapping
  `mapping/<DESTINATION>/Mapping_<TABLE>.xlsx` cho một bảng DIM/FCT, theo
  đúng layout của 2 template mẫu trong `references/`. Agent đọc
  `extract/database/<TABLE>.md` + `extract/SB_DWH/<TABLE>.md` (hoặc
  `extract/PDTD_DTM/<TABLE>.md` tùy phase) để suy luận công thức "How to
  mapping" theo từng hệ nguồn (CLOS/RLOS), rồi gọi `scripts/gen_mapping.py`
  để điền vào bản sao template (giữ nguyên style/màu sắc).
