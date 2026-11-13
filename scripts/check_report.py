#!/usr/bin/env python3
"""Phase 3 cua skill gen-report: kiem tra CO HOC cau lenh bao cao so voi SRS + lineage LLD.

  python3 scripts/check_report.py BC1 mapping/BAOCAO/BC1_RLOS_APPLICATION.sql [ten_muc_SRS]
  (ten_muc_SRS, vd 'CLOS': chi doi chieu muc SRS do - dung khi 1 bao cao gom nhieu cau lenh rieng)

In markdown ra stdout (khong tao file). Cac kiem tra:
  1. Phu cot: truong SRS <-> cot SELECT cuoi cua cau lenh (thieu / thua)
  2. Moi alias.COLUMN deu ton tai (bang PDTD_DTM theo lld/pdtd_dtm, hoac cot do CTE tao ra)
  3. Khong tham chieu STG_* (vung dem cat lat; phai di qua PDTD_DTM.DIM_*)
  4. Chuoi lineage: cot gen dung -> nguon SBLOS2 -> so voi nguon SRS ghi cho truong do
     exact | table (chi khop bang) | mismatch | no-trace | no-ref | literal-ok | literal-diff
  6. Literal chuoi: literal trong logic SRS (va dieu kien alias map) co mat trong cau lenh khong
  Muc 1 con kiem THU TU cot dau ra so voi SRS (theo tung nhanh UNION).
Phan NGU NGHIA (dung bang, dung dieu kien loc, grain) khong tu dong hoa duoc -> doc tay, xem
references/crosscheck-method.md.
Exit code 1 neu co loi co hoc (muc 1-3, gom ca thu tu cot), 0 neu khong. Muc 4-6 la thong tin de doc tay.
"""
import os
import re
import sys
from collections import defaultdict

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import gen_report_common as C  # noqa: E402

SCHEMAS = {'PDTD_DTM', 'SB_DWH', 'STG_DTM', 'SBLOS2'}
KW = {'ON', 'LEFT', 'RIGHT', 'INNER', 'JOIN', 'WHERE', 'GROUP', 'ORDER', 'CROSS', 'FULL', 'UNION',
      'USING', 'SELECT', 'AND', 'OR', 'WITH', 'FETCH', 'CONNECT', 'START', 'HAVING', 'OUTER', 'NATURAL'}
REF_RE = re.compile(r'\b([A-Za-z_]\w*)\.([A-Za-z_]\w*)\b')


LITS = []   # gia tri cac literal chuoi, thay trong van ban bang 'placeholder' '@Ln@' de khong lam roi ngoac/dau phay


def clean(sql):
    sql = re.sub(r'/\*.*?\*/', lambda m: ' ' * len(m.group()), sql, flags=re.S)
    sql = re.sub(r'--[^\n]*', lambda m: ' ' * len(m.group()), sql)
    LITS.clear()

    def _lit(m):
        LITS.append(m.group(0)[m.group(0).index("'") + 1:-1].replace("''", "'"))
        return "'@L%d@'" % (len(LITS) - 1)
    return re.sub(r"N?'(?:[^']|'')*'", _lit, sql)


def restore(t):
    """Tra literal that vao van ban da 'clean'."""
    return re.sub(r"'@L(\d+)@'", lambda m: "'" + LITS[int(m.group(1))].replace("'", "''") + "'", t)


def lits_in(t):
    return [LITS[int(i)] for i in re.findall(r"'@L(\d+)@'", t)]


def mask(s):
    out, d = [], 0
    for ch in s:
        if ch == '(':
            out.append('(')
            d += 1
        elif ch == ')':
            d -= 1
            out.append(')')
        else:
            out.append(ch if d == 0 else ' ')
    return ''.join(out)


def match_paren(s, i):
    d = 0
    for j in range(i, len(s)):
        if s[j] == '(':
            d += 1
        elif s[j] == ')':
            d -= 1
            if d == 0:
                return j
    return len(s) - 1


