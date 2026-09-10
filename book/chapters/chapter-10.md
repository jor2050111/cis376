# Chapter 10: Incident Response

At 7:40 on a Thursday morning, Luis Ortega calls from the registrar's office at Harquahala Charter Academy. A guardian phoned him in tears. A stranger had called her at home, used her child's first name, recited the child's birthday, and named last term's grades. Luis has already checked the database. Every table is there. Every row is intact. Nothing is missing at all.

That is what a database breach looks like from the inside. Copying data leaves the data where it was. The evidence is not a hole in a table, it is a line in a log. Chapter 7 turned that logging on and built the audit trail. Chapter 9 wrote the recovery plan and proved it with a restore drill. This chapter is the morning those two pieces of work earn their keep, because now you have to answer questions with them under time pressure.

You are the database administrator at Copperwind IT Services, which hosts the academy's student information database. Naomi Redhouse, Copperwind's security lead, signs the incident report. Mei Lin, who runs Data Services, will ask you two questions before anything else. What do we know, and how do we know it. Every query in this chapter exists to answer the second one. You will reconstruct the incident from shipped evidence, contain the account without destroying that evidence, decide what the law requires you to do, and write the report that changes the next plan.

## Module Overview 🧭

* **Estimated time:** 5-6 hours
* **Prerequisites:** One prior SQL course (Introduction to Oracle: SQL, CIS276DA MySQL Database, or CIS276DB SQL Server Database). Chapter 1 (the lab environment and the three course databases). Chapter 4 named HIPAA and FERPA, Chapter 7 configured the logs, and Chapter 9 wrote the recovery plan. One sentence recalls each where it is needed.
* **Deliverables:** Skills Lab 10A folder (`skills-lab-10a.sql` and `skills-lab-10a-answers.md`), Quick Checks

## Learning Objectives 🎯

By the end of this chapter, you will be able to:

* **10.1 (Create):** Construct a step-by-step incident response plan for three common database security scenarios (Section 10.1)
* **10.2 (Analyze):** Investigate database and server logs to trace the origin, scope, and timeline of a simulated breach (Section 10.2)
* **10.3 (Evaluate):** Determine the notification and recovery obligations an incident triggers under HIPAA, FERPA, and state breach laws (Sections 10.3-10.4)

### This chapter aligns with the following Course Learning Outcomes

* **CLO II (Evaluate):** Assess security management for database environments.
* **CLO IV (Evaluate):** Evaluate practices for database environment incident responses.
* **CLO V (Evaluate):** Critique current practices and future trends of database management and security.

---

## 10.1 The Incident Response Lifecycle

Three words get used as if they meant the same thing, and the difference decides who you call. An **event** is anything the server records. A failed login is an event. A **security incident** is an event, or a set of them, that violates a security policy or threatens confidentiality, integrity, or availability. Sixty failed logins in five minutes is an incident. A **breach** is an incident in which protected data was acquired, accessed, used, or disclosed without authorization. A breach is the category that starts legal clocks, and Section 10.3 is where those clocks live.

You do not get to pick the label at the start. You investigate, and the evidence moves the event up or down that ladder. Calling something a breach before you can prove acquisition creates obligations you may not owe. Calling it routine to avoid the work is worse, and it is the failure regulators write about.

### The Six Phases

An **incident response plan** is the written sequence a team follows so that nobody improvises at 3 a.m. The phases below are the working shape this book uses. Each one has an exit test, which is the question that tells you the phase is done.

| Phase | What you do | The exit test |
| --- | --- | --- |
| Preparation | Write the plan, arm the logging, name the people, run a practice | Could you answer "who has the phone number for counsel" right now? |
| Detection and analysis | Confirm the event is real, classify it, open the record | Can you state what happened in one sentence with evidence behind it? |
| Containment | Stop the harm from continuing without erasing how it happened | Is the access closed and is the evidence still readable? |
| Eradication | Remove the cause, not only the symptom | Is the opening that was used gone from the configuration? |
| Recovery | Return the service to normal and watch it | Is the data correct, and is monitoring in place for a repeat? |
| Lessons learned | Write the after-action report and change the plan | Does every action item have an owner and a date? |

Two of those phases are where database administrators get into trouble. Containment tempts you to delete the compromised account, which destroys the record of what it could reach. Lessons learned tempts you to skip the report because the crisis ended. A plan that stops at recovery guarantees the same incident twice. Preparation is the opposite case, because it finishes before the incident starts and is the only phase you control completely. It is Chapter 7's logging settings, Chapter 9's tested restore, and Chapter 5's least-privilege roles. When those three are done, the other five phases take hours instead of weeks.

### Who Does What

Chapter 1 named five roles in a database environment. An incident adds a sixth, the **incident commander**, and reshuffles the rest, because response is a decision-making structure and not a technical task.

| Role | Owns | Does not own |
| --- | --- | --- |
| Incident commander | The sequence, the clock, the record of decisions | The technical fix |
| Database administrator | The evidence queries, containment on the server, the restore | Whether to notify anyone |
| Security lead | Classification, the risk assessment, the after-action report | The business decision to notify |
| Data owner | The notification decision and the message to affected people | The server configuration |
| Legal counsel | What the law requires and when the clock started | The technical timeline |
| Communications | What is said publicly and to whom | The facts, which come from the record |

One person can wear several of these hats at a small organization. The separation still matters, because the notification decision must not sit with the person whose configuration caused the incident. That is Chapter 1's separation of duties, applied on the worst day.

### Three Scenarios, Three First Moves

Most database incidents fall into three shapes. The first move differs for each, and getting it wrong costs either evidence or time.

| Scenario | What it looks like | First move | What it would destroy if rushed |
| --- | --- | --- | --- |
| Credential compromise | A valid account used from a strange address at a strange hour | Disable the login, keep the account | Dropping the role erases what it could reach |
| Destructive attack or ransomware | Rows or files altered or encrypted, service failing | Isolate the server, snapshot before anything | Restoring first overwrites the evidence of how they got in |
| Insider over-access | An authorized account reading far outside its job | Copy the audit trail off the server, then review | Revoking first can trigger a cleanup by the insider |

Notice the shared pattern in the last column. Every rushed first move destroys the answer to "how did this happen," which is the only question that prevents the next one.

### Try It Yourself 10.1: Write the Parks Department's First Hour 🛠️

A city parks department runs a registration database for youth programs. On Monday its help desk gets three calls from parents who received texts about a program their child never signed up for.

