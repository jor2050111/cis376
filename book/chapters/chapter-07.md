# Chapter 7: Auditing and Log Management

At 2:11 on a Thursday morning, something started guessing the `postgres` password on Copperwind's server. It tried every five seconds for five minutes and then stopped. At 3:42 that afternoon, a technician who does not manage roles made a reporting account a superuser. Nobody noticed either event that day. Both sit in the server log, and the log is where you will find them in Section 7.4. The question this chapter asks is not whether those events happened. It is whether anyone was watching, and whether the record will still exist when someone finally looks.

In your SQL course, the database answered your queries and forgot them. That is fine for a class and dangerous for a clinic. Chapter 5 built roles and proved, from the catalog, that each one holds the privileges the data owner approved. That proof describes what a role *may* do. It says nothing about what the role *did*. Auditing closes that gap. It records who connected, what they ran, and which rows changed, so that a review can compare the record against the policy.

This chapter opens Part III, where you watch the server, keep it fast, and keep it recoverable. You will write an auditing plan that names the events worth capturing and how long to keep them. You will configure PostgreSQL's own log and add a trigger-based trail that records who changed what and when. Then you will read one day of a shipped server log and sort every event into routine, suspicious, or violation. Mei Lin wants the plan. Naomi Redhouse wants the review. Chapters 10 and 11 will want the evidence.

## Module Overview 🧭

* **Estimated time:** 5-6 hours
* **Prerequisites:** One prior SQL course (Introduction to Oracle: SQL, CIS276DA MySQL Database, or CIS276DB SQL Server Database). Chapter 1 (the lab environment and the three course databases). Chapter 5 supplies the role vocabulary, and Chapter 4 supplies the retention vocabulary. One sentence recalls each where needed.
* **Deliverables:** Skills Lab 7A folder (`skills-lab-7a.sql` and `skills-lab-7a-answers.md`), Quick Checks

## Learning Objectives 🎯

By the end of this chapter, you will be able to:

* **7.1 (Create):** Construct an auditing plan that names the database events to capture, where each is logged, and how long the logs are kept (Section 7.1)
* **7.2 (Apply):** Configure server logging and trigger-based audit trails that record who changed what and when (Sections 7.2-7.3)
* **7.3 (Analyze):** Interpret audit logs to classify events as routine, suspicious, or policy violations (Section 7.4)

### This chapter aligns with the following Course Learning Outcomes

* **CLO II (Evaluate):** Assess security management for database environments.
* **CLO III (Create):** Develop strategies to maintain optimal system performance, security and availability.
* **CLO IV (Evaluate):** Evaluate practices for database environment incident responses.

---

## 7.1 What to Audit and Why

Logging everything is the beginner's plan, and it fails twice. The disk fills, and the reviewer drowns. An **auditing plan** is the written decision about which database events matter, where each one is recorded, who reads the record, and how long it is kept. It is the data owner's decision as much as yours. Dr. Vasquez decides that a viewed chart matters. You decide how to capture it. The plan is the document Naomi Redhouse reads before she reads a single log line, because it tells her what a normal day should look like.

### The Events Worth Capturing

An **audit event** is one action on the database that the plan says to record. Five categories cover nearly every review you will run. Each one answers a question a reviewer will ask:

| Category | Example | The question it answers |
| --- | --- | --- |
| Logins | A connection authorized for `mlin` at 06:04 | Who was on the server, and when? |
| Failed logins | Sixty password failures for `postgres` in five minutes | Is someone guessing? |
| DDL | `CREATE TABLE`, `DROP TABLE`, `ALTER TABLE` | Did the schema change, and who changed it? |
| Privileged DML | A `DELETE` on `visit_notes`, an `UPDATE` to a grade | Who changed protected rows? |
| Role changes | `ALTER ROLE ... SUPERUSER`, `GRANT`, `CREATE ROLE` | Did anyone's power change? |

The first three categories come from the server itself. PostgreSQL can write a line for every connection and every statement it runs, and Section 7.2 turns that on. The last two need more than the server offers. A statement log records that an `UPDATE` ran. It does not record which row changed or what the old value was. Section 7.3 builds a trigger-based trail for that. A role change is a statement, so the server log catches it, but the catalog is the second witness: `pg_roles` shows the result after the fact.

Regulation names the categories too. HIPAA's technical safeguards require **audit controls**, mechanisms that record and examine activity in systems that hold electronic protected health information (45 CFR 164.312(b)). Its administrative safeguards require a regular review of that activity (45 CFR 164.308(a)(1)(ii)(D)). FERPA requires a school to keep a record of each request for access to a student's education records and each disclosure (34 CFR 99.32). Neither regulation says "turn on `log_statement`." Both say you must be able to show who touched the data. The plan is how you show it.

### Where Each Event Is Recorded

The plan names a source for every category, because a reviewer who cannot find the record has nothing to review. Copperwind uses three sources. The **server log** is the text file PostgreSQL writes as it runs. It holds logins, failed logins, and whichever statements the configuration says to keep. An **audit trail** is a table inside the database that a trigger fills with the before-and-after of each protected change. The system catalog is the third source. It does not record events, but it shows the current state, so a reviewer can confirm that a logged `GRANT` took effect.

Copperwind's own `login_events` table is a fourth source you already loaded. It holds every login attempt the ticket system recorded on Copperwind's server for two months, with the address each attempt came from. You have written `GROUP BY` before. Here it sizes the problem the plan must handle:

```sql
\connect copperwind_ops
SELECT success,
       COUNT(*) AS attempts,
       COUNT(DISTINCT username) AS usernames
FROM login_events
GROUP BY success
ORDER BY success;
-- Output:
--  success | attempts | usernames
-- ---------+----------+-----------
--  f       |      557 |        14
--  t       |    11443 |        11
```

Two months of activity produced a few hundred failures against more than eleven thousand successes. The failures used more distinct usernames than the successes did. That second number is the reviewer's first clue: accounts that fail and never succeed are accounts that do not exist. Section 7.4 follows that clue to one address.

### How Long to Keep It

Chapter 4 built a retention schedule for the clinic's records. Logs need a row in the same schedule. Two forces set the number. Regulation sets the floor: HIPAA requires the documentation of your security program, which includes review records, to be kept for six years (45 CFR 164.316(b)(2)(i)). Disk sets the ceiling: a server that logs every statement can write gigabytes a day. Copperwind resolves the two by keeping different sources for different lengths:

| Source | Events | Kept online | Archived off the server | Reviewer |
| --- | --- | --- | --- | --- |
| Server log | Logins, failed logins, DDL | 30 days | 1 year, compressed | You, weekly |
| Audit trail tables | Privileged DML on `tickets`, `visit_notes`, `grades` | Life of the row plus 6 years | With the database backup | Data owner, quarterly |
| Review records | Findings and sign-offs | 6 years | With policy documents | Naomi Redhouse |

