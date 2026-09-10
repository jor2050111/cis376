# Chapter 4 Data Pack: Compliance, Separation, and Retention

Chapter 4 works in the clinic database and the school database. Run
each setup script from the extracted `cis376` folder:

```text
psql -U postgres -d postgres -f assets/code/chapter-04/setup-sandwash.sql
psql -U postgres -d postgres -f assets/code/chapter-04/setup-harquahala.sql
```

## Contents

| File | Purpose |
| ---- | ------- |
| `setup-sandwash.sql` | Creates `sandwash_clinic` and loads the clinic's providers, patients, appointments, visit notes, and staff accounts |
| `setup-harquahala.sql` | Creates `harquahala_academy` and loads the school's students, guardians, staff, courses, sections, enrollments, grades, and portal accounts |
| `skills-lab-4a.sql` | Starter script for Skills Lab 4A with numbered markers for each part |
| `skills-lab-4a-answers.md` | Starter answer file with the classification register, the separation notes, the memo, and the two Questions & Analysis answers |
| `retention-policy-template.md` | Fictional retention and disposal policy template that Part 3 of the lab completes |

The CSV files the scripts load live in `assets/code/data/`. Its README
holds the data dictionary for every table.

## Which parts of the chapter use which files

| Chapter part | Database | Files |
| ------------ | -------- | ----- |
| Section 4.1 (HIPAA, minimum necessary) | `sandwash_clinic` | `setup-sandwash.sql` |
| Section 4.2 and Try It Yourself 4.2 (FERPA, directory view) | `harquahala_academy` | `setup-harquahala.sql` |
| Section 4.3 and Fix It 4.1 (schemas, views, separation) | both | both setup scripts |
| Section 4.4 (retention, legal holds, disposal) | `sandwash_clinic` | `setup-sandwash.sql` |
| Skills Lab 4A | `sandwash_clinic` | `setup-sandwash.sql`, `skills-lab-4a.sql`, `skills-lab-4a-answers.md`, `retention-policy-template.md` |

Rerun a setup script whenever you want a clean copy. Section 4.4 and
the lab both delete rows from `visit_notes`, and the script restores
them.

## Fictional data

Copperwind IT Services, Sandwash Family Clinic, and Harquahala Charter
Academy are fictional organizations created for this textbook. All
names, patients, students, staff, and records are synthetic. Any
resemblance to a real organization or person is coincidental.
