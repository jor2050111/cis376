# Chapter 5: Access Control and Role-Based Security

Dr. Elena Vasquez signed a one-page list last spring. It named who at Sandwash Family Clinic may see a patient's chart, who may see only the schedule, and who may see billing codes and nothing else. The list was correct the day she signed it. Since then a reporting tool was installed, a front-desk lead left, and a billing contractor started. Nobody changed the list. Somebody changed the database. That gap is where most data exposures live, and closing it is the work of this chapter.

In your SQL course you connected as one account your instructor created, and every table was open to you. Chapter 4 decided which columns each group at the clinic and the academy may see under HIPAA and FERPA. This chapter turns those decisions into accounts, privileges, and row filters on a live PostgreSQL server. Then it turns around and asks the harder question: how do you prove, next quarter, that the server still matches the list?

You will build login roles for people and for programs. You will grant the least privilege each role needs and learn why a grant can look right and still fail. You will group roles into a hierarchy, add row-level security so a provider sees only her own patients, and finish with an access review that reads the truth from the catalog. Mei Lin assigns the work. Naomi Redhouse signs the review.

## Module Overview 🧭

* **Estimated time:** 5-6 hours
* **Prerequisites:** One prior SQL course (Introduction to Oracle: SQL, CIS276DA MySQL Database, or CIS276DB SQL Server Database). Chapter 1 (the lab environment and the three course databases). Chapter 4 supplies the classification vocabulary, and one sentence recalls it where needed.
* **Deliverables:** Skills Lab 5A folder (`skills-lab-5a.sql` and `skills-lab-5a-answers.md`), Quick Checks

## Learning Objectives 🎯

By the end of this chapter, you will be able to:

* **5.1 (Create):** Design an access control matrix for a database environment with at least three user roles and map each cell to a privilege (Sections 5.1-5.2)
* **5.2 (Apply):** Implement role-based access control with group roles, least-privilege grants, and row-level security policies (Section 5.3)
* **5.3 (Analyze):** Audit effective privileges from the system catalog and identify violations of least privilege (Section 5.4)

### This chapter aligns with the following Course Learning Outcomes

* **CLO II (Evaluate):** Assess security management for database environments.
* **CLO III (Create):** Develop strategies to maintain optimal system performance, security and availability.

---

## 5.1 Authentication: Who Is Asking

Every request that reaches a database carries two questions. Chapter 2 named them. Authentication answers the first: is this connection who it claims to be? Authorization answers the second: given who it is, what may it do? PostgreSQL handles them in that order, at two different gates. Chapter 2 wrote the rules in `pg_hba.conf` that decide which client addresses may ask and which method (password, certificate, or operating-system identity) proves the claim. This section decides which roles exist to be proven, and how.

### Login Roles for People and for Programs

Chapter 1 noted that a PostgreSQL role is both a user and a group. A **login role** is a role with the `LOGIN` attribute, which is what lets a connection start. A role without it holds privileges for others and can never connect on its own. Section 5.3 builds on that second kind. Two kinds of login role exist in every environment, and they need different settings:

| Question | A person | A service account |
| --- | --- | --- |
| Who uses it? | One named human | One application or job |
| How many connections? | One or two at a time | A fixed pool the application opens |
| When does it expire? | When the person leaves | When the application is retired |

A service account, which Chapter 2 defined as a login role used by an application or a scheduled job, is never used by a person. No human logs in as it to "check something." The reason is evidence: when a service account appears in a log, you need to know that the application acted, not a person hiding behind it. The **connection limit** caps how many sessions a role may hold at once. An application that opens connections until the server refuses everyone else is a Chapter 1 availability threat, and the limit is the control.

### Passwords the Server Can Defend

PostgreSQL stores passwords as a salted hash, not as text. Since version 14 the default scheme is **SCRAM-SHA-256**, a challenge-response method in which the password itself never crosses the network. PostgreSQL has no built-in rule about password length or complexity. That policy lives with the organization. The server enforces two things the organization cannot: how the password is stored and when it stops working. `VALID UNTIL` sets the expiry. Use it for every person, because people leave, and for contractors, because contracts end. Confirm the hashing scheme, create Tomas Reyes's account and the scheduling application's account, then read both back from the catalog:

```sql
\connect sandwash_clinic
SHOW password_encryption;
CREATE ROLE clinic_treyes LOGIN
  PASSWORD 'Sandwash-Ch5-Person-2026!'
  VALID UNTIL '2027-06-30';
CREATE ROLE clinic_scheduler_app LOGIN
  PASSWORD 'Sandwash-Ch5-App-2026!'
  CONNECTION LIMIT 5;
SELECT rolname AS role_name,
       rolcanlogin AS can_login,
       rolconnlimit AS conn_limit,
       rolvaliduntil::date AS valid_until,
       left(rolpassword, 13) AS password_scheme
FROM pg_authid
WHERE rolname LIKE 'clinic\_%'
ORDER BY rolname;
-- Output:
--  password_encryption
-- ---------------------
--  scram-sha-256
--
-- CREATE ROLE
-- CREATE ROLE
--       role_name       | can_login | conn_limit | valid_until | password_scheme
-- ----------------------+-----------+------------+-------------+-----------------
--  clinic_backup_svc    | t         |          1 |             | SCRAM-SHA-256
--  clinic_reports_svc   | t         |         -1 |             | SCRAM-SHA-256
--  clinic_scheduler_app | t         |          5 |             | SCRAM-SHA-256
--  clinic_treyes        | t         |         -1 | 2027-06-30  | SCRAM-SHA-256
```

Replace both passwords with ones of your own. A connection limit of `-1` means no limit, which is the default and the wrong answer for a service account. Two roles you did not create appear: `clinic_backup_svc` and `clinic_reports_svc`. They came with the clinic database when Copperwind took it over from the previous host. Leave them alone for now. Section 5.4 explains why unfamiliar login roles are the first finding of any access review, and Skills Lab 5A asks you to run them down.

