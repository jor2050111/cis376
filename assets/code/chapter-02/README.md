# Chapter 2 Data Pack: Infrastructure and Requirements

Chapter 2 measures Copperwind's operations database and sizes the
clinic's. Run each setup script from the extracted `cis376` folder:

```text
psql -U postgres -d postgres -f assets/code/chapter-02/setup-copperwind.sql
psql -U postgres -d postgres -f assets/code/chapter-02/setup-sandwash.sql
```

## Contents

| File | Purpose |
| ---- | ------- |
| `setup-copperwind.sql` | Creates `copperwind_ops` and loads Copperwind's clients, technicians, tickets, notes, and login events |
| `setup-sandwash.sql` | Creates `sandwash_clinic` and loads the clinic's providers, patients, appointments, visit notes, and staff accounts |
| `pg_hba-starter.conf` | A small fictional `pg_hba.conf` you read and edit in Skills Lab 2A, Part 3. Comments explain the five columns. Never copy it onto a real server |
| `skills-lab-2a.sql` | Starter script for Skills Lab 2A with numbered markers for each part |
| `skills-lab-2a-answers.md` | Starter answer file for the measurement, projection, and service model tables, the placement diagram, the corrected rule file, and the two Questions & Analysis answers |

The CSV files the scripts load live in `assets/code/data/`. Its README
holds the data dictionary for every table.

## Which parts use which files

| Chapter part | Database | Files |
| ------------ | -------- | ----- |
| Sections 2.2 and 2.3 (settings, `pg_hba_file_rules`, roles) | `copperwind_ops` | `setup-copperwind.sql` |
| Section 2.4 and Try It Yourself 2.4 (sizes, growth, throughput, projection) | `copperwind_ops` | `setup-copperwind.sql` |
| Fix It 2.1 | `copperwind_ops` | `setup-copperwind.sql` |
| Skills Lab 2A, Parts 1 and 2 | `sandwash_clinic` | `setup-sandwash.sql`, `skills-lab-2a.sql`, `skills-lab-2a-answers.md` |
| Skills Lab 2A, Part 3 | none (paper and text) | `pg_hba-starter.conf`, `skills-lab-2a-answers.md` |

The addresses in `pg_hba-starter.conf` and in the chapter's placement
diagram are fictional private and documentation ranges. They do not
point at any real network.

## Fictional data

Copperwind IT Services, Sandwash Family Clinic, and Harquahala Charter
Academy are fictional organizations created for this textbook. All
names, patients, students, staff, and records are synthetic. Any
resemblance to a real organization or person is coincidental.