**Predict:** Before you write anything, decide which of the three scenarios above this most resembles, and predict which phase of the lifecycle the department is entering. Then predict the one action a hurried administrator would take first that would cost the department its evidence.

**Run:** Write the first hour as a numbered plan of six steps, one per phase, in order. For each step name the person from the roles table who owns it and the exit test that says the step is finished. Add one line naming the evidence you would copy off the server before you change anything.

**Explain:** In one or two sentences, explain why the notification decision does not belong to the administrator who runs the containment, and name the principle from Chapter 1 that says so.

### Quick Check 10.1 ✅

1. An administrator sees forty failed logins on a service account overnight and closes the ticket as noise. State which of the three terms from this section applies, and name the evidence that would move it up one level.
2. Compare containment and eradication. Give one database example of each on the same incident, and explain what goes wrong if you do them in the reverse order.
3. A team finishes recovery and skips the after-action report because the service is back. Name the phase they dropped and the one thing the plan will still be missing next time.

---

## 10.2 Scope Analysis and Damage Control

**Scope analysis** answers three questions about an incident, and every later decision depends on the answers. Where did it come from? How far did it reach? When did it start and stop? Answering them is a reading job, and the reading material is the server log and the audit trail. Chapter 7 built both instruments. This section uses them on two pieces of evidence the academy ships with this chapter. `assets/code/chapter-10/postgresql-2026-09-03.log` is 301 lines of the server log covering the night of September 2 into the morning of September 3. `assets/code/chapter-10/academy_audit_trail.csv` is 141 rows of the application audit trail from the three weeks before that. Neither one alone tells the story.

### The Evidence You Start With

Here are three lines from the log, exactly as the server wrote them. The prefix is the one Chapter 7 configured, `%m [%p] %u@%d `, which gives you the timestamp with its zone, the process id, the role, and the database.

```text
2026-09-02 07:04:50.000 MST [51155] academy_app@harquahala_academy LOG:  connection authorized: user=academy_app database=harquahala_academy application_name=psql
2026-09-02 23:48:00.000 MST [51261] academy_reports@harquahala_academy FATAL:  password authentication failed for user "academy_reports"
2026-09-03 02:13:11.000 MST [51296] academy_reports@harquahala_academy LOG:  statement: COPY (SELECT full_name, phone, email FROM guardians) TO STDOUT WITH CSV HEADER
```

Read the third line twice. It names the exact columns that left the server. That single fact is what makes the whole notification decision in Section 10.3 possible, and it exists only because someone turned on statement logging before the incident.

### Load the Evidence Before You Read It

Reading 301 lines by eye works once and never again. Load both files into tables and let queries do the reading. Start with the audit trail. It arrives as naive timestamps with no zone attached, and the academy's server runs on Arizona time, so declare that zone before the load reads a single row:

```sql
\connect harquahala_academy
-- Arizona keeps Mountain Standard Time all year, so every naive
-- timestamp in the file is an MST instant. Say so before loading.
SET TimeZone = 'America/Phoenix';
DROP TABLE IF EXISTS academy_audit;
CREATE TABLE academy_audit (
  audit_id    integer PRIMARY KEY,
  changed_at  timestamptz NOT NULL,
  db_user     text NOT NULL,
  table_name  text NOT NULL,
  operation   text NOT NULL,
  row_summary text NOT NULL
);
\copy academy_audit FROM 'assets/code/chapter-10/academy_audit_trail.csv' WITH (FORMAT csv, HEADER true)
SELECT COUNT(*) AS audit_rows,
       min(changed_at) AS first_change,
       max(changed_at) AS last_change
FROM academy_audit;
-- Output:
-- COPY 141
--  audit_rows |      first_change      |      last_change
-- ------------+------------------------+------------------------
--         141 | 2026-08-13 03:43:10-07 | 2026-09-01 17:42:01-07
```

The trail covers August 13 through September 1 and stops the day before the log begins. That gap is not a defect. The two instruments watch different things, and putting them on one clock is the job.

The server log needs parsing, not just loading. Read each line into one column, then split it on the prefix with a regular expression. `regexp_match()` returns the parenthesized pieces as an array, and `LATERAL` lets the select list use them. Capturing the zone abbreviation along with the timestamp is what makes the result a true instant instead of a wall-clock guess:

```sql
DROP TABLE IF EXISTS server_log_raw, server_log;
CREATE TABLE server_log_raw (line text);
\copy server_log_raw FROM 'assets/code/chapter-10/postgresql-2026-09-03.log' WITH (FORMAT text)
CREATE TABLE server_log AS
SELECT parts[1]::timestamptz AS logged_at,
       parts[2]::integer AS pid,
       parts[3] AS role_name,
       parts[5] AS severity,
       parts[6] AS message
FROM server_log_raw,
     LATERAL regexp_match(line, '^(\S+ \S+ \S+) \[(\d+)\] (\S+)@(\S+) (\w+):\s+(.*)$') AS parts;
SELECT severity,
       COUNT(*) AS log_lines,
       min(logged_at) AS first_line,
       max(logged_at) AS last_line
FROM server_log
GROUP BY severity
ORDER BY severity;
-- Output:
-- COPY 301
-- SELECT 301
--  severity | log_lines |       first_line       |       last_line
-- ----------+-----------+------------------------+------------------------
--  FATAL    |        35 | 2026-09-02 23:48:00-07 | 2026-09-02 23:53:06-07
--  LOG      |       266 | 2026-09-02 07:04:50-07 | 2026-09-03 02:15:29-07
```

Two severities, 35 and 266, and they add to the 301 lines the copy reported. No third group with a blank severity appeared, so every line matched the prefix and nothing was silently dropped. Thirty-five failures on one night is the first thing worth a second look.

### The Scope Analysis Query Set

Now ask the three scope questions in order. The origin question comes first because it narrows everything after it. A password guessing run has a signature: one role, many failures, and a machine-steady interval between attempts.

