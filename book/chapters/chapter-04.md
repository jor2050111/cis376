# Chapter 4: Compliance: HIPAA, FERPA, Retention, and Separation

A front-desk clerk at a clinic opens the schedule and sees every patient's diagnosis code beside the appointment time. A school's parent portal lists a student whose mother filed an opt-out form in August. A records request arrives at a law office one week after the office purged its old files. In each case the database did exactly what it was built to do. The problem is that nobody told the database what the law expected of it.

Chapter 1 named the data owner as the person who decides who may see what. This chapter gives that decision its vocabulary. Two federal regulations govern the clients you manage at Copperwind. HIPAA covers Sandwash Family Clinic. FERPA covers Harquahala Charter Academy. Both are written in plain terms that a database administrator can turn into configuration: which columns are protected, who may see them, and how long they stay. Chapter 5 grants the privileges. Chapter 6 encrypts what remains exposed. This chapter decides what those controls protect.

You will read the parts of HIPAA and FERPA that reach the database. You will classify the columns in both client databases, build the directory view the academy's portal should have used, and separate protected data behind schemas. Then you will write a retention policy and run a disposal the clinic can defend to an auditor. Every step ends with a query that proves the control took effect.

## Module Overview 🧭

* **Estimated time:** 4-5 hours
* **Prerequisites:** One prior SQL course (Introduction to Oracle: SQL, CIS276DA MySQL Database, or CIS276DB SQL Server Database). Chapter 1 (the lab server and the three course databases). This chapter's data pack rebuilds `sandwash_clinic` and `harquahala_academy` from scratch, so no saved work is required.
* **Deliverables:** Skills Lab 4A folder (`skills-lab-4a.sql` and `skills-lab-4a-answers.md`), Quick Checks

## Learning Objectives 🎯

By the end of this chapter, you will be able to:

* **4.1 (Analyze):** Classify data elements in a clinic database and a school database as protected health information, education records, directory information, or public data under HIPAA and FERPA (Sections 4.1-4.2)
* **4.2 (Apply):** Implement data separation with schemas and views so each user group sees only the columns its regulation allows (Section 4.3)
* **4.3 (Create):** Write a data retention and disposal policy that satisfies a stated regulatory requirement and can be enforced in the database (Section 4.4)

### This chapter aligns with the following Course Learning Outcomes

* **CLO I (Analyze):** Analyze database architecture and design for business solutions.
* **CLO II (Evaluate):** Assess security management for database environments.
* **CLO III (Create):** Develop strategies to maintain optimal system performance, security and availability.

---

## 4.1 HIPAA for the Database Team

In your SQL course a column was a column. Under HIPAA, some columns carry legal weight, and the database team has to know which ones. The Health Insurance Portability and Accountability Act (HIPAA) is a federal law. Its rules live in Title 45 of the Code of Federal Regulations, and two of them reach the database. The Privacy Rule says who may use and disclose health information. The Security Rule says how to protect it when it is electronic.

Start with who is regulated. A **covered entity** is a health plan, a health care clearinghouse, or a health care provider that sends health information electronically (45 CFR 160.103). Sandwash Family Clinic bills insurers electronically, so it is a covered entity. A **business associate** is an outside organization that creates, receives, keeps, or transmits protected health information for a covered entity. Copperwind hosts the clinic's database. That makes Copperwind a business associate. A written contract binds it, and so does the Security Rule, directly. When you configure the clinic server, you are not helping the clinic comply. You are complying.

### What Counts as Protected Health Information

**Protected health information (PHI)** is individually identifiable health information that a covered entity or business associate holds or transmits, in any form (45 CFR 160.103). Two tests make data PHI. It relates to a person's health, care, or payment for care. And it identifies the person, or could reasonably be used to identify them. A diagnosis code with no name attached is health data. A diagnosis code next to a phone number is PHI.

The rule lists eighteen identifiers in its de-identification standard (45 CFR 164.514(b)). The list is the checklist you use on a column. Names. Dates tied to a person other than the year, which means birth dates and visit dates. Phone numbers, email addresses, and street addresses. Medical record numbers, health plan member numbers, and account numbers. IP addresses, device serial numbers, photos, and biometrics. Any column that holds one of these, in a table that also holds health data, is PHI.

Run the classification against the clinic's two most sensitive tables. The system catalog gives you the column list, so you classify from evidence instead of memory:

```sql
\connect sandwash_clinic
SELECT table_name,
       column_name,
       data_type
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name IN ('patients', 'visit_notes')
ORDER BY table_name, ordinal_position;
-- Output:
--  table_name  |     column_name     | data_type
-- -------------+---------------------+-----------
--  patients    | patient_id          | integer
--  patients    | first_name          | text
--  patients    | last_name           | text
--  patients    | date_of_birth       | date
--  patients    | phone               | text
--  patients    | email               | text
--  patients    | address             | text
--  patients    | insurance_member_id | text
--  visit_notes | note_id             | integer
--  visit_notes | appointment_id      | integer
--  visit_notes | diagnosis_code      | text
--  visit_notes | note_text           | text
```

Read the list with the eighteen identifiers beside you. Every column in `patients` except `patient_id` is an identifier: two name columns, a birth date, a phone number, an email address, a street address, and a health plan member number. In `visit_notes`, `diagnosis_code` and `note_text` are health information. Neither table is PHI on its own in a strict reading. Together, joined through `appointments`, they are the clinic's most protected asset. The join path is the exposure, and Section 4.3 uses that fact to design the separation.

### The Security Rule's Three Safeguard Families

The **Security Rule** (45 CFR Part 164, Subpart C) protects electronic PHI. It sorts its rules into three families. **Administrative safeguards** (45 CFR 164.308) are about policies and people. They cover risk analysis, who in the workforce gets access, training, incident procedures, and a contingency plan. **Physical safeguards** (45 CFR 164.310) cover buildings, workstations, and media. That includes the disposal of drives that held PHI. **Technical safeguards** (45 CFR 164.312) are the controls inside the system. They cover access control with a unique ID per user, audit controls, integrity, authentication, and transmission security.

