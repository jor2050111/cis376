# Chapter 8: Performance Tuning and Redundancy

At 8:55 on the first morning of registration, Luis Ortega at Harquahala Charter Academy opens the roster page and waits. The spinner turns for nine seconds, then the grades load. Nine seconds does not sound like a crisis. Multiply it by sixty staff refreshing all morning, and the school's whole first day drags. Nobody typed a bad query. The query was fine in July, when the table held last year's rows. The table grew, and the same query got slower, and no one measured the change until a person was staring at a spinner.

You know how to make a query return the right answer. This chapter is about the two questions that come after correct: how fast, and what happens when the server fails. Chapter 2 sized the storage and Chapter 7 turned on the logs that tell you what the server did. Now you make the server quick enough for the people who depend on it, and you build the copies that keep it available when a disk dies at 2 a.m. Mei Lin wants the roster page under a second. Ethan Cole wants a backup he has restored at least once.

You will measure a slow query with its execution plan before you touch it, because a guess is not a plan. You will add an index and watch the plan change, keep the table healthy with `VACUUM` and `ANALYZE`, and learn when memory and the network matter more than any index. Then you will design the redundancy that protects the data: logical backups, the write-ahead log, a replica, and the plan that says how much downtime and data loss the school can accept. The chapter ends where every design ends, at the tradeoff: what each copy costs, and what it exposes.

## Module Overview 🧭

* **Estimated time:** 5-6 hours
* **Prerequisites:** One prior SQL course (Introduction to Oracle: SQL, CIS276DA MySQL Database, or CIS276DB SQL Server Database). Chapter 1 (the lab environment and the three course databases) and Chapter 2 (sizing and the write-ahead log). Chapter 7 supplies the logging vocabulary, and one sentence recalls it where needed.
* **Deliverables:** Skills Lab 8A folder (`skills-lab-8a.sql` and `skills-lab-8a-answers.md`), Quick Checks

## Learning Objectives 🎯

By the end of this chapter, you will be able to:

* **8.1 (Apply):** Apply indexing and query tuning techniques and measure their effect on query response time with execution plans (Sections 8.1-8.2)
* **8.2 (Create):** Design a redundancy plan with backups and replication that meets a stated availability target on premise or in the cloud (Section 8.3)
* **8.3 (Evaluate):** Judge the cost, benefit, and security exposure of a redundancy design against a performance optimization for the same budget (Section 8.4)

### This chapter aligns with the following Course Learning Outcomes

* **CLO III (Create):** Develop strategies to maintain optimal system performance, security and availability.
* **CLO V (Evaluate):** Critique current practices and future trends of database management and security.

---

## 8.1 Measure Before You Tune

The first rule of tuning is that you do not tune. You measure, then you tune the one thing the measurement blamed. A server has hundreds of settings and a database has dozens of indexes you could add, and almost all of them are the wrong answer for any given slow query. The **execution plan** is the tool that tells you which answer is right. It is PostgreSQL's step-by-step account of how it will run a query: which tables it reads, in which order, and how it joins them.

### Reading a Plan with EXPLAIN

`EXPLAIN` shows the plan without running the query. `EXPLAIN ANALYZE` runs the query and reports what happened when it ran. Start with the report Copperwind's ticket dashboard runs all day, the open tickets for one client. Ask for the plan first:

```sql
\connect copperwind_ops
EXPLAIN (COSTS OFF)
SELECT ticket_id, opened_at, summary
FROM tickets
WHERE client_id = 12
  AND status = 'Open';
-- Output:
--                         QUERY PLAN
-- ----------------------------------------------------------
--  Seq Scan on tickets
--    Filter: ((client_id = 12) AND (status = 'Open'::text))
```

A **sequential scan** (`Seq Scan`) reads every row in the table and throws away the ones that do not match. For 18,240 tickets that is fast enough to feel instant. For the academy's growing tables it is the nine-second spinner. The `COSTS OFF` option hides the planner's cost estimates so the shape of the plan stands out. Now run it and see the real work:

```sql
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF)
SELECT ticket_id, opened_at, summary
FROM tickets
WHERE client_id = 12
  AND status = 'Open';
-- Output:
--                         QUERY PLAN
-- ----------------------------------------------------------
--  Seq Scan on tickets (actual rows=4 loops=1)
--    Filter: ((client_id = 12) AND (status = 'Open'::text))
--    Rows Removed by Filter: 18236
```

Read the last line. The server looked at 18,240 rows to return 4. It removed 18,236. That ratio, work done against rows returned, is the number tuning tries to shrink. The `TIMING OFF` and `SUMMARY OFF` options drop the millisecond timings, because timings vary from run to run and this book records plans that do not. You will still read the timings on your own screen. Plain `EXPLAIN ANALYZE` prints an `Execution Time` line, and on this server the query above runs in well under a millisecond today. Record that number in your notes. It is the baseline the next section improves.

### A Baseline You Can Compare Against

A **baseline** here means the same thing it meant in Chapter 1: a measurement taken while the system is healthy, so a later measurement means something. Before you add an index, you save the plan and the timing. After, you run the identical query and compare. Without the before, "it feels faster" is the whole report, and nobody can check it. The habit is one line in your command log: the query, the date, the plan shape, and the execution time.

