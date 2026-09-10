# Chapter 9: Disaster Recovery and Vulnerability Management

At 4 a.m. a Copperwind on-call phone lights up. A storage controller in the rack that holds the Sandwash Family Clinic database has failed, and the clinic opens at 7. Ethan Cole, who runs the backup rotation, asks you one question: how fast can you bring the clinic back, and how much of yesterday will be gone? Every answer you can give at 4 a.m. was decided months earlier, in a plan nobody reads until the morning they need it.

Chapter 8 taught you to make a database fast and to copy it with `pg_dump` and the write-ahead log. This chapter turns those copies into a promise you can keep. You will write the recovery plan that sets how much downtime and how much data loss the business can accept. You will restore a backup into a throwaway database and prove it landed, because a backup nobody has restored is a rumor. Then you will turn from recovery to prevention and rank the openings an attacker looks for, from an unpatched server to a search box that trusts its input.

Copperwind hired you to manage its databases, and Naomi Redhouse, the security lead, signs the recovery plans and the vulnerability reviews. This is where the two halves of the job meet. Recovery is what you do after something fails. Vulnerability management is the work that makes the failure less likely. Both are judged by evidence: a timed restore, a count that matches the plan, a finding closed. This chapter closes Part III, so by its end you can show what a database is doing, make it faster, and prove it can come back.

## Module Overview 🧭

* **Estimated time:** 5-6 hours
* **Prerequisites:** One prior SQL course (Introduction to Oracle: SQL, CIS276DA MySQL Database, or CIS276DB SQL Server Database). Chapter 1 (the lab environment and the three course databases). Chapter 8 introduces `pg_dump` and the write-ahead log, and one sentence recalls each where needed.
* **Deliverables:** Skills Lab 9A folder (`skills-lab-9a.sql` and `skills-lab-9a-answers.md`), Quick Checks

## Learning Objectives 🎯

By the end of this chapter, you will be able to:

* **9.1 (Create):** Formulate a disaster recovery plan with recovery time and recovery point objectives, data tiers, and a retention schedule for a regulated database (Section 9.1)
* **9.2 (Evaluate):** Validate a recovery plan by restoring a backup to a point in time and checking the result against the plan's targets (Section 9.2)
* **9.3 (Analyze):** Rank database vulnerabilities, including SQL injection and unpatched software, by likelihood and impact, and match each to a control (Sections 9.3-9.4)

### This chapter aligns with the following Course Learning Outcomes

* **CLO II (Evaluate):** Assess security management for database environments.
* **CLO III (Create):** Develop strategies to maintain optimal system performance, security and availability.
* **CLO IV (Evaluate):** Evaluate practices for database environment incident responses.

---

## 9.1 Disaster Recovery Planning

A disaster is any event that takes a database out of service: a failed disk, a flooded server room, a ransomware attack, or a `DROP TABLE` with no undo. A **disaster recovery plan** is the written answer to two questions asked in advance. How long may the database stay down? How much recent data may be lost? You answer both before the disaster, because at 4 a.m. there is no time to decide and no one to ask.

### Two Numbers That Drive Everything

The plan turns those two questions into two numbers. The **recovery time objective (RTO)** is the longest acceptable time from the moment the database goes down to the moment it is serving users again. The **recovery point objective (RPO)** is the largest amount of recent data the business can afford to lose, measured in time. An RPO of one hour means the recovery may lose up to the last hour of changes. These two numbers decide almost every technical choice that follows, so the data owner sets them and the plan records who signed.

RPO drives how often you back up. If the clinic can lose at most one hour of appointments, a nightly backup is not enough, because a failure at 4 p.m. would lose a full day. RTO drives which recovery method you use. A method that takes six hours cannot meet a two-hour RTO no matter how well it works. To set an honest RPO, you need to know how fast the data changes. Copperwind's ticket table answers that for its own operations database:

```sql
\connect copperwind_ops
SELECT MIN(opened_at)::date AS first_ticket,
       MAX(opened_at)::date AS last_ticket,
       COUNT(*) AS total_tickets,
       ROUND(COUNT(*)::numeric
             / (MAX(opened_at)::date - MIN(opened_at)::date), 1) AS tickets_per_day
FROM tickets;
-- Output:
--  first_ticket | last_ticket | total_tickets | tickets_per_day
-- --------------+-------------+---------------+-----------------
--  2024-01-01   | 2026-06-30  |         18240 |            20.0
```

About 20 tickets arrive a day, so a lost hour of business time costs a handful of tickets, not thousands. That number is small for tickets and much larger for a busy clinic's appointments. The point is the same either way. An RPO is a business decision informed by a measurement, not a guess, and the measurement belongs in the plan beside the number.

### Data Criticality Tiers

