# Chapter 8 Data Pack: Performance Tuning and Redundancy

Chapter 8 works in two databases. Copperwind's operations database
carries the Skills Lab and most of the reading. The academy carries
the spine Try It Yourself and the Fix It. Run each script from the
extracted `cis376` folder:

```text
psql -U postgres -d postgres -f assets/code/chapter-08/setup-copperwind.sql
psql -U postgres -d postgres -f assets/code/chapter-08/setup-harquahala.sql
```

## Contents

| File | Purpose |
| ---- | ------- |
| `setup-copperwind.sql` | Creates `copperwind_ops` and loads Copperwind's clients, technicians, tickets, notes, and login events. The Skills Lab tunes three slow reports on it |
| `setup-harquahala.sql` | Creates `harquahala_academy` and loads the school's tables. The spine exercise indexes `enrollments` and the Fix It repairs a name search on `students` |
| `skills-lab-8a.sql` | Starter script for Skills Lab 8A with numbered markers for each part |
| `skills-lab-8a-answers.md` | Starter answer file with the baseline table, the before-and-after plans, the redundancy plan, and the two Questions & Analysis answers |
| `redundancy-plan-template.md` | Blank one-row-per-database backup and replication plan to fill in Part 3 |

The CSV files the scripts load live in `assets/code/data/`. Its README
holds the data dictionary for every table.

## Which parts use which files

| Chapter part | Database | Script |
| ------------ | -------- | ------ |
| Sections 8.1, 8.2 (EXPLAIN, indexes, VACUUM, work_mem), 8.3, 8.4 | `copperwind_ops` | `setup-copperwind.sql` |
| Try It Yourself 8.2, Fix It 8.1 | `harquahala_academy` | `setup-harquahala.sql` |
| Skills Lab 8A | `copperwind_ops` | `setup-copperwind.sql`, `skills-lab-8a.sql`, `skills-lab-8a-answers.md` |

Rerunning either setup script rebuilds that database from the shared
CSVs, so you can start any exercise from a clean, freshly analyzed
table. Run `setup-copperwind.sql` once more before the lab so your
baseline measurements start from the same state as the book.

## Fictional data

Copperwind IT Services, Sandwash Family Clinic, and Harquahala Charter
Academy are fictional organizations created for this textbook. All
names, patients, students, staff, and records are synthetic. Any
resemblance to a real organization or person is coincidental.
