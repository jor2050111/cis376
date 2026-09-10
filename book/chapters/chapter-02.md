# Chapter 2: Infrastructure and Requirements

Mei Lin stops by your desk with a one-line request from Sandwash Family Clinic. The clinic wants Copperwind to host its scheduling database, and Dr. Vasquez wants an answer to three questions before she signs. Where will the server live? Who can reach it? How big does it need to be? None of those questions is a query. Each is a decision that has to be made before a database exists, and each one is hard to undo once it does.

Chapter 1 gave you a server and a baseline. This chapter asks what comes before the server. You will compare the three ways an organization can run a database (its own hardware, rented cloud infrastructure, or a managed service) and weigh each against cost, control, and compliance. You will place the database in a network tier where only the systems that need it can reach it, and you will express that decision in PostgreSQL's own gate, the `pg_hba.conf` file. You will separate identity, authentication, and authorization so that Chapter 5 can build on the vocabulary. Then you will measure a running server and turn the numbers into a hardware and growth estimate a manager can approve.

The habit from Chapter 1 carries over. Every decision in this chapter ends with a query that proves the server agrees with the plan. A placement diagram is a drawing until `pg_hba_file_rules` confirms it. A sizing estimate is a guess until it starts from measured bytes per row.

## Module Overview 🧭

* **Estimated time:** 4-5 hours
* **Prerequisites:** One prior SQL course (Introduction to Oracle: SQL, CIS276DA MySQL Database, or CIS276DB SQL Server Database). Chapter 1 (a running PostgreSQL 17 server and the course data pack). This chapter's folder ships its own setup scripts, so no saved work from Chapter 1 is needed.
* **Deliverables:** Skills Lab 2A folder (`skills-lab-2a.sql` and `skills-lab-2a-answers.md`), Quick Checks

## Learning Objectives 🎯

By the end of this chapter, you will be able to:

* **2.1 (Evaluate):** Compare on-premise, cloud infrastructure, and managed database service models against the cost, control, and compliance needs of a given organization (Section 2.1)
* **2.2 (Create):** Design a network placement for a database server across security tiers and express its trusted-client rules in a host-based authentication file (Sections 2.2-2.3)
* **2.3 (Analyze):** Estimate database size, throughput, and hardware needs from measured usage statistics (Section 2.4)

### This chapter aligns with the following Course Learning Outcomes

* **CLO I (Analyze):** Analyze database architecture and design for business solutions.
* **CLO III (Create):** Develop strategies to maintain optimal system performance, security and availability.

---

## 2.1 Service Models: Who Runs the Server?

In your SQL course the server was already there when you logged in. Someone chose where it ran. That choice is the **service model**, the arrangement that decides which parts of a database system your organization operates and which parts a provider operates for you. Three models cover nearly every case.

**On-premise** means your organization owns the hardware, the operating system, and the DBMS, and runs them in a room it controls. Copperwind's own rack in its Phoenix office is on-premise. You choose every setting, and you also replace every failed disk.

**Infrastructure as a service (IaaS)** means a cloud provider rents you virtual machines, storage, and networking. You install and manage PostgreSQL on the virtual machine yourself. The provider keeps the building, the power, and the physical hosts running. You still patch the operating system and the database.

A **managed database service** (Chapter 1 introduced the term) goes one step further. The provider installs PostgreSQL, patches it, takes backups, and replicates it. You get a connection string and a console. You keep every decision about data, access, and retention, because the provider cannot make those for you.

### The Shared Responsibility Model

Cloud providers describe the split with a phrase worth learning: the **shared responsibility model**. The provider secures the cloud. The customer secures what they put in the cloud. Where the line falls depends on the service model, and misreading the line is the most common cloud mistake. A clinic that assumes its managed database is "HIPAA compliant out of the box" has confused the provider's half with its own.

| Responsibility | On-premise | IaaS | Managed database service |
| --- | --- | --- | --- |
| Building, power, physical access | You | Provider | Provider |
| Hardware and hypervisor | You | Provider | Provider |
| Operating system patches | You | You | Provider |
| PostgreSQL install and patches | You | You | Provider |
| Backups and replication | You | You | Provider (you set the policy) |
| Network placement and firewall rules | You | You (in the provider's tools) | You (in the provider's tools) |
| Roles, privileges, row-level security | You | You | You |
| Data classification and retention | You | You | You |
| Encryption keys | You | You | You, or shared |

Read the bottom four rows again. They never move. Whatever model Copperwind picks for the clinic, the questions of who may see a patient record, how long it is kept, and who holds the encryption keys stay with Copperwind and the clinic. Chapters 4 through 6 answer them. This chapter decides everything above the line.

### Cost, Control, and Compliance

Three factors decide the model, and they pull in different directions.

**Cost** has two shapes. On-premise is mostly capital cost: a server bought once and depreciated over years, plus the staff time to run it. Cloud is operating cost: a monthly bill that rises and falls with what you use. A small database that runs all day every day often costs less on a server you already own. A database that must double on short notice, or that needs a second copy in another city, usually costs less in the cloud. The honest comparison prices staff time. A managed service that removes ten hours a month of patching and backup checks is worth ten hours of a DBA's pay.

**Control** is what you give up as you move right across the table. On a managed service you cannot install an extension the provider does not offer, read the server's log files directly, or tune a setting the provider has locked. For most small organizations that loss is a gain, because the provider's defaults are safer than an untended server. For a workload with unusual needs it can be a deal breaker. List the extensions and settings you rely on before you choose.

**Compliance** asks whether a regulator will accept the arrangement. HIPAA allows a covered entity to host protected health information with a cloud provider, but only under a written contract. That contract is the **business associate agreement (BAA)**, in which the provider accepts its share of the safeguards. Every major provider signs one for its managed database products. A provider that will not sign is not an option for the clinic, whatever its price. FERPA has no equivalent contract, but it holds the school responsible for any vendor that handles education records. Chapter 4 covers both regulations in detail.

