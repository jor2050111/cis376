# Chapter 3: Data Modeling and Integrity

A front-desk clerk at a clinic types "Complete" instead of "Completed" and the no-show report undercounts for a month. A school exports its gradebook to a spreadsheet, a teacher's name gets typed three different ways, and the registrar cannot tell how many sections that teacher taught. Two schedulers book the same provider for the same 3:00 slot, and neither system said no. None of these is an attack. Each one is data the database accepted because nobody told it not to.

You have written CREATE TABLE with a primary key and a foreign key. In your SQL course those keys were how joins worked. In this chapter they are the first line of defense for integrity, the second property of the CIA triad you met in Chapter 1. A database that enforces its own rules stops bad data at the door, whether the bad data comes from a tired clerk, a buggy import script, or an attacker with a stolen password. A database that trusts its applications to check first will eventually store whatever they send.

This chapter closes Part I. You will put the five constraint types and transactions to work as controls on the Sandwash clinic database. You will learn why one dataset takes two shapes, one for the front desk and one for the reports. You will weigh relational, NoSQL, and Big Data models against a workload and see where PostgreSQL's JSONB type bridges them. Then you will reorganize a flat import into Third Normal Form and see what that buys security. The Skills Lab hands you the Harquahala gradebook export, anomalies included, and asks you to redesign it so the bad rows can never come back.

## Module Overview 🧭

* **Estimated time:** 5-6 hours
* **Prerequisites:** One prior SQL course (Introduction to Oracle: SQL, CIS276DA MySQL Database, or CIS276DB SQL Server Database). Chapter 1 (a working PostgreSQL 17 server and the course data pack). This chapter's folder rebuilds the two databases it uses, so no saved work is required.
* **Deliverables:** Skills Lab 3A folder (`skills-lab-3a.sql` and `skills-lab-3a-answers.md`), Quick Checks

## Learning Objectives 🎯

By the end of this chapter, you will be able to:

* **3.1 (Apply):** Implement integrity constraints and transactions that keep a database consistent under concurrent use (Section 3.1)
* **3.2 (Evaluate):** Justify a relational, NoSQL, or hybrid data model for a transactional or reporting workload (Sections 3.2-3.3)
* **3.3 (Create):** Reorganize a flawed flat schema into Third Normal Form and explain how the redesign supports integrity and data separation (Section 3.4)

### This chapter aligns with the following Course Learning Outcomes

* **CLO I (Analyze):** Analyze database architecture and design for business solutions.
* **CLO III (Create):** Develop strategies to maintain optimal system performance, security and availability.
* **CLO V (Evaluate):** Critique current practices and future trends of database management and security.

---

## 3.1 Integrity the Database Enforces

Chapter 1 put "two schedulers book the same slot" in the threat table and pointed here. This section is the answer. An **integrity constraint** is a rule the database checks on every insert and update, and refuses to break. You declared constraints in your SQL course so that joins would work. From the management side they do a second job. They are controls that run whether or not the application remembered to check, whether or not the person at the keyboard is honest, and at three in the morning when nobody is watching.

Five constraint types cover most of the rules a business can state about a single table. Each answers a different way data goes wrong:

| Constraint | The rule it enforces | The bad data it stops | Clinic example |
| --- | --- | --- | --- |
| PRIMARY KEY | Every row has one unique, non-null identifier | Duplicate or missing records | Two rows for one appointment |
| FOREIGN KEY | A value must exist in the parent table | Orphans and typos in references | A visit note for an appointment that does not exist |
| UNIQUE | No two rows share the value | Accidental duplicates | Two providers with the same NPI |
| NOT NULL | The column must hold a value | Silent blanks | An appointment with no provider |
| CHECK | The value satisfies a condition you write | Out-of-range and misspelled values | A status of "Complete" |

The first four you know. The fifth, the **CHECK constraint**, is the one most databases never use and most bad data walks through. A CHECK holds any true-or-false condition on the row: a status drawn from a fixed list, a date of birth in the past, a discharge time after an admit time. When the application enforces the list and the database does not, every other path into the table (an import script, a support engineer in psql, a second application) can break the rule. When the database enforces it, no path can.

Start by asking the clinic database what it already enforces. `pg_constraint` is a PostgreSQL system catalog (the portable equivalent is `information_schema.table_constraints`, which shows less detail):

```sql
\connect sandwash_clinic
SELECT conname AS constraint_name,
       contype AS type,
       pg_get_constraintdef(oid) AS definition
FROM pg_constraint
WHERE conrelid = 'appointments'::regclass
ORDER BY conname;
-- Output:
--         constraint_name        | type |                         definition
-- -------------------------------+------+-------------------------------------------------------------
--  appointments_patient_id_fkey  | f    | FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
--  appointments_pkey             | p    | PRIMARY KEY (appointment_id)
--  appointments_provider_id_fkey | f    | FOREIGN KEY (provider_id) REFERENCES providers(provider_id)
```

Type `p` is the primary key and `f` marks the two foreign keys. There is no `c` row, so `status` accepts any text at all. The prose in the setup script says the four valid values are Scheduled, Completed, Cancelled, and No-show. Nothing on the server knows that yet. You will fix that in Try It Yourself 3.2.

### The Constraint You Cannot Add

Now the double-booking threat. The obvious control is `UNIQUE (provider_id, scheduled_at)`: one provider, one slot, one appointment. Before you add a constraint to a table that already holds data, ask whether the data already breaks it, because PostgreSQL will refuse to add a constraint that existing rows violate:

```sql
-- Count the slots that already hold two appointments for one provider.
SELECT COUNT(*) AS double_booked_slots
FROM (
  SELECT provider_id, scheduled_at
  FROM appointments
  GROUP BY provider_id, scheduled_at
  HAVING COUNT(*) > 1
) AS collisions;
-- Output:
--  double_booked_slots
-- ---------------------
--                   12
```