Only superusers may read `pg_authid`, because it holds the hashes. `pg_roles` shows the same rows without that column, and every later query in this chapter uses it. `left(rolpassword, 13)` shows the scheme prefix and nothing else. Never paste a full hash into a lab or a ticket.

!!! warning "Passwords in statements end up in logs"
    A `CREATE ROLE ... PASSWORD` statement is text, and text gets logged. Once statement logging is on (Chapter 7), the password sits in the server log in the clear. In psql, run `\password clinic_treyes` instead. The meta-command hashes the password on the client and sends only the hash. This book's scripts put passwords in statements so they run unattended. On a production server, do not.

### What the Server Logs

Authentication failures are the earliest sign of trouble, and PostgreSQL reports each one with a `FATAL` line. The client sees the line, and the server writes the same line to its log with a timestamp and the client address. Three refusals you will meet, captured from this chapter's roles:

```text
psql: error: connection to server at "localhost" (127.0.0.1), port 5432 failed: FATAL:  too many connections for role "clinic_scheduler_app"
psql: error: connection to server at "localhost" (127.0.0.1), port 5432 failed: FATAL:  role "clinic_intern" does not exist
psql: error: connection to server at "localhost" (127.0.0.1), port 5432 failed: FATAL:  role "clinic_frontdesk" is not permitted to log in
```

Read them as an administrator. The first says the scheduling application hit its connection limit: the limit doing its job, or a leak in the application. The second says someone tried a role name that was never created, which is a typo or a probe. The third says someone tried to log in as a group role, which no application should ever do. A fresh server records only failures. Successful connections appear once `log_connections` is on, and Chapter 7 turns it on. Until then, the failures are your evidence.

### Try It Yourself 5.1: Sort the Credit Union's Accounts 🛠️

**Predict:** A credit union's loan database has six login roles: `teller_kim`, `loanapp`, `nightly_export`, `auditor_temp`, `dba_shared`, and `branch_manager_ortiz`. Before you build anything, decide which are people and which are service accounts, and predict which one violates the person-or-program rule outright.

**Run:** Build a table with the columns Role, Person or service account, Connection limit, Expiry date, and One-line reason. Fill every row. Give each person an expiry and each service account a limit, and write the `CREATE ROLE` statement for the two rows you are most confident about.

**Explain:** In one or two sentences, explain why `dba_shared` cannot be fixed with a stronger password, and name the Chapter 1 principle it violates.

### Quick Check 5.1 ✅

1. The clinic's reporting tool opened 40 connections during a report and the front desk could not log in. Name the setting that prevents a repeat and state where it belongs: on the role, on the database, or in `pg_hba.conf`.
2. A colleague proposes one `clinic_provider_login` account that all 12 providers share, "to keep it simple." Using the evidence argument from this section, explain what the shared account costs you when a chart is viewed at 2 a.m.

---

## 5.2 Authorization: What May They Do

A role that can log in still cannot read a table. Authorization is a separate decision, and PostgreSQL asks it three times on the way to a row. The role needs `CONNECT` on the database, `USAGE` on the schema that holds the table, and a privilege such as `SELECT` on the table itself. A **privilege** is a named permission on one object, held by one role. You have written `GRANT` and `REVOKE` before. This section is about which privileges to grant, to whom, and how to prove the grant works.

### The Three Doors

Each kind of object has its own privilege list. These are the ones an administrator grants most often (sequences take `USAGE` and functions take `EXECUTE`):

| Object | Privileges | What the grant allows |
| --- | --- | --- |
| Database | `CONNECT`, `CREATE`, `TEMP` | Connecting, creating schemas, creating temporary tables |
| Schema | `USAGE`, `CREATE` | Looking up objects inside it, creating objects inside it |
| Table or view | `SELECT`, `INSERT`, `UPDATE`, `DELETE`, `TRUNCATE`, `REFERENCES`, `TRIGGER` | Reading and changing rows, pointing foreign keys at it, adding triggers |

Two defaults matter more than the rest of the list. The pseudo-role **PUBLIC** stands for every role on the server. PostgreSQL grants PUBLIC `CONNECT` on every new database and `USAGE` on the `public` schema, so the first two doors stand open on a fresh server and only the third is closed. A schema you create yourself starts with all three closed for everyone but its owner. Fix It 5.1 shows what that looks like.

The front desk is the clinic's simplest case. Grace Yazzie's team schedules visits, so it needs appointments, the provider list, and a way to find a patient by name and phone. It does not need a date of birth, an address, or an insurance number. Chapter 4 filtered those columns with a view. A column-level grant does the same job when the filter is a plain list of columns, and it leaves one less object to maintain. Grant, then prove each door with the catalog instead of a query that happens to work. The `has_*_privilege()` functions are PostgreSQL-specific, and they answer the exact question a reviewer asks:

```sql
-- No LOGIN: the front desk is a job, and people join it in Section 5.3
CREATE ROLE clinic_frontdesk NOLOGIN;
GRANT SELECT ON appointments, providers TO clinic_frontdesk;
-- Name the columns and the rest of the row stays closed
GRANT SELECT (patient_id, first_name, last_name, phone)
  ON patients TO clinic_frontdesk;
SELECT has_database_privilege('clinic_frontdesk', 'sandwash_clinic', 'CONNECT') AS can_connect,
       has_schema_privilege('clinic_frontdesk', 'public', 'USAGE') AS schema_usage,
       has_table_privilege('clinic_frontdesk', 'patients', 'SELECT') AS whole_table,
       has_column_privilege('clinic_frontdesk', 'patients', 'phone', 'SELECT') AS phone_column,
       has_column_privilege('clinic_frontdesk', 'patients', 'insurance_member_id', 'SELECT') AS insurance_column;
-- Output:
-- CREATE ROLE
-- GRANT
-- GRANT
--  can_connect | schema_usage | whole_table | phone_column | insurance_column
-- -------------+--------------+-------------+--------------+------------------
--  t           | t            | f           | t            | f
```

