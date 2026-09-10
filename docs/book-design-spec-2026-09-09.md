# CIS376 Book Design Spec (Spine, Data, Per-Chapter Plan, QA Contract)

**Date:** 2026-09-09

**Status:** governing spec for the first draft. Every chapter author
(human or agent) reads this file, `part-structure.md`, `CIS376_CLOs.md`,
`style-guide.md`, and `CLAUDE.md` before writing a line.

**Governing family documents:**

* `../../PEDAGOGY-UPGRADE-PLAYBOOK-V1.md` (the five upgrades: spine,
  fading, cumulative retrieval, Fix It, subgoal labels)
* `../../TEXTBOOK-QUALITY-RUBRIC-V2.md` (publication gates)
* `../../cis215/docs/pedagogy-upgrade-plan-2026-07-28.md` (source of
  the Copperwind canon)

**Prime directive:** CIS215 and CIS133 retrofitted the five upgrades
onto finished books. CIS376 builds them in from the first draft. Every
chapter ships with its spine block, its fading level, its cumulative
retrieval items, its Fix It block with a real captured error, and its
subgoal-labeled flagship example. There is no "baseline" mode.

---

## 1. The spine: Copperwind IT Services and two regulated clients

### 1.1 Canonical facts (family-wide, reuse exactly)

**Copperwind IT Services** is a fictional managed IT services provider
(MSP) in Phoenix, Arizona. About 30 employees. Two support teams,
**Deskside** and **Network Ops**, with 8 technicians total. Roughly 40
client companies across the Valley: clinics, law offices, schools,
retailers, and nonprofits. Copperwind tracks every support request as
a ticket.

**Canonical cast (the 8 technicians):** Priya Sharma, Malik Johnson,
Mei Lin, Diego Ramos, Amara Okafor, Sofia Reyes, Ethan Cole, Naomi
Redhouse.

**Canonical ticket vocabulary:** categories Hardware, Software,
Network, Security, Accounts. Priorities Low, Medium, High, Critical.
Teams Deskside, Network Ops. Date range January 2024 through June 2026.

**New CIS376-side canon (recorded here, now family canon):**
Copperwind added a **Data Services** practice in 2025. It hosts and
manages databases for clients that cannot staff a database
administrator. **Mei Lin leads Data Services.** **Naomi Redhouse is
the security lead** who signs off on access reviews and incident
reports. **Ethan Cole** runs backups and the on-call rotation.

**The student's role:** Copperwind has hired you as its **database
administrator**. You manage Copperwind's own operations database and
the databases of two regulated clients. Mei Lin is your manager. Naomi
Redhouse reviews your security work. Chapter 1 states the role. Later
chapters echo it in one sentence where a spine block opens.

### 1.2 The two clients (new, fictional, collision-checked 2026-09-09)

**Sandwash Family Clinic** is a fictional primary care clinic in west
Phoenix with 12 providers, about 600 active patients in the course
data, and a front desk of 4. It is a HIPAA covered entity. Copperwind
hosts its scheduling and visit-notes database. Cast: **Dr. Elena
Vasquez** (medical director and data owner), **Tomas Reyes** (office
manager), **Grace Yazzie** (front desk lead). Name-collision search on
2026-09-09 found no clinic named Sandwash in Arizona. (The first
candidate, Palo Brea, collided with a real Phoenix practice and was
dropped.)

**Harquahala Charter Academy** is a fictional K-8 charter school in the
west Valley with about 800 students, 1,200 guardians, and 60 staff in
the course data. It is subject to FERPA. Copperwind hosts its student
information database. Cast: **Principal Dana Whitfield** (data owner),
**Luis Ortega** (registrar), **Ms. Keisha Bell** (a teacher). The name
comes from the Harquahala Mountains. Name-collision search on
2026-09-09 found no school by that name. (The first candidate, Cholla
Vista, collided with several real Arizona schools and was dropped.)

### 1.3 Continuity rules

* Chapter 1 introduces all three organizations in Section 1.3, in one
  paragraph each, and loads their databases.