Twelve slots are already double-booked. The UNIQUE constraint would be rejected, and that rejection is useful information. The rule was never enforced, so the data drifted. Which appointment in each pair is real? That is a data-owner decision for Dr. Vasquez and the office manager, not a DBA decision. Your job is to bring them the twelve rows, get a ruling, clean the data, and then add the constraint so the thirteenth collision never happens. A constraint you cannot add is a finding, and findings go to the owner.

### Try It Yourself 3.1: Which Constraint Stops It? 🛠️

**Predict:** A credit union's loan database has five recurring problems. Before reading on, name the one constraint type from the table above that would have stopped each. The problems: a loan with no member number, two members with the same Social Security number, and a payment posted to a loan number that was never issued. Also an interest rate of 240 percent, and the same loan appearing twice with different balances.

**Run:** Write each problem in a three-column table: Problem, Constraint, and the column or columns it applies to. Then mark which of the five could be enforced by the application alone and which need the database, given that the credit union also loads payments from a nightly file.

**Explain:** In one or two sentences, explain why the nightly file changes your answer for at least one row.

### Transactions and ACID

Constraints protect one row at a time. A **transaction** protects a group of statements: either all of them take effect or none do. Closing out a clinic visit is two statements, an update to the appointment and an insert of the visit note. If the server loses power between them, the clinic has a completed visit with no note, or a note for a visit still marked Scheduled. Wrap both in one transaction and that half-finished state cannot survive.

```sql
-- Close out one visit as a single unit of work.
BEGIN;
UPDATE appointments
SET status = 'Completed'
WHERE appointment_id = 430;
INSERT INTO visit_notes (note_id, appointment_id, diagnosis_code, note_text)
VALUES (4487, 430, 'Z00.00', 'Routine visit, no concerns.');
COMMIT;
SELECT a.appointment_id, a.status, v.diagnosis_code
FROM appointments AS a
JOIN visit_notes AS v USING (appointment_id)
WHERE a.appointment_id = 430;
-- Output:
-- BEGIN
-- UPDATE 1
-- INSERT 0 1
-- COMMIT
--  appointment_id |  status   | diagnosis_code
-- ----------------+-----------+----------------
--             430 | Completed | Z00.00
```

Both changes landed together. Had the INSERT failed (a bad `appointment_id`, a duplicate `note_id`), a `ROLLBACK` would have undone the UPDATE too, and the visit would still read Scheduled with no note. The guarantees a transaction makes have a name you will hear in every vendor's documentation. **ACID** stands for four properties:

| Property | What it promises | The clinic failure it prevents |
| --- | --- | --- |
| Atomicity | All statements in the transaction take effect, or none | A completed visit with no note |
| Consistency | Every constraint holds when the transaction ends | A note pointing at a deleted appointment |
| Isolation | Concurrent transactions do not see each other's half-finished work | A report that counts a visit before it is closed |
| Durability | Once committed, the change survives a crash | A visit closed at 4:59 that is gone at 5:01 |

Isolation is the property that matters under concurrent use, and it is the one applications get wrong. Two front-desk clerks each read that the 3:00 slot is open, each insert an appointment, and each commit. The application checked. The check was true when it ran. This is a **lost update**, one of the classic concurrency failures, and no amount of checking in the application prevents it, because the two checks cannot see each other. The only reliable control is a constraint the database enforces at commit time. With `UNIQUE (provider_id, scheduled_at)` in place, whichever clerk commits second gets an error instead of a double booking. That is why the twelve collisions above matter: the constraint is the fix, and the data has to be clean before the fix can go in.

!!! note "PostgreSQL's default isolation level"
    PostgreSQL runs every transaction at the Read Committed level unless you ask for more. Each statement sees data committed before that statement started. That is enough for the front desk when the constraints are in place. Reports that must see one consistent snapshot across many statements ask for `REPEATABLE READ`. The Further Reading links the concurrency chapter that explains the tradeoff.

### Try It Yourself 3.2: A Bad Update Meets a CHECK Constraint 🛠️

You manage the Sandwash clinic database for Copperwind, and the no-show report has been undercounting because someone keeps typing "Complete". You will make that impossible, then prove it.

**Predict:** You will add a CHECK constraint that limits `status` to the four valid values, open a transaction, and run an UPDATE that sets one appointment to "Complete". Before you run it, write down what you expect to see after the UPDATE and what the status counts will show after you roll back.

**Run:** Add the constraint and confirm the catalog now shows a `c` row:

```sql
ALTER TABLE appointments
ADD CONSTRAINT appointments_status_check
CHECK (status IN ('Scheduled', 'Completed', 'Cancelled', 'No-show'));
SELECT conname AS constraint_name,
       pg_get_constraintdef(oid) AS definition
FROM pg_constraint
WHERE conrelid = 'appointments'::regclass
  AND contype = 'c';
-- Output:
-- ALTER TABLE
--       constraint_name      |                                                definition
-- ---------------------------+----------------------------------------------------------------------------------------------------------
--  appointments_status_check | CHECK ((status = ANY (ARRAY['Scheduled'::text, 'Completed'::text, 'Cancelled'::text, 'No-show'::text])))
```

Now open a transaction and try the bad update. This is a psql session transcript, so the prompts are shown. The `*` in the prompt means you are inside a transaction, and the `!` means the transaction has failed and must be rolled back:

```text
sandwash_clinic=# BEGIN;
BEGIN
sandwash_clinic=*# UPDATE appointments
sandwash_clinic-*# SET status = 'Complete'
sandwash_clinic-*# WHERE appointment_id = 2;
ERROR:  new row for relation "appointments" violates check constraint "appointments_status_check"
DETAIL:  Failing row contains (2, 122, 4, 2021-01-20 17:00:00, Complete, Follow-up).
sandwash_clinic=!# ROLLBACK;
ROLLBACK
```

Read the DETAIL line. PostgreSQL shows you the whole row it refused, so a support engineer can see the typo without a second query. Now prove nothing changed:

```sql
SELECT status,
       COUNT(*) AS appointment_count
FROM appointments
GROUP BY status
ORDER BY status;
-- Output:
--   status   | appointment_count
-- -----------+-------------------
--  Cancelled |               512
--  Completed |              4655
--  No-show   |               421
--  Scheduled |               412
```

