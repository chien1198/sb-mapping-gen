---
name: mapping-gen
description: Generate a mapping Excel file for one DIM/FCT table in the LOS/PDTD datamart pipeline — CLOS/RLOS to SB_DWH, SB_DWH to STG_DTM, STG_DTM to PDTD_DTM, or (not yet available) Datamart to Report. Use when the user asks to gen/generate/create mapping for a table or destination, at any stage of the pipeline.
---

# Generate mapping Excel — router

This is a **4-phase pipeline**, each phase mapping data one layer further
downstream:

1. **SB_DWH** — CLOS/RLOS source systems → `SB_DWH.<TABLE>` (reshapes
   `lld/sb_dwh/SB_DWH_<TABLE>.csv`, multiple "How to mapping <SYSTEM>"
   columns, JOINs)
2. **STG_DTM** — `SB_DWH.<TABLE>` → `STG_DTM.STG_<TABLE>` (reshapes
   `lld/stg_dtm/STG_DTM_STG_<TABLE>.csv`, 1:1 copy, single source,
   table-wide row filter)
3. **PDTD_DTM** — `STG_DTM.<TABLE>` → `PDTD_DTM.<TABLE>` (reshapes
   `lld/pdtd_dtm/PDTD_DTM_<TABLE>.csv`, an aggregation layer on top of
   STG_DTM — can be 1:1 or need JOINs, not a fixed shape)
4. **Report** — Datamart → report extract (not yet available, see below)

All three implemented phases now work the same way: a table's mapping
logic has already been fully decided in its LLD CSV (`lld/<phase>/`), so
the skill's job is to **reshape** that LLD into the template's Excel
layout — assigning short aliases, splitting JOIN clauses into their own
section, picking a header label — not to re-derive source/target logic
from raw docx/xlsx extracts the way earlier versions of this skill did.

This skill is a single entry point: it identifies which phase the user
means, then reads the matching rules file in `references/` and follows it.
The rules files hold all the phase-specific detail (input files, header
block shape, per-column formula logic, filters, JOINs) — this file only
covers how to tell the phases apart and the two things every phase shares
(output naming pattern, self-check via `scripts/validate_mapping.py`).

## Identifying the phase

The user names a **destination**, not a phase number — match on that, but
confirm it against where the table's LLD file actually lives, since a
table's own name can exist under more than one phase (e.g.
`DIM_CLOS_APPLICATION` has both a `lld/sb_dwh/` file and a `lld/pdtd_dtm/`
file — same business table, two different mapping jobs):

| User says / implies | Destination | LLD path | Rules file |
|---|---|---|---|
| "SB_DWH", "gen mapping cho SB_DWH", or no destination given but the table only exists under `lld/sb_dwh/` | `SB_DWH` | `lld/sb_dwh/SB_DWH_<TABLE>.csv` | `references/rules-sb_dwh.md` |
| "STG_DTM", "STG", table name already prefixed `STG_` | `STG_DTM` | `lld/stg_dtm/STG_DTM_STG_<TABLE>.csv` | `references/rules-stg_dtm.md` |
| "PDTD_DTM", "PDTD" | `PDTD_DTM` | `lld/pdtd_dtm/PDTD_DTM_<TABLE>.csv` | `references/rules-pdtd_dtm.md` |
| "Report", "báo cáo" | `Report` | — | not implemented — see below |

Note PDTD_DTM target tables keep their original business name (e.g.
`DIM_CLOS_APPLICATION`, `DIM_T24_CARD`, `AGG_LOS_KPI_APPLICATION`) — there
is no `DIM_PDTD_*`/`FCT_PDTD_*` naming prefix in this project's actual
schema, so don't use that pattern to detect the phase.

If the bare table name the user gives exists under more than one `lld/*`
path and they haven't said which destination they mean, **ask** — don't
guess silently, since the phases produce very different output shapes and
picking the wrong one wastes a full generation+review cycle.

Once identified, **read the matching rules file in full** before doing
anything else — each one is self-contained (inputs, output structure,
formula-derivation rules, steps, notes). Follow it as you would have
followed a standalone skill; this router file doesn't repeat that detail.

### Report (phase 4) — not yet available

`mapping/Report/` and `extract/report/` are both empty, and no rules file
exists yet for this phase — unlike PDTD_DTM, there isn't even a confirmed
source/target shape to design around (`input/srs_report/` has 12 raw SRS
docs, unextracted). If the user asks for Report mapping, say so plainly:
this phase needs its own discovery pass (what extract/report/ should hold,
what the target mapping template looks like, whether it's even structured
like the DIM/FCT LOAN templates) before a rules file can be written — don't
attempt to invent a structure for it. Offer to run that discovery pass if
the user wants to start now.

## What every phase shares

- **One table per run** unless the user explicitly asks for all tables in
  that phase — keeps each output reviewable before running the rest.
- **Output path pattern**: `mapping/<DESTINATION>/Mapping_<TARGET_TABLE>.xlsx`
  (e.g. `mapping/SB_DWH/Mapping_DIM_CLOS_CUSTOMER.xlsx`,
  `mapping/STG_DTM/Mapping_STG_DIM_CLOS_CUSTOMER.xlsx`,
  `mapping/PDTD_DTM/Mapping_DIM_CLOS_CUSTOMER.xlsx` — the `<TARGET_TABLE>`
  is always that phase's own LLD `target_table` value, not a name you
  construct). `mapping/` is git-ignored — safe to regenerate freely.
- **Same renderer for every phase**: `scripts/gen_mapping.py` fills a copy
  of `references/Mapping_DIM_LOAN_template.xlsx` (DIM) or
  `references/Mapping_FCT_LOAN_template .xlsx` (FCT, mind the trailing
  space in that filename) from a JSON file you build — see the docstring at
  the top of that script for the exact JSON schema. It never invents
  mapping logic; all analysis happens before it runs, in the agent turn,
  guided by the phase's rules file.
- **Always self-check before reporting done**:
  ```bash
  .venv/bin/python scripts/validate_mapping.py <output.xlsx>
  ```
  This is a formatting/structural self-check shared by all phases (bold
  header lines, no stray strikethrough, one JOIN clause per cell, no blank
  mapping/Item Name cells, the fixed "Điều kiện lấy dữ liệu" row keeping its
  label, CLOS-before-RLOS column order when both appear, etc. — see the
  checklist at the top of `scripts/validate_mapping.py` for the current
  full list). It does **not** judge business-logic correctness. If it exits
  non-zero, the bug is almost always in `gen_mapping.py`'s styling/placement
  logic, not the JSON data — fix the script, regenerate, and re-validate.
  Never report a file as done without running this.
- **`[CẦN REVIEW]` convention**: prefix any inferred/uncertain mapping text
  with `[CẦN REVIEW] ` so the user can spot it during review — never
  silently guess and present it as settled. Each phase's rules file details
  when this applies for that phase.
- Treat any new formatting requirement the user raises in review as
  something to encode as a new check in `scripts/validate_mapping.py`,
  not just a one-off hand fix to the file in front of you — that script is
  the shared contract every phase's output must satisfy.
