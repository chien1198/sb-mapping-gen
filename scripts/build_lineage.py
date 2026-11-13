#!/usr/bin/env python3
"""Sinh lineage chuoi PDTD_DTM <- STG_DTM <- SB_DWH <- STG_LOS (SBLOS2) tu cac file LLD.

Nguon duy nhat: lld/pdtd_dtm/*.csv, lld/stg_dtm/*.csv, lld/sb_dwh/*.csv (11 cot, xem skill design-lld).
Khong doc HLD, khong doc lld/BC*.csv.

Output (output/lineage/):
  lineage_chain.csv       1 dong / (cot PDTD_DTM x nguon hop1 x nguon hop2/hop3)
  lineage_chain.json      cung noi dung, de skill doc
  lineage_manifest.json   sha256 tung file LLD + so dong -> dung cho --check

Cach dung:
  python3 scripts/build_lineage.py            # sinh lai
  python3 scripts/build_lineage.py --check    # exit 0 = con moi, exit 1 = LLD da doi (can sinh lai)
"""
import csv
import glob
import hashlib
import json
import os
import re
import sys
from datetime import datetime

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LLD = os.path.join(ROOT, 'lld')
OUT = os.path.join(ROOT, 'output', 'lineage')
LAYERS = [('pdtd_dtm', 'PDTD_DTM_'), ('stg_dtm', 'STG_DTM_'), ('sb_dwh', 'SB_DWH_')]

TOKEN = re.compile(r'\b([A-Z][A-Z0-9_]{2,})\.([A-Z][A-Z0-9_]*)\b')
# bang nguon thuc te (STG_LOS / SBLOS2); alias va bang noi bo bi loai boi viec doi chieu voi tap bang da biet
LOS_TABLE = re.compile(r'^(NG_SB_|SB_[CR]LOS_|[CR]LOS_REF_|Q_[CR]LOS_|MAS_)')
LOGIC_MAX = 800


def files(layer, prefix):
    return sorted(glob.glob(os.path.join(LLD, layer, prefix + '*.csv')))


def load_layer(layer, prefix):
    """-> {(table, column): [row, ...]} (mot cot co the xuat hien nhieu lan, vd nhanh UNION)."""
    idx = {}
    for f in files(layer, prefix):
        with open(f, newline='', encoding='utf-8-sig') as fh:
            reader = csv.DictReader(fh)
            if 'target_table' not in (reader.fieldnames or []):
                print(f'CANH BAO: {os.path.basename(f)} khong co cot target_table (sai header/BOM?) - file bi bo qua', file=sys.stderr)
            for r in reader:
                if not r.get('target_table'):
                    continue
                idx.setdefault((r['target_table'], r['target_column']), []).append(r)
    return idx


def manifest():
    m = {'layers': {}}
    for layer, prefix in LAYERS:
        h = hashlib.sha256()
        n = 0
        for f in files(layer, prefix):
            h.update(os.path.basename(f).encode())
            with open(f, 'rb') as fh:
                h.update(fh.read())
            n += 1
        m['layers'][layer] = {'files': n, 'sha256': h.hexdigest()}
    return m


def sources(row, known_tables):
    """Tap (bang, cot) ma etl_logic / source_* cua 1 dong tham chieu toi. Chi giu bang da biet."""
    found = []
    for t, c in TOKEN.findall(row.get('etl_logic') or ''):
        if t in known_tables or LOS_TABLE.match(t):
            found.append((t, c))
    st, sc = (row.get('source_table') or '').strip(), (row.get('source_column') or '').strip()
    if st and sc and (st in known_tables or LOS_TABLE.match(st)):
        found.append((st, sc))
    seen, out = set(), []
    for x in found:
        if x not in seen:
            seen.add(x)
            out.append(x)
    return out


def short(s):
    s = ' '.join((s or '').split())
    return s if len(s) <= LOGIC_MAX else s[:LOGIC_MAX] + '...'