Four statuses, none of them "Complete", and appointment 2 still reads Completed. The constraint and the rollback together left the table exactly as it was.

**Explain:** In one or two sentences, explain why the ROLLBACK was still necessary even though the UPDATE had already failed. What would have happened to the next statement in that session if you had skipped it?

### Quick Check 3.1 ✅

1. A school's grades table stores `term_grade` as text with no CHECK. The registrar says the application only offers A through F in a dropdown. Name two paths into the table that bypass the dropdown and state which constraint closes both.
2. A colleague proposes handling double bookings by having the scheduling application query for the slot before inserting. Using the ACID property it violates, explain in one or two sentences why that fails under concurrent use.
3. You try to add a UNIQUE constraint and PostgreSQL rejects it because existing rows collide. Which of the five roles from Chapter 1 decides which rows to keep, and what do you bring them?

---

## 3.2 Usage Analysis: Two Workloads, Two Shapes

The clinic's data serves two masters. The front desk inserts, updates, and looks up one appointment at a time, hundreds of times a day. Dr. Vasquez wants one report a month that reads every appointment and rolls it up by provider. The first is a **transactional workload**: many small reads and writes, each touching a few rows, each needing to finish now. The second is a **reporting workload**: a few large reads that scan thousands of rows and can take a minute. The same tables cannot be shaped ideally for both, and the district outline names this analysis as a design task, so you make it on purpose.

Normalized tables (Section 3.4 explains the term) serve the transactional side. Each fact lives once, so an update touches one row and a constraint can guard it. Reports, though, want the facts joined and summed, and they want the same join every month. The relational answer is not a second copy of the data. It is a second shape of the same data, built from the normalized tables on demand.

### Views: A Saved Question

A **view** is a named query that behaves like a table. It stores no rows. Every time someone selects from it, the database runs the query underneath. Here is the no-show report as a view:

```sql
-- One reporting shape for the medical director, built on the
-- normalized tables so it is always current.
CREATE VIEW provider_no_show_rate AS
SELECT p.provider_id,
       p.full_name,
       COUNT(*) AS appointments,
       COUNT(*) FILTER (WHERE a.status = 'No-show') AS no_shows,
       ROUND(100.0 * COUNT(*) FILTER (WHERE a.status = 'No-show')
             / COUNT(*), 1) AS no_show_pct
FROM appointments AS a
JOIN providers AS p USING (provider_id)
GROUP BY p.provider_id, p.full_name;
SELECT full_name, appointments, no_shows, no_show_pct
FROM provider_no_show_rate
ORDER BY no_show_pct DESC
LIMIT 5;
-- Output:
-- CREATE VIEW
--      full_name     | appointments | no_shows | no_show_pct
-- -------------------+--------------+----------+-------------
--  Dr. Elena Vasquez |          476 |       40 |         8.4
--  Yara Jackson      |          490 |       38 |         7.8
--  Dr. Nadia Yazzie  |          460 |       35 |         7.6
--  Dr. Kenji Foster  |          629 |       48 |         7.6
--  Dr. Miguel Garcia |          494 |       37 |         7.5
```

The view has two management payoffs beyond convenience. First, it fixes the definition. Every report that reads `provider_no_show_rate` counts a no-show the same way, so two managers cannot argue over numbers built from different queries. Second, it is a boundary. A reporting account can be granted SELECT on the view and nothing on the tables behind it. Chapter 1's threat table opened with an over-privileged reporting account, and a view is the first tool that shrinks its reach. Chapter 4 builds views that hide whole columns for the same reason.

### Materialized Views: A Saved Answer

A view re-runs its query on every read. For a 6,000-row table that costs nothing. For a 60-million-row table a monthly report might take ten minutes, and a dashboard that refreshes every time someone opens it would slow the front desk down. A **materialized view** stores the query's result as real rows on disk. Reads are instant. The cost is staleness: the stored rows reflect the moment they were built, not the moment they are read. `CREATE MATERIALIZED VIEW` and its refresh are PostgreSQL syntax, not standard SQL, though most products have an equivalent.

The build below carries the decisions, not just the syntax. Every role a chapter creates carries the clinic prefix so the harness and your notes can find it later:

```sql
-- Step 1: Store the summary once, so reports read rows instead of scanning
CREATE MATERIALIZED VIEW provider_visit_summary AS
SELECT p.provider_id,
       p.full_name,
       COUNT(*) FILTER (WHERE a.status = 'Completed') AS completed,
       COUNT(*) FILTER (WHERE a.status = 'Scheduled') AS scheduled,
       COUNT(*) FILTER (WHERE a.status = 'Cancelled') AS cancelled
FROM appointments AS a
JOIN providers AS p USING (provider_id)
GROUP BY p.provider_id, p.full_name;
-- Step 2: A unique index lets a later refresh run without blocking readers
CREATE UNIQUE INDEX provider_visit_summary_pk
ON provider_visit_summary (provider_id);
-- Step 3: Give the reporting role the summary, never the tables behind it
CREATE ROLE clinic_reporting NOLOGIN;
GRANT SELECT ON provider_visit_summary TO clinic_reporting;
-- Step 4: Prove the boundary holds before anyone connects with the role
SELECT has_table_privilege('clinic_reporting', 'provider_visit_summary', 'SELECT') AS can_read_summary,
       has_table_privilege('clinic_reporting', 'appointments', 'SELECT') AS can_read_appointments;
-- Output:
-- SELECT 12
-- CREATE INDEX
-- CREATE ROLE
-- GRANT
--  can_read_summary | can_read_appointments
-- ------------------+-----------------------
--  t                | f
```

The reporting role can read the summary and cannot read the appointments table. That is the whole point of Step 3. Chapter 5 turns this one GRANT into a full role design, but the shape is already here: the report gets a shape, not the source.

Now watch staleness happen. Cancel one appointment and read the summary again:

```sql
UPDATE appointments
SET status = 'Cancelled'
WHERE appointment_id = 887;
SELECT full_name, scheduled, cancelled
FROM provider_visit_summary
WHERE provider_id = 6;
-- Output:
-- UPDATE 1
--      full_name     | scheduled | cancelled
-- -------------------+-----------+-----------
--  Dr. Alma Martinez |        36 |        45
```

The update committed, and the summary did not move. The stored rows are a snapshot. A materialized view is only as current as its last refresh, so the refresh schedule is a management decision that belongs in writing. Refresh it now, and read again:

```sql
-- CONCURRENTLY needs the unique index from Step 2. Without it, the
-- refresh locks the summary and every report waits.
REFRESH MATERIALIZED VIEW CONCURRENTLY provider_visit_summary;
SELECT full_name, scheduled, cancelled
FROM provider_visit_summary
WHERE provider_id = 6;
-- Output:
-- REFRESH MATERIALIZED VIEW
--      full_name     | scheduled | cancelled
-- -------------------+-----------+-----------
--  Dr. Alma Martinez |        35 |        46
```

One scheduled visit became one cancelled visit, and the summary now agrees with the table. When you hand a manager a materialized view, hand them the refresh time with it. "Current as of 6:00 a.m." is honest. A dashboard with no timestamp is a report that quietly lies for the rest of the day.

### Choosing the Shape

| The workload looks like | Give it | Because |
| --- | --- | --- |
| Many small inserts and updates, each row matters now | Normalized tables with constraints | One fact, one place, one rule guarding it |
| A join everyone runs, on data that changes constantly | A view | Always current, one agreed definition, a privilege boundary |
| A heavy rollup read often, on data that changes slowly | A materialized view with a refresh schedule | Fast reads, and the staleness is written down |
| Years of history read only for analysis | A separate reporting database or warehouse | The report load never touches the front desk |

The last row is where Chapter 8's replication and Chapter 2's sizing meet. A busy clinic eventually copies its history to a second server so that month-end reports and the front desk stop competing for the same disk. The decision starts here, with naming which queries are transactional and which are reports.

### Try It Yourself 3.3: Sort the Parks Department's Queries 🛠️

**Predict:** A city parks department runs a reservation system for picnic ramadas and ball fields. Below are six things its staff and managers do. Before reading further, label each one transactional or reporting, and pick the shape from the table above that serves it: normalized tables, a view, or a materialized view.

* A resident books ramada 4 for Saturday at 10:00.
* A clerk cancels that booking and issues a refund.
* The recreation director opens a dashboard of bookings by park for the last five years, several times a day.
* A supervisor lists today's bookings for one park every morning.
* The finance office pulls total refund amounts by month for the annual audit.
* Two residents click "book" on the same field at the same second.

**Run:** Write the six in a table with columns Task, Workload, Shape, and Why. For the last row, name the constraint that decides who gets the field.

**Explain:** In one or two sentences, explain what you would tell the recreation director about the dashboard's numbers, and why the honest answer includes a time.

### Quick Check 3.2 ✅

1. A manager asks why the no-show percentage on her dashboard does not match the one the front desk sees in the application. Both were correct when built. Name the shape her dashboard is most likely using and the fix.
2. Compare granting a reporting account SELECT on `provider_no_show_rate` with granting it SELECT on `appointments` and `providers`. Which CIA property does the difference protect, and how?
3. Decide whether a monthly report that scans 6,000 rows should be a view or a materialized view, and defend the choice in one sentence.

---

## 3.3 Relational, NoSQL, and Big Data

Everything so far assumed a relational database, where tables have fixed columns and constraints hold the rows in shape. That model is not the only one, and the district outline asks you to judge when it fits. The judgment is a management decision because each model trades away something the others enforce, and what gets traded is usually integrity or access control.

### What NoSQL Gives Up and Gets Back

**NoSQL** is a family name for databases that drop the fixed-table model. The four common kinds each store a different shape:

| Model | Stores | Fits when | Common products |
| --- | --- | --- | --- |
| Document store | Whole records as JSON documents with varying fields | Each record is self-contained and its fields differ | MongoDB, Couchbase |
| Key-value store | One value per key, no structure inside | Caches, sessions, lookups by one id | Redis, DynamoDB |
| Wide-column store | Rows with millions of sparse columns | Time series and event logs at huge scale | Cassandra, HBase |
| Graph database | Nodes and the edges between them | Questions about relationships many hops deep | Neo4j |

A **document store** is the kind you will meet most. It keeps a whole patient intake form, or a whole ticket with its notes, as one JSON document. No joins, no fixed columns, and a new question on the form needs no ALTER TABLE. That flexibility is why developers like it. Here is what a manager must weigh against it:

* Constraints move to the application. The database cannot refuse a status of "Complete" because it does not know what a status is. Every integrity rule from Section 3.1 becomes code someone has to write, test, and keep in sync across every program that writes the data.
* Transactions are narrower. Most document stores guarantee atomicity for one document. Multi-document transactions exist in newer versions but are the exception, not the default.
* Access control is coarser. Relational products have decades of row-level, column-level, and view-based permissions. Many NoSQL products grant access per collection or per database. Hiding one field from one role is an application job.
* Duplication is the design. A document store copies the provider's name into every appointment document because there is no join. When the name changes, something has to find every copy. Section 3.4 names that problem.

None of this makes NoSQL wrong. It makes it a choice with a security bill attached. A product catalog with a thousand optional attributes, a session cache, or a clickstream of a billion events a day may pay that bill gladly. A clinic's appointment book, where every row is regulated and every status has a meaning, should not.

### Big Data

**Big Data** describes datasets too large, too fast, or too varied for one server and one schema. The three words are the traditional test: volume (petabytes, not gigabytes), velocity (millions of events a second), and variety (logs, images, sensor readings, and forms all at once). Big Data platforms spread the data across many machines and bring the computation to it. Copperwind's 18,000 tickets are not Big Data. A hospital network's device telemetry might be.