Read the first column again. You never granted `CONNECT`, and the front desk has it anyway, because PUBLIC does. On a production server the clinic would close that door once and open it by name: `REVOKE CONNECT ON DATABASE sandwash_clinic FROM PUBLIC`, then `GRANT CONNECT` to each group role. This book does not run that revoke, because the setup scripts rebuild tables, not databases, so the revoke would outlive the chapter and confuse the next one. Note it in your command log as a hardening step. Chapter 11's benchmark asks for it.

### From the Matrix to the Grants

The grants above came from a decision, and the decision has a standard form. An **access control matrix** lists each role against each protected object and states the privilege the role holds on it. Dr. Vasquez, the data owner, rules on the cells. You implement them and prove them. Here is the clinic's matrix for four staff roles, following the minimum-necessary standard Chapter 4 applied to the same tables:

| Table | Provider | Front desk | Billing | Office manager |
| --- | --- | --- | --- | --- |
| `providers` | SELECT | SELECT | SELECT | SELECT |
| `appointments` | SELECT, own rows | SELECT | SELECT | SELECT |
| `patients` | SELECT, own rows | SELECT (id, name, phone) | SELECT (id, name, insurance) | none |
| `visit_notes` | SELECT, own rows | none | SELECT (diagnosis_code) | none |
| `staff_accounts` | none | none | none | SELECT |

Every cell is a `GRANT` or a `REVOKE`, and "own rows" is a row-level security policy from Section 5.3. Three habits keep the matrix honest. Name the columns whenever the cell says less than the whole table. Write "none" on purpose, so an empty cell is a decision and not an oversight. Date the matrix and keep the signed copy, because Section 5.4 compares the server against it.

`GRANT SELECT ON ALL TABLES IN SCHEMA public` reads like a standing rule. It is a snapshot. It grants on the tables that exist at that moment and nothing else. **Default privileges** are the standing rule: `ALTER DEFAULT PRIVILEGES` tells PostgreSQL what to grant on objects a given role creates in the future. The next exercise shows the snapshot fail and the rule succeed.

### Try It Yourself 5.2: The Table Created Tomorrow 🛠️

**Predict:** The clinic's quality committee gets a read-only role with `SELECT` on every table in `public`. Next month the office manager adds a `referrals` table. Before you run anything, predict whether the committee can read the new table, and say which statement in the script below changes the answer.

**Run:** Run the script as `postgres` in `sandwash_clinic`. It creates the role, takes the snapshot, adds a table, checks, sets the standing rule, adds a second table, and checks again. It removes both tables at the end so the clinic database is unchanged.

```sql
CREATE ROLE clinic_quality NOLOGIN;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO clinic_quality;
CREATE TABLE referrals (referral_id integer PRIMARY KEY, referred_to text NOT NULL);
SELECT has_table_privilege('clinic_quality', 'visit_notes', 'SELECT') AS existing_table,
       has_table_privilege('clinic_quality', 'referrals', 'SELECT') AS new_table;
-- The standing rule: every table postgres creates in public from now on
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT SELECT ON TABLES TO clinic_quality;
CREATE TABLE referral_outcomes (referral_id integer PRIMARY KEY, outcome text NOT NULL);
SELECT has_table_privilege('clinic_quality', 'referrals', 'SELECT') AS before_rule,
       has_table_privilege('clinic_quality', 'referral_outcomes', 'SELECT') AS after_rule;
DROP TABLE referral_outcomes, referrals;
-- Output:
-- CREATE ROLE
-- GRANT
-- CREATE TABLE
--  existing_table | new_table
-- ----------------+-----------
--  t              | f
--
-- ALTER DEFAULT PRIVILEGES
-- CREATE TABLE
--  before_rule | after_rule
-- -------------+------------
--  f           | t
--
-- DROP TABLE
```

**Explain:** In one or two sentences, explain why `referrals` stayed closed even after the default-privileges rule was set, and what that means for the order in which you write a provisioning script.

### Fix It 5.1: The Grant That Took and Did Not Work 🔧

Luis Ortega, the academy's registrar, wants a class roster view in a schema of its own, and his reporting role has `SELECT` on it. The `GRANT` returned without complaint, and the first report fails.

**Symptom:** You ran the script in the Repair block below without its `GRANT USAGE` line: schema, view, role, and `GRANT SELECT` on the view. Then you tested the grant as the registrar role, and the test was refused.

```text
SET ROLE academy_registrar;
SELECT COUNT(*) AS roster_rows
FROM academy.class_roster;
```

```text
ERROR:  permission denied for schema academy
LINE 2: FROM academy.class_roster;
```

**Diagnose:** State the cause in one sentence before you change anything. The error names a schema, not a view, so which of the three doors is still closed, and why did the `GRANT` on the view not open it?

**Repair:** Step back out of the registrar role with `RESET ROLE`, grant the missing schema privilege, and run the same test again. The block below is the whole script with the one added line, so you can paste it as is. `SET ROLE` switches your session to a role you are a member of, and a superuser is a member of every role. State what changed and what did not.

```sql
\connect harquahala_academy
CREATE SCHEMA academy;
CREATE VIEW academy.class_roster AS
SELECT s.section_id, s.term, st.first_name, st.last_name, st.grade_level
FROM sections AS s
JOIN enrollments AS e ON e.section_id = s.section_id
JOIN students AS st ON st.student_id = e.student_id;
CREATE ROLE academy_registrar NOLOGIN;
GRANT SELECT ON academy.class_roster TO academy_registrar;
-- The repair: open the schema door the view grant could not open
GRANT USAGE ON SCHEMA academy TO academy_registrar;
SET ROLE academy_registrar;
SELECT COUNT(*) AS roster_rows
FROM academy.class_roster;
RESET ROLE;
SELECT has_schema_privilege('academy_registrar', 'academy', 'USAGE') AS schema_usage;
-- Output:
-- CREATE SCHEMA
-- CREATE VIEW
-- CREATE ROLE
-- GRANT
-- GRANT
-- SET
--  roster_rows
-- -------------
--         6000
--
-- RESET
--  schema_usage
-- --------------
--  t
```

