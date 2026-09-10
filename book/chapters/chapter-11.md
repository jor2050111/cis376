# Chapter 11: Routine Analysis and Best Practices

Nobody at Copperwind noticed the reporting account. It was created during a busy week two years ago, granted read access to every table so a dashboard would stop erroring, and forgotten. It never failed. It never alerted. It sat there reading tables its job never needed. It would have kept sitting there, except that a monthly review compared what the server allows against what the data owner signed.

That is the shape of most database problems. They do not announce themselves. Disks fill a percent at a time. Privileges collect. Logging stays off because nobody turned it on. Query cost creeps up as a table grows past the point an index would have helped. Every one of those is cheap to fix in month one and expensive in month twenty. The only thing that finds them in month one is a review that runs whether or not anything looks wrong.

Mei Lin has asked you to put Copperwind's Data Services practice on a routine. You will build a review that measures the same things every month and archives the numbers, so change becomes visible instead of remembered. You will put access, performance, and compliance audits on a calendar. Then you will score a Copperwind server against a benchmark, choose the controls worth adopting today, and prove with three numbers that adopting them changed something.

## Module Overview 🧭

* **Estimated time:** 5-6 hours
* **Prerequisites:** One prior SQL course (Introduction to Oracle: SQL, CIS276DA MySQL Database, or CIS276DB SQL Server Database). Chapter 1 (the lab environment and the three course databases). Chapters 5, 7, 8, and 9 supply the controls this chapter reviews, and one sentence recalls each where it appears.
* **Deliverables:** Skills Lab 11A folder (`skills-lab-11a.sql` and `skills-lab-11a-answers.md`), Quick Checks

## Learning Objectives 🎯

By the end of this chapter, you will be able to:

* **11.1 (Create):** Build a routine performance and security review that runs on a schedule and reports from logs, catalog views, and historical baselines (Sections 11.1-11.2)
* **11.2 (Evaluate):** Critique a database configuration against an industry benchmark and select the controls worth adopting (Section 11.3)
* **11.3 (Evaluate):** Measure the effect of an adopted best practice with at least three quantifiable metrics (Section 11.4)

### This chapter aligns with the following Course Learning Outcomes

* **CLO II (Evaluate):** Assess security management for database environments.
* **CLO III (Create):** Develop strategies to maintain optimal system performance, security and availability.
* **CLO V (Evaluate):** Critique current practices and future trends of database management and security.

---

## 11.1 The Routine

A **routine review** is a fixed set of measurements taken on a fixed schedule, whether or not anything looks wrong. It is the opposite of the work you did in Chapter 10, where an alarm sent you looking. The review looks first. Its job is to turn slow change into a number somebody reads before the change becomes an incident. Three things make a review a routine rather than a good intention. It measures the same things every time, so two runs can be compared. It writes its results somewhere durable, so the comparison survives your memory. It happens on a calendar, so a quiet month does not skip it.

### What a Review Measures

The measurements fall into four families, and a review that covers all four tells you more than four reviews that each cover one. Capacity says whether the server will still fit next year. Performance says whether the work is getting more expensive. Security says whether access still matches the signed list. Evidence says who was here.

| Family | Question it answers | Source on a PostgreSQL server |
| --- | --- | --- |
| Capacity | Are we growing faster than we planned for? | `pg_class` sizes, row counts, `pg_database_size()` |
| Performance | Is the same work costing more than it did? | Execution plans, the statement collector, index inventory |
| Security | Does access still match what the data owner approved? | `pg_roles`, `information_schema.table_privileges`, `pg_settings` |
| Evidence | Who connected, and did anything fail? | The server log, and the login events the application records |

Chapter 1 called the first measurement of a healthy system a **baseline**. A routine review is that idea repeated. One baseline tells you where you stand. A year of them tells you which direction you are moving, and direction is what lets you act before a number becomes a problem.

### Reading the Log the Routine Depends On

Chapter 7 turned on server logging and built an audit trail. This chapter reads what those instruments produced. Copperwind's application records every login attempt in `login_events`, so the security half of the review starts there. Roll the attempts up by month and the review has a number it can compare:

```sql
\connect copperwind_ops
SELECT date_trunc('month', event_time)::date AS review_month,
       COUNT(*) AS login_attempts,
       COUNT(*) FILTER (WHERE NOT success) AS failed_attempts,
       COUNT(DISTINCT source_ip) FILTER (WHERE NOT success) AS failing_sources
FROM login_events
GROUP BY review_month
ORDER BY review_month;
-- Output:
--  review_month | login_attempts | failed_attempts | failing_sources
-- --------------+----------------+-----------------+-----------------
--  2026-06-01   |           5920 |             178 |               6
--  2026-07-01   |           6080 |             379 |               7
```

Failed attempts more than doubled between the two months while total traffic barely moved. A single month of that table would have looked unremarkable. The comparison is what makes it a finding, and the comparison exists only because something recorded last month's number.

### The Review Archive

That "something" is a table. A **review archive** stores one row per metric per run, so every capture is permanent and any two runs can be joined. Keep it in its own schema for the same reason Chapter 4 kept protected columns in theirs. A report table sitting beside the client tables eventually gets treated like a client table. The script below is the whole routine. Read the four steps before the SQL, because they are the design and the SQL is how PostgreSQL spells it. Step 2 matters most. Defining the metric set as a view means next month's run measures the same six things the same way, even if somebody else runs it. Notice that the role count filters on the `copperwind_` prefix. Roles live in the cluster, not in the database, so an unfiltered count would sweep in every other client Copperwind hosts and your own practice roles besides.