The management lesson is that Big Data platforms inherit the NoSQL tradeoffs and add one more: the data is copied, sometimes many times, across machines you do not individually manage. Every copy is a place confidentiality can fail. When someone proposes a data lake for regulated records, the first questions are the ones this course keeps asking. Who can read it? How is it encrypted? How would you delete one person's records from every copy when a retention rule says to? Chapter 4 makes that last question concrete.

### JSONB: The Relational Bridge

Most organizations do not have to choose. PostgreSQL's **JSONB** type stores a JSON document inside a relational column, indexed and queryable, with the rest of the row still under constraints. The name means "JSON, binary": the document is parsed once at insert time and stored in a form the server can search. JSONB is PostgreSQL syntax, not standard SQL, though Oracle, MySQL, and SQL Server each have a JSON column type with a similar role. It is the right tool for **semi-structured data**: records that share a core of fixed fields and then vary.

The clinic's telehealth intake form is a good example. Every response belongs to an appointment (fixed, constrained) and answers a questionnaire whose questions change every quarter (variable). Put the fixed part in columns and the variable part in JSONB:

```sql
-- The appointment link and the object shape are enforced. The answers
-- inside the object are not, and the prose says so.
CREATE TABLE intake_responses (
  response_id    integer PRIMARY KEY,
  appointment_id integer NOT NULL REFERENCES appointments (appointment_id),
  answers        jsonb NOT NULL CHECK (jsonb_typeof(answers) = 'object')
);
INSERT INTO intake_responses (response_id, appointment_id, answers)
VALUES (1, 881, '{"symptom_days": 3, "fever": true, "medications": ["ibuprofen"]}'),
       (2, 430, '{"symptom_days": 10, "fever": false}');
SELECT appointment_id,
       answers ->> 'symptom_days' AS symptom_days,
       answers ->> 'fever' AS fever,
       answers -> 'medications' AS medications
FROM intake_responses
ORDER BY response_id;
-- Output:
-- CREATE TABLE
-- INSERT 0 2
--  appointment_id | symptom_days | fever |  medications
-- ----------------+--------------+-------+---------------
--             881 | 3            | true  | ["ibuprofen"]
--             430 | 10           | false |
```

The `->>` operator pulls a field out as text and `->` pulls it out as JSON. The second response has no medications field, so the column comes back empty, with no error. That is the bridge's price in miniature: the foreign key stopped a response for a nonexistent appointment, and the CHECK stopped anything that is not a JSON object, but nothing stopped a missing field. Whatever must always be present belongs in a real column with NOT NULL. Whatever varies goes in the document.

You can still ask the document questions. The containment operator `@>` (PostgreSQL-only) asks whether a document includes a given fragment:

```sql
SELECT appointment_id, answers ->> 'symptom_days' AS symptom_days
FROM intake_responses
WHERE answers @> '{"fever": true}';
-- Output:
--  appointment_id | symptom_days
-- ----------------+--------------
--             881 | 3
```

A GIN index on the `answers` column makes that query fast at scale, and Chapter 8 measures the difference. For now the design rule is enough: the fields your constraints, reports, and access rules depend on live in columns. The rest can live in JSONB. That rule keeps the integrity story from Section 3.1 intact while giving the developers the flexibility they asked a document store for.

### Try It Yourself 3.4: The Field That Was Not There 🛠️

**Predict:** A nonprofit food bank stores donation records as JSON documents. One volunteer's form includes an `amount` field and another's does not. You will extract `amount` from both documents. Before you run it, write down what you expect the second extraction to return: an error, zero, or something else.

**Run:** Paste these two extractions into psql. They use literal documents, so they work in any database:

```sql
SELECT '{"donor": "Desert Spoke Cyclists", "amount": 250}'::jsonb ->> 'amount' AS amount,
       '{"donor": "Desert Spoke Cyclists"}'::jsonb ->> 'amount' AS missing_amount;
-- Output:
--  amount | missing_amount
-- --------+----------------
--  250    |
```

**Explain:** In one or two sentences, explain what a `SUM(amount)` over a thousand such documents would silently do, and name the design rule from this section that prevents it.

### Quick Check 3.3 ✅

1. A developer proposes moving the clinic's appointments to a document store so that each visit type can carry its own fields. Weigh the proposal against the four tradeoffs in this section and name the one that matters most under HIPAA.
2. Decide which of the following belongs in a JSONB column and which in a constrained column, and justify each in a phrase. The items: a student's grade level, a guardian's answers to an optional survey, an appointment's status, and a support ticket's device details that differ by device type.
3. Explain why "we deleted the record" is a harder claim to prove on a Big Data platform than on one PostgreSQL server.

---

## 3.4 Normalization as an Integrity and Separation Tool

Your SQL course probably defined the normal forms. This section uses them for something. **Normalization** is the process of organizing tables so that each fact is stored once, in the table whose key determines it. The test for **Third Normal Form (3NF)** fits on one line: every non-key column depends on the key, the whole key, and nothing but the key. The reason a database manager cares is not elegance. A fact stored in one place can be guarded by one constraint, protected by one GRANT, encrypted in one column, and deleted with one statement. A fact stored in six places has six chances to drift and six places to leak.

Data arrives denormalized all the time. Someone exports a report to a spreadsheet, the spreadsheet becomes the system of record, and then it comes back to you as a CSV. Here is a small one from the clinic: the sign-up sheet from a fall vaccine event, kept in a spreadsheet and handed to you to "put in the database". Load it into a **staging table**, a temporary landing table with no constraints, so you can inspect it before anything trusts it:

```sql
-- No constraints on purpose: staging holds whatever arrived so
-- you can find the problems with queries before the data goes live.
CREATE TABLE flu_shot_signups (
  patient_name       text,
  patient_phone      text,
  provider_name      text,
  provider_specialty text,
  vaccine            text,
  given_on           date
);
INSERT INTO flu_shot_signups
VALUES ('Hana Singh',   '602-555-9536',   'Alma Yazzie',  'Nurse Practitioner', 'Influenza', '2025-10-06'),
       ('Hana Singh',   '(602) 555-9536', 'Alma Yazzie',  'Nurse Practitioner', 'COVID-19',  '2025-10-06'),
       ('Noor Ramirez', '602-555-6470',   'Yara Jackson', 'Nurse Practitioner', 'Influenza', '2025-10-06'),
       ('Nadia Foster', '602-555-5141',   'Alma Yazzie',  'Nurse Practitioner', 'Influenza', '2025-10-07'),
       ('Nadia Foster', '602-555-5141',   'Yara Jackson', 'Nurse Practitioner', 'Tdap',      '2025-10-07'),
       ('Noor Ramirez', '602-555-6470',   'Yara Jackson', 'Nurse Practitioner', 'COVID-19',  '2025-10-07');
SELECT patient_name,
       COUNT(DISTINCT patient_phone) AS phone_spellings
FROM flu_shot_signups
GROUP BY patient_name
HAVING COUNT(DISTINCT patient_phone) > 1;
-- Output:
-- CREATE TABLE
-- INSERT 0 6
--  patient_name | phone_spellings
-- --------------+-----------------
--  Hana Singh   |               2
```

Six rows, and one patient already has two phone numbers. That is an **update anomaly**: the same fact, stored twice, changed once. The sheet repeats the patient's phone on every row because the row's key (who, which vaccine, which day) does not determine the phone. The patient determines the phone. Likewise the provider determines the specialty, so "Nurse Practitioner" appears six times and one typo would create a fifth specialty. Each repeated column is a **functional dependency** on something other than the row's key, and each one is a place where the data can disagree with itself.

### Decomposing to 3NF

The fix is to give each dependency its own table with its own key. The clinic already has the two parents, `patients` and `providers`, and they already carry the phone and the specialty under constraints. What the sign-up sheet adds is one new fact, that a provider gave a patient a vaccine on a date. That fact gets a table of its own, keyed by a **surrogate key**, a system-generated identifier with no business meaning. A surrogate key never has to change when a name or a phone number does. The script below carries the decisions as step comments:

```sql
-- Step 1: Create the child table with the rules the spreadsheet never had
CREATE TABLE immunizations (
  immunization_id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  patient_id      integer NOT NULL REFERENCES patients (patient_id),
  provider_id     integer NOT NULL REFERENCES providers (provider_id),
  vaccine         text NOT NULL CHECK (vaccine IN ('Influenza', 'COVID-19', 'Tdap')),
  given_on        date NOT NULL,
  UNIQUE (patient_id, vaccine, given_on)
);
-- Step 2: Resolve names to keys against the parents. A name is not a
--         key, so match on the phone too, reduced to digits so the
--         sheet's second spelling still resolves
INSERT INTO immunizations (patient_id, provider_id, vaccine, given_on)
SELECT p.patient_id, pr.provider_id, s.vaccine, s.given_on
FROM flu_shot_signups AS s
JOIN patients AS p
  ON p.first_name || ' ' || p.last_name = s.patient_name
 AND regexp_replace(p.phone, '\D', '', 'g')
     = regexp_replace(s.patient_phone, '\D', '', 'g')
JOIN providers AS pr ON pr.full_name = s.provider_name;
-- Step 3: Prove every staged row landed before you drop the staging table
SELECT (SELECT COUNT(*) FROM flu_shot_signups) AS staged_rows,
       (SELECT COUNT(*) FROM immunizations) AS loaded_rows;
-- Output:
-- CREATE TABLE
-- INSERT 0 6
--  staged_rows | loaded_rows
-- -------------+-------------
--            6 |           6
```

Six in, six out. Step 2 is the line to read twice. The clinic has two patients named Noor Ramirez, so a join on the name alone would have loaded each of her sign-ups twice, against both patients. The phone broke the tie. A name that matched nothing would have produced no row instead of a bad one. In a real load you would count the unmatched names first and send them back to the sheet's owner. The sheet lost the key when it was exported, and every load from it has to earn the key back. The staging table's job is done, so drop it, then read the phone number from the one place it now lives:

```sql
DROP TABLE flu_shot_signups;
SELECT p.first_name, p.phone, i.vaccine, i.given_on
FROM immunizations AS i
JOIN patients AS p USING (patient_id)
WHERE p.last_name = 'Singh'
ORDER BY i.vaccine;
-- Output:
-- DROP TABLE
--  first_name |    phone     |  vaccine  |  given_on
-- ------------+--------------+-----------+------------
--  Hana       | 602-555-9536 | COVID-19  | 2025-10-06
--  Hana       | 602-555-9536 | Influenza | 2025-10-06
```

One phone number, two vaccines. The second spelling is gone because the redesign has nowhere to put it.

### What Normalization Buys Security

Look at what the redesign changed from the management side. This is the argument you will make to Dr. Vasquez when she asks why the spreadsheet could not just be imported as it was:

* **One constraint guards each fact.** The vaccine list, the date, and the patient link are enforced once, in `immunizations`. The sheet had no place to enforce anything.
* **Identifiers are separated from the facts about them.** The patient's name and phone live in `patients`. The immunization row holds only a number. A role that may read the immunization log need not be able to read phone numbers, and Chapter 4 builds that separation into schemas and views.
* **There is one place to protect.** When Chapter 6 encrypts a column, it encrypts it once. When a retention rule in Chapter 4 says to delete a patient's contact details, one DELETE reaches every copy, because there is only one.
* **Audit trails stay readable.** A change to a phone number is one row in one table's audit log (Chapter 7), not six rows scattered across a sign-up sheet.

Denormalization has its place, and Section 3.2 showed it: a materialized view is a deliberately denormalized copy, built from the normalized source, with its staleness written down. The rule is direction. Normalize the source of truth. Denormalize copies for reading, and let the copies be rebuilt from the source, never the other way around.

### Fix It 3.1: Children Before Parents 🔧

Copperwind's night batch loads a clinic's new patients and their appointments from two files, and the front desk arrives to find the appointments missing.

**Symptom:** The load script inserts the appointment rows first and every one of them is refused.

