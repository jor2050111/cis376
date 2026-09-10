# Chapter 5 Data Pack: Access Control and Role-Based Security

Chapter 5 works in two databases. The clinic carries the Skills Lab
and most of the reading. The academy carries the spine Try It Yourself
and the Fix It. Run each script from the extracted `cis376` folder:

```text
psql -U postgres -d postgres -f assets/code/chapter-05/setup-sandwash.sql
psql -U postgres -d postgres -f assets/code/chapter-05/setup-harquahala.sql
```

## Contents

| File | Purpose |
| ---- | ------- |
| `setup-sandwash.sql` | Chapter-specific. Creates `sandwash_clinic`, loads the clinic tables, drops every `clinic_` role, then recreates the two login roles the clinic's previous host left behind (`clinic_backup_svc`, `clinic_reports_svc`). Skills Lab 5A reviews those roles against the matrix |
| `setup-harquahala.sql` | Creates `harquahala_academy` and loads the school's tables. No roles. The chapter builds `staff_logins` and the teacher role on top of it |
| `skills-lab-5a.sql` | Starter script for Skills Lab 5A with numbered markers for each part |
| `skills-lab-5a-answers.md` | Starter answer file with the access control matrix, the row-count comparison, the access review record, and the two Questions & Analysis answers |

The CSV files the scripts load live in `assets/code/data/`. Its README
holds the data dictionary for every table.

## Which parts use which files

| Chapter part | Database | Script |
| ------------ | -------- | ------ |
| Sections 5.1, 5.2 (front desk, default privileges), 5.3 (hierarchy, row-level security), 5.4 | `sandwash_clinic` | `setup-sandwash.sql` |
| Fix It 5.1, the `staff_logins` mapping, Try It Yourself 5.3 | `harquahala_academy` | `setup-harquahala.sql` |
| Skills Lab 5A | `sandwash_clinic` | `setup-sandwash.sql`, `skills-lab-5a.sql`, `skills-lab-5a-answers.md` |

Rerunning `setup-sandwash.sql` removes every role whose name starts
with `clinic_`, including the ones you create while reading, and puts
the two inherited roles back. Run it once more before you start the
lab so your review starts from the same state as the book.

## Fictional data

Copperwind IT Services, Sandwash Family Clinic, and Harquahala Charter
Academy are fictional organizations created for this textbook. All
names, patients, students, staff, and records are synthetic. Any
resemblance to a real organization or person is coincidental.
