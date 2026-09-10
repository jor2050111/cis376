# HANDOFF: CIS376 Textbook

**Last updated:** 2026-09-09 (session 2, wave two drafted)

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
  already uses the elevated lines. Confirmed by Mr. Vega on
  2026-09-09 (session 2): every chapter uses the elevated Bloom's
  wording, never "Understand".
* Flesch band 60-70, with a 55 floor for chapters 4 and 10. Confirmed
  2026-09-09: landing slightly above 55 is acceptable in any chapter
  when the author's educator judgment says the vocabulary calls for
  it, and the report must say so.
* Task list id: `cis376-spring27`. Confirmed 2026-09-09 (Spring 2027).
* Publishing: Mr. Vega approved (2026-09-09) creating the public
  GitHub repo as the first push and deploying the draft site.

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

## Status after wave two (2026-09-09, session 2)

**Chapters 1-9 drafted, verified, and committed. Chapters 10-12 not
started.** Wave two (6-9) awaits Mr. Vega's review before wave three
launches. Public repo `jor2050111/cis376` created and the draft site
deploys from `main` through `.github/workflows/docs.yml`.

| Ch | Lines | SQL blocks | Flesch | Notes |
| -- | ----- | ---------- | ------ | ----- |
| 1 | 540 | 6 | 61.3 | Written by the maintainer, the exemplar |
| 2 | 662 | 12 | 62.9 | Fix It error differs from the spec row (corrected in spec) |
| 3 | 694 | 15 | 64.3 | Found 12 real double bookings in appointments and taught them |
| 4 | 692 | 14 | 57.2 | Inside the 55 floor; regulatory vocabulary |
| 5 | 741 | 13 | 64.2 | 41 lines over target; chapter-specific setup-sandwash.sql plants an over-grant |
| 6 | 726 | 11 | 64.6 | 26 over target; TLS "after restart" captures from a throwaway cluster on port 5499, recorded in chapter-06-captures.md |
| 7 | 727 | 9 | 66.7 | Drafted at 811 with 24 fences, trimmed to 15 fences; log settings captured from a throwaway cluster on port 5439 |
| 8 | 611 | 9 | 66.4 | pg_stat_statements taught in a text fence because the local cluster has no preload; verified blocks use EXPLAIN (COSTS OFF) |
| 9 | 566 | 12 | 62.1 | 34 under the floor by author choice; ships copperwind_ops (3.7 MB) and sandwash_clinic (604 KB) plain dumps plus a scan report |

Every chapter passes: harness (0 failures), output check (0
mismatches), structure checker (0 errors), sentence length (0 flagged),
style sweeps, and a clean Zensical build. Glossary: 180 terms merged
from `docs/glossary-additions/` (seven duplicate definitions were kept
as the earlier chapter's wording; see the CONFLICT lines from
`tools/merge_glossary_additions.py --check`). Combined Flesch 62.3.

### How to continue (next session)

1. Start PostgreSQL (command above) and confirm `psql -U postgres -d
   postgres -c "select 1"` works. Activate nothing else: the QA tools
   are plain `python3`, the build uses `.venv/bin/zensical`.
2. Read `docs/CHAPTER-AGENT-BRIEF.md`. It is the complete instruction
   set for a chapter author. Wave one proved it: four agents in
   parallel, each ~15-30 minutes, all green on the first review.
3. Wave two (6-9) is drafted. After Mr. Vega's review, launch wave
   three: chapters 10, 11, 12 as three background agents. Each prompt
   names the chapter, points at the brief, and restates the chapter's
   spec row (spec Section 4: spine database, fading level, Fix It
   error, fixture) plus the part-structure sections, MLOs, aligned
   CLOs, and neighbors. Add the wave-two lessons: no cluster config
   edits (capture restart-dependent output from a throwaway `initdb`
   cluster on a spare port and record it in a `chapter-NN-captures.md`),
   `EXPLAIN (COSTS OFF)` in verified blocks, deterministic evidence
   instead of random salts or timings, and a fence budget of 15.
   Chapter 11's Fix It (pg_stat_statements not preloaded) is real on
   this cluster. Pattern: read the brief first, deliver the listed
   files, run the workflow until green, report back, do not commit.
4. Special fixtures the spec assigns: ch 9 needs a backup dump of
   copperwind_ops (produce it with `pg_dump` under `tools/locked.py`
   after a plain `psql -f` rebuild, never inside the harness) and a
   scan report; ch 10 already has its log and audit CSV in
   `assets/code/chapter-10/`; ch 11 needs a benchmark checklist and a
   baselines file; ch 12 needs the plan template. Ch 6 needs a
   self-signed certificate for the TLS section (generate with openssl,
   ship the command, not the key).
