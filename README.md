# seabank-mapping-gen

Gen tài liệu mapping dim/fact (Excel) từ tài liệu thiết kế database (docx) và
thiết kế datamart (excel), dựa theo template mapping có sẵn.

## Cấu trúc thư mục

```
seabank-mapping-gen/
├── input/         # tài liệu đầu vào gốc: docx (database design), xlsx (datamart design)
├── extract/       # bản convert của input sang dạng file native (markdown/json) — tối ưu token khi đọc
├── references/    # template mapping mẫu có sẵn (2 tài liệu tham chiếu)
└── mapping/       # file đích: kết quả mapping được generate ra
```

- **input/**: đặt file `.docx` (thiết kế database) và `.xlsx` (thiết kế datamart) gốc vào đây.
- **extract/**: nội dung đã convert từ input/ sang dạng dễ đọc (markdown/json), dùng thay
  cho việc đọc lại docx/xlsx gốc mỗi lần.
- **references/**: 2 tài liệu template mapping mẫu có sẵn, dùng làm chuẩn đối chiếu khi gen.
- **mapping/**: file mapping đích được tạo ra từ input + references.

> **Lưu ý bảo mật**: `input/`, `extract/`, `mapping/` bị git-ignore mặc định vì có thể
> chứa dữ liệu thiết kế nội bộ/nhạy cảm của ngân hàng. Chỉ `references/` (template không
> nhạy cảm) được commit.

## Skills

- **mapping-extract-input** (`.claude/skills/mapping-extract-input/`): convert `input/*.docx`
  và `input/*.xlsx` thành các file Markdown nhỏ theo từng bảng trong
  `extract/database/` và `extract/datamart/`, kèm `_index.json` để tra
  nhanh bảng nào ở file nào. Chạy lại skill này mỗi khi upload/đổi file
  trong `input/`.

  Chạy trực tiếp (không qua skill):
  ```bash
  python3 -m venv .venv && .venv/bin/pip install python-docx openpyxl
  .venv/bin/python scripts/extract_input.py
  ```

- **mapping-gen** (`.claude/skills/mapping-gen/`): sinh file mapping
  `mapping/Mapping_<TABLE>.xlsx` cho một bảng DIM/FCT, theo đúng layout của
  2 template mẫu trong `references/`. Agent đọc `extract/database/<TABLE>.md`
  + `extract/datamart/<TABLE>.md` để suy luận công thức "How to mapping"
  theo từng hệ nguồn (CLOS/RLOS), rồi gọi `scripts/gen_mapping.py` để điền
  vào bản sao template (giữ nguyên style/màu sắc).