Each standard is either required or addressable. Required means do it. Addressable means decide whether it fits your environment, do it or something equal to it, and write the decision down. Addressable never means optional. Encrypting PHI at rest is addressable, and nearly every covered entity decides to do it.

Read the technical safeguards as your job description for Part II of this book:

| Technical safeguard (45 CFR 164.312) | What it asks | Where you implement it |
| --- | --- | --- |
| Access control | Unique user identification, emergency access, automatic logoff, encryption | Roles and grants (Chapter 5), column encryption (Chapter 6) |
| Audit controls | Record and examine activity in systems that hold PHI | Server logging and audit triggers (Chapter 7) |
| Integrity | Protect PHI from improper alteration or destruction | Constraints (Chapter 3), audit trails (Chapter 7), backups (Chapter 9) |
| Person or entity authentication | Verify that a person or program is who it claims | Password policy and connection rules (Chapters 2 and 5) |
| Transmission security | Guard PHI in motion over a network | TLS connections (Chapter 6) |

The administrative safeguards reach you too. The information access management standard asks the covered entity to authorize access to PHI by role and to document it. The contingency plan standard asks for backups and a tested recovery plan. Chapters 5 and 9 produce the evidence those standards expect.

### The Minimum Necessary Standard

The **minimum necessary standard** (45 CFR 164.502(b)) requires a covered entity or business associate to limit PHI to the minimum needed for a use, disclosure, or request. It does not apply to disclosures to a provider for treatment, to the patient, or to disclosures the patient authorized. It applies in full to everything else, and everything else is most of what a database serves. The implementation rule (45 CFR 164.514(d)) tells you how. Name the classes of workers who need PHI. For each class, name the kinds of PHI they need. Then limit their access to match.

That is a role-based access design stated in legal language. The clinic has already named its classes of persons. They are in its staff table:

```sql
SELECT role_name,
       COUNT(*) AS accounts
FROM staff_accounts
GROUP BY role_name
ORDER BY accounts DESC;
-- Output:
--    role_name    | accounts
-- ----------------+----------
--  provider       |       12
--  frontdesk      |        4
--  billing        |        2
--  office_manager |        1
--  it_admin       |        1
```

Five classes. Providers deliver treatment, so the minimum necessary standard does not limit what they see for their own patients. The other four classes need a defined category of PHI each. The front desk is the clearest case. To check a patient in, a clerk needs the appointment time, the patient's name, a phone number to call about a delay, and the appointment status. Here is that view of one day:

```sql
SELECT a.scheduled_at,
       p.first_name,
       p.last_name,
       p.phone,
       a.status
FROM appointments AS a
JOIN patients AS p ON p.patient_id = a.patient_id
WHERE a.scheduled_at::date = DATE '2026-05-23'
ORDER BY a.scheduled_at;
-- Output:
--     scheduled_at     | first_name | last_name |    phone     |  status
-- ---------------------+------------+-----------+--------------+-----------
--  2026-05-23 08:30:00 | Benjamin   | Chavez    | 602-555-8023 | Completed
--  2026-05-23 08:45:00 | Serena     | Sanchez   | 602-555-2183 | Completed
--  2026-05-23 08:45:00 | Lena       | Dominguez | 602-555-4546 | Completed
--  2026-05-23 12:00:00 | Nathan     | Bennett   | 602-555-1149 | Completed
--  2026-05-23 15:30:00 | Javier     | Flores    | 602-555-6963 | Completed
```

No diagnosis, no birth date, no member number. Those five columns are still PHI, because a name beside an appointment date reveals that the person received care. The standard does not ask you to remove PHI from the front desk. It asks you to give the front desk the minimum. In Section 4.3 this query becomes a view with a grant on it, and the front desk never touches the base tables.

### Try It Yourself 4.1: Is It PHI? 🛠️

**Predict:** A dental office asks Copperwind to host its scheduling database. Its `reminders` table holds `patient_name`, `mobile_phone`, `appointment_date`, `procedure_code`, `hygienist_initials`, and `confirmed`. Before reading on, write down which columns are identifiers and which are health data. Then decide whether the table as a whole is PHI.

**Run:** Build a three-column table on paper: Column, Identifier or health information or neither, and the reason. Then decide which columns a text-message reminder service needs to send "You have an appointment Tuesday at 2 p.m." and mark them.

**Explain:** In one or two sentences, explain why the reminder service's column set is still PHI even though it excludes the procedure code, and name the standard that limits what the service receives.

### Quick Check 4.1 ✅

1. Copperwind hosts the clinic's database but never opens a patient record. Classify Copperwind under HIPAA and name the rule that applies to it directly.
2. A billing clerk asks for read access to `visit_notes` because "claims sometimes need the diagnosis." Apply the minimum necessary standard: what category of PHI does the billing class need, and which column set would you propose instead of the full table?
3. Name the three safeguard families of the Security Rule and give one database control from this book for each.

---

## 4.2 FERPA for the Database Team

The Family Educational Rights and Privacy Act (FERPA) protects student records at any school that takes federal education funds. Its rules live at 34 CFR Part 99. Harquahala Charter Academy is a public charter school, so FERPA governs every table in `harquahala_academy`. The rule is shorter than HIPAA, and its terms map onto a database even more directly.

An **education record** is any record directly related to a student that the school, or a party acting for it, keeps (34 CFR 99.3). Grades, enrollments, attendance, discipline, counseling notes, and guardian contact details all qualify. So does the database Copperwind hosts, because Copperwind acts for the school. FERPA gives parents the right to inspect these records. It also requires written consent before the school discloses them, with a list of exceptions. Two exceptions do most of the work in a database: directory information and legitimate educational interest.

One boundary matters to Copperwind's other client too. Health records that a school keeps on its students are education records under FERPA, and HIPAA's definition of PHI excludes them (45 CFR 160.103). If the academy ever stored nurse visits, FERPA would govern them, not HIPAA. The same column can fall under a different law depending on who holds it.