### The Tool You Cannot Use Yet: pg_stat_statements

One plan at a time answers "why is this query slow." A different question comes first on a busy server: "which query should I look at?" The **pg_stat_statements** extension answers it. It records every statement the server runs, with total time, call count, and mean time, so you can sort by the query that costs the most and start there. It is the standard first stop for finding the slow report you did not know about.

It needs to be loaded when the server starts. Check whether this server has it:

```sql
SHOW shared_preload_libraries;
SELECT COUNT(*) AS installed
FROM pg_extension
WHERE extname = 'pg_stat_statements';
-- Output:
--  shared_preload_libraries
-- --------------------------
--
--
--  installed
-- -----------
--          0
```

The library list is empty and the extension is not installed, so this server cannot collect those statistics yet. Turning it on is a two-step change to `postgresql.conf`, and the first step needs a restart because the library loads at startup:

```text
# postgresql.conf: load the collector at server start
shared_preload_libraries = 'pg_stat_statements'
```

After the restart, you create the extension once and query its view:

```text
CREATE EXTENSION pg_stat_statements;

SELECT queryid, calls, round(mean_exec_time::numeric, 2) AS avg_ms, query
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 3;

  queryid   | calls | avg_ms |            query
------------+-------+--------+------------------------------
 -8273...   |   412 |   9.31 | SELECT ... FROM enrollments ...
  5561...   |  1050 |   2.04 | SELECT ... FROM tickets ...
  9902...   |   88  |   1.77 | SELECT ... FROM ticket_notes ...
```

That output is what the tool prints once it is configured. This book does not restart the shared cluster to turn it on. The rest of the chapter measures with `EXPLAIN ANALYZE`, which needs no restart and answers the "why" for a query you already suspect. Chapter 11 configures a review server where `pg_stat_statements` runs for real. For now, treat the two tools as a pair: the extension finds the slow query, the plan explains it.

### Try It Yourself 8.1: Predict the Plan 🛠️

**Predict:** A credit union runs `SELECT * FROM transactions WHERE account_id = 4417` against a table of 2 million rows with no index on `account_id`. Before running anything, predict which scan the plan will show, and roughly how many rows the server must read to return the 30 that match.

**Run:** On paper, write the two-line plan you expect from `EXPLAIN (COSTS OFF)`, using the tickets plan above as your model. Then write the one line of `EXPLAIN ANALYZE` output that would prove the scan read far more rows than it returned.

**Explain:** In one or two sentences, explain why the row count returned is the wrong number to judge a query's cost, and which number in the plan is the right one.

### Quick Check 8.1 ✅

1. A colleague says a query "must be fast because it only returns three rows." Name the plan line that could prove them wrong and explain what it measures.
2. State the difference between `EXPLAIN` and `EXPLAIN ANALYZE`, and name one query you would never run with `ANALYZE` on a production table.
3. Explain why `pg_stat_statements` and `EXPLAIN ANALYZE` answer different questions, and which one you reach for first when a single page is slow.

---

## 8.2 Tuning Methods: Indexes, Queries, Maintenance, and Memory

Once a measurement names the problem, you have a short menu of fixes. Most slow reads want an index. Some want a rewritten query. A bloated table wants maintenance. A big sort wants memory, and a chatty application wants fewer round trips. Work the menu in that order, and measure after each change.

### Indexes Turn a Scan into a Lookup

An **index** is a sorted structure the server keeps beside a table so it can find rows by a column's value without reading every row. It is the difference between reading a book cover to cover and using its index. The tickets dashboard filtered on `client_id` and `status`, so an index on both columns lets the server jump straight to the matching rows. Build it, then run the identical query and read the new plan:

```sql
-- Step 1: Index the exact columns the slow query filters on
CREATE INDEX tickets_client_status_idx
  ON tickets (client_id, status);
-- Step 2: Re-run the SAME query and read the plan, not the clock
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF)
SELECT ticket_id, opened_at, summary
FROM tickets
WHERE client_id = 12
  AND status = 'Open';
-- Output:
-- CREATE INDEX
--                                   QUERY PLAN
-- ------------------------------------------------------------------------------
--  Bitmap Heap Scan on tickets (actual rows=4 loops=1)
--    Recheck Cond: ((client_id = 12) AND (status = 'Open'::text))
--    Heap Blocks: exact=4
--    ->  Bitmap Index Scan on tickets_client_status_idx (actual rows=4 loops=1)
--          Index Cond: ((client_id = 12) AND (status = 'Open'::text))
```

The `Seq Scan` is gone. The plan now reads the index to find four rows, then fetches only those four from the table. The `Rows Removed by Filter: 18236` line disappeared with it, because the server never touched the other rows. That is the whole game: read what you need, not everything you have.

An index has a price. It takes disk space, and every `INSERT`, `UPDATE`, and `DELETE` must update it, so writes get a little slower. The rule is to index the columns your slow reads filter and join on, and no others. An index nobody's query uses is pure cost. Section 8.4 returns to this tradeoff.

### The Second Report: Indexing a Join Column

The dashboard's other slow spot is the notes timeline for one ticket. Foreign key columns are the classic place a missing index hurts, because joins and lookups hit them constantly:

```sql
CREATE INDEX ticket_notes_ticket_id_idx
  ON ticket_notes (ticket_id);
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF)
SELECT noted_at, note_text
FROM ticket_notes
WHERE ticket_id = 9001
ORDER BY noted_at;
-- Output:
-- CREATE INDEX
--                                         QUERY PLAN
-- -------------------------------------------------------------------------------------------
--  Sort (actual rows=2 loops=1)
--    Sort Key: noted_at
--    Sort Method: quicksort  Memory: 25kB
--    ->  Index Scan using ticket_notes_ticket_id_idx on ticket_notes (actual rows=2 loops=1)
--          Index Cond: (ticket_id = 9001)
```

The `Index Scan` reads two rows by their `ticket_id` and hands them to a small sort. Before the index, that inner step was a `Seq Scan` over 28,326 notes to find two. PostgreSQL created the index on the primary key of every table for you, but never on the foreign keys. This is a change you make by hand, on the columns your reports use.

### Rewriting the Query Instead of Indexing It

Sometimes the fix is the query, not the server. A filter wrapped in a function cannot use a plain index on the column, because the index stores the raw value and the query asks for a transformed one. You will meet that trap in this chapter's Fix It. The rewrite rule is short: keep the indexed column bare on one side of the comparison, and put the work on the other side. `WHERE opened_at >= '2026-01-01'` can use an index on `opened_at`. `WHERE date_trunc('month', opened_at) = '2026-01-01'` cannot.

### Maintenance: VACUUM and ANALYZE Keep the Plan Honest

PostgreSQL never overwrites a row in place. An `UPDATE` writes a new version and marks the old one dead, and a `DELETE` just marks it dead. Dead rows pile up and the table bloats, which slows every scan. **VACUUM** reclaims the space dead rows hold. **ANALYZE** refreshes the statistics the planner uses to choose a plan. Watch bloat appear and then get reclaimed:

```sql
SELECT pg_size_pretty(pg_relation_size('login_events')) AS before_update;
-- Rewrite every row: each UPDATE leaves its old version behind as dead space
UPDATE login_events SET success = success;
SELECT pg_size_pretty(pg_relation_size('login_events')) AS after_update;
VACUUM login_events;
SELECT pg_size_pretty(pg_relation_size('login_events')) AS after_vacuum;
VACUUM FULL login_events;
SELECT pg_size_pretty(pg_relation_size('login_events')) AS after_vacuum_full;
-- Output:
--  before_update
-- ---------------
--  1024 kB
--
-- UPDATE 12000
--  after_update
-- --------------
--  1456 kB
--
-- VACUUM
--  after_vacuum
-- --------------
--  1456 kB
--
-- VACUUM
--  after_vacuum_full
-- -------------------
--  728 kB
```

Read the four sizes. The update grew the table from 1024 kB to 1456 kB by leaving 12,000 dead rows behind. Plain `VACUUM` did not shrink the file, because it frees the dead space for the table to reuse, not to hand back to the operating system. `VACUUM FULL` rewrote the table compactly and returned the space, down to 728 kB. That difference is the trap. Plain `VACUUM` is safe and runs while the table is in use. `VACUUM FULL` locks the whole table against reads and writes while it rewrites, so it is a maintenance-window job, never a mid-day fix. Autovacuum runs plain `VACUUM` and `ANALYZE` for you in the background. You reach for the manual commands after a bulk load or a mass update, when you do not want to wait.

### Memory: When the Sort Spills to Disk

A sort or a hash that fits in memory is fast. One that does not spills to disk and crawls. The **work_mem** setting caps the memory one sort or hash may use before it spills. Watch the same sort spill and then stay in memory:

```sql
SET work_mem = '64kB';
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF)
SELECT ticket_id, note_text
FROM ticket_notes
ORDER BY note_text;
SET work_mem = '16MB';
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF)
SELECT ticket_id, note_text
FROM ticket_notes
ORDER BY note_text;
RESET work_mem;
-- Output:
-- SET
--                          QUERY PLAN
-- ------------------------------------------------------------
--  Sort (actual rows=28326 loops=1)
--    Sort Key: note_text
--    Sort Method: external merge  Disk: 1040kB
--    ->  Seq Scan on ticket_notes (actual rows=28326 loops=1)
--
-- SET
--                          QUERY PLAN
-- ------------------------------------------------------------
--  Sort (actual rows=28326 loops=1)
--    Sort Key: note_text
--    Sort Method: quicksort  Memory: 2040kB
--    ->  Seq Scan on ticket_notes (actual rows=28326 loops=1)
--
-- RESET
```

The first sort spilled to disk (`external merge  Disk: 1040kB`). The second, with more `work_mem`, stayed in memory (`quicksort  Memory: 2040kB`). Raising `work_mem` fixed this sort, but the setting is per-sort and per-connection, so a large value times hundreds of connections can exhaust the server's memory. Raise it for the one reporting session that needs it, not for the whole server by reflex. This is a change you verify by reading the `Sort Method` line, not by trusting the number you set.

### The Round Trip You Cannot Index