```sql
-- Step 1: Origin. One role with many failures and a fixed interval
--         between them is a script, not a person forgetting a password
SELECT role_name,
       COUNT(*) AS failed_logins,
       min(logged_at) AS first_attempt,
       max(logged_at) AS last_attempt,
       EXTRACT(epoch FROM max(logged_at) - min(logged_at))::int
         / (COUNT(*) - 1) AS seconds_apart
FROM server_log
WHERE message LIKE 'password authentication failed%'
GROUP BY role_name;
-- Step 2: Extent, part one. Find every session that opened after the
--         failures stopped, and the address it came from
SELECT pid,
       max(substring(message FROM 'host=([0-9.]+)')) AS source_address,
       min(logged_at) AS session_start,
       max(logged_at) AS session_end,
       COUNT(*) FILTER (WHERE message LIKE 'statement:%') AS statements_run
FROM server_log
WHERE logged_at > (SELECT max(logged_at) FROM server_log
                   WHERE message LIKE 'password authentication failed%')
GROUP BY pid;
-- Step 3: Extent, part two. Read the statements themselves and pull the
--         source and the column list out of each one
SELECT logged_at::time AS at_time,
       CASE WHEN message LIKE 'statement: COPY%' THEN 'export'
            ELSE 'read' END AS action,
       substring(message FROM 'FROM ([a-z_.]+)') AS first_source,
       substring(message FROM 'SELECT (.*?) FROM') AS columns_named
FROM server_log
WHERE pid = 51296
  AND message LIKE 'statement:%'
ORDER BY logged_at;
-- Output:
--     role_name    | failed_logins |     first_attempt      |      last_attempt      | seconds_apart
-- -----------------+---------------+------------------------+------------------------+---------------
--  academy_reports |            35 | 2026-09-02 23:48:00-07 | 2026-09-02 23:53:06-07 |             9
--
--   pid  | source_address |     session_start      |      session_end       | statements_run
-- -------+----------------+------------------------+------------------------+----------------
--  51296 | 198.51.100.23  | 2026-09-03 02:09:41-07 | 2026-09-03 02:15:29-07 |              3
--
--  at_time  | action |       first_source        |                      columns_named
-- ----------+--------+---------------------------+----------------------------------------------------------
--  02:10:53 | read   | information_schema.tables | table_name
--  02:13:11 | export | guardians                 | full_name, phone, email
--  02:13:43 | export | students                  | s.first_name, s.last_name, s.date_of_birth, g.term_grade
```

Read the three results as one finding. Thirty-five failures against `academy_reports`, exactly nine seconds apart, from 23:48:00 to 23:53:06. One session afterward, process 51296, from the address 198.51.100.23, open for under six minutes and running three statements. Those three statements are a tour: list the tables, take the guardian contact list, then take student names, birth dates, and grades.

The last column is the one you carry into Section 10.3. The exports did not take "some student data." They took `full_name, phone, email` from `guardians`, and student names, birth dates, and term grades from a join. Regulators ask which data elements left, and the log answers in the regulator's own vocabulary.

### Root Cause and the Merged Timeline

You now know how the data left. You do not yet know why the reporting account could reach it at all. That answer is in the audit trail, which records privilege changes alongside row changes:

```sql
-- Every row in the trail is an INSERT, UPDATE, or DELETE except one
SELECT changed_at, db_user, table_name, operation, row_summary
FROM academy_audit
WHERE operation NOT IN ('INSERT', 'UPDATE', 'DELETE');
-- Put both instruments on one clock and read them together
SELECT changed_at AS occurred_at,
       'audit trail' AS source,
       'SELECT on every table granted to academy_reports' AS event
FROM academy_audit
WHERE operation = 'GRANT'
UNION ALL
SELECT min(logged_at), 'server log',
       COUNT(*) || ' failed logins for academy_reports'
FROM server_log
WHERE message LIKE 'password authentication failed%'
UNION ALL
SELECT logged_at, 'server log',
       CASE
         WHEN message LIKE 'connection received%'
           THEN 'session opened from ' || substring(message FROM 'host=([0-9.]+)')
         WHEN message LIKE 'statement: COPY%'
           THEN 'export from ' || substring(message FROM 'FROM ([a-z_]+)')
         WHEN message LIKE 'statement: SELECT%' THEN 'table list read'
         ELSE 'session closed'
       END
FROM server_log
WHERE pid = 51296
  AND message NOT LIKE 'connection authorized%'
ORDER BY occurred_at;
-- Output:
--        changed_at       |  db_user   | table_name | operation |                          row_summary
-- ------------------------+------------+------------+-----------+----------------------------------------------------------------
--  2026-08-30 15:00:00-07 | dwhitfield | pg_authid  | GRANT     | GRANT SELECT ON ALL TABLES IN SCHEMA public TO academy_reports
--
--       occurred_at       |   source    |                      event
-- ------------------------+-------------+--------------------------------------------------
--  2026-08-30 15:00:00-07 | audit trail | SELECT on every table granted to academy_reports
--  2026-09-02 23:48:00-07 | server log  | 35 failed logins for academy_reports
--  2026-09-03 02:09:41-07 | server log  | session opened from 198.51.100.23
--  2026-09-03 02:10:53-07 | server log  | table list read
--  2026-09-03 02:13:11-07 | server log  | export from guardians
--  2026-09-03 02:13:43-07 | server log  | export from students
--  2026-09-03 02:15:29-07 | server log  | session closed
```

There is the whole incident on one page. On August 30 at 3 p.m., Principal Dana Whitfield granted `SELECT` on every table in the schema to a reporting account, most likely to unblock a board report. That is the **root cause**, the condition without which the rest could not have happened. The guessing run three days later found a password. The session that followed read a table list and took two exports. Total elapsed time from the grant to the export was a little over three days.

An over-grant is not an exotic attack. It is Chapter 5's least-privilege rule broken once, by a person with authority and a deadline, and never reviewed. The account was always going to be guessed eventually. The grant decided what a guess was worth.

### What the Log Cannot Tell You

Write down the gaps as carefully as the findings, because an incident report that overstates the evidence gets taken apart by the first reviewer. Two gaps sit in this log.

The failure lines carry no source address. The prefix has `%u` and `%d` but no `%h`, so the 35 failures cannot be tied to 198.51.100.23 or to any other address. The successful session came more than two hours after the failures stopped. It is likely the same actor and the log does not prove it. Say "likely" in the report and add `%h` to `log_line_prefix` as an action item.

The log also cannot prove what the intruder did with the data after `COPY ... TO STDOUT` handed it over. It proves the rows were read and sent to the client, which under most rules is enough to count as acquisition. Section 10.3 shows where that distinction pays.

### Fix It 10.1: The Timeline in the Wrong Zone 🔧

The first draft of the incident report says the night of September 2 was quiet. It was not, and no error message appears anywhere.