Not all data deserves the same protection, and treating every table as the most critical wastes money. A **data criticality tier** groups data by how much its loss or downtime hurts, and each tier gets its own RTO, RPO, and backup frequency. Three tiers cover most organizations:

| Tier | What it holds | Example at Copperwind | RTO | RPO |
| --- | --- | --- | --- | --- |
| 1 Critical | Data the business stops without | Clinic appointments and visit notes | 2 hours | 1 hour |
| 2 Important | Data needed soon, not instantly | Copperwind tickets and notes | 8 hours | 1 day |
| 3 Deferrable | Data that can wait or be rebuilt | Reporting copies, archived logs | 3 days | 1 week |

Tiering is a security decision as much as a cost one. Chapter 4 classified data by regulation, and the two views line up. The clinic's protected health information is Tier 1 because the clinic cannot see patients without it, and losing it also breaks a HIPAA obligation to keep records available. Name the tier for each database in the plan, and the backup schedule writes itself.

### Retention Requirements

A backup schedule also has to say how long each backup is kept, on what media, and where. **Retention requirements** name all three, and regulation often sets the floor. Chapter 4 recorded that HIPAA requires six years of documentation (45 CFR 164.316(b)(2)(i)), and a recovery plan is part of that documentation. Three retention questions belong in every plan:

* **Years:** how long each backup class is kept. Daily backups may live 30 days, monthly backups a year, and compliance archives for the regulatory period.
* **Media:** where the copies sit. Disk for fast restores, object storage for cheap long-term copies, and immutable storage that ransomware cannot rewrite.
* **Offsite copies:** how many copies exist and how far apart. The common rule is three copies, on two kinds of media, with one offsite. A backup in the same rack as the database dies with it.

An offsite copy is the difference between an inconvenience and a closed business. If the only backup sits on the failed server, the plan was fiction.

Written out, the clinic's schedule reads like this. Each row names a backup class, how long it lives, where it sits, and the authority behind the number:

| Backup class | Kept for | Media | Offsite | Authority |
| --- | --- | --- | --- | --- |
| Hourly appointment backups | 7 days | Disk | Yes, cloud object storage | Clinic RPO of 1 hour |
| Nightly full backups | 30 days | Disk plus object storage | Yes | Clinic recovery policy |
| Monthly archives | 6 years | Immutable object storage | Yes | HIPAA documentation, 45 CFR 164.316(b)(2)(i) |

The schedule is the recovery plan made concrete. A reviewer reads it top to bottom and can tell, without asking you, how much data the clinic risks and how far back it can reach.

### Try It Yourself 9.1: Set the Credit Union's Targets 🛠️

**Predict:** A credit union runs a loan database. The board says members must never lose a posted payment, and the loan desk can be down for at most half a business day. Before you write anything, predict which number, RTO or RPO, is the near-zero one, and which control from Chapter 8 an RPO near zero forces the credit union to run.

**Run:** Write the plan's core in a short table: the RTO, the RPO, the tier you assign the payment records, and the backup frequency each number implies. Add one line naming the retention rule you would set for month-end statements and why.

**Explain:** In one or two sentences, explain why an RTO of four hours and an RPO of zero can both be true at once. Name what that pair tells you to buy that a nightly `pg_dump` alone cannot provide.

### Quick Check 9.1 ✅

1. A clinic sets its appointment database to RTO 2 hours and RPO 1 hour. State what each number requires you to do differently, and name the one that decides how often you back up.
2. A colleague keeps the only backup on a second drive in the same server. Name the retention rule this breaks and the kind of disaster that turns the choice into a total loss.

---

## 9.2 Recovery Strategies and Drills

A plan is a promise, and a **restore drill** is how you find out whether you can keep it. The drill restores a real backup into a throwaway database, verifies the result against the plan, and times the whole thing. You run it before the disaster, on a schedule, because the worst moment to learn a backup is corrupt is the moment you need it.

### Restoring a Logical Backup

Chapter 8 produced two kinds of backup. A **logical backup**, from `pg_dump`, is a file of SQL statements that rebuild the data by replaying them. A **physical backup** is a byte-for-byte copy of the data files. Copperwind ships the clinic and its own database as logical backups, which restore the same way on any machine that runs PostgreSQL 17. A plain-format logical backup restores by replaying it into an empty database, so the drill has three moves: make an empty target, replay the file, and check the result.

```sql
-- Step 1: An empty target the setup scripts do not own, so a bad
--         restore cannot hide behind rows that were already there
\connect copperwind_ops
DROP DATABASE IF EXISTS copperwind_restore_drill;
CREATE DATABASE copperwind_restore_drill;
-- Output:
-- DROP DATABASE
-- CREATE DATABASE
```