Two design choices in that table repay attention. The server log is short-lived online because the server's disk is precious, and Section 7.2 shows how rotation keeps it short. The audit trail lives as long as the data it describes, because a review of a 2024 grade change needs the 2024 trail. The archive copy leaves the server, because a log that lives only on the server it protects disappears with that server. Section 7.4 shows what an attacker with the superuser password could do to it.

### Try It Yourself 7.1: Plan the Law Office's Audit 🛠️

**Predict:** A law office runs a case management database with three paralegals, two attorneys, and a billing application. The office manager asks you to "log everything, forever." Before you write anything, predict which of the five event categories will produce the most lines per day on that server and which will produce the fewest. Then predict which one the managing attorney will ask about first after a client complains.

**Run:** Build the office's auditing plan as a five-row table with the columns Event category, Example event, Where it is recorded, Kept online, Archived, and Reviewer. Fill every row from the two tables in this section. Then write one sentence for the office manager explaining why "everything, forever" is not a plan.

**Explain:** In one or two sentences, explain why privileged DML on case notes cannot be captured by the server log alone, and name the source the plan uses instead.

### Quick Check 7.1 ✅

1. A clinic asks you to prove that nobody changed a diagnosis code last quarter. Name the source in the auditing plan that answers the question, and state why the server log by itself cannot.
2. The server log at the academy is kept for seven days and then deleted. Name the regulation and the specific record that this retention period would fail to support, and state the two forces the plan must balance when it picks a new number.

---

## 7.2 Server Logging

PostgreSQL logs by default, but only a little. A fresh server writes startup messages, errors, and failed connections. It writes nothing about the connections that succeed or the statements that run. The plan in Section 7.1 asks for logins and DDL, so this section turns them on and makes the lines readable. Every logging decision is a **configuration parameter**, a named setting the server reads from `postgresql.conf`, and the `pg_settings` catalog view tells you the current value of each one and how to change it.

### What the Server Logs Today

Start where Chapter 1 started, with a baseline. Read the logging settings that matter, and read the `context` column with care. It says what it takes for a change to be noticed:

```sql
SELECT name, setting, context
FROM pg_settings
WHERE name IN ('logging_collector', 'log_destination', 'log_directory',
               'log_filename', 'log_rotation_age', 'log_rotation_size',
               'log_line_prefix', 'log_connections', 'log_statement')
ORDER BY name;
-- Output:
--        name        |            setting             |      context
-- -------------------+--------------------------------+-------------------
--  log_connections   | off                            | superuser-backend
--  log_destination   | stderr                         | sighup
--  log_directory     | log                            | sighup
--  log_filename      | postgresql-%Y-%m-%d_%H%M%S.log | sighup
--  log_line_prefix   | %m [%p]                        | sighup
--  log_rotation_age  | 1440                           | sighup
--  log_rotation_size | 10240                          | sighup
--  log_statement     | none                           | superuser
--  logging_collector | off                            | postmaster
```

Your values will differ from these in one place. The output above came from a development server started by hand. Its **logging collector**, the background process that captures the server's output and writes it to files, is off, so the log goes to the terminal. The Windows installer turns the collector on and points it at a `log` folder inside the data directory. Everything else is the shipped default, and the defaults are the problem. `log_connections` is off, so successful logins leave no trace. `log_statement` is `none`, so a `DROP TABLE` leaves no trace. The prefix `%m [%p] ` stamps each line with a time and a process number and nothing else, so a line that says `statement: DROP TABLE tickets` does not say who ran it.

The `context` column decides how you fix that. A `sighup` setting takes effect when the server rereads its configuration. A `postmaster` setting needs a restart. A `superuser` setting can be changed by a superuser for one session, or for one database or role. A `superuser-backend` setting is fixed when a connection starts, so the only way to change it is in the configuration file. Read the column before you plan a change. The plan for `log_line_prefix` (reload) is not the plan for `logging_collector` (restart, at a time the clinic agrees to).

### The Four Settings the Plan Needs

Open `postgresql.conf` in the data directory and add four lines. They are the whole change:

* `log_connections = on`
* `log_statement = 'ddl'`
* `log_line_prefix = '%m [%p] %u@%d %h '`
* `logging_collector = on`

`log_connections = on` writes a line for every authorized connection. Failed connections were already logged. `log_statement = 'ddl'` writes every `CREATE`, `ALTER`, and `DROP`. The other values are `none`, `mod` (DDL plus every `INSERT`, `UPDATE`, and `DELETE`), and `all`. The plan chose `ddl` for the whole server because `mod` on a ticket system would log thousands of lines an hour, and Section 7.3 captures the changes that matter with less noise.

The **log line prefix** is the format of the stamp at the front of each line. `%m` is the time with milliseconds, `%p` the process, `%u` the role, `%d` the database, and `%h` the client's address. The default omits the last three. Without `%u` a statement has no author. Without `%h` a failed login has no source. The shipped log you will read in Section 7.4 carries `%u@%d` and not `%h`, and you will feel that gap when you try to name the attacker.

A **configuration reload** tells the running server to reread its files without stopping. Ask for it from psql with `SELECT pg_reload_conf();`, which answers `t` when the signal went out. Then open a new session and check with `SHOW log_connections`. A `superuser-backend` setting is read at connection time, so the session that asked for the reload still answers `off`, and the fresh session answers `on`. `logging_collector` is the one setting in the list that a reload cannot apply. Its context is `postmaster`, and the server tells you so: after the reload, `pg_settings.pending_restart` is true for it until the next restart. Schedule that restart with the client. The other three take effect at once, and the log proves it. Here is the server's own log from the moment of the reload through the first statements afterward, trimmed to the lines that matter:

```text
2026-09-09 21:20:34.171 MST [17844] LOG:  received SIGHUP, reloading configuration files
2026-09-09 21:20:34.171 MST [17844] LOG:  parameter "log_connections" changed to "on"
2026-09-09 21:20:34.171 MST [17844] LOG:  parameter "log_statement" changed to "ddl"
2026-09-09 21:20:34.171 MST [17844] @  LOG:  parameter "log_line_prefix" changed to "%m [%p] %u@%d %h "
2026-09-09 21:20:34.210 MST [17985] [unknown]@[unknown] 127.0.0.1 LOG:  connection received: host=127.0.0.1 port=60667
2026-09-09 21:20:34.210 MST [17985] postgres@postgres 127.0.0.1 LOG:  connection authorized: user=postgres database=postgres application_name=psql
2026-09-09 21:20:34.210 MST [17985] postgres@postgres 127.0.0.1 LOG:  statement: CREATE TABLE audit_demo (demo_id integer);
2026-09-09 21:20:34.224 MST [17987] copperwind_ghost@postgres 127.0.0.1 FATAL:  role "copperwind_ghost" does not exist
```