### Directory Information and the Opt-Out

**Directory information** is information in an education record that would not generally be considered harmful or an invasion of privacy if disclosed (34 CFR 99.3). The rule names the usual items: name, address, phone listing, email address, photo, date and place of birth, grade level, dates of attendance, and activities. A school may publish directory information without consent. First it must give public notice of what it designates and offer parents a period to refuse (34 CFR 99.37(a)). Once a parent opts out, the school must honor the refusal. It keeps honoring it after the student leaves unless the request is withdrawn (34 CFR 99.37(b)).

Each school chooses which items it designates. Harquahala designates name and grade level only. Its student table records the refusal as a flag:

```sql
\connect harquahala_academy
SELECT directory_opt_out,
       COUNT(*) AS students
FROM students
GROUP BY directory_opt_out
ORDER BY directory_opt_out;
-- Output:
--  directory_opt_out | students
-- -------------------+----------
--  f                 |      751
--  t                 |       49
```

Forty-nine families said no. The portal incident that opened this chapter happened because a query read `students` and forgot the flag. The fix is to build the filter once, into an object the portal cannot bypass, and prove that no opted-out student passes through it.

### Try It Yourself 4.2: Build the Harquahala Directory View 🛠️

You manage the academy's database for Copperwind, and Principal Dana Whitfield has asked for a directory object that the school website and the portal can read safely. (You first loaded this database in Chapter 1.)

**Predict:** The view below selects four columns and filters on the opt-out flag. Before you run it, write down how many rows the view will return and how many opted-out students will appear in it. Then predict what happens to a student who opts out next month without anyone touching the view.

**Run:** Create the view and count its rows. Then run the proof query, which joins the view back to the base table and counts any opted-out student that leaked through:

```sql
CREATE VIEW student_directory AS
SELECT student_id,
       first_name,
       last_name,
       grade_level
FROM students
WHERE directory_opt_out = false;

SELECT COUNT(*) AS directory_rows
FROM student_directory;

SELECT COUNT(*) AS opted_out_visible
FROM student_directory AS d
JOIN students AS s ON s.student_id = d.student_id
WHERE s.directory_opt_out = true;
-- Output:
-- CREATE VIEW
--  directory_rows
-- ----------------
--             751
--
--  opted_out_visible
-- -------------------
--                  0
```

**Explain:** In one or two sentences, explain why the second count is the evidence you would hand the principal. Then explain why the view honors an opt-out filed next month without any change to its definition.

Notice what the view leaves out. Birth dates are on FERPA's list of possible directory items, but Harquahala did not designate them, so the view does not carry them. Section 4.3 turns the column list of a view into a general tool.

### Legitimate Educational Interest

The second exception lets a school share education records without consent with school officials who have a **legitimate educational interest** in them (34 CFR 99.31(a)(1)). The school decides who counts as an official and what interest is legitimate. It publishes those criteria in its annual notice. Then the rule adds the sentence that lands on your desk. The school must use reasonable methods to ensure that officials reach only the records in which they have a legitimate educational interest. It may meet that duty with physical or technological access controls (34 CFR 99.31(a)(1)(ii)).

A teacher's interest reaches the students in the sections she teaches. Measure how far that is for one teacher:

```sql
SELECT st.full_name,
       COUNT(DISTINCT e.student_id) AS students_taught,
       (SELECT COUNT(*) FROM students) AS students_enrolled
FROM staff AS st
JOIN sections AS sec ON sec.staff_id = st.staff_id
JOIN enrollments AS e ON e.section_id = sec.section_id
WHERE st.full_name = 'Keisha Bell'
GROUP BY st.full_name;
-- Output:
--   full_name  | students_taught | students_enrolled
-- -------------+-----------------+-------------------
--  Keisha Bell |             189 |               800
```

Ms. Bell has a legitimate educational interest in 189 students, not 800. A grant of `SELECT` on the whole `grades` table gives her 611 students' records she has no interest in, and the school would have trouble calling that a reasonable method. Chapter 5 builds the row-level security policy that filters grades by who is asking. This chapter's job is to name the boundary the policy will enforce.

### Parents and Eligible Students

FERPA rights belong to the parent while the student is a minor in a K-12 school. The regulation defines parent broadly: a natural parent, a guardian, or an individual acting as a parent in the absence of one (34 CFR 99.3). Either parent holds full rights unless a court order or a legally binding document says otherwise. When a student turns 18 or enrolls in a postsecondary institution, the student becomes an **eligible student** and the rights transfer from the parents to the student (34 CFR 99.5(a)).

For Harquahala, a K-8 school, the portal serves guardians, and the `student_guardians` table records who is linked to whom. That table is an access control list in disguise. A guardian's portal account should reach the records of linked students and nothing else. For Copperwind's community college clients, the same portal design flips: the student holds the rights, and a parent calling for grades gets nothing without the student's written consent.

### Try It Yourself 4.3: Who Holds the Rights? 🛠️

**Predict:** A fictional trade school asks Copperwind to design the access rules for its student portal. Three requests arrive the same afternoon. A father asks for his 17-year-old daughter's attendance record. A mother asks for her 19-year-old son's grades. A welding instructor asks for the transcript of a student who is enrolled in a different program. Before reading on, decide which requests FERPA permits without written consent.

**Run:** For each request, write the FERPA concept that decides it: parent rights, eligible student, legitimate educational interest, or consent. Then name the table or column in a student database that records who is linked to whom.

**Explain:** In one or two sentences, explain why the instructor's request fails even though he is a school official, and name the regulation's phrase for the method the school must use to stop it.

### Quick Check 4.2 ✅

1. The academy wants to print a yearbook with every student's name, photo, and birthday. Classify each item. Then state which ones Harquahala's current designation does not cover.
2. Compare the directory-information exception and the legitimate-educational-interest exception. Which one is decided by the parent, and which is decided by the school?
3. A counselor at the academy stores notes about a student's therapy referrals in the database. Determine which federal law governs those notes and explain why the answer is not HIPAA.