`CREATE DATABASE` and `DROP DATABASE` are the meta-statements a drill needs, and they cannot run while you are connected to the database they name, which is why the drill connects to `copperwind_ops` first. From a shell, the restore itself is one command: `psql -U postgres -d copperwind_restore_drill -f assets/code/chapter-09/copperwind_ops-backup.sql`. Inside psql, the `\i` meta-command replays the same file. psql echoes a `CREATE TABLE` and a `COPY` line for every object as it rebuilds them:

```sql
\connect copperwind_restore_drill
\i assets/code/chapter-09/copperwind_ops-backup.sql
```

The restore ran without complaint, but "without complaint" is not evidence. The plan lists how many rows each table should hold, so read the restored database and compare. A logical backup preserves every row, so the counts should match the source exactly:

```sql
-- Step 2: Count every restored table so the next step can judge them
\connect copperwind_restore_drill
SELECT 'clients' AS table_name, COUNT(*) AS restored_rows FROM clients
UNION ALL SELECT 'technicians', COUNT(*) FROM technicians
UNION ALL SELECT 'tickets', COUNT(*) FROM tickets
UNION ALL SELECT 'ticket_notes', COUNT(*) FROM ticket_notes
UNION ALL SELECT 'login_events', COUNT(*) FROM login_events
ORDER BY table_name;
-- Output:
--   table_name  | restored_rows
-- --------------+---------------
--  clients      |            40
--  login_events |         12000
--  technicians  |             8
--  ticket_notes |         28326
--  tickets      |         18240
```

The database also reports its own size, a quick second signal that the restore is whole rather than truncated:

```sql
-- Step 3: A whole-database size check backs up the row counts
\connect copperwind_restore_drill
SELECT pg_size_pretty(pg_database_size('copperwind_restore_drill')) AS restored_size;
-- Output:
--  restored_size
-- ---------------
--  14 MB
```

!!! note "Plain dumps and custom dumps restore differently"
    Chapter 8 produced these backups in plain format, a file of SQL that `psql -f` replays. `pg_dump` also writes a custom format that `pg_restore` reads, and that format lets you restore one table, reorder the load, or restore in parallel. The choice is a tradeoff: plain dumps are readable and restore anywhere, custom dumps are faster and more flexible. The drill is the same either way, only the restore command changes.

A drill database is disposable. Once you have the counts and the time, drop it so nothing you built for the test outlives it:

```sql
-- Step 4: The drill database is disposable, so drop it when done
\connect copperwind_ops
DROP DATABASE IF EXISTS copperwind_restore_drill;
-- Output:
-- DROP DATABASE
```

That is the drill: an empty target, a replay, a verified count, and a clean teardown. Time it from the first command to the last and you have the measured RTO for a logical restore of this database. Compare that time against the plan's RTO, and the drill has told you whether the promise holds.

### Point-in-Time Recovery from the Write-Ahead Log

A logical backup restores the database as it was when the dump ran. To recover to a moment between backups, you need the **write-ahead log (WAL)**, the running record of every change PostgreSQL makes. **Point-in-time recovery (PITR)** starts from a physical **base backup** and replays archived WAL forward to a chosen instant, such as one second before a mistaken `DELETE`. That is how an RPO of minutes is met without backing up every minute.

PITR is a server configuration, not a single command, and it must be armed before the disaster. The settings live in `postgresql.conf`:

```text
# postgresql.conf: let the server keep WAL for point-in-time recovery
wal_level = replica          # the default; 'minimal' cannot support PITR
archive_mode = on            # copy each completed WAL segment aside
archive_command = 'test ! -f /backups/wal/%f && cp %p /backups/wal/%f'
# Changing wal_level or archive_mode requires a server restart.
```

You cannot test the restart on a shared teaching server, and you should never restart one you share with others. What you can verify is the current state, which tells you whether PITR is armed. Two settings decide it:

```sql
\connect copperwind_ops
SELECT name, setting
FROM pg_settings
WHERE name IN ('wal_level', 'archive_mode')
ORDER BY name;
-- Output:
--      name     | setting
-- --------------+---------
--  archive_mode | off
--  wal_level    | replica
```

`archive_mode` is `off`, so this server keeps no WAL archive and cannot do point-in-time recovery yet. The write-ahead log itself is always running, though, and you can prove the server is tracking a live WAL position and is not already recovering:

```sql
SELECT pg_current_wal_lsn() IS NOT NULL AS wal_position_tracked,
       pg_is_in_recovery() AS server_in_recovery;
-- Output:
--  wal_position_tracked | server_in_recovery
-- ----------------------+--------------------
--  t                    | f
```

The reading is honest evidence for the plan: the log is flowing, but archiving is off, so today the clinic can restore only to its last full backup. Turning `archive_mode` on and testing the restart is a change request the plan records, not a thing you do to a shared server on a whim.

Once archiving is on, a point-in-time recovery follows a fixed recipe. You restore the base backup into a new data directory, tell the server where to find the archived WAL and how far to replay, and let it recover:

```text
# Restore the base backup, then in postgresql.conf on the restored copy:
restore_command = 'cp /backups/wal/%f %p'   # fetch each archived segment
recovery_target_time = '2026-06-30 13:59:00' # stop just before the mistake
# Create a recovery.signal file, then start the server. It replays WAL
# up to the target time and stops, leaving the data as of that instant.
```

The target can be a time, a named restore point, or a transaction id. That is how an RPO of minutes is met: the last base backup plus replayed WAL rebuilds the database to the second before the `DELETE`, not to last night.

### Fix It 9.1: The Restore That Would Not Land 🔧

An earlier drill was interrupted after it had created the `tickets` table in the drill database. You start the restore again without clearing the target first.

**Symptom:** You replay the plain backup into a database that already holds one of its tables, and psql stops on the collision.

```text
psql -U postgres -d copperwind_restore_drill -f assets/code/chapter-09/copperwind_ops-backup.sql
```

```text
psql:assets/code/chapter-09/copperwind_ops-backup.sql:91: ERROR:  relation "tickets" already exists
```

**Diagnose:** State the cause in one sentence before touching anything. A plain-format dump issues `CREATE TABLE` for every table and assumes the database is empty, so a table that already exists makes the create fail.

**Repair:** Give the restore the empty database it expects. Drop and recreate the drill database, then replay the file into the clean target. State what changed: the target, not the backup.

**Verify:** How do you know it is fixed? Name the two signals from this section that prove it: a restore that finishes with no error, and a count query whose numbers match the plan.

### Try It Yourself 9.2: Recover Copperwind and Prove the Drill 🛠️

Copperwind's recovery plan for `copperwind_ops` sets an acceptance check: after a restore, each table must hold exactly the rows below, or the drill fails and the backup is suspect.

| Table | Expected rows |
| --- | --- |
| clients | 40 |
| technicians | 8 |
| tickets | 18240 |
| ticket_notes | 28326 |
| login_events | 12000 |

The backup `assets/code/chapter-09/copperwind_ops-backup.sql` has arrived, and no worked script follows. You write it.

**Predict:** Name the approach before you type. Which database do you restore into, and why not the live one? Then predict what a single verification query should return if the restore is good, and what one row of it would look like if the `tickets` table came back short.

**Run:** Restore the backup into `copperwind_restore_drill`, then write one query that compares the restored counts against the plan above and labels each table `match` or `MISMATCH`. Rule the drill pass or fail, note the wall-clock time the restore took, and drop the drill database when you are done. Your comparison should match this:

```text
  table_name  | expected_rows | restored_rows | verdict
--------------+---------------+---------------+---------
 clients      |            40 |            40 | match
 login_events |         12000 |         12000 | match
 technicians  |             8 |             8 | match
 ticket_notes |         28326 |         28326 | match
 tickets      |         18240 |         18240 | match
```

**Explain:** In one or two sentences, explain why a count match still does not fully prove the recovery plan works. Name the two plan targets from Section 9.1 that the count check alone does not measure.

### Try It Yourself 9.3: Time the Bike Shop's Restore 🛠️

**Predict:** A bike shop keeps one nightly `pg_dump` of its point-of-sale database and has never restored it. The owner assumes recovery takes "a few minutes." Before reasoning further, predict the two things a first restore drill could reveal that the nightly backup job itself never would.

**Run:** Write the three steps of a restore drill for the shop in order, and beside each step name the plan target it measures or the risk it retires. Then state the one number you would report to the owner after the drill and where it goes in the plan.

**Explain:** In one or two sentences, explain why timing the restore matters as much as confirming it succeeds, and what the shop should do if the measured time is longer than its RTO.

### Quick Check 9.2 ✅

1. A teammate says "the nightly backup job succeeded, so we are covered." Using this section, name the one test that turns that hope into evidence and the two results the test must produce.
2. The clinic wants to recover to the moment just before a bad bulk update, not to last night's backup. Name the recovery method that makes this possible and the one `postgresql.conf` setting that must be on for it to work.

---

## 9.3 Vulnerability Management

Recovery is what you do after a failure. **Vulnerability management** is the routine that makes failures rarer: find the weaknesses in the database and its server, rank them, fix or accept each one, and check again on a schedule. A **vulnerability** is a weakness an attacker or an accident could use to break confidentiality, integrity, or availability. The three most common ones for a database are unpatched software, weak protocols, and misconfiguration, and all three are visible from the server itself.

### Versions and Patches

Old software is the easiest opening to find and often the easiest to close. A **security patch** is a vendor fix for a known flaw, and PostgreSQL ships them in minor releases, such as 17.11 to 17.12, that never change how your queries behave. Running a version behind on patches means running with published flaws an attacker can look up by version number. So the first question of any review is which version is running:

```sql
SELECT current_setting('server_version') AS running_version,
       current_setting('ssl') AS ssl_on,
       current_setting('password_encryption') AS password_scheme;
-- Output:
--  running_version  | ssl_on | password_scheme
-- ------------------+--------+-----------------
--  17.11 (Homebrew) | off    | scram-sha-256
```

Three findings sit in one row. The version tells you whether patches are current. The `ssl` setting is `off`, so this server accepts unencrypted connections, a Chapter 6 concern for data in motion. The password scheme is `scram-sha-256`, which is the strong default from Chapter 5. Read the whole posture from the catalog, not from memory, because the catalog is what an auditor will read.

PostgreSQL ships minor releases about every three months and lists the flaws each one fixes on its security page. The management move is a patch cadence: a scheduled window to move to the current minor release, tested on a copy first, so the server is never far behind a published fix. A minor upgrade does not change your data or your queries, so the risk is downtime, not breakage. The restore drill you built in Section 9.2 is what makes that downtime safe to schedule.

### Secure Protocols and Configuration Scanning

A **secure protocol** carries data so a listener on the network learns nothing. TLS for client connections (Chapter 6) is the one that matters most for a database, and the `ssl = off` reading above is a finding a review would open. Rather than check each setting by hand, teams scan the whole configuration against a published standard. A **configuration benchmark**, such as the Center for Internet Security's PostgreSQL Benchmark, is a checklist of hardening rules, and a scan reports which rules the server passes and which it fails. Copperwind's Data Services team runs a scan and files the report with each database it manages. The chapter data pack ships one such report for the clinic server, `copperwind-scan-report.md`, and Skills Lab 9A asks you to rank its findings.

### Tracking Findings

A scan produces findings, and a finding nobody ranks or closes is noise. You rank each one by **likelihood**, how easily it could be used, and **impact**, how much harm it would do, then order by the two together so the worst rises to the top. Recording the findings in a table lets the database do the ranking and lets the next review measure progress. Score each finding, sort, and the priority list writes itself:

```sql
-- Step 1: Record each scan finding with a likelihood and an impact,
--         both scored 1 (low) to 5 (high) by the reviewer
CREATE TEMP TABLE scan_findings (
  finding_id   text,
  description  text,
  likelihood   integer,
  impact       integer
);
INSERT INTO scan_findings VALUES
  ('CW-01', 'Server version behind two minor releases', 3, 4),
  ('CW-02', 'Application role holds SELECT on every table', 4, 4),
  ('CW-03', 'TLS not required for remote connections', 3, 5),
  ('CW-04', 'Backups written to an unencrypted shared folder', 2, 5),
  ('CW-05', 'log_connections off, so logins are not recorded', 4, 2);
-- Step 2: Multiply likelihood by impact for one comparable risk score
-- Step 3: Band the score so a manager can read the priority at a glance
SELECT finding_id,
       likelihood,
       impact,
       likelihood * impact AS risk_score,
       CASE WHEN likelihood * impact >= 15 THEN 'Critical'
            WHEN likelihood * impact >= 9  THEN 'High'
            WHEN likelihood * impact >= 4  THEN 'Medium'
            ELSE 'Low' END AS priority
FROM scan_findings
ORDER BY risk_score DESC, finding_id;
-- Output:
-- CREATE TABLE
-- INSERT 0 5
--  finding_id | likelihood | impact | risk_score | priority
-- ------------+------------+--------+------------+----------
--  CW-02      |          4 |      4 |         16 | Critical
--  CW-03      |          3 |      5 |         15 | Critical
--  CW-01      |          3 |      4 |         12 | High
--  CW-04      |          2 |      5 |         10 | High
--  CW-05      |          4 |      2 |          8 | Medium
```

The ranking does the arguing for you. The over-privileged application role and the missing TLS rise to Critical, the unpatched version and the exposed backup fall to High, and the missing login log sits at Medium. Each finding then gets a control and an owner. Least privilege answers CW-02 (Chapter 5), TLS answers CW-03 (Chapter 6), a patch window answers CW-01, encryption and retention answer CW-04 (Chapters 6 and this one), and logging answers CW-05 (Chapter 7). Ranking without a matched control is a list of worries. Ranking with controls is a work plan.

### Try It Yourself 9.4: Rank the Law Office's Scan 🛠️

**Predict:** A law office's scan returns four findings. They are a superuser account with a weak password, a public schema readable by every role, a database three minor versions behind, and verbose error messages that leak table names. Before scoring, predict which one ranks highest in terms of likelihood and impact.

**Run:** Build a five-column table (finding, likelihood 1-5, impact 1-5, score, matched control). Score each finding, order by score, and name the control and the chapter that answers each. Mark the one finding you would treat as blocking until it is fixed.

