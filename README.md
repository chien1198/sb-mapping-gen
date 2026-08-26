# seabank-mapping-gen

Công cụ generate tài liệu mapping dim/fact (Excel) từ:

1. Tài liệu thiết kế database (`.docx`)
2. Tài liệu thiết kế datamart, có mô tả logic (`.xlsx`)

theo một template Excel chuẩn có sẵn.

## Kiến trúc pipeline

```
docx (database design)  ──┐
                           ├─► extract ─► cache JSON ─► mapping ─► generate ─► output .xlsx
xlsx (datamart design)  ──┘
```

- **extract**: đọc file gốc (docx/xlsx) một lần, chuẩn hoá thành JSON theo schema
  cố định (`src/seabank_mapping_gen/models/schema.py`), lưu vào `data/cache/`.
  Các bước sau chỉ đọc JSON cache — không phải đọc lại docx/xlsx gốc mỗi lần
  chạy, giúp tiết kiệm token/thời gian khi lặp lại.
- **mapping**: đối chiếu database design và datamart design (đã cache) để build
  ra danh sách mapping (source → target, transform logic), đồng thời cảnh báo
  cột nào không đối chiếu được.
- **generate**: đổ mapping đã build vào file `templates/mapping_template.xlsx`
  (giữ nguyên style/header của template), xuất ra `data/output/`.

## Cấu trúc thư mục

```
seabank-mapping-gen/
├── src/seabank_mapping_gen/
│   ├── extract/         # đọc docx/xlsx gốc -> model chuẩn hoá
│   │   ├── database_docx.py
│   │   └── datamart_xlsx.py
│   ├── mapping/         # build mapping logic từ 2 design đã chuẩn hoá
│   │   └── build_mapping.py
│   ├── generate/        # ghi mapping vào template xlsx
│   │   └── xlsx_writer.py
│   ├── models/          # schema trung gian (Pydantic) dùng chung toàn pipeline
│   │   └── schema.py
│   ├── utils/           # cache JSON, helper dùng chung
│   │   └── cache.py
│   └── cli.py           # entrypoint CLI (extract / build / run)
├── templates/            # template .xlsx mapping chuẩn (đặt file mẫu vào đây)
├── data/
│   ├── input/
│   │   ├── database_design/   # đặt file .docx thiết kế database vào đây
│   │   └── datamart_design/   # đặt file .xlsx thiết kế datamart vào đây
│   ├── cache/            # JSON đã extract (git-ignored, tự sinh lại được)
│   │   ├── database/
│   │   └── datamart/
│   └── output/            # file mapping .xlsx kết quả (git-ignored)
├── tests/
└── docs/                  # tài liệu tham chiếu, ghi chú nghiệp vụ
```

> **Lưu ý bảo mật**: `data/input/`, `data/cache/`, `data/output/` bị git-ignore
> mặc định vì có thể chứa dữ liệu thiết kế nội bộ/nhạy cảm của ngân hàng.
> Chỉ commit code, template rỗng, và tài liệu tham chiếu không nhạy cảm.

## Cài đặt

```bash
python -m venv .venv
source .venv/bin/activate
pip install -e ".[dev]"
```

## Sử dụng

```bash
# Bước 1: extract riêng (tạo cache JSON, có thể inspect/sửa tay trước khi build)
mapping-gen extract \
  --database data/input/database_design/db_design.docx \
  --datamart data/input/datamart_design/datamart_design.xlsx

# Bước 2: build mapping từ cache đã có + template -> output
mapping-gen build \
  --database-cache data/cache/database/db_design.json \
  --datamart-cache data/cache/datamart/datamart_design.json \
  --template templates/mapping_template.xlsx \
  --output data/output/mapping.xlsx

# Hoặc chạy full pipeline 1 lệnh
mapping-gen run \
  --database data/input/database_design/db_design.docx \
  --datamart data/input/datamart_design/datamart_design.xlsx \
  --template templates/mapping_template.xlsx \
  --output data/output/mapping.xlsx
```

## Trạng thái hiện tại

Đây là khung sườn (scaffold) ban đầu. Các phần sau còn là **skeleton cần
hoàn thiện dựa trên file mẫu thực tế**:

- [`extract/database_docx.py`](src/seabank_mapping_gen/extract/database_docx.py) —
  cần chỉnh `EXPECTED_HEADERS`/`_parse_table` theo layout bảng thật trong docx.
- [`extract/datamart_xlsx.py`](src/seabank_mapping_gen/extract/datamart_xlsx.py) —
  cần chỉnh `EXPECTED_HEADERS`/`_parse_sheet` theo layout sheet thật trong xlsx.
- [`generate/xlsx_writer.py`](src/seabank_mapping_gen/generate/xlsx_writer.py) —
  cần chỉnh `TEMPLATE_SHEET_NAME`/`START_ROW`/`COLUMN_MAP` theo template thật.

Khi bạn gửi tài liệu mẫu (database design, datamart design, template mapping),
các phần trên sẽ được cập nhật để khớp đúng layout thực tế.
