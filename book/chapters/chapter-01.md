# Chapter 1: Database Management and Security Fundamentals

A clinic's front desk cannot see this morning's schedule. A school registrar gets an email saying a parent found another family's phone number in the portal. A managed services firm learns at 2 a.m. that someone guessed the password on a reporting account and pulled a customer list. None of these stories starts with a bad query. Each one starts with a decision nobody made: who owns this data, who may touch it, and who is watching.

You already know how to ask a database a question. In your SQL course you wrote joins, aggregates, and CREATE TABLE statements, and the database answered. This course asks what happens around that query. Who is allowed to run it? What does the result expose? How fast does it need to return, and what happens when the server it runs on fails? The district's course outcomes for CIS376 are management and security outcomes. SQL is the tool you bring with you, not the subject you are here to learn.

This chapter gives you the job. You take on the role of database administrator for Copperwind IT Services, a fictional managed services provider in Phoenix that hosts databases for two regulated clients. You will sort out who is responsible for what in a database environment and apply the CIA triad to the threats a database faces. You will install PostgreSQL and its tools and load the three databases you will manage all book long. Then you will learn the management lifecycle that organizes the eleven chapters ahead.

## Module Overview 🧭

* **Estimated time:** 5-6 hours, including the PostgreSQL install
* **Prerequisites:** One prior SQL course (Introduction to Oracle: SQL, CIS276DA MySQL Database, or CIS276DB SQL Server Database). No chapter dependencies. This is the first chapter.
* **Deliverables:** Skills Lab 1A folder (`skills-lab-1a.sql` and `skills-lab-1a-answers.md`), Quick Checks

## Learning Objectives 🎯

By the end of this chapter, you will be able to:

* **1.1 (Analyze):** Distinguish the responsibilities of a database administrator, a security administrator, and a data owner across the functions of a DBMS (Section 1.1)
* **1.2 (Apply):** Apply the CIA triad to classify database threats and match each to the control family that addresses it (Section 1.2)
* **1.3 (Apply):** Install PostgreSQL, psql, and pgAdmin, load the course databases, and run a baseline health check on a server you manage (Section 1.3)

### This chapter aligns with the following Course Learning Outcomes

* **CLO I (Analyze):** Analyze database architecture and design for business solutions.
* **CLO II (Evaluate):** Assess security management for database environments.
* **CLO V (Evaluate):** Critique current practices and future trends of database management and security.

---

## 1.1 The Management View of a DBMS

In your SQL course, the database management system was the thing that ran your queries. From the management side it looks different. A **database management system (DBMS)** is the software that stores data, enforces the rules about that data, controls who may reach it, and keeps it available when hardware and people fail. PostgreSQL, Oracle Database, MySQL, and Microsoft SQL Server are all DBMS products. You used one of the last three. This book uses the first, and Section 1.3 explains why.

Every DBMS performs the same core functions, whatever its vendor:

| Function | What it does | Why a manager cares |
| --- | --- | --- |
| Storage management | Writes data to disk and reads it back | Capacity, cost, and speed |
| Query processing | Parses, plans, and runs SQL | Performance and predictability |
| Transaction management | Groups changes so they all succeed or all fail | Correct data under concurrent use |
| Integrity enforcement | Applies constraints and types | The database refuses bad data |
| Access control | Authenticates connections and authorizes actions | Who may see or change what |
| Logging and auditing | Records what happened | Evidence for reviews and incidents |
| Backup and recovery | Copies data and restores it | Survival when something breaks |

Read the right-hand column again. Every row is a management decision before it is a technical one. How much capacity do we buy? How fast must the schedule query return? Who is allowed to see a patient's diagnosis? How long do we keep logs? A database administrator makes some of these calls, recommends others, and carries out the rest. Knowing which is which is the first skill in this course.

### Who Is Responsible for What

Database work fails most often at the seams between people, so start by naming the people. Five roles appear in nearly every organization, even when one person wears several hats:

* **Database administrator (DBA):** installs, configures, monitors, backs up, tunes, and recovers the DBMS. The DBA implements access decisions and proves they took effect. In small organizations the DBA is also the security administrator.
* **Security administrator:** sets the access policy, reviews who holds which privileges, monitors logs for misuse, and leads the response when a control fails. This role asks the DBA for evidence and signs off on it.
* **Data owner:** the business leader accountable for a dataset. A clinic's medical director owns patient records. A school principal owns student records. The data owner decides who has a legitimate need to see the data. The DBA never makes that decision alone.
* **Developer:** writes the applications and queries that use the database. Developers request privileges. They should not grant them to themselves.
* **Auditor:** an internal or external reviewer who checks that policy, configuration, and evidence agree. Auditors do not change anything. They ask for proof.