---

## 4.3 Data Classification and Separation

Both regulations end in the same instruction: give each group only the data it needs. To do that at scale you need two things. A classification that says how sensitive each column is, and a structure in the database that makes the classification hard to violate by accident. This section builds both.

### Classification Levels

**Data classification** gives each data element a sensitivity level. The level decides how the data is stored, who may see it, and how it is disposed of. Four levels cover nearly every organization Copperwind serves:

| Level | Meaning | Clinic examples | Academy examples |
| --- | --- | --- | --- |
| Public | Released without harm | Clinic hours, provider names and specialties | Designated directory information for students who have not opted out |
| Internal | For staff, not for release | Staff usernames, appointment counts by month | Staff roster, course catalog, section schedules |
| Confidential | Regulated, released only to authorized roles | Patient contact details, appointment lists with names | Grades, enrollments, guardian contacts, opt-out flags |
| Restricted | Regulated and most damaging if exposed | Diagnosis codes, visit notes, insurance member numbers | Counseling notes, custody orders, disability status |

The levels are a management decision, and the data owner signs them. Dr. Vasquez decides that `insurance_member_id` is Restricted. Principal Whitfield decides that guardian phone numbers are Confidential. You record the decisions in a classification register, one row per column. The register then feeds every grant in Chapter 5 and every encryption choice in Chapter 6. The Skills Lab has you build the clinic's register.

### Schemas as Boundaries

A **schema** is a named container for tables, views, and other objects inside one database. Every table you have created so far lives in the default schema, `public`. You have used schema names in queries before if you came from Oracle or SQL Server. What is new is treating the schema as a security boundary. A role cannot reach any object inside a schema without `USAGE` on the schema, whatever grants it holds on the objects. That gives you a door with one lock, and it is the first thing a privilege review checks.

Here is the separation script for the academy, with each decision named. It moves the most sensitive table behind a restricted schema, places the directory view from Section 4.2 in its own public-facing schema, and opens exactly one door for the portal:

```sql
-- Step 1: Create one schema per boundary, named for what it holds
CREATE SCHEMA academy_restricted;
CREATE SCHEMA academy_directory;
-- Step 2: Move the education records behind the restricted boundary
ALTER TABLE grades SET SCHEMA academy_restricted;
-- Step 3: Move the directory view where public-facing readers will look
ALTER VIEW student_directory SET SCHEMA academy_directory;
-- Step 4: Create the group role that the portal's login will join
CREATE ROLE academy_portal NOLOGIN;
-- Step 5: Open the directory door and grant the view, never the base table
GRANT USAGE ON SCHEMA academy_directory TO academy_portal;
GRANT SELECT ON academy_directory.student_directory TO academy_portal;
-- Output:
-- CREATE SCHEMA
-- CREATE SCHEMA
-- ALTER TABLE
-- ALTER VIEW
-- CREATE ROLE
-- GRANT
-- GRANT
```

`ALTER TABLE ... SET SCHEMA` moves the table without copying it, and every foreign key still points where it did. Queries that named `grades` without a schema now fail until they say `academy_restricted.grades`, and that failure is a feature. It tells you which application code reached into a restricted table.

Configuration without verification is a guess, so ask the catalog what the portal role can reach. The `has_schema_privilege()` and `has_table_privilege()` functions are PostgreSQL's way to ask that question without logging in as the role:

```sql
SELECT has_schema_privilege('academy_portal', 'academy_directory', 'USAGE') AS directory_usage,
       has_table_privilege('academy_portal', 'academy_directory.student_directory', 'SELECT') AS directory_select,
       has_table_privilege('academy_portal', 'public.students', 'SELECT') AS students_select,
       has_schema_privilege('academy_portal', 'academy_restricted', 'USAGE') AS restricted_usage;
-- Output:
--  directory_usage | directory_select | students_select | restricted_usage
-- -----------------+------------------+-----------------+------------------
--  t               | t                | f               | f
```

Two `t` values and two `f` values, in the order you designed. The portal can use the directory schema and read the directory view. It cannot read `students` and cannot enter the restricted schema at all. Now prove that the view works for the role that will use it. `SET ROLE` switches your session to the group role, and `RESET ROLE` switches back:

```sql
SET ROLE academy_portal;
SELECT COUNT(*) AS rows_visible
FROM academy_directory.student_directory;
RESET ROLE;
-- Output:
-- SET
--  rows_visible
-- --------------
--           751
--
-- RESET
```

The portal role reads 751 rows through a view over a table it cannot read directly. That works because a **view** is a stored query that runs, by default, with the privileges of the view's owner, not the caller. The caller needs `SELECT` on the view. The owner needs `SELECT` on the base tables. That asymmetry is what makes a view a column filter you can hand to a role you do not trust with the table.

### Views as Column Filters

A view narrows a table in two directions. Its column list decides which attributes pass through. Its `WHERE` clause decides which rows. The directory view does both: four columns of six, and only the rows without an opt-out. When you design a view for a role, write the column list by hand from the classification register. Never write `SELECT *`. The next block shows why, with the output the academy saw when its predecessor broke that rule.

### Fix It 4.1: The View That Grew a Column 🔧

Before Copperwind took over the academy's database, someone built a roster view for the front office with `SELECT *`, and the nightly deployment script recreates every view from a file.

**Symptom:** The registrar adds a `meal_program` column to `students` to track free and reduced-price meal eligibility, which is confidential under federal school-meal rules. The next morning the front-office roster page shows it. No error appeared anywhere. Here is the view definition the deployment script reruns each night, and the roster query before and after the column arrived:

```text
CREATE OR REPLACE VIEW student_roster AS
SELECT *
FROM students
WHERE directory_opt_out = false;

SELECT * FROM student_roster ORDER BY student_id LIMIT 3;
```