Read the fourth line. The prefix changed in the middle of the reload, so the server's own line carries a half-filled prefix. Every line after it names a role, a database, and an address. The `CREATE TABLE` appears because it is DDL. A `SELECT COUNT(*)` that ran in the same session does not appear, because `ddl` does not log reads. The last line is a login attempt with a role that does not exist, which is the second most common shape of a probe. The most common is a real role with a wrong password, and Section 7.4 has sixty of those.

### Scope: Server, Database, Role, Session

The configuration file sets a value for the whole server. Three narrower scopes override it, and the narrowest wins. `ALTER DATABASE ... SET` applies to new sessions in one database. `ALTER ROLE ... SET` applies to new sessions of one role. `SET` changes the current session only. The narrow scopes let you log the clinic harder than the ticket system without logging the ticket system at all. The change lands in `pg_db_role_setting`, and a fresh session is the proof. The block ends with the habit that follows every edit to `postgresql.conf` or `pg_hba.conf`. Run `pg_reload_conf()`, which Chapter 2 used for the connection rules, then read `pending_restart` to learn whether the reload was enough:

```sql
-- Step 1: Log one database harder than the server default
ALTER DATABASE copperwind_ops SET log_statement = 'ddl';
-- Step 2: A new session is the only honest test of a new-session setting
\connect copperwind_ops
SHOW log_statement;
-- Step 3: The catalog shows the override to the next reviewer
SELECT d.datname AS database_name,
       s.setconfig AS settings
FROM pg_db_role_setting AS s
JOIN pg_database AS d ON d.oid = s.setdatabase;
-- Step 4: Reload, then ask which settings still wait for a restart
SELECT pg_reload_conf();
SELECT name, setting, context, pending_restart
FROM pg_settings
WHERE name IN ('logging_collector', 'log_line_prefix', 'log_statement', 'log_connections')
ORDER BY name;
-- Output:
-- ALTER DATABASE
--  log_statement
-- ---------------
--  ddl
--
--  database_name  |      settings
-- ----------------+---------------------
--  copperwind_ops | {log_statement=ddl}
--
--  pg_reload_conf
-- ----------------
--  t
--
--        name        | setting  |      context      | pending_restart
-- -------------------+----------+-------------------+-----------------
--  log_connections   | off      | superuser-backend | f
--  log_line_prefix   | %m [%p]  | sighup            | f
--  log_statement     | ddl      | superuser         | f
--  logging_collector | off      | postmaster        | f
```

The `\connect` matters. The `ALTER DATABASE` changed what future sessions get, not the session that ran it. Reconnect, then `SHOW`. Configuration without verification is a guess, and here the verification needs a new connection to be honest. Note two limits before you lean on this scope. `log_connections` cannot be set this way, because its context is `superuser-backend`, and the server refuses the `ALTER` with `cannot be set after connection start`. And a per-database setting survives every rerun of a setup script, because the scripts rebuild tables, not databases. Record it in your command log so the next reviewer knows it is there. Nothing is pending in the last result because nothing in the file changed on this server. After your own edit, expect `logging_collector` to show `t` until the restart.

!!! warning "Statement logging captures passwords"
    Chapter 5 warned that `CREATE ROLE ... PASSWORD 'text'` is a statement, and statements get logged. With `log_statement = 'ddl'` or `'all'`, that password sits in the log in the clear, and the log is kept for a year. Use `\password` in psql, which sends only the hash, whenever the server logs DDL. The setup scripts in this book put passwords in statements so they can run unattended. Your production scripts should not.

### Destinations and Rotation

`log_destination` says what form the log takes. `stderr` is plain text and is what this chapter reads. `csvlog` and `jsonlog` write the same events as structured rows that load into a table without parsing, at the cost of larger files. When the collector is on, `log_directory` and `log_filename` say where the files land. The default pattern `postgresql-%Y-%m-%d_%H%M%S.log` starts a new file at each rotation and names it for the moment it started.

**Log rotation** is the switch to a new file. `log_rotation_age` rotates after a number of minutes (the default 1440 is one day) and `log_rotation_size` after a number of kilobytes (the default 10240 is 10 MB), whichever comes first. Rotation never deletes. A server with a one-day rotation and a year of uptime holds 365 files, and the plan's "30 days online" line is a job you schedule, not a setting you flip. The one exception is a cyclic filename such as `postgresql-%a.log` (one file per weekday) with `log_truncate_on_rotation = on`, which overwrites each file weekly and keeps seven days by design.

### Try It Yourself 7.2: Log One Account Harder 🛠️

**Predict:** Naomi Redhouse wants every statement the `copperwind_reports` service account runs, and nothing extra from anyone else, for the next two weeks. Before you run anything, predict which scope from this section does that with one statement, and predict what `pg_db_role_setting` will show afterward: how many rows, and what each row's `setconfig` column holds.

**Run:** Create the account, attach the setting to it, and read the catalog. The `COALESCE` calls turn an empty role or database column into a label, so a setting that applies to every role or every database reads as such:

```sql
CREATE ROLE copperwind_reports LOGIN
  PASSWORD 'Copperwind-Ch7-Reports-2026!';
ALTER ROLE copperwind_reports SET log_statement = 'all';
SELECT COALESCE(r.rolname, '(every role)') AS role_name,
       COALESCE(d.datname, '(every database)') AS database_name,
       s.setconfig AS settings
FROM pg_db_role_setting AS s
LEFT JOIN pg_roles AS r ON r.oid = s.setrole
LEFT JOIN pg_database AS d ON d.oid = s.setdatabase
ORDER BY role_name, database_name;
-- Output:
-- CREATE ROLE
-- ALTER ROLE
--      role_name      |  database_name   |      settings
-- --------------------+------------------+---------------------
--  (every role)       | copperwind_ops   | {log_statement=ddl}
--  copperwind_reports | (every database) | {log_statement=all}
```

**Explain:** In one or two sentences, explain why the reporting account's `all` wins over the database's `ddl` when the account connects to `copperwind_ops`. Then say what you would have to change so the setting expires in two weeks without anyone remembering to remove it.

### Quick Check 7.2 ✅

1. A colleague edits `postgresql.conf`, runs `pg_reload_conf()`, and reports that `SHOW logging_collector` still says `off`. Name the column in `pg_settings` that explains why and state what has to happen next.
2. The academy's server logs every statement with the default prefix. A reviewer finds `statement: DELETE FROM grades` and nothing else on the line. Name the two prefix escapes that would have made the line useful and state which scope you would set them in.

---

## 7.3 Application-Level Audit Trails

The server log now says that `clinic_scheduler_app` ran an `UPDATE` on `appointments` at 09:14. It does not say which appointment, what the status was before, or what it became. For a HIPAA review of a changed diagnosis code, that is not evidence. It is a rumor with a timestamp. A **trigger** is a rule attached to a table that runs a function when rows are inserted, updated, or deleted. An **audit trail** built with triggers writes the before-and-after of each change into a second table, with the role that made it and the time. You have written `INSERT` and `UPDATE`. This section makes the table write its own history.