The line that matters most runs between the data owner and the DBA. The owner decides *who should* see the data. The DBA configures *who can* see it and shows the owner that the two match. When those two lists drift apart, you have a security problem even if no attacker ever shows up.

**Separation of duties** is the principle behind these boundaries. No single person should be able to request access, grant it, use it, and erase the record of having done so. When one person holds all four powers, mistakes go unnoticed and misuse goes unproven. Later chapters turn this principle into configuration. This chapter only asks you to see it.

### The Job You Are Taking

For the rest of this book you are the database administrator at Copperwind IT Services. Copperwind is a fictional managed services provider in Phoenix with about 30 employees, two support teams, and roughly 40 client companies across the Valley. In 2025 it added a Data Services practice that hosts and manages databases for clients too small to employ a DBA of their own. Mei Lin leads Data Services and is your manager. Naomi Redhouse is the security lead who reviews your access work. Ethan Cole runs backups and the on-call rotation. You meet the clients in Section 1.3.

### Try It Yourself 1.1: Who Decides? 🛠️

**Predict:** A developer at a law office asks you, the DBA, to give the new billing application read access to every table in the case management database. Before reading on, write down which of the five roles should answer each question: Should billing see client notes at all? How is that access configured? Was it configured correctly? Did anyone misuse it afterward?

**Run:** Build a four-row table on paper or in a text file with the columns Question, Role that decides, Role that carries it out, and Role that verifies. Fill every cell from the five roles above.

**Explain:** In one or two sentences, explain what goes wrong if the DBA answers the first question alone. Name the principle that the answer violates.

### Quick Check 1.1 ✅

1. A school's registrar can create teacher accounts, grant those accounts access to grades, and delete the log that records the grants. Name the principle this arrangement violates and state which of the three powers you would move to another role first.
2. Match each DBMS function to the management question it answers: transaction management, logging and auditing, backup and recovery. Choose from "What happened last night?", "Can two clerks book the same room?", and "How long until we are running again?"
3. Explain in your own words why the data owner, not the DBA, decides who may see a patient's diagnosis.

---

## 1.2 The CIA Triad Applied to Databases

Security conversations need a shared vocabulary, and the oldest one still works. The **CIA triad** names the three properties every protected system must preserve: **confidentiality**, **integrity**, and **availability**. Every threat to a database attacks at least one of the three, and every control defends at least one. When you can name which property a threat attacks, you can usually name the control that answers it.

### Confidentiality

Confidentiality means only authorized people and programs can read the data. For a database, the reading happens through queries, exports, backups, log files, and network traffic, and a leak through any of those channels is a confidentiality failure. Common threats:

* An account holds more privileges than its job needs and someone uses them.
* A backup file sits on a shared drive where anyone can copy it.
* A query travels across the network unencrypted and a listener captures it.
* An application concatenates user input into SQL and an attacker injects a query that dumps a table.

Controls that answer these threats: least-privilege access (Chapter 5), encryption at rest and in motion (Chapter 6), separation of sensitive columns behind schemas and views (Chapter 4), and parameterized queries (Chapter 9). **Least privilege** is the rule that every account gets the minimum access its work requires and nothing more. You will apply it in nearly every chapter.

### Integrity

Integrity means the data is correct and complete, and changes to it are authorized and recorded. A database loses integrity when a clerk types a birth date in the future or when two updates collide and one is lost. It loses integrity when an application bug doubles every invoice, or when an attacker edits a grade. Threats to integrity often make no noise at all. Wrong data sits quietly until someone acts on it.

Controls: constraints and transactions that make bad data impossible to store (Chapter 3). Audit trails that record who changed what (Chapter 7). Backups you can restore to a known-good point in time (Chapter 9).

### Availability

Availability means authorized users can reach the data when they need it. A clinic that cannot open its schedule at 7 a.m. has a security incident even though nothing leaked. Threats to availability include hardware failure, a full disk, a runaway query that starves every other connection, a ransomware attack that encrypts the data files, and a mistaken `DROP TABLE` with no backup.

Controls: capacity planning (Chapter 2), performance tuning (Chapter 8), redundancy and replication (Chapter 8), disaster recovery plans with tested restores (Chapter 9), and incident response that contains damage quickly (Chapter 10).

### From Threat to Control

