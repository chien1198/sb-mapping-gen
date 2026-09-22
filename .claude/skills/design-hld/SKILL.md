---
name: design-hld
description: Design the HLD (High-Level Design) table structure for one DIM/FCT/REF table in the CLOS/RLOS-split SB_DWH and PDTD_DTM layers — data lineage diagram plus full column design. Use when the user asks to design/gen HLD, thiết kế HLD, or design the detailed column structure for a table from the split proposal in output/Table_Split_Proposal_CLOS_RLOS.md.
---

# Design HLD (High-Level Design) table structure

Produces the detailed table design (data lineage + column-by-column structure)
for tables that came out of the CLOS/RLOS table-split decision recorded in
`output/Table_Split_Proposal_CLOS_RLOS.md`. This is a downstream step from that
proposal: the proposal decided **which tables get split/merged and why**; this
skill decides **exactly what columns each resulting table has**, reasoned from
first principles (DIM vs FACT design method below), not by blindly copying the
old merged table's column list.

## When to use

User asks to design/generate HLD for a specific table (by name, e.g.
"design HLD cho DIM_LOS_ORG_UNIT", "gen HLD DIM_CLOS_APPLICATION"), or to
continue the HLD design work table-by-table from `output/Table_Split_Proposal_CLOS_RLOS.md`.

## Operating mode — one table at a time, user-paced

**Never bulk-generate the whole table list in one shot.** The user controls
the pace explicitly: they name the next table to design (or say "next" /
"tiếp theo" to mean "the next undesigned table in the split proposal, in the
order it's listed there"). After producing one table's design, stop and wait
— don't chain into the next table uninvited.

Within a single table's design, if anything is genuinely ambiguous (see
"Where to stop and ask" below), **ask before writing** rather than guessing
and labeling it `[CẦN REVIEW]` — this differs from `mapping-gen`'s convention,
because HLD is structural (wrong column set is expensive to unwind later),
not a formula that's easy to patch. Reserve `[CẦN REVIEW]` markers for minor
open questions that don't block writing a reasonable draft (e.g. a column
name inconsistency already flagged in the source lineage doc itself).

## Inputs to read (in this order) for any table

1. `output/Table_Split_Proposal_CLOS_RLOS.md` — find the table in its
   CHUNG/CLOS/RLOS/REF_ group under SB_DWH or PDTD_DTM, and read the "Nguyên
   nhân" reasoning already recorded there. This tells you *why* the table is
   shaped the way it's proposed, and which old `DIM_LOS_*`/`FCT_LOS_*`/
   `DIM_PDTD_*`/`FCT_PDTD_*` table it derives from.
2. `extract/database/<OLD_TABLE_NAME>.md` — the static column list from the
   design docx (STT, Tên cột, Kiểu dữ liệu, Bắt buộc, Độ lớn, Khóa, Mô tả).
   This is the structural starting point.
3. `extract/SB_DWH/<OLD_TABLE_NAME>.md` (for SB_DWH-layer tables) or
   `extract/PDTD_DTM/<OLD_TABLE_NAME>.md` (for PDTD_DTM-layer tables) — the
   lineage/transform doc: table type, grain, key, source tables, load rule.
   This is where you get the per-column source table + source column +
   transform logic used to fill "Nguồn STG_LOS" in the lineage section.
4. For a table with a REF_ dependency (PDTD_DTM layer, CLOS/RLOS group): the
   matching `extract/database/<REF_TABLE>.md` for whichever of the 9 REF_
   tables the split proposal says this table maps through.
5. If the table involves a source system column whose meaning is unclear,
   check `input/CLOS - Metadata.xlsx` / `input/RLOS - Metadata.xlsx` (sheet
   "3. Column Review") for the business meaning before guessing.
6. `input/DS_BANG_202608.xlsx` (sheet `DS_bang`) — **check this for every
   STG_LOS source table before deciding DIM vs FCT**, not only when something
   already looks suspicious. Column `KEY CDC` states the source table's CDC
   key; column `Trường CLOB` flags large-object columns to exclude from any
   hash-based backup key. If `KEY CDC` is empty for a table that otherwise
   looks like DIM material (stable descriptive attributes), that table
   **cannot** support a DIM/SCD2 design — see the new "No CDC key → can't be a
   DIM" rule in `references/design-method.md`. Known no-key source tables as
   of 202608 (re-check this file when designing any table sourced from one):
   `NG_SB_CLOS_COLL_CD`, `NG_SB_CLOS_CONDITON_CDGRID`,
   `NG_SB_CLOS_CUST_INFO_LEGAL`, `NG_SB_RLOS_APPLICANT_IDGRID`,
   `NG_SB_RLOS_COL_OTHER`, `NG_SB_RLOS_COL_REALESTATE`,
   `NG_SB_RLOS_COL_TRANSPORT`, `NG_SB_RLOS_COL_VALPAPER`,
   `NG_SB_RLOS_COLL_CERTIGRD`, `NG_SB_RLOS_CBS`, `NG_SB_RLOS_DISB_COL_GRID`,
   `NG_SB_RLOS_MANUAL_DEVIATION`, `NG_SB_RLOS_REPAY_CALC`,
   `NG_SB_RLOS_REPAYFLAGS`, `NG_SB_RLOS_SENT_CBS_LOG`,
   `NG_SB_RLOS_SUB_PRODUCT`, `NG_SB_RLOS_CIVIL_APP`,
   `NG_SB_RLOS_CREDIT_CARD_APP`.