```text
 student_id | first_name | last_name | date_of_birth | grade_level | directory_opt_out
------------+------------+-----------+---------------+-------------+-------------------
          1 | Tanya      | Young     | 2016-09-27    |           5 | f
          2 | Alma       | Chavez    | 2015-02-07    |           6 | f
          3 | Sebastian  | Espinoza  | 2021-06-21    |           0 | f
(3 rows)

ALTER TABLE students ADD COLUMN meal_program text;
UPDATE students SET meal_program = 'Free' WHERE student_id = 2;
-- (nightly deployment reruns the CREATE OR REPLACE VIEW above)

 student_id | first_name | last_name | date_of_birth | grade_level | directory_opt_out | meal_program
------------+------------+-----------+---------------+-------------+-------------------+--------------
          1 | Tanya      | Young     | 2016-09-27    |           5 | f                 |
          2 | Alma       | Chavez    | 2015-02-07    |           6 | f                 | Free
          3 | Sebastian  | Espinoza  | 2021-06-21    |           0 | f                 |
(3 rows)
```

**Diagnose:** Before you touch anything, state the cause in one sentence. PostgreSQL expands `*` when a view is created, so the `ALTER TABLE` alone did not change the roster. What did, and why is `SELECT *` in a view definition the root cause even though the redeploy pulled the trigger?

**Repair:** Rewrite the view with an explicit column list drawn from the classification register: `student_id`, `first_name`, `last_name`, and `grade_level`. Rerun the deployment script. State what changed in the file. Note that the roster already leaked two columns (`date_of_birth` and `directory_opt_out`) before `meal_program` arrived.

**Verify:** How do you know it is fixed? Name the catalog query from Chapter 1 that lists a view's columns from `information_schema.columns`, and state the exact column count it should return for `student_roster` after the repair.

### Separating Identifiers from Sensitive Attributes

The strongest separation happens in the data model, before any grant. Keep the columns that identify a person in one table. Keep the sensitive attributes in another, linked only by a surrogate key. The clinic's schema already does this. `visit_notes` holds a diagnosis and a note but no name, no birth date, and no phone number. Reaching a patient from a note takes two joins, through `appointments` and then `patients`. Chapter 3 called this normalization. Here it is a security control: a role with access to `visit_notes` alone can count diagnoses but cannot say whose they are.

That property makes reporting possible without exposing PHI. The clinic's quality committee wants to know which conditions it treats most:

```sql
\connect sandwash_clinic
SELECT diagnosis_code,
       COUNT(*) AS visits
FROM visit_notes
GROUP BY diagnosis_code
ORDER BY visits DESC
LIMIT 5;
-- Output:
--  diagnosis_code | visits
-- ----------------+--------
--  L30.9          |    411
--  K21.9          |    392
--  M54.5          |    389
--  J45.909        |    386
--  I10            |    383
```

No identifier appears, and the counts are large enough that no row points to a person. HIPAA's **de-identification** standard (45 CFR 164.514(b)) says health information stops being PHI when the eighteen identifiers are removed and the entity has no reason to believe the remainder can identify anyone. The surrogate keys in `visit_notes` are still a link back, so this table is not de-identified. It is separated, which is the working state for most of what you manage. Small counts deserve care too. A report that says one patient in a ZIP code has a rare diagnosis identifies that patient. Aggregate reports for outside parties usually suppress cells below a threshold, and the classification register should say what that threshold is.

### Try It Yourself 4.4: Draw the Boundaries 🛠️

**Predict:** A food bank's donor database has four tables: `donors` (name, address, email), `donations` (donor, date, amount), `volunteers` (name, phone, background check result, driver's license number), and `shifts` (volunteer, date, site). Before reading on, assign each column a classification level from the table at the start of this section, and name the two columns you would call Restricted.

**Run:** Sketch a schema layout on paper: which tables go in a `foodbank_restricted` schema, which stay in the working schema, and what one view the volunteer coordinator gets instead of the `volunteers` table. List the view's columns.

**Explain:** In one or two sentences, explain why moving the whole `volunteers` table behind the restricted schema is safer than revoking two columns from it. Then say what a `SELECT *` in the coordinator's view would risk next year.

### Quick Check 4.3 ✅

1. A role holds `SELECT` on `academy_restricted.grades` but has never been granted `USAGE` on `academy_restricted`. Predict what its query returns and explain which lock stopped it.
2. Compare a view with an explicit column list to `REVOKE SELECT` on individual columns of the base table. Which one survives an `ALTER TABLE ... ADD COLUMN` safely, and why?
3. The clinic's quality report groups visits by diagnosis code and by patient ZIP code. Judge whether the report is still separated from identifiers, and name the HIPAA identifier that changed your answer.

---

## 4.4 Retention and Disposal

Keeping data is not free of risk. Every row you retain is a row that can leak, be subpoenaed, or be restored from a backup you forgot existed. Every row you delete too early is a record a patient, a parent, or a court may demand next year. A **retention schedule** resolves that tension in writing. It names each class of records, states how long the organization keeps it, names the event that starts the clock, and says how the records are destroyed at the end. The database enforces the schedule. The policy is what an auditor reads first.

### What the Regulations Require

HIPAA sets one retention period the database team must know. The Security Rule requires documentation: your policies, your risk analysis, your access authorizations, and records of the actions you take. That documentation must be kept for six years from its creation or from the date it was last in effect, whichever is later (45 CFR 164.316(b)(2)(i)). Your **disposal log**, the record of what was destroyed and when, is part of that documentation. HIPAA does not set a retention period for medical records themselves. State medical-record laws do, and they vary by state and by whether the patient is a minor. The clinic's counsel supplies that number and the schedule cites it.

The Security Rule also governs the end of the data's life. Its device and media controls standard requires a policy for the final disposal of electronic PHI. It also requires a procedure for removing PHI from media before reuse (45 CFR 164.310(d)(2)). NIST Special Publication 800-88, Guidelines for Media Sanitization, is the reference those policies cite for drives. The same principle applies inside the database. A deleted row that can still be read was not disposed of.

FERPA takes the opposite shape. It sets no retention period for education records. It does forbid one kind of destruction. A school may not destroy any education record while a request to inspect it is outstanding (34 CFR 99.10(e)). That single sentence is the legal-hold rule, and it applies to any schedule you write for the academy.

