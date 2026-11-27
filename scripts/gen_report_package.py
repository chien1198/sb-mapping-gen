#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Sinh package bao cao PDTD_DTM.PKG_REPORT (Oracle 19c, SQL table macro) tu mapping/BAOCAO/*.sql.

Nguon su that: mapping/BAOCAO/BC*.sql (do skill gen-report sinh). Package la SAN PHAM SINH RA,
khong sua tay file output - sua file .sql nguon roi chay lai:

    python3 scripts/gen_report_package.py

Quy tac bien doi moi file .sql -> 1 ham SQL macro (1-1, ten ham = ten file bo duoi .sql):
  - Comment dau file /* ... */ chuyen thanh comment PL/SQL ngay tren ham, CHI giu ghi chu nghiep vu: bo dong
    'Nguon thiet ke' (duong dan repo), bo hau to moi truong '(PDTD_DTM, Oracle 19c)', doi :p_date_* thanh p_date_*.
  - File output KHONG co header / ghi chu van hanh (nguon, cach sinh, cach goi, grant, kiem tra deploy).
  - Bo dau ';' cuoi cau lenh (macro tra ve van ban cau lenh, khong co ';').
  - Doi bind :p_date_from / :p_date_to thanh ten tham so ham p_date_from / p_date_to.
  - Giu nguyen moi thu con lai (ke ca ORDER BY cuoi; neu can thu tu dam bao thi ORDER BY o cau lenh goi).
  - Chuoi SQL nam trong q'[...]' (tu doi ky tu bao neu trong SQL co chuoi ket thuc literal);
    SQL dai hon ~30000 byte duoc cat theo dong thanh nhieu literal noi bang || (PL/SQL gioi han 32767 byte / literal).