The last method is not on the server at all. An application that runs one query per row, in a loop, pays the network cost of a round trip every time. A hundred rows become a hundred trips. No index helps, because each query is already fast. The fix is to ask once: replace the loop with a single query that returns all hundred rows, or batch the inserts into one statement. When a report is slow and every query in it looks fast, count the queries. The number of round trips is often the real cost.

### Try It Yourself 8.2: Tune the Enrollment Lookup 🛠️

You are Copperwind's database administrator, and the academy's registration page runs one query per student to list the sections that student is enrolled in. It is slow on the first day of school. The script below measures the query, adds an index, and measures again. Three pieces are missing.

**Predict:** For each `____`, write down what belongs there and one phrase saying why. The first gap is the option that runs the query and reports actual rows without the varying timings. The second is the keyword that builds the sorted structure. The third is the column the `WHERE` clause filters on. Then predict the plan change: which scan appears before the index, and which after.

**Run:** Copy the script into a file, fill the gaps, and run it as `postgres` in `harquahala_academy`. Compare your plans with the expected output that follows. The full solution is in `docs/execution-logs/chapter-08-reference.sql` if you get stuck.

```text
\connect harquahala_academy
-- Step 1: Measure the lookup as it runs today, before any change
EXPLAIN (____)
SELECT e.section_id, s.term
FROM enrollments AS e
JOIN sections AS s ON s.section_id = e.section_id
WHERE e.student_id = 42;
-- Step 2: Index the column the page filters one student at a time
CREATE ____ enrollments_student_id_idx
  ON enrollments (____);
-- Step 3: Re-run the identical query and read the new plan
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF)
SELECT e.section_id, s.term
FROM enrollments AS e
JOIN sections AS s ON s.section_id = e.section_id
WHERE e.student_id = 42;
```

```text
                          QUERY PLAN
--------------------------------------------------------------
 Hash Join (actual rows=15 loops=1)
   Hash Cond: (e.section_id = s.section_id)
   ->  Seq Scan on enrollments e (actual rows=15 loops=1)
         Filter: (student_id = 42)
         Rows Removed by Filter: 5985
   ->  Hash (actual rows=120 loops=1)
         Buckets: 1024  Batches: 1  Memory Usage: 14kB
         ->  Seq Scan on sections s (actual rows=120 loops=1)

CREATE INDEX
                                         QUERY PLAN
---------------------------------------------------------------------------------------------
 Hash Join (actual rows=15 loops=1)
   Hash Cond: (e.section_id = s.section_id)
   ->  Index Scan using enrollments_student_id_idx on enrollments e (actual rows=15 loops=1)
         Index Cond: (student_id = 42)
   ->  Hash (actual rows=120 loops=1)
         Buckets: 1024  Batches: 1  Memory Usage: 14kB
         ->  Seq Scan on sections s (actual rows=120 loops=1)
```

**Explain:** The `enrollments` scan changed and the `sections` scan did not. In one or two sentences, explain why the 120-row `sections` table kept its `Seq Scan` even after you indexed `enrollments`, and what that tells you about indexing small tables.

### Fix It 8.1: The Index That the Query Ignored 🔧

The academy's front office looks up families by last name, and the registrar added an index on `students(last_name)` last week. The name search is still slow, and no error ever appears.

**Symptom:** The search box lowercases what the user types so that "young" and "Young" both match, so the application runs `WHERE lower(last_name) = 'young'`. With the index in place, that query still reads the whole table. Here is the plan for the case-sensitive query the index was built for, and then the plan for the query the application sends instead:

```text
CREATE INDEX students_last_name_idx ON students (last_name);

EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF)
SELECT student_id, first_name, last_name, grade_level
FROM students
WHERE last_name = 'Young';

                             QUERY PLAN
----------------------------------------------------------------------------
 Bitmap Heap Scan on students (actual rows=21 loops=1)
   Recheck Cond: (last_name = 'Young'::text)
   Heap Blocks: exact=4
   ->  Bitmap Index Scan on students_last_name_idx (actual rows=21 loops=1)
         Index Cond: (last_name = 'Young'::text)

EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF)
SELECT student_id, first_name, last_name, grade_level
FROM students
WHERE lower(last_name) = 'young';

                  QUERY PLAN
-----------------------------------------------
 Seq Scan on students (actual rows=21 loops=1)
   Filter: (lower(last_name) = 'young'::text)
   Rows Removed by Filter: 779
```

**Diagnose:** State the cause in one sentence before you change anything. The first query uses the index and the second one does not, even though both search by last name. The index stores `last_name` as stored. What value does the second query compare against, and why can the index not answer it?

**Repair:** Give the query an index it can use. An **expression index** stores the result of a function, so an index on `lower(last_name)` matches the query exactly. Build it, then run the same case-insensitive query and read the plan:

```sql
\connect harquahala_academy
CREATE INDEX students_last_name_idx ON students (last_name);
-- The repair: index the expression the query filters on
CREATE INDEX students_lower_last_name_idx ON students (lower(last_name));
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF)
SELECT student_id, first_name, last_name, grade_level
FROM students
WHERE lower(last_name) = 'young';
-- Output:
-- CREATE INDEX
-- CREATE INDEX
--                                     QUERY PLAN
-- ----------------------------------------------------------------------------------
--  Bitmap Heap Scan on students (actual rows=21 loops=1)
--    Recheck Cond: (lower(last_name) = 'young'::text)
--    Heap Blocks: exact=4
--    ->  Bitmap Index Scan on students_lower_last_name_idx (actual rows=21 loops=1)
--          Index Cond: (lower(last_name) = 'young'::text)
```