### A Schedule the Database Can Enforce

Here is the clinic's schedule for the record series this chapter works with. The Skills Lab template carries the same fields:

| Series | Records | Trigger event | Retention | Disposition | Authority |
| --- | --- | --- | --- | --- | --- |
| VN-01 | Visit notes and diagnosis codes | Date of visit | 6 years (state medical-record law, confirmed by counsel) | Secure deletion, logged | Clinic policy RM-4, state statute cited in RM-4 |
| AP-01 | Appointment history | Date of visit | 6 years | Secure deletion, logged | Clinic policy RM-4 |
| SEC-01 | Security Rule documentation, disposal log, access reviews | Creation or last effective date | 6 years | Archive, then secure deletion | 45 CFR 164.316(b)(2)(i) |
| LH-01 | Legal holds | Hold released | Life of the hold plus 6 years | Archive | Clinic policy RM-4 |

The schedule runs on a fixed date each quarter so the evidence is reproducible. The run for September 2026 disposes of series VN-01 records for visits before 2020-09-01. Start by measuring what the schedule would remove:

```sql
SELECT COUNT(*) AS notes_past_retention
FROM visit_notes AS vn
JOIN appointments AS a ON a.appointment_id = vn.appointment_id
WHERE a.scheduled_at < DATE '2020-09-01';
-- Output:
--  notes_past_retention
-- ----------------------
--                   992
```

Nine hundred ninety-two notes. That count is the first line of the disposal record, and it is the number the office manager approves before anything runs.

### Legal Holds

A **legal hold** suspends the retention schedule for specific records because of litigation, an investigation, a records request, or a complaint. The hold outranks the schedule. A disposal run that destroys a held record is a compliance failure even when the schedule said the record was due. So the hold has to live where the disposal query can see it. Store holds in a table, never in an email:

```sql
CREATE TABLE clinic_legal_holds (
  hold_id     serial PRIMARY KEY,
  patient_id  integer NOT NULL REFERENCES patients (patient_id),
  reason      text NOT NULL,
  placed_by   text NOT NULL,
  placed_on   date NOT NULL DEFAULT CURRENT_DATE,
  released_on date
);

INSERT INTO clinic_legal_holds (patient_id, reason, placed_by, placed_on)
VALUES (19, 'Records request from patient counsel', 'Tomas Reyes', DATE '2026-08-14');

SELECT COUNT(*) AS notes_on_hold
FROM visit_notes AS vn
JOIN appointments AS a ON a.appointment_id = vn.appointment_id
JOIN clinic_legal_holds AS h ON h.patient_id = a.patient_id
WHERE a.scheduled_at < DATE '2020-09-01'
  AND h.released_on IS NULL;
-- Output:
-- CREATE TABLE
-- INSERT 0 1
--  notes_on_hold
-- ---------------
--              4
```

Four of the 992 notes belong to a patient whose counsel has asked for records. Those four stay. A hold is released by setting `released_on`, never by deleting the hold row, because the hold's own history is a record in series LH-01.

### Secure Deletion and the Disposal Log

**Secure deletion** means the data is gone from every place it could be read, and someone can prove it. A `DELETE` statement is the first step, not the last. It marks rows dead. `VACUUM` reclaims the space later. The write-ahead log holds the change for a while. Every backup taken before the run still holds the rows. Any replica received the delete but keeps its own dead tuples until it vacuums. Your policy has to name each of those places and say when the data leaves it. Backups age out under their own schedule, which Chapter 9 writes. Chapter 6 adds a faster route for encrypted columns: destroy the key and every copy becomes unreadable at once.

Documenting the destruction is not a formality. It is the Security Rule documentation that series SEC-01 keeps for six years, and it is the answer when a patient asks in 2029 why the clinic no longer has a 2019 note. Do the delete and the log entry in one transaction, so a failure leaves neither half behind. PostgreSQL lets a `DELETE ... RETURNING` feed an `INSERT` inside one statement, which is PostgreSQL-specific syntax and exactly the tool for this:

```sql
CREATE TABLE clinic_disposal_log (
  disposal_id    serial PRIMARY KEY,
  record_series  text NOT NULL,
  cutoff_date    date NOT NULL,
  rows_destroyed integer NOT NULL,
  authority      text NOT NULL,
  performed_by   text NOT NULL,
  performed_at   timestamp NOT NULL DEFAULT now()
);

-- Step 1: One transaction, so the log and the delete succeed or fail together
BEGIN;
-- Step 2: Delete only what the schedule names and the holds release
WITH destroyed AS (
  DELETE FROM visit_notes AS vn
  USING appointments AS a
  WHERE a.appointment_id = vn.appointment_id
    AND a.scheduled_at < DATE '2020-09-01'
    AND NOT EXISTS (
      SELECT 1
      FROM clinic_legal_holds AS h
      WHERE h.patient_id = a.patient_id
        AND h.released_on IS NULL)
  RETURNING vn.note_id
)
-- Step 3: Write the count the delete returned, not a number typed by hand
INSERT INTO clinic_disposal_log
  (record_series, cutoff_date, rows_destroyed, authority, performed_by, performed_at)
SELECT 'visit_notes', DATE '2020-09-01', COUNT(*),
       'Sandwash retention schedule, series VN-01', 'Copperwind DBA',
       TIMESTAMP '2026-09-01 06:00:00'
FROM destroyed;
COMMIT;

-- Step 4: Read the log back as the auditor will
SELECT record_series, cutoff_date, rows_destroyed, performed_by
FROM clinic_disposal_log;
-- Output:
-- CREATE TABLE
-- BEGIN
-- INSERT 0 1
-- COMMIT
--  record_series | cutoff_date | rows_destroyed |  performed_by
-- ---------------+-------------+----------------+----------------
--  visit_notes   | 2020-09-01  |            988 | Copperwind DBA
```