```sql
-- Step 1: Keep the archive in its own schema, so a report can never be
--         mistaken for a table the client owns
CREATE SCHEMA IF NOT EXISTS review;
CREATE TABLE review.metrics (
  captured_on   date   NOT NULL,
  database_name text   NOT NULL,
  metric_name   text   NOT NULL,
  metric_value  bigint NOT NULL,
  PRIMARY KEY (captured_on, database_name, metric_name)
);
-- Step 2: Define the metric set once, as a view, so every run measures
--         the same things the same way
CREATE VIEW review.monthly_metrics AS
SELECT 'tickets_rows' AS metric_name, COUNT(*) AS metric_value FROM tickets
UNION ALL SELECT 'open_tickets', COUNT(*) FROM tickets WHERE status = 'Open'
UNION ALL SELECT 'ticket_notes_kb', pg_total_relation_size('ticket_notes') / 1024
UNION ALL SELECT 'failed_logins', COUNT(*) FROM login_events WHERE NOT success
UNION ALL SELECT 'login_roles', COUNT(*) FROM pg_roles
  WHERE rolcanlogin AND rolname LIKE 'copperwind\_%'
UNION ALL SELECT 'indexes_total', COUNT(*) FROM pg_index
  WHERE indrelid IN (SELECT oid FROM pg_class
                     WHERE relnamespace = 'public'::regnamespace
                       AND relkind = 'r');
-- Step 3: Load the archive the previous review left behind
\copy review.metrics FROM 'assets/code/chapter-11/review-baselines.csv' WITH (FORMAT csv, HEADER true)
-- Step 4: Capture this run. A scheduler passes the date on a live
--         server, and this book writes it out so every reader's
--         comparison matches the one printed here
INSERT INTO review.metrics (captured_on, database_name, metric_name, metric_value)
SELECT DATE '2026-09-01', current_database(), metric_name, metric_value
FROM review.monthly_metrics;
-- Output:
-- CREATE SCHEMA
-- CREATE TABLE
-- CREATE VIEW
-- COPY 12
-- INSERT 0 6
```

The shipped file holds the August capture for every database Copperwind manages, so the archive carries a `database_name` column and each database keeps its own copy. Loading twelve rows into a database that owns six of them costs nothing and saves a cross-database connection. PostgreSQL has no built-in scheduler, so the calendar lives outside the database. On Linux or macOS, a `cron` entry such as `0 6 1 * * psql -d copperwind_ops -f monthly-review.sql` runs the script at 6 a.m. on the first of each month. Windows Task Scheduler calls the same `psql -f` command on a monthly trigger. The `pg_cron` extension keeps the schedule inside PostgreSQL instead. Which one you pick is an operations decision rather than a database one.

### Making the Change Visible

The archive earns its keep the moment you join one run to another. This is the report Mei Lin reads, and it is four columns wide because a manager needs the old number, the new number, and the difference in one glance:

```sql
SELECT last_month.metric_name,
       last_month.metric_value AS baseline_2026_08_01,
       this_month.metric_value AS current_2026_09_01,
       this_month.metric_value - last_month.metric_value AS change
FROM review.metrics AS last_month
JOIN review.metrics AS this_month
  ON this_month.database_name = last_month.database_name
 AND this_month.metric_name = last_month.metric_name
 AND this_month.captured_on = DATE '2026-09-01'
WHERE last_month.captured_on = DATE '2026-08-01'
  AND last_month.database_name = current_database()
ORDER BY last_month.metric_name;
-- Output:
--    metric_name   | baseline_2026_08_01 | current_2026_09_01 | change
-- -----------------+---------------------+--------------------+--------
--  failed_logins   |                  96 |                557 |    461
--  indexes_total   |                   5 |                  5 |      0
--  login_roles     |                   3 |                  2 |     -1
--  open_tickets    |                 198 |                226 |     28
--  ticket_notes_kb |                2760 |               2848 |     88
--  tickets_rows    |               17960 |              18240 |    280
```

Read the change column top to bottom. Failed logins jumped by 461, which is the finding the log report already hinted at. Login roles dropped by one, which matches an account the last access review closed. Tickets, open tickets, and note storage all grew a little, which is a business doing business. Indexes did not move at all, and on a table that gained 280 rows that is worth a second look in Section 11.2. Notice what the report does not do. It decides nothing. It puts six numbers and six differences in front of a person who knows what the business is planning, and that person asks the next question.

### Fix It 11.1: The Collector That Was Never Loaded 🔧

The performance half of the review wants the statement collector Chapter 8 introduced, so you install it and go looking for the most expensive query.

**Symptom:** The extension installs without complaint and the next query fails.

```text
CREATE EXTENSION pg_stat_statements;
SELECT queryid, calls, query FROM pg_stat_statements
ORDER BY total_exec_time DESC LIMIT 3;
```

```text
ERROR:  pg_stat_statements must be loaded via "shared_preload_libraries"
```

**Diagnose:** Name the cause before touching anything. `CREATE EXTENSION` created the view and the functions, but the code that counts statements is a shared library PostgreSQL loads once when the server starts. The catalog entries exist and the collector behind them does not.

**Repair:** Add `pg_stat_statements` to `shared_preload_libraries` in `postgresql.conf` and restart the server. A reload is not enough. Ask the catalog why: `SELECT name, context FROM pg_settings WHERE name = 'shared_preload_libraries';` answers `postmaster`, which is PostgreSQL's word for a setting only a restart can change. Chapter 9 made the same point about `archive_mode`, and the rule that follows is the same. A restart belongs in a change window, never in a workday whim on a shared server.

**Verify:** Two readings prove it. `SHOW shared_preload_libraries` names the library, and the view answers with rows instead of raising. The transcript below came from a separate single-user review server built for this capture, because this book never restarts a cluster other people are using. The counts and timings on your server will differ, and they should:

```text
SHOW shared_preload_libraries;
 shared_preload_libraries
--------------------------
 pg_stat_statements

SELECT calls, round(mean_exec_time::numeric, 2) AS avg_ms, left(query, 44) AS query
FROM pg_stat_statements ORDER BY total_exec_time DESC LIMIT 2;
 calls | avg_ms |                    query
-------+--------+----------------------------------------------
     3 |   1.09 | SELECT category, COUNT(*) FROM tickets GROUP
     5 |   0.62 | SELECT ticket_id FROM tickets WHERE client_i
```