!!! note "Cloud security services, introduced"
    Providers also sell services that sit beside the database: managed firewalls, key vaults, identity services, and activity monitors. They are the cloud versions of controls you will configure by hand in Parts II and III. Chapter 11 weighs them against the do-it-yourself versions. For now, treat them as items in the "Provider" column that you still have to turn on.

### Try It Yourself 2.1: Pick a Model for the Food Bank 🛠️

**Predict:** A nonprofit food bank tracks 4,000 donors and 30,000 donations a year in a PostgreSQL database. It has one part-time IT volunteer, no server room, and a grant that pays a fixed monthly amount for technology. Before reading further, write down which service model you would recommend and the single factor (cost, control, or compliance) that decided it.

**Run:** Build a three-row table, one row per service model, with the columns Monthly cost shape, What the food bank still has to do, and Biggest risk. Fill it from the shared responsibility table above. Then circle the row you recommended.

**Explain:** In one or two sentences, explain what would have to change about the food bank for a different row to win. Name the factor that would flip.

### Quick Check 2.1 ✅

1. A law office moves its case database from its own closet to a managed service and assumes it no longer needs to review who holds which privileges. Name the row of the shared responsibility table it misread.
2. Compare the cost shape of on-premise and cloud hosting for a database that runs at a steady load 24 hours a day. State which one usually wins and the one condition that would reverse it.
3. Explain why a cloud provider's refusal to sign a business associate agreement ends the conversation for a HIPAA covered entity.

---

## 2.2 Network Placement: Where the Server Sits and Who Can Knock

You connected to your server in Chapter 1 with `-h localhost`. That flag named a network address, and every connection to a database names one. Network placement is the decision about which addresses can reach the server at all. It is the cheapest security control you will ever configure, because a connection that never arrives cannot guess a password.

### Tiers and Zones

Architects divide a network into **security tiers** (also called zones), groups of systems that share the same exposure and the same rules for who may talk to them. The classic layout has three:

* The **presentation tier** faces users: web servers, a patient portal, a parent portal. It is reachable from the internet and is assumed to be attacked.
* The **application tier** runs the business logic: the scheduling application, the reporting service, the job that sends appointment reminders. It accepts connections only from the presentation tier.
* The **data tier** holds the database. It accepts connections only from the application tier and from a small set of administrative addresses. Nothing on the internet can reach it directly.

Between the tiers sit **firewalls**, devices or software that permit or drop network traffic by address, port, and direction. The rule for the data tier is short: allow the application tier to reach port 5432, allow the administrators' addresses to reach port 5432, and drop everything else. A database that lives in the data tier can have a weak password and still be unreachable by an attacker on the internet. A database on the presentation tier with a strong password is one leaked credential from disaster.

Here is the placement for the clinic, drawn the way you will draw it in the Skills Lab:

```text
Internet
   |
   |  443 only
   v
[ Presentation tier: patient portal web server ]        10.40.10.0/24
   |
   |  8080 only
   v
[ Application tier: scheduling app, reminder job ]      10.40.20.0/24
   |
   |  5432 only, from 10.40.20.0/24 and the admin host
   v
[ Data tier: PostgreSQL for sandwash_clinic ]           10.40.30.10
        ^
        |  5432 from the Copperwind admin host only
[ Copperwind admin jump host ]                          10.40.5.15
```

The addresses are fictional. The shape is the point. Two gates stand between the internet and the clinic's patient table, and the database itself adds a third.

### The Server's Own Address: listen_addresses

The network firewall is the first gate. PostgreSQL adds a second gate of its own before any password is checked: it only accepts connections on the network interfaces named in the `listen_addresses` setting. A fresh install listens on `localhost` only, which means no machine other than the server itself can connect. That is the safest possible default and the reason your Chapter 1 connection worked with `-h localhost`.

Confirm the settings that decide reachability on your own server. `SHOW` is PostgreSQL's way to read one setting, and the `pg_settings` view reads several at once:

```sql
\connect copperwind_ops
SELECT name, setting
FROM pg_settings
WHERE name IN ('listen_addresses', 'port', 'ssl', 'hba_file')
ORDER BY name;
-- Output:
--        name       |                   setting
-- ------------------+---------------------------------------------
--  hba_file         | /opt/homebrew/var/postgresql@17/pg_hba.conf
--  listen_addresses | localhost
--  port             | 5432
--  ssl              | off
```

Four facts in one query. The server accepts connections only from itself, on the standard port, without TLS, and the fourth row names the file that holds the third gate. The `hba_file` path shown is where this book's author's Homebrew install keeps it. On a Windows install the path is usually `C:/Program Files/PostgreSQL/17/data/pg_hba.conf`. Your row will show your path.

When the clinic's application server needs to connect, you widen `listen_addresses` in `postgresql.conf` to the data-tier address. Never set it to `*` (every interface) unless the firewall in front of the server is already doing the filtering:

```text
# postgresql.conf on the clinic's data-tier server
listen_addresses = 'localhost, 10.40.30.10'
port = 5432
```

This setting takes effect only after a server restart. After the restart, rerun the `pg_settings` query above. If the row still says `localhost`, the change did not take.

### The Database's Own Gate: pg_hba.conf

The firewall decides which machines can reach the port. `listen_addresses` decides which interfaces the server answers on. Neither one knows anything about databases or roles. The third gate does. **Host-based authentication** is PostgreSQL's rule table for deciding, connection by connection, whether to accept a client and how to check its identity. The rules live in `pg_hba.conf` (the "hba" is host-based authentication), and every connection is matched against them before any password is examined.