The log says 988, which is 992 minus the four held notes. The number came from the rows the `DELETE` returned, so it cannot disagree with what happened. Now reclaim the space and confirm that the only notes left past the cutoff are the held ones:

```sql
VACUUM visit_notes;

SELECT COUNT(*) AS notes_past_retention
FROM visit_notes AS vn
JOIN appointments AS a ON a.appointment_id = vn.appointment_id
WHERE a.scheduled_at < DATE '2020-09-01';
-- Output:
-- VACUUM
--  notes_past_retention
-- ----------------------
--                     4
```

Four remain, all under hold. When the hold is released, the next quarterly run picks them up, and the log gains a second row. That is a retention policy the database enforces. It has a schedule in a table, a hold in a table, a transaction that respects both, and a log that a person who was not there can read.

### Try It Yourself 4.5: What DELETE Leaves Behind 🛠️

**Predict:** A law office deletes a former client's matter files from its case database and tells the client the data is gone. Before reading on, list every place inside and around a PostgreSQL server where those rows may still be readable an hour later.

**Run:** Write the list as a table with three columns: Location, How long the data stays there, and the action or schedule that removes it. Use this section and your Chapter 1 notes on the cluster layout. Aim for at least five rows.

**Explain:** In one or two sentences, explain what the office should have told the client instead, and which row of your table a retention policy controls least directly.

### Quick Check 4.4 ✅

1. The clinic's office manager asks you to "just delete everything older than six years" from a psql prompt. Apply this section: name the three things that must exist before that statement runs.
2. A parent files a request to inspect her son's records, and the academy's annual purge is scheduled for the same week. Determine what FERPA requires and state where in the database the requirement should be recorded.
3. Explain why the disposal log stores the count the `DELETE` returned instead of the count measured before the run, and name the retention period that applies to the log itself.

---

## 4.5 Summary and Retrieval 💡

### Key Concepts

* HIPAA regulates covered entities and their business associates. Copperwind is a business associate, so the Security Rule (45 CFR Part 164, Subpart C) applies to the clinic server directly. PHI is health information joined to any of eighteen identifiers, and the join path between tables is the exposure.
* The Security Rule's administrative, physical, and technical safeguards map onto the controls in Part II and Part III of this book. The minimum necessary standard (45 CFR 164.502(b)) is a role-based access design: name the classes of workers, name the PHI each class needs, and limit access to match.
* FERPA (34 CFR Part 99) protects education records. Directory information may be released only after public notice and only for students who have not opted out (34 CFR 99.3 and 99.37). School officials get records only where they have a legitimate educational interest, and the school must use reasonable methods to enforce that. Rights transfer from parent to eligible student at 18 or at postsecondary enrollment.
* Data classification assigns each column a level (Public, Internal, Confidential, Restricted) that the data owner signs. Schemas are boundaries with one lock, `USAGE`. Views are column and row filters that run with the owner's privileges, and they take an explicit column list, never `SELECT *`.
* Keeping identifiers and sensitive attributes in separate tables is a security control. Aggregates over the attribute table report without exposing PHI, as long as the counts stay large.
* A retention schedule names each record series, its trigger, its period, its disposition, and its authority. Legal holds outrank the schedule and live in a table the disposal query reads. Secure deletion means the data left every copy, and the disposal log proves it. HIPAA keeps that documentation for six years (45 CFR 164.316(b)(2)(i)). FERPA forbids destroying a record while an inspection request is open (34 CFR 99.10(e)).

### Key Terms

See course glossary for full definitions

* covered entity, business associate, protected health information (PHI), Security Rule, administrative safeguards, physical safeguards, technical safeguards, minimum necessary standard (Section 4.1)
* education record, directory information, legitimate educational interest, eligible student (Section 4.2)
* data classification, schema, view, de-identification (Section 4.3)
* retention schedule, legal hold, secure deletion, disposal log (Section 4.4)

### Retrieval Practice

1. From memory, state the two conditions that make a column PHI, and name three of the eighteen identifiers that appear in the clinic's `patients` table.
2. Explain the difference between the directory-information exception and the legitimate-educational-interest exception, and say who decides each.
3. A colleague proposes `CREATE VIEW frontdesk AS SELECT * FROM patients`. State the two things wrong with it and the one PostgreSQL behavior that makes the second problem appear only on redeploy.
4. From Chapter 2: Name the file that decides which client addresses may connect to a PostgreSQL server, and explain why a server holding PHI belongs in its own network tier.
5. Describe the four objects a database-enforced retention policy needs, and name the regulation that forbids destroying a record while an inspection request is open.

---

## 4.6 Skills Lab 4A: Classify and Separate Sandwash Clinic Data

**Goal:** Produce the clinic's classification register and move its protected health information behind a restricted schema. Then expose a minimum-necessary view for the front desk and write the retention policy that Dr. Vasquez and Naomi Redhouse can sign.

**Dataset or starter files:** `assets/code/chapter-04/` in the course data pack. The setup script `setup-sandwash.sql` rebuilds `sandwash_clinic` from the CSVs in `assets/code/data/`. The starter script `skills-lab-4a.sql`, the starter answer file `skills-lab-4a-answers.md`, and the policy template `retention-policy-template.md`. All organizations and records are fictional.

### Part 1: Foundation (Aligns with Objective 4.1)

1. Rerun `setup-sandwash.sql` so you start from a clean database. Under marker 1.1 in `skills-lab-4a.sql`, write one `information_schema.columns` query that lists every column in all five clinic tables with its data type. Paste the result as `-- Output:` comment lines.
2. In the answer file, fill the classification register, one row per column. Each row names the table, the column, the level (Public, Internal, Confidential, or Restricted), the HIPAA identifier if there is one, and a one-line reason. Every column gets a row, including the keys.
3. Under marker 1.2, write a query that shows the join path from `visit_notes` to a patient's name. In the answer file, explain in two or three sentences why that path, not any single table, is what the classification protects.

### Part 2: Application (Aligns with Objectives 4.1 and 4.2)