### The Audit Table and Its Trigger

One table holds the trail for every protected table in the clinic. Each row records who, which table, what kind of change, and two JSONB documents holding the row before and after. Chapter 3 introduced JSONB for semi-structured data, and this is its best use in the book: an audit row does not care how many columns the audited table has. A **trigger function** fills it. That is a function returning the type `trigger`, written here in PL/pgSQL, PostgreSQL's procedural language. Inside it, `OLD` and `NEW` are the row before and after the change, `TG_TABLE_NAME` is the table that fired, and `TG_OP` is `INSERT`, `UPDATE`, or `DELETE`. The function must end by returning a row, and that last line is the one the Fix It later in this section is about:

```sql
\connect sandwash_clinic
-- Step 1: One table holds the trail for every protected table
CREATE TABLE audit_log (
  audit_id   bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  changed_at timestamptz NOT NULL DEFAULT clock_timestamp(),
  changed_by text NOT NULL,
  table_name text NOT NULL,
  operation  text NOT NULL,
  old_row    jsonb,
  new_row    jsonb
);
-- Step 2: One function serves every table, so the trail has one shape
CREATE FUNCTION clinic_audit_change() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
  -- current_user is the role acting, even under SET ROLE
  -- to_jsonb() copies whichever row exists for this operation
  INSERT INTO audit_log (changed_by, table_name, operation, old_row, new_row)
  VALUES (current_user, TG_TABLE_NAME, TG_OP, to_jsonb(OLD), to_jsonb(NEW));
  -- An AFTER trigger ignores the value, but the function must return one
  RETURN NEW;
END;
$$;
-- Step 3: Fire after the change is final, once per changed row
CREATE TRIGGER appointments_audit
  AFTER INSERT OR UPDATE OR DELETE ON appointments
  FOR EACH ROW EXECUTE FUNCTION clinic_audit_change();
-- Output:
-- CREATE TABLE
-- CREATE FUNCTION
-- CREATE TRIGGER
```

`clock_timestamp()` records the wall-clock time of the write. `now()` would record the start of the transaction, which can be minutes earlier in a long batch. `old_row` is empty for an insert and `new_row` is empty for a delete, so both columns allow nulls on purpose.

Three decisions sit in the trigger. It fires `AFTER` the change, so a change that a constraint rejects never reaches the trail. A `BEFORE` trigger would record an update that then failed, and a reviewer would chase a change that never happened. It fires `FOR EACH ROW`, so an `UPDATE` that touches 40 rows writes 40 audit rows, one per appointment. And the trail is written inside the same transaction as the change. Chapter 3 taught that a transaction either commits whole or rolls back whole. That rule now protects the trail: a rolled-back update leaves no audit row, and a committed one cannot lose its audit row.

Now give the clinic's scheduling application a role, let it change appointments, and watch the trail fill. `SET ROLE` switches your session to that role, as it did in Chapter 5. The last query asks the catalog what the application may do to the trail:

```sql
-- Step 1: The application gets INSERT on the trail and nothing else
CREATE ROLE clinic_scheduler_app LOGIN
  PASSWORD 'Sandwash-Ch7-Scheduler-2026!';
GRANT SELECT, UPDATE ON appointments TO clinic_scheduler_app;
GRANT INSERT ON audit_log TO clinic_scheduler_app;
-- Step 2: Make one change as the application
SET ROLE clinic_scheduler_app;
UPDATE appointments
SET status = 'Cancelled'
WHERE appointment_id = 1;
RESET ROLE;
-- Step 3: Read the trail, then ask what the application may do to it
SELECT audit_id, changed_by, table_name, operation,
       old_row ->> 'status' AS old_status,
       new_row ->> 'status' AS new_status
FROM audit_log;
SELECT has_table_privilege('clinic_scheduler_app', 'audit_log', 'INSERT') AS can_insert,
       has_table_privilege('clinic_scheduler_app', 'audit_log', 'SELECT') AS can_select,
       has_table_privilege('clinic_scheduler_app', 'audit_log', 'UPDATE') AS can_update,
       has_table_privilege('clinic_scheduler_app', 'audit_log', 'DELETE') AS can_delete;
-- Output:
-- CREATE ROLE
-- GRANT
-- GRANT
-- SET
-- UPDATE 1
-- RESET
--  audit_id |      changed_by      |  table_name  | operation | old_status | new_status
-- ----------+----------------------+--------------+-----------+------------+------------
--         1 | clinic_scheduler_app | appointments | UPDATE    | Completed  | Cancelled
--
--  can_insert | can_select | can_update | can_delete
-- ------------+------------+------------+------------
--  t          | f          | f          | f
```

The application changed one row, and the trail says which role, which table, what kind of change, and the value before and after. The `->>` operator pulls one key out of the JSONB document as text. The whole document is still there for a reviewer who needs the patient and provider on that appointment.

### Protecting the Trail

An audit table that the application can edit is a diary with an eraser. The grant above gave the scheduler `INSERT` on `audit_log` and nothing else, because the trigger runs as the role that made the change and needs to insert. It got no `UPDATE`, no `DELETE`, and no `SELECT`. The trail is **append-only** for every role but its owner, and the second result above proves it: `t` for `INSERT` and `f` for the other three. Try the eraser anyway. Run `SET ROLE clinic_scheduler_app` and then `DELETE FROM audit_log`, and the server answers `ERROR:  permission denied for table audit_log`.

Two roles can still erase the trail: the table's owner and any superuser. That is why Section 7.1 archives the trail off the server with the backups, and why the application never connects as `postgres`. Separation of duties from Chapter 1 applies here in its purest form. The role that changes the data must not be the role that can change the record of the change. On a production server the owner of `audit_log` is a role nobody logs in as, and the reviewer reads the trail through a `SELECT` grant of her own.

### Try It Yourself 7.3: Complete the Visit Notes Trail 🛠️

You are Copperwind's database administrator, and Dr. Vasquez has asked for a trail on diagnosis-code changes in `visit_notes`. The generic function copies the whole row, and a visit note's whole row includes `note_text`. Copying that text into a second table doubles the protected health information you must guard, so this trail records only the note's id and the code. The script below builds it. Three pieces are missing.

**Predict:** For each `____`, write down what belongs there and one phrase saying why. The first gap is a trigger variable that names the kind of change. The second is the statement every trigger function must end with. The third decides whether the trail records a change before or after it is final. Then predict the `audit_id` of the new row, given the rows the trail already holds.

**Run:** Copy the script into a file, fill the gaps, and run it as `postgres` in `sandwash_clinic` after the blocks above. Compare your output with the expected output that follows.