Once the collector runs, the review gains a metric no catalog view can give it: the query that costs the most across all callers. Until then, the review measures what it can and records the gap as a finding, which is what the benchmark in Section 11.3 will call it.

### Try It Yourself 11.1: Design the Parks Department's Review 🛠️

A city parks department runs one database behind its facility reservation site. It has never had a review. The recreation director wants a monthly page she can read in two minutes.

**Predict:** Before you write anything, predict which family will produce the metric she cares about most. Then name one metric that would look impressive on the page and tell her nothing she can act on.

**Run:** Write a six-row metric table with the columns Metric, Family, Source, and Why it changes. Cover at least three families. Then write the one sentence you would put at the top of the page when every metric is flat.

**Explain:** In one or two sentences, explain why the archive matters more than any single month's page. Name what the director loses if the department keeps the page and throws away the numbers behind it.

### Quick Check 11.1 ✅

1. A colleague says the review can skip a month because "nothing changed." Name the two things that claim assumes and explain which one the archive can settle.
2. A server's failed-login count is 557 this month. State what that number alone tells you and what it takes to turn it into a finding, and explain why the metric set is defined as a view instead of retyped each month.

---

## 11.2 Audits on a Calendar

A review measures. An **audit** compares what it measures against a standard and reports every difference. Three audits cover the ground the course outcomes ask for, and each one answers to a different reader.

| Audit | Compares | Standard it uses | Who reads it |
| --- | --- | --- | --- |
| Access | Granted privileges and live accounts | The signed access list from the data owner | Security lead, data owner |
| Performance | Current cost of the work | Last quarter's plans, sizes, and index inventory | Database administrator, manager |
| Compliance | Configuration and retention evidence | The regulation and the organization's own policy | Compliance officer, auditor |

### The Access Audit

Chapter 5 built roles and Chapter 7 recorded what they did. The access audit asks a narrower question: does the server allow exactly what the data owner approved, and nothing else? Answering it needs both lists in the same place. The signed list arrives as a file from Mei Lin, so load it instead of typing it, then let one full join find every difference in both directions:

```sql
CREATE TABLE review.approved_access (
  role_name  text NOT NULL,
  table_name text NOT NULL,
  privilege  text NOT NULL,
  PRIMARY KEY (role_name, table_name, privilege)
);
\copy review.approved_access FROM 'assets/code/chapter-11/copperwind-access-list.csv' WITH (FORMAT csv, HEADER true)
WITH granted AS (
  SELECT grantee AS role_name, table_name, privilege_type AS privilege
  FROM information_schema.table_privileges
  WHERE table_schema = 'public' AND grantee LIKE 'copperwind\_%'
)
SELECT role_name, table_name, privilege,
       CASE WHEN a.role_name IS NULL THEN 'NOT APPROVED'
            WHEN g.role_name IS NULL THEN 'MISSING'
            ELSE 'approved' END AS finding
FROM granted AS g
FULL JOIN review.approved_access AS a USING (role_name, table_name, privilege)
ORDER BY role_name, table_name, privilege;
-- Output:
-- CREATE TABLE
-- COPY 6
--      role_name      |  table_name  | privilege |   finding
-- --------------------+--------------+-----------+--------------
--  copperwind_app     | ticket_notes | INSERT    | approved
--  copperwind_app     | ticket_notes | SELECT    | approved
--  copperwind_app     | tickets      | INSERT    | approved
--  copperwind_app     | tickets      | SELECT    | approved
--  copperwind_reports | clients      | SELECT    | approved
--  copperwind_reports | login_events | SELECT    | NOT APPROVED
--  copperwind_reports | technicians  | SELECT    | NOT APPROVED
--  copperwind_reports | ticket_notes | SELECT    | NOT APPROVED
--  copperwind_reports | tickets      | SELECT    | approved
```

There is the reporting account from the opening paragraph. Someone granted `copperwind_reports` read access to every table in the schema, and three of those tables are not on the signed list. The ticket application, granted table by table, matches its approvals exactly. Nothing here is an attack. It is a hurry, preserved. The full join is the whole trick. An inner join would show only the grants that appear on both lists, which hides the two failures you care about. A grant nobody approved is a confidentiality risk. An approval nobody granted is a broken application waiting for the next deploy. **Privilege drift** is the name for the first one, and it moves in one direction unless something checks.

### The Performance Audit

The performance audit compares today's cost against the last capture. Two cheap readings start it. An index inventory says what the server has to work with, and a plan says what it does with them:

```sql
SELECT c.relname AS table_name,
       COUNT(i.indexrelid) AS index_count,
       pg_size_pretty(pg_total_relation_size(c.oid)) AS total_size
FROM pg_class AS c
LEFT JOIN pg_index AS i ON i.indrelid = c.oid
WHERE c.relnamespace = 'public'::regnamespace
  AND c.relkind = 'r'
GROUP BY c.relname, c.oid
ORDER BY pg_total_relation_size(c.oid) DESC;
EXPLAIN (COSTS OFF)
SELECT ticket_id, opened_at, summary
FROM tickets
WHERE client_id = 12
  AND status = 'Open';
-- Output:
--   table_name  | index_count | total_size
-- --------------+-------------+------------
--  ticket_notes |           1 | 2848 kB
--  tickets      |           1 | 2624 kB
--  login_events |           1 | 1336 kB
--  clients      |           1 | 32 kB
--  technicians  |           1 | 32 kB
--
--                         QUERY PLAN
-- ----------------------------------------------------------
--  Seq Scan on tickets
--    Filter: ((client_id = 12) AND (status = 'Open'::text))
```