Each rule is one line with five fields:

| Field | Meaning | Common values |
| --- | --- | --- |
| TYPE | How the client arrived | `local` (same machine, no network), `host` (TCP), `hostssl` (TCP with TLS only) |
| DATABASE | Which database the rule covers | a name, `all`, `replication` |
| USER | Which role the rule covers | a name, `all`, a `+group` |
| ADDRESS | Which client addresses match | an address with a mask, such as `10.40.20.0/24` |
| METHOD | How to prove identity | `scram-sha-256`, `cert`, `reject`, `trust` |

Two facts about this file decide everything. First, PostgreSQL reads the rules top to bottom and stops at the first line whose TYPE, DATABASE, USER, and ADDRESS all match. That line's METHOD is used, even if a later line would have matched better. Second, if no line matches, the connection is refused. Order is therefore a security decision. Here is the clinic's file, with the reasoning for each position:

```text
# Step 1: Local maintenance from the server itself, by the superuser only
local   all              postgres                          scram-sha-256

# Step 2: Reject any outside address before a broader rule can accept it
host    all              all             203.0.113.0/24    reject

# Step 3: The application tier reaches only its own database, as its own role
host    sandwash_clinic  clinic_app      10.40.20.0/24     scram-sha-256

# Step 4: The Copperwind admin host may reach every database, but must use TLS
hostssl all              all             10.40.5.15/32     scram-sha-256

# Step 5: Nothing else. A missing rule is a refusal, so no catch-all line
```

Step 2 sits above Step 3 on purpose. If a client from the outside range ever did reach the port, it would hit `reject` before any accepting rule. Step 3 names one database and one role, so a leaked application password cannot open the operations database next door. Step 4 uses `hostssl`, which refuses any administrative connection that is not encrypted. Chapter 6 shows you how to set up the certificates that make `hostssl` work.

Two methods deserve a warning. `trust` accepts the connection with no proof of identity at all. It exists for development laptops and appears in the cluster shown below. It never belongs on a server another machine can reach. `password` sends the password in clear text and has no place anywhere. Use `scram-sha-256`, which is the PostgreSQL 17 default.

### Verifying the Gate

`pg_hba.conf` is only a text file until the server reads it. Two checks prove what the server will do. The `pg_hba_file_rules` view parses the file on disk, one row per rule, and reports any line it cannot understand in its `error` column. Read it before you reload, because a syntax error in this file can lock everyone out:

```sql
SELECT line_number, type, database, user_name, address, auth_method
FROM pg_hba_file_rules
ORDER BY line_number;
-- Output:
--  line_number | type  |   database    | user_name |  address  | auth_method
-- -------------+-------+---------------+-----------+-----------+-------------
--          117 | local | {all}         | {all}     |           | trust
--          119 | host  | {all}         | {all}     | 127.0.0.1 | trust
--          121 | host  | {all}         | {all}     | ::1       | trust
--          124 | local | {replication} | {all}     |           | trust
--          125 | host  | {replication} | {all}     | 127.0.0.1 | trust
--          126 | host  | {replication} | {all}     | ::1       | trust
```

These rows come from a cluster created with `initdb --auth=trust`, the choice a source build or a package install makes when nobody tells it otherwise. Every rule says `trust`, which accepts any connection that reaches it without checking a password. That is survivable on a laptop no other machine can reach. It is indefensible on a server. If you installed with the Windows or macOS installer, that installer chose for you and your rows show `scram-sha-256` instead. Either way, notice the shape: `local` rules for same-machine connections, `host` rules for the two loopback addresses `127.0.0.1` and `::1`, and no rule at all for any other address. That is why a fresh install is unreachable from the network even before the firewall does anything.

After you edit the file, tell the server to reread it. Unlike `listen_addresses`, this change needs no restart:

```text
SELECT pg_reload_conf();
```

Then query `pg_hba_file_rules` again and confirm the rows match the file you meant to write. The `error` column must be empty on every row. A row with an error is a rule the server ignores, and the connection you thought you allowed will be refused.

### Try It Yourself 2.2: Read Your Own Gate 🛠️

**Predict:** Before you run anything, write down how many rules you expect your server's `pg_hba.conf` to contain and what method you expect on the loopback rules. Then predict what happens to a connection from another computer on your home network, given the `listen_addresses` value you saw above.

**Run:** Run the `pg_hba_file_rules` query from this section on your own server. Count the rows and note the methods. Then open the file named by `hba_file` in a text editor (do not save any changes yet) and match each row to its line.

**Explain:** In one or two sentences, explain which of the three gates (firewall, `listen_addresses`, or `pg_hba.conf`) would stop the home-network connection first, and why the other two never get to decide.

### Quick Check 2.2 ✅

1. A city parks department puts its reservation database on the same subnet as its public web server "so the app can reach it." Name the tier the database belongs in and the one firewall rule that should stand between the two.
2. Two rules in a `pg_hba.conf` file both match a connection from `10.40.20.7` as `clinic_app`. The first says `reject` and the second says `scram-sha-256`. State what the server does and why the order mattered.
3. Explain why you should query `pg_hba_file_rules` before running `pg_reload_conf()`, not only after.

---

## 2.3 Identity and Access Management Foundations

The `pg_hba.conf` rules you just read all end with a method, and each method is a promise about how the server will learn who is connecting. That question belongs to a larger discipline. **Identity and access management (IAM)** is the set of policies and systems that decide who someone is, prove it, and control what they may do. Chapter 5 applies IAM inside PostgreSQL in full. This section gives you the three words the whole subject rests on, because people who blur them write policies that cannot be enforced.

### Three Words, Three Questions