**Verify:** How do you know it is fixed? Name the plan line that proves the query now uses an index, and state which index it names. The plain `students(last_name)` index is still there, unused by this query. Decide whether the registrar should keep it, and say what evidence would settle that (recall the plan for the case-sensitive search above).

### Quick Check 8.2 ✅

1. A table gets one bulk `DELETE` of half its rows every night and a report over it grows slower each week. Name the command that reclaims the space and state which form of it you would schedule and why.
2. You raised `work_mem` and a report sped up. Explain the risk of setting the same value in `postgresql.conf` for every connection.
3. A query filters on `WHERE upper(email) = 'A@EXAMPLE.ORG'` and ignores the index on `email`. State the two fixes available and which one changes no application code.

---

## 8.3 Redundancy: Backups, WAL, and Replication

Tuning makes the server fast. Redundancy keeps the data alive when the server does not. A **backup** is a copy you can restore from. **Replication** is a live second server that can take over. They answer different failures, and a real plan uses both. Two numbers drive every choice. The **recovery point objective (RPO)** is how much recent data you can afford to lose, measured in time. The **recovery time objective (RTO)** is how long you can be down. A clinic that can lose at most five minutes of appointments has a five-minute RPO. A registration system that must be back within an hour has a one-hour RTO. The owner sets the numbers. You build to them.

### Logical Backups with pg_dump

**pg_dump** writes a single database to a file as the SQL needed to rebuild it, or as a compressed archive. It is the simplest backup and the easiest to move between servers and versions. Ethan Cole runs it nightly for the academy:

```bash
# Step 1: Dump one database to a compressed custom-format archive
pg_dump -U postgres -F c -f harquahala_2026-09-09.dump harquahala_academy

# Step 2: Confirm the archive is readable and list what it holds
pg_restore --list harquahala_2026-09-09.dump | head
```

A logical backup has two limits you must plan around. It captures the database at the moment the dump started, so anything written after that is not in it. That gap is your RPO for this method alone, up to a full day if you dump once a night. And restoring a large database from a dump is slow, because the server rebuilds every table and index from SQL. Chapter 9 hands you a shipped dump and times a real restore against a target, so you feel both limits with a clock running.

### The Write-Ahead Log

Chapter 2 introduced the **write-ahead log (WAL)**, PostgreSQL's record of every change, written to disk before the change reaches the table. Its first job is crash recovery: after a power loss, the server replays the WAL to reach a consistent state. Its second job is redundancy. If you keep a base backup and every WAL segment since, you can replay the log to any moment in between, which is **point-in-time recovery**. That shrinks the RPO from a full day to seconds, because the WAL holds every change the nightly dump missed. Archiving WAL is a configuration change, and like every configuration change it gets a verifying query. Check the settings this server ships with:

```sql
SELECT name, setting
FROM pg_settings
WHERE name IN ('wal_level', 'archive_mode', 'max_wal_senders')
ORDER BY name;
-- Output:
--       name       | setting
-- -----------------+---------
--  archive_mode    | off
--  max_wal_senders | 10
--  wal_level       | replica
```

`wal_level` is `replica`, which is enough to feed a standby server, and `max_wal_senders` allows ten replication connections. `archive_mode` is `off`, so this server keeps WAL only long enough for crash recovery, not for point-in-time recovery. Turning archiving on means setting `archive_mode = on` and an `archive_command` that copies each finished WAL segment somewhere safe, then a restart. On a server you manage you would make that change, then confirm `archive_mode` reads `on` and watch the archive directory fill.

### Streaming Replication and High Availability

**Streaming replication** connects a second server, the **standby**, to the first, the **primary**. The primary streams its WAL to the standby as it is written, and the standby replays it continuously, so it stays seconds behind and ready. This is the difference between a backup and **high availability**: a backup you restore after an outage, a standby takes over during one. A standby also serves read-only queries, so the academy could send its heavy month-end reports to the standby and leave the primary for the front office.

**Failover** is promoting the standby to primary when the primary fails. Do it by hand and the RTO is however long it takes a person to notice and act. Automate it with a tool that watches both servers and promotes on failure, and the RTO drops to seconds. The cost is the tool itself and the care to avoid promoting two primaries at once. On premise you run both servers and the failover tool yourself. In the cloud, a managed database service offers replication and automatic failover as a checkbox with a monthly charge. Either way the decision the provider cannot make for you is the RPO and RTO, because only the owner knows what an hour of downtime costs the school.

### The Backup Plan, on One Page

A plan nobody wrote down is a hope. The **backup plan** names, for each database, how it is protected and to what target. Copperwind keeps one row per database:

| Database | RPO | RTO | Backup method | Replication | Owner sign-off |
| --- | --- | --- | --- | --- | --- |
| `harquahala_academy` | 5 min | 1 hour | Nightly `pg_dump` plus WAL archive | Warm standby | Principal Whitfield |
| `sandwash_clinic` | 5 min | 1 hour | Nightly `pg_dump` plus WAL archive | Warm standby | Dr. Vasquez |
| `copperwind_ops` | 1 hour | 4 hours | Nightly `pg_dump` | None | Mei Lin |

Read the last column. Every row ends at a person who signs the numbers, because the RPO and RTO are business decisions, not technical ones. The academy and the clinic get a standby because their downtime stops a school day or a clinic morning. Copperwind's own operations database can wait, so it saves the cost of a second server. A blank template for this table ships as `redundancy-plan-template.md` in this chapter's folder, and Skills Lab 8A asks you to fill it.

### Try It Yourself 8.3: Set the Targets for a Food Bank 🛠️

**Predict:** A regional food bank runs one database for scheduled deliveries and donor records. Delivery routes are planned each morning and must survive a crash with almost no loss. Donor history is updated weekly. Before writing anything, predict whether the two kinds of data should share one RPO, and which one justifies the tighter number.

**Run:** Fill one row of the backup-plan table for this food bank, choosing an RPO, an RTO, a backup method, and whether to add a standby. Write one sentence per choice naming the cost it accepts or avoids.

**Explain:** In one or two sentences, explain why a nightly `pg_dump` alone cannot meet a five-minute RPO, and what you would add to close the gap.

### Quick Check 8.3 ✅

1. Define RPO and RTO in one sentence each, and state which one a WAL archive improves.
2. A manager asks why the clinic needs a standby when it already has a nightly backup. Explain the difference between restoring a backup and failing over to a standby, in terms of RTO.
3. `archive_mode` reads `off` on a server. State what kind of recovery that server cannot do until it is changed, and the query that confirms the change later.

---

## 8.4 Tradeoffs: Cost, Benefit, and Exposure

Every choice in this chapter spends something to gain something. An index spends disk and write speed to buy read speed. A standby spends a second server to buy availability. WAL archiving spends storage to buy a smaller RPO. The Evaluate skill this section teaches is weighing those costs against the benefit for one budget, and against the security exposure each copy creates.

### Redundancy Versus Tuning for the Same Dollar

Give Copperwind one fixed budget and it cannot buy everything. Faster storage speeds up every query and every backup, but it does nothing when the disk fails. A second server survives a failure but speeds up nothing on a normal day, unless you route reports to it. More memory helps the sorts that spill and no others. The right spend depends on which pain the owner feels. A school that is fast but loses a day of registration to a dead disk needed the standby. A clinic that never fails but takes nine seconds per chart needed the index and the memory. Measurement, again, is what turns this from opinion into a case: the plan that shows a spill argues for memory, the outage log argues for the standby.

### The Exposure Every Copy Creates

Each copy you make for availability is another copy an attacker can steal. This is where redundancy meets the security work of the earlier chapters. Three exposures deserve a line in the plan:

* **Backup files hold the whole database in one portable file.** A dump of the clinic is every patient record on one drive. Chapter 6 encrypted the sensitive columns, and that protection travels into the dump only if the columns were encrypted at rest, not decrypted into it. Encrypt the backup file itself, store it with the same access control as the database, and never leave it on a shared drive. Chapter 1 named the unencrypted backup on a shared drive as a confidentiality threat. This is the chapter that creates the backup.
* **A standby is a full, live copy of the data.** Every control on the primary must exist on the standby. A role that cannot read a table on the primary can read the whole file if the standby is left open. Replication traffic crosses the network, so it needs the same TLS protection Chapter 6 put on client connections.
* **A backup kept forever is a breach kept forever.** Chapter 4's retention schedule governs backups too. A dump of records you were required to destroy is a copy of data you no longer have a right to hold. The retention policy names how long backups live and how they are destroyed.

The pattern is the one from Chapter 1: naming the exposure points to the control, and the control lives in a chapter you have already read. Redundancy does not get a security exception. It multiplies the thing you were protecting, so it multiplies the protection you owe it.

### Try It Yourself 8.4: Weigh Two Proposals 🛠️

**Predict:** A law office's database is fast but has only a nightly backup on the same server as the database. The vendor offers two upgrades for the same price: a second server as a standby, or a faster disk. Before reading on, predict which one survives the failure the current setup is most exposed to.

**Run:** On paper, list the failure each upgrade protects against and the failure it does nothing for. Then state which you would recommend and the one measurement you would take first to defend the choice.

**Explain:** In one or two sentences, explain why "the backup is on the same server" is the exposure that decides this, and what a second copy on that same server still cannot survive.

### Try It Yourself 8.5: Read the Exposure of a Restore Copy 🛠️

**Predict:** To test a restore, a technician loads last night's clinic dump onto a spare laptop with no disk encryption and no roles configured. Before reading on, predict which CIA property this practice threatens and which regulation from Chapter 4 it puts at risk.

**Run:** On paper, name three controls from earlier chapters the spare laptop is missing that the primary server has. For each, name the chapter it came from.

**Explain:** In one or two sentences, explain why a restore test is a real security event and not a private chore. Then name one rule you would add to the backup plan to keep test copies safe.