Every table carries exactly one index, which is its primary key. That is the shape of a database nobody has tuned, and the plan says what it costs. The monthly client report scans the whole ticket table to find the handful of open tickets for one client. Chapter 8 taught the fix. This audit's job is to notice that nobody applied it, and to say so in a way the archive can measure later. One reading this audit wants is missing from the block above. `pg_stat_user_tables` counts how many times each index has been used, which finds indexes that cost storage and write time and earn nothing. Those counters move every time anyone touches the database, so they belong in your report rather than in a textbook. Read `idx_scan` on your own server, and treat any index with a count near zero as a candidate for removal.

### The Compliance Audit

The compliance audit collects evidence rather than opinions. Each regulated obligation gets a row, a source, and a date, and the source is a query output or a file, never a recollection. Chapter 4 named the obligations. This audit proves they are met.

| Obligation | Evidence the audit collects | Chapter that built it |
| --- | --- | --- |
| Access is limited to the minimum necessary | The access audit above, signed by the data owner | 4, 5 |
| Activity is recorded and reviewable | Log settings and a sample of the audit trail | 7 |
| Records are kept and disposed on schedule | Retention rule and the oldest surviving row | 4, 9 |
| The system can be restored | The last restore drill's date, time, and count check | 9 |

### The Calendar

An audit without a date is a plan. The calendar turns three good ideas into a routine, and it needs four columns: how often, who runs it, what evidence it produces, and where that evidence is filed.

| Activity | Frequency | Owner | Evidence produced | Filed |
| --- | --- | --- | --- | --- |
| Metric capture and comparison | Monthly | Database administrator | Archive rows and the change report | Review archive |
| Access audit | Quarterly | Database administrator, signed by security lead | Drift table plus the signed access list | Client review folder |
| Performance audit | Quarterly | Database administrator | Index inventory and saved plans | Client review folder |
| Compliance audit | Annually, and after any regulated change | Security lead | Evidence table with sources | Compliance file |
| Restore drill | Quarterly | Backup owner | Timed restore and count check | Recovery plan appendix |

Frequency is a judgment about how fast the thing drifts. Privileges drift with every busy week, so quarterly is the floor. Configuration drifts slowly, so annually is fine for compliance unless a regulated change happens first. The habit that keeps a calendar alive is the one that keeps a backup honest. The next review opens by reading the last one, so a skipped month is visible instead of invisible.

### Try It Yourself 11.2: Audit a Law Office's Grants 🛠️

A law office's case database has four roles. The signed list gives the paralegal role read access to `matters` and `documents`, and the billing role read access to `matters` and `invoices`. The application may read and write all four tables, and the retired partner's login should not exist. The server shows the paralegal role reading `invoices` as well, and the retired partner's login still active.

**Predict:** Before writing any SQL, predict which of the two findings you would rank first for the managing partner, and name the CIA property each one attacks.

**Run:** Write the drift table by hand with the columns Role, Object, Privilege, and Finding, using the labels from this section. Then write the two remediation statements you would run, and name the role that must approve each before you run it.

**Explain:** In one or two sentences, explain why an audit reports a missing approved grant as a finding too, and what breaks if you only ever look for extra privileges.

### Quick Check 11.2 ✅

1. State the standard each of the three audits compares against, and name the one person who signs the access audit at Copperwind.
2. A manager asks why the compliance audit runs yearly while the access audit runs quarterly. Answer with the idea of drift speed, then explain why an inner join between granted and approved privileges would hide both findings an access audit exists to produce.

---

## 11.3 Frameworks and Benchmarks

You do not have to invent the checklist. Standards bodies publish lists of database controls, and each one carries the arguments and the audit steps with it. Borrowing one saves the work and, more usefully, gives your review an authority a reviewer already trusts. When Naomi Redhouse asks why a control is on the list, "because the benchmark says so, and here is the rationale" ends the conversation faster than your own judgment does.

### The Shape of a Benchmark Control

A **configuration benchmark** is a numbered list of hardening rules for one product. The Center for Internet Security publishes one for PostgreSQL, and separate ones for Oracle, MySQL, and SQL Server. Every control in a benchmark has the same five parts, and the shape is why a benchmark is usable rather than merely correct:

| Part | What it holds | Why it is there |
| --- | --- | --- |
| Number and title | A stable identifier and a one-line rule | So two reviews can refer to the same control |
| Profile | Level 1 for every server, Level 2 for higher-risk data | So a small shop is not held to a bank's standard |
| Rationale | What goes wrong without the control | So you can argue for the change, or against it |
| Audit | The exact command that reports the current state | So the score is evidence and not opinion |
| Remediation | The exact change that fixes a failure | So the fix does not depend on your memory |

Copperwind wrote its own short benchmark in that shape for the databases it hosts, and this chapter's data pack ships it as `copperwind-benchmark-checklist.md`. Ten controls, each with a rationale, an audit command, and a remediation. Open it now and read one control end to end before you score anything.

### Scoring the Server

Eight of the ten controls audit a server setting, so one query scores all eight at once. Write the benchmark's expected value beside each control, read what the server reports, and let the comparison produce the score:

```sql
-- Step 1: Write the benchmark's expected value beside each control id,
--         so the score is a comparison and not an opinion
WITH benchmark (control_id, setting_name, expected_value) AS (
  VALUES ('CW-BM-01', 'log_connections',          'on'),
         ('CW-BM-02', 'log_statement',            'ddl'),
         ('CW-BM-03', 'log_line_prefix',          '%m [%p] %u@%d %h '),
         ('CW-BM-04', 'ssl',                      'on'),
         ('CW-BM-05', 'password_encryption',      'scram-sha-256'),
         ('CW-BM-06', 'archive_mode',             'on'),
         ('CW-BM-07', 'row_security',             'on'),
         ('CW-BM-08', 'shared_preload_libraries', 'pg_stat_statements')
)
-- Step 2: Read what the server reports today, from the catalog rather
--         than from anyone's memory of how it was set up
-- Step 3: Keep the observed value beside the score, so the report shows
--         the reviewer what it saw
SELECT b.control_id,
       b.setting_name,
       b.expected_value,
       s.setting AS observed_value,
       CASE WHEN s.setting = b.expected_value THEN 'PASS' ELSE 'FAIL' END AS score
FROM benchmark AS b
JOIN pg_settings AS s ON s.name = b.setting_name
ORDER BY b.control_id;
-- Output:
--  control_id |       setting_name       |   expected_value   | observed_value | score
-- ------------+--------------------------+--------------------+----------------+-------
--  CW-BM-01   | log_connections          | on                 | off            | FAIL
--  CW-BM-02   | log_statement            | ddl                | none           | FAIL
--  CW-BM-03   | log_line_prefix          | %m [%p] %u@%d %h   | %m [%p]        | FAIL
--  CW-BM-04   | ssl                      | on                 | off            | FAIL
--  CW-BM-05   | password_encryption      | scram-sha-256      | scram-sha-256  | PASS
--  CW-BM-06   | archive_mode             | on                 | off            | FAIL
--  CW-BM-07   | row_security             | on                 | on             | PASS
--  CW-BM-08   | shared_preload_libraries | pg_stat_statements |                | FAIL
```