5. After each wave: `python3 tools/merge_glossary_additions.py`,
   `python3 tools/check_course_structure.py --all`,
   `python3 tools/check_readability.py`, `.venv/bin/zensical build
   --clean`, then commit.
6. Whole-book QA after chapter 12 (spec Section 8), then rebuild the
   data pack zip and update this file. The repo and Pages deploy
   already exist (created 2026-09-09 in session 2); every push to
   `main` redeploys https://jor2050111.github.io/cis376/.

### Review notes from wave two (maintainer judgment calls pending)

* Ch 6 is 726 lines. Every configuration change carries its proof, and
  the "after your restart" TLS output sits in `text` fences. The
  `hostnossl ... reject` refusal was captured on port 5499 against
  `postgres` and quoted with `sandwash_clinic` and 5432 substituted
  (stated in the captures file). The Skills Lab hashes 1,201 rows at
  bcrypt cost 10, about a minute; Part 3 asks students to restart
  their own server for TLS. The HHS breach-notification link answers
  403 to curl but renders in a browser.
* Ch 7 ships two settings that persist across setup reruns (`ALTER
  DATABASE copperwind_ops SET log_statement` and a role-level SET);
  the README says how to reset them. The classification rule names a
  `copperwind_dba` login that is a plan rule, not a created role. The
  postgresql.conf excerpt became a bulleted list to hit the fence
  budget. The merged parse-and-classify block is 41 SQL lines.
* Ch 8 adds a WAL definition that Chapter 2 bolds but never defined.
  The merge kept Chapter 8's wording and dropped Chapter 9's.
* Ch 9 is 566 lines. Both dump headers read "17.11 (Homebrew)". The
  Fix It pre-seeds a lone `tickets` table so the error is the spec's
  exact line. Point-in-time recovery is taught in `text` fences and
  verified only through `SHOW` and `pg_current_wal_lsn()`.
* Wave-one items below still stand.

### Review notes from wave one (maintainer judgment calls pending)

* Ch 2 prints the author's `hba_file` path and `trust` rules from the
  development cluster in two verified blocks. The prose says so and
  names the Windows path. Acceptable for a draft; consider moving the
  rules output to a `text` fence showing a typical installer default.
* Ch 3 names NoSQL products (MongoDB, Redis, DynamoDB, Cassandra,
  Neo4j) in a comparison table, following Chapter 1's naming of
  Oracle, MySQL, and SQL Server. Products, not clients. Kept.
* Ch 3 found 12 provider double bookings and 86 student name
  collisions in the generated data and turned both into lessons. If a
  later chapter needs a UNIQUE(provider_id, scheduled_at) constraint
  to succeed, the generator must change and chapter 3 with it.
* Ch 4 measured the directory opt-out rate at 6.1 percent (49 of
  800); the spec said about 8 percent. The chapter prints the real
  number. Spec Section 2.3 should be corrected.
* Ch 5 is 741 lines because every configuration change is followed by
  its proof query. Trimming means removing evidence. Left as is.
* Ch 5 setup-sandwash.sql is chapter-specific and marked; the
  generator will not overwrite it.

## Session log

### 2026-09-09: scaffold, spec, data, tools

Instantiated from the template, tokens replaced, shared files synced,
Bloom's reference seeded. Wrote the CLO reference, the 12-chapter
part structure with refined MLOs, the design spec, the style layer,
the home page, the glossary stub, and the nav. Built the data
generator and the SQL QA tools (harness, output fill and check,
structure, readability, glossary merge, lock wrapper). Installed
PostgreSQL 17 locally and verified the harness end to end. Wrote
Chapter 1 by hand as the exemplar, then ran wave one (chapters 2-5)
as four parallel agents against `docs/CHAPTER-AGENT-BRIEF.md`.
HQ task: recWdgSTKDhci9Y9v (In progress, Claude).

### 2026-09-09: session 2, wave two

Recorded Mr. Vega's four rulings (elevated CLOs, Flesch floor
judgment, task list term, public repo as first push). Ran chapters
6-9 as four parallel agents; chapter 7 took a second consolidation
pass (811 lines and 24 fences down to 727 and 15). Merged the
glossary to 180 terms, whole-book checks green, committed, created
the public repo, and deployed the draft site. Paused for Mr. Vega's
review before wave three.