* **Identity** answers "who is this?" It is a name the system recognizes: a login role such as `clinic_app`, a person's account such as `gyazzie`, or a certificate's subject.
* **Authentication** answers "can you prove it?" A password checked with SCRAM, a client certificate, or a ticket from a central directory are all proofs. `pg_hba.conf` chooses the proof. It does not decide what the identity may do afterward.
* **Authorization** answers "what may you do now that we believe you?" Privileges, role memberships, and row-level security policies live here. Authorization happens after authentication and only inside the database.

The order matters because each step trusts the one before it. A perfect set of grants means nothing if authentication accepts any password. A perfect authentication method means nothing if every identity holds superuser. When a control fails, name the word it failed at, and the fix is usually obvious.

### People and Service Accounts

An identity belongs either to a person or to a program. A **service account** is a login role used by an application or a scheduled job instead of a person. `clinic_app` in the placement diagram is one. Service accounts deserve stricter handling than people, not looser, because their passwords sit in configuration files and their sessions run all night with nobody watching. Three rules follow. Give each service its own role, so a leaked password exposes one application. Deny the role the ability to log in from anywhere but its own tier, which is what Step 3 of the clinic's `pg_hba.conf` did. Never let a person share a service account, because the audit trail in Chapter 7 will then record the program's name where a person's should be.

The database stores less about an identity than you might expect. It keeps the role's name, whether it can log in, how many connections it may hold, when its password expires, and the password hash itself. Look at what your server holds today:

```sql
SELECT rolname AS role_name,
       rolcanlogin AS can_login,
       rolconnlimit AS connection_limit,
       rolvaliduntil AS password_expires
FROM pg_roles
WHERE rolname NOT LIKE 'pg\_%'
ORDER BY rolname;
-- Output:
--  role_name | can_login | connection_limit | password_expires
-- -----------+-----------+------------------+------------------
--  postgres  | t         |               -1 |
```

One row, no connection limit (`-1` means unlimited), and no expiry. Nothing here says who the person behind `postgres` is, what department they work in, or whether they still work there. That information lives somewhere else, and that is the point of the next subsection.

### Single Sign-On and What the Database Delegates

Most organizations keep one directory of people (Active Directory, an identity provider, a campus login) and want every system to trust it. **Single sign-on (SSO)** is the arrangement in which a person proves identity once to a central service and every other system accepts that proof. The person gets one password. The organization gets one place to disable an account on someone's last day.

PostgreSQL can join such an arrangement, but only for the first two words. Its `pg_hba.conf` methods include `ldap`, `gss` (Kerberos), `radius`, and `cert`, each of which hands authentication to an outside system. What PostgreSQL never delegates is authorization. Even when the directory vouches for `gyazzie`, a role named `gyazzie` must exist inside the cluster and hold the privileges the front desk needs. The directory says who she is. The database says what she may do. Keeping those two lists in agreement is a recurring chore, and Chapter 5 gives you the catalog queries that make it a review instead of a guess.

Whatever method authenticates, the hashing of local passwords is a setting you should confirm once. PostgreSQL 17 defaults to SCRAM, a challenge-response method in which the password itself never crosses the network:

```sql
SHOW password_encryption;
-- Output:
--  password_encryption
-- ---------------------
--  scram-sha-256
```

If a server you inherit shows `md5` here, add "migrate passwords to SCRAM" to its plan. Chapter 5 shows you how.

### Try It Yourself 2.3: Sort the Bike Shop's Accounts 🛠️

**Predict:** A bike shop's point-of-sale database has these logins: `pos_register`, used by every register terminal. `maria` and `devon`, the two owners. `nightly_report`, used by a script that emails sales totals at midnight. `webstore`, used by the online shop. Before reading on, label each as a person or a service account and predict which one is most likely to still be working two years after everyone forgot it existed.

**Run:** Build a table with the columns Identity, Person or service, Where it should be allowed to connect from, and Who owns it. Fill it in. Then write one `pg_hba.conf` line for `webstore`, assuming the web server sits at `10.50.20.8`.

**Explain:** In one or two sentences, explain why `pos_register` shared by every terminal is an authorization problem even though every terminal authenticates correctly. Name the chapter that will fix it.

### Quick Check 2.3 ✅

1. A clinic's reminder job logs in as `postgres` because "it needed to read appointments." Name which of the three IAM words the clinic skipped, and state the smallest change that fixes it.
2. Compare a person's account and a service account on two points: where its password is stored, and how you learn the account is no longer needed.
3. Explain what PostgreSQL still has to hold about a user even when a central directory handles that user's login.

---

## 2.4 Specification Requirements: Measure, Then Size

Dr. Vasquez's third question was "how big?" The wrong way to answer is to guess a server from a vendor's catalog. The right way starts with numbers from a database that already runs, and every DBMS keeps those numbers for you. Four measurements drive the estimate. **Size** is how many bytes the data occupies today. **Growth** is how fast that number rises. **Throughput** is how many reads and writes the server handles per unit of time. **Usage** is when the load arrives and who generates it. This section measures all four on `copperwind_ops`, then turns them into a hardware recommendation. The Skills Lab asks you to repeat the method on the clinic.

### Size: Bytes per Row

Chapter 1 showed you `pg_total_relation_size()`, which adds a table's data pages, indexes, and overflow storage. Your baseline showed `ticket_notes` and `tickets` carrying most of the operations database. The sizing question is not how big those tables are but how big each row is, because rows are what the business adds:

```sql
SELECT 'tickets' AS table_name,
       COUNT(*) AS row_count,
       pg_size_pretty(pg_total_relation_size('tickets')) AS total_size,
       pg_total_relation_size('tickets') / COUNT(*) AS bytes_per_row
FROM tickets
UNION ALL
SELECT 'ticket_notes',
       COUNT(*),
       pg_size_pretty(pg_total_relation_size('ticket_notes')),
       pg_total_relation_size('ticket_notes') / COUNT(*)
FROM ticket_notes;
-- Output:
--   table_name  | row_count | total_size | bytes_per_row
-- --------------+-----------+------------+---------------
--  tickets      |     18240 | 2624 kB    |           147
--  ticket_notes |     28326 | 2848 kB    |           102
```