def select_items(seg):
    m = mask(seg)
    sel = [x.start() for x in re.finditer(r'\bSELECT\b', m)]
    if not sel:
        return []
    s = sel[-1]
    fm = re.search(r'\bFROM\b', m[s:])
    e = s + fm.start() if fm else len(seg)
    lst, lm = seg[s + 6:e], m[s + 6:e]
    parts, cur = [], 0
    for i, ch in enumerate(lm):
        if ch == ',':
            parts.append(lst[cur:i])
            cur = i + 1
    parts.append(lst[cur:])
    out = []
    for p in parts:
        t = re.sub(r'^\s*DISTINCT\s+', '', p.strip(), flags=re.I)
        if not t:
            continue
        am = re.search(r'\bAS\s+"?(\w+)"?\s*$', t, re.I | re.S)
        if am:
            alias = am.group(1).upper()
        elif t.endswith('*'):
            alias = '*'
        else:
            dm = re.search(r'(\w+)\s*$', t)
            alias = dm.group(1).upper() if dm else '?'
        out.append((alias, t))
    return out


def alias_map(seg):
    amap = {}
    for tb, al in re.findall(r'\b(?:FROM|JOIN)\s+([\w\.]+)\s+(?:AS\s+)?(\w+)?', seg, re.I):
        t = tb.split('.')[-1].upper()
        a = al.upper() if al and al.upper() not in KW else t
        amap[a] = t
    return amap


def split_query(sql):
    """-> dict ten_segment -> {items, aliases, text}; '__main__' la SELECT cuoi."""
    c = clean(sql)
    m = mask(c)
    sel = [x.start() for x in re.finditer(r'\bSELECT\b', m)]
    main_start = sel[0] if sel else 0     # SELECT dau tien o muc ngoai cung (CTE nam trong ngoac nen bi che)
    segs = {}
    for cm in re.finditer(r'\b(\w+)\s+AS\s*\(', m[:main_start]):
        op = cm.end() - 1
        cl = match_paren(c, op)
        body = c[op + 1:cl]
        segs[cm.group(1).upper()] = {'items': select_items(body), 'aliases': alias_map(body), 'text': body}
    main, mm = c[main_start:], m[main_start:]
    cuts = [0] + [x.end() for x in re.finditer(r'\bUNION\s+(?:ALL\s+)?', mm)] + [len(main)]
    for i in range(len(cuts) - 1):                     # moi nhanh UNION la 1 segment rieng (alias co the tai su dung)
        end = cuts[i + 1]
        if i + 1 < len(cuts) - 1:
            end = [x.start() for x in re.finditer(r'\bUNION\s+(?:ALL\s+)?', mm)][i]
        part = main[cuts[i]:end]
        segs['__MAIN__' if i == 0 else f'__MAIN_{i + 1}__'] = {'items': select_items(part), 'aliases': alias_map(part), 'text': part}
    return segs, c