Here is the thinking pattern this book asks of you, as a table you can reuse. A **threat** is anything that could violate one of the three properties. A **control** is a safeguard that reduces the likelihood or the impact of a threat. Controls come in families, and naming the family is often enough to know which chapter holds the answer.

| Threat | Property attacked | Control family | Chapter |
| --- | --- | --- | --- |
| Over-privileged reporting account | Confidentiality | Access control | 5 |
| Unencrypted backup on a shared drive | Confidentiality | Encryption, retention | 6, 9 |
| Two schedulers book the same slot | Integrity | Transactions, constraints | 3 |
| Silent grade edit by a staff account | Integrity | Auditing | 7 |
| Disk fills during month-end reports | Availability | Capacity planning, monitoring | 2, 11 |
| Ransomware encrypts the data directory | Availability | Backups, recovery, response | 9, 10 |

Regulation adds a fourth column you cannot skip. When the data is health information, HIPAA names the safeguards a covered entity must have. When it is student records, FERPA names who may see them. Chapter 4 covers both. For now, notice that the regulations are written in the language of this triad: they require confidentiality of protected data, integrity of records, and availability of the systems that hold them.

### Try It Yourself 1.2: Classify Five Threats 🛠️

**Predict:** For each event below, decide which CIA property it attacks first. Some attack two. Commit to your answers before you check them against the table above.

* A front-desk clerk at a clinic can see every patient's diagnosis code, not only the appointment list.
* A school's student information system is offline on the first day of registration.
* A report shows 1,800 open tickets when the true number is 900 because a nightly job ran twice.
* A former employee's account still logs in every Sunday night.
* A server's disk is 97 percent full and growing.

**Run:** Write each event in a table with three columns: Property attacked, Control family, and the chapter you expect to answer it. Use the table in this section as your key.

**Explain:** Pick the one event you found hardest to classify and explain in one or two sentences why it attacks the property you chose rather than the other candidate.

### Quick Check 1.2 ✅

1. Name the CIA property that a ransomware attack violates first, and the property it violates second if the attackers also copy the data before encrypting it.
2. A database enforces a rule that no appointment can be scheduled in the past. Which property does that rule protect, and which control family does it belong to?
3. Explain why an outage is a security incident even when no data leaked.

---

## 1.3 Your Lab Environment: PostgreSQL, psql, and pgAdmin

You cannot manage a database you cannot touch, so this section puts a server under your control. Every hands-on task in this book runs on **PostgreSQL**, a free, open-source DBMS that runs on Windows, macOS, and Linux. PostgreSQL was chosen for this course because everything the outcomes ask you to manage exists in it and costs nothing. That list includes roles and privileges, row-level security, column encryption, TLS connections, statement logging, backups, replication, and execution plans. What you learn transfers. Oracle, MySQL, and SQL Server all have equivalents for each control you will configure.

### Installing PostgreSQL 17

Download the PostgreSQL 17 installer for your operating system from the PostgreSQL download page (linked under Further Reading) and run it. The installer asks a few questions. Answer them this way:

1. Install the PostgreSQL Server, the command line tools, and pgAdmin 4. Leave Stack Builder unchecked.
2. Accept the default data directory and port 5432.
3. When the installer asks for a password for the `postgres` superuser, choose one you can remember and write it down in a password manager. Every setup script in this book connects as `postgres`.
4. On macOS you may instead install with Homebrew (`brew install postgresql@17`) or Postgres.app. Either works. Note where the `psql` binary lands so you can run it from a terminal.

When the install finishes, open a terminal (Command Prompt or PowerShell on Windows, Terminal on macOS) and confirm the client tool is on your path:

```bash
psql --version
```

You should see `psql (PostgreSQL) 17.x`. If the command is not found on Windows, add the PostgreSQL `bin` folder (usually `C:\Program Files\PostgreSQL\17\bin`) to your PATH and open a new terminal.

### Two Clients, One Server

You will talk to your server through two clients. **psql** is PostgreSQL's command-line client. Every script in this book runs through it, and every output you will paste into a lab came from it. **pgAdmin** is the graphical client the installer added. It is good for browsing tables, reading execution plans, and checking a role's privileges without typing. Use both. Use psql when you want a repeatable script and pgAdmin when you want to look around.

If you came from Oracle, psql plays the role SQL*Plus played. From MySQL, it replaces the `mysql` client. From SQL Server, it replaces `sqlcmd`, and pgAdmin stands in for SQL Server Management Studio. Three more vocabulary bridges will save you confusion:

* A PostgreSQL **role** is both a user and a group. A role that can log in is what MySQL and SQL Server call a user. A role that cannot log in but holds privileges is a group. Chapter 5 builds on this.
* A PostgreSQL **cluster** is one running server that holds many databases. Each database holds schemas, and each schema holds tables. Oracle users: a PostgreSQL schema behaves much like an Oracle schema. SQL Server users: a PostgreSQL database with its schemas maps to a SQL Server database.
* Commands that begin with a backslash, such as `\l` or `\dt`, are psql **meta-commands**. They are instructions to the client, not SQL, and they will not run in pgAdmin's query tool.

!!! tip "Keep a command log from day one"
    Open a plain text file named `copperwind-notes.md` and paste every command you run as an administrator, with the date and a one-line reason. Auditors ask "who changed this and why," and a DBA who can answer from notes is trusted with more. The Skills Labs in this book expect the same habit, one script and one answer file per lab.

Connect to your server as the superuser to prove the install works:

```bash
psql -U postgres -d postgres -h localhost
```

Enter the password you chose during the install. The prompt changes to `postgres=#`. The `#` tells you that you are connected as a **superuser**, a role that bypasses every permission check. You will use the superuser to build things in this chapter and then step away from it. Working as superuser all day is the database equivalent of running every program as an administrator.

### A First Look in pgAdmin

Open pgAdmin. The first launch asks you to set a master password, which protects the connection passwords pgAdmin stores for you. Then register your server:

1. Right-click Servers in the left pane and choose Register, then Server.
2. On the General tab, name it `Copperwind Lab`.
3. On the Connection tab, enter `localhost` as the host, `5432` as the port, `postgres` as the username, and the superuser password. Save.

Expand the new server and its Databases node. You will see the `postgres` maintenance database and, after the next subsection, the three course databases. Every object you create from psql appears here after a refresh, and every privilege you grant in Chapter 5 is readable from an object's Properties panel. Treat pgAdmin as the window and psql as the keyboard.

### Meet the Organizations You Manage

Three databases arrive in this chapter's data pack, one for each organization you manage at Copperwind.

**Copperwind IT Services** keeps its own operations in `copperwind_ops`. It holds 40 clients, 8 technicians, and about 18,000 support tickets from January 2024 through June 2026. It also holds the notes on those tickets and a table of login events on the Copperwind server. This is the database you will size, tune, back up, and audit.

**Sandwash Family Clinic** is a fictional primary care clinic in west Phoenix with 12 providers and about 600 patients. Its database, `sandwash_clinic`, holds providers, patients, appointments, visit notes, and staff accounts. The clinic is a HIPAA covered entity, and Dr. Elena Vasquez, its medical director, is the data owner. Tomas Reyes manages the office and Grace Yazzie leads the front desk.

**Harquahala Charter Academy** is a fictional K-8 charter school in the west Valley with about 800 students, 1,200 guardians, and 60 staff. Its database, `harquahala_academy`, holds students, guardians, staff, courses, sections, enrollments, grades, and parent portal accounts. FERPA governs these records. Principal Dana Whitfield is the data owner and Luis Ortega is the registrar.

All three organizations and every record in their databases are fictional. The data was generated for this textbook.

### Loading the Course Databases

Download the course data pack from Canvas and extract it. Keep the extracted folder named `cis376` and run every command in this book from inside it. That way the relative file paths in the setup scripts work exactly as printed. From a terminal in the `cis376` folder, run the three setup scripts:

```bash
psql -U postgres -d postgres -h localhost -f assets/code/chapter-01/setup-copperwind.sql
psql -U postgres -d postgres -h localhost -f assets/code/chapter-01/setup-sandwash.sql
psql -U postgres -d postgres -h localhost -f assets/code/chapter-01/setup-harquahala.sql
```

Each script creates its database if it does not exist, connects to it, creates the tables, and loads them from CSV files with the `\copy` meta-command. The scripts are safe to rerun. Each one drops and rebuilds its own tables, so a later chapter can always hand you a clean copy.

Open the Copperwind script and read it before you trust it. That habit matters more in this course than in your SQL course, because scripts you run as superuser can do anything. Here is the shape of every setup script, with the decisions named:

```text
-- Step 1: Create the database only if it is missing, then move into it
SELECT 'CREATE DATABASE copperwind_ops'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'copperwind_ops') \gexec
\connect copperwind_ops

-- Step 2: Drop the chapter's own tables so a rerun starts clean
DROP TABLE IF EXISTS login_events, ticket_notes, tickets, technicians, clients CASCADE;

-- Step 3: Create parents before children so foreign keys can resolve
CREATE TABLE clients (...);
CREATE TABLE technicians (...);
CREATE TABLE tickets (... REFERENCES clients ..., ... REFERENCES technicians ...);

-- Step 4: Load in the same parent-first order
\copy clients FROM 'assets/code/data/copperwind/clients.csv' WITH (FORMAT csv, HEADER true)
\copy tickets FROM 'assets/code/data/copperwind/tickets.csv' WITH (FORMAT csv, HEADER true, NULL '')

-- Step 5: Refresh planner statistics so the first queries run well
ANALYZE;
```

Step 3 and Step 4 share a reason. The database enforces the foreign keys as rows arrive, so children loaded before their parents are rejected. You will meet that rejection on purpose in Chapter 3.

Now connect to the Copperwind database and confirm the load:

```sql
\connect copperwind_ops
SELECT COUNT(*) AS ticket_count
FROM tickets;
-- Output:
--  ticket_count
-- --------------
--         18240
```

The count is the first number you will trust from this server, and it came from a query, not from the script's promise. That is the habit: configuration without verification is a guess.

### Your First Baseline

A **baseline** is a measurement you take when a system is healthy so you can tell later when it is not. Before you change anything on a server you inherit, you record how big it is, what version it runs, and who can log in. Copperwind's first baseline takes one query per database. Start with the one you are connected to:

```sql
-- Step 1: Name the database so the report is self-describing
-- Step 2: Measure its total size, formatted for humans
-- Step 3: Record the server version the measurement was taken on
SELECT current_database() AS database_name,
       pg_size_pretty(pg_database_size(current_database())) AS total_size,
       split_part(current_setting('server_version'), ' ', 1) AS server_version;
-- Output:
--  database_name  | total_size | server_version
-- ----------------+------------+----------------
--  copperwind_ops | 14 MB      | 17.11
```

Your version number will differ if your installer shipped a different minor release. The size will match closely, because the data is the same. Next, find out which tables carry that size. The system catalog holds the answer. `pg_class` lists every table and index, and `pg_total_relation_size()` adds a table's indexes and overflow storage to its own pages:

```sql
SELECT relname AS table_name,
       pg_size_pretty(pg_total_relation_size(oid)) AS total_size
FROM pg_class
WHERE relkind = 'r'
  AND relnamespace = 'public'::regnamespace
ORDER BY pg_total_relation_size(oid) DESC;
-- Output:
--   table_name  | total_size
-- --------------+------------
--  ticket_notes | 2848 kB
--  tickets      | 2624 kB
--  login_events | 1336 kB
--  clients      | 32 kB
--  technicians  | 32 kB
```

Two tables hold most of the data, and the ticket notes outweigh the tickets themselves. File that fact away. Chapter 2 asks you to project how fast those two tables will grow.

Finally, list who can log in. This is the question the security lead will ask you first:

```sql
SELECT rolname AS role_name,
       rolsuper AS is_superuser,
       rolcanlogin AS can_login
FROM pg_roles
WHERE rolname NOT LIKE 'pg\_%'
ORDER BY rolname;
-- Output:
--  role_name | is_superuser | can_login
-- -----------+--------------+-----------
--  postgres  | t            | t
```

On a fresh install the only login role is the superuser you created. Copperwind's real server would list its application accounts, its technicians, and any leftover accounts from people who have moved on. That last group is the one you look for. Section 1.2 named it as a confidentiality threat, and Chapter 5 shows you how to remove it.

### Try It Yourself 1.3: Baseline the Clinic 🛠️

**Predict:** The clinic database holds 600 patients and 6,000 appointments against Copperwind's 18,240 tickets and 28,000 notes. Before you run anything, write down whether you expect `sandwash_clinic` to be larger or smaller than `copperwind_ops`, and by roughly what factor.

**Run:** Connect to the clinic database and run the same three baseline queries: total size, per-table sizes, and login roles. Compare the size against your prediction.

```sql
\connect sandwash_clinic
SELECT current_database() AS database_name,
       pg_size_pretty(pg_database_size(current_database())) AS total_size;
-- Output:
--   database_name  | total_size
-- -----------------+------------
--  sandwash_clinic | 9782 kB
```

**Explain:** In one or two sentences, explain why a database with one tenth of the rows is not one tenth of the size. Name at least one thing besides your rows that occupies space in a database.

