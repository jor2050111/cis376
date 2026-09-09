# Chapter 1 Data Pack: The Three Course Databases

Chapter 1 loads all three databases you manage for the rest of the
book. Run each script from the extracted `cis376` folder:

```text
psql -U postgres -d postgres -f assets/code/chapter-01/setup-copperwind.sql
psql -U postgres -d postgres -f assets/code/chapter-01/setup-sandwash.sql
psql -U postgres -d postgres -f assets/code/chapter-01/setup-harquahala.sql
```

## Contents

| File | Purpose |
| ---- | ------- |
| `setup-copperwind.sql` | Creates `copperwind_ops` and loads Copperwind's clients, technicians, tickets, notes, and login events |
| `setup-sandwash.sql` | Creates `sandwash_clinic` and loads the clinic's providers, patients, appointments, visit notes, and staff accounts |
| `setup-harquahala.sql` | Creates `harquahala_academy` and loads the school's students, guardians, staff, courses, sections, enrollments, grades, and portal accounts |
| `skills-lab-1a.sql` | Starter script for Skills Lab 1A with numbered markers for each part |
| `skills-lab-1a-answers.md` | Starter answer file for the written parts and the two Questions & Analysis answers |

The CSV files the scripts load live in `assets/code/data/`. Its README
holds the data dictionary for every table.

## Which chapters use these databases

Every chapter. Each later chapter folder ships its own copy of the
setup scripts it needs, so you can rebuild any database at any time
without touching earlier work.

## Fictional data

Copperwind IT Services, Sandwash Family Clinic, and Harquahala Charter
Academy are fictional organizations created for this textbook. All
names, patients, students, staff, and records are synthetic. Any
resemblance to a real organization or person is coincidental.