## Design method — apply BEFORE looking at the old column list

Read `references/design-method.md` in full before drafting columns. It has
the DIM reasoning chain and the FACT reasoning chain the user set as the
standard for this work, plus the column-optimization rule (drop a column from
a CLOS or RLOS table if the source data only ever populates it for the other
system). Apply this reasoning explicitly for every table — don't just carry
over the merged table's column list and rename the table.

## Output format

Read `references/output-format.md` for the full template (headings, Mermaid
lineage diagram conventions, the two-part table description block per the
user's reference screenshot, and the column table shape). Follow it exactly
— every table's design in the shared output file must look the same so the
whole document reads as one coherent HLD, not a patchwork of ad hoc formats.

## Output file

Single shared file: `hld/HLD_Table_Design.md`. The document has exactly
**three top-level sections for the whole file** — Section 1 (all tables'
lineage diagrams), Section 2 (all tables' column designs), and Section 3 (a
single open-issues table, see below) — nested by layer → group
(CHUNG/CLOS/RLOS/REF_) → DIM/FCT → table name for Sections 1–2. A table's
design is **inserted** under its matching heading path in both Section 1 and
Section 2, not appended as a standalone section of its own. Read
`references/output-format.md` for the exact heading skeleton before writing
anything — get this structure wrong and every subsequent table's insertion
point becomes ambiguous.

Read the current file first, then insert under the correct existing heading
(never create a new top-level section per table, never reorder existing
headings). If `hld/HLD_Table_Design.md` doesn't exist yet, create it with the
full heading skeleton per `references/output-format.md` (all three sections,
all layers/groups, empty of table content) before adding the first table.

### Section 3 — Vấn đề mở (open issues log)

A single Markdown table at the end of the file, columns: `STT | Bảng | Vấn
đề | Cần xác nhận gì | Trạng thái`. Every time a table's design surfaces a
PENDING situation (event/log-sourced DIM, a documented-vs-actual source
mismatch like DQ-11, any other "cần hỏi lại BA/DEV" case from "Where to stop
and ask" below) — **add a row here**, not just a note buried in that table's
Section 1/2 prose. The prose note in Section 1/2 stays too (it has the full
context); Section 3 is the scannable index of everything still open across
the whole document.

`Trạng thái` starts at `PENDING`. When the user says a listed issue is
resolved, update that row's `Trạng thái` to `ĐÃ GIẢI QUYẾT` — never delete
the row (it's the history of what was asked and answered) — and go back to
update the corresponding PENDING marker/heading/note in Section 1 and
Section 2 for that table to reflect the resolution (e.g. replace "⚠️ PENDING
xác nhận BA" in the heading with the confirmed source, rewrite the column
row's Mô tả with the confirmed lineage). Don't leave Section 3 marked
resolved while Section 1/2 still shows the old PENDING language — the two
must stay in sync.

## Mandatory step — cross-check against SRS before reporting a result

`extract/SB_DWH/<TABLE>.md` / `extract/PDTD_DTM/<TABLE>.md` (the lineage
docs) are themselves a **secondary source** — they summarize per-column
lineage, but the primary source of truth for "which report needs this
column, and what does it actually map from in STG_LOS" is the SRS itself
(`input/srs_report/BC1..BC11_PDTD_DTM_SRS_v1.0.docx`). Before presenting any
table's design as finished (not just when something already looks
suspicious), do this verification pass for every column carrying a real
business value (skip purely technical columns — `DIMENSION_KEY`, `*_SK`,
`EFF_DATE`, `EXP_DATE`):

1. From the lineage doc's "Báo cáo sử dụng" line, identify which BC reports
   reference this table.
2. For each such report, open its SRS docx and find the field list table
   (the largest table in the doc, columns `STT | Trường | Ý nghĩa | Cách lấy
   dữ liệu` — see the pattern already used when verifying
   `DIM_CLOS_APPLICATION` against BC2). Extract each field's `Cách lấy dữ
   liệu` cell, which states `<SOURCE_TABLE>> <SOURCE_COLUMN>` directly.
3. Compare that against what the lineage doc and your drafted column
   description say. Three outcomes:
   - **Match** — proceed, no note needed beyond the normal column
     description.
   - **SRS confirms a column the lineage doc under-specifies** — fill in the
     gap using the SRS's own wording (as already done for `BI_FLOW`'s
     per-system formula difference).
   - **SRS says one source, but the source-system metadata
     (`CLOS - Metadata.xlsx` / `RLOS - Metadata.xlsx`, sheet "3. Column
     Review") shows that source table/column doesn't exist** — this is a
     real data-quality gap (the `DIM_CLOS_APPLICATION` DQ-11 pattern): keep
     the column (the report genuinely needs it), mark the table/column
     PENDING, and log it in Section 3 per the rule below. Don't silently
     drop a column just because you can't verify its source — only drop a
     column when no report needs it at all (see the column-optimization
     rule in `references/design-method.md`).
4. If a column exists in the old merged table's design but **no** BC report
   actually uses it (checked across all of BC1–BC11, not just the ones the
   lineage doc lists), treat that as a live "where to stop and ask" case
   below rather than assuming it's still needed.

This pass is what turns "the lineage doc says X" into "the report actually
needs X, from exactly this source" — do it before every reported result, not
only when a mismatch already seems likely from the lineage doc alone.

## Where to stop, ask, and log

Ask the user instead of guessing, and **log the issue as a new row in
Section 3** once confirmed (per the "Section 3" rule above — don't skip the
log because the user is only asking a clarifying question, not writing yet),
when:

- **Every source table feeding a DIM is application-scoped (event/log, or a
  per-application snapshot/master-looking table), not a true entity master**
  — see `references/design-method.md`'s "Red flag — DIM sourced from an
  application-scoped table, not a true master" for the full test, three
  worked examples (`DIM_LOS_USER`, `DIM_CLOS_PRODUCT`/`DIM_RLOS_PRODUCT`,
  `DIM_CLOS_WORKSTEP`/`DIM_RLOS_WORKSTEP`), and the **standing resolution**:
  a manually-maintained `MAP_<hệ>_<entity>` seed table at the STG_LOS layer
  (e.g. `MAP_LOS_USER`, `MAP_CLOS_PRODUCT`/`MAP_RLOS_PRODUCT`,
  `MAP_CLOS_WORKSTEP`/`MAP_RLOS_WORKSTEP`) becomes the DIM's *only* source —
  no more blending with the old application-scoped tables. Confirm the
  column set against actual report demand (the mandatory SRS cross-check
  covers this), design the `MAP_` table explicitly as its own STG_LOS
  source in the lineage, and update Section 3 to `ĐÃ GIẢI QUYẾT` once a
  previously-PENDING DIM gets its seed table designed — see the
  "Resolution" subsection in design-method.md for the full column shape
  (`EFF_DATE` entered by the editor, not ETL-computed; `UPDATED_BY` for
  audit) and SCD2 load rule (standard, unchanged mechanics — only the
  source changed). For a **new** table hitting this pattern, confirm with
  the user that the same seed-table fix applies before assuming it
  automatically does. Don't fold a separate, downstream FCT-level data gap
  (e.g. `WFINSTRUMENTTABLE`'s `PROCESSNAME`/`ACTIVITYNAME` not being loaded
  anywhere yet, needed for a `WORKSTEP_FLAG`-style derived column) into this
  DIM's design just because both mention the same STG_LOS table — log it as
  its own Section 3 row against the FCT once that table is designed.
- The split proposal's "Nguyên nhân" for this table references a column
  whose CLOS-side vs RLOS-side source table disagrees with what
  `extract/SB_DWH/<TABLE>.md` actually lists (a real discrepancy between the
  two source documents, not just missing detail).
- A column's business meaning is genuinely ambiguous between belonging to
  the DIM vs being fact-only data (rare, but the "attributes so volatile they
  don't survive one grain row" smell described in the design method doc).
- The REF_ table a PDTD_DTM-layer table should join through isn't obvious
  from the split proposal (more than one candidate REF_ table plausibly
  fits, or none does).
- The old merged table had a column that doesn't cleanly belong to either
  the CLOS or RLOS split and isn't already called out as shared in the split
  proposal — don't silently drop it or silently duplicate it into both.

Don't ask about naming conventions (prefix `DIM_CLOS_`/`DIM_RLOS_`/`DIM_LOS_`,
same table name across SB_DWH/PDTD_DTM, REF_ tables keep source names) — that
was already settled in `output/Table_Split_Proposal_CLOS_RLOS.md` and applies
uniformly.

## After producing a table's design

Report back concisely: table name, layer, group (CHUNG/CLOS/RLOS/REF_),
column count, one line on any column dropped/added versus the old merged
table's column list (this is the part most worth the user's attention — it's
the actual storage-optimization outcome), and one line confirming the SRS
cross-check ran (which BC reports were checked, and whether it surfaced any
new PENDING row in Section 3 — don't just say "done", name what was
verified). Then stop and wait for the next table to design.