* Every later spine block opens with one orienting sentence so the
  chapter stands alone. A callback like "(You first built the clinic
  roles in Chapter 5.)" is welcome. A dependency like "continue from
  your Chapter 5 script" is banned (schedule neutrality, G2).
* The spine claims exactly one Try It Yourself per chapter plus the
  Skills Lab. Other Try It Yourself blocks keep varied cover stories:
  a law office, a nonprofit food bank, a bike shop, a city parks
  department, a credit union. Never a real company.
* The three databases rotate through the Skills Labs so no single
  regulation dominates:

| Chapter | Skills Lab database | Spine Try It Yourself database |
| --- | --- | --- |
| 1 | all three | copperwind_ops |
| 2 | sandwash_clinic | copperwind_ops |
| 3 | harquahala_academy | sandwash_clinic |
| 4 | sandwash_clinic | harquahala_academy |
| 5 | sandwash_clinic | harquahala_academy |
| 6 | harquahala_academy | sandwash_clinic |
| 7 | copperwind_ops | sandwash_clinic |
| 8 | copperwind_ops | harquahala_academy |
| 9 | sandwash_clinic | copperwind_ops |
| 10 | harquahala_academy | sandwash_clinic |
| 11 | copperwind_ops | harquahala_academy |
| 12 | student's choice | all three |

### 1.4 Fictional disclaimer (verbatim, every chapter README)

> Copperwind IT Services, Sandwash Family Clinic, and Harquahala
> Charter Academy are fictional organizations created for this
> textbook. All names, patients, students, staff, and records are
> synthetic. Any resemblance to a real organization or person is
> coincidental.

---

## 2. The data landscape

All data is seeded synthetic data. Base seed **376**. Generators live
in `assets/code/_generators/` and rerun byte-identically. Each
generator asserts the engineered properties the chapters depend on.
Real patient or student data never appears anywhere.

### 2.1 copperwind_ops (Copperwind's own operations database)

| Table | Rows | Purpose |
| --- | --- | --- |
| `clients` | 40 | client_id, client_name, sector (Healthcare, Legal, Education, Retail, Nonprofit), city, contract_start |
| `technicians` | 8 | technician_id, full_name, team, hire_date |
| `tickets` | about 18,000 | ticket_id, client_id, technician_id, category, priority, opened_at, closed_at, status, summary |
| `ticket_notes` | about 30,000 | note_id, ticket_id, author_id, noted_at, note_text |
| `login_events` | about 12,000 | event_id, username, event_time, source_ip, success (feeds Ch 7 and Ch 11) |

Engineered properties: ticket volume grows 3 percent a month
(Ch 2 sizing), Security tickets cluster in two months (Ch 7 review),
three reports run slow without indexes (Ch 8), a burst of failed
logins from one address sits in `login_events` (Ch 7 and Ch 11).

### 2.2 sandwash_clinic (HIPAA)

| Table | Rows | Purpose |
| --- | --- | --- |
| `providers` | 12 | provider_id, full_name, specialty, npi (synthetic 10-digit) |
| `patients` | 600 | patient_id, first_name, last_name, date_of_birth, phone, email, address, insurance_member_id |
| `appointments` | 6,000 | appointment_id, patient_id, provider_id, scheduled_at, status, visit_type |
| `visit_notes` | 4,500 | note_id, appointment_id, diagnosis_code, note_text (synthetic, non-clinical filler) |
| `staff_accounts` | 20 | account_id, username, role_name, provider_id (nullable) |

Engineered properties: `insurance_member_id` is the column Ch 6
encrypts. Every provider has patients (Ch 5 row-level security has
rows to filter). Notes older than the retention window exist (Ch 4
and Ch 9 retention). Ch 10 ships a separate breached snapshot.

### 2.3 harquahala_academy (FERPA)