Two of eight pass. The password scheme is strong and row-level security is available, both of which are defaults this server never had to earn. Everything a person had to turn on is off: connection logging, statement logging, the log prefix that identifies who, TLS, write-ahead log archiving, and the statement collector from Fix It 11.1. That is a normal score for a server nobody has hardened, and it is a fair picture of where the work is.

### Frameworks Above the Product

A benchmark tells you how to configure one product. A **control framework** organizes security work into families so an organization can plan across products. NIST Special Publication 800-53 is the federal catalog, and its family codes appear in contracts, audit reports, and job postings. You do not memorize the catalog. You learn the families, because they map onto what you have already built:

| Family | Code | What it covers | Where you did it |
| --- | --- | --- | --- |
| Access Control | AC | Least privilege, role assignment, account management | Chapters 4, 5 |
| Audit and Accountability | AU | Log content, retention, review, protection of logs | Chapter 7 |
| Configuration Management | CM | Baseline configuration, change control, settings | Chapters 2, 11 |
| Contingency Planning | CP | Backup, recovery, testing the plan | Chapters 8, 9 |
| System and Communications Protection | SC | Encryption at rest and in motion | Chapter 6 |
| Incident Response | IR | Detection, containment, reporting | Chapter 10 |

The **OWASP** guidance sits between the two. Its Database Security Cheat Sheet is short, opinionated, and written for the person doing the work, and its ordering is the useful part. It puts transport security, least privilege, and parameterized queries above everything else, which matches where the damage happens. Use a benchmark to configure the server, a framework to plan and report, and a cheat sheet to remember what matters most on a busy day.

### What the Cloud Provider Sells You

Chapter 2 weighed running a database on your own hardware against renting a managed one. That choice reappears here, because every major cloud provider sells security services that do part of this chapter's routine for you. Four categories cover most of them:

* **Managed key services** hold encryption keys in hardware, rotate them on a schedule, and log every use. They answer the key-custody question Chapter 6 raised and could not answer for you.
* **Security posture services** score your database configuration against a published benchmark on a schedule and open a finding for each failure. They also track your engine version against published advisories. They are the Section 11.3 query, running nightly, across every server you own.
* **Managed audit log services** collect database logs into storage you cannot quietly edit, with their own retention rules. They answer the Chapter 7 question of where logs go and who could change them.
* **Managed secret services** store service account passwords outside the application, hand them out on request, and rotate them without an outage. They answer the Chapter 5 problem of a service account password sitting in a configuration file that nobody rotates because rotating it means a restart.

None of these decides anything. A posture service will tell you TLS is off. It will not tell you whether your clinic can accept the downtime a restart costs, and it will not sign the access list. The decisions in this chapter stay with you wherever the server runs, which is the point Chapter 1 made about managed services and this chapter makes again with a score in hand.

### Choosing What to Adopt

A failing score is not a work plan. Six failures with no order and no owner will still be six failures next quarter. Rank them the way Chapter 9 ranked scan findings, by likelihood and impact, then apply one more filter that decides what happens this month: what does the fix cost, and what does it interrupt? That filter splits Copperwind's six failures cleanly. Connection logging, statement logging, and the log prefix need a configuration reload, which is cheap but touches a shared file. TLS, write-ahead log archiving, and the statement collector need a restart, which means a change window and a client notification. Two more controls from the checklist need neither, because they are grants inside the database and take effect immediately. Those two, plus the missing index the performance audit found, are what Section 11.4 adopts today. The other six become a change request with a date, which is a real answer rather than a deferral.

### Try It Yourself 11.3: Score a Bike Shop Against Three Controls 🛠️

A bike shop runs a point-of-sale database on a server in the back room. The owner has never heard of a benchmark. You score three controls: connection logging, TLS for client connections, and the rule that PUBLIC holds no CONNECT privilege on the database. The shop's server reports `log_connections = off`, `ssl = off`, and PUBLIC still holding CONNECT.

**Predict:** All three fail. Before reading further, predict which one you would adopt first if the shop closes for exactly one hour a week and every change must fit in that hour.

**Run:** Build a five-column table (Control, Observed, Score, Cost of the fix, Adopt now or schedule). Fill it for all three, using reload, restart, or immediate as the cost. Then write the one-sentence change request you would hand the owner for whatever you did not adopt today.

**Explain:** In one or two sentences, explain why cost to apply belongs in the decision at all, given that likelihood and impact already rank the risk. Name what happens to a work plan that ignores it.

### Quick Check 11.3 ✅

1. Name the five parts of a benchmark control and state which one lets you argue against adopting it.
2. Two servers score 6 of 10 on the same benchmark. Explain why that does not make them equally secure, using the Level 1 and Level 2 profiles.

---

## 11.4 Measuring Improvement

You adopted a control. Did anything change? A **quantifiable metric** is a number, taken the same way before and after, that moves when the control works and stays put when it does not. Without one, the report says the work was done. With three, the report says what the work bought.