Each ticket costs about 147 bytes with its indexes, and each note about 102. Those two numbers are the unit prices for the estimate. Notice that a text column's size depends on what people type, so a business that starts writing longer notes changes the unit price without adding a single row. Re-measure once a quarter.

### Growth: The Monthly Rate

Copperwind opens tickets every day, so the tables grow every day. The growth rate is in the data itself. Group the tickets by the month they were opened and look at the recent trend:

```sql
SELECT date_trunc('month', opened_at)::date AS month_start,
       COUNT(*) AS tickets_opened
FROM tickets
WHERE opened_at >= DATE '2026-03-01'
GROUP BY month_start
ORDER BY month_start;
-- Output:
--  month_start | tickets_opened
-- -------------+----------------
--  2026-03-01  |            829
--  2026-04-01  |            854
--  2026-05-01  |            879
--  2026-06-01  |            906
```

Each month adds about 25 tickets to the month before it. That is a compounding pattern, not a fixed step, and a compounding pattern must be projected with a rate. Compare the first full month in the table with the latest and solve for the monthly rate that connects them across the 29 steps between:

```sql
WITH monthly AS (
  SELECT date_trunc('month', opened_at)::date AS month_start,
         COUNT(*) AS tickets_opened
  FROM tickets
  GROUP BY month_start
)
SELECT MIN(tickets_opened) FILTER (WHERE month_start = '2024-01-01') AS first_month,
       MIN(tickets_opened) FILTER (WHERE month_start = '2026-06-01') AS last_month,
       ROUND((POWER(
         MIN(tickets_opened) FILTER (WHERE month_start = '2026-06-01')::numeric
         / MIN(tickets_opened) FILTER (WHERE month_start = '2024-01-01'),
         1.0 / 29) - 1) * 100, 1) AS monthly_growth_pct
FROM monthly;
-- Output:
--  first_month | last_month | monthly_growth_pct
-- -------------+------------+--------------------
--          383 |        906 |                3.0
```

Ticket volume has grown 3 percent a month, every month, for two and a half years. (`FILTER` is standard SQL that MySQL does not support. Oracle and SQL Server students may not have met it either. It applies a `WHERE` to one aggregate.) Three percent a month sounds small and is not. It doubles the monthly volume in about two years, which is exactly what the first and last months show.

### Throughput: How Much Work per Hour

Size tells you how much disk to buy. Throughput tells you how fast the disk and processor must be. The server keeps a running count of every row it inserts, updates, and deletes in each table, in the `pg_stat_user_tables` view. On a server that has run for a month, dividing those counters by the hours since the counters were reset gives you rows per hour. On your freshly loaded copy the counters show the load itself:

```sql
SELECT relname AS table_name,
       n_tup_ins AS rows_inserted,
       n_tup_upd AS rows_updated,
       n_tup_del AS rows_deleted
FROM pg_stat_user_tables
ORDER BY n_tup_ins DESC;
-- Output:
--   table_name  | rows_inserted | rows_updated | rows_deleted
-- --------------+---------------+--------------+--------------
--  ticket_notes |         28326 |            0 |            0
--  tickets      |         18240 |            0 |            0
--  login_events |         12000 |            0 |            0
--  clients      |            40 |            0 |            0
--  technicians  |             8 |            0 |            0
```

These counters are cumulative, so the habit is to record them at the start of a window and again at the end. The difference is the throughput for that window. Until you have a window, the data itself gives a floor. June 2026 is the latest full month, and Copperwind works about a 12-hour day:

```sql
SELECT COUNT(*) AS june_tickets,
       ROUND(COUNT(*) / 30.0, 1) AS tickets_per_day,
       ROUND(COUNT(*) / 30.0 / 12, 1) AS tickets_per_working_hour
FROM tickets
WHERE opened_at >= DATE '2026-06-01'
  AND opened_at <  DATE '2026-07-01';
-- Output:
--  june_tickets | tickets_per_day | tickets_per_working_hour
-- --------------+-----------------+--------------------------
--           906 |            30.2 |                      2.5
```

Two and a half new tickets an hour, each with one or two notes, is a small write load. Any current server handles it without noticing. The reads are the larger share: every technician's queue, every client report, and every dashboard is a `SELECT`. Chapter 8 measures reads with `pg_stat_statements`. For sizing, the write rate and the working set are enough.

### Usage: When the Load Arrives

A server is sized for its peak, not its average. Usage analysis finds the peak. Copperwind's tickets carry a timestamp, so the busiest hours fall out of one query:

```sql
SELECT EXTRACT(hour FROM opened_at) AS hour_of_day,
       COUNT(*) AS tickets_opened
FROM tickets
GROUP BY hour_of_day
ORDER BY tickets_opened DESC
LIMIT 3;
-- Output:
--  hour_of_day | tickets_opened
-- -------------+----------------
--           13 |           1595
--           11 |           1574
--           14 |           1549
```

The load peaks in the early afternoon and is nearly flat across the working day. That is a gentle profile. A school's database spikes on the first morning of registration, and a clinic's spikes at 7 a.m. when the front desk opens the schedule. The peak-to-average ratio decides how much headroom to buy, and you cannot know it without this query or its equivalent.

### From Numbers to Hardware

Now the numbers become a recommendation. Four rules of thumb carry most of the weight, and each one starts from a measurement you just took:

| Resource | Start from | Rule of thumb |
| --- | --- | --- |
| Storage | Today's size plus 36 months of growth | Multiply by 3: the data, its write-ahead log and indexes, and room for one local backup |
| Memory | The working set (the tables and indexes queries touch every day) | Enough RAM to hold the working set, so reads come from memory instead of disk |
| Processor | Peak concurrent connections and the heaviest report | One core per two or three active connections, plus one for the operating system |
| Disk speed | Peak writes per second | Solid-state storage for anything that takes writes all day |

The write-ahead log (WAL) is PostgreSQL's record of every change, written before the change reaches the table. Chapter 8 explains why it exists. For sizing, know that it consumes disk alongside the data. The **working set** is the part of the database that daily queries touch. For Copperwind it is this year's tickets and notes, not the 2024 history. A server whose RAM holds the working set answers most queries without reading disk, and that single fact does more for response time than any processor upgrade.

**Capacity planning** is the discipline of turning these measurements into a purchase or a cloud tier, with a date by which the estimate must be revisited. The date matters as much as the number. An estimate with no expiry becomes an outage.

### Try It Yourself 2.4: Project Copperwind's Storage 36 Months Out 🛠️

You are Copperwind's database administrator, and Mei Lin needs a storage number for next year's budget request. The measurements above give you the unit price per ticket and the growth rate. This query joins them into a projection.

**Predict:** Before you run it, write down your estimate. The two ticket tables hold about 5.3 MB today, June added 906 tickets, and volume grows 3 percent a month. Will the ticket data more than double, more than triple, or more than quadruple in 36 months? Commit to one.

**Run:**

```sql
-- Step 1: Price one ticket in bytes, its notes included
WITH per_ticket AS (
  SELECT (pg_total_relation_size('tickets')
          + pg_total_relation_size('ticket_notes'))::numeric
         / (SELECT COUNT(*) FROM tickets) AS bytes_per_ticket
),
-- Step 2: Start the projection from the latest full month
latest AS (
  SELECT COUNT(*) AS tickets_per_month
  FROM tickets
  WHERE opened_at >= DATE '2026-06-01'
    AND opened_at <  DATE '2026-07-01'
),
-- Step 3: Compound 3 percent a month for 36 months and add it up
projected AS (
  SELECT SUM(tickets_per_month * POWER(1.03, month_number)) AS new_tickets
  FROM latest, generate_series(1, 36) AS month_number
)
-- Step 4: Turn tickets into bytes and add today's footprint
SELECT ROUND(bytes_per_ticket) AS bytes_per_ticket,
       ROUND(new_tickets) AS new_tickets,
       pg_size_pretty(pg_total_relation_size('tickets')
                      + pg_total_relation_size('ticket_notes')) AS ticket_data_today,
       pg_size_pretty((new_tickets * bytes_per_ticket)::bigint) AS growth_36_months,
       pg_size_pretty((pg_total_relation_size('tickets')
                       + pg_total_relation_size('ticket_notes')
                       + new_tickets * bytes_per_ticket)::bigint) AS ticket_data_in_36_months
FROM per_ticket, projected;
-- Output:
--  bytes_per_ticket | new_tickets | ticket_data_today | growth_36_months | ticket_data_in_36_months
-- ------------------+-------------+-------------------+------------------+--------------------------
--               307 |       59048 | 5472 kB           | 17 MB            | 23 MB
```

**Explain:** In one or two sentences, explain why the projection adds 59,000 new tickets in 36 months when the last 30 months added only 18,240. Then state the storage number you would put in the budget after applying the multiply-by-three rule from the hardware table, and say when you would re-measure.

Step 1 divides the combined size of both tables by the ticket count, so each ticket carries its share of the notes. Step 3 uses `generate_series()`, a PostgreSQL function that produces a row per month, and `POWER()` to compound the rate. The result is a number Mei Lin can defend in a budget meeting because every input is a query someone can rerun.

### Fix It 2.1: The Size That Would Not Print 🔧

Before the careful projection above, you try a rough ceiling: multiply today's ticket footprint by the factor the monthly rate has grown since January 2024.

**Symptom:** You cast the ratio to `float` to avoid integer division, the way your SQL course taught you, and the query fails on the last line.

```text
WITH growth AS (
  SELECT COUNT(*) FILTER (WHERE opened_at >= DATE '2026-06-01')::float
         / COUNT(*) FILTER (WHERE opened_at < DATE '2024-02-01') AS growth_factor
  FROM tickets
)
SELECT pg_size_pretty((pg_total_relation_size('tickets')
                       + pg_total_relation_size('ticket_notes')) * growth_factor)
       AS rough_ceiling
FROM growth;
```

```text
ERROR:  function pg_size_pretty(double precision) does not exist
```

**Diagnose:** State the cause in one sentence before you edit anything. `pg_size_pretty()` accepts a `bigint` or a `numeric`. A `bigint` multiplied by a `float` produces a `double precision` value, and no version of the function accepts that type.

**Repair:** Cast the finished byte count back to `bigint` before handing it to `pg_size_pretty()`. The cast also drops the fraction of a byte, which no disk can store anyway. Rerun:

```sql
WITH growth AS (
  SELECT COUNT(*) FILTER (WHERE opened_at >= DATE '2026-06-01')::float
         / COUNT(*) FILTER (WHERE opened_at < DATE '2024-02-01') AS growth_factor
  FROM tickets
)
SELECT ROUND(growth_factor::numeric, 2) AS growth_factor,
       pg_size_pretty(((pg_total_relation_size('tickets')
                        + pg_total_relation_size('ticket_notes'))
                       * growth_factor)::bigint) AS rough_ceiling
FROM growth;
-- Output:
--  growth_factor | rough_ceiling
-- ---------------+---------------
--           2.37 | 13 MB
```