### Try It Yourself 1.4: Translate Your Old Habits 🛠️

**Predict:** Write down the command you used in your prerequisite course to list the tables in a database (`SHOW TABLES` in MySQL, `SELECT table_name FROM user_tables` in Oracle, or `sp_tables` in SQL Server). Then predict whether that same command will work in psql, and what will happen if it does not.

**Run:** In psql, connected to `harquahala_academy`, run your old command and read the response. Then run the psql equivalents and a standard SQL equivalent that works on every DBMS:

```sql
\connect harquahala_academy
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
-- Output:
--     table_name
-- -------------------
--  courses
--  enrollments
--  grades
--  guardians
--  portal_accounts
--  sections
--  staff
--  student_guardians
--  students
```

**Explain:** In one or two sentences, explain why the `information_schema` query is the one worth memorizing when you move between database products.

### Fix It 1.1: The Database That Was Not There 🔧

Your first Copperwind script stops before it does anything, and the error message tells you exactly why if you read it to the end.

**Symptom:** You try to connect to the operations database and psql refuses.

```text
psql -U postgres -h localhost -d copperwind
```

```text
psql: error: connection to server at "localhost" (127.0.0.1), port 5432 failed: FATAL:  database "copperwind" does not exist
```

**Diagnose:** Before you touch anything, state the cause in one sentence. The message names a host, a port, and a database. The server answered, so which of the three is wrong?

**Repair:** Connect to the maintenance database `postgres` and list the databases that exist with the `\l` meta-command. Then reconnect with the exact name you find. State what you changed.

**Verify:** How do you know the fix worked? Name the prompt you expect to see and the one query from this section that proves you are in the right database.

### Quick Check 1.3 ✅

1. A teammate says the `postgres` role is convenient and wants to build the clinic application on it. Name the property of a superuser that makes this a bad idea and the principle from Section 1.2 it violates.
2. You ran `\dt` in pgAdmin's query tool and it failed. Explain why in one sentence.
3. Explain what a baseline is for, and name the three measurements this section took.

---

## 1.4 The Management Lifecycle This Book Follows

Eleven chapters remain, and they follow the order a database manager works in. The five stages below are the map. Every later chapter names its stage in its opening paragraphs, and Chapter 12 asks you to write a plan that walks through all five for one organization.

| Stage | The question it answers | Chapters | CLOs |
| --- | --- | --- | --- |
| Plan | What are we building, where does it run, and what shape is the data? | 1, 2, 3 | I |
| Secure | Who may see what, and how do we prove it? | 4, 5, 6 | II |
| Monitor | What is the server doing, how fast, and is it recoverable? | 7, 8, 9 | III |
| Recover | What do we do when a control fails? | 9, 10 | IV |
| Review | What is working, what is not, and what comes next? | 11, 12 | V |

Each stage produces evidence as well as work. Planning produces a sizing estimate someone can check. Securing produces a privilege list the data owner can sign. Monitoring produces logs and baselines. Recovery produces a timed restore. Review produces a report with numbers in it. When a chapter asks you to paste query output under a task, that is the evidence habit at work. It is the habit that separates a DBA who is trusted from one who is merely busy.

The stages form a loop, not a line. A review in Chapter 11 sends you back to planning. An incident in Chapter 10 rewrites the recovery plan you made in Chapter 9. Regulations in Chapter 4 constrain the architecture you chose in Chapter 2. When you finish the book, the loop is the thing you carry to any DBMS on any employer's server.

### Current Practice and Where It Is Going

The management job changes shape as the tools change, and the last course outcome asks you to keep judging those changes. Three shifts matter today.

**Managed database services** in the cloud take over installation, patching, backups, and replication. They do not take over your decisions. Someone still decides who may see the data, how long it is kept, and what the recovery target is. Chapter 2 weighs the tradeoff.

**Regulation keeps growing.** HIPAA and FERPA have been in force for decades, and state breach-notification laws, the European GDPR, and the California CCPA have added obligations on top. Every one of them arrives at the DBA as a configuration request. Chapters 4 and 10 translate them.

**Automation and AI** now propose indexes, flag unusual queries, and draft incident timelines. They are useful and they are fallible. Chapter 12 asks you to judge an emerging tool with evidence rather than enthusiasm.

!!! note "Where the vendors agree"
    Every major DBMS vendor publishes a hardening guide, and the Center for Internet Security publishes a benchmark for PostgreSQL, Oracle, MySQL, and SQL Server. Their checklists overlap far more than they differ: least privilege, encrypted connections, logging on, patches current, backups tested. Chapter 11 puts one of those benchmarks in your hands. Until then, notice how often this chapter's five roles, three properties, and five stages reappear in whatever guide you open.