### What Makes a Metric Worth Collecting

Four tests separate a metric from a number:

* **It is specific.** "Access is tighter" is an opinion. "The reporting role can read 2 tables instead of 5" is a metric.
* **It is stable.** It measures the same way on Monday and on the first of the month, and a rerun with no change returns the same value.
* **It is cheap.** It comes from a catalog view or a count, so nobody skips it because it takes an afternoon.
* **It moves.** If the control works and the number does not budge, you measured the wrong thing.

The last test rules out most of the numbers people like to report. Total row count grows whether or not you did anything. Uptime looks impressive and says nothing about the control you just adopted. Choose the number the control acts on directly, and name what direction counts as better before you take the first reading.

### Capture the Before

The archive from Section 11.1 already holds a table for this, and a second view defines the three control metrics. Capturing the before is one insert:

```sql
CREATE VIEW review.control_metrics AS
SELECT 'public_connect_allowed' AS metric_name,
       has_database_privilege('public', current_database(),
                              'CONNECT')::int::bigint AS metric_value
UNION ALL
SELECT 'reports_role_tables',
       (SELECT COUNT(*) FROM pg_class
        WHERE relnamespace = 'public'::regnamespace AND relkind = 'r'
          AND has_table_privilege('copperwind_reports', oid, 'SELECT'))
UNION ALL
SELECT 'indexes_on_tickets',
       (SELECT COUNT(*) FROM pg_index WHERE indrelid = 'tickets'::regclass);
INSERT INTO review.metrics (captured_on, database_name, metric_name, metric_value)
SELECT DATE '2026-09-01', current_database(), metric_name, metric_value
FROM review.control_metrics;
SELECT metric_name, metric_value
FROM review.control_metrics
ORDER BY metric_name;
-- Output:
-- CREATE VIEW
-- INSERT 0 3
--       metric_name       | metric_value
-- ------------------------+--------------
--  indexes_on_tickets     |            1
--  public_connect_allowed |            1
--  reports_role_tables    |            5
```

Three numbers, three directions. `public_connect_allowed` is 1 and should be 0, because benchmark control CW-BM-09 says a client's database accepts only the roles that serve it. `reports_role_tables` is 5 and should be 2, the size of the signed list. `indexes_on_tickets` is 1 and should be 2, because the monthly client report needs one the primary key cannot serve.

### Adopt the Controls

Now the changes. Not one of them needs a restart, and each is followed by the reading that proves it landed:

```sql
REVOKE CONNECT ON DATABASE copperwind_ops FROM PUBLIC;
GRANT CONNECT ON DATABASE copperwind_ops TO copperwind_app, copperwind_reports;
REVOKE SELECT ON ALL TABLES IN SCHEMA public FROM copperwind_reports;
GRANT SELECT ON clients, tickets TO copperwind_reports;
CREATE INDEX tickets_client_status_idx ON tickets (client_id, status);
EXPLAIN (COSTS OFF)
SELECT ticket_id, opened_at, summary
FROM tickets
WHERE client_id = 12
  AND status = 'Open';
-- Output:
-- REVOKE
-- GRANT
-- REVOKE
-- GRANT
-- CREATE INDEX
--                              QUERY PLAN
-- --------------------------------------------------------------------
--  Bitmap Heap Scan on tickets
--    Recheck Cond: ((client_id = 12) AND (status = 'Open'::text))
--    ->  Bitmap Index Scan on tickets_client_status_idx
--          Index Cond: ((client_id = 12) AND (status = 'Open'::text))
```

The plan is the proof for the third control. The same query that scanned the whole ticket table in Section 11.2 now reaches the rows through `tickets_client_status_idx`. Revoking a blanket grant and re-granting the signed list is the pattern for the second, and the order matters. Revoking after granting would take back what you just gave.

### Capture the After and Report the Change

Two weeks later the review runs the same view again and the report writes itself. The join between two captures is the one Section 11.1 used, pointed at different dates:

```sql
INSERT INTO review.metrics (captured_on, database_name, metric_name, metric_value)
SELECT DATE '2026-09-15', current_database(), metric_name, metric_value
FROM review.control_metrics;
SELECT first_capture.metric_name,
       first_capture.metric_value  AS before_2026_09_01,
       second_capture.metric_value AS after_2026_09_15,
       second_capture.metric_value - first_capture.metric_value AS change
FROM review.metrics AS first_capture
JOIN review.metrics AS second_capture
  ON second_capture.database_name = first_capture.database_name
 AND second_capture.metric_name = first_capture.metric_name
 AND second_capture.captured_on = DATE '2026-09-15'
WHERE first_capture.captured_on = DATE '2026-09-01'
  AND first_capture.database_name = current_database()
ORDER BY first_capture.metric_name;
-- Output:
-- INSERT 0 3
--       metric_name       | before_2026_09_01 | after_2026_09_15 | change
-- ------------------------+-------------------+------------------+--------
--  indexes_on_tickets     |                 1 |                2 |      1
--  public_connect_allowed |                 1 |                0 |     -1
--  reports_role_tables    |                 5 |                2 |     -3
```

Three metrics, three moves in the intended direction. Two went down and one went up, which is why the report has to say what good looks like for each. Written for Mei Lin, the whole thing is four sentences. The reporting role now reads two tables instead of five, which closes the access finding from the quarterly audit. The database now accepts connections only from the two roles that serve it, which closes benchmark control CW-BM-09. The client report reaches its rows through an index instead of scanning 18,240 of them. Six benchmark controls remain open and need a maintenance window. That paragraph is the deliverable, and a manager can act on all of it without asking you a follow-up question.

### Try It Yourself 11.4: Pick the Food Bank's Three Numbers 🛠️

A food bank tightened its donor database after an audit. It revoked a shared login, moved donor contact details behind a view, and added an index the monthly mailing list query needed. The director wants proof, and the volunteer who did the work reported "the database is more secure now."

**Predict:** Before reading further, predict which of the three changes will be hardest to express as a single number, and why.