**Verify:** The query returns a size string instead of an error, and the number is in the same neighborhood as the careful projection's `ticket_data_in_36_months`. If the two estimates disagreed by a factor of ten, one of them would be wrong, and you would check the growth factor first.

### Try It Yourself 2.5: Size the Credit Union's Server 🛠️

**Predict:** A credit union's transaction database measures 40 GB today, grows 2 percent a month, and peaks at 60 active connections at lunchtime on paydays, when it writes 400 rows per second. Its working set (the last 90 days of transactions) is 6 GB. Before you calculate, predict which of the four resources in the hardware table will be the most expensive line on the quote.

**Run:** Fill a four-row table, one row per resource, with the columns Measurement, Rule applied, and Recommendation. For storage, compound 2 percent for 36 months (the factor is about 2.04) and then apply the multiply-by-three rule. For processor, apply one core per two active connections.

**Explain:** In one or two sentences, explain why a server with 8 GB of RAM would serve this database well even though the database is 40 GB. Name the term from this section that makes the answer work.

### Quick Check 2.4 ✅

1. A bike shop's database grew from 1 GB to 1.5 GB in a year. The owner wants to buy "a 2 GB drive to be safe." Using the storage rule from this section, state the smallest size you would recommend and name the two things besides the data that need the room.
2. Compare two ways of measuring throughput from this section: the `pg_stat_user_tables` counters and the tickets-per-hour query. State which one measures the server and which one measures the business, and when you would trust each.
3. Explain why a sizing estimate should carry an expiry date, using the growth rate you measured as the example.

---

## 2.5 Summary and Retrieval 💡

### Key Concepts

* The service model (on-premise, infrastructure as a service, or managed database service) decides which parts of the system you operate and which the provider operates. The shared responsibility model draws the line. Roles, privileges, data classification, retention, and keys stay with you under every model.
* Cost, control, and compliance decide the model. Cloud trades capital cost for operating cost and trades control for safer defaults. A HIPAA covered entity can use a provider only under a business associate agreement.
* A database belongs in the data tier, reachable only from the application tier and a few administrative addresses. Three gates enforce that: the network firewall, `listen_addresses`, and `pg_hba.conf`.
* `pg_hba.conf` matches each connection against its rules top to bottom and stops at the first match, so order is a security decision. A missing rule is a refusal. `pg_hba_file_rules` shows what the server will read, and `pg_reload_conf()` makes it read it.
* Identity is who you are, authentication proves it, and authorization decides what you may do. A directory can handle the first two through single sign-on. The database never delegates the third. Service accounts get their own roles and their own connection rules.
* Sizing starts from measurements: bytes per row, monthly growth rate, rows written per hour, and the hour of peak load. Storage is projected growth times three. Memory holds the working set. Every estimate carries a date to re-measure.

### Key Terms

See course glossary for full definitions

* service model, on-premise, infrastructure as a service (IaaS), shared responsibility model, business associate agreement (BAA) (Section 2.1)
* security tier, presentation tier, application tier, data tier, firewall, host-based authentication (Section 2.2)
* identity and access management (IAM), identity, authentication, authorization, service account, single sign-on (SSO) (Section 2.3)
* size, growth, throughput, usage, working set, capacity planning (Section 2.4)

### Retrieval Practice

1. From memory, name the rows of the shared responsibility table that stay with the customer under every service model, and say why they cannot move.
2. State the three gates a connection must pass to reach a database in the data tier, in the order it meets them, and name the one that knows about roles.
3. Write the five fields of a `pg_hba.conf` rule from memory and explain in one sentence why the order of rules matters.
4. Explain the difference between authentication and authorization using a service account as the example, and name the one that PostgreSQL never hands to an outside directory.
5. From Chapter 1: Name the three measurements a baseline records and state which of them this chapter turned into a growth projection.

---

## 2.6 Skills Lab 2A: Place and Size the Sandwash Clinic Database

**Goal:** Measure the clinic's database, project three years of growth, recommend a service model Dr. Vasquez can approve, draw the network placement, and write the `pg_hba.conf` rules that enforce it.

**Dataset or starter files:** `assets/code/chapter-02/` in the course data pack. The setup script `setup-sandwash.sql` rebuilds `sandwash_clinic` from the CSVs in `assets/code/data/`. The starter script `skills-lab-2a.sql` holds numbered markers for each part, `skills-lab-2a-answers.md` holds the tables you fill, and `pg_hba-starter.conf` is a small fictional rule file you will read and edit. Sandwash Family Clinic and every record in its database are fictional.

The clinic's facts for this lab: 12 providers, about 600 active patients, and a front desk of 4. Dr. Vasquez plans to add two providers next year, so plan for appointment volume to step up 20 percent starting in month 13 of your projection and hold there. The clinic is a HIPAA covered entity. Its patient portal will run on a web server that Copperwind hosts. The scheduling application runs on the application tier at `10.40.20.0/24`. Copperwind administrators connect from the jump host at `10.40.5.15`. The clinic's own office network is `10.60.0.0/16`, and its staff use the application, never the database directly.

### Part 1: Foundation (Aligns with Objective 2.3)

1. From the extracted `cis376` folder, run `setup-sandwash.sql` as the `postgres` superuser. Under marker 1.1 in `skills-lab-2a.sql`, measure every table in `sandwash_clinic`: row count, total size, and bytes per row. Paste the result as `-- Output:` comment lines.
2. Under marker 1.2, count appointments by month for the most recent 12 full months and compute the average appointments per month. Under marker 1.3, count visit notes per appointment (the ratio, not the list) so each appointment carries its share of note storage.
3. Fill the Measurements table in your answer file from these results. Note in one sentence whether the clinic's appointment volume is growing, flat, or shrinking, with the numbers that show it.

