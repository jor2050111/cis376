# CIS376 Textbook Style Guide

This file holds the course-specific layer only. The canonical shared
writing law lives at `../shared/style-guide-core.md` in the textbooks
workspace. The sync script copies it into this repo as
`docs/style-guide-core.md`. Read the core first. Never edit the synced
copy, and never restate core rules here. When this file and the core
disagree, this file wins for CIS376 only.

## Audience and Tone Calibration

Calibrate the core's tone invariants for community college students
who have completed one SQL course and are moving into database
administration and security.

* **Assumed background:** one SQL course on Oracle, MySQL, or SQL
  Server (Introduction to Oracle: SQL, CIS276DA, or CIS276DB).
  Students can write joins, aggregates, and CREATE TABLE with keys.
  They have never administered a server, granted a privilege, or
  restored a backup.
* **Register:** collegial and professional. The student is
  Copperwind's database administrator, a practitioner with a manager
  (Mei Lin) and a security reviewer (Naomi Redhouse). Write to a
  colleague who is new to the job, not to a beginner.
* **Reading level:** Flesch Reading Ease 60-70. Chapters 4 and 10 may
  land as low as 55 because HIPAA, FERPA, and breach-notification
  vocabulary is long and cannot be shortened without losing accuracy.
  Recorded 2026-09-09, pending Mr. Vega's confirmation.
* **Bridging rule:** one sentence names what the prerequisite taught,
  then the chapter extends it. "You have written CREATE TABLE with a
  foreign key. This chapter treats that key as a security control."
  Never a paragraph of review, never a SQL tutorial.
* **Management first:** every section answers a management or
  security question before it shows syntax. If a paragraph teaches SQL
  for its own sake, cut it.

## Bloom's-Level Emphasis for CIS376

The shared framework lives in `docs/blooms-taxonomy-reference.md`.

* **Primary levels:** Apply, Analyze, Evaluate. Every chapter carries
  at least one Analyze or Evaluate MLO.
* **Occasional levels:** Create, in the design and planning chapters
  (2, 3, 4, 5, 7, 8, 9, 10, 11, 12).
* **Avoided levels:** Remember and Understand never appear as MLO
  levels. They may appear in Quick Check and Review Question tags,
  where recall of a regulation's terms is a fair ask.
* **Distribution across the book:** Part I leans Apply and Analyze
  with one Create. Parts II and III balance Apply, Analyze, and
  Create. Part IV leans Evaluate and Create.

## Tech-Stack Conventions for PostgreSQL 17, psql, pgAdmin 4, SQL

* **Code fence identifiers:** `sql` for anything the harness should
  execute against a chapter database (SQL statements and psql
  meta-commands together are fine). `text` for configuration
  excerpts, psql transcripts, gapped completion problems, broken Fix
  It code, and captured errors. `bash` for shell commands such as
  `pg_dump` and `psql -f`. Never a bare fence.
* **Language style standard:** SQL keywords UPPERCASE, identifiers
  lowercase snake_case, one clause per line, two-space indentation
  inside subqueries and CASE expressions, a trailing semicolon on
  every statement. Semicolons are SQL syntax and are exempt from the
  prose ban.
* **Naming scheme:** semantic names everywhere. Roles carry an
  organization prefix (`copperwind_`, `clinic_`, `academy_`).
  Schemas are named for their boundary (`clinic`, `clinic_restricted`,
  `academy`, `academy_directory`). Views say what they filter
  (`patient_directory`, `grades_for_teacher`). Audit tables end in
  `_audit`.
* **Verified output:** every executed block ends with `-- Output:`
  comment lines copied from the harness log. A block that produces no
  rows ends with the psql tag it printed (`-- Output:` then
  `-- CREATE ROLE`, `-- GRANT`, and so on).
* **Version targets:** PostgreSQL 17, psql 17, pgAdmin 4 current
  release. Extensions: pgcrypto, pg_stat_statements.
* **Capitalization table:**

| Term | Correct | Incorrect |
| ---- | ------- | --------- |
| PostgreSQL | PostgreSQL | Postgres, PostGreSQL, postgresql (in prose) |
| psql | psql | PSQL, Psql |
| pgAdmin | pgAdmin | PGAdmin, PgAdmin, pgadmin |
| pgcrypto | `pgcrypto` | PGCrypto |
| pg_dump | `pg_dump` | pgdump, PG Dump |
| pg_hba.conf | `pg_hba.conf` | pg_hba, HBA file (after first use) |
| row-level security | row-level security | Row Level Security, RLS (spell out first) |
| role | role | user (for a PostgreSQL login) |
| HIPAA | HIPAA | HIPPA |
| FERPA | FERPA | Ferpa |
| on-premise | on-premise | on-prem, on premises (in prose) |
| WAL | write-ahead log (WAL) | Write Ahead Log |

## Dataset and Example-Domain Conventions

* **Example domains:** the spine (Copperwind IT Services, Sandwash
  Family Clinic, Harquahala Charter Academy) claims one Try It
  Yourself and the Skills Lab in each chapter. Other examples use
  varied fictional cover stories: a law office, a food bank, a bike
  shop, a city parks department, a credit union. Never a real
  company, hospital, or school.
* **Provided files:** `assets/code/chapter-NN/` ships setup scripts,
  CSVs, fixtures (logs, dumps, scan reports), and starter deliverable
  files. Students run one `psql -f` command from the extracted
  `cis376` root. The pattern is fixed in CLAUDE.md.
* **Rules for new datasets or fixtures:** seeded synthetic data from
  `assets/code/_generators/` with base seed 376, byte-identical on
  rerun, with asserts for every engineered property a chapter depends
  on. A fixture the generator cannot produce (a server log excerpt, a
  backup dump) is produced by a documented script or command recorded
  in the generator README.
* **What students never hand-type:** table data, log files, backup
  files, policy templates. The exception is short DDL and GRANT
  statements, where typing the statement is the lesson.
* **Real names and numbers:** synthetic NPI numbers, phone numbers in
  the 555 range, email addresses on `example.org` or `example.edu`,
  street addresses that do not exist. Regulation citations (45 CFR
  164, 34 CFR 99) are real and must be accurate.