### Quick Check 8.4 ✅

1. Given one budget, state the failure a standby protects against that a faster disk does not, and the daily benefit a faster disk gives that a standby does not.
2. A dump of the clinic sits unencrypted on a technician's laptop. Name the CIA property at risk and the two earlier-chapter controls that should have traveled with the copy.
3. Explain why a backup you keep past its retention date is a liability, not just wasted disk.

---

## 8.5 Summary and Retrieval 💡

### Key Concepts

* Measure before you tune. The execution plan from `EXPLAIN` and `EXPLAIN ANALYZE` names the slow step, and the ratio of rows read to rows returned is the number tuning tries to shrink. A baseline plan and timing, saved before a change, is what makes the change provable. `pg_stat_statements` finds the slow query, and the plan explains it.
* Indexes turn a sequential scan into a lookup, at the cost of disk and slower writes. Index the columns your slow reads filter and join on, especially foreign keys, and no others. A filter wrapped in a function needs an expression index or a rewritten query, because a plain index cannot answer a transformed value.
* `VACUUM` reclaims the space dead rows hold and `ANALYZE` refreshes the planner's statistics. Plain `VACUUM` runs while the table is in use. `VACUUM FULL` locks it and returns space to the operating system, so it is a maintenance-window job. `work_mem` keeps a sort in memory instead of spilling to disk, but it is per-sort, so raise it narrowly.
* Redundancy keeps data alive when the server fails. RPO is how much data you can lose, RTO is how long you can be down, and the owner sets both. `pg_dump` makes a portable logical backup, WAL archiving enables point-in-time recovery, and streaming replication keeps a standby ready for failover. You restore a backup after an outage. A standby takes over during one.
* Every copy spends something and exposes something. Weigh tuning against redundancy for one budget by the pain the owner feels. A backup file, a standby, and a kept-too-long dump each multiply the data, so each inherits the encryption, access control, and retention rules from earlier chapters.

### Key Terms

See course glossary for full definitions

* execution plan, sequential scan, index scan, pg_stat_statements (Section 8.1)
* index, expression index, VACUUM, ANALYZE, work_mem (Section 8.2)
* backup, replication, recovery point objective (RPO), recovery time objective (RTO), point-in-time recovery, streaming replication, standby, failover, high availability (Section 8.3)

### Retrieval Practice

1. From memory, name the two `EXPLAIN` variants and state which one runs the query, then name the plan line that tells you a scan read far more rows than it returned.
2. State the rule for when a query needs an expression index instead of a plain one, and give one example of a filter that triggers it.
3. Explain the difference between what plain `VACUUM` reclaims and what `VACUUM FULL` reclaims, and why only one of them locks the table.
4. From Chapter 6: A nightly `pg_dump` of the clinic is copied to offsite storage. Name the encryption control that must already be in place so the dump does not expose insurance numbers, and say whether encrypting a column at rest is enough on its own.
5. From Chapter 4: A backup of student records is two years past the retention date. State the rule that governs how long a backup may live and why an over-kept backup is a compliance problem, not just wasted disk.

---

## 8.6 Skills Lab 8A: Tune and Protect Copperwind Tickets

**Goal:** Baseline three slow reports on Copperwind's operations database and fix them with indexes and query changes. Measure the gain with execution plans, then design the backup and replication plan that meets Mei Lin's stated availability target.

**Dataset or starter files:** `assets/code/chapter-08/` in the course data pack. `setup-copperwind.sql` rebuilds `copperwind_ops` with its clients, technicians, tickets, notes, and login events. `setup-harquahala.sql` rebuilds `harquahala_academy` for the spine exercise and the Fix It. `skills-lab-8a.sql` is the starter script with numbered markers. `skills-lab-8a-answers.md` holds the backup plan and the two Questions & Analysis answers. `redundancy-plan-template.md` is the blank plan table. The setup scripts load the CSVs in `assets/code/data/`. Copperwind and every record in it are fictional.

Mei Lin's target for `copperwind_ops`: the operations database can lose up to one hour of data and be down up to four hours. The clinic and the academy she hosts have tighter numbers, and Part 3 asks you to compare.

### Part 1: Foundation (Aligns with Objective 8.1)

1. From the extracted `cis376` folder, run `setup-copperwind.sql` as `postgres`. Under marker 1.1, capture the plan of three reports before any change: open tickets for one client, the notes timeline for one ticket, and tickets opened in a given month. Use `EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF)` and paste each plan. From plain `EXPLAIN ANALYZE`, record each execution time in your answer file as the baseline.
2. Under marker 1.2, for each report name the plan line that shows the slow step and the ratio of rows read to rows returned. Write one sentence per report naming what the plan blames.
3. In the answer file, state which one report you expect to improve most from an index and why, before you add any index.

### Part 2: Application (Aligns with Objectives 8.1 and 8.2)

1. Under marker 2.1, add the index each report needs. For the first two reports a plain index on the filtered or joined column is enough. For the monthly report, decide between an index on `opened_at` with a rewritten range filter and an expression index, and defend the choice in one sentence.
2. Under marker 2.2, re-run the identical `EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF)` for all three reports and paste the new plans. In the answer file, put the before and after plan shapes side by side and record the execution-time change from plain `EXPLAIN ANALYZE`.
3. Under marker 2.3, run one report that sorts a large result, first with `work_mem` set low and then set high, and paste both `Sort Method` lines. State the setting value that kept the sort in memory and why you would not set it server-wide.