**Symptom:** A colleague summarizes the four hours around midnight to bound the incident window. The report comes back with events in it, so it looks like it worked.

```text
SET TimeZone = 'UTC';
SELECT current_setting('TimeZone') AS report_zone,
       COUNT(*) AS events_in_window,
       COUNT(*) FILTER (WHERE severity = 'FATAL') AS failed_logins,
       min(logged_at) AS first_event,
       max(logged_at) AS last_event
FROM server_log
WHERE logged_at >= '2026-09-02 23:00:00'
  AND logged_at <  '2026-09-03 03:00:00';
```

```text
 report_zone | events_in_window | failed_logins |      first_event       |       last_event
-------------+------------------+---------------+------------------------+------------------------
 UTC         |               47 |             0 | 2026-09-02 23:00:59+00 | 2026-09-03 00:57:52+00
```

**Diagnose:** Name the cause in one sentence before you change anything. The `logged_at` column is a `timestamptz`, so it holds an instant. The two strings in the `WHERE` clause hold no zone at all, so PostgreSQL reads them in the session's zone. Under `UTC` that window is 23:00 to 03:00 UTC, which is 16:00 to 20:00 in Phoenix, an afternoon that ended before the first failure. Forty-seven quiet connections, zero failures, and the entire incident outside the window.

**Repair:** State the zone the evidence was written in and let the same strings mean what the reader thinks they mean. Arizona observes no daylight saving, so `America/Phoenix` is Mountain Standard Time every day of the year. Nothing else about the query changes:

```sql
-- The repair: declare the zone the evidence was recorded in, and put
-- that zone in the report so the next reader cannot misread the times
SET TimeZone = 'America/Phoenix';
SELECT current_setting('TimeZone') AS report_zone,
       COUNT(*) AS events_in_window,
       COUNT(*) FILTER (WHERE severity = 'FATAL') AS failed_logins,
       min(logged_at) AS first_event,
       max(logged_at) AS last_event
FROM server_log
WHERE logged_at >= '2026-09-02 23:00:00'
  AND logged_at <  '2026-09-03 03:00:00';
-- Output:
-- SET
--    report_zone   | events_in_window | failed_logins |      first_event       |       last_event
-- -----------------+------------------+---------------+------------------------+------------------------
--  America/Phoenix |               41 |            35 | 2026-09-02 23:48:00-07 | 2026-09-03 02:15:29-07
```

**Verify:** How do you know it is fixed? Name the two numbers that changed and the one column that explains why. The failure count moved off zero, the window now opens on the first failed login instead of an afternoon connection, and `report_zone` states the clock the other four columns are measured against. Put that column in every **forensic timeline** you write. A timeline without a zone is a rumor with numbers in it.

### Containment Without Destroying Evidence

**Containment** stops the harm. It is not cleanup, and the difference is the whole art. Four actions get proposed in the first ten minutes of a credential incident. They do not cost the same.

| Action | Stops the access? | What it preserves | What it costs |
| --- | --- | --- | --- |
| `ALTER ROLE ... NOLOGIN` | Yes, for new connections | The account, its grants, its ownership | Nothing |
| `pg_terminate_backend(pid)` | Yes, for the session already open | Everything, including the log lines | The session's own work is lost |
| `REVOKE` the privileges | Yes, for what it names | The account and the log | The record of what the account could reach |
| `DROP ROLE` | Yes, completely | Nothing about the account | The privilege trail an investigator needs |

The pairing that contains without erasing is the first two together. `ALTER ROLE ... NOLOGIN` shuts the door on new connections and leaves the role, its privileges, and its ownership in the catalog where a reviewer can read them. `pg_terminate_backend()` closes any session already inside. Both are PostgreSQL-specific, and every major database product has an equivalent pair.

`DROP ROLE` is the move to resist. It answers "make it stop" and deletes the answer to "what could it reach," which the data owner will ask within the hour. PostgreSQL argues the point for you, because while privileges are still granted the drop fails with `ERROR: role "clinic_gyazzie" cannot be dropped because some objects depend on it`. Forcing it through means revoking everything first, and that revoke is exactly the record you needed.

### Try It Yourself 10.2: Bound the Law Office's Incident 🛠️

A law office finds that a paralegal account read 4,000 client matter records over one weekend. The account is legitimate and the paralegal was on vacation.

**Predict:** Before writing anything, predict which of the three scope questions (origin, extent, timeline) the office can answer from a server log alone, and which one needs the application audit trail. Then predict what the office will not be able to prove if its log line prefix records only the timestamp and the role.

**Run:** Write the three scope questions as three sentences, each naming the exact evidence that would answer it and the column in that evidence you would read. Then write the two containment commands you would run in order, and beside each one name what it preserves.

**Explain:** In one or two sentences, explain why the office should copy the log file off the server before it changes anything. Then name one setting from Chapter 7 that could otherwise remove the evidence on its own.

### Try It Yourself 10.3: Contain the Clinic Login 🛠️

Sandwash Family Clinic's front desk lead, Grace Yazzie, reports that her password was in a phishing email reply she now regrets sending. Her login `clinic_gyazzie` reads the schedule and the patient directory. Tomas Reyes wants the account locked before the clinic opens, and Dr. Elena Vasquez, the data owner, wants to know exactly what it could reach. Both are reasonable and only one sequence satisfies them together.

Load `assets/code/chapter-10/setup-sandwash.sql`, which creates the clinic tables and the `clinic_gyazzie` login. No worked script follows. You write it.

**Predict:** Name your approach before you type. Which command closes the door without removing the account, which one closes a session already open, and which tempting command would answer Tomas while leaving Dr. Vasquez with nothing? Then predict what a verification query should return for each of the three things you need to prove: the login is shut, the grants survived, and no session is left.

**Run:** Contain the account, then write one verification pass that proves all three in a single reading. Your output should match the block below. The grant count is the number of tables the login could read. The session count is zero because a lab copy holds no live connection for that role.

```text
 sessions_closed
-----------------
               0

 can_still_log_in | surviving_grants | live_sessions
------------------+------------------+---------------
 f                |                3 |             0
```

**Explain:** In one or two sentences, explain what Dr. Vasquez can now be told that she could not have been told if you had dropped the role. Name the phase of the lifecycle you would be entering next.

### Quick Check 10.2 ✅

