# Chapter 12 Data Pack: Current Practice, Future Trends, and Capstone

Chapter 12 is the capstone, so it works in all three databases. The
reading uses each one in turn, and Skills Lab 12A uses the single
organization you choose. Run the setup scripts you need from the
extracted `cis376` folder:

```text
psql -U postgres -d postgres -f assets/code/chapter-12/setup-copperwind.sql
psql -U postgres -d postgres -f assets/code/chapter-12/setup-sandwash.sql
psql -U postgres -d postgres -f assets/code/chapter-12/setup-harquahala.sql
```

## Contents

| File | Purpose |
| ---- | ------- |
| `setup-copperwind.sql` | Creates `copperwind_ops` and loads Copperwind's clients, technicians, tickets, notes, and login events |
| `setup-sandwash.sql` | Creates `sandwash_clinic` and loads the clinic's providers, patients, appointments, visit notes, and staff accounts |
| `setup-harquahala.sql` | Creates `harquahala_academy` and loads the academy's students, guardians, staff, courses, sections, enrollments, grades, and portal accounts |
| `management-security-plan-template.md` | The nine-section plan skeleton the capstone fills, with a prompt under each heading and blank tables for access, compliance, the skills matrix, and open items |
| `skills-lab-12a.sql` | Starter script for Skills Lab 12A with numbered markers for each part |
| `skills-lab-12a-answers.md` | Starter answer file for the plan, the adoption decision, the conditional recommendation, the skills matrix, and the two Questions & Analysis answers |

The CSV files the setup scripts load live in `assets/code/data/`. Its
README holds the data dictionary for every table.

## Which parts use which files

| Chapter part | Database or file | Script |
| ------------ | ---------------- | ------ |
| Section 12.1 (migration history) | `copperwind_ops` | `setup-copperwind.sql` |
| Section 12.1 (governance inventory) | `sandwash_clinic` | `setup-sandwash.sql` |
| Section 12.2 (index proposal, keyword search) | `copperwind_ops` | `setup-copperwind.sql` |
| Section 12.2 (re-identification check) | `harquahala_academy` | `setup-harquahala.sql` |
| Section 12.4, Fix It 12.1 | `copperwind_ops` | `setup-copperwind.sql` |
| Try It Yourself 12.5 | all three | all three setup scripts |
| Skills Lab 12A | the one you choose | the matching setup script, `management-security-plan-template.md`, `skills-lab-12a.sql`, `skills-lab-12a-answers.md` |

Section 12.1 creates a `deploy` schema in `copperwind_ops` and Section
12.2 creates an index on `tickets(status)`. Section 12.4 creates the
role `copperwind_reporting`. Rerunning `setup-copperwind.sql` clears
the index and the role, and the `deploy` schema can be dropped with
`DROP SCHEMA deploy CASCADE;` when you want a clean copy.

## Fictional data

Copperwind IT Services, Sandwash Family Clinic, and Harquahala Charter
Academy are fictional organizations created for this textbook. All
names, patients, students, staff, and records are synthetic. Any
resemblance to a real organization or person is coincidental.