**Explain:** In one or two sentences, explain why likelihood and impact are scored separately rather than as one "severity" guess. Give an example of a high-impact finding whose low likelihood still lets it wait.

### Quick Check 9.3 ✅

1. A review finds the server two minor releases behind. State the vulnerability class this belongs to and the control that closes it, and explain why the fix is low-risk to apply.
2. Two findings score the same risk number, but one is a missing TLS rule and one is a missing login log. Explain how you would break the tie, using the CIA property each one protects.

---

## 9.4 SQL Injection

One vulnerability deserves its own section because it is the most common way a database is robbed through the front door. **SQL injection** is an attack that slips SQL into a value the application meant as plain data, so the attacker's text runs as part of the query. It attacks confidentiality first and integrity close behind, and it does not need a stolen password. It needs one query that was built by gluing user input into SQL text.

### How It Works, and What Stops It

The flaw is string building. When an application concatenates a user's input into a SQL string, the database cannot tell the value from the command. A **parameterized query** sends the SQL and the values separately, so the value can only ever be data, never code. In PostgreSQL you build a dynamic query with `EXECUTE`, and the difference between danger and safety is whether the input is glued into the text or passed with `USING`. The demonstration builds both against Copperwind's client list. The unsafe version concatenates. The safe version parameterizes:

```sql
\connect copperwind_ops
-- Unsafe: the input is glued straight into the SQL text
CREATE FUNCTION clients_named_unsafe(p_name text) RETURNS bigint
LANGUAGE plpgsql AS $$
DECLARE hits bigint;
BEGIN
  EXECUTE 'SELECT count(*) FROM clients WHERE client_name = ''' || p_name || ''''
    INTO hits;
  RETURN hits;
END $$;
-- Safe: the input rides in a parameter and can only be data
CREATE FUNCTION clients_named_safe(p_name text) RETURNS bigint
LANGUAGE plpgsql AS $$
DECLARE hits bigint;
BEGIN
  EXECUTE 'SELECT count(*) FROM clients WHERE client_name = $1'
    USING p_name INTO hits;
  RETURN hits;
END $$;
-- A normal search, then the same injection against each function
SELECT clients_named_unsafe('Nobody Incorporated')  AS unsafe_real_name,
       clients_named_unsafe(''' OR ''1''=''1')       AS unsafe_injected,
       clients_named_safe(''' OR ''1''=''1')         AS safe_injected;
-- Output:
-- CREATE FUNCTION
-- CREATE FUNCTION
--  unsafe_real_name | unsafe_injected | safe_injected
-- ------------------+-----------------+---------------
--                 0 |              40 |             0
```

Read the three numbers. Searching the unsafe function for a name nobody has returns 0, as it should. Feeding it the string `' OR '1'='1` returns 40, every client Copperwind has, because the injected text turned the filter into a condition that is always true. The safe function, given the exact same attack string, returns 0, because it treated the string as a name to look for and no client is named that. The attack and the defense differ by one choice: `USING` instead of `||`.

When you must build the query text rather than pass a parameter, PostgreSQL gives you `format()` with the `%L` placeholder, which quotes and escapes a value as a SQL literal. It is the safe way to put a value into text that a parameter cannot reach, such as a value used in more than one place. The same attack string lands harmless:

```sql
\connect copperwind_ops
-- %L quotes and escapes the input as a literal, so it stays data
CREATE FUNCTION clients_named_format(p_name text) RETURNS bigint
LANGUAGE plpgsql AS $$
DECLARE hits bigint;
BEGIN
  EXECUTE format('SELECT count(*) FROM clients WHERE client_name = %L', p_name)
    INTO hits;
  RETURN hits;
END $$;
SELECT clients_named_format('Nobody Incorporated')  AS format_real_name,
       clients_named_format(''' OR ''1''=''1')       AS format_injected;
-- Output:
-- CREATE FUNCTION
--  format_real_name | format_injected
-- ------------------+-----------------
--                 0 |               0
```

Use `%L` for values and never `%s`, which inserts the raw text and reopens the same hole the unsafe function had. A parameter with `USING` is the first choice, and `%L` is the tool for the cases a parameter cannot cover.

### Least Privilege Limits the Damage

Parameterized queries stop the injection. Least privilege decides how bad it is when one slips through, because no code is perfect. Chapter 5 built roles that hold only the privileges their job needs, and that work pays off here. Say the clinic's scheduling application connects as a role that can only `SELECT` from the appointment tables. An injection that reaches the database still cannot `DROP` a table, read the `patients` insurance column, or create an account. The injection that returned 40 client names above would return nothing extra if the role could not read the `clients` table at all. Two controls, stacked: parameterized queries keep the attack out, and least privilege shrinks the blast radius if it gets in. The application that connects as a superuser has neither.

### Try It Yourself 9.5: Read the Food Bank's Search Box 🛠️