```text
INSERT INTO appointments (appointment_id, patient_id, provider_id, scheduled_at, status, visit_type)
VALUES (6001, 601, 3, '2026-06-02 09:00:00', 'Scheduled', 'Follow-up');
```

```text
ERROR:  insert or update on table "appointments" violates foreign key constraint "appointments_patient_id_fkey"
DETAIL:  Key (patient_id)=(601) is not present in table "patients".
```

**Diagnose:** State the cause in one sentence before you touch the script. The DETAIL line names the table that is missing a row and the key it looked for. Is the foreign key wrong, or is the order wrong?

**Repair:** Reorder the load so that `patients` is inserted before `appointments`, as every setup script in this book does (Chapter 1 named that order as Step 3 and Step 4). Do not drop or disable the constraint to make the error go away. State what changed in the script.

**Verify:** How do you know it is fixed? Name the query that shows patient 601 in `patients` and the count of appointments for that patient, and name the catalog row from Section 3.1 that proves the foreign key is still in place.

### Try It Yourself 3.5: Normalize the Bike Shop's Repair Log 🛠️

**Predict:** A bike shop keeps its repair log as one sheet. Its columns: ticket number, date, customer name, customer phone, bike serial number, bike model, mechanic name, mechanic hourly rate, part number, part description, part price, quantity. One ticket can use several parts. Before reading further, write down how many tables you expect a 3NF design to need and which column becomes each table's key.

**Run:** Draw the design as a list of tables, each with its key, its columns, and the foreign keys that connect it to the others. Mark every column that a CHECK or UNIQUE constraint should guard, and say what rule it enforces.

**Explain:** In one or two sentences, name the update anomaly in the original sheet that your design removes, and the one column whose access you could now restrict to the shop owner alone.

### Quick Check 3.4 ✅

1. A flat export repeats the teacher's name on every grade row. Name the functional dependency that violates 3NF and the table that should own the name.
2. Compare a staging table with no constraints against loading straight into the constrained tables. Explain in one or two sentences when each is the right call.
3. Design the one CHECK constraint that makes a grade of "E" impossible to store, and state where it belongs in a normalized gradebook.

---

## 3.5 Summary and Retrieval 💡

### Key Concepts

* Constraints are controls. PRIMARY KEY, FOREIGN KEY, UNIQUE, NOT NULL, and CHECK each stop a specific kind of bad data, and they run on every path into the table, not only through the application. A constraint you cannot add because existing rows violate it is a finding for the data owner.
* Transactions make a group of statements succeed or fail together. ACID names the four guarantees. Under concurrent use, isolation is the one applications get wrong, and a constraint checked at commit time is the only reliable defense against a lost update or a double booking.
* Transactional and reporting workloads want different shapes of the same data. Normalized tables serve the front desk. Views give reports one agreed definition and a privilege boundary. Materialized views trade staleness for speed, and the refresh schedule is a decision to write down.
* NoSQL models trade constraints, transactions, and fine-grained access control for flexibility and scale. Big Data adds copies across machines you do not individually control. JSONB puts semi-structured data inside a constrained relational row, and the design rule is that anything a constraint, report, or access rule depends on stays in a real column.
* Normalization stores each fact once, in the table whose key determines it. That gives every fact one constraint, one GRANT, one column to encrypt, and one row to delete. Denormalize copies for reading, never the source.

### Key Terms

See course glossary for full definitions

* integrity constraint, CHECK constraint, transaction, ACID, lost update (Section 3.1)
* transactional workload, reporting workload, view, materialized view (Section 3.2)
* NoSQL, document store, Big Data, JSONB, semi-structured data (Section 3.3)
* normalization, Third Normal Form (3NF), staging table, update anomaly, functional dependency, surrogate key (Section 3.4)

### Retrieval Practice

1. From memory, name the five constraint types and one kind of bad data each one stops.
2. State the four ACID properties and explain, without looking back, why an application's "check before insert" cannot prevent a double booking.
3. A manager asks for a fast dashboard over data that changes all day. Say which shape you would offer, what you would warn her about, and what you would put in writing.
4. Give the one-line test for Third Normal Form and name two security benefits of meeting it.
5. From Chapter 1: Name the CIA property this chapter's controls protect, and the role that decides which of two colliding rows is the real one.

---

## 3.6 Skills Lab 3A: Redesign the Harquahala Gradebook

**Goal:** Turn the academy's flat gradebook export into a Third Normal Form design with constraints that make a bad grade impossible to store. Then build one reporting view the registrar can hand to teachers without exposing the tables behind it.

**Dataset or starter files:** `assets/code/chapter-03/` in the course data pack. `setup-harquahala.sql` rebuilds `harquahala_academy`. `harquahala_gradebook_export.csv` is the flat export (1,201 rows: student name, grade level, course, term, teacher name, term grade) that a former staff member kept in a spreadsheet. The starter script `skills-lab-3a.sql` and the starter answer file `skills-lab-3a-answers.md` carry the numbered markers. The export contains planted anomalies. Finding them is Part 1. All organizations and records are fictional.

### Part 1: Foundation (Aligns with Objectives 3.1 and 3.3)

1. Rebuild the academy database from this chapter's setup script. Under marker 1.1 in `skills-lab-3a.sql`, create a staging table named `gradebook_import` with six text columns matching the CSV header and no constraints. Load the file with `\copy` from the `cis376` root and paste the row count as `-- Output:` comment lines.
2. Under marker 1.2, write three queries that find the anomalies without being told what they are. Find every distinct spelling of each teacher's name that appears fewer than five times, every row that appears more than once, and every `term_grade` outside A through F. Paste each result. Record the findings in the anomaly table in your answer file, with the row counts as evidence.
3. Under marker 1.3, for each anomaly, name the constraint type from Section 3.1 that would have prevented it in a normalized design. Note which one no constraint can catch (a misspelled name is still a valid name). Write those three sentences in the answer file.

### Part 2: Application (Aligns with Objectives 3.1 and 3.3)