1. Under marker 2.1, create the schema `clinic_restricted` and move the tables your register marks Restricted into it. Justify each move in a comment. Then create the schema `clinic` for the views that roles will read.
2. Under marker 2.2, create the group role `clinic_frontdesk` (no login) and the view `clinic.frontdesk_schedule`. Choose its columns from your register: what a clerk needs to check a patient in and call about a delay, and nothing else. Write the column list by hand. Grant `USAGE` on `clinic` and `SELECT` on the view to the role.
3. Under marker 2.3, prove the boundary with `has_schema_privilege()` and `has_table_privilege()` for the role against the view, the `patients` table, and every table in `clinic_restricted`. Then `SET ROLE clinic_frontdesk`, count the rows in the view, and `RESET ROLE`. Paste every result.

### Part 3: Extension (Aligns with Objectives 4.2 and 4.3)

1. Open `retention-policy-template.md` and complete every field for the four record series in Section 4.4, adding one series for the `appointments` table's cancelled and no-show rows with a period you defend. Cite the HIPAA documentation period and the FERPA-style hold rule the clinic adopts by policy.
2. Under marker 3.1, create the clinic's legal-hold table and disposal-log table and place one hold. Then run the quarterly disposal for series VN-01 with the cutoff `2020-09-01`, inside one transaction that logs the count the `DELETE` returned. Paste the log row and the after-count.
3. In the answer file, write a half-page memo to Dr. Vasquez. Explain what the September run destroyed, what it kept and why, where copies of the destroyed notes may still exist, and when each copy will be gone. Write it for a physician, not for a DBA.

### Questions & Analysis 🤔

1. Your front-desk view excludes some columns your register marked Confidential and includes others. Using the minimum necessary standard as your test, defend one inclusion and one exclusion with evidence from Part 2, and describe what a billing view would need that the front-desk view does not.
2. The disposal run in Part 3 removed notes but left the appointment rows behind. Analyze whether the remaining appointment rows are still PHI, what a patient could learn from them, and whether your retention schedule should treat series AP-01 differently from VN-01. Support the answer with a query.

**Submission:** Submit one folder named `skills-lab-4a-lastname`. It holds `skills-lab-4a.sql` with every result pasted as `-- Output:` comment lines (or the saved psql output beside it). It also holds `skills-lab-4a-answers.md` with the classification register, the completed retention policy, the memo, and your two Questions & Analysis answers clearly labeled.

### Rubric: Skills Lab 4A

This lab is graded with the standard
[Skills Lab Rubric](../skills-lab-rubric.md): four criteria, five
levels from Mastery to Not Evident. The criteria are Technical
Accuracy and Efficiency, Output Quality, Documentation Quality, and
Analysis, Interpretation, and Response to QUESTION(s). The criteria
and levels are the same everywhere. Your instructor sets the point
values in your course. Check the syllabus and the Canvas rubric
attached to this lab for the values that apply to you.

---

## 4.7 Review Questions 🔄️

1. **Apply:** A credit union asks Copperwind to host its member database, which holds names, account numbers, and loan balances. Neither HIPAA nor FERPA applies. Apply the four classification levels and the minimum necessary idea to design a view for the call center, and name the columns it must not include.

2. **Analyze:** A bike shop's three stores share one database. A physical therapy practice next door asks to store patient exercise logs in it "to save money." Break the request into the questions this chapter asks: who becomes a business associate, which tables become PHI, and what separation you would require before you could say yes.

3. **Evaluate:** The academy's registrar proposes keeping every grade forever "because parents ask for old transcripts." Judge the proposal against the risks this chapter names for kept data and the one rule FERPA does impose. Then recommend a schedule with a trigger event and a disposition.

4. **Create:** Design the classification register and schema layout for a city parks department's database. It holds facility reservations, youth sports rosters with guardian contacts and medical alert notes, and staff records. Name each schema, the level of each table, and the one view each of three user groups receives.

---

## Further Reading 📖

* [45 CFR Part 164, Subpart C: Security Standards for the Protection of Electronic Protected Health Information](https://www.ecfr.gov/current/title-45/subtitle-A/subchapter-C/part-164/subpart-C) - The Security Rule itself, from the Electronic Code of Federal Regulations. Sections 164.308 through 164.312 hold the three safeguard families.
* [HHS: The HIPAA Security Rule](https://www.hhs.gov/hipaa/for-professionals/security/index.html) - The Department of Health and Human Services' plain-language overview and its links to the rule's history and guidance.
* [HHS: Minimum Necessary Requirement](https://www.hhs.gov/hipaa/for-professionals/privacy/guidance/minimum-necessary-requirement/index.html) - HHS guidance on 45 CFR 164.502(b) and 164.514(d), including the role-based access design this chapter builds on.
* [34 CFR Part 99: Family Educational Rights and Privacy](https://www.ecfr.gov/current/title-34/part-99) - The FERPA regulations, including the definitions in 99.3, the disclosure exceptions in 99.31, and the directory-information conditions in 99.37.
* [U.S. Department of Education: Protecting Student Privacy, FERPA](https://studentprivacy.ed.gov/ferpa) - The Department's FERPA page, with the regulation text, guidance for school officials, and model notices.
* [NIST SP 800-88 Rev. 2: Guidelines for Media Sanitization](https://csrc.nist.gov/pubs/sp/800/88/r2/final) - The reference a disposal policy cites for clearing, purging, and destroying media that held regulated data.
* [PostgreSQL Documentation: Schemas](https://www.postgresql.org/docs/17/ddl-schemas.html) - The reference for the schema boundary, the search path, and the `USAGE` privilege that Section 4.3 relies on.

---

## Looking Ahead ⏩

You now know which columns the law protects, and you have drawn the boundaries around them with schemas and views. Chapter 5 puts people at those boundaries. You will create login roles and group roles for the clinic's five classes of staff and grant each one the least privilege its work requires. Then you will write row-level security policies so a provider sees only her own patients and a teacher sees only her own sections. The classification register you built in this chapter is the specification for every grant you write there.
