# HANDOFF: CIS376 Textbook

**Last updated:** 2026-09-09

## What this is

The OER textbook for CIS376 (Database Management and Security),
built from `../template/` to the CIS215 and CIS133 standard: 12
chapters in 4 Parts, the N.1-N.7 anatomy, exactly 3 MLOs per chapter,
the shared Skills Lab rubric, and the five pedagogy upgrades built in
from the first draft (spine, fading, cumulative retrieval, Fix It,
subgoal labels). Lab engine: PostgreSQL 17.

## Decisions on record (2026-09-09, Mr. Vega)

* PostgreSQL 17 is the lab engine. The CLOs are management and
  security outcomes, so SQL is assumed and never the subject.
* Students arrive from one SQL course (Oracle SQL, CIS276DA MySQL, or
  CIS276DB SQL Server). Chapters bridge in one sentence, never reteach.
* 14 old modules became 12 chapters: old 2+3 merged into Chapter 2,
  old 13+14 merged into Chapter 12, old 12 became Chapter 11 and
  absorbed outline section III.F.
* The spine is Copperwind IT Services with two fictional regulated
  clients, Sandwash Family Clinic (HIPAA) and Harquahala Charter
  Academy (FERPA). Both names passed a collision search. The first
  candidates (Palo Brea, Cholla Vista) collided and were dropped.
* Chapter CLO blocks quote the ELEVATED CLOs with Bloom's tags (the
  wording the previous QM course map used), not the district's
  "Understand" wording. Recorded in docs/CIS376_CLOs.md. This is a
  deviation from the assumption stated at kickoff, made because
  "understand" fails QM measurability and the Canvas alignment map
  already uses the elevated lines. Flagged for Mr. Vega.
* Flesch band 60-70, with a 55 floor for chapters 4 and 10. Pending
  Mr. Vega's confirmation.
* Task list id: `cis376-spring27` (assumed; confirm the term).

## Where things are

| What | Where |
| --- | --- |
| Authoritative CLOs, outline, mapping | `docs/CIS376_CLOs.md` |
| 12-chapter plan with MLOs | `docs/part-structure.md` |
| Spine bible, data landscape, per-chapter plan, block formats, QA protocol | `docs/book-design-spec-2026-09-09.md` |
| Course style layer | `docs/style-guide.md` |
| Data generator (seed 376, `--check` proves byte-identical rerun) | `assets/code/_generators/generate_course_data.py` |
| Shared CSVs (loaded once, by every chapter's setup script) | `assets/code/data/<org>/` |
| Chapter fixtures (flat export, logs, audit rows) | `assets/code/chapter-03`, `chapter-07`, `chapter-10` |
| SQL harness | `tools/run_chapter_sql.py` |
| Output checker | `tools/check_sql_outputs.py` |
| Structure checker (Section 3.1 counts) | `tools/check_course_structure.py` |
| Readability | `tools/check_readability.py` |

The three synced Python tools (`run_chapter_code.py`,
`check_output_comments.py`, `check_sentence_length.py`) stay in
`tools/` because the sync script owns them. Only the sentence-length
checker applies to this book.

## Local PostgreSQL for verification

```bash
export LC_ALL=en_US.UTF-8
/opt/homebrew/opt/postgresql@17/bin/pg_ctl -D /opt/homebrew/var/postgresql@17 -l /tmp/pg.log start
```

The cluster was initialized with `initdb -U postgres --auth=trust`,
so `postgres` is the only login role and catalog outputs match a
student install. The harness rebuilds the three databases under their
real names before every run and drops course roles (`copperwind_*`,
`clinic_*`, `academy_*`). A file lock serializes harness runs, because
roles are cluster-wide. `LC_ALL` must be set or the postmaster refuses
to start on macOS.

## Rebuilding the student data pack

```bash
cd /Users/vega/Documents/code/textbooks && \
zip -r cis376/build/cis376-data-pack.zip cis376/assets/code \
    -x '*.DS_Store' -x '*__pycache__*' -x 'cis376/assets/code/_generators/*'
```

## Status

See the bottom of this file for the running session log.

### 2026-09-09: scaffold, spec, data, tools

Instantiated from the template, tokens replaced, shared files synced,
Bloom's reference seeded. Wrote the CLO reference, the 12-chapter
part structure with refined MLOs, the design spec, the style layer,
the home page, the glossary stub, and the nav. Built the data
generator and the four SQL QA tools. Installed PostgreSQL 17 locally
and verified the harness end to end. Chapters: not yet written.
