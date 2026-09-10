# Chapter 9 Data Pack: Disaster Recovery and Vulnerability Management

Chapter 9 works in two databases. Copperwind carries the spine restore
drill and most of the reading. The clinic carries the Skills Lab. Run
each setup script from the extracted `cis376` folder:

```text
psql -U postgres -d postgres -f assets/code/chapter-09/setup-copperwind.sql
psql -U postgres -d postgres -f assets/code/chapter-09/setup-sandwash.sql
```

## Contents

| File | Purpose |
| ---- | ------- |
| `setup-copperwind.sql` | Creates `copperwind_ops` and loads Copperwind's clients, technicians, tickets, notes, and login events |
| `setup-sandwash.sql` | Creates `sandwash_clinic` and loads the clinic's providers, patients, appointments, visit notes, and staff accounts |
| `copperwind_ops-backup.sql` | Plain-format `pg_dump` backup of `copperwind_ops`. Section 9.2 and Try It Yourself 9.2 restore it into a throwaway drill database |
| `sandwash_clinic-backup.sql` | Plain-format `pg_dump` backup of `sandwash_clinic`. Skills Lab 9A restores it in the clinic's recovery drill |
| `copperwind-scan-report.md` | A fictional configuration scan of the clinic's PostgreSQL host, benchmark style, with findings Skills Lab 9A ranks |
| `skills-lab-9a.sql` | Starter script for Skills Lab 9A with numbered markers for each part |
| `skills-lab-9a-answers.md` | Starter answer file for the recovery plan, the drill record, the ranked findings, and the two Questions & Analysis answers |

The CSV files the setup scripts load live in `assets/code/data/`. Its
README holds the data dictionary for every table.

## Which parts use which files

| Chapter part | Database or file | Script |
| ------------ | ---------------- | ------ |
| Sections 9.1, 9.3, 9.4 | `copperwind_ops` | `setup-copperwind.sql` |
| Section 9.2, Try It Yourself 9.2 (restore drill) | `copperwind_ops`, `copperwind_ops-backup.sql` | `setup-copperwind.sql` |
| Skills Lab 9A | `sandwash_clinic`, `sandwash_clinic-backup.sql`, `copperwind-scan-report.md` | `setup-sandwash.sql`, `skills-lab-9a.sql`, `skills-lab-9a-answers.md` |

The restore drill creates a throwaway database (`copperwind_restore_drill`
in the chapter, `clinic_restore_drill` in the lab), verifies the restore,
and drops it. Nothing you create in the drill outlives it, and the two
backup files are read-only inputs you never edit.

## Fictional data

Copperwind IT Services, Sandwash Family Clinic, and Harquahala Charter
Academy are fictional organizations created for this textbook. All
names, patients, students, staff, and records are synthetic. Any
resemblance to a real organization or person is coincidental.
