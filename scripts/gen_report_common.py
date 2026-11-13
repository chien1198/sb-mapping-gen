"""Ham dung chung cho skill gen-report (build_field_map.py, check_report.py).

Nguon: extract/srs_report/BCn.md (SRS), output/lineage/lineage_chain.csv (sinh tu LLD),
lld/pdtd_dtm/*.csv (cot co that). Khong doc HLD, khong doc lld/BC*.csv.
"""
import csv
import glob
import os
import re
import subprocess
import sys
from collections import defaultdict

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LINEAGE_CSV = os.path.join(ROOT, 'output', 'lineage', 'lineage_chain.csv')
DECISIONS_DIR = os.path.join(ROOT, '.claude', 'skills', 'gen-report', 'decisions')

RESERVED = {'CASE', 'COALESCE', 'SUBSTR', 'UPPER', 'LOWER', 'TRIM', 'NVL', 'MIN', 'MAX', 'SUM', 'COUNT', 'LISTAGG', 'SELECT', 'WHEN', 'NULL'}
SRC_TBL = r'(?:NG_SB_|SB_[CR]LOS_|[CR]LOS_REF_|Q_[CR]LOS_|STG_DIM_)[A-Z0-9_]*'


def norm(s):
    """Chuan hoa ten cot de so khop (bo dau gach duoi: ENTRY_DATE = ENTRYDATE)."""
    return (s or '').replace('_', '').upper()


def ensure_lineage():
    """Chay build_lineage.py --check; STALE thi sinh lai. Tra ve thong bao."""
    script = os.path.join(ROOT, 'scripts', 'build_lineage.py')
    r = subprocess.run([sys.executable, script, '--check'], capture_output=True, text=True)
    if r.returncode == 0:
        return r.stdout.strip()
    r2 = subprocess.run([sys.executable, script], capture_output=True, text=True)
    return r.stdout.strip() + ' | ' + r2.stdout.strip()


def load_lineage():
    with open(LINEAGE_CSV, newline='', encoding='utf-8-sig') as fh:
        return list(csv.DictReader(fh))


def pdtd_columns():
    """{table: {COLUMN,...}} tu lld/pdtd_dtm (nguon tin cay cho 'cot co that')."""
    out = defaultdict(set)
    for f in glob.glob(os.path.join(ROOT, 'lld', 'pdtd_dtm', 'PDTD_DTM_*.csv')):
        with open(f, newline='', encoding='utf-8-sig') as fh:
            reader = csv.DictReader(fh)
            if 'target_table' not in (reader.fieldnames or []):
                print(f'CANH BAO: {os.path.basename(f)} khong co cot target_table - file bi bo qua', file=sys.stderr)
            for r in reader:
                if r.get('target_table'):
                    out[r['target_table']].add(r['target_column'].upper())
    return out


def pdtd_pk(table):
    """Tap cot PK cua bang PDTD_DTM (de nhan dien grain 1-N)."""
    f = os.path.join(ROOT, 'lld', 'pdtd_dtm', f'PDTD_DTM_{table}.csv')
    if not os.path.exists(f):
        return set()
    with open(f, newline='', encoding='utf-8-sig') as fh:
        return {r['target_column'].upper() for r in csv.DictReader(fh) if (r.get('key') or '').startswith('PK')}


def parse_srs(bc):
    """Doc extract/srs_report/<bc>.md -> list {section, field, meaning, logic, tables, pairs}.

    pairs = {(bang_nguon, COT)} bat tu 'BANG> COT', 'BANG alias> COT', 'BANG.COT'.
    tables = moi bang nguon duoc nhac toi trong cot 'Cach lay du lieu'.
    """
    path = os.path.join(ROOT, 'extract', 'srs_report', f'{bc}.md')
    lines = open(path, encoding='utf-8').read().splitlines()
    out, in_sec, section = [], False, ''
    for ln in lines:
        if ln.startswith('## '):
            in_sec = 'Danh sách trường' in ln
            section = ''
            continue
        if not in_sec:
            continue
        if ln.startswith('### '):
            section = ln[4:].strip()
            continue
        if not ln.startswith('|'):
            continue
        cells = [c.strip().replace('\x00', '|') for c in ln.replace('\\|', '\x00').strip().strip('|').split('|')]
        if len(cells) < 4 or cells[1] in ('Trường', '---', ''):
            continue
        logic = cells[3]
        pairs = set(re.findall(r'\b(' + SRC_TBL + r')\s*(?:[a-z][a-z0-9]?)?\s*>\s*(?:[a-z][a-z0-9]?\.)?([A-Z][A-Z0-9_]*)(?!\w)', logic))
        pairs |= set(re.findall(r'\b(' + SRC_TBL + r')\.([A-Z][A-Z0-9_]*)(?!\w)', logic))
        pairs = {(t, c) for t, c in pairs if c not in RESERVED and not re.fullmatch(SRC_TBL, c)}
        tables = set(re.findall(r'\b(' + SRC_TBL + r')\b', logic))
        out.append({'section': section, 'field': cells[1], 'meaning': cells[2], 'logic': logic,
                    'tables': tables, 'pairs': pairs})
    return out


def t24_table(stg_dim_table):
    """STG_DIM_X (vung dem cat lat) -> DIM_T24_X (PDTD_DTM). Quy tac cung cua skill."""
    return 'DIM_T24_' + stg_dim_table[len('STG_DIM_'):]


def parse_alias_literals(bc):
    """Literal chuoi trong muc 'Bang nguon & dieu kien Join' (alias map) cua SRS, theo tung section.

    -> ({section: {literal,...}}, [(section, dong_nghi_loi_go)]). Dong co so dau nhay le (nghi loi go trong SRS)
    khong duoc doc literal ma bao rieng. Bo literal khong co chu cai (vd '.', '\\s' cua regex).
    """
    path = os.path.join(ROOT, 'extract', 'srs_report', f'{bc}.md')
    out, odd, in_sec, section = {}, [], False, ''
    for ln in open(path, encoding='utf-8').read().splitlines():
        if ln.startswith('## '):
            in_sec = 'điều kiện Join' in ln
            section = ''
            continue
        if not in_sec:
            continue
        if ln.startswith('### '):
            section = ln[4:].strip()
            continue
        if ln.startswith('|'):
            if ln.count("'") % 2:
                odd.append((section, ln.strip()[:140]))
                continue
            out.setdefault(section, set()).update(
                x for x in re.findall(r"'([^']+)'", ln) if re.search(r'[A-Za-z\u00C0-\u1EF9]{2,}', x) and '(' not in x and ')' not in x)
    return out, odd


def norm_lit(s):
    """Chuan hoa literal de so khop: gop khoang trang, khong phan biet hoa thuong (giu dau tieng Viet)."""
    return ' '.join((s or '').split()).upper()