1. A colleague proposes dropping a compromised service account immediately. Name the two commands that contain the same risk, and state the specific question that dropping the role would make unanswerable.
2. Your log shows an export at 02:13 and your audit trail shows a grant three days earlier. Explain which one gives you the root cause and which one gives you the extent, and why a report needs both.
3. A forensic timeline reports first and last event times with no zone stated. Name two ways a reader could misread it, and the one column that removes the ambiguity.

---

## 10.3 Regulatory Obligations

Containment is done, the timeline is written, and now a different set of people take over. The question changes from "what happened" to "whom must we tell, and by when." Three bodies of law can apply to one database, and they are triggered by different facts. Chapter 4 taught who is regulated. This section teaches what a breach obliges them to do.

### HIPAA: A Clock That Starts at Discovery

The HIPAA Breach Notification Rule (45 CFR 164.400-414) applies to covered entities and their business associates, and it is triggered by a breach of **unsecured protected health information**. Sandwash Family Clinic is a covered entity. Copperwind, which hosts its database, is a business associate. Four facts drive the rest.

* **The presumption:** an impermissible use or disclosure of protected health information is presumed to be a breach. The presumption holds unless a risk assessment shows a low probability that the information was compromised (45 CFR 164.402).
* **The four risk factors:** what information was involved and how identifiable it is. Who received it. Whether it was in fact acquired or viewed. How far the risk has been mitigated.
* **The deadline:** individual notice goes out without unreasonable delay and no later than 60 days from discovery (45 CFR 164.404). The Secretary of Health and Human Services is notified at the same time when 500 or more people in a state are affected (45 CFR 164.408). Prominent media are notified as well at that threshold (45 CFR 164.406).
* **The encryption safe harbor:** information rendered unusable, unreadable, or indecipherable by the methods the Secretary specifies is not unsecured, and its breach requires no notification. Chapter 6 built that control on the clinic's insurance column.

Copperwind's own duty is narrower and comes first. A business associate notifies the covered entity, not the patients, and it does so without unreasonable delay and no later than 60 days after discovery (45 CFR 164.410). Your job in a clinic incident is to hand Dr. Vasquez a complete, dated, evidence-backed account. Hers is to decide what the patients hear.

### FERPA: No Clock, Two Other Duties

The Family Educational Rights and Privacy Act (34 CFR Part 99) governs the academy, and it contains no breach notification rule at all. There is no deadline, no audience, and no threshold. That absence surprises people, and it is the most useful fact in this section, because the absence of a FERPA notice is not the absence of an obligation.

Two FERPA duties land on this incident instead. First, the school must maintain a record of each request for and each disclosure of personally identifiable information from a student's education records (34 CFR 99.32(a)(1)). That record stays with the student's own records for as long as they exist. An unauthorized export is a disclosure the school did not intend, and every student in the attacker's file needs the entry.

Second, and more serious for Copperwind, a school must use reasonable methods to ensure school officials reach only the records in which they have a legitimate educational interest. It may meet that duty with technological access controls (34 CFR 99.31(a)(1)(ii)). Copperwind can be treated as a school official under that rule, because the academy outsourced a function to it and the three conditions in 34 CFR 99.31(a)(1)(i)(B) hold. A reporting account holding `SELECT` on every table is the opposite of a reasonable method. The Department of Education's enforcement reaches that far. A third party found to have improperly redisclosed personally identifiable information can be barred from access for at least five years (34 CFR 99.67(e)).

The Department also publishes a data breach response checklist for schools, which sets out the response components FERPA's own text leaves unwritten. Whether to notify families is a judgment call the data owner makes. Recording the disclosure is not optional.

### State Breach Laws Read Your Column List

State law is where the exact columns from Section 10.2 decide the answer. Arizona's statute is typical in shape. A person who owns or licenses computerized personal information must investigate a suspected incident, and on determining that a breach occurred must notify affected individuals within 45 days (A.R.S. 18-552(A) and (B)). Above 1,000 individuals, the Attorney General, the Arizona Department of Homeland Security, and the three largest consumer reporting agencies are added.

The trigger is the definition, not the headcount. Arizona defines **personal information** two ways (A.R.S. 18-551(7)). One is a first name or initial and last name combined with at least one **specified data element**. The other is an email address or username with the password that opens the account. The specified data elements are a short, closed list (A.R.S. 18-551(11)). It holds Social Security, driver license, passport, and taxpayer identification numbers. It also holds a private key, a financial account number with its access code, a health insurance identification number, medical or mental health treatment information, and biometric data.

Hold the academy's export against that list. Names, birth dates, term grades, guardian phone numbers, guardian email addresses. Not one of them is a specified data element, and no password left with the email addresses. Arizona's notification duty does not trigger. Change one column and the answer flips. Had the export reached `portal_accounts`, which pairs a username with a password hash, or had it been the clinic's `insurance_member_id`, the statute would apply at once.

Two more provisions belong in your notes. A person who merely *maintains* data owned by someone else must notify the owner as soon as practicable and cooperate with them (A.R.S. 18-552(C)). That is Copperwind's obligation to the academy, and it has no 45-day cushion. And the statute does not apply to HIPAA covered entities or business associates at all (A.R.S. 18-552(N)(2)), which is why the clinic scenario is a HIPAA question and never an Arizona one.

### The Decision Table

Reasoning out loud is how a decision like this gets defended. Encoding it is how it gets reviewed. Put the facts in one place, put each authority's trigger beside it, and let the join do the deciding:

```sql
-- Step 1: State the facts the evidence established, once, so every
--         rule is tested against the same reading of the incident
WITH incident AS (
  SELECT true  AS education_records,
         false AS health_information,
         false AS listed_personal_data,
         false AS eu_data_subjects
),
-- Step 2: Give each authority its trigger, its audience, its deadline,
--         and the citation a reviewer can look up without calling you
obligation (authority, triggered_by, notify, deadline, citation) AS (
  VALUES
    ('FERPA',   'education_records',    'record the disclosure for the student', 'at the time of disclosure',  '34 CFR 99.32'),
    ('HIPAA',   'health_information',   'individuals, HHS, media above 500',     '60 days from discovery',     '45 CFR 164.404'),
    ('Arizona', 'listed_personal_data', 'individuals and the Attorney General',  '45 days from determination', 'A.R.S. 18-552'),
    ('GDPR',    'eu_data_subjects',     'the supervisory authority',             '72 hours from awareness',    'GDPR Article 33')
)
-- Step 3: Match every rule against every fact and sort the live ones up
SELECT o.authority, o.notify, o.deadline, o.citation,
       CASE o.triggered_by
         WHEN 'education_records'    THEN i.education_records
         WHEN 'health_information'   THEN i.health_information
         WHEN 'listed_personal_data' THEN i.listed_personal_data
         WHEN 'eu_data_subjects'     THEN i.eu_data_subjects
       END AS triggered
FROM obligation o
CROSS JOIN incident i
ORDER BY triggered DESC, o.authority;
-- Output:
--  authority |                notify                 |          deadline          |    citation     | triggered
-- -----------+---------------------------------------+----------------------------+-----------------+-----------
--  FERPA     | record the disclosure for the student | at the time of disclosure  | 34 CFR 99.32    | t
--  Arizona   | individuals and the Attorney General  | 45 days from determination | A.R.S. 18-552   | f
--  GDPR      | the supervisory authority             | 72 hours from awareness    | GDPR Article 33 | f
--  HIPAA     | individuals, HHS, media above 500     | 60 days from discovery     | 45 CFR 164.404  | f
```

One rule fires and three do not, and the three that do not are as much a part of the answer as the one that does. A reviewer who asks "did you consider the state law" gets a row, a citation, and the fact that decided it. Write the table with the facts as a separate block, because when the investigation finds a fifth column in the export you change one boolean and not the whole argument.

### GDPR and CCPA: Two Different Shapes

Two more regimes get named in every compliance meeting, and they work nothing alike. Knowing the shape of each is enough for a database administrator.

The European **General Data Protection Regulation (GDPR)** puts a hard clock on the regulator. A controller notifies the supervisory authority without undue delay, and where feasible within 72 hours of becoming aware of a personal data breach (Article 33). The one exception is a breach unlikely to result in a risk to people. Data subjects are told when the risk to them is high (Article 34). Seventy-two hours is short enough that the timeline query has to already exist. It applies wherever the data subjects are in the European Union, whatever country the server sits in.

The **California Consumer Privacy Act (CCPA)** does the opposite. California's notification duty lives in a separate breach statute, not in the CCPA. What the CCPA adds is a private right of action (California Civil Code 1798.150). A consumer whose nonencrypted and nonredacted personal information is exposed by a failure to maintain reasonable security may sue. Statutory damages run from \$100 to \$750 per consumer per incident, or actual damages if those are greater. The exposure is a lawsuit, not a deadline, and the defense is evidence that your security was reasonable. That evidence is the access review, the log settings, and the drill record from the last three chapters.

Both regimes reward the same preparation. One asks how fast you can produce the timeline. The other asks what you can prove about the controls that were in place before the incident.

### Try It Yourself 10.4: Judge the Credit Union's Obligations 🛠️

A credit union's member database is copied by an intruder. The export held member first and last names, mailing addresses, account balances, and account numbers with the online banking passwords that open them.

**Predict:** Before checking anything, predict whether this export meets the Arizona definition of personal information, and name the specific element that decides it. Then predict whether HIPAA applies and say why in one clause.

**Run:** Build the decision table by hand with four rows: HIPAA, FERPA, the state breach law, and the GDPR. For each row write the trigger, the audience, the deadline, the citation, and a true or false verdict with the fact that produced it. Add a fifth row for any duty the credit union owes its regulator that this chapter did not name, and mark it as a question for counsel, not an answer.

**Explain:** In one or two sentences, explain how the verdict would change if the credit union had encrypted the account numbers and kept the keys elsewhere. Name the term for the provision that would apply.

### Quick Check 10.3 ✅

1. A school's export contained student names and term grades only. State what FERPA requires the school to do, what it does not require, and the citation for the duty that does apply.
2. Explain why a business associate's first notification goes to the covered entity and not to patients, and name the deadline that governs it.
3. Two incidents expose the same number of people. One export held names and birth dates, the other held names and health insurance identification numbers. Explain why only one triggers a state notification duty.

---

## 10.4 Recovery and After-Action

Recovery inside an incident is not the same exercise as the restore drill from Chapter 9, even though it uses the same tools. The drill assumed the data was lost. An incident asks a question first: was anything damaged at all? Answering that with evidence, before anyone touches a backup, is what keeps a confidentiality incident from becoming an availability incident too.

### Does This Incident Need a Restore?

A restore overwrites the current state of the database, which is also the state an investigator may need to examine. So you earn the restore. Two independent witnesses can answer the damage question here, and both are already loaded:

```sql
-- Witness one: the server log, for statements that could change data
SELECT COUNT(*) FILTER (WHERE message ~ '^statement: (INSERT|UPDATE|DELETE|ALTER|DROP)')
         AS write_statements,
       COUNT(*) FILTER (WHERE message LIKE 'statement:%') AS statements_logged
FROM server_log
WHERE pid = 51296;
-- Witness two: the audit trail, for rows the reporting role changed
SELECT COUNT(*) AS trail_rows_by_reporting_role
FROM academy_audit
WHERE db_user = 'academy_reports';
-- Output:
--  write_statements | statements_logged
-- ------------------+-------------------
--                 0 |                 3
--
--  trail_rows_by_reporting_role
-- ------------------------------
--                             0
```

Three statements ran and none of them could write. The audit trail holds no row change by the reporting account across three weeks. The academy's data is intact, so no restore is needed, and two witnesses say it more convincingly than one. This incident took confidentiality only. Recovery here means closing the opening and watching for a repeat, not rebuilding anything.

When a restore is needed, the timeline picks the backup. Chapter 9 taught you to restore the most recent good copy, and an incident narrows "good" to "taken before the intruder's first access." A backup made after the initial access reinstalls whatever they left behind. Here the first access was 2026-09-03 at 02:09:41 Mountain Standard Time, so any restore would start from the last copy taken before that instant. The forensic timeline is an input to the recovery decision, not only a report.

### Eradication: Close the Opening

Containment stopped the account. **Eradication** removes the condition that made the account worth attacking, which the timeline named as the August 30 grant. Undo it, then prove it is undone:

```sql
-- Close the opening the root cause left, then read the catalog back
REVOKE SELECT ON ALL TABLES IN SCHEMA public FROM academy_reports;
SELECT r.rolname AS role_name,
       r.rolcanlogin AS can_log_in,
       COUNT(g.table_name) AS table_privileges
FROM pg_roles r
LEFT JOIN information_schema.role_table_grants g
       ON g.grantee = r.rolname
WHERE r.rolname LIKE 'academy\_%'
GROUP BY r.rolname, r.rolcanlogin
ORDER BY r.rolname;
-- Output:
-- REVOKE
--     role_name    | can_log_in | table_privileges
-- -----------------+------------+------------------
--  academy_app     | t          |                9
--  academy_reports | t          |                0
```

The reporting role now holds zero table privileges while the application role keeps the nine it needs. The catalog says so, which is the only form of "done" that survives a review. Notice what the same query also reports. `academy_reports` still shows `can_log_in` as true, because eradication removed the privilege and not the account. That is the next decision and it belongs to a person, not a script. Lock it, rotate its password, or retire it once the board report has a supported home. Skills Lab 10A asks you to make the call and defend it. Eradication rarely stops at one command either. Three remaining items each trace to evidence. Rotate the reporting password, add `%h` to `log_line_prefix` so failures carry an address, and alert when failed logins for one role cross a threshold. Chapter 11 puts that last one on a schedule.

### The After-Action Report

The **after-action report** is the deliverable of the last phase, and it is the only part of incident response that changes the future. Write it while the details are fresh. Seven sections cover it, and the shipped template `assets/code/chapter-10/after-action-report-template.md` carries all seven.

| Section | What goes in it | The test it must pass |
| --- | --- | --- |
| Summary | What happened, in five sentences a board member can read | No jargon, no blame, no speculation |
| Timeline | Every event with its instant and its evidence source | A stated time zone on every row |
| Scope | Which tables, which columns, how many people | Column names, not categories |
| Root cause | The condition without which this could not happen | Names a decision, not a person |
| What worked and what did not | Controls that held and controls that were absent | At least one of each |
| Action items | Owner, due date, and how it will be verified | No item without an owner and a date |
| Notification record | Every authority considered, triggered or not | The fact that decided each verdict |

The last row is where most reports fail. "Improve access reviews" is a wish. "Naomi Redhouse reviews every role holding `SELECT` on all tables, quarterly, evidence pasted into the review record" is an **action item**. The difference is whether the next reviewer can tell if it happened. The fifth row hides a second trap. Write what worked, because this incident was reconstructed to the second only because statement logging was on and the audit trail recorded privilege changes. A report that lists failures alone teaches an organization that good work is invisible.

### Try It Yourself 10.5: Write the Bike Shop's Action Items 🛠️

A bike shop's point-of-sale database was reached through a vendor support account that still had a default password and full read access. The shop restored from a backup taken two days after the vendor account was first used, and the intruder returned a week later.

**Predict:** Before writing anything, predict which phase of the lifecycle the shop got wrong, and predict which single fact from a forensic timeline would have prevented the second intrusion.

**Run:** Write four action items for the shop's after-action report. Each one names the owner, a due date expressed as a number of days after the report, and the evidence that would prove it was done. At least one must address the restore point and at least one must address the account.

**Explain:** In one or two sentences, explain why restoring from a backup taken after the first unauthorized access reinstalled the problem, and name the section of the report that should have caught it.

### Quick Check 10.4 ✅

1. An administrator restores a database immediately after discovering an intrusion. Name two things that decision can cost, and state the one question the evidence should have answered first.
2. You must choose a backup to restore after a breach. State the rule for picking it, and name the artifact from Section 10.2 that tells you which copy qualifies.
3. Read this action item: "Tighten permissions on reporting accounts." Rewrite it so it passes the test in the after-action table, and name what you added.

---

## 10.5 Summary and Retrieval 💡

### Key Concepts

* An event becomes a security incident when it threatens confidentiality, integrity, or availability, and becomes a breach when protected data was acquired or disclosed. The label follows the evidence, and only the last one starts legal clocks.
* The response lifecycle runs preparation, detection and analysis, containment, eradication, recovery, and lessons learned. Preparation is finished before the incident starts, and it is what makes the other five phases take hours instead of weeks.
* Scope analysis asks where the incident came from, how far it reached, and when it ran. The server log answers origin and extent, the audit trail answers root cause, and a merged timeline puts both instruments on one clock. That timeline is meaningless until it states its zone. Comparing a `timestamptz` against a naive string makes the session's zone a silent filter, and the report can miss the incident without raising an error.
* Containment stops the harm without erasing how it happened. `ALTER ROLE ... NOLOGIN` plus `pg_terminate_backend()` closes the door and keeps the account, its grants, and its ownership readable. `DROP ROLE` answers the same question and destroys the answer to the next one.
* HIPAA presumes a breach and gives 60 days from discovery, with encryption as the way out. FERPA sets no notification clock but requires a disclosure record and reasonable access controls. State breach laws are triggered by a closed list of data elements, so the exported column names decide the answer.
* Recovery inside an incident starts by proving whether anything was damaged. When a restore is needed, the timeline picks the copy, which must predate the first unauthorized access. The after-action report closes the loop, and every action item carries an owner and a date.

### Key Terms

See course glossary for full definitions

* event, security incident, breach, incident response plan, incident commander (Section 10.1)
* scope analysis, root cause, forensic timeline, containment (Section 10.2)
* unsecured protected health information, encryption safe harbor, personal information, specified data element, General Data Protection Regulation (GDPR), California Consumer Privacy Act (CCPA) (Section 10.3)
* eradication, after-action report, action item (Section 10.4)

### Retrieval Practice

1. From memory, name the six phases of the incident response lifecycle in order, and state the exit test for containment.
2. State the two commands that contain a compromised PostgreSQL login without destroying evidence, and name the one thing each of them preserves that `DROP ROLE` does not.
3. A breach exposed student names, birth dates, and grades in Arizona. State what FERPA requires, what the state statute requires, and the fact that decides the second answer.
4. From Chapter 8: Name the copies of a database that redundancy creates, and explain what each one adds to the scope question when a breach is investigated.
5. From Chapter 6: State what encryption at rest would change about a breach notification decision, and name the one condition that has to hold for it to matter.

---

## 10.6 Skills Lab 10A: The Harquahala Breach

**Goal:** Work the academy breach end to end. Reconstruct it from the shipped evidence, contain the compromised account without destroying the trail, decide the notification obligations with citations, and write the after-action report that Naomi Redhouse and Principal Whitfield will both sign.