| Table | Rows | Purpose |
| --- | --- | --- |
| `students` | 800 | student_id, first_name, last_name, date_of_birth, grade_level, directory_opt_out (boolean) |
| `guardians` | 1,200 | guardian_id, full_name, phone, email, relationship |
| `student_guardians` | 1,500 | student_id, guardian_id, is_primary |
| `staff` | 60 | staff_id, full_name, role_name (Teacher, Registrar, Counselor, Admin) |
| `courses` | 40 | course_id, course_name, grade_level |
| `sections` | 120 | section_id, course_id, staff_id, term |
| `enrollments` | 6,000 | enrollment_id, student_id, section_id |
| `grades` | 6,000 | enrollment_id, term_grade, comments |
| `portal_accounts` | 1,200 | account_id, guardian_id, username, password_hash (Ch 6 hashes it) |

Engineered properties: about 8 percent of students opt out of
directory information (Ch 4). The Ch 3 flat gradebook export
denormalizes `students`, `sections`, and `grades` into one CSV with
planted anomalies (three spelling variants of one teacher's name,
one duplicated row, one grade outside the valid range). Ch 10 ships
audit rows and a server log showing an over-privileged account
exporting guardian contacts.

### 2.4 Chapter folders

Each `assets/code/chapter-NN/` folder ships everything that chapter
needs and nothing it does not:

* `setup-<database>.sql` for each database the chapter uses. The
  script drops and recreates the database's tables, then loads the
  CSVs with `\copy` using paths relative to the `cis376` root. It is
  idempotent. The generator writes the base script into every chapter
  folder listed for that organization. A chapter that needs a
  different starting state (schemas already separated, roles already
  created) keeps a hand-edited copy marked
  `-- CHAPTER-SPECIFIC: do not regenerate` on its first lines.
* The shared CSVs live once in `assets/code/data/<org>/` (decision
  2026-09-09: the Copperwind history is several megabytes and twelve
  copies would bloat the repo and the student zip). Every setup script
  loads from there. Chapter independence is unchanged: a chapter needs
  the pack, never saved work.
* Any chapter-specific fixture: a server log excerpt, a backup dump, a
  scan report, a flat export, a starter `pg_hba.conf`.
* `skills-lab-Na.sql` (starter script with numbered `\echo` markers)
  and `skills-lab-Na-answers.md` (starter answer file).
* `README.md`: the data dictionary, the load command, and the fictional
  disclaimer.

The student's one load command, run from the extracted `cis376` root:

```text
psql -U postgres -d postgres -f assets/code/chapter-01/setup-copperwind.sql
```

Every setup script begins by creating the target database if it does
not exist and connecting to it (`\connect`), so the student always
starts from `postgres`.

---

## 3. What every chapter receives

| Upgrade | Chapters | Form |
| --- | --- | --- |
| U1 Spine block | 1-12 | One Try It Yourself per chapter on a spine database, plus the Skills Lab |
| U2 Fading | 1-4 full worked SQL, 5-8 completion problem, 9-12 problem-first | The spine Try It Yourself carries the fading level |
| U3 Cumulative retrieval | 2-12 | 1-2 Retrieval Practice items labeled "From Chapter N:" |
| U4 Fix It block | 1-12 | One `### Fix It N.1: [Title] 🔧` per chapter, real captured error |
| U5 Subgoal labels | 1-12 | Step comments on the 1-2 most complex SQL or config examples |
| Backward callback | 2-12 | At least one genuine cross-chapter reference in section prose |

### 3.1 Locked counts (the structure checker enforces these)

* Exactly 3 MLOs, each ending with a `(Section N.X)` or
  `(Sections N.X-N.Y)` binding
* CLO alignment block present, quoting `CIS376_CLOs.md` elevated lines
  verbatim
