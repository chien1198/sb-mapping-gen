#!/usr/bin/env python3
"""Phase 1 cua skill gen-report: ban do truong bao cao (SRS) -> cot PDTD_DTM, dung lineage tu LLD.

  python3 scripts/build_field_map.py BC1

In markdown ra stdout (khong tao file). Trang thai moi truong:
  auto        = co it nhat 1 cot PDTD_DTM co lineage ve DUNG cot nguon SRS ghi
  candidate   = chi khop duoc BANG nguon (can chon cot)
  unresolved  = khong khop (truong phai sinh / nguon khong nam trong lineage)
Exit code 0 = khong co gi can chot, 2 = con candidate/unresolved/nhom 1-N chua co quyet dinh.
"""
import os
import difflib
import re
import sys
from collections import defaultdict

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import gen_report_common as C  # noqa: E402


def family(srs_rows):
    n = sum(1 for r in srs_rows for t in r['tables'] if 'RLOS' in t)
    m = sum(1 for r in srs_rows for t in r['tables'] if 'CLOS' in t)
    return 'RLOS' if n >= m else 'CLOS'


def rank_key(cand, names, fam):
    """Xep hang ung vien 'TABLE.COL': trung ten truoc, giong ten, roi bang chinh cua ho."""
    table, col = cand.split('.', 1)
    drv = 0 if table in (f'FCT_{fam}_APPLICATION', f'DIM_{fam}_APPLICATION') else 1   # cot cap ho so uu tien
    eq = 0 if C.norm(col) in names else 1
    sim = -max(difflib.SequenceMatcher(None, C.norm(col), n).ratio() for n in names)
    wrong = 0 if (fam in table or 'T24' in table or table == 'DIM_LOS_COMPANY') else 1
    agg = 1 if table.startswith('AGG_') else 0
    app = 0 if table.endswith('_APPLICATION') else 1
    return (drv, eq, sim, agg, wrong, app, table)


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)
    bc = sys.argv[1].upper()
    msg = C.ensure_lineage()
    srs = C.parse_srs(bc)
    fam = family(srs)
    lin = C.load_lineage()
    cols = C.pdtd_columns()

    by_exact, by_tbl = defaultdict(set), defaultdict(set)
    for r in lin:
        if r['los_kind'] == 'source':
            k = (r['los_table'], C.norm(r['los_column']))
            v = f"{r['pdtd_table']}.{r['pdtd_column']}"
            by_exact[k].add(v)
            by_tbl[r['los_table']].add(v)

    rows = []
    for s in srs:
        exact, tbl = set(), set()
        for t, c in s['pairs']:
            if t.startswith('STG_DIM_'):            # vung dem cat lat -> DIM_T24_* (PDTD_DTM)
                dt = C.t24_table(t)
                if dt in cols:
                    exact |= {f'{dt}.{x}' for x in cols[dt] if C.norm(x) == C.norm(c)}
                continue
            exact |= by_exact.get((t, C.norm(c)), set())
        for t in s['tables']:
            if t.startswith('STG_DIM_'):
                dt = C.t24_table(t)
                if dt in cols:
                    tbl |= {f'{dt}.{x}' for x in cols[dt]}
            else:
                tbl |= by_tbl.get(t, set())
        names = {C.norm(s['field'])} | {C.norm(c) for _, c in s['pairs']}
        for t in (f'DIM_{fam}_APPLICATION', f'FCT_{fam}_APPLICATION'):   # cot trung ten tren bang ho so
            exact |= {f'{t}.{x}' for x in cols.get(t, ()) if C.norm(x) in names}
        if exact:
            status, cand = 'auto', exact
        elif tbl:
            status, cand = 'candidate', tbl
        else:
            status, cand = 'unresolved', set()
        cand = sorted(cand, key=lambda x: rank_key(x, names, fam))
        rows.append((s, status, cand))

    cnt = defaultdict(int)
    for _, st, _ in rows:
        cnt[st] += 1

    # --- nhom 1-N: bang FCT khac driving co PK khac -> nhieu dong / ho so
    app_tbl = f'FCT_{fam}_APPLICATION'
    drv_pk = C.pdtd_pk(app_tbl)
    multi = {}
    for s, st, cand in rows:
        if st != 'auto':
            continue
        for x in cand[:1]:                      # chi xet ung vien xep hang 1
            t = x.split('.')[0]
            if t.startswith('FCT_') and t != app_tbl and C.pdtd_pk(t) and C.pdtd_pk(t) != drv_pk:
                multi.setdefault(t, set()).add(s['field'])

    dec_path = os.path.join(C.DECISIONS_DIR, f'{bc}.md')
    dec = open(dec_path, encoding='utf-8').read() if os.path.exists(dec_path) else ''

    print(f'# {bc} - ban do truong (SRS -> PDTD_DTM)  [ho {fam}]')
    print(f'Lineage: {msg}')
    print(f"Tong {len(rows)} truong: auto={cnt['auto']}, candidate={cnt['candidate']}, unresolved={cnt['unresolved']}")
    print(f"Quyet dinh da chot: {dec_path if dec else '(chua co file)'}\n")
    print('| # | Truong | Trang thai | Ung vien (xep hang) | Nguon SRS |')
    print('|---|---|---|---|---|')
    for n, (s, st, cand) in enumerate(rows, 1):
        src = ', '.join(sorted(f'{t}.{c}' for t, c in s['pairs'])) or ', '.join(sorted(s['tables'])) or re.sub(r'\s+', ' ', s['logic'])[:60]
        print(f"| {n} | {s['field']} | {st} | {'; '.join(cand[:3]) or '-'} | {src} |")

    print('\n## Nhom 1-N (nhieu dong / ho so) can chot grain')
    need_stop = cnt['candidate'] > 0 or cnt['unresolved'] > 0
    if not multi:
        print('(khong co)')
    for t, fs in sorted(multi.items()):
        decided = bool(dec) and t in dec
        print(f"- {t}: {', '.join(sorted(fs))} -> {'DA CHOT (xem decisions)' if decided else 'CHUA CHOT'}")
        if not decided:
            need_stop = True
    print('\n## Can xu ly truoc Phase 2' if need_stop else '\n## Khong can dung - sang Phase 2')
    if cnt['candidate']:
        print('- candidate: chon cot dua tren logic SRS + etl_logic trong lld/pdtd_dtm (chi hoi nguoi dung neu van mo ho)')
    if cnt['unresolved']:
        print('- unresolved: truong phai sinh / nguon ngoai lineage - doc SRS va LLD de xac dinh, hoi nguoi dung neu van mo ho')
    sys.exit(2 if need_stop else 0)


if __name__ == '__main__':
    main()