### Try It Yourself 1.5: Place the Week's Work on the Map 🛠️

**Predict:** Below are six tasks from Mei Lin's list for your first week at Copperwind. Before reading further, assign each to a lifecycle stage. Some tasks touch two stages. Choose the primary one.

* Estimate how much disk the ticket tables will need in three years.
* Remove login access for a technician who left last month.
* Restore last night's clinic backup onto a test server and time it.
* Read the failed-login log from the weekend and decide whether it was an attack.
* Confirm that the parent portal never shows a student who opted out of directory information.
* Write the first page of a monthly health report Naomi Redhouse can sign.

**Run:** Build a two-column table, Task and Stage, and fill it. Then add a third column naming the chapter you expect to teach each task, using the stage table above.

**Explain:** In one or two sentences, explain why the failed-login task could belong to two stages, and what determines which stage it lands in on a given day.

### Quick Check 1.4 ✅

1. Name the five lifecycle stages in order and the course outcome each one serves.
2. A cloud provider now runs Copperwind's backups automatically. Name one decision the provider still cannot make for Copperwind.
3. Explain why the lifecycle is described as a loop rather than a sequence, using one example from this section.

---

## 1.5 Summary and Retrieval 💡

### Key Concepts

* A DBMS stores data, enforces rules, controls access, logs activity, and recovers from failure. Each function is a management decision before it is a technical one.
* Five roles share the work: the DBA, the security administrator, the data owner, the developer, and the auditor. The data owner decides who should see data. The DBA configures who can and proves the two lists match. Separation of duties keeps any one person from holding every power.
* The CIA triad names the three properties to protect: confidentiality, integrity, and availability. Every threat attacks at least one, and every control defends at least one. Naming the property points you to the control family and the chapter.
* PostgreSQL 17 is your lab server. psql runs scripts and pgAdmin lets you browse. Roles serve as both users and groups, a cluster holds many databases, and backslash commands belong to psql, not SQL.
* A baseline records size, version, and login roles while a server is healthy. Configuration without verification is a guess, so every change in this book is followed by the query that proves it.
* The management lifecycle runs Plan, Secure, Monitor, Recover, Review, and loops. The five stages map to the five course outcomes and to the chapters ahead.

### Key Terms

See course glossary for full definitions

* database management system (DBMS), database administrator (DBA), security administrator, data owner, separation of duties (Section 1.1)
* CIA triad, confidentiality, integrity, availability, threat, control, least privilege (Section 1.2)
* PostgreSQL, psql, pgAdmin, role, cluster, meta-command, superuser, baseline (Section 1.3)
* management lifecycle, managed database service (Section 1.4)

### Retrieval Practice

1. From memory, list the five roles in a database environment and the one decision the data owner never delegates to the DBA.
2. State the three properties of the CIA triad and give one database threat for each without looking at the tables in this chapter.
3. A colleague asks why you followed the setup script with a `COUNT(*)` query. Explain the habit in one sentence.
4. Describe the difference between a PostgreSQL role that can log in and one that cannot, and say which one your prerequisite course would have called a user.
5. Name the five stages of the management lifecycle in order and say which chapter closes the loop.

---

## 1.6 Skills Lab 1A: Stand Up the Copperwind Lab

**Goal:** Install and verify your PostgreSQL server, load all three course databases, record their baselines, and open Copperwind's risk register with five classified threats that Naomi Redhouse can review.

**Dataset or starter files:** `assets/code/chapter-01/` in the course data pack. The three setup scripts (`setup-copperwind.sql`, `setup-sandwash.sql`, `setup-harquahala.sql`), the starter script `skills-lab-1a.sql`, and the starter answer file `skills-lab-1a-answers.md`. The setup scripts load the CSVs in `assets/code/data/`. All three organizations and all of their records are fictional.

### Part 1: Foundation (Aligns with Objective 1.3)

1. Install PostgreSQL 17 with psql and pgAdmin. Record the exact output of `psql --version` in your answer file.
2. From the extracted `cis376` folder, run the three setup scripts as the `postgres` superuser. Then, in `skills-lab-1a.sql` under marker 1.1, write a query against `pg_database` that lists the three course databases by name. Paste the result as `-- Output:` comment lines.
3. Under marker 1.2, connect to each database in turn and count the rows in its largest table: `ticket_notes`, `appointments`, and `enrollments`. Under marker 1.3, record the server version and list every role that can log in.