**Verify:** How do you know it is fixed for the next role as well as this one? Explain why the last line of the block, the catalog function's `t`, is stronger evidence than the working `COUNT(*)` above it.

### Quick Check 5.2 ✅

1. A new role can connect to the clinic database without any `GRANT CONNECT`. Explain where the privilege came from and state the one statement that closes the door for every future role at once.
2. The billing contractor needs `insurance_member_id` and patient names but never addresses. Choose between a view and a column-level grant, and defend the choice in two sentences.

---

## 5.3 Role-Based Access Control: Grant to the Job, Not the Person

Section 5.2 granted privileges to `clinic_frontdesk`, a role nobody can log in as. That was the point. **Role-based access control (RBAC)** grants privileges to jobs and then assigns people to jobs. When Grace Yazzie's team hires someone, you add one membership. When someone leaves, you remove one. The privilege list never changes, so it never drifts by accident. A **group role** is a role that exists to hold privileges for its members. A login role becomes a member with `GRANT group TO member`, the same `GRANT` you already know, applied to a role instead of a table.

### The Role Hierarchy

Groups can belong to groups. Everyone at the clinic may see the provider list, so `clinic_staff` holds that one grant and every job role joins it. `clinic_provider` adds the clinical tables. Dr. Vasquez's own login joins `clinic_provider` and holds no grants of its own. The `IN ROLE` clause on `CREATE ROLE` makes the membership at creation time:

```sql
\connect sandwash_clinic
-- Step 1: The base group that every job at the clinic shares
CREATE ROLE clinic_staff NOLOGIN;
GRANT SELECT ON providers TO clinic_staff;
-- Step 2: A job group inherits the base and adds its own tables
CREATE ROLE clinic_provider NOLOGIN IN ROLE clinic_staff;
GRANT SELECT ON appointments, patients, visit_notes TO clinic_provider;
GRANT SELECT (username, provider_id) ON staff_accounts TO clinic_provider;
-- Step 3: A job created earlier joins the base the same way
GRANT clinic_staff TO clinic_frontdesk;
-- Step 4: A person joins a job and receives no direct grants at all
CREATE ROLE clinic_evasquez LOGIN
  PASSWORD 'Sandwash-Ch5-Provider-2026!'
  IN ROLE clinic_provider;
-- Output:
-- CREATE ROLE
-- GRANT
-- CREATE ROLE
-- GRANT
-- GRANT
-- GRANT ROLE
-- CREATE ROLE
```

The narrow grant on `staff_accounts` in Step 2 exists for the row-level policy later in this section, which maps a login back to a provider. **Inheritance** is what makes the hierarchy work. A member uses the privileges of its group automatically, and its group's group, all the way up. PostgreSQL records every membership in `pg_auth_members`, and Skills Lab 5A reads that catalog. Test the chain from the bottom with `SET ROLE`:

```sql
SET ROLE clinic_evasquez;
SELECT current_user AS who,
       (SELECT COUNT(*) FROM providers) AS providers_visible,
       (SELECT COUNT(*) FROM appointments) AS appointments_visible;
RESET ROLE;
-- Output:
-- SET
--        who       | providers_visible | appointments_visible
-- -----------------+-------------------+----------------------
--  clinic_evasquez |                12 |                 6000
--
-- RESET
```

Dr. Vasquez's login reads the provider list through `clinic_staff` and every appointment through `clinic_provider`, and it holds no grant of its own. That second number is the problem this section exists to fix. A `GRANT` decides whether a role may read a table. It cannot decide which rows. Dr. Vasquez should see her 476 appointments, not all 6,000.

A role created with `NOINHERIT` breaks the chain on purpose and must `SET ROLE` to its group before using its privileges, which keeps a powerful membership from being active by default. The course roles keep the default, `INHERIT`.

### Row-Level Security

**Row-level security** lets a table filter its own rows by who is asking. You enable it on the table, then attach policies. A **policy** is a named rule with a `USING` expression that must be true for a row to be visible to the roles the policy names. The expression can reference `current_user`, so one policy serves every provider. The clinic maps a login to a provider through `staff_accounts`, whose `username` column is the login role without its `clinic_` prefix:

```sql
ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;
-- The subquery runs as the asking role, hence the staff_accounts grant above
CREATE POLICY provider_own_appointments ON appointments
  FOR SELECT
  TO clinic_provider
  USING (provider_id = (SELECT provider_id
                        FROM staff_accounts
                        WHERE 'clinic_' || username = current_user));
SET ROLE clinic_evasquez;
SELECT current_user AS who,
       COUNT(*) AS appointments_visible,
       COUNT(DISTINCT provider_id) AS providers_seen
FROM appointments;
RESET ROLE;
SET ROLE clinic_frontdesk;
SELECT current_user AS who,
       COUNT(*) AS appointments_visible
FROM appointments;
RESET ROLE;
-- Output:
-- ALTER TABLE
-- CREATE POLICY
-- SET
--        who       | appointments_visible | providers_seen
-- -----------------+----------------------+----------------
--  clinic_evasquez |                  476 |              1
--
-- RESET
-- SET
--        who        | appointments_visible
-- ------------------+----------------------
--  clinic_frontdesk |                    0
--
-- RESET
```

The same table, the same `SELECT COUNT(*)`, and Dr. Vasquez's answer dropped from 6,000 to 476, every one of them hers. Nothing in her query changed. The table did the filtering, so an application bug, a saved report, or a curious query all get the same answer. Two roles bypass the filter: superusers, and the table's owner unless you run `ALTER TABLE ... FORCE ROW LEVEL SECURITY`. That is one more reason the clinic's application must never connect as `postgres`.

The front desk's answer is the other lesson. Enabling row-level security changes the table for every role that is not the owner, and with no policy naming them, the front desk sees nothing at all. Zero rows and no error is the signature of a missing policy, and it is easy to mistake for an empty table:

```sql
-- The front desk schedules for everyone, so its policy passes every row
CREATE POLICY frontdesk_all_appointments ON appointments
  FOR SELECT
  TO clinic_frontdesk
  USING (true);
SET ROLE clinic_frontdesk;
SELECT COUNT(*) AS appointments_visible
FROM appointments;
RESET ROLE;
-- Output:
-- CREATE POLICY
-- SET
--  appointments_visible
-- ----------------------
--                  6000
--
-- RESET
```

When you turn on row-level security, walk the matrix and write one policy for every role the table lists, including the roles that may see everything.

### The Academy's Teachers

The academy needs the same control on `grades`. Ms. Keisha Bell teaches four sections, and FERPA's legitimate-educational-interest rule (Chapter 4) means she may see the grades in those sections and no others. The clinic mapped logins to people through a `username` column. The academy's `staff` table has none, so the mapping is a decision you make and record. Build it from each staff member's full name, which is unique in this data, and confirm the two logins this section uses:

```sql
\connect harquahala_academy
CREATE TABLE staff_logins AS
SELECT staff_id,
       'academy_' || lower(replace(full_name, ' ', '_')) AS login_role
FROM staff;
ALTER TABLE staff_logins ADD PRIMARY KEY (staff_id);
ALTER TABLE staff_logins ADD UNIQUE (login_role);
SELECT sl.login_role, COUNT(sec.section_id) AS sections_taught
FROM staff_logins AS sl
LEFT JOIN sections AS sec ON sec.staff_id = sl.staff_id
WHERE sl.staff_id IN (1, 45)
GROUP BY sl.login_role
ORDER BY sl.login_role;
-- Output:
-- SELECT 60
-- ALTER TABLE
-- ALTER TABLE
--      login_role      | sections_taught
-- ---------------------+-----------------
--  academy_keisha_bell |               4
--  academy_luis_ortega |               0
```

The `UNIQUE` constraint is the point of the second `ALTER TABLE`. If two staff members ever produced the same login name, the constraint would refuse the mapping instead of letting two people share one identity.

### Try It Yourself 5.3: Complete the Teacher Policy 🛠️

You are Copperwind's database administrator, and Principal Whitfield has approved a read-only gradebook view for teachers, limited to their own sections. The script below builds it. Three pieces are missing.

**Predict:** For each `____`, write down what belongs there and one phrase saying why. The first gap is a role attribute, the second is a keyword, and the third is a function you met in the clinic policy. Then predict the shape of the output: how many rows, and roughly how many students in total for a teacher with four sections.

**Run:** Copy the script into a file, fill the gaps, and run it as `postgres` in `harquahala_academy` after the `staff_logins` block above. Compare your output with the expected output that follows.

```text
-- Step 1: One group role for every teacher. It never logs in itself.
CREATE ROLE academy_teacher ____;
-- Step 2: The minimum a teacher needs, read only
GRANT SELECT ON sections, enrollments, grades, staff_logins TO academy_teacher;
-- Step 3: Turn on row filtering for grades
ALTER TABLE grades ____ ROW LEVEL SECURITY;
-- Step 4: Keep only the rows from sections the current login teaches
CREATE POLICY teacher_own_sections ON grades
  FOR SELECT
  TO academy_teacher
  USING (enrollment_id IN (
    SELECT e.enrollment_id
    FROM enrollments AS e
    JOIN sections AS s ON s.section_id = e.section_id
    JOIN staff_logins AS sl ON sl.staff_id = s.staff_id
    WHERE sl.login_role = ____));
-- Step 5: One teacher's login, a member of the group
CREATE ROLE academy_keisha_bell LOGIN
  PASSWORD 'Harquahala-Ch5-Teacher-2026!'
  IN ROLE academy_teacher;
-- Step 6: Prove it as the teacher, then step back out
SET ROLE academy_keisha_bell;
SELECT term_grade, COUNT(*) AS students
FROM grades
GROUP BY term_grade
ORDER BY term_grade;
RESET ROLE;
```

```text
 term_grade | students
------------+----------
 A          |       68
 B          |       52
 C          |       47
 D          |       17
 F          |        5
```

**Explain:** The academy has 6,000 grade rows and Ms. Bell sees 189. In one or two sentences, explain which single expression in the policy produced that number, and what a teacher would see if you had created her login without `IN ROLE academy_teacher`.

### Try It Yourself 5.4: A Policy for the Parks Department 🛠️

**Predict:** A city parks department stores picnic-shelter reservations in one table with a `park_id` column, and each ranger's login is listed in a `ranger_parks` table with the parks that ranger covers. Some rangers cover two parks. Before you write anything, predict whether the clinic's `provider_id = (SELECT ...)` pattern will work here, and what will go wrong if a ranger covers two parks.

**Run:** Write the `CREATE POLICY` statement on paper or in a text file. Name the table, the role it applies to, and the `USING` expression, and choose between `=` and `IN` on purpose. Then write the one extra policy the reservations clerk needs so the desk does not go dark.

**Explain:** In one or two sentences, explain why the choice between `=` and `IN` is a data question before it is a syntax question, and what error or wrong result each choice risks.

### Quick Check 5.3 ✅

1. A new nurse practitioner joins the clinic. List the statements you run, in order, and state which existing statement you do not touch because RBAC was done right.
2. Dr. Vasquez runs `SELECT COUNT(*) FROM appointments` and gets 476. The office manager runs the same query and gets 0. Explain both numbers and state which one is a bug.

---

## 5.4 Access Reviews: Prove It Still Matches

The matrix in Section 5.2 was true when Dr. Vasquez signed it. An **access review** is the scheduled comparison of what the server allows against what the data owner approved. **Drift** is the difference: a role nobody remembers creating, a grant made "for now" and never revoked, a policy that vanished when a table was rebuilt. HIPAA's administrative safeguards require a covered entity to review system activity and manage workforce access. FERPA asks a school to know who holds legitimate educational interest. Both assume you can answer four questions from evidence: who can log in, who belongs to which job, what each job can do, and which rows.

