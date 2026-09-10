# Chapter 3 Data Pack: Data Modeling and Integrity

Chapter 3 works on two databases. Run each script from the extracted
`cis376` folder:

```text
psql -U postgres -d postgres -f assets/code/chapter-03/setup-sandwash.sql
psql -U postgres -d postgres -f assets/code/chapter-03/setup-harquahala.sql
```

Both scripts drop and rebuild their tables, so you can rerun either one
at any time to start clean.

## Contents

| File | Purpose |
| ---- | ------- |
| `setup-sandwash.sql` | Creates `sandwash_clinic` and loads the clinic's providers, patients, appointments, visit notes, and staff accounts |
| `setup-harquahala.sql` | Creates `harquahala_academy` and loads the school's students, guardians, staff, courses, sections, enrollments, grades, and portal accounts |
| `harquahala_gradebook_export.csv` | The flat gradebook export for Skills Lab 3A: 1,201 rows with the columns `student_name`, `grade_level`, `course_name`, `term`, `teacher_name`, `term_grade`. It contains planted anomalies that Part 1 of the lab asks you to find |
| `skills-lab-3a.sql` | Starter script for Skills Lab 3A with numbered markers for each part |
| `skills-lab-3a-answers.md` | Starter answer file for the anomaly table, the schema table, the memo, and the two Questions & Analysis answers |

The CSV files the setup scripts load live in `assets/code/data/`. Its
README holds the data dictionary for every table.

## Which parts use which files

| Part of the chapter | Database | Files |
| --- | --- | --- |
| Sections 3.1 through 3.4, including Try It Yourself 3.2 and Fix It 3.1 | `sandwash_clinic` | `setup-sandwash.sql` |
| Skills Lab 3A | `harquahala_academy` | `setup-harquahala.sql`, `harquahala_gradebook_export.csv`, `skills-lab-3a.sql`, `skills-lab-3a-answers.md` |

Try It Yourself 3.1, 3.3, and 3.5 are paper exercises. Try It Yourself
3.4 uses literal JSON values and runs in any database.

## The gradebook export

`harquahala_gradebook_export.csv` was produced by the course data
generator as a denormalized copy of the first 1,200 enrollments in
`harquahala_academy`, joined to their students, sections, courses,
staff, and grades, with the keys removed. Three anomalies were planted
on purpose. The lab asks you to find them with queries, so this README
does not list them.

Load it into a staging table with the `\copy` meta-command from the
`cis376` root:

```text
\copy gradebook_import FROM 'assets/code/chapter-03/harquahala_gradebook_export.csv' WITH (FORMAT csv, HEADER true)
```

## Fictional data

Copperwind IT Services, Sandwash Family Clinic, and Harquahala Charter
Academy are fictional organizations created for this textbook. All
names, patients, students, staff, and records are synthetic. Any
resemblance to a real organization or person is coincidental.