* Exactly 5 Try It Yourself blocks per chapter, numbered N.1 to N.5 in
  reading order (one per main section, plus the spine block placed
  where the chapter's own logic puts it)
* Exactly 4 Quick Checks (one per main section)
* Equal counts of `**Predict:**`, `**Run:**`, `**Explain:**` labels
* Exactly 1 Fix It block with `**Symptom:**`, `**Diagnose:**`,
  `**Repair:**`, `**Verify:**` and no Predict, Run, or Explain labels
* Retrieval Practice: exactly 5 numbered items. Chapters 2-12 carry 1-2
  "From Chapter N:" items and at least 3 same-chapter items
* Questions & Analysis: exactly 2 numbered questions
* Section anatomy N.1-N.4, N.5 Summary and Retrieval, N.6 Skills Lab
  NA, N.7 Review Questions, Further Reading, Looking Ahead (Chapter 12:
  Course Conclusion: Where You Go from Here)
* Gap markers (`____`) appear only inside `text` fences

### 3.2 Length

600-700 lines of markdown per chapter. 8-15 runnable or displayed
code blocks. Typical SQL examples run 3-20 lines. A configuration
excerpt (`postgresql.conf`, `pg_hba.conf`) may run to 15 lines when the
whole excerpt is the point.

---

## 4. Per-chapter plan

| Ch | Spine TIY (database, task) | Fading | Fix It (real error to capture) | Retrieval from | Subgoal-label targets |
| --- | --- | --- | --- | --- | --- |
| 1 | copperwind_ops: run the baseline health query (sizes, roles, version) | A full | `psql: error: connection to server ... failed: FATAL: database "copperwind" does not exist` (wrong database name in the connect string) | none | the health-check query, the setup script's load sequence |
| 2 | copperwind_ops: measure table sizes and monthly ticket growth, project storage 36 months out | A full | `ERROR: function pg_size_pretty(double precision) does not exist` (a ratio cast to float multiplied into a byte count, cast to bigint fixes it. PostgreSQL 17 has a numeric overload, so the numeric variant first planned cannot occur) | Ch 1 | the growth projection query, the pg_hba.conf rule order walkthrough |
| 3 | sandwash_clinic: add a CHECK constraint on appointment status and watch a bad update fail inside a transaction | A full | `ERROR: insert or update on table "appointments" violates foreign key constraint` (loading children before parents) | Ch 1 | the 3NF decomposition script, the materialized view refresh |
| 4 | harquahala_academy: build the directory-information view that honors `directory_opt_out` | A full | Silent bug: a view built with `SELECT *` starts exposing a new sensitive column after `ALTER TABLE ... ADD COLUMN`. Wrong output, no error. Capture the before-and-after output | Ch 2 | the schema separation script (move PHI, grant USAGE, create view) |
| 5 | harquahala_academy: complete a gapped GRANT script for a teacher role and a row-level security policy on grades | B gaps | `ERROR: permission denied for schema academy` (GRANT on tables without USAGE on the schema) | Ch 3, Ch 1 | the role hierarchy script, the effective-privilege catalog query |
| 6 | sandwash_clinic: complete a gapped pgcrypto script that encrypts `insurance_member_id` and decrypts it for one authorized role | B gaps | `ERROR: Wrong key or corrupt data` (decrypting with the wrong passphrase) | Ch 4, Ch 2 | the encrypt-then-query pattern, the TLS verification sequence |
| 7 | sandwash_clinic: complete a gapped audit trigger on `visit_notes` and read back the trail | B gaps | `ERROR: control reached end of trigger procedure without RETURN` (trigger function missing `RETURN NEW`) | Ch 5, Ch 3 | the audit trigger function, the log-review classification query |
| 8 | harquahala_academy: complete a gapped index-and-measure script on `enrollments` and compare two EXPLAIN plans | B gaps | Silent bug: an index exists but `WHERE lower(last_name) = ...` forces a Seq Scan. Capture both plans | Ch 6, Ch 4 | the baseline-index-measure sequence, the backup plan table |
| 9 | copperwind_ops: given a shipped dump and a target, write and run the restore, then verify row counts against the plan | C problem-first | `ERROR: relation "tickets" already exists` (restoring a plain dump into a database that is not empty) | Ch 7, Ch 5 | the restore drill steps, the vulnerability ranking table |
| 10 | sandwash_clinic: given the shipped log excerpt and audit rows, write the queries that establish the breach timeline | C problem-first | Silent bug: a timeline query compares `timestamptz` values to naive strings in the wrong zone and shifts every event by 7 hours (Arizona has no daylight saving). Capture both outputs | Ch 8, Ch 6 | the scope analysis query set, the notification decision table |
| 11 | harquahala_academy: given the metric list, write the monthly review query set and the baseline comparison | C problem-first | `ERROR: pg_stat_statements must be loaded via "shared_preload_libraries"` (extension created but server not configured) | Ch 9, Ch 7 | the scheduled review script, the benchmark scoring table |
| 12 | all three: given the plan template, write the evidence queries that fill its architecture, access, and recovery sections | C problem-first | `ERROR: column "t.client_id" must appear in the GROUP BY clause or be used in an aggregate function` (the plan's summary query) | Ch 10, Ch 8 | the evidence query set, the skills matrix |

Fix It errors are captured from a real run against the shipped data
pack with the harness or with `psql`. Paste the final error line only.
Never invent an error message. The two silent bugs (Ch 4, Ch 8) and
the timezone bug (Ch 10) show wrong output instead of an error, so the
book carries three non-raising bugs.

---

## 5. Block formats (exact)

### 5.1 SQL example with verified output

Every runnable example is a `sql` fence. The output appears as
`-- Output:` comment lines at the end of the same block, exactly as
psql printed it (aligned table, row count line optional). The
harness verifies these lines.

```sql
-- Confirm the load before anyone builds on it.
SELECT COUNT(*) AS ticket_count
FROM tickets;
-- Output:
--  ticket_count
-- --------------
--         18240
```

Configuration excerpts, shell commands, and psql session transcripts
go in `text` or `bash` fences. They are not executed by the harness.
The author captures their output by hand and records the capture in
the execution notes.

### 5.2 Spine Try It Yourself

Heading: `### Try It Yourself N.M: [Title] 🛠️` where M is the block's
position in reading order. Exactly one `**Predict:**`, one
`**Run:**`, and one `**Explain:**` line.

**Level A (Ch 1-4), full worked:** complete runnable SQL in a `sql`
fence with verified `-- Output:` lines.

**Level B (Ch 5-8), completion problem:** the script with 1-3 gaps
written as `____` inside a `text` fence, followed by the real expected
output in a second `text` fence. Predict asks the student to commit to
what belongs in each gap and why. Run asks them to complete and run
it. Never put gapped code in a `sql` fence: the harness executes
those.

**Level C (Ch 9-12), problem-first:** the task, the files, the
expected output (real, from a reference solution), and at most a
one-line scaffold. Predict asks the student to name the approach and
the output they expect. Run asks them to write and run it and compare.

For levels B and C the author writes the reference solution, runs it,
and pastes the real output. The reference solution lives in
`docs/execution-logs/chapter-NN-reference.sql`, never in the chapter.

### 5.3 Fix It block

```markdown
### Fix It N.1: [Descriptive Title] 🔧

[One sentence of scenario context, spine or neutral.]

**Symptom:** [What the administrator tried and what went wrong.]

```text
[broken SQL or command]
```

```text
[the real final error line, or the wrong output]
```

**Diagnose:** [Name the cause in one sentence before touching the code.]

**Repair:** [Fix and rerun. State what changed.]

**Verify:** [How do you know it is fixed? Name the output or catalog
row that proves it.]
```

### 5.4 Subgoal labels

Numbered step comments inside the block name the decision, not the
syntax. Three to five steps. Never label single lines.

```sql
-- Step 1: Create the group role that owns the privilege set
CREATE ROLE clinic_frontdesk NOLOGIN;
-- Step 2: Open the schema door before granting anything inside it
GRANT USAGE ON SCHEMA clinic TO clinic_frontdesk;
-- Step 3: Grant the minimum-necessary view, never the base table
GRANT SELECT ON clinic.patient_directory TO clinic_frontdesk;
```

### 5.5 Cumulative retrieval

Retrieval Practice items 4 and 5 (or item 5 alone) begin
`From Chapter N:` and are answerable from memory. Items 1-3 stay on
the current chapter.

---

## 6. SQL and configuration conventions

* Keywords in UPPERCASE, identifiers in lowercase snake_case, one
  clause per line, two-space indentation inside subqueries.
* Semantic names: `clinic_frontdesk`, not `role1`. Table aliases are
  short but meaningful (`p` for patients only inside a two-table
  query).
* Every role a chapter creates is prefixed by the organization:
  `copperwind_`, `clinic_`, `academy_`. Setup scripts drop those roles
  first so reruns are clean.
* Every example that changes server state (`ALTER SYSTEM`, `GRANT`,
  extension creation) is followed by the query that proves the change
  took effect. Configuration without verification is banned.
* PostgreSQL-only syntax is marked the first time it appears in a
  chapter ("`\du` is a psql meta-command, not SQL").
* Passwords in examples are visibly fake and never reused across
  chapters: `Sandwash-Demo-2026!` style, and the prose says to replace
  them.
* The student superuser is `postgres`. The book never asks students to
  work as `postgres` after Chapter 1 except to create roles.

---

## 7. Deliverable and rubric

Every Skills Lab deliverable is one folder `skills-lab-Na-lastname`
containing:

1. `skills-lab-Na.sql`: the executed script, with `\echo` markers
   between parts and results pasted as `-- Output:` comments, or the
   saved psql output file beside it.
2. `skills-lab-Na-answers.md`: the written parts (plans, policies,
   matrices, memos) and the two Questions & Analysis answers.

The rubric is the family's universal Skills Lab rubric, transcluded in
Chapter 1 and linked from Chapters 2-12. In this course the four
criteria read as:

* Technical Accuracy and Efficiency: the controls work on the server
  and the evidence queries prove it
* Output Quality: plans, matrices, and reports a manager could act on
* Documentation Quality: every configuration choice says why
* Analysis, Interpretation, and Response to QUESTION(s): the two
  questions, answered with evidence

---

## 8. QA protocol (every chapter, before it is called done)

1. `python3 tools/run_chapter_sql.py book/chapters/chapter-NN.md`
   creates fresh databases from the chapter folder, runs every `sql`
   block in order, and writes `docs/execution-logs/chapter-NN.log`.
   Zero failures.
2. `python3 tools/check_output_comments.py book/chapters/chapter-NN.md`
   confirms every `-- Output:` line matches the log.
3. `python3 tools/check_course_structure.py book/chapters/chapter-NN.md`
   passes with zero errors (Section 3.1 counts).
4. `python3 tools/check_sentence_length.py book/chapters/chapter-NN.md`
   reports nothing.
5. `python3 tools/check_readability.py` shows the chapter inside the
   approved band (60-70 target, 55 floor for the two regulation-heavy
   chapters, 4 and 10, recorded in CLAUDE.md).
6. Style sweeps: em dash (U+2014), semicolons in prose outside code,
   banned vocabulary and filler from `style-guide-core.md`,
   "real-world", "soft skills", "prepare you for".
7. Glossary: every bolded first-use term has a glossary entry in the
   definition-list format. Key Terms lists point to the glossary.
8. Further Reading URLs verified live at draft time (curl or browser).
   Government and standards sites (NIST, HHS, ED.gov, OWASP,
   PostgreSQL docs) preferred.
9. `zensical build --clean` completes with no warnings.
10. Fictional disclaimer present in the chapter README. Zero real
    organization names outside Further Reading and standards bodies.

---

## 9. Execution notes

The harness runs against the local PostgreSQL 17 cluster
(`/opt/homebrew/opt/postgresql@17`, data directory
`/opt/homebrew/var/postgresql@17`, bootstrap superuser `postgres`,
trust auth on localhost, `LC_ALL=en_US.UTF-8` required to start). The
harness rebuilds the three databases under their real names before
every chapter run, so `current_database()`, connect messages, and
column widths match what a student sees. A file lock serializes runs.
Roles are cluster-wide, so the harness drops any role prefixed
`copperwind_`, `clinic_`, or `academy_` before a chapter run, and
chapter authors never paste `\du` output (it would list the author's
cluster, not the student's). Use catalog queries filtered to the
course prefixes instead.

Workflow for an author: draft the chapter with `-- Output:` markers
left empty, run `run_chapter_sql.py`, run `fill_sql_outputs.py` to
paste the captured output, review the diff, then run
`check_sql_outputs.py` and the rest of the battery.