```text
-- Step 1: Record only the code that changed, never the note text
CREATE FUNCTION visit_notes_audit_change() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO audit_log (changed_by, table_name, operation, old_row, new_row)
  VALUES (current_user, TG_TABLE_NAME, ____,
          jsonb_build_object('note_id', OLD.note_id, 'diagnosis_code', OLD.diagnosis_code),
          jsonb_build_object('note_id', NEW.note_id, 'diagnosis_code', NEW.diagnosis_code));
  ____ NEW;
END;
$$;
-- Step 2: Fire once per row, after the change is final
CREATE TRIGGER visit_notes_audit
  ____ UPDATE ON visit_notes
  FOR EACH ROW EXECUTE FUNCTION visit_notes_audit_change();
-- Step 3: Make one change as the application, then read the trail
GRANT SELECT, UPDATE ON visit_notes TO clinic_scheduler_app;
SET ROLE clinic_scheduler_app;
UPDATE visit_notes
SET diagnosis_code = 'Z00.00'
WHERE note_id = 1;
RESET ROLE;
SELECT audit_id, changed_by, table_name, operation, old_row, new_row
FROM audit_log
WHERE table_name = 'visit_notes';
```

```text
 audit_id |      changed_by      | table_name  | operation |                 old_row                 |                  new_row
----------+----------------------+-------------+-----------+-----------------------------------------+--------------------------------------------
        2 | clinic_scheduler_app | visit_notes | UPDATE    | {"note_id": 1, "diagnosis_code": "I10"} | {"note_id": 1, "diagnosis_code": "Z00.00"}
```

**Explain:** In one or two sentences, explain why this trail records the note's id but not its text, and name the Chapter 4 standard that decision follows. Then state what a reviewer loses if the trigger is created with `BEFORE` instead of the word you chose.

### Fix It 7.1: The Trigger That Reached the End 🔧

Tomas Reyes asked for a trail on phone-number changes in `patients`, and the function you wrote for it was accepted without complaint. Your first test update was refused.

**Symptom:** You created the function and trigger below as `postgres`, then updated one patient's phone number. The `CREATE FUNCTION` and `CREATE TRIGGER` both succeeded. The `UPDATE` did not.

```text
CREATE FUNCTION patients_phone_audit() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO audit_log (changed_by, table_name, operation, old_row, new_row)
  VALUES (current_user, TG_TABLE_NAME, TG_OP,
          jsonb_build_object('patient_id', OLD.patient_id, 'phone', OLD.phone),
          jsonb_build_object('patient_id', NEW.patient_id, 'phone', NEW.phone));
END;
$$;
CREATE TRIGGER patients_phone_audit
  AFTER UPDATE OF phone ON patients
  FOR EACH ROW EXECUTE FUNCTION patients_phone_audit();
UPDATE patients
SET phone = '555-0199'
WHERE patient_id = 1;
```

```text
ERROR:  control reached end of trigger procedure without RETURN
```

**Diagnose:** State the cause in one sentence before you change anything. The function was accepted when it was created, so why did the error wait until the trigger fired, and which line of Section 7.3's worked example is missing here?

**Repair:** Replace the function with one that returns, and run the same update again. `CREATE OR REPLACE` on the function swaps its body. The same words on the trigger let the block run whether or not you created the broken version first. State what changed and what did not:

```sql
CREATE OR REPLACE FUNCTION patients_phone_audit() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO audit_log (changed_by, table_name, operation, old_row, new_row)
  VALUES (current_user, TG_TABLE_NAME, TG_OP,
          jsonb_build_object('patient_id', OLD.patient_id, 'phone', OLD.phone),
          jsonb_build_object('patient_id', NEW.patient_id, 'phone', NEW.phone));
  RETURN NEW;
END;
$$;
CREATE OR REPLACE TRIGGER patients_phone_audit
  AFTER UPDATE OF phone ON patients
  FOR EACH ROW EXECUTE FUNCTION patients_phone_audit();
UPDATE patients
SET phone = '555-0199'
WHERE patient_id = 1;
SELECT changed_by, table_name, operation,
       old_row ->> 'phone' AS old_phone,
       new_row ->> 'phone' AS new_phone
FROM audit_log
WHERE table_name = 'patients';
-- Output:
-- CREATE FUNCTION
-- CREATE TRIGGER
-- UPDATE 1
--  changed_by | table_name | operation |  old_phone   | new_phone
-- ------------+------------+-----------+--------------+-----------
--  postgres   | patients   | UPDATE    | 602-555-2526 | 555-0199
```

**Verify:** How do you know it is fixed for the next update as well as this one? Name the row in the output that proves the trail wrote, and explain why `UPDATE 1` alone would not have proved it.

### Quick Check 7.3 ✅

1. A developer proposes recording the audit rows with `now()` instead of `clock_timestamp()` "because it is the standard." Explain what changes in the trail during a ten-minute batch job, and state which value a reviewer building a timeline needs.
2. The billing application's role has `INSERT`, `UPDATE`, and `DELETE` on `audit_log` "so its own writes work." Name the one privilege it needs, state what the other two let a compromised application do, and name the Chapter 1 principle that decides it.

---

## 7.4 Reading Logs

A log nobody reads is a disk-space problem, not a control. **Event classification** is the reading step: every logged event gets one of three labels. A **routine** event is one the plan expects, such as a technician connecting at 09:00. A **suspicious** event is one the plan did not expect and cannot yet explain, such as sixty failed logins before dawn. A **violation** is an event that breaks a written rule, whoever did it and whatever the reason. The labels come from the plan, not from the log line. The same `ALTER ROLE` is routine when the DBA runs it on a ticket and a violation when anyone else runs it.

### Loading and Classifying One Day of Log

The data pack ships one day of Copperwind's server log, `postgresql-2026-08-14.log`, 599 lines written with the prefix `%m [%p] %u@%d `. Reading 599 lines by eye works once. Reading them every week does not. Load the file into a table with `\copy`, one line per row, and split each line into columns with a regular expression that matches the prefix. `regexp_match()` returns the parenthesized pieces as an array, and `LATERAL` lets the `SELECT` list use it. A line that does not match leaves a null timestamp, so one count proves the prefix held all day.

The classification then names each event and applies the plan's rules to it. Copperwind's plan has three rules that a query can test: role changes are made only by the DBA's own login, `copperwind_dba`, on a ticket. Failed logins are always at least suspicious. And any event outside 06:00 to 19:00 is suspicious until a person explains it:

```sql
\connect copperwind_ops
-- Step 1: Load the file one line per row, then split each line on the prefix
CREATE TABLE server_log_raw (line text);
\copy server_log_raw FROM 'assets/code/chapter-07/postgresql-2026-08-14.log' WITH (FORMAT text)
CREATE TABLE server_log AS
SELECT parts[1]::timestamp AS logged_at,
       parts[2]::integer AS pid,
       parts[3] AS role_name,
       parts[4] AS database_name,
       parts[5] AS severity,
       parts[6] AS message
FROM server_log_raw,
     LATERAL regexp_match(line, '^(\S+ \S+) \S+ \[(\d+)\] (\S+)@(\S+) (\w+):\s+(.*)$') AS parts;
SELECT COUNT(*) FILTER (WHERE logged_at IS NULL) AS lines_unparsed FROM server_log;
-- Step 2: Name the event each log line records, from the message text
WITH events AS (
  SELECT logged_at, role_name,
         CASE
           WHEN message LIKE 'password authentication failed%' THEN 'failed login'
           WHEN message LIKE 'connection authorized%' THEN 'login'
           WHEN message LIKE 'statement: ALTER ROLE%' THEN 'role change'
           WHEN message LIKE 'statement: SELECT%' THEN 'read query'
           ELSE 'other'
         END AS event_kind
  FROM server_log
  WHERE severity <> 'DETAIL'
)
-- Step 3: Apply the plan's rules in order of severity, worst first
SELECT CASE
         WHEN event_kind = 'role change' AND role_name <> 'copperwind_dba' THEN 'violation'
         WHEN event_kind = 'failed login' THEN 'suspicious'
         WHEN logged_at::time NOT BETWEEN '06:00' AND '19:00' THEN 'suspicious'
         ELSE 'routine'
       END AS classification,
       event_kind, role_name,
       COUNT(*) AS events,
       min(logged_at)::time AS first_seen,
       max(logged_at)::time AS last_seen
FROM events
-- Step 4: Summarize by class so the review reads worst first
GROUP BY classification, event_kind, role_name
ORDER BY classification DESC, event_kind, role_name;
-- Output:
-- CREATE TABLE
-- COPY 599
-- SELECT 599
--  lines_unparsed
-- ----------------
--               0
--
--  classification |  event_kind  |     role_name      | events | first_seen | last_seen
-- ----------------+--------------+--------------------+--------+------------+-----------
--  violation      | role change  | ecole              |      1 | 15:42:09   | 15:42:09
--  suspicious     | failed login | postgres           |     60 | 02:11:00   | 02:15:55
--  routine        | login        | copperwind_app     |     82 | 06:07:33   | 18:54:24
--  routine        | login        | copperwind_reports |     88 | 06:11:35   | 18:52:41
--  routine        | login        | ecole              |    106 | 06:18:01   | 18:46:15
--  routine        | login        | mlin               |     77 | 06:04:07   | 18:38:27
--  routine        | login        | nredhouse          |     67 | 06:08:03   | 18:55:21
--  routine        | read query   | copperwind_app     |     12 | 07:27:28   | 17:35:58
--  routine        | read query   | copperwind_reports |     14 | 06:12:39   | 18:25:57
--  routine        | read query   | ecole              |      9 | 07:34:42   | 18:27:20
--  routine        | read query   | mlin               |     12 | 06:05:25   | 18:27:39
--  routine        | read query   | nredhouse          |     11 | 08:21:53   | 18:37:38
```

Zero unparsed lines means the prefix was consistent all day. On a server whose prefix changed mid-day, that count would be the first finding. The `DETAIL` lines are excluded because each one belongs to the `FATAL` line above it, and counting both would double the failures. The `CASE` order in Step 3 is the plan's priority. A role change by the wrong account is a violation even if it happened at noon, so that test runs first. Read the output from the top. One violation: Ethan Cole, who runs backups and the on-call rotation, ran `ALTER ROLE copperwind_reports WITH SUPERUSER` at 15:42. Sixty suspicious events: the `postgres` failures, all between 02:11:00 and 02:15:55. Everything else is routine. Five accounts, two of them service accounts, worked from a little after six in the morning to a little before seven at night. The routine rows are the ones that let you say so with evidence instead of a shrug.

### Reading the Two Findings

Sixty failures between 02:11:00 and 02:15:55 is one attempt every five seconds, which is a script, not a person. Each `FATAL` line carries a `DETAIL` line, the same for all sixty, and it is the finding inside the finding. `SELECT DISTINCT message FROM server_log WHERE severity = 'DETAIL'` returns one row: `Connection matched file "/etc/postgresql/17/main/pg_hba.conf" line 12: "host all all 0.0.0.0/0 scram-sha-256"`. Chapter 2 wrote the rules in `pg_hba.conf`, and this server's rule 12 accepts a password attempt from any address on the internet. The burst stopped because the script gave up, not because the server refused it. And the prefix has no `%h`, so the log cannot say where it came from. Two actions follow: a `reject` rule for addresses outside Copperwind's networks, and `%h` in the prefix before the next attempt.

The `ALTER ROLE` is worse than it looks, because the log tells you only that it ran. The catalog tells you whether it stuck. `SELECT rolsuper FROM pg_roles WHERE rolname = 'copperwind_reports'` is the second witness. If it returns `t`, a reporting account with no connection limit is now a superuser, and every Chapter 5 control on this server is bypassable by anyone with its password. Revoke it, then ask Ethan. Not the other way around.

### Try It Yourself 7.4: Find the Source in the Login Table 🛠️

**Predict:** The server log could not name the address behind the 02:11 burst. Copperwind's `login_events` table records a `source_ip` for every attempt. Before you run anything, predict whether the failed attempts in that table cluster on one address or spread across many. Then predict whether the usernames tried from the worst address are Copperwind's real accounts or guesses.

**Run:** Rank the source addresses by failures, then list the usernames tried from the worst one:

```sql
SELECT source_ip,
       COUNT(*) AS failures,
       COUNT(DISTINCT username) AS usernames_tried,
       min(event_time) AS first_attempt,
       max(event_time) AS last_attempt
FROM login_events
WHERE NOT success
GROUP BY source_ip
ORDER BY failures DESC
LIMIT 3;
SELECT username, COUNT(*) AS failures
FROM login_events
WHERE NOT success
  AND source_ip = '203.0.113.77'
GROUP BY username
ORDER BY failures DESC;
-- Output:
--   source_ip   | failures | usernames_tried |    first_attempt    |    last_attempt
-- --------------+----------+-----------------+---------------------+---------------------
--  203.0.113.77 |      199 |               5 | 2026-07-19 02:11:00 | 2026-07-19 02:34:06
--  10.20.5.14   |       69 |              10 | 2026-06-01 17:45:27 | 2026-07-30 22:06:09
--  10.20.7.9    |       64 |              10 | 2026-06-01 08:26:04 | 2026-07-30 15:37:56
--
--     username    | failures
-- ----------------+----------
--  admin          |       47
--  root           |       44
--  postgres       |       42
--  backup         |       38
--  copperwind_app |       28
```

**Explain:** In one or two sentences, explain what the mix of usernames from `203.0.113.77` tells you about who was on the other end. Then classify the two internal addresses in the first output as routine or suspicious, with one reason each.