**Dataset or starter files:** `assets/code/chapter-10/` in the course data pack. `setup-harquahala.sql` rebuilds `harquahala_academy` in the state the academy's server was in on the morning of the incident, including the reporting login and the August 30 grant. `postgresql-2026-09-03.log` is the server log and `academy_audit_trail.csv` is the application audit trail. `after-action-report-template.md` is the report skeleton. `skills-lab-10a.sql` is the starter script with numbered markers, and `skills-lab-10a-answers.md` holds the written work. The academy and every record in it are fictional.

### Part 1: Foundation (Aligns with Objective 10.2)

1. From the extracted `cis376` folder, run `setup-harquahala.sql` as `postgres`. Under marker 1.1, load the audit trail and the server log into tables, declaring the evidence time zone as you do. Paste the row counts and the date range of each.
2. Under marker 1.2, answer the three scope questions. Produce the failed-login summary, the intruder's session with its source address, and the statements that ran, with the exported column list pulled out of each one.
3. Under marker 1.3, measure the exposure. Count the guardians whose contact details were in the first export. For the second export, count the grade rows, the distinct students, and how many of those students have `directory_opt_out` set to true. In the answer file, state the elapsed time from the grant to the first export.

### Part 2: Application (Aligns with Objectives 10.1 and 10.2)

1. Under marker 2.1, produce the merged timeline from both sources, ordered, with the report's time zone as a column. Under marker 2.2, contain the compromised account and prove three things: the login is shut, no session survives, and the account's privileges are still readable.
2. Under marker 2.3, decide whether the incident needs a restore and prove your answer with two independent witnesses. Then eradicate the root cause and read the catalog back to show it is closed.
3. In the answer file, write the incident response plan you would follow for a repeat of this exact scenario, six steps with an owner and an exit test for each. Add one paragraph naming what the log could not prove and how you would close that gap.

### Part 3: Extension (Aligns with Objectives 10.1 and 10.3)

1. Under marker 3.1, build the notification decision table for this incident. Use the exported column list from Part 1 as your facts, and give every row a citation. Paste the result.
2. In the answer file, write the notification memo for Principal Whitfield in plain language. State what was taken, what the law requires, what it does not require, and what you recommend the academy do anyway. Name Copperwind's own obligation to the academy and its deadline.
3. Fill in `after-action-report-template.md` completely. Every action item names an owner, a due date, and the evidence that would prove it was done. Include at least one control that worked.

### Questions & Analysis 🤔

1. Using your Part 1 numbers and Part 3 citations as evidence, explain why this incident produces a FERPA duty and no state notification duty. Then name the single column that would have reversed that answer had it been in the export, and say why.
2. Your Part 2 containment kept the compromised account. Defend that choice to an office manager who wanted it deleted before opening, using something you were able to report because the account survived. Then state the one circumstance in which deleting it would have been the right call.

**Submission:** Submit one folder named `skills-lab-10a-lastname`. It holds `skills-lab-10a.sql` with every result pasted as `-- Output:` comment lines (or the saved psql output beside it). It also holds `skills-lab-10a-answers.md` with the response plan, the notification memo, and your two Questions & Analysis answers clearly labeled, plus your completed `after-action-report-template.md`.

### Rubric: Skills Lab 10A

This lab is graded with the standard
[Skills Lab Rubric](../skills-lab-rubric.md): four criteria, five
levels from Mastery to Not Evident. The criteria are Technical
Accuracy and Efficiency, Output Quality, Documentation Quality, and
Analysis, Interpretation, and Response to QUESTION(s). The criteria
and levels are the same everywhere. Your instructor sets the point
values in your course. Check the syllabus and the Canvas rubric
attached to this lab for the values that apply to you.

---

## 10.7 Review Questions 🔄️

1. **Apply:** A food bank finds that a volunteer account was used from an unfamiliar address at 3 a.m. Write the containment step by step for a PostgreSQL server, naming each command, what it stops, and what it preserves. Then name the one command you would refuse to run and explain what it would cost.

2. **Analyze:** A server log shows 60 failed logins for one role ending at 01:40 and a successful login for the same role at 04:12 from an address the failures do not name. State what the evidence supports, what it does not support, and the one logging setting that would close the gap.

3. **Evaluate:** A clinic and a school each lose a file holding names and dates of birth for 900 people. Judge the notification obligations for each organization, name the citation behind each verdict, and explain why the same data produces different duties.

4. **Create:** Design the detection half of an incident response plan for the academy. Name three signals worth alerting on, the query or log setting that produces each, the threshold that fires it, and who receives it. For each signal state what the alert would have changed about the timeline in this chapter.

---

## Further Reading 📖

* [HHS: Breach Notification Rule](https://www.hhs.gov/hipaa/for-professionals/breach-notification/index.html) - The Department of Health and Human Services summary of 45 CFR 164.400-414, including the four-factor risk assessment and the encryption relief this chapter applies.
* [45 CFR Part 164, Subpart D: Notification in the Case of Breach of Unsecured Protected Health Information](https://www.ecfr.gov/current/title-45/subtitle-A/subchapter-C/part-164/subpart-D) - The rule itself, with the individual, media, Secretary, and business associate notification sections.
* [ED Student Privacy: Data Breach Response Checklist](https://studentprivacy.ed.gov/resources/data-breach-response-checklist) - The Department of Education's breach response components for schools, which fills the gap FERPA's own text leaves.
* [NIST SP 800-61 Rev. 3: Incident Response Recommendations and Considerations](https://csrc.nist.gov/pubs/sp/800/61/r3/final) - The current federal incident response guidance, which maps response work onto the Cybersecurity Framework functions.
* [Arizona Revised Statutes 18-552: Notification of Security System Breaches](https://www.azleg.gov/ars/18/00552.htm) - One state's breach statute end to end, including the 45-day deadline, the maintainer duty, and the HIPAA exception this chapter reads.
* [PostgreSQL Documentation: Date/Time Types](https://www.postgresql.org/docs/17/datatype-datetime.html) - How `timestamptz` stores an instant and how the session time zone decides what a naive string means, which is the mechanism behind Fix It 10.1.

---

## Looking Ahead ⏩

You can now work an incident from evidence: reconstruct it, contain it without erasing the trail, decide what the law requires, and write the report that changes the plan. Chapter 11 takes the same instruments off the emergency footing and puts them on a calendar. You will build the scheduled review that reads logs and catalog views every month, measure the server against a published benchmark, and prove an improvement with numbers. The action items you wrote today are exactly what that routine is for.