def main():
    if len(sys.argv) < 3:
        print(__doc__)
        sys.exit(1)
    bc, sqlpath = sys.argv[1].upper(), sys.argv[2]
    sql = open(sqlpath, encoding='utf-8').read()
    srs = C.parse_srs(bc)
    if len(sys.argv) > 3:      # chi doi chieu 1 muc SRS (cau lenh rieng cho tung nguon)
        srs = [x for x in srs if x['section'].lower().startswith(sys.argv[3].lower())]   # khop dau ten muc
    cols = C.pdtd_columns()
    lin = C.load_lineage()
    segs, c = split_query(sql)
    errors = 0

    # lineage index
    lsrc = defaultdict(set)
    for r in lin:
        if r['los_kind'] == 'source':
            lsrc[(r['pdtd_table'], r['pdtd_column'].upper())].add((r['los_table'], C.norm(r['los_column'])))

    print(f'# {bc} - kiem tra co hoc: {sqlpath}')
    print('Lineage:', C.ensure_lineage(), '\n')

    # 1. phu cot - moi nhanh UNION doi chieu voi 1 muc (section) cua SRS; mot nhanh duy nhat doi chieu toan bo SRS
    branches = [k for k in segs if k.startswith('__MAIN')]
    sections = []
    for s in srs:
        if s['section'] not in sections:
            sections.append(s['section'])
    if len(branches) > 1 and len(branches) != len(sections):
        print(f'CANH BAO: {len(branches)} nhanh UNION nhung SRS co {len(sections)} muc - doi chieu moi nhanh voi toan bo SRS\n')
        sections = [None] * len(branches)
    elif len(branches) == 1:
        sections = [None]
    units = []     # (nhan, ten_segment, {FIELD: srs_row}, {ALIAS: expr})
    print('## 1. Phu cot')
    for br, sec in zip(branches, sections):
        rows = [s for s in srs if sec is None or s['section'] == sec]
        srs_map = {}
        for s in rows:
            srs_map.setdefault(s['field'].upper(), s)
        gen_items = {a: e for a, e in segs[br]['items']}
        label = (sec or '').strip() or ('nhanh ' + br if len(branches) > 1 else '')
        units.append((label, br, srs_map, gen_items))
        miss = [f for f in srs_map if f not in gen_items]
        extra_all = [a for a in gen_items if a not in srs_map]
        pad = [a for a in extra_all if re.match(r'^\s*(?:CAST\s*\(\s*)?NULL\b', gen_items[a], re.I)]   # cot dem NULL cho UNION
        extra = [a for a in extra_all if a not in pad]
        print(f"{'[' + label + '] ' if label else ''}SRS={len(srs_map)} truong, gen={len(gen_items)} cot")
        print('- Thieu trong gen:', ', '.join(miss) or '(khong)')
        print('- Thua so voi SRS:', ', '.join(extra) or '(khong)')
        if pad:
            print('- Cot dem NULL de UNION khop cot (thong tin, khong tinh la loi):', ', '.join(pad))
        errors += len(miss) + len(extra)
        srs_order = [f for f in srs_map if f in gen_items]
        gen_order = [a for a in gen_items if a in srs_map]
        if srs_order != gen_order:
            k = next(i for i, (x, y) in enumerate(zip(srs_order, gen_order)) if x != y)
            print(f'- THU TU cot lech SRS tai vi tri {k + 1}: SRS={srs_order[k]}, gen={gen_order[k]}')
            errors += 1
        else:
            print('- Thu tu cot: khop SRS')

    # 2. alias.COLUMN ton tai
    print('\n## 2. Tham chieu cot khong ton tai')
    bad = []
    for name, sg in segs.items():
        outs = {a for a, _ in sg['items']}
        for al, col in REF_RE.findall(sg['text']):
            if al.upper() in SCHEMAS:
                continue
            t = sg['aliases'].get(al.upper())
            if t is None:
                continue
            col = col.upper()
            if t in cols:
                if col not in cols[t]:
                    bad.append((name, al, t, col))
            elif t in segs:
                tgt = segs[t]
                allowed = {a for a, _ in tgt['items']}
                if '*' in allowed:
                    for tt in tgt['aliases'].values():
                        allowed |= cols.get(tt, set())
                if col not in allowed:
                    bad.append((name, al, f'CTE {t}', col))
    for b in bad:
        print(f'- [{b[0]}] {b[1]}.{b[3]} -> {b[2]} khong co cot {b[3]}')
    if not bad:
        print('(khong co)')
    errors += len(bad)

    # 3. STG_
    print('\n## 3. Tham chieu STG_* (phai di qua PDTD_DTM.DIM_*)')
    stg = sorted(set(re.findall(r'\bSTG_[A-Z0-9_]+', c.upper())))
    print('- ' + ', '.join(stg) if stg else '(khong co)')
    errors += len(stg)

    # 4. chuoi lineage
    def resolve(al, col, seg, depth=0):
        t = segs[seg]['aliases'].get(al.upper())
        if t is None:
            return set()
        if t in cols:
            return {(t, col)}
        if t in segs and depth < 5:
            for a, expr in segs[t]['items']:
                if a == col:
                    return refs(expr, t, depth + 1)
            for a2, tt in segs[t]['aliases'].items():
                if tt in cols and col in cols[tt]:
                    return {(tt, col)}
                if tt in segs:
                    r = resolve(a2, col, t, depth + 1)
                    if r:
                        return r
        return set()

    def refs(expr, seg, depth=0):
        out = set()
        for al, col in REF_RE.findall(expr):
            if al.upper() not in SCHEMAS:
                out |= resolve(al, col.upper(), seg, depth)
        return out

    res = defaultdict(list)
    todo = [(label + ': ' if label else '', br, f, s, gen_items[f])
            for label, br, srs_map, gen_items in units for f, s in srs_map.items() if f in gen_items]
    for lab, br, f, s, expr in todo:
        rf = refs(expr, br)
        pairs = {(t, C.norm(cn)) for t, cn in s['pairs']}
        tabs = set(s['tables'])
        exp_t24 = {C.t24_table(t): [cn for tt, cn in s['pairs'] if tt == t] for t in tabs if t.startswith('STG_DIM_')}
        status = None
        srs_lits = {C.norm_lit(x) for x in re.findall(r"'([^']+)'", s['logic'])}
        raw = restore(re.sub(r'\s+AS\s+"?\w+"?\s*$', '', expr.strip(), flags=re.I)).strip()
        lm = re.fullmatch(r"'((?:[^']|'')*)'", raw)
        if not rf and lm:
            status = 'literal-ok' if C.norm_lit(lm.group(1).replace("''", "'")) in srs_lits else 'literal-diff'
        elif not rf:
            status = 'no-ref'
        else:
            for t, cn in rf:
                if lsrc.get((t, cn), set()) & pairs or (t in exp_t24 and C.norm(cn) in {C.norm(x) for x in exp_t24[t]}):
                    status = 'exact'
                    break
            if not status:
                for t, cn in rf:
                    srcs = {x[0] for x in lsrc.get((t, cn), set())}
                    if srcs & tabs or t in exp_t24:
                        status = 'table'
                        break
            if not status:
                status = 'mismatch' if any(lsrc.get(x) for x in rf) else 'no-trace'
        res[status].append((lab + f, sorted(rf), [f'{t}.{c}' for t, c in sorted(s['pairs'])] or sorted(tabs), sorted({s2 for x in rf for s2 in lsrc.get(x, set())})[:3]))
    n = sum(len(v) for v in res.values())
    print('\n## 4. Chuoi lineage (cot gen -> nguon SBLOS2 -> nguon SRS)')
    print(f"{n} truong: " + ', '.join(f'{k}={len(res[k])}' for k in ('exact', 'table', 'mismatch', 'no-trace', 'no-ref', 'literal-ok', 'literal-diff') if k in res))
    notes = {'table': 'chi khop bang nguon, cot khac/phai sinh - doc tay',
             'mismatch': 'lineage ve nguon KHAC nguon SRS ghi - doc tay (co the la lech that)',
             'no-trace': 'cot gen khong co lineage ve SBLOS2 (tinh toan/khoa SK) - doc tay',
             'no-ref': 'bieu thuc khong tham chieu cot PDTD_DTM (phai sinh thuan, khong phai literal) - doc tay',
             'literal-diff': 'literal khac gia tri SRS ghi - kiem tra'}
    for k in ('literal-diff', 'mismatch', 'table', 'no-trace', 'no-ref'):
        if not res.get(k):
            continue
        print(f'\n### {k}: {notes[k]}')
        for f, rf, p, ls in res[k]:
            print(f"- {f}: gen={', '.join(f'{t}.{x}' for t, x in rf) or '-'} | SRS={', '.join(p) or '-'} | lineage={', '.join(f'{t}.{x}' for t, x in ls) or '-'}")

    # 5. LISTAGG tran
    ov = len(re.findall(r'LISTAGG', c, re.I)) - len(re.findall(r'ON\s+OVERFLOW', c, re.I))
    print(f"\n## 5. LISTAGG khong co ON OVERFLOW: {max(ov, 0)} cho (nen them TRUNCATE neu giu LISTAGG)")

    # 6. literal chuoi: SRS vs cau lenh (thong tin, khong tinh la loi)
    def lits_of(expr, seg, depth=0):
        out = set(lits_in(expr))
        for al, col in REF_RE.findall(expr):
            t = segs[seg]['aliases'].get(al.upper())
            if t in segs and depth < 4:
                for a, e in segs[t]['items']:
                    if a == col.upper():
                        out |= lits_of(e, t, depth + 1)
        return out

    alias_lits, odd_lines = C.parse_alias_literals(bc)
    alias_sections = list(alias_lits)
    print('\n## 6. Literal chuoi: SRS vs cau lenh (thong tin - doc tay, khong tinh la loi)')
    ctes_text = ' '.join(sg['text'] for k, sg in segs.items() if not k.startswith('__MAIN'))
    any_out = False
    for sec, ln in odd_lines:
        any_out = True
        print(f"- SRS co dong dieu kien voi so dau nhay le (nghi loi go, khong doc literal) [{sec}]: {ln}")
    for ui, (label, br, srs_map, gen_items) in enumerate(units):
        pool = {C.norm_lit(x) for x in lits_in(segs[br]['text'] + ' ' + ctes_text)}
        tag = f'[{label}] ' if label else ''
        # (a) literal trong logic tung truong - chi xet truong co logic phai sinh o tang bao cao (chuoi gen co literal)
        for f, s in srs_map.items():
            if f not in gen_items:
                continue
            g = lits_of(gen_items[f], br)
            if not g:
                continue
            if s['logic'].count("'") % 2:
                any_out = True
                print(f"- {tag}{f}: logic SRS co so dau nhay le (nghi loi go) - khong doi chieu literal")
                continue
            srs_l = [x for x in re.findall(r"'([^']+)'", s['logic'])]
            only_srs = sorted({x for x in srs_l if C.norm_lit(x) not in {C.norm_lit(y) for y in g}})
            only_gen = sorted({y for y in g if re.search(r'[A-Za-zÀ-ỹ]{3,}', y) and C.norm_lit(y) not in {C.norm_lit(x) for x in srs_l}})
            if only_srs or only_gen:
                any_out = True
                print(f"- {tag}{f}: SRS co ma gen khong co={only_srs or '-'} | gen co ma SRS khong co={only_gen or '-'}")
        # (b) literal trong dieu kien alias map cua SRS ma cau lenh khong co (co the nam o LLD)
        if len(units) == len(alias_sections) and len(units) > 1:
            al = alias_lits[alias_sections[ui]]
        else:
            al = set().union(*alias_lits.values()) if alias_lits else set()
        miss_l = sorted(x for x in al if C.norm_lit(x) not in pool)
        if miss_l:
            any_out = True
            print(f"- {tag}Dieu kien alias map (SRS) khong thay trong cau lenh (co the da nam o LLD): {miss_l}")
    if not any_out:
        print('(khong co)')

    dec = os.path.join(C.DECISIONS_DIR, f'{bc}.md')
    print(f"\n## Quyet dinh da chot ({dec if os.path.exists(dec) else 'chua co file'})")
    if os.path.exists(dec):
        print(open(dec, encoding='utf-8').read())
    sys.exit(1 if errors else 0)


if __name__ == '__main__':
    main()