### The Data Security Review

A **data security review** is the written record of a log reading: what was read, what was found, what was done, and who signed. Chapter 5's access review had seven fields, and this record reuses five of them so the two can sit side by side in Naomi Redhouse's binder:

| Field | Entry for 2026-08-14 |
| --- | --- |
| Scope | `copperwind_ops` server log, 599 lines, plus `login_events` for the same server |
| Method | Loaded with `\copy`, parsed into `server_log`, classified with the Section 7.4 query |
| Findings | 1 violation: `ALTER ROLE copperwind_reports WITH SUPERUSER` by `ecole` at 15:42:09. 60 suspicious: password failures for `postgres`, 02:11:00 to 02:15:55, one every five seconds. Routine: 420 logins and 58 read queries by five known accounts, 06:04 to 18:55 |
| Actions | Superuser revoked and confirmed in `pg_roles`. Ticket opened with Mei Lin for the role change. `reject` rule drafted for `pg_hba.conf`. `%h` added to the prefix |
| Residual risk | Source address of the burst unknown for this day. Accepted by Naomi Redhouse until the prefix change ships |

The findings cite line counts and times because the next reviewer will compare against them. "Some failed logins overnight" cannot be compared. "Sixty, at five-second intervals, ending 02:15:55" can. Chapter 10 turns a record like this into an incident timeline, and it will need the numbers.

### Try It Yourself 7.5: Classify by Hand, Then Check 🛠️

**Predict:** Here are four lines from the shipped log. Before you look at the classification output above, label each one routine, suspicious, or violation, and write one phrase naming the rule in the plan that decides it.

```text
2026-08-14 02:13:35.000 MST [40859] postgres@copperwind_ops FATAL:  password authentication failed for user "postgres"
2026-08-14 09:00:15.000 MST [40509] nredhouse@copperwind_ops LOG:  statement: SELECT count(*) FROM tickets WHERE status = 'Open'
2026-08-14 15:42:09.000 MST [40888] ecole@copperwind_ops LOG:  statement: ALTER ROLE copperwind_reports WITH SUPERUSER
2026-08-14 18:55:21.000 MST [40548] nredhouse@copperwind_ops LOG:  connection authorized: user=nredhouse database=copperwind_ops application_name=psql
```

**Run:** Compare your four labels against the classification query's output. Then change the plan's business hours in the query to `07:00` to `18:00` and rerun it. Count how many events change class.

**Explain:** In one or two sentences, explain why the last line's label depends on a number in the plan, not on anything in the line itself. Then say what that implies about who must approve a change to the plan.

### Quick Check 7.4 ✅

1. A review query finds an `ALTER ROLE ... SUPERUSER` run by the DBA's own login at 10:15 with a ticket number in the application name. Classify it and explain why the same statement from another account gets a different label.
2. Explain why the `DETAIL` lines were excluded from the event count and what would have gone wrong in the failed-login count if they had stayed.

---

## 7.5 Summary and Retrieval 💡

### Key Concepts

* An auditing plan names five event categories (logins, failed logins, DDL, privileged DML, role changes), the source that records each, the reviewer, and the retention. Regulation sets the retention floor and disk sets the ceiling, so different sources are kept for different lengths and archived off the server.
* The server logs little by default. `log_connections`, `log_statement`, and `log_line_prefix` turn on logins and DDL and stamp every line with the role, database, and address. The `context` column in `pg_settings` says whether a change needs a reload, a restart, or a new session. Narrow scopes (`ALTER DATABASE`, `ALTER ROLE`) log one database or one account harder than the rest. Rotation switches files and never deletes them, so retention is a job you schedule.
* A trigger-based audit trail records who, which table, what kind of change, and the row before and after, inside the same transaction as the change. The audit table is append-only for every role but its owner, and the application role gets `INSERT` alone.
* Every trigger function must return a row, and PL/pgSQL enforces it when the trigger fires, not when the function is created.
* Event classification applies the plan's rules to each logged event: routine, suspicious, or violation. The label comes from the plan, not the line. The data security review records scope, method, findings with counts and times, actions, and residual risk, so the next review can compare.

### Key Terms

See course glossary for full definitions

* auditing plan, audit event, audit controls, server log, audit trail (Section 7.1)
* configuration parameter, logging collector, log line prefix, configuration reload, log rotation (Section 7.2)
* trigger, trigger function, append-only (Section 7.3)
* event classification, routine, suspicious, violation, data security review (Section 7.4)

### Retrieval Practice

1. From memory, list the five event categories in an auditing plan and name the source that records each one.
2. State what `log_statement = 'ddl'` writes and does not write, and name the setting that would have to change for a `DELETE` to appear in the server log.
3. Explain why the audit trigger fires `AFTER` the change instead of `BEFORE`, and what a reviewer would chase if it were the other way around.
4. From Chapter 5: The `has_table_privilege()` function proved what a role may do. State what this chapter's trail adds that the catalog cannot, and name the one privilege the application role holds on the audit table.
5. From Chapter 3: A transaction commits whole or rolls back whole. Explain how that rule protects an audit trail written by a trigger, and what would be lost if the trail were written by the application after the commit instead.

---

## 7.6 Skills Lab 7A: An Audit Trail for Copperwind Tickets

**Goal:** Write Copperwind's auditing plan, configure server logging on your own server, and prove it. Then add a trigger-based trail to the `tickets` table that the application cannot erase, and review one day of shipped server log with a classification query and a signed record.

**Dataset or starter files:** `assets/code/chapter-07/` in the course data pack. `setup-copperwind.sql` rebuilds `copperwind_ops`. `postgresql-2026-08-14.log` is the shipped server log, 599 lines from one day. `skills-lab-7a.sql` is the starter script with numbered markers. `skills-lab-7a-answers.md` holds the plan, the review record, and the two Questions & Analysis answers. The setup script loads the CSVs in `assets/code/data/copperwind/`. Copperwind and every record in its database are fictional.

Mei Lin's specification is the plan's input:

* Capture logins, failed logins, and DDL on the server. Capture every change to `tickets` in a trail with the old and new row.
* The ticket application connects as `copperwind_ticket_app`. It may read and change tickets. It may never read, change, or erase the trail.
* Role changes are made only by the DBA's own login on a ticket. Business hours are 06:00 to 19:00. Anything else is suspicious until explained.
* Server logs stay online 30 days and in the archive one year. The trail stays as long as the ticket plus six years.

### Part 1: Foundation (Aligns with Objective 7.1)