**Run:** Write a three-row table with the columns Change, Metric, Direction that counts as better, and Where the number comes from. Then write one sentence naming a number the volunteer might report that would pass as impressive and fail the "it moves" test.

**Explain:** In one or two sentences, explain why the before reading has to be taken before the change instead of reconstructed afterward. Name what a reconstructed before costs the report.

### Try It Yourself 11.5: Put the Academy on the Same Routine 🛠️

Copperwind manages `harquahala_academy` on the same monthly routine, and Luis Ortega, the registrar, wants the one-page comparison Mei Lin gets. Nothing is built yet in the academy's database. You have the metric list, the shipped archive, and the expected result.

The academy's six metrics, agreed with Principal Dana Whitfield:

| Metric name | What it counts |
| --- | --- |
| `students_rows` | Rows in `students` |
| `enrollments_rows` | Rows in `enrollments` |
| `directory_opt_outs` | Students with `directory_opt_out` true |
| `portal_accounts_rows` | Rows in `portal_accounts` |
| `staff_rows` | Rows in `staff` |
| `indexes_total` | Indexes on tables in the `public` schema |

The archive file `assets/code/chapter-11/review-baselines.csv` holds the 2026-08-01 capture for every database Copperwind manages. Your capture date is 2026-09-01. The only scaffold you get is the connection: `\connect harquahala_academy`.

**Predict:** Name the approach before you type. Which two objects does the academy's database need before any capture can happen, and which column of the shipped file keeps Copperwind's own rows out of the academy's report? Then predict the sign of the change on `directory_opt_outs` and say what would worry you if it went the other way.

**Run:** Build the archive, load the shipped baselines, capture the six metrics for 2026-09-01, and report every metric against its 2026-08-01 baseline with the change. Your report should match this:

```text
     metric_name      | baseline_2026_08_01 | current_2026_09_01 | change
----------------------+---------------------+--------------------+--------
 directory_opt_outs   |                  44 |                 49 |      5
 enrollments_rows     |                5940 |               6000 |     60
 indexes_total        |                  10 |                 10 |      0
 portal_accounts_rows |                1188 |               1201 |     13
 staff_rows           |                  61 |                 60 |     -1
 students_rows        |                 793 |                800 |      7
```

**Explain:** In one or two sentences, explain what the `staff_rows` change of -1 obligates you to check before the report reaches Luis Ortega. Name the audit from Section 11.2 that would settle it.

### Quick Check 11.4 ✅

1. Name the four tests a metric has to pass, and give one number that fails the last one.
2. A report says a control was adopted and shows no numbers. State what a manager cannot tell from it, then explain why the fixed report still has to name the direction that counts as better for each metric.

---

## 11.5 Summary and Retrieval 💡

### Key Concepts

* A routine review measures the same things on the same schedule, whether or not anything looks wrong. Three properties make it a routine: a fixed metric set, a durable archive, and a calendar. Remove any one and it lasts until the first busy week.
* The metric set covers capacity, performance, security, and evidence, and it is defined once as a view so every run measures the same way. The archive stores one row per metric per run, in its own schema, so any two runs can be joined and change becomes visible.
* Three audits compare measurement against a standard. The access audit compares granted privileges against the signed list and finds privilege drift in both directions. The performance audit compares current cost against the last capture. The compliance audit collects evidence with sources. The calendar names the frequency, the owner, the evidence, and where it is filed.
* A configuration benchmark is a numbered list of hardening rules for one product, and every control carries a number, a profile, a rationale, an audit command, and a remediation. A control framework such as NIST SP 800-53 organizes the work into families for planning. Cloud security services automate parts of the routine and decide none of it.
* A failing score is not a work plan. Rank findings by likelihood and impact, then filter by what the fix costs, because grants take effect immediately while restarts need a change window. A quantifiable metric is specific, stable, cheap, and it moves when the control works. Capture the before, adopt the control, capture the after the same way, and report the change with the direction that counts as better.

### Key Terms

See course glossary for full definitions

* routine review, review archive, metric set, capture (Section 11.1)
* audit, access audit, privilege drift, performance audit, compliance audit, review calendar (Section 11.2)
* control framework, control family, security posture service (Section 11.3)
* quantifiable metric, before-and-after report (Section 11.4)

### Retrieval Practice

1. From memory, name the three properties that turn a set of measurements into a routine, and state which one a busy month attacks first.
2. Describe the five parts of a benchmark control in order, and name the part that lets you argue a control is not worth adopting on a particular server.
3. State the four tests a metric must pass, and give one example of a number that is specific, stable, and cheap but still worthless.
4. From Chapter 9: A vulnerability scan produces findings ranked by likelihood and impact. Name the third factor this chapter adds before a finding becomes this month's work, and give one example of a fix that factor pushes into next month.
5. From Chapter 7: The server log records connections and data definition changes. Name the setting that has to be on before the access audit can say who connected, and explain why the audit still needs the catalog even when the log is complete.

---

## 11.6 Skills Lab 11A: The Copperwind Monthly Review

**Goal:** Stand up Copperwind's monthly review on `copperwind_ops`, score the server against the shipped benchmark checklist, adopt three controls, and report the before-and-after metrics in a page Mei Lin can act on.

**Dataset or starter files:** `assets/code/chapter-11/` in the course data pack. `setup-copperwind.sql` rebuilds `copperwind_ops` with the two service roles Copperwind runs against it. `review-baselines.csv` is the archive the previous review left behind, and `copperwind-access-list.csv` is the signed access list. `copperwind-benchmark-checklist.md` is the ten-control benchmark you score. `skills-lab-11a.sql` is the starter script with numbered markers, and `skills-lab-11a-answers.md` holds the metric design, the scoring record, the calendar, the before-and-after report, and the two Questions & Analysis answers. Copperwind and every record in its database are fictional.

### Part 1: Foundation (Aligns with Objective 11.1)