### Who Can Log In

Start wider than the matrix. The matrix names the roles you expect. The catalog names the roles that exist:

```sql
\connect sandwash_clinic
SELECT rolname AS role_name,
       rolsuper AS is_superuser,
       rolconnlimit AS conn_limit,
       rolvaliduntil::date AS valid_until
FROM pg_roles
WHERE rolcanlogin
  AND rolname NOT LIKE 'pg\_%'
ORDER BY rolname;
-- Output:
--       role_name       | is_superuser | conn_limit | valid_until
-- ----------------------+--------------+------------+-------------
--  clinic_backup_svc    | f            |          1 |
--  clinic_evasquez      | f            |         -1 |
--  clinic_reports_svc   | f            |         -1 |
--  clinic_scheduler_app | f            |          5 |
--  clinic_treyes        | f            |         -1 | 2027-06-30
--  postgres             | t            |         -1 |
```

Three of these you created in this chapter. Two you did not: `clinic_backup_svc` and `clinic_reports_svc` arrived with the database from the previous host. Neither appears in the matrix. Neither has an expiry. One has no connection limit. Unknown login roles are the first finding in nearly every review, because nobody deletes an account they do not remember creating. Write them down. Skills Lab 5A asks you to decide what each may keep.

### What Each Role Can Do

Direct grants are easy to list and misleading to read, because most privileges arrive through membership. **Effective privileges** are what a role can do once every membership it inherits is counted. `has_table_privilege()` answers with inheritance included. A review asks it about every role, every table, and every privilege that matters, and keeps the combinations that come back true. Scope it to one job family at a time so the answer fits on a page:

```sql
-- Step 1: Every role in the clinic_staff tree, superusers excluded
--         (a superuser is a member of everything and is reviewed separately)
WITH reviewed_roles AS (
  SELECT rolname
  FROM pg_roles
  WHERE pg_has_role(rolname, 'clinic_staff', 'MEMBER')
    AND NOT rolsuper
),
-- Step 2: Every base table in the schema under review
clinic_tables AS (
  SELECT tablename
  FROM pg_tables
  WHERE schemaname = 'public'
),
-- Step 3: The privileges that change data or expose it
checked_privileges AS (
  SELECT unnest(ARRAY['SELECT', 'INSERT', 'UPDATE', 'DELETE']) AS privilege
)
-- Step 4: Test every combination and keep only the ones that hold
SELECT r.rolname AS role_name,
       t.tablename AS table_name,
       string_agg(p.privilege, ', ' ORDER BY p.privilege) AS effective_privileges
FROM reviewed_roles AS r
CROSS JOIN clinic_tables AS t
CROSS JOIN checked_privileges AS p
WHERE has_table_privilege(r.rolname, 'public.' || t.tablename, p.privilege)
GROUP BY r.rolname, t.tablename
ORDER BY r.rolname, t.tablename;
-- Output:
--     role_name     |  table_name  | effective_privileges
-- ------------------+--------------+----------------------
--  clinic_evasquez  | appointments | SELECT
--  clinic_evasquez  | patients     | SELECT
--  clinic_evasquez  | providers    | SELECT
--  clinic_evasquez  | visit_notes  | SELECT
--  clinic_frontdesk | appointments | SELECT
--  clinic_frontdesk | providers    | SELECT
--  clinic_provider  | appointments | SELECT
--  clinic_provider  | patients     | SELECT
--  clinic_provider  | providers    | SELECT
--  clinic_provider  | visit_notes  | SELECT
--  clinic_staff     | providers    | SELECT
```

Lay this beside the matrix. Every provider row says `SELECT` and nothing else, which matches. The front desk holds `SELECT` on appointments and providers, which matches. Two grants are missing on purpose: the front desk's `patients` columns and the providers' `staff_accounts` columns. `has_table_privilege()` reports whole-table privileges only. Column grants are a separate question, answered by `has_column_privilege()` or by `information_schema.column_privileges`, and Skills Lab 5A asks it.

### Which Rows

A grant that matches the matrix still over-exposes data if the "own rows" cell has no policy behind it. Policies live in `pg_policies`, one row each, and a table that should filter but has no row here is a finding:

```sql
SELECT tablename, policyname, roles AS applies_to
FROM pg_policies
ORDER BY tablename, policyname;
-- Output:
--   tablename   |         policyname         |     applies_to
-- --------------+----------------------------+--------------------
--  appointments | frontdesk_all_appointments | {clinic_frontdesk}
--  appointments | provider_own_appointments  | {clinic_provider}
```

Only `appointments` is filtered. The matrix says providers see their own rows in `patients` and `visit_notes` too, so this review has found two gaps that no `GRANT` query would show. Recording a gap is a finding, not a failure. The failure would be a review that never asked. (`pg_class.relrowsecurity` tells you the other half: a table with row security on and no policy at all is the zero-rows problem from Section 5.3.)

### Documenting the Review

A review nobody can read next quarter did not happen. Naomi Redhouse signs a short record with the same seven fields every time, so two reviews can be compared. Scope names the database, the schema, and the matrix version compared against. Date and reviewer say when and who. Method lists the queries, pasted or referenced by file. Findings state each difference from the matrix, with the output that shows it. Actions record the `REVOKE`, `DROP ROLE`, or `CREATE POLICY` taken, or the ticket opened. Residual risk says what was left as is and who accepted it. Sign-off closes the record. Keep it beside the signed matrix. The next review starts by reading the last one, so drift is measured from the previous record, not from memory.

### Try It Yourself 5.5: Catch the Grant Made "For Now" 🛠️

**Predict:** A front-desk lead asked for permission to correct phone numbers, and someone granted `UPDATE` on `patients` to `clinic_frontdesk` without telling you. Before you run anything, predict which review query will show it and what the row will say. Then predict why a role that cannot read a whole table can still appear as able to update it.

**Run:** Plant the grant, run the effective-privilege review restricted to write privileges, then revoke it and prove the revoke took effect.

