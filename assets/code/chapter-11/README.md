# Chapter 11 Data Pack: Routine Analysis and Best Practices

Chapter 11 works in two databases. Copperwind carries the reading and
the Skills Lab. The academy carries the spine Try It Yourself, where you
put a second database on the same routine. Run each setup script from
the extracted `cis376` folder:

```text
psql -U postgres -d postgres -f assets/code/chapter-11/setup-copperwind.sql
psql -U postgres -d postgres -f assets/code/chapter-11/setup-harquahala.sql
```

## Contents

| File | Purpose |
| ---- | ------- |
| `setup-copperwind.sql` | Creates `copperwind_ops`, loads Copperwind's clients, technicians, tickets, notes, and login events, and creates the two service roles the chapter audits. Chapter-specific: one role holds more than the signed access list allows |
| `setup-harquahala.sql` | Creates `harquahala_academy` and loads students, guardians, staff, courses, sections, enrollments, grades, and portal accounts |
| `review-baselines.csv` | The 2026-08-01 review capture for both databases. Sections 11.1 and 11.4 and Try It Yourself 11.5 load it and compare against it |
| `copperwind-access-list.csv` | The access list the data owner signed. Section 11.2 loads it and compares it against the privileges the server actually grants |
| `copperwind-benchmark-checklist.md` | Copperwind's ten-control configuration benchmark, written in the shape published benchmarks use. Section 11.3 scores eight of its controls and Skills Lab 11A scores all ten |
| `skills-lab-11a.sql` | Starter script for Skills Lab 11A with numbered markers for each part |
| `skills-lab-11a-answers.md` | Starter answer file for the metric design, the scoring record, the review calendar, the before-and-after report, and the two Questions & Analysis answers |

The CSV files the setup scripts load live in `assets/code/data/`. Its
README holds the data dictionary for every table.

## Which parts use which files

| Chapter part | Database or file | Script |
| ------------ | ---------------- | ------ |
| Sections 11.1, 11.3, 11.4 | `copperwind_ops`, `review-baselines.csv` | `setup-copperwind.sql` |
| Section 11.2 (access audit) | `copperwind_ops`, `copperwind-access-list.csv` | `setup-copperwind.sql` |
| Section 11.3 (benchmark) | `copperwind_ops`, `copperwind-benchmark-checklist.md` | `setup-copperwind.sql` |
| Try It Yourself 11.5 | `harquahala_academy`, `review-baselines.csv` | `setup-harquahala.sql` |
| Skills Lab 11A | `copperwind_ops`, all three fixtures | `setup-copperwind.sql`, `skills-lab-11a.sql`, `skills-lab-11a-answers.md` |

## Objects the chapter creates, and how to reset

The chapter builds everything inside a `review` schema so nothing it
creates sits beside the client tables: `review.metrics` (the archive),
`review.monthly_metrics` and `review.control_metrics` (the metric set
views), and `review.approved_access` (the signed list). Section 11.4
also revokes CONNECT from PUBLIC, revokes a blanket SELECT, and creates
`tickets_client_status_idx`.

Rerunning `setup-copperwind.sql` resets all of it. The script drops the
`review` schema, drops and recreates the tables, and drops and recreates
every role whose name starts with `copperwind_`, so a second pass
through the chapter starts from the same state as the first.

The two service-role passwords in the setup script are visibly fake and
belong to this chapter only. Replace them on any server that matters.

## Fictional data

Copperwind IT Services, Sandwash Family Clinic, and Harquahala Charter
Academy are fictional organizations created for this textbook. All
names, patients, students, staff, and records are synthetic. Any
resemblance to a real organization or person is coincidental.
