# Chapter 7 Data Pack: Auditing and Log Management

Chapter 7 works in two databases and one shipped server log. Copperwind
carries the logging configuration, the log review, and the Skills Lab.
The clinic carries the trigger-based audit trail, the spine Try It
Yourself, and the Fix It. Run each script from the extracted `cis376`
folder:

```text
psql -U postgres -d postgres -f assets/code/chapter-07/setup-copperwind.sql
psql -U postgres -d postgres -f assets/code/chapter-07/setup-sandwash.sql
```

## Contents

| File | Purpose |
| ---- | ------- |
| `setup-copperwind.sql` | Creates `copperwind_ops` and loads Copperwind's clients, technicians, tickets, notes, and login events. No roles. The chapter creates `copperwind_reports` on top of it |
| `setup-sandwash.sql` | Creates `sandwash_clinic` and loads the clinic's providers, patients, appointments, visit notes, and staff accounts. No roles. The chapter builds `audit_log`, the trigger functions, and `clinic_scheduler_app` on top of it |
| `postgresql-2026-08-14.log` | One day of Copperwind's server log, 599 lines, written with the prefix `%m [%p] %u@%d `. Section 7.4 loads and classifies it. Skills Lab 7A reviews it. The file is fictional and was produced for this textbook |
| `skills-lab-7a.sql` | Starter script for Skills Lab 7A with numbered markers for each part |
| `skills-lab-7a-answers.md` | Starter answer file with the auditing plan, the `SHOW` transcript, the data security review record, and the two Questions & Analysis answers |

The CSV files the scripts load live in `assets/code/data/`. Its README
holds the data dictionary for every table.

## What the shipped log contains

`postgresql-2026-08-14.log` holds three kinds of line:

* 420 `connection authorized` lines for five accounts (`copperwind_app`,
  `copperwind_reports`, `ecole`, `mlin`, `nredhouse`) between 06:04 and
  18:55.
* 59 `statement:` lines. Fifty-eight are the same `SELECT count(*)`
  on `tickets`. One, at 15:42:09, is
  `ALTER ROLE copperwind_reports WITH SUPERUSER` run by `ecole`.
* 60 `FATAL: password authentication failed` lines for `postgres`
  between 02:11:00 and 02:15:55, one every five seconds, each followed
  by a `DETAIL` line naming `pg_hba.conf` line 12.

The prefix carries the role and database but not the client address.
Section 7.4 treats that gap as a finding.

## Which parts use which files

| Chapter part | Database or file | Script |
| ------------ | ---------------- | ------ |
| Section 7.1 (`login_events`), 7.2 (settings, scopes), 7.4 (log review) | `copperwind_ops`, `postgresql-2026-08-14.log` | `setup-copperwind.sql` |
| Section 7.3 (audit trail), Try It Yourself 7.3, Fix It 7.1 | `sandwash_clinic` | `setup-sandwash.sql` |
| Skills Lab 7A | `copperwind_ops`, `postgresql-2026-08-14.log` | `setup-copperwind.sql`, `skills-lab-7a.sql`, `skills-lab-7a-answers.md` |

Two settings the chapter makes outlive a rerun of the setup scripts,
because the scripts rebuild tables, not databases or roles:
`ALTER DATABASE copperwind_ops SET log_statement = 'ddl'` and the
`log_statement = 'all'` attached to `copperwind_reports`. Remove them
with `ALTER DATABASE copperwind_ops RESET log_statement` and
`ALTER ROLE copperwind_reports RESET log_statement` when you want a
clean server. The `postgresql.conf` edits in Section 7.2 and Skills
Lab 7A are made on your own server and stay until you change them.

## Fictional data

Copperwind IT Services, Sandwash Family Clinic, and Harquahala Charter
Academy are fictional organizations created for this textbook. All
names, patients, students, staff, and records are synthetic. Any
resemblance to a real organization or person is coincidental.
