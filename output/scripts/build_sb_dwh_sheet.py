import json
import shutil
import zipfile
import openpyxl
from openpyxl.styles import Font, Alignment
from copy import copy


def fix_zip_order(path):
    """openpyxl writes [Content_Types].xml last; OPC/Excel require it
    first, otherwise Excel (esp. macOS) refuses to open the file even
    though the XML content itself is valid."""
    tmp = path + '.tmp'
    with zipfile.ZipFile(path, 'r') as zin:
        names = zin.namelist()
        ordered = ['[Content_Types].xml'] + [n for n in names if n != '[Content_Types].xml']
        infos = {i.filename: i for i in zin.infolist()}
        with zipfile.ZipFile(tmp, 'w', zipfile.ZIP_DEFLATED) as zout:
            for name in ordered:
                zout.writestr(infos[name], zin.read(name))
    shutil.move(tmp, path)

SRC_JSON = '/Users/chiennguyen/sb-mapping-gen/output/lineage_sb_dwh_all.json'
TEMPLATE = '/Users/chiennguyen/sb-mapping-gen/input/Template_design_20260927.xlsx'
OUT = '/Users/chiennguyen/sb-mapping-gen/output/SB_DWH_PDTD_DTM_Lineage.xlsx'

rows = json.load(open(SRC_JSON, encoding='utf-8'))

wb = openpyxl.load_workbook(TEMPLATE)
ws = wb['SB_DWH']

header_font = copy(ws['A1'].font)
body_font = Font(name=header_font.name, size=11, bold=False)
wrap_align = Alignment(wrap_text=True, vertical='top')
top_align = Alignment(wrap_text=False, vertical='top')

def br_to_newline(s):
    if not s:
        return s
    return s.replace('<br>', '\n')

def source_table_display(source_table):
    """Multi-source values are '<br>'-joined; render each on its own
    line in the cell (Alt+Enter), not as literal '<br>' text."""
    if not source_table:
        return source_table
    return br_to_newline(source_table)

def source_column_display(source_table, source_column):
    """Single source: keep the bare column name (the table is already
    shown in the adjacent 'source table' cell). Multi-source: prefix
    each column with its table (TABLE.COLUMN), one pair per line, so
    it's unambiguous which column belongs to which table."""
    if not source_column:
        return source_column
    tables = (source_table or '').split('<br>')
    columns = source_column.split('<br>')
    if len(columns) == 1:
        return columns[0]
    if len(tables) != len(columns):
        # fall back to plain newline-joined columns if arrays don't align
        return br_to_newline(source_column)
    return '\n'.join(f'{t}.{c}' for t, c in zip(tables, columns))

def clean(v):
    """Return None instead of empty string so openpyxl doesn't write a
    malformed empty inlineStr cell (Excel rejects those as corrupt).
    Also guard against leading =/+/-/@ which Excel/LibreOffice parse as
    a formula instead of literal text, producing #VALUE!/#REF! errors
    that make Excel refuse to open the file."""
    if v is None:
        return None
    v = str(v).strip()
    if not v:
        return None
    if v[0] in ('=', '+', '-', '@'):
        v = "'" + v
    return v

r = 2
for row in rows:
    ws.cell(row=r, column=1, value=r - 1)  # STT
    ws.cell(row=r, column=2, value=clean(row.get('target_table')))
    ws.cell(row=r, column=3, value=clean(row.get('target_column')))
    ws.cell(row=r, column=4, value=clean(row.get('meaning')))
    ws.cell(row=r, column=5, value=clean(source_table_display(row.get('source_table'))))
    ws.cell(row=r, column=6, value=clean(source_column_display(row.get('source_table'), row.get('source_column'))))
    ws.cell(row=r, column=7, value=clean(row.get('logic')))
    ws.cell(row=r, column=8, value=clean(br_to_newline(row.get('reports'))))
    ws.cell(row=r, column=9, value=clean(br_to_newline(row.get('report_metrics'))))
    ws.cell(row=r, column=10, value=clean(row.get('note')))
    for col in range(1, 11):
        cell = ws.cell(row=r, column=col)
        cell.font = body_font
        cell.alignment = wrap_align
    r += 1

last_row = r - 1
print('Rows written:', last_row - 1)

wb.save(OUT)
fix_zip_order(OUT)
print('Saved to', OUT)