1. From the extracted `cis376` folder, run `setup-copperwind.sql` as `postgres`. Under marker 1.1, create the `review` schema and the archive table, and load `review-baselines.csv` into it. Paste the `COPY` result.
2. Design your own metric set of at least six metrics, drawn from at least three of the four families in Section 11.1. In the answer file, record each metric with its family, its source, and one sentence on why it changes. At least one metric must come from `login_events` and at least one from a catalog view.
3. Under marker 1.2, define your metric set as a view and capture it with `captured_on` set to `DATE '2026-09-01'`. Under marker 1.3, report every metric the shipped archive holds against its 2026-08-01 baseline, with the change. Paste both results.

### Part 2: Application (Aligns with Objectives 11.1 and 11.2)

1. Under marker 2.1, run the access audit: load `copperwind-access-list.csv` into `review.approved_access` and produce the drift table. Under marker 2.2, run the performance audit: the index inventory plus an `EXPLAIN (COSTS OFF)` plan for the monthly client report. Paste both results.
2. Open `copperwind-benchmark-checklist.md` and score all ten controls. Score the eight setting controls with one query under marker 2.3, and the last two with the audit commands the checklist gives. Fill the scoring record table in your answer file with the observed value and the score for every control.
3. In the answer file, build Copperwind's review calendar for this database with the four columns from Section 11.2: frequency, owner, evidence produced, and where it is filed. Give every audit a frequency and defend one of your choices in a sentence, using drift speed.

### Part 3: Extension (Aligns with Objectives 11.2 and 11.3)

1. Choose three failing controls to adopt now and at least one to schedule instead. In the answer file, justify each choice with likelihood, impact, and cost to apply, and state why the scheduled one cannot be done today.
2. Under marker 3.1, define a control-metric view for your three adopted controls and capture it as of `DATE '2026-09-01'`. Under marker 3.2, adopt the three controls, each followed by the reading that proves it took effect. Under marker 3.3, capture the same view as of `DATE '2026-09-15'` and produce the before-and-after report with a change column.
3. Write the review page for Mei Lin in the answer file. Name what changed with its number, what proves it, what is still open, and the date you are requesting for the maintenance window. Keep it under 200 words and write it so a client manager could read it.

### Questions & Analysis 🤔

1. Your before-and-after report shows three metrics moving. Using your numbers as evidence, explain which of the three changes most reduced Copperwind's risk, and name one risk that all three together leave untouched.
2. The benchmark you scored is Copperwind's own short subset, not the published benchmark it imitates. Judge what Copperwind gains and gives up by maintaining its own checklist, and state the one condition under which you would recommend scoring against the published benchmark instead.

**Submission:** Submit one folder named `skills-lab-11a-lastname`. It holds `skills-lab-11a.sql` with every result pasted as `-- Output:` comment lines (or the saved psql output beside it). It also holds `skills-lab-11a-answers.md` with the metric design, the scoring record, the review calendar, the before-and-after report, the page for Mei Lin, and your two Questions & Analysis answers clearly labeled.

### Rubric: Skills Lab 11A

This lab is graded with the standard
[Skills Lab Rubric](../skills-lab-rubric.md): four criteria, five
levels from Mastery to Not Evident. The criteria are Technical
Accuracy and Efficiency, Output Quality, Documentation Quality, and
Analysis, Interpretation, and Response to QUESTION(s). The criteria
and levels are the same everywhere. Your instructor sets the point
values in your course. Check the syllabus and the Canvas rubric
attached to this lab for the values that apply to you.

---

## 11.7 Review Questions 🔄️

1. **Apply:** A credit union hosts one member database and has never run a review. Design its monthly metric set: name six metrics, the family each belongs to, and the catalog view or table each comes from. State the one metric you would put at the top of the page and why.

2. **Analyze:** An access audit returns four rows marked NOT APPROVED and one marked MISSING. Explain what each label means for the business, rank the two kinds of finding by urgency, and describe the evidence you would bring the data owner before either is fixed.

3. **Evaluate:** Two managed database servers score 6 of 10 on the same benchmark. One fails three Level 1 controls and one Level 2 control. The other fails four Level 2 controls. Judge which server you would work on first and defend the choice using the profile idea and the data each server holds.

4. **Create:** Design a one-page routine review for the academy's student database. Name six metrics with their sources, the audit calendar with frequency and owner for three audits, and the three before-and-after metrics you would use to prove that closing a FERPA directory-information finding worked.

---

## Further Reading 📖

* [CIS PostgreSQL Benchmark](https://www.cisecurity.org/benchmark/postgresql) - The published benchmark whose control shape (number, profile, rationale, audit, remediation) this chapter's Copperwind checklist imitates. Free to download after registration.
* [NIST SP 800-53 Rev. 5: Security and Privacy Controls](https://csrc.nist.gov/pubs/sp/800/53/r5/upd1/final) - The federal control catalog behind the family codes in Section 11.3, including AC, AU, CM, CP, and SC.
* [OWASP Database Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Database_Security_Cheat_Sheet.html) - The short, ordered list of database controls to check first, written for the person doing the work.
* [PostgreSQL Documentation: Monitoring Database Activity](https://www.postgresql.org/docs/17/monitoring-stats.html) - Every statistics view a review can read, including `pg_stat_user_tables` and the index-usage counters this chapter names but does not print.
* [PostgreSQL Documentation: pg_stat_statements](https://www.postgresql.org/docs/17/pgstatstatements.html) - The extension from Fix It 11.1, including the `shared_preload_libraries` requirement and every column the view reports.

---

## Looking Ahead ⏩

You can now run a review that finds problems before they announce themselves, score a server against a benchmark, and prove with numbers that a control did something. That is the last of the eleven working skills. Chapter 12 asks you to judge what comes next, from managed cloud databases and infrastructure as code to vector search and confidential computing. Then it asks you to bring all eleven chapters into one management and security plan for one organization. The archive, the calendar, and the before-and-after report you built here become the review section of that plan.