```sql
GRANT UPDATE ON patients TO clinic_frontdesk;
SELECT r.rolname AS role_name,
       t.tablename AS table_name,
       string_agg(p.privilege, ', ' ORDER BY p.privilege) AS write_privileges
FROM (SELECT rolname FROM pg_roles
      WHERE pg_has_role(rolname, 'clinic_staff', 'MEMBER')
        AND NOT rolsuper) AS r
CROSS JOIN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') AS t
CROSS JOIN (SELECT unnest(ARRAY['INSERT', 'UPDATE', 'DELETE']) AS privilege) AS p
WHERE has_table_privilege(r.rolname, 'public.' || t.tablename, p.privilege)
GROUP BY r.rolname, t.tablename
ORDER BY r.rolname, t.tablename;
REVOKE UPDATE ON patients FROM clinic_frontdesk;
SELECT has_table_privilege('clinic_frontdesk', 'patients', 'UPDATE') AS can_update;
-- Output:
-- GRANT
--     role_name     | table_name | write_privileges
-- ------------------+------------+------------------
--  clinic_frontdesk | patients   | UPDATE
--
-- REVOKE
--  can_update
-- ------------
--  f
```

**Explain:** In one or two sentences, explain why a review that lists only `SELECT` grants would have missed this. Then state the right answer to the front-desk lead's request (name the column and the statement).

### Quick Check 5.4 ✅

1. A review shows a role with `SELECT` on every clinic table and no membership in any group. Name the two questions you ask before deciding whether that is drift, and who answers each.
2. Explain why `information_schema.role_table_grants` alone would have missed the privileges Dr. Vasquez's login holds, and name the function that does not miss them.

---

## 5.5 Summary and Retrieval 💡

### Key Concepts

* Authentication asks who is connecting. Authorization asks what they may do. People and programs get different login roles: a person gets an expiry date, a service account gets a connection limit, and nobody shares an account, because a shared account cannot be traced.
* A role reaches a row through three doors: `CONNECT` on the database, `USAGE` on the schema, and a privilege on the table. PUBLIC opens the first two on a fresh server. A schema you create starts closed, so a grant can succeed and still not work.
* The access control matrix is the data owner's decision in a form you can implement and audit. Column grants and "none" cells make it exact. Default privileges make it hold for tables that do not exist yet.
* Role-based access control grants to jobs and assigns people to jobs. Group roles nest, members inherit, and a person holds no direct grants. Row-level security filters rows by `current_user`, and enabling it without a policy for a role empties that role's table.
* An access review compares the catalog with the matrix on a schedule. Effective privileges come from `has_table_privilege()`, not from the grant list. Expect unknown login roles, write privileges nobody asked for, and tables with row security but no policy. The next review starts from the record, not from memory.

### Key Terms

See course glossary for full definitions

* authentication, authorization, login role, service account, connection limit, SCRAM-SHA-256 (Section 5.1)
* privilege, PUBLIC, access control matrix, default privileges (Section 5.2)
* role-based access control (RBAC), group role, inheritance, row-level security, policy (Section 5.3)
* access review, drift, effective privileges (Section 5.4)

### Retrieval Practice

1. From memory, list the three doors a role passes through to read a table, and the privilege each door requires.
2. Explain the difference between a login role and a group role, and state the rule about direct grants that role-based access control depends on.
3. State what a role with `SELECT` on a table sees the moment row-level security is enabled with no policy naming that role, and why the result is dangerous.
4. From Chapter 3: A `CHECK` constraint and a row-level security policy both refuse something. State what each one refuses and which CIA property each one protects.
5. From Chapter 1: Name the role that decides who should see a patient's record and the role that proves the configuration matches. Explain how an access review connects the two.

---

## 5.6 Skills Lab 5A: Roles for the Clinic

**Goal:** Design the clinic's access control matrix for four staff roles and implement it with group roles, least-privilege grants, and row-level security that limits providers to their own patients. Then run the access review that catches what the previous host left behind.

**Dataset or starter files:** `assets/code/chapter-05/` in the course data pack. `setup-sandwash.sql` rebuilds `sandwash_clinic` in the state this chapter starts from, including two login roles inherited from the clinic's previous host. `skills-lab-5a.sql` is the starter script with numbered markers. `skills-lab-5a-answers.md` holds the matrix, the review record, and the two Questions & Analysis answers. The setup script loads the CSVs in `assets/code/data/sandwash/`. The clinic and every record in it are fictional.

Dr. Vasquez has ruled on the cells, and the ruling is your specification:

* Providers see providers, and their own patients' rows in `appointments`, `patients`, and `visit_notes`. "Own" means a patient who has an appointment with that provider.
* The front desk sees every appointment and every provider. On `patients` it sees `patient_id`, `first_name`, `last_name`, and `phone` only.
* Billing sees every appointment and every provider. On `patients` it sees `patient_id`, `first_name`, `last_name`, and `insurance_member_id`. On `visit_notes` it sees `note_id`, `appointment_id`, and `diagnosis_code`, never `note_text`.
* The office manager sees providers, appointments, and `staff_accounts`, and no patient data.
* Nobody in the four roles inserts, updates, or deletes anything. The application does that through its own service account, which is a later lab.

### Part 1: Foundation (Aligns with Objective 5.1)

1. From the extracted `cis376` folder, run `setup-sandwash.sql` as `postgres`. It drops every existing `clinic_` role first, so you start where the book starts. Under marker 1.1, list every login role on the server that is not a system role, with its connection limit and expiry, and paste the result.
2. In the answer file, fill the access control matrix for `clinic_provider`, `clinic_frontdesk`, `clinic_billing`, and `clinic_office_manager` against the five clinic tables. Every cell is a privilege with a column list where the ruling limits columns, "own rows" where a policy is required, or "none". Add one phrase per non-empty cell naming the job task that needs it.
3. Under marker 1.2, create the four group roles with `NOLOGIN`. Then create one login role for a person from `staff_accounts` in each of three jobs: `clinic_evasquez` (provider), `clinic_bsalazar` (front desk), and `clinic_gyazzie` (billing). Give each a visibly fake password of its own and an expiry date, and make each a member of its job role. Verify the memberships with a query that joins `pg_auth_members` to `pg_roles` for the member and the group.