def build():
    pd = load_layer(*LAYERS[0])
    stg = load_layer(*LAYERS[1])
    sb = load_layer(*LAYERS[2])
    pd_tables = {t for t, _ in pd}
    stg_tables = {t for t, _ in stg}
    sb_tables = {t for t, _ in sb}
    known = pd_tables | stg_tables | sb_tables

    rows = []
    for (pt, pc), plist in sorted(pd.items()):
        for prow in plist:
            hop1 = []
            for t, c in sources(prow, known):
                if t.endswith('_PREV'):
                    kind = 'prev'          # carry-forward tu chinh bang (ngay truoc)
                elif t in stg_tables:
                    kind = 'stg'
                elif t in pd_tables:
                    kind = 'pdtd_ref'      # bang PDTD_DTM khac (join DIM/REF)
                else:
                    kind = 'other'
                hop1.append((kind, t, c))
            if not hop1:
                hop1 = [('none', '', '')]
            for kind, t1, c1 in hop1:
                base = {
                    'pdtd_table': pt, 'pdtd_column': pc,
                    'pdtd_logic_type': prow.get('etl_logic_type', ''),
                    'pdtd_logic': short(prow.get('etl_logic')),
                    'hop1_kind': kind, 'stg_table': t1, 'stg_column': c1,
                }
                if kind != 'stg':
                    rows.append({**base, 'stg_logic': '', 'sb_table': '', 'sb_column': '',
                                 'sb_logic_type': '', 'sb_logic': '', 'los_kind': 'none',
                                 'los_table': '', 'los_column': ''})
                    continue
                # hop 2: STG_DTM -> SB_DWH
                srows = stg.get((t1, c1), [])
                sb_refs = []
                for srow in srows:
                    for t2, c2 in sources(srow, known):
                        sb_refs.append((t2, c2, srow))
                if not sb_refs:  # STG_DTM khong khai bao -> gia dinh cung ten voi SB_DWH
                    sb_refs = [(t1[4:] if t1.startswith('STG_') else t1, c1, None)]
                for t2, c2, srow in sb_refs:
                    entry = {**base, 'stg_logic': short(srow.get('etl_logic')) if srow else '(STG_DTM khong khai bao, gia dinh cung ten)',
                             'sb_table': t2, 'sb_column': c2}
                    brows = sb.get((t2, c2), [])
                    if not brows:
                        rows.append({**entry, 'sb_logic_type': '', 'sb_logic': '', 'los_kind': 'none',
                                     'los_table': '', 'los_column': ''})
                        continue
                    for brow in brows:
                        lsrc = sources(brow, known) or [('', '')]
                        for t3, c3 in lsrc:
                            if not t3:
                                lk = 'none'
                            elif t3 in sb_tables:
                                lk = 'sb_ref'    # bang SB_DWH khac (join DIM)
                            else:
                                lk = 'source'
                            rows.append({**entry, 'sb_logic_type': brow.get('etl_logic_type', ''),
                                         'sb_logic': short(brow.get('etl_logic')),
                                         'los_kind': lk, 'los_table': t3, 'los_column': c3})
    return rows


def main():
    check = '--check' in sys.argv
    cur = manifest()
    mpath = os.path.join(OUT, 'lineage_manifest.json')
    if check:
        if not os.path.exists(mpath):
            print('STALE: chua co lineage, can sinh (chay build_lineage.py)')
            sys.exit(1)
        old = json.load(open(mpath))
        diff = [k for k, v in cur['layers'].items() if old['layers'].get(k, {}).get('sha256') != v['sha256']]
        if diff:
            print('STALE: LLD da doi o layer', ', '.join(diff), '-> chay lai build_lineage.py')
            sys.exit(1)
        print('FRESH: lineage khop LLD hien tai (sinh luc', old.get('generated_at'), ')')
        sys.exit(0)

    rows = build()
    os.makedirs(OUT, exist_ok=True)
    cols = ['pdtd_table', 'pdtd_column', 'pdtd_logic_type', 'pdtd_logic', 'hop1_kind', 'stg_table', 'stg_column',
            'stg_logic', 'sb_table', 'sb_column', 'sb_logic_type', 'sb_logic', 'los_kind', 'los_table', 'los_column']
    with open(os.path.join(OUT, 'lineage_chain.csv'), 'w', newline='', encoding='utf-8') as fh:
        w = csv.DictWriter(fh, fieldnames=cols)
        w.writeheader()
        w.writerows(rows)
    with open(os.path.join(OUT, 'lineage_chain.json'), 'w', encoding='utf-8') as fh:
        json.dump(rows, fh, ensure_ascii=False)
    cur['generated_at'] = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    cur['rows'] = len(rows)
    cur['pdtd_columns'] = len({(r['pdtd_table'], r['pdtd_column']) for r in rows})
    with open(mpath, 'w', encoding='utf-8') as fh:
        json.dump(cur, fh, ensure_ascii=False, indent=2)
    print('OK:', cur['rows'], 'dong,', cur['pdtd_columns'], 'cot PDTD_DTM ->', OUT)


if __name__ == '__main__':
    main()