1. Design the 3NF target. The export has no keys, so you will create surrogate keys. Under marker 2.1, create a schema named `gradebook` with at least four tables inside it: teachers, courses, sections, and enrollments. A section is one course, one teacher, and one term. An enrollment is one student name and grade level, one section, and one term grade. Every table gets a primary key. Every reference gets a foreign key. Add `UNIQUE` on the natural identity of teachers, courses, and sections, `NOT NULL` wherever the export always has a value, and a `CHECK` that limits `term_grade` to A, B, C, D, and F. Document the functional dependency each table owns in the schema table in your answer file.
2. Under marker 2.2, load the target from `gradebook_import` in parent-first order with `INSERT ... SELECT`. Resolve the three teacher-name variants to one teacher row before you load sections, and state in the answer file which spelling you kept and why. Load enrollments with `SELECT DISTINCT` so the duplicated row lands once. Paste the row count of every target table.
3. Under marker 2.3, attempt to load the one row with the invalid grade as it is. Paste the error the CHECK constraint returns. Then decide what to do with that row (correct it from a named source, or hold it out and report it) and record the decision and the reason in your answer file. Do not silently change the grade to make the load succeed.

### Part 3: Extension (Aligns with Objectives 3.2 and 3.3)

1. Under marker 3.1, create a reporting view named `gradebook.section_grade_distribution` that shows, for each section, the course, the teacher, the term, and a count of each letter grade. Create a role named `academy_reporting` with no login. Grant it `USAGE` on the `gradebook` schema and `SELECT` on the view only. Paste the `has_table_privilege` results that prove it can read the view and cannot read `gradebook.enrollments`.
2. Under marker 3.2, run the view for the sections taught by the teacher whose name was misspelled and paste the result. Then write two sentences in your answer file on what the registrar would have seen if the view had been built on the flat export instead.
3. Write a one-page memo to Principal Whitfield, in the answer file, that explains in plain language what the redesign changed. Name the three anomalies you found, the constraint that now prevents each preventable one, and the one place a student's grade now lives. Close with one sentence on what the view lets the school share with teachers without sharing the tables.

### Questions & Analysis 🤔

1. Using your Part 1 and Part 2 output as evidence, explain which of the three anomalies the database can prevent outright and which it can only make visible. What process, outside the database, has to own the one it cannot prevent?
2. FERPA treats a grade as an education record. Compare who could read a student's grade in the flat export (one file, one permission) against your normalized design with the reporting view. Explain, citing the `has_table_privilege` output, how the redesign supports data separation, and propose one further separation you would add before the portal reads from it.

**Submission:** Submit one folder named `skills-lab-3a-lastname`. It holds `skills-lab-3a.sql` with every result pasted as `-- Output:` comment lines (or the saved psql output beside it), including the captured CHECK constraint error from Part 2. It also holds `skills-lab-3a-answers.md` with the anomaly table, the schema table, the memo, and your two Questions & Analysis answers clearly labeled.

### Rubric: Skills Lab 3A

This lab is graded with the standard
[Skills Lab Rubric](../skills-lab-rubric.md): four criteria, five
levels from Mastery to Not Evident. The criteria are Technical
Accuracy and Efficiency, Output Quality, Documentation Quality, and
Analysis, Interpretation, and Response to QUESTION(s). The criteria
and levels are the same everywhere. Your instructor sets the point
values in your course. Check the syllabus and the Canvas rubric
attached to this lab for the values that apply to you.

---

## 3.7 Review Questions 🔄️

1. **Apply:** A law office's case management database has a `case_status` column that holds Open, Closed, and Archived, plus eleven variants that staff typed by hand over the years. Write the steps, in order, to enforce the three valid values without losing the eleven variant rows, and name who decides what each variant becomes.

2. **Analyze:** A credit union's mobile app lets two members transfer from the same joint account at the same moment, and the balance went negative. Break the failure down by ACID property, identify which one was violated and how, and name the database-side control that prevents it regardless of what the app does.

3. **Evaluate:** A developer proposes storing Copperwind's support tickets as JSON documents in a document store so that each device type can carry its own fields. Judge the proposal against the clinic's and the school's regulatory needs, and propose the hybrid design from Section 3.3 that gives the developer the flexibility without giving up the constraints.

4. **Create:** Design a materialized-view refresh policy for the academy's grade distribution dashboard. State the refresh schedule, the timestamp the dashboard must display, the index that lets the refresh run without blocking readers, and the role that may read the view. Justify each choice in one sentence.

---

## Further Reading 📖

* [PostgreSQL Documentation: Constraints](https://www.postgresql.org/docs/17/ddl-constraints.html) - The reference for every constraint type in Section 3.1, including the exclusion constraints this chapter did not cover.
* [PostgreSQL Documentation: Concurrency Control](https://www.postgresql.org/docs/17/mvcc.html) - The isolation levels behind the ACID table, and the concurrency failures each level does and does not prevent.
* [PostgreSQL Documentation: Materialized Views](https://www.postgresql.org/docs/17/rules-materializedviews.html) - The staleness tradeoff from Section 3.2 in the project's own words, with the refresh options.
* [PostgreSQL Documentation: JSON Types](https://www.postgresql.org/docs/17/datatype-json.html) - The JSONB operators used in Section 3.3, the containment rules, and when to add a GIN index.
* [NIST SP 800-53 Rev. 5: Security and Privacy Controls](https://csrc.nist.gov/pubs/sp/800/53/r5/upd1/final) - The System and Information Integrity family. Its control SI-10, Information Input Validation, names the requirement that this chapter's constraints and transactions satisfy inside the database.
* [OWASP Input Validation Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Input_Validation_Cheat_Sheet.html) - The application-side half of the integrity story, and why the database constraint is the layer that holds when the application forgets.

---

## Looking Ahead ⏩

You can now make a database refuse bad data and shape the same data for the people who write it and the people who read it. Chapter 4 asks what the law says those people may see. HIPAA and FERPA classify the clinic's and the academy's columns, and the schemas, views, and separation you started building here become the way the database proves it honors that classification.