### Part 2: Application (Aligns with Objectives 5.1 and 5.2)

1. Under marker 2.1, implement every cell of your matrix with `GRANT`, using column lists where the matrix names columns. After each role's grants, prove them with one `has_table_privilege()` or `has_column_privilege()` query that returns at least one `t` and one `f`. Paste every result.
2. Under marker 2.2, enable row-level security on `appointments`, `patients`, and `visit_notes` and write the provider policies. The `patients` and `visit_notes` policies reach the provider through `appointments`, so plan the subqueries before you type them. Then write the policies the front desk, billing, and office manager need so none of their tables goes dark. Query `pg_policies` and paste the list.
3. Under marker 2.3, `SET ROLE clinic_evasquez` and count the rows she can see in each of the three tables. `RESET ROLE`, then count the same rows as `postgres` filtered to `provider_id = 1`. Paste both sets of numbers side by side in the answer file. They must match. If they do not, the policy is wrong, not the count.

### Part 3: Extension (Aligns with Objectives 5.2 and 5.3)

1. Under marker 3.1, run the full access review: login roles, memberships, effective table privileges for every `clinic_` role (not only the `clinic_staff` tree), column privileges from `information_schema.column_privileges`, and `pg_policies`. Paste every result.
2. In the answer file, list every role the matrix does not name and every privilege the review shows that the matrix does not allow. One of them is an over-grant the previous host left behind. Name it and state the CIA property it threatens and the harm a curious or compromised account could do with it. Remediate it under marker 3.2 with the narrowest statement that removes the risk, rerun the review query that found it, and paste the proof.
3. Write the access review record for Naomi Redhouse using the seven fields from Section 5.4. Include a decision on `clinic_backup_svc`: what a backup account needs, whether its current privileges are justified, and what you changed or left in place and why.

### Questions & Analysis 🤔

1. Using your Part 2.3 numbers as evidence, explain what row-level security adds that the grants in Part 2.1 could not. Then name one exposure it does not close (consider who bypasses it and how the application connects).
2. You could have fixed the planted over-grant by revoking the extra privileges or by dropping the account. Justify the choice you made with evidence from your review output, and state the one question you would ask Tomas Reyes before choosing the other option.

**Submission:** Submit one folder named `skills-lab-5a-lastname`. It holds `skills-lab-5a.sql` with every result pasted as `-- Output:` comment lines (or the saved psql output beside it). It also holds `skills-lab-5a-answers.md` with the completed matrix, the side-by-side row counts, the access review record, and your two Questions & Analysis answers clearly labeled.

### Rubric: Skills Lab 5A

This lab is graded with the standard
[Skills Lab Rubric](../skills-lab-rubric.md): four criteria, five
levels from Mastery to Not Evident. The criteria are Technical
Accuracy and Efficiency, Output Quality, Documentation Quality, and
Analysis, Interpretation, and Response to QUESTION(s). The criteria
and levels are the same everywhere. Your instructor sets the point
values in your course. Check the syllabus and the Canvas rubric
attached to this lab for the values that apply to you.

---

## 5.7 Review Questions 🔄️

1. **Apply:** A nonprofit food bank runs a donor database with a volunteer coordinator, a grant writer, and a nightly export job. Write the `CREATE ROLE` statements for all three, choosing `LOGIN`, `CONNECTION LIMIT`, and `VALID UNTIL` for each, and state in one line per role why you chose what you chose.

2. **Analyze:** A law office reports that its paralegal role "can see case notes it should not." The paralegal login is a member of `office_staff`, which is a member of `case_readers`. Describe the two catalog queries you run first, in order, and explain what each one can and cannot tell you about where the privilege came from.

3. **Evaluate:** A bike shop's point-of-sale vendor wants one database role for the whole application, with row-level security to keep each store's data separate, and argues that per-clerk roles are "overkill." Judge the proposal against the evidence argument in Section 5.1 and the bypass rules in Section 5.3, and state the one condition under which you would accept it.

4. **Create:** Design the quarterly access review for the academy database. Name the four questions it answers, the query or catalog view that answers each, the roles that receive the record, and the two findings you would treat as blocking until they are fixed.

---

## Further Reading 📖

* [PostgreSQL Documentation: Privileges](https://www.postgresql.org/docs/17/ddl-priv.html) - The complete privilege list for every object type and the rules for PUBLIC, default privileges, and the `has_*_privilege()` functions.
* [PostgreSQL Documentation: Row Security Policies](https://www.postgresql.org/docs/17/ddl-rowsecurity.html) - Policy syntax, permissive versus restrictive policies, and the exact bypass rules for owners and superusers.
* [PostgreSQL Documentation: Password Authentication](https://www.postgresql.org/docs/17/auth-password.html) - Why SCRAM-SHA-256 replaced MD5 and how the `password_encryption` setting interacts with `pg_hba.conf`.
* [NIST SP 800-53 Rev. 5](https://csrc.nist.gov/pubs/sp/800/53/r5/upd1/final) - The Access Control (AC) family, including AC-2 Account Management and AC-6 Least Privilege, which this chapter's matrix and review implement.
* [OWASP Authorization Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authorization_Cheat_Sheet.html) - Least privilege, deny by default, and the application-side habits that keep a well-configured database from being bypassed.

---

## Looking Ahead ⏩

Every control in this chapter assumes the database is the only way to the data. A backup file on a shared drive, a network capture, or a stolen laptop reads the rows without asking any role for permission. Chapter 6 is for that case. You will hash the academy's portal passwords and encrypt the clinic's insurance numbers with pgcrypto so that a stolen copy is unreadable. You will put TLS on the connection so that a listener on the network learns nothing. Access control decides who may ask. Encryption decides what an unauthorized reader gets.