### Part 2: Application (Aligns with Objectives 2.1 and 2.3)

1. Under marker 2.1, write the 36-month projection for the clinic's appointment and visit-note storage. Start from the monthly average you measured, apply the 20 percent step in month 13, and price each appointment with its notes in bytes. Follow the Step 1 through Step 4 pattern from Try It Yourself 2.4 and label your steps the same way.
2. Fill the Projection table in your answer file: storage today, projected growth, projected total, and the recommended purchase after the multiply-by-three rule. Add the date by which the estimate should be re-measured and one sentence saying why that date.
3. Fill the Service Model table: one row per model, scored against the clinic's cost, control, and compliance needs. Below the table, write the recommendation as a short paragraph addressed to Dr. Vasquez. Name the model, the deciding factor, and the one document Copperwind must obtain from the provider if the recommendation is a cloud model.

### Part 3: Extension (Aligns with Objectives 2.2 and 2.3)

1. In your answer file, draw the clinic's network placement as a text diagram in the style of Section 2.2. Show the three tiers, the jump host, the clinic office network, the port each arrow carries, and the address ranges above.
2. Open `pg_hba-starter.conf`. It contains a rule that violates the placement you drew. Copy the file into your answer file and fix the violation. Then add the three rules the placement needs. The scheduling application's service account `clinic_app` connects from its own tier. Administrators connect from the jump host over TLS only. A `reject` line stops the clinic's office network before any accepting rule could match it. Put a one-line comment above each rule stating why it sits where it does.
3. Under marker 3.1, write the `pg_hba_file_rules` query you would run after copying your rules onto the clinic's server. In a comment, state the two things you would check in its output before running `pg_reload_conf()`.

### Questions & Analysis 🤔

1. Your Part 2 projection assumed a 20 percent step in month 13. Analyze how the projection changes if the two new providers bring patients who write longer notes, and identify which measurement from Part 1 you would watch to catch that change early.
2. Your Part 3 rule file rejects the clinic's own office network. Evaluate that decision from Tomas Reyes's point of view when a front-desk computer "cannot reach the database," and explain which tier should answer his request and why the rule should stay.

**Submission:** Submit one folder named `skills-lab-2a-lastname`. It holds `skills-lab-2a.sql` with every result pasted as `-- Output:` comment lines (or the saved psql output beside it). It also holds `skills-lab-2a-answers.md` with the Measurements, Projection, and Service Model tables, the recommendation paragraph, the placement diagram, the corrected rule file, and your two Questions & Analysis answers clearly labeled.

### Rubric: Skills Lab 2A

This lab is graded with the standard
[Skills Lab Rubric](../skills-lab-rubric.md): four criteria, five
levels from Mastery to Not Evident. The criteria are Technical
Accuracy and Efficiency, Output Quality, Documentation Quality, and
Analysis, Interpretation, and Response to QUESTION(s). The criteria
and levels are the same everywhere. Your instructor sets the point
values in your course. Check the syllabus and the Canvas rubric
attached to this lab for the values that apply to you.

---

## 2.7 Review Questions 🔄️

1. **Apply:** A city parks department runs a reservation database on a managed cloud service. List which rows of the shared responsibility table the department still owns, and name the first one you would ask its IT manager for evidence about.

2. **Analyze:** A law office's `pg_hba.conf` has a line `host all all 0.0.0.0/0 scram-sha-256` as its first rule, followed by a `reject` line for the guest wireless network. Break down what happens to a connection from the guest network and explain what the office believes its file does versus what it does.

3. **Evaluate:** Copperwind can host the clinic database on its own rack for a fixed yearly cost. A managed service costs 40 percent more but includes backups, patching, and a signed business associate agreement. Judge which option you would recommend to Dr. Vasquez and state the one measurement from Section 2.4 that could change your answer.

4. **Create:** Design a one-page sizing worksheet Copperwind can use for any new client database. Name the four measurements, the query that produces each, the rule that converts each into a hardware line, and the field that records when the estimate expires.

---

## Further Reading 📖

* [PostgreSQL Documentation: The pg_hba.conf File](https://www.postgresql.org/docs/17/auth-pg-hba-conf.html) - The full rule syntax, every authentication method, and the first-match rule this chapter built on.
* [PostgreSQL Documentation: Connections and Authentication Settings](https://www.postgresql.org/docs/17/runtime-config-connection.html) - The reference for `listen_addresses`, `port`, and the other settings that decide reachability.
* [PostgreSQL Documentation: Database Object Size Functions](https://www.postgresql.org/docs/17/functions-admin.html#FUNCTIONS-ADMIN-DBSIZE) - `pg_total_relation_size()`, `pg_size_pretty()`, and their relatives, with the types each one accepts.
* [NIST SP 800-145: The NIST Definition of Cloud Computing](https://csrc.nist.gov/pubs/sp/800/145/final) - The two-page definition of the service models this chapter compared, in the words regulators and auditors use.
* [HHS: Guidance on HIPAA and Cloud Computing](https://www.hhs.gov/hipaa/for-professionals/special-topics/health-information-technology/cloud-computing/index.html) - What a covered entity must do before a cloud provider may hold protected health information, including the business associate agreement.
* [CIS PostgreSQL Benchmark](https://www.cisecurity.org/benchmark/postgresql) - The hardening checklist Chapter 11 returns to, with a section on connection and authentication settings you can preview now.

---

## Looking Ahead ⏩

You have placed the clinic's server, gated who can reach it, and sized it with numbers you can defend. Chapter 3 moves inside the database. It asks what shape the data should take so the database can defend its own correctness. You will add constraints that refuse bad rows and transactions that keep two clerks from booking the same slot. You will also build a normalized design that keeps sensitive columns apart. The clinic's appointments table, which you just measured, is where that work begins.