### Part 3: Extension (Aligns with Objectives 8.2 and 8.3)

1. Fill `redundancy-plan-template.md` for all three databases you manage: `copperwind_ops` at Mei Lin's stated target, and `sandwash_clinic` and `harquahala_academy` at the tighter numbers a regulated client needs. For each database choose a backup method, whether to add a standby, and name the owner who signs the numbers.
2. Under marker 3.1, run the three `pg_settings` queries that report `wal_level`, `archive_mode`, and `max_wal_senders`, and paste the results. In the answer file, state which setting must change before the server can do point-in-time recovery, and the query that would confirm the change.
3. In the answer file, write the security section of the plan. For the backup file and for the standby, name the encryption, access-control, and retention controls from earlier chapters that must travel with each copy, and name the chapter each control came from.

### Questions & Analysis 🤔

1. Using your Part 2 before-and-after plans as evidence, explain which report gained the most from tuning and why the row-read ratio, not the execution time alone, is the honest measure of the gain. Name one report where an index would have been the wrong fix and say what you would do instead.
2. Copperwind has one budget this quarter: a faster disk for the operations server, or a standby for the academy. Using your Part 3 plan and Mei Lin's targets, recommend one, defend it with the availability numbers, and state the one measurement or log you would bring to the owner to support the case.

**Submission:** Submit one folder named `skills-lab-8a-lastname`. It holds `skills-lab-8a.sql` with every plan pasted as `-- Output:` comment lines (or the saved psql output beside it). It also holds `skills-lab-8a-answers.md` with the baseline table, the before-and-after plans, the completed redundancy plan, and your two Questions & Analysis answers clearly labeled.

### Rubric: Skills Lab 8A

This lab is graded with the standard
[Skills Lab Rubric](../skills-lab-rubric.md): four criteria, five
levels from Mastery to Not Evident. The criteria are Technical
Accuracy and Efficiency, Output Quality, Documentation Quality, and
Analysis, Interpretation, and Response to QUESTION(s). The criteria
and levels are the same everywhere. Your instructor sets the point
values in your course. Check the syllabus and the Canvas rubric
attached to this lab for the values that apply to you.

---

## 8.7 Review Questions 🔄️

1. **Apply:** A bike shop's sales report filters `WHERE sale_date >= '2026-01-01'` on a table with no index on `sale_date`, and the plan shows a sequential scan. Write the index you would add and the one-line `EXPLAIN` option you would run before and after to prove it helped, and name the plan line you would read to confirm the change.

2. **Analyze:** A city parks department reports that a reservations query got slower over six months while returning the same number of rows. The table takes a large nightly `DELETE` of expired holds. Explain the two most likely causes, name the measurement that distinguishes them, and match each cause to the command that fixes it.

3. **Evaluate:** A credit union can spend its quarterly budget on either WAL archiving with point-in-time recovery or a second server as a standby, not both. Judge the two options against a stated RPO of five minutes and an RTO of thirty minutes, and state which target each option serves and the one you would fund first.

4. **Create:** Design the redundancy plan for a nonprofit food bank's single database, which loses at most fifteen minutes of data and must be back within two hours. Name the backup method, the replication choice, the RPO and RTO you commit to, and the two security controls the backup file inherits from earlier chapters.

---

## Further Reading 📖

* [PostgreSQL Documentation: Using EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html) - How to read every node in a plan, the meaning of each cost and actual-rows number, and the options this chapter used.
* [PostgreSQL Documentation: Indexes](https://www.postgresql.org/docs/17/indexes.html) - Index types, indexes on expressions, and the rules for when the planner will and will not use one.
* [PostgreSQL Documentation: Routine Vacuuming](https://www.postgresql.org/docs/17/routine-vacuuming.html) - Why dead rows accumulate, what autovacuum does, and when to run `VACUUM` and `ANALYZE` by hand.
* [PostgreSQL Documentation: Continuous Archiving and Point-in-Time Recovery](https://www.postgresql.org/docs/17/continuous-archiving.html) - The base backup, WAL archiving, and the restore that turns them into point-in-time recovery.
* [PostgreSQL Documentation: High Availability, Load Balancing, and Replication](https://www.postgresql.org/docs/17/high-availability.html) - Streaming replication, standby servers, and the failover choices behind an availability target.
* [NIST SP 800-34 Rev. 1](https://csrc.nist.gov/pubs/sp/800/34/r1/final) - Contingency planning for information systems, the framework behind recovery point and recovery time objectives.

---

## Looking Ahead ⏩

You can now make a query fast and keep a copy of the data ready. Chapter 9 asks the question a backup only implies: when the server is gone, can you bring it back, and how long does it take? You will take the `pg_dump` this chapter created, restore it against a target on a clean server, and time the drill against the RPO and RTO you set here. Then you will rank the vulnerabilities that put the data at risk in the first place. A backup you have never restored is a guess, and Chapter 9 is where you stop guessing.
