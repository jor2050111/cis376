# Shared Course Data: The Three Databases

This folder holds the CSV files behind the three databases every
chapter of CIS376 works on. Each chapter's `setup-<org>.sql` script
loads from here with `\copy`, so run every setup script from the
extracted `cis376` folder:

```text
psql -U postgres -d postgres -f assets/code/chapter-01/setup-copperwind.sql
```

The data is shared across chapters only to keep the pack small. No
chapter depends on work you saved in another chapter. Rerunning a
setup script rebuilds that database from these files.

## copperwind_ops (Copperwind IT Services)

| File | Rows | Columns |
| ---- | ---- | ------- |
| `copperwind/clients.csv` | 40 | client_id, client_name, sector, city, contract_start |
| `copperwind/technicians.csv` | 8 | technician_id, full_name, team, hire_date |
| `copperwind/tickets.csv` | 18,240 | ticket_id, client_id, technician_id, category, priority, opened_at, closed_at, status, summary |
| `copperwind/ticket_notes.csv` | about 28,000 | note_id, ticket_id, author_id, noted_at, note_text |
| `copperwind/login_events.csv` | 12,000 | event_id, username, event_time, source_ip, success |

Tickets run January 2024 through June 2026 and grow about 3 percent a
month. Security tickets spike in March 2025 and February 2026. One
burst of failed logins from a single outside address sits in
`login_events`.

## sandwash_clinic (Sandwash Family Clinic)

| File | Rows | Columns |
| ---- | ---- | ------- |
| `sandwash/providers.csv` | 12 | provider_id, full_name, specialty, npi |
| `sandwash/patients.csv` | 600 | patient_id, first_name, last_name, date_of_birth, phone, email, address, insurance_member_id |
| `sandwash/appointments.csv` | 6,000 | appointment_id, patient_id, provider_id, scheduled_at, status, visit_type |
| `sandwash/visit_notes.csv` | about 4,400 | note_id, appointment_id, diagnosis_code, note_text |
| `sandwash/staff_accounts.csv` | 20 | account_id, username, role_name, provider_id |

Every column that looks like protected health information is
synthetic. NPI numbers, member ids, phone numbers, and addresses do not
belong to anyone.

## harquahala_academy (Harquahala Charter Academy)

| File | Rows | Columns |
| ---- | ---- | ------- |
| `harquahala/students.csv` | 800 | student_id, first_name, last_name, date_of_birth, grade_level, directory_opt_out |
| `harquahala/guardians.csv` | about 1,200 | guardian_id, full_name, phone, email, relationship |
| `harquahala/student_guardians.csv` | about 1,300 | student_id, guardian_id, is_primary |
| `harquahala/staff.csv` | 60 | staff_id, full_name, role_name |
| `harquahala/courses.csv` | 40 | course_id, course_name, grade_level |
| `harquahala/sections.csv` | 120 | section_id, course_id, staff_id, term |
| `harquahala/enrollments.csv` | 6,000 | enrollment_id, student_id, section_id |
| `harquahala/grades.csv` | 6,000 | enrollment_id, term_grade, comments |
| `harquahala/portal_accounts.csv` | about 1,200 | account_id, guardian_id, username, password_hash |

About 8 percent of students have opted out of directory information.
The `password_hash` column holds a visibly fake placeholder so that
Chapter 6 can replace it with a real hash.

## Provenance and license

All files are seeded synthetic data produced by
`assets/code/_generators/generate_course_data.py` (base seed 376,
byte-identical on rerun). They are part of the CIS376 OER textbook and
carry its license.

Copperwind IT Services, Sandwash Family Clinic, and Harquahala Charter
Academy are fictional organizations created for this textbook. All
names, patients, students, staff, and records are synthetic. Any
resemblance to a real organization or person is coincidental.
