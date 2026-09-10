# Chapter 10 Data Pack: Incident Response

Chapter 10 works in two databases. The academy carries the worked
investigation and the Skills Lab. The clinic carries the spine Try It
Yourself on containment. Run each setup script from the extracted
`cis376` folder:

```text
psql -U postgres -d postgres -f assets/code/chapter-10/setup-harquahala.sql
psql -U postgres -d postgres -f assets/code/chapter-10/setup-sandwash.sql
```

Both scripts are chapter-specific. They create logins as well as tables,
because Chapter 10 starts from the state a server was in on the morning
of an incident. Rerunning either script drops and recreates every table
and every role it owns.

## Contents

| File | Purpose |
| ---- | ------- |
| `setup-harquahala.sql` | Creates `harquahala_academy`, loads the students, guardians, staff, courses, sections, enrollments, grades, and portal accounts, and creates the `academy_app` and `academy_reports` logins with the over-grant of 2026-08-30 in place |
| `setup-sandwash.sql` | Creates `sandwash_clinic`, loads the clinic tables, and creates the `clinic_gyazzie` front desk login that Try It Yourself 10.3 contains |
| `postgresql-2026-09-03.log` | 301 lines of the academy's server log, written with the prefix `%m [%p] %u@%d `, covering 2026-09-02 morning through 2026-09-03 early morning. Section 10.2 and Skills Lab 10A parse it |
| `academy_audit_trail.csv` | 141 rows of the academy's application audit trail, 2026-08-13 through 2026-09-01, with the privilege grant that is the incident's root cause |
| `after-action-report-template.md` | The report skeleton Skills Lab 10A fills in, with all seven sections and the test each one must pass |
| `skills-lab-10a.sql` | Starter script for Skills Lab 10A with numbered markers for each part |
| `skills-lab-10a-answers.md` | Starter answer file for the scope answers, the containment record, the response plan, the notification decision, and the two Questions & Analysis answers |

The CSV files the setup scripts load live in `assets/code/data/`. Its
README holds the data dictionary for every table.

## Data dictionary: academy_audit_trail.csv

| Column | Type | Notes |
| ------ | ---- | ----- |
| `audit_id` | integer | Sequential, 1 through 141 |
| `changed_at` | timestamp | Naive, no zone in the file. The academy's server runs Mountain Standard Time, so load it as `timestamptz` with `SET TimeZone = 'America/Phoenix'` first |
| `db_user` | text | The login that made the change |
| `table_name` | text | The table changed, or `pg_authid` for a privilege change |
| `operation` | text | `INSERT`, `UPDATE`, or `GRANT` |
| `row_summary` | text | Which row changed, or the full statement for a `GRANT` |

## Which parts use which files

| Chapter part | Database or file | Script |
| ------------ | ---------------- | ------ |
| Sections 10.1, 10.3 | No database needed | None |
| Section 10.2, Fix It 10.1 | `harquahala_academy`, `postgresql-2026-09-03.log`, `academy_audit_trail.csv` | `setup-harquahala.sql` |
| Try It Yourself 10.3 | `sandwash_clinic` | `setup-sandwash.sql` |
| Section 10.4 | `harquahala_academy`, both evidence files | `setup-harquahala.sql` |
| Skills Lab 10A | `harquahala_academy`, both evidence files, `after-action-report-template.md` | `setup-harquahala.sql`, `skills-lab-10a.sql`, `skills-lab-10a-answers.md` |

## A note on the evidence files

The log and the audit trail are read-only inputs. You load them into
tables, query those tables, and never edit the files. The address
`198.51.100.23` in the log belongs to a block reserved for documentation
(RFC 5737) and routes nowhere. The passwords in the setup scripts are
visibly fake and belong to a lab copy only. Replace them on any server
that is not one.

## Fictional data

Copperwind IT Services, Sandwash Family Clinic, and Harquahala
Charter Academy are fictional organizations created for this textbook.
All names, patients, students, staff, and records are synthetic. Any
resemblance to a real organization or person is coincidental.