Dau ra on dinh (khong co thoi gian/hash) de git diff chi hien bao cao nao thuc su doi.
"""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SRC_DIR = ROOT / "mapping" / "BAOCAO"
OUT_FILE = ROOT / "Scripts_Golive" / "create package report" / "CREATE_PACKAGE_REPORT_PDTD_DTM.sql"
SCHEMA = "PDTD_DTM"
PKG = "PKG_REPORT"
PARAMS = ("p_date_from", "p_date_to")
MAX_LITERAL_BYTES = 30000
DELIMS = [("[", "]"), ("{", "}"), ("(", ")"), ("<", ">"), ("~", "~"), ("#", "#")]
MAX_LINE_LEN = 2000
# Hau to moi truong trong tieu de bao cao ("(PDTD_DTM, Oracle 19c)", "(CLOS + RLOS, PDTD_DTM, Oracle 19c)", "(1 dong / ho so; PDTD_DTM, Oracle 19c)")
ENV_SUFFIX = re.compile(r"\s*\(PDTD_DTM, Oracle 19c\)|\s*[,;]\s*PDTD_DTM, Oracle 19c")


def code_only(sql):
    """Thay noi dung chuoi '...' va comment bang khoang trang (giu do dai) de kiem tra token."""
    out, i, n = [], 0, len(sql)
    while i < n:
        c = sql[i]
        if c == "'":
            j = i + 1
            while j < n:
                if sql[j] == "'":
                    if j + 1 < n and sql[j + 1] == "'":
                        j += 2
                        continue
                    break
                j += 1
            out.append(" " * (j - i + 1))
            i = j + 1
        elif sql.startswith("--", i):
            j = sql.find("\n", i)
            j = n if j == -1 else j
            out.append(" " * (j - i))
            i = j
        elif sql.startswith("/*", i):
            j = sql.find("*/", i + 2)
            j = n if j == -1 else j + 2
            out.append(" " * (j - i))
            i = j
        else:
            out.append(c)
            i += 1
    return "".join(out)


def report_sort_key(path):
    m = re.match(r"BC(\d+)_", path.name)
    return (int(m.group(1)) if m else 10**6, path.name)


def split_chunks(body):
    """Cat body theo dong thanh cac chunk <= MAX_LITERAL_BYTES (moi chunk ket thuc bang \\n tru chunk cuoi)."""
    chunks, cur, size = [], [], 0
    lines = body.split("\n")
    for idx, line in enumerate(lines):
        add = len(line.encode("utf-8")) + 1
        if cur and size + add > MAX_LITERAL_BYTES:
            chunks.append("\n".join(cur) + "\n")
            cur, size = [], 0
        cur.append(line)
        size += add
    chunks.append("\n".join(cur))
    return chunks


def parse_report(path):
    text = path.read_text(encoding="utf-8").replace("\r\n", "\n")
    m = re.match(r"\s*(/\*.*?\*/)", text, re.S)
    if not m:
        raise SystemExit(f"[LOI] {path.name}: khong thay comment dau file /* ... */")
    header = m.group(1)
    header = re.sub(r"^[ \t]*Nguon thiet ke:.*\n", "", header, flags=re.M)   # duong dan repo / skill: khong phai nghiep vu
    for p in PARAMS:
        header = header.replace(":" + p, p)
    header = ENV_SUFFIX.sub("", header)
    body = text[m.end():].strip()
    if not body.endswith(";"):
        raise SystemExit(f"[LOI] {path.name}: cau lenh khong ket thuc bang ';'")
    body = body[:-1].rstrip()

    code = code_only(body)
    if ";" in code:
        raise SystemExit(f"[LOI] {path.name}: con dau ';' ngoai chuoi/comment (file chua nhieu hon 1 cau lenh?)")
    binds = set(re.findall(r":[A-Za-z_]\w*", code))
    extra = binds - {":" + p for p in PARAMS}
    if extra:
        raise SystemExit(f"[LOI] {path.name}: bind la chua xu ly: {sorted(extra)}")
    uses = {p: (":" + p) in code for p in PARAMS}
    for p in PARAMS:
        body = body.replace(":" + p, p)

    if any(ln.strip() == "/" for ln in body.split("\n")):
        raise SystemExit(f"[LOI] {path.name}: co dong chi chua '/' (se ket thuc lenh trong SQL*Plus)")
    long_lines = [i + 1 for i, ln in enumerate(body.split("\n")) if len(ln) > MAX_LINE_LEN]
    if long_lines:
        print(f"[CANH BAO] {path.name}: dong qua dai (> {MAX_LINE_LEN} ky tu) tai {long_lines[:5]}", file=sys.stderr)

    delim = next(((o, c) for o, c in DELIMS if (c + "'") not in body), None)
    if delim is None:
        raise SystemExit(f"[LOI] {path.name}: khong chon duoc ky tu bao q'..' an toan")

    title_m = re.search(r"^\s*(BC\d+\s*-.*)$", header, re.M)
    title = title_m.group(1).strip() if title_m else path.stem
    return {
        "name": path.stem, "file": path.name, "header": header, "body": body, "uses": uses,
        "delim": delim, "has_amp": "&" in body, "title": title,
    }


def clob_expr(rep):
    o, c = rep["delim"]
    chunks = split_chunks(rep["body"])
    parts = []
    for k, ch in enumerate(chunks):
        pre = "\n" if k == 0 else ""
        suf = "\n" if k == len(chunks) - 1 else ""
        lit = f"q'{o}{pre}{ch}{suf}{c}'"
        parts.append(f"TO_CLOB({lit})" if k == 0 else lit)
    return "\n      || ".join(parts), len(chunks)


def build(reports):
    spec, body_parts, summary = [], [], []
    for r in reports:
        sig = f"{r['name']}(p_date_from DATE, p_date_to DATE)"
        spec.append(f"  -- {r['title']}\n  FUNCTION {sig} RETURN CLOB SQL_MACRO;\n")
        expr, nchunk = clob_expr(r)
        hdr = "\n".join("  " + ln if ln.strip() else ln for ln in r["header"].split("\n"))
        body_parts.append(
            f"{hdr}\n"
            f"  FUNCTION {sig}\n"
            f"    RETURN CLOB SQL_MACRO IS\n"
            f"  BEGIN\n"
            f"    RETURN {expr};\n"
            f"  END {r['name']};\n")
        summary.append((r["name"], len(r["body"].encode("utf-8")), nchunk, r["delim"][0], r["uses"]))

    define_off = "SET DEFINE OFF\n" if any(r["has_amp"] for r in reports) else ""
    out = f"""{define_off}CREATE OR REPLACE PACKAGE {SCHEMA}.{PKG} AS
{chr(10).join(spec)}END {PKG};
/

CREATE OR REPLACE PACKAGE BODY {SCHEMA}.{PKG} AS

{chr(10).join(body_parts)}
END {PKG};
/
"""
    return out, summary


def main():
    files = sorted(SRC_DIR.glob("BC*.sql"), key=report_sort_key)
    if not files:
        raise SystemExit(f"[LOI] khong co file BC*.sql trong {SRC_DIR}")
    reports = [parse_report(f) for f in files]
    names = [r["name"] for r in reports]
    if len(set(names)) != len(names):
        raise SystemExit("[LOI] ten ham trung nhau")
    too_long = [n for n in names if len(n) > 128]
    if too_long:
        raise SystemExit(f"[LOI] ten ham qua dai: {too_long}")

    out, summary = build(reports)
    OUT_FILE.parent.mkdir(parents=True, exist_ok=True)
    OUT_FILE.write_text(out, encoding="utf-8", newline="\n")

    print(f"Da ghi {OUT_FILE.relative_to(ROOT)} ({len(out.encode('utf-8'))} byte, {len(reports)} ham)")
    for name, nbytes, nchunk, d, uses in summary:
        unused = [p for p, u in uses.items() if not u]
        extra = f"  [khong dung: {', '.join(unused)}]" if unused else ""
        print(f"  {name:<28} {nbytes:>6} byte  {nchunk} literal  q'{d}'{extra}")


if __name__ == "__main__":
    main()