### Part 2: Application (Aligns with Objectives 1.1 and 1.3)

1. Under markers 2.1 through 2.3, run the three baseline queries from Section 1.3 (total size, per-table sizes, login roles) against each database. Fill the baseline table in your answer file from the results.
2. In the answer file, write one paragraph for Mei Lin that reads the baseline like a manager. Say which database is largest and why, which table will grow fastest, and which login roles exist that Copperwind did not create on purpose. Cite the query output that supports each claim.
3. Open pgAdmin, connect to your server, and expand `sandwash_clinic` to the `patients` table. Use the Properties panel to find the table's owner. In your answer file, state who owns it and name the role from Section 1.1 that should decide who may read it.

### Part 3: Extension (Aligns with Objectives 1.1 and 1.2)

1. Open the risk register table in your answer file. Fill five rows, at least one for each CIA property and at least one for each of the three organizations. For each row name the asset (a table or a file), the threat, the property attacked, the control family, and the role that owns the decision.
2. Under marker 3.1 in your script, write one evidence query per risk that shows the exposure exists today. For example, a query that lists every login role with superuser rights supports a confidentiality risk. Paste each result under its query.
3. Rank the five risks from most to least urgent in a short paragraph and defend the top pick in two sentences a non-technical clinic manager could follow.

### Questions & Analysis 🤔

1. Compare the baselines of the three databases. Using your Part 2 numbers as evidence, explain which one you would monitor most closely for availability problems in the next year and why size alone is not the whole answer.
2. Your risk register names a role as the owner of each decision. For the risk you ranked first, explain what goes wrong if the DBA makes that decision alone, and propose the evidence you would bring the data owner so they can decide well.

**Submission:** Submit one folder named `skills-lab-1a-lastname`. It holds `skills-lab-1a.sql` with every result pasted as `-- Output:` comment lines (or the saved psql output beside it). It also holds `skills-lab-1a-answers.md` with the baseline table, the risk register, and your two Questions & Analysis answers clearly labeled.

### Rubric: Skills Lab 1A

Every Skills Lab in this book is graded with the same rubric.
Bookmark the [Skills Lab Rubric](../skills-lab-rubric.md) page for
quick reference in later chapters.

--8<-- "skills-lab-rubric.md:rubric"

---

## 1.7 Review Questions 🔄️

1. **Apply:** A bike shop's owner asks you to "lock down" the point-of-sale database. Using the five roles from Section 1.1, name who should decide which clerks may issue refunds, who configures it, and who checks it six months later.

2. **Analyze:** A food bank's donor database was down for six hours on its busiest day, and a volunteer says it was "not a security problem because nothing leaked." Break the event into CIA terms and explain which property failed, which control family should have prevented it, and what evidence you would collect afterward.

3. **Evaluate:** Copperwind could run the clinic database as a managed cloud service or on a server in its own rack. Judge which lifecycle stages the cloud option takes off your plate and which decisions it leaves with Copperwind, and state one question you would ask the provider before deciding.

4. **Create:** Design a one-page baseline checklist for any database Copperwind inherits from a new client. Name at least six measurements, the query or tool that produces each, and the role that should receive the report.

---

## Further Reading 📖

* [PostgreSQL 17 Downloads](https://www.postgresql.org/download/) - The official installers for Windows, macOS, and Linux, plus the package repositories this chapter's install steps describe.
* [PostgreSQL Documentation: Database Roles](https://www.postgresql.org/docs/17/user-manag.html) - The reference for the role concept you met in Section 1.3, which Chapter 5 builds on.
* [psql Reference](https://www.postgresql.org/docs/17/app-psql.html) - Every meta-command, including `\l`, `\dt`, `\copy`, and `\connect`.
* [NIST Cybersecurity Framework 2.0](https://www.nist.gov/cyberframework) - The management-level framework whose functions (Govern, Identify, Protect, Detect, Respond, Recover) parallel this book's lifecycle.
* [OWASP Database Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Database_Security_Cheat_Sheet.html) - A concise checklist of database controls you will implement one at a time across Parts II and III.

---

## Looking Ahead ⏩

You have a server, three databases, and a first baseline. Chapter 2 asks the questions that come before a server exists. Should Copperwind run the clinic database in its own rack or in the cloud? Which network tier does it belong in? How much storage and throughput will it need in three years? The ticket-size numbers you recorded today are the starting point for that projection.
