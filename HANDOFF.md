# HANDOFF: CIS376 Textbook

**Last updated:** 2026-09-10 (session 3, all twelve chapters drafted)

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
mkdir -p cis376/build && \
zip -r cis376/build/cis376-data-pack.zip cis376/assets/code \
    -x '*.DS_Store' -x '*__pycache__*' -x 'cis376/assets/code/_generators/*'
```

## Status after wave three (2026-09-10, session 3)

**All twelve chapters drafted, verified, and committed.** The book is
draft complete. What remains is the whole-book QA pass in spec Section
8 and Mr. Vega's read. Public repo `jor2050111/cis376` deploys from
`main` through `.github/workflows/docs.yml`.

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

| 10 | 700 | 8 | 59.3 | Inside the 55 floor on regulatory vocabulary at 15.0 words per sentence. Arizona's statute produces a negative verdict, which is the Evaluate payoff |
| 11 | 700 | 9 | 63.8 | Ships a benchmark checklist, a baselines file, and a signed access list. The login_roles metric is prefix-scoped so it survives a student's leftover roles |
| 12 | 678 | 9 | 62.6 | The capstone. Ships the nine-section plan template the Skills Lab fills |

Every chapter passes: harness (0 failures), output check (0
mismatches), structure checker (0 errors), sentence length (0 flagged),
style sweeps, and a clean Zensical build. Glossary: 237 terms merged
from `docs/glossary-additions/` with zero conflicts. Chapter Flesch
runs 57.3 to 66.7, with only chapters 4 and 10 under 60 and both inside
their documented floor. Data pack rebuilt at 1.9 MB, all twelve chapter
folders, generators excluded.

Readability note for whoever runs QA next. `check_readability.py`
also scores `index.md` (42.0), `glossary.md` (49.7), and
`skills-lab-rubric.md` (51.7), which drags the combined number to 61.7.
That is expected and not a defect. Those three files are mandated
boilerplate, definitions, and rubric criteria, and spec Section 8 item
5 applies the 60-70 band to chapters only. Rewriting the district CLO
wording to raise a score would break the alignment contract. Do not
chase the combined figure.

### How to continue (next session)

The drafting is done. The next session runs whole-book QA, not chapters.

1. Start PostgreSQL (command above) and confirm `psql -U postgres -d
   postgres -c "select 1"` works. The QA tools are plain `python3`, the
   build uses `.venv/bin/zensical`.
2. Run spec Section 8 across all twelve: `check_course_structure.py
   --all`, `check_readability.py`, and per chapter the harness, output
   check, and sentence length. Every one was green at the close of
   session 3, so a red result means something drifted.
3. Read for the seams, which is what parallel authorship cannot catch
   and no checker will flag:
   * A term bolded as a first use in two chapters. Session 3 fixed
     seven of these. Detect them by diffing bolded terms across
     chapters, not by reading.
   * A cross-chapter callback that names something the other chapter
     does not actually contain.
   * A metric, path, or count that is true on the author's cluster and
     false on a student's. The chapter 11 login_roles defect was this
     shape: `pg_roles` is cluster-wide, so it counted roles left behind
     by earlier chapters. Anything reading `pg_roles`, `pg_database`,
     `pg_settings`, or a file path deserves the same suspicion.
4. Re-verify Further Reading URLs. All twenty-two resolved on
   2026-09-10. The four HHS pages answer 403 to curl and render fine in
   a browser, so check those in the browser pane and do not replace
   them over a 403.
5. Rebuild the data pack (command above) and push. Every push to `main`
   redeploys https://jor2050111.github.io/cis376/.

### Review notes from wave three (decisions already taken, recorded for review)

* Chapter 11's `login_roles` metric counted every login role in the
  cluster. Roles are cluster-wide, so a student holding roles from
  chapters 5 through 10 would read a different number and a different
  delta than the book prints, and the prose reading that delta would be
  wrong for them. The metric now filters on the `copperwind_` prefix,
  which is also what an MSP reviewing one client would measure. The
  baseline moved 4 to 3, the delta stayed at -1, and a sentence names
  the reason. Output refilled from a fresh harness run.
* Chapter 11 promised four cloud security categories and shipped three.
  The fourth is now a managed secret service, closing the Chapter 5
  problem of a service account password sitting in a config file.
* Chapter 11 ships a third fixture the plan did not name,
  `copperwind-access-list.csv`. Kept: a signed access list is a data
  owner artifact a student should load, not type.
* Chapter 11 keeps both databases' rows in `review.metrics` and filters
  by `current_database()`. That is one archive for a managed fleet.
* Chapter 10's reading of the shipped log corrected the wave-three
  brief. The guessing run ends at 23:53:06 across 35 attempts, not
  23:51:36. The chapter teaches from the evidence.
* Chapter 10's Arizona verdict is negative and deliberate. None of the
  exported columns is a specified data element under A.R.S. 18-551(11),
  so the state statute does not trigger. Verified against the statute
  text on 2026-09-10, along with the 45-day deadline, the maintainer
  duty in 18-552(C), and the HIPAA exemption in 18-552(N)(2) that keeps
  the clinic out of Arizona's statute entirely.
* Chapter 10 cites NIST SP 800-61 Rev. 3. Rev. 2 was withdrawn in
  April 2025 and its four-phase model is not presented as current.
* Chapter 10 keeps the breach exposure counts in its captures file
  rather than the chapter, because Skills Lab 10A asks students to
  produce them.
* Quick Check question counts are not uniform book-wide. Chapters 1-4,
  8, 10, and 12 carry three per section, chapters 5-7, 9, and 11 carry
  two. CLAUDE.md allows 2-3, so both pass. Forcing uniformity would
  either pad five chapters past the line budget or cut content from
  seven. Left as is, deliberately.
* Captures files belong in `docs/execution-logs/`, not the chapter's
  data pack folder. The wave-three brief said otherwise and was wrong.
  Chapters 10 and 11 caught it; chapter 12's was moved by hand.


### Review notes from wave two (decisions already taken, recorded for review)

These are calls the author made and the reasons for them. None is a
question for Mr. Vega. A heading that said "pending" cost a session in
2026-09-10 looking for a decision that did not exist. Anything that
genuinely needs his ruling goes in "Open questions for Mr. Vega" below,
and nowhere else.

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

### Review notes from wave one (decisions already taken, recorded for review)

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

## Open questions for Mr. Vega

None. All four rulings requested in session 1 were given on 2026-09-09
and are applied: elevated Bloom's CLO wording in every chapter block,
educator judgment allowed slightly above the 55 Flesch floor, task list
id `cis376-spring27`, and the public repo plus Pages deploy.

---

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

### 2026-09-10: session 3, wave three and draft completion

Opened by checking what was waiting on Mr. Vega and finding nothing.
All four rulings from session 2 were already applied. The wave-one and
wave-two notes had been filed under a "pending" heading despite
recording decisions already taken, which is what sent him looking.
Renamed both headings and added an "Open questions for Mr. Vega"
section so a real question has one home.

Fixed two design spec defects before launching. Section 4's chapter 10
row described the shipped academy fixtures while naming the clinic as
its spine database, when Section 1.3's rotation table, Section 2.3, the
Skills Lab title, and the generator's chapter map all agree the
fixtures are the academy's and the spine block is the clinic's. The row
text was the error. Section 2.3's 8 percent opt-out estimate became the
6.1 percent chapter 4 measured. Pinned chapter 10's timezone Fix It to
an explicit SET TimeZone in both blocks so the seven-hour shift
reproduces outside Arizona.

Fixed seven cross-chapter double-bolds from waves one and two, and
kept chapter 2's pg_hba trust rules as verified output while reframing
them as the stock initdb --auth=trust default they are.

Ran chapters 10, 11, and 12 as three parallel agents. All three came
back green. Repaired chapter 11's cluster-wide login_roles metric and
its missing fourth cloud category, merged the glossary to 237 terms
with zero conflicts, rebuilt the data pack, and committed.

Verified independently rather than on report: chapter 12's Fix It error
and repair output against the live server, and every chapter 10 legal
claim against the Arizona statute text.

HQ task: recWdgSTKDhci9Y9v.