1. From the extracted `cis376` folder, run `setup-copperwind.sql` as `postgres`. Under marker 1.1, run the `pg_settings` query from Section 7.2 against your own server and paste the result. In the answer file, note every value that differs from the book's output and say why (installer, operating system, or an earlier change of yours).
2. In the answer file, fill the auditing plan table: five event categories, each with an example, the source that records it, retention online, archive, and reviewer. Use Mei Lin's numbers where she gave them and choose the rest, with one phrase of reason per row.
3. Under marker 1.2, summarize `login_events` by success and by distinct username, as in Section 7.1. Then add one query that counts attempts by hour of day. Paste both results and, in the answer file, name the hour that looks least like the others.

### Part 2: Application (Aligns with Objectives 7.1 and 7.2)

1. On your own server, edit `postgresql.conf` to set `log_connections`, `log_statement = 'ddl'`, and a prefix that includes `%u@%d %h`. Reload. Under marker 2.1, paste the `pg_reload_conf()` result and the `pending_restart` query. Then open a new session, run `SHOW` for all three settings, and paste the transcript into the answer file. Under marker 2.2, attach `log_statement = 'all'` to `copperwind_reports` (create it if your server lacks it) and prove the setting with the `pg_db_role_setting` query.
2. Under marker 2.3, create `tickets_audit` with the columns from Section 7.3, a trigger function `copperwind_audit_change()`, and an `AFTER INSERT OR UPDATE OR DELETE` trigger on `tickets`. Create `copperwind_ticket_app` with a visibly fake password of your own, grant it `SELECT` and `UPDATE` on `tickets` and `INSERT` on `tickets_audit`, and nothing else.
3. Under marker 2.4, `SET ROLE copperwind_ticket_app` and make three changes: close one open ticket, raise one ticket's priority, and reopen a closed one. `RESET ROLE` and read the trail, showing the old and new value of the column each change touched. Under marker 2.5, prove the trail is append-only with `has_table_privilege()` for all four privileges, and attempt a `DELETE` on the trail as the application. Paste the refusal.

### Part 3: Extension (Aligns with Objectives 7.2 and 7.3)

1. Under marker 3.1, load `postgresql-2026-08-14.log` with `\copy`, parse it into `server_log` with the Section 7.4 expression, and confirm that every line parsed. Under marker 3.2, run the classification query with Mei Lin's rules and paste the result.
2. Under marker 3.3, write the two follow-up queries the review needs: the exact line of every violation, and the failed-login burst measured per minute. Then correlate: query `login_events` for the address with the most failures and compare its rhythm with the burst in the server log. In the answer file, state whether the two sources describe the same kind of attack and what the log's prefix would need to prove it.
3. Write the data security review record for Naomi Redhouse with the five fields from Section 7.4. Every finding cites a count and a time. Under actions, include the exact `ALTER ROLE` that reverses the violation and the `pg_roles` query that proves it. Add the `pg_hba.conf` rule you would write and where in the file it goes (Chapter 2 decided the order).

### Questions & Analysis 🤔

1. Using your Part 2.4 output and your Part 3.2 output as evidence, explain what each source could show that the other could not. Name one question the server log answers that the trail cannot, and one the trail answers that the log cannot. Then state which source the six-year retention in Mei Lin's specification protects and why.
2. The `ALTER ROLE` at 15:42 was run by Ethan Cole, who runs backups and the on-call rotation. Justify your classification with evidence from the log and the plan. Then state the one question you would ask him, and what his answer would and would not change about the actions in your review record.

**Submission:** Submit one folder named `skills-lab-7a-lastname`. It holds `skills-lab-7a.sql` with every result pasted as `-- Output:` comment lines (or the saved psql output beside it). It also holds `skills-lab-7a-answers.md` with the auditing plan, the `SHOW` transcript, the data security review record, and your two Questions & Analysis answers clearly labeled.

### Rubric: Skills Lab 7A

This lab is graded with the standard
[Skills Lab Rubric](../skills-lab-rubric.md): four criteria, five
levels from Mastery to Not Evident. The criteria are Technical
Accuracy and Efficiency, Output Quality, Documentation Quality, and
Analysis, Interpretation, and Response to QUESTION(s). The criteria
and levels are the same everywhere. Your instructor sets the point
values in your course. Check the syllabus and the Canvas rubric
attached to this lab for the values that apply to you.

---

## 7.7 Review Questions 🔄️

1. **Apply:** A nonprofit food bank runs its donor database on a server with 20 GB of free disk and no archive job. Write the four `postgresql.conf` lines you would set for its auditing plan, choose a `log_statement` value, and state in one line per setting why you chose it and what it costs in disk.

2. **Analyze:** A bike shop's point-of-sale vendor says its application "keeps its own audit log" in a table the application owns and writes to after each sale commits. Break down what a reviewer can and cannot trust in that trail, compare it with a trigger-based trail written inside the transaction, and name the two roles that could still erase either one.

3. **Evaluate:** A city parks department proposes `log_statement = 'all'` on its reservations server "so nothing is missed," with a 90-day online retention. Judge the proposal against the two forces in Section 7.1 and the password warning in Section 7.2, and state the one condition under which you would accept it.

4. **Create:** Design the weekly log review for the academy's server. Name the five event categories and the query that classifies each. Separate the plan rules a query can test from the ones a person must judge. Then name the record the review produces and the two findings you would treat as blocking until they are fixed.

---

## Further Reading 📖

* [PostgreSQL Documentation: Error Reporting and Logging](https://www.postgresql.org/docs/17/runtime-config-logging.html) - Every logging parameter in Section 7.2, including the full list of `log_line_prefix` escapes and the `log_statement` values.
* [PostgreSQL Documentation: Log File Maintenance](https://www.postgresql.org/docs/17/logfile-maintenance.html) - Rotation, truncation, and the cyclic filename patterns that keep a fixed number of days by design.
* [PostgreSQL Documentation: Trigger Functions in PL/pgSQL](https://www.postgresql.org/docs/17/plpgsql-trigger.html) - `OLD`, `NEW`, `TG_OP`, `TG_TABLE_NAME`, and the return-value rules behind Fix It 7.1.
* [NIST SP 800-92: Guide to Computer Security Log Management](https://csrc.nist.gov/pubs/sp/800/92/final) - The planning, retention, and review practices that Section 7.1's plan follows.
* [45 CFR 164.312: Technical Safeguards](https://www.ecfr.gov/current/title-45/section-164.312) - The audit controls standard, in the regulation's own words, beside the access control and integrity standards it sits with.
* [OWASP Logging Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Logging_Cheat_Sheet.html) - What an application should log, what it must never log (passwords, full records), and how to protect the log itself.

---

## Looking Ahead ⏩

You can now say what happened on the server and prove it. Chapter 8 asks how fast it happened. The same `pg_settings` view holds `log_min_duration_statement`, which logs every statement slower than a threshold you set, and that line is where performance work begins. You will read execution plans, add the indexes that turn three slow Copperwind reports into fast ones, and measure before and after so the improvement is evidence, not a feeling. Then you will make the server survive a disk failure with replication, because a fast server that is down is not fast.