**Predict:** A food bank's donor page has a search box that finds donors by last name. A developer built the query by joining the box's text onto `... WHERE last_name = '` and the input and a closing quote. Before writing anything, predict what a curious visitor who types `' OR '1'='1` into the box would see, and which CIA property that breaks first.

**Run:** Rewrite the developer's query two ways in a text file: once showing the concatenation that is vulnerable, and once as a parameterized query that is not. Then name the database role the search page should connect as and the one privilege it needs, using the least-privilege idea from Chapter 5.

**Explain:** In one or two sentences, explain why validating the input to reject quotation marks is a weaker fix than a parameterized query, and what the parameterized version does that input filtering cannot promise.

### Quick Check 9.4 ✅

1. Explain in your own words why a parameterized query stops SQL injection when careful string escaping often does not.
2. An application connects to the clinic database as a superuser "so it never hits a permissions error." Name the two controls from this chapter that the choice throws away and the worst thing an injection could then do.

---

## 9.5 Summary and Retrieval 💡

### Key Concepts

* A disaster recovery plan sets two numbers before the disaster. The recovery time objective is the longest acceptable downtime, and the recovery point objective is the most recent data the business can lose. RPO drives how often you back up, RTO drives which recovery method you choose, and the data owner signs both.
* Data criticality tiers give each class of data its own RTO, RPO, and backup frequency, so the most critical data is protected hardest and the rest is protected cheaply. Retention requirements name how long copies are kept, on what media, and how many sit offsite.
* A restore drill turns a backup into evidence. Restore into an empty throwaway database, verify the row counts against the plan, and time the restore against the RTO. A backup nobody has restored is a rumor.
* Point-in-time recovery replays the write-ahead log from a base backup to a chosen instant, which is how a tight RPO is met. It must be armed in `postgresql.conf` before the disaster, and every configuration change is followed by the query that proves the current state.
* Vulnerability management finds, ranks, and closes weaknesses on a schedule. Rank each finding by likelihood and impact, match every finding to a control and an owner, and rescan to measure progress.
* SQL injection runs when user input is glued into SQL text. Parameterized queries stop it by sending values apart from the command, and least privilege limits the damage if one gets through.

### Key Terms

See course glossary for full definitions

* disaster recovery plan, recovery time objective (RTO), recovery point objective (RPO), data criticality tier, retention requirements (Section 9.1)
* restore drill, logical backup, physical backup, write-ahead log (WAL), point-in-time recovery (PITR), base backup (Section 9.2)
* vulnerability, vulnerability management, security patch, secure protocol, configuration benchmark, likelihood, impact (Section 9.3)
* SQL injection, parameterized query (Section 9.4)

### Retrieval Practice

1. From memory, state what the recovery time objective and the recovery point objective each measure, and which one decides how often you back up.
2. Describe the three steps of a restore drill in order, and name the plan target each step measures or proves.
3. Explain why a parameterized query stops SQL injection, and how least privilege limits the harm when an injection still lands.
4. From Chapter 7: An audit log shows the events on a server. Name one thing a restore drill's result should also be recorded in, and why the next reviewer needs the record rather than your memory.
5. From Chapter 5: Name the control that shrinks the blast radius of a successful SQL injection, and state the rule it applies to the role an application connects as.

---

## 9.6 Skills Lab 9A: Recover the Sandwash Clinic

**Goal:** Write the clinic's disaster recovery plan and prove it with a timed restore drill against a shipped backup. Then rank the findings from a shipped configuration scan so Naomi Redhouse can sign a work plan.

**Dataset or starter files:** `assets/code/chapter-09/` in the course data pack. `setup-sandwash.sql` rebuilds `sandwash_clinic`. `sandwash_clinic-backup.sql` is the logical backup you restore in the drill. `copperwind-scan-report.md` is the configuration scan you rank. `skills-lab-9a.sql` is the starter script with numbered markers, and `skills-lab-9a-answers.md` holds the plan, the drill record, the ranking, and the two Questions & Analysis answers. The clinic and every record in it are fictional.

### Part 1: Foundation (Aligns with Objective 9.1)

1. From the extracted `cis376` folder, run `setup-sandwash.sql` as `postgres`. Under marker 1.1, measure the clinic: count `appointments` and `visit_notes` and find the date range of `appointments`. Paste the result.
2. In the answer file, write the clinic's disaster recovery plan. Set an RTO and an RPO for the appointment and visit-note data, and assign each table a data criticality tier. Justify both numbers with the measurement from step 1 and the HIPAA availability point from Chapter 4.
3. Write the retention section of the plan: how long each backup class is kept, on what media, and how many copies sit offsite. Cite the HIPAA six-year documentation period where it applies.

### Part 2: Application (Aligns with Objectives 9.1 and 9.2)

1. Under marker 2.1, create an empty drill database named `clinic_restore_drill`. Under marker 2.2, restore `sandwash_clinic-backup.sql` into it. Note the wall-clock time the restore took.
2. Under marker 2.3, write one query that compares the restored row counts of `providers`, `patients`, `appointments`, `visit_notes`, and `staff_accounts` against the Part 1 counts, labeling each `match` or `MISMATCH`. Paste the result and rule the drill pass or fail.
3. In the answer file, compare the measured restore time against your RTO from Part 1 and the backup's age against your RPO. State whether the plan's targets were met and what you would change if they were not. Drop the drill database when you finish.

### Part 3: Extension (Aligns with Objectives 9.2 and 9.3)

1. Open `copperwind-scan-report.md`. Under marker 3.1, record its findings in a tracking table with a likelihood and an impact you assign, and produce the ranked, banded list with a query like the one in Section 9.3.
2. In the answer file, match each of the five findings to a control and the chapter that teaches it, and name the role or person who owns the fix. Mark any finding you would treat as blocking until it is closed.
3. Write a short paragraph for Naomi Redhouse that names the top two findings, the recovery drill's result, and the one action you recommend first, in language a clinic manager could follow.

### Questions & Analysis 🤔

1. Using your Part 2 numbers as evidence, explain what the restore drill proved that the backup job's own success message could not, and name one failure the drill would still miss.
2. Your ranking put two findings at the top. Justify the order with likelihood and impact, then explain how the recovery plan from Part 1 would change if the top finding were exploited tomorrow.

**Submission:** Submit one folder named `skills-lab-9a-lastname`. It holds `skills-lab-9a.sql` with every result pasted as `-- Output:` comment lines (or the saved psql output beside it). It also holds `skills-lab-9a-answers.md` with the recovery plan, the drill record, the ranked findings, and your two Questions & Analysis answers clearly labeled.

### Rubric: Skills Lab 9A

This lab is graded with the standard
[Skills Lab Rubric](../skills-lab-rubric.md): four criteria, five
levels from Mastery to Not Evident. The criteria are Technical
Accuracy and Efficiency, Output Quality, Documentation Quality, and
Analysis, Interpretation, and Response to QUESTION(s). The criteria
and levels are the same everywhere. Your instructor sets the point
values in your course. Check the syllabus and the Canvas rubric
attached to this lab for the values that apply to you.

---

## 9.7 Review Questions 🔄️

1. **Apply:** A nonprofit food bank runs a donor database with an RTO of 8 hours and an RPO of 24 hours. Name the backup frequency those two numbers imply, and write the three steps of a restore drill that would prove the plan holds.

2. **Analyze:** A clinic's configuration scan returns a missing TLS rule, an application role with full table access, and a server one minor version behind. Rank the three by likelihood and impact, match each to a control and a chapter, and explain which one you would fix first and why.

3. **Evaluate:** A bike shop keeps nightly `pg_dump` backups and has restored one exactly zero times. Judge whether the shop can claim it meets a 4-hour RTO, and state the single test that would turn the claim into evidence or disprove it.

4. **Create:** Design a one-page recovery plan for the academy's student database. Set an RTO and an RPO, assign two data criticality tiers, name the retention rule for grade records, and describe the restore drill that verifies the plan, including the acceptance check it must pass.

---

## Further Reading 📖

* [PostgreSQL Documentation: Backup and Restore](https://www.postgresql.org/docs/17/backup.html) - The reference for logical dumps, file-system backups, and continuous archiving, covering the restore commands this chapter runs.
* [PostgreSQL Documentation: Continuous Archiving and Point-in-Time Recovery](https://www.postgresql.org/docs/17/continuous-archiving.html) - How `archive_mode`, base backups, and WAL replay combine into the PITR this chapter configures but does not restart.
* [NIST SP 800-34 Rev. 1: Contingency Planning Guide](https://csrc.nist.gov/pubs/sp/800/34/r1/upd1/final) - The federal method behind RTO, RPO, and data tiers, written for whole information systems.
* [OWASP SQL Injection Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html) - The defense hierarchy that puts parameterized queries first and least privilege as defense in depth.
* [CIS PostgreSQL Benchmark](https://www.cisecurity.org/benchmark/postgresql) - The configuration benchmarks a scan compares a server against, including the PostgreSQL benchmark behind the shipped scan report.

---

## Looking Ahead ⏩

You can now plan a recovery, prove it with a timed restore, and rank the weaknesses an attacker would try first. That closes Part III: you can show what a database is doing, make it measurably faster, and prove it can be recovered within stated targets. Chapter 10 is the chapter where a control fails anyway. You will work a breach at the academy from the evidence, reading the logs Chapter 7 configured and applying the recovery plan this chapter taught you to write. Then you will decide what the law requires you to tell whom.
