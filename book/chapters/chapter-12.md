# Chapter 12: Current Practice, Future Trends, and Capstone

Three claims land on your desk in one morning. A cloud provider offers to run the Sandwash Family Clinic database for a monthly fee and says its backups are better than yours. An assistant built into your query tool proposes an index and promises it will cut a report in half. A vendor writes to Mei Lin about a server that keeps data encrypted even while it computes on it. Every one of these is a claim. Not one of them arrives with evidence.

Eleven chapters gave you the instruments to test claims like these. You have measured a server, granted and revoked access, encrypted a column, read an audit trail, compared two execution plans, restored a backup on a clock, and contained an incident. That toolkit is what this chapter turns toward the future. The last course outcome asks you to critique current practice and future trends, and critique is not the same as opinion. Critique means you name the claim, name the evidence that would settle it, and go get that evidence.

Then you write the plan. The capstone in this chapter asks for one document that covers architecture, access, compliance, performance, recovery, and response for a single organization, with query output as proof under each section. Copperwind hired you as its database administrator in Chapter 1. This is the document Mei Lin has been waiting for, and Naomi Redhouse signs the access pages.

## Module Overview 🧭

* **Estimated time:** 6-7 hours, including the capstone plan
* **Prerequisites:** One prior SQL course (Introduction to Oracle: SQL, CIS276DA MySQL Database, or CIS276DB SQL Server Database). Chapter 1 (the lab environment and the three course databases). The capstone draws on all eleven earlier chapters, and each one is recalled in a sentence where it is needed.
* **Deliverables:** Skills Lab 12A folder (`skills-lab-12a.sql` and `skills-lab-12a-answers.md`), Quick Checks

## Learning Objectives 🎯

By the end of this chapter, you will be able to:

* **12.1 (Evaluate):** Appraise emerging database technologies and predict their effect on administration and security practice using current evidence (Sections 12.1-12.2)
* **12.2 (Evaluate):** Weigh the cost and benefit of adopting an emerging database technology for a specific organization (Section 12.3)
* **12.3 (Create):** Produce a complete database management and security plan that addresses architecture, access, compliance, performance, recovery, and response for one organization (Section 12.4)

### This chapter aligns with the following Course Learning Outcomes

* **CLO I (Analyze):** Analyze database architecture and design for business solutions.
* **CLO II (Evaluate):** Assess security management for database environments.
* **CLO III (Create):** Develop strategies to maintain optimal system performance, security and availability.
* **CLO IV (Evaluate):** Evaluate practices for database environment incident responses.
* **CLO V (Evaluate):** Critique current practices and future trends of database management and security.

---

## 12.1 Current Practice

Four practices show up in most database shops today: managed cloud databases, database DevOps, zero trust, and data governance programs. None of them is new science. Each one rearranges work you already know how to do. Reading them that way is the point of this section, because a practice you can map onto your own controls is a practice you can judge.

This chapter works in all three databases. Load them from the extracted `cis376` folder:

```text
psql -U postgres -d postgres -f assets/code/chapter-12/setup-copperwind.sql
psql -U postgres -d postgres -f assets/code/chapter-12/setup-sandwash.sql
psql -U postgres -d postgres -f assets/code/chapter-12/setup-harquahala.sql
```

### Managed Cloud Databases

Chapter 2 introduced the managed database service and the shared responsibility model that comes with it. The provider runs the hardware, the operating system, the patches, the backups, and often the replication. You keep everything above that line. Here is the split, task by task, for the controls this book taught:

| Task | On-premise | Managed service | Who still decides |
| --- | --- | --- | --- |
| Patch the server | You | Provider | You pick the maintenance window |
| Take and test backups | You | Provider takes them | You still test a restore |
| Set the recovery targets | You | You | The data owner |
| Grant and revoke roles | You | You | The data owner |
| Encrypt a sensitive column | You | You | You |
| Classify the data | You | You | The data owner |
| Read the audit trail | You | You | The security reviewer |

Read the last column. The provider absorbs labor, not judgment. Every row that names a person is a row a contract cannot fill. That is why Chapter 9 insisted on a restore drill even when a backup job reports success. A provider's success message is the provider's evidence, and your plan needs yours.

### Database DevOps and Infrastructure as Code

**Database DevOps** is the practice of shipping database changes the same way an application ships code: in small versioned files, reviewed before they run, applied by a tool rather than by hand. **Infrastructure as code** is the same idea for the server itself, where the configuration lives in a file under version control instead of in someone's memory of what they typed.

A **schema migration** is one of those files. It carries a number, a description, and the statements that move the database from one known state to the next. The tool that applies migrations keeps a table of which ones ran, so the server itself can answer the question an auditor asks first.

```sql
\connect copperwind_ops
CREATE SCHEMA deploy;
CREATE TABLE deploy.schema_migrations (
  migration_id text PRIMARY KEY,
  applied_on   date NOT NULL,
  applied_by   text NOT NULL,
  description  text NOT NULL
);
INSERT INTO deploy.schema_migrations VALUES
  ('0007-index-tickets-opened-at', DATE '2026-03-02', 'data_services',
   'Index tickets.opened_at for the monthly volume report'),
  ('0008-reporting-role', DATE '2026-04-13', 'data_services',
   'Create copperwind_reporting and grant SELECT on two tables');
SELECT migration_id, applied_on, applied_by
FROM deploy.schema_migrations
ORDER BY migration_id;
-- Output:
-- CREATE SCHEMA
-- CREATE TABLE
-- INSERT 0 2
--          migration_id         | applied_on |  applied_by
-- ------------------------------+------------+---------------
--  0007-index-tickets-opened-at | 2026-03-02 | data_services
--  0008-reporting-role          | 2026-04-13 | data_services
```

The history table sits in its own `deploy` schema so it never mixes with Copperwind's business tables. Two rows are enough to show the habit. Someone can now ask when the reporting role was created and get a date instead of a guess. That is the whole promise of the practice, and it is the same promise Chapter 1 made about baselines: write it down while it is true.

Infrastructure as code carries one risk worth naming. A file that creates roles or opens network rules is powerful, and anyone who can merge it can change your server. The review step is the control, and it belongs in the plan you write in Section 12.4.

### Zero Trust

**Zero trust** is a design principle that removes the idea of a trusted inside. No request is trusted because of where it came from. Every request proves who it is, gets only what it needs, and is logged as if it might be hostile. The federal description in NIST SP 800-207 is written for whole networks, and it lands on a database as three demands you have already met:

| Zero trust demand | What it means for a database | Where you built it |
| --- | --- | --- |
| Verify explicitly | Every connection authenticates, and the channel is encrypted | Chapters 2 and 6 |
| Least privilege | Each role holds only the grants its work needs, reviewed on a schedule | Chapters 4 and 5 |
| Assume breach | Activity is logged and readable, and containment is planned | Chapters 7 and 10 |

Nothing in that table is new to you. What zero trust adds is the refusal to make exceptions for the network. A reporting server "inside the firewall" gets the same treatment as one on the public internet. When someone proposes a zero trust program, the question to ask is which of the three demands their proposal changes, and what evidence they will produce that it took effect.

### Data Governance

**Data governance** is the program that keeps four answers current. What data do we hold? How sensitive is each piece? Who decides who may see it? How long do we keep it? Chapter 1 named the data owner. Chapter 4 taught data classification and retention. Governance is what stops those answers from going stale.

The program adds one role you have not met. A **data steward** is the person inside a business unit who maintains the meaning of the data: what a column means, which values are valid, and which records are authoritative. A steward is not a database administrator and not a data owner. Grace Yazzie, who leads the clinic front desk, is a natural steward for appointment status, because she knows what "no show" means in practice.

The program's first artifact is an inventory. Every governance review starts by listing the tables, their classification, their size, and the person who decides access. The classification column below uses PHI for protected health information, the term Chapter 4 defined.

```sql
\connect sandwash_clinic
WITH inventory (table_name, classification, decides_access) AS (
  VALUES ('patients', 'PHI', 'Dr. Elena Vasquez'),
         ('appointments', 'PHI', 'Dr. Elena Vasquez'),
         ('visit_notes', 'PHI', 'Dr. Elena Vasquez'),
         ('providers', 'Internal', 'Tomas Reyes'),
         ('staff_accounts', 'Restricted', 'Naomi Redhouse')
),
counted (table_name, row_count) AS (
  SELECT 'patients', COUNT(*) FROM patients
  UNION ALL SELECT 'appointments', COUNT(*) FROM appointments
  UNION ALL SELECT 'visit_notes', COUNT(*) FROM visit_notes
  UNION ALL SELECT 'providers', COUNT(*) FROM providers
  UNION ALL SELECT 'staff_accounts', COUNT(*) FROM staff_accounts
)
SELECT i.table_name, i.classification, c.row_count, i.decides_access
FROM inventory AS i
JOIN counted AS c ON c.table_name = i.table_name
ORDER BY i.classification, i.table_name;
-- Output:
--    table_name   | classification | row_count |  decides_access
-- ----------------+----------------+-----------+-------------------
--  providers      | Internal       |        12 | Tomas Reyes
--  appointments   | PHI            |      6000 | Dr. Elena Vasquez
--  patients       | PHI            |       600 | Dr. Elena Vasquez
--  visit_notes    | PHI            |      4486 | Dr. Elena Vasquez
--  staff_accounts | Restricted     |        20 | Naomi Redhouse
```

The classification and the owner names come from the clinic. The row counts come from the server. Half of a governance inventory is policy and half is measurement, and the two halves have to be checked against each other. A table that policy never mentions is the finding governance exists to catch.

### Try It Yourself 12.1: Split the Credit Union's Responsibilities 🛠️

A small credit union runs its member database on a server in a back office. Its board wants to move to a managed cloud service to stop worrying about patching.

**Predict:** Before writing anything, predict which two of the seven tasks in the shared responsibility table will surprise the board by staying with the credit union. Write down why you picked those two.

**Run:** Build a three-column table with the columns Task, Who does the work after the move, and Who still decides. Fill one row for each of the seven tasks. Then add an eighth row for a task this chapter has not listed, and fill it the same way.

**Explain:** In one or two sentences, name what the credit union should ask the provider to show before signing. Then name the chapter that taught you why a provider's own success message is not enough.

### Quick Check 12.1 ✅

1. A vendor says its managed service "handles compliance for you." Name two decisions from the shared responsibility table that no provider can make, and say who makes each one.
2. Explain what a migration history table lets an auditor do that a folder of SQL files does not.
3. A manager says zero trust means buying a new product. Using the three demands table, name one control you already configured in this book that satisfies each demand.

---

## 12.2 Emerging Trends

The four practices in Section 12.1 are settled enough that most shops run some version of them. This section covers five ideas that are still moving. Some will be ordinary in a few years. Some will not. Your job is not to predict which. Your job is to describe each one accurately enough that you could test it when someone asks you to.

### Machine Learning in Administration

Tools now propose indexes, flag queries that look unlike last month's, group similar incidents, and draft summaries of a log. They are useful because they read more data than you can, and they are fallible because they infer from patterns instead of measuring your server.

Treat every proposal as a hypothesis with a test attached. An assistant reviewing Copperwind's monthly reports proposes one index on `tickets(status)`. It claims the index will speed both the open-ticket queue and the closed-ticket volume report. Chapter 8 taught you the instrument that settles the claim:

```sql
\connect copperwind_ops
CREATE INDEX idx_tickets_status ON tickets (status);
ANALYZE tickets;
EXPLAIN (COSTS OFF)
SELECT ticket_id, opened_at
FROM tickets
WHERE status = 'Closed';
EXPLAIN (COSTS OFF)
SELECT ticket_id, opened_at
FROM tickets
WHERE status = 'Open';
-- Output:
-- CREATE INDEX
-- ANALYZE
--              QUERY PLAN
-- -------------------------------------
--  Seq Scan on tickets
--    Filter: (status = 'Closed'::text)
--
--                    QUERY PLAN
-- ------------------------------------------------
--  Index Scan using idx_tickets_status on tickets
--    Index Cond: (status = 'Open'::text)
```

The assistant was half right, and the plans say which half. Almost every ticket in the table is closed, so the closed-ticket report still reads the whole table and ignores the index. Open tickets are rare, so that report uses the index. An index earns its disk and its write cost on the second report only. Had you accepted the claim whole, you would have reported a speedup that never happened.

That is the pattern for every tool in this family. Ask what measurement would show the tool was right, take the measurement, and record both. A proposal you tested and rejected is worth as much in a plan as one you adopted, because it tells the next administrator not to try it again.

### Vector Search

Your search tools today match words. An **embedding** is a list of numbers that a model produces from a piece of text, built so that texts with similar meaning produce nearby lists. **Vector search** finds rows whose embeddings sit closest to the embedding of your question, which lets a search match meaning rather than spelling.

The gap it fills is easy to measure. Copperwind's ticket summaries are written by technicians in their own words:

```sql
SELECT COUNT(*) FILTER (WHERE to_tsvector('english', summary)
                             @@ plainto_tsquery('english', 'password')) AS matches_password,
       COUNT(*) FILTER (WHERE to_tsvector('english', summary)
                             @@ plainto_tsquery('english', 'locked out')) AS matches_locked_out,
       COUNT(*) FILTER (WHERE category = 'Accounts') AS accounts_tickets
FROM tickets;
-- Output:
--  matches_password | matches_locked_out | accounts_tickets
-- ------------------+--------------------+------------------
--               781 |                  0 |             2655
```

Thousands of account tickets exist, and a search for "locked out" finds none of them, because nobody typed those words. Text search returns what was written. A vector search over the same summaries would rank the password resets and the multi-factor device replacements near that question, because their meaning is close even though their words are not.

PostgreSQL does not ship vector types in the core server. The `pgvector` extension adds a vector column type and index methods for similarity search, and it is the usual answer in a PostgreSQL shop. Three costs come with it, and all three belong in a plan. You need a model to produce the embeddings, which sends your text somewhere unless the model runs on your own hardware. You store a vector beside every row, which grows the table. And the results are ranked by similarity, so there is no exact answer to check them against.

That last cost is the security one. A ranked list feels authoritative. Suppose a clinic ran a similarity search over visit notes. A near match is still protected health information. The minimum necessary standard from Chapter 4 applies to it just as it applies to an exact match.

### Distributed SQL

**Distributed SQL** describes databases that spread one logical database across many servers, and often across regions, while still offering SQL and transactions that cross the whole set. Products in this family include CockroachDB, YugabyteDB, and Google Cloud Spanner. The promise is that a region can fail without the database failing, and that a database can grow past one machine without being split by hand.

PostgreSQL already gives you the two building blocks underneath that promise, and Chapter 8 used both. Replication keeps a copy on another server. Partitioning splits one large table into pieces. Distributed SQL products automate the coordination between them, and they charge for it in three ways. A write must reach more than one machine before it is confirmed, which adds delay. The software is harder to operate. The licensing or hosting is rarely free.

The management question is therefore not "is this faster" but "does this organization lose money when one server is down." Sandwash Family Clinic closes at 5 p.m. and has one location. Harquahala Charter Academy runs one campus. Neither one is the case that distributed SQL was built for, and saying so is a legitimate answer to a vendor.

### Confidential Computing

Chapter 6 encrypted data at rest and data in motion. One gap remained, and you noticed it there. Data must be decrypted to be computed on, so it sits in plain form in server memory while a query runs. **Confidential computing** closes that gap with hardware. The processor provides a **trusted execution environment**, a protected region of memory that the operating system and the hypervisor cannot read inside.

The reason to care is the cloud. If the database runs on someone else's hardware, confidential computing is what lets you say the host operator cannot read the data while a query runs. NIST defines the trusted execution environment this rests on, and names NIST IR 8320 as the publication behind that definition. A single product's claim is a different question, and Section 12.3 says where to settle it: the product's own documentation.

The costs are real. It depends on specific processor features, so it constrains where the database can run. It adds overhead, though how much depends on the workload. And it protects memory only, so every control from Chapters 4 through 7 still has to be there. A DBA who cannot answer "who may run this query" has not been helped by protecting the memory the query runs in.

### Privacy-Enhancing Technologies

A **privacy-enhancing technology** is any method that lets you use data while reducing what it reveals about an individual. You already used two. Chapter 4 de-identified records by removing direct identifiers, and Chapter 6 replaced a sensitive value with a token. **Differential privacy** is a newer method that adds measured noise to a published result, so that any one person's presence or absence cannot change the answer enough to be detected.

The reason these methods keep arriving is that removing names is not enough. Harquahala keeps a grade level and a date of birth for every student, and neither is a direct identifier:

```sql
\connect harquahala_academy
WITH group_sizes AS (
  SELECT grade_level, date_of_birth, COUNT(*) AS students_in_group
  FROM students
  GROUP BY grade_level, date_of_birth
)
SELECT SUM(students_in_group) AS students_described,
       COUNT(*) AS distinct_combinations,
       COUNT(*) FILTER (WHERE students_in_group = 1) AS groups_of_one
FROM group_sizes;
-- Output:
--  students_described | distinct_combinations | groups_of_one
-- --------------------+-----------------------+---------------
--                 800 |                   714 |           638
```

Most of the school is alone in its own group. A "de-identified" export carrying grade level and date of birth would name those students to anyone who knows a birthday, and a school community knows birthdays. That is re-identification. It is why the directory rules of the Family Educational Rights and Privacy Act (FERPA) in Chapter 4 turn on combinations of fields rather than on names alone.

Two habits follow. Check group sizes before you release an aggregate, and suppress or widen any group that is too small. Then say in the plan which method you used, because "de-identified" on its own does not tell the next reader whether anyone checked.

### Try It Yourself 12.2: Test a Tool's Claim on a Bike Shop 🛠️

A bike shop's point-of-sale vendor adds an assistant that proposes an index on the `sales` table and claims reports will run "up to ten times faster."

**Predict:** Before reasoning further, write down the two measurements you would need to accept or reject that claim, and predict which one the vendor is unlikely to have taken.

**Run:** Write the four steps you would run on the shop's server, in order, from baseline to verdict. Beside each step name what it produces. Then write the sentence you would send the owner if the plan after the change looked exactly like the plan before it.

**Explain:** In one or two sentences, explain why "up to ten times faster" is a claim about the vendor's data and not the shop's. Then name the plan line from Chapter 8 that settles the question locally.

### Quick Check 12.2 ✅

1. A clinic asks whether vector search over its visit notes would be safer than keyword search because the results are "just similarities." Judge the claim and name the Chapter 4 rule that decides it.
2. A school district publishes a table of average grades by grade level and month of birth. Name the risk in that table and the one check that would have caught it before release.
3. Compare confidential computing with column encryption from Chapter 6. Name the attack each one stops that the other does not.

---

## 12.3 Evaluating Adoption

A trend becomes your problem the day someone asks you to adopt it. **Cost-benefit analysis** is the comparison that weighs what an option costs over its life against what it returns, measured against the alternatives. This section gives you a six-step version that fits on one page, and an evidence standard that keeps it honest. The method does not tell you what to choose. It tells you what you must know before you choose.

### The Six-Step Method

| Step | What you produce | The trap it avoids |
| --- | --- | --- |
| 1. State the problem as a measurement | A number that is wrong today | Adopting a tool with no problem |
| 2. Name every option, including doing nothing | A short list | Comparing one option with itself |
| 3. Price the full cost | A total, not a sticker price | Missing migration and training |
| 4. Estimate the benefit in the same units as step 1 | A predicted number | Benefits that cannot be checked |
| 5. Name the risks and the control each one needs | A risk row per option | Discovering the risk after signing |
| 6. Pilot it, with the decision rule written first | A verdict you cannot argue with | Reading the result to fit the hope |

Step 3 deserves a name. **Total cost of ownership** is the full cost of an option over its life. It includes the license or hosting fee, the migration work, the training, the extra monitoring, and the staff time to run it. **Switching cost** is what it takes to leave later, and a vendor rarely volunteers it. Ask how the data comes out, in what format, and who has done it.

Step 6 deserves a name too. A **pilot** is a limited trial with a stated scope, a stated duration, and a decision rule written before the trial starts. Writing the rule first is the whole point. "We will adopt it if the monthly report drops below two minutes" is a rule. "We will see how it goes" is not.

### What Counts as Evidence

An **evidence standard** is the rule you apply to a claim before you let it into a decision. Rank your sources, and say in the recommendation which rank each claim came from:

| Rank | Source | What it can settle |
| --- | --- | --- |
| 1 | Your own measurement on your own data | Whether it works here |
| 2 | The product's own documentation | What it claims to do and how it is configured |
| 3 | A standards body such as NIST or the release notes of your database | What a term means and what a version shipped |
| 4 | A vendor's case study or webinar | What the vendor wants you to consider |
| 5 | "Studies show" with no study named | Nothing |

Rank 5 is not a joke. A sentence with no source behind it cannot be checked, so it cannot be defended when the decision goes badly. If you cannot name the study, drop the sentence.

Two rules make the ranking usable. First, any claim about your own performance, cost, or risk needs rank 1 evidence before it goes in a plan. Second, any claim about what a product does needs rank 2 evidence, quoted with a link, because vendor documentation changes and your plan should record what it said when you read it.

### Scoring Without Hiding

Once you have the evidence, a score keeps the comparison visible. Copperwind is weighing three candidates for the coming year. The weights below are Copperwind's own, and Mei Lin set them: benefit counts double because the practice is short on people, and cost and risk each count once.

```sql
WITH candidate (technology, benefit_score, cost_score, risk_score) AS (
  VALUES ('Managed cloud database', 4, 3, 2),
         ('Vector search for ticket triage', 3, 2, 3),
         ('Confidential computing host', 2, 5, 4)
)
SELECT technology,
       benefit_score,
       cost_score,
       risk_score,
       benefit_score * 2 - cost_score - risk_score AS net_score
FROM candidate
ORDER BY net_score DESC;
-- Output:
--            technology            | benefit_score | cost_score | risk_score | net_score
-- ---------------------------------+---------------+------------+------------+-----------
--  Managed cloud database          |             4 |          3 |          2 |         3
--  Vector search for ticket triage |             3 |          2 |          3 |         1
--  Confidential computing host     |             2 |          5 |          4 |        -5
```

The ranking is not the decision. It is a record of the reasoning, and its value is that someone can disagree with a specific number instead of with your judgment as a whole. Change the weight on cost and the order can change, which is exactly the conversation a manager should be having.

### Writing the Recommendation

Write the recommendation as a condition, never as a certainty. A conditional recommendation names what you believe, what it rests on, and what would change your mind:

> If two conditions hold, the managed service costs less staff time than it saves. The clinic's monthly volume must stay under 700 appointments, and the provider's restore drill must meet a four-hour target in our own test. If either number moves, this recommendation does not hold and we re-run the pilot.

Compare that with "the cloud is the future." One sentence can be checked in three months. The other cannot be checked at all. Every prediction you write about a trend belongs in the first form.

### Try It Yourself 12.3: Weigh a Proposal for a City Parks Department 🛠️

A city parks department runs a reservation database for 40 ballfields. A vendor proposes a distributed SQL platform, citing "always available" and "unlimited scale."

**Predict:** Before reasoning further, predict which of the six steps the vendor's proposal has already done for you, and which step will be hardest for the department to complete on its own.

**Run:** Work the six steps for this proposal and record one line per step. For step 2 include doing nothing. For step 5 name at least two risks with the control each one needs. Then rank each of the vendor's two claims on the five-rank evidence table and say what would move it up one rank.

**Explain:** In one or two sentences, write the conditional recommendation you would send the parks director, including the one measurement that would reverse it.

### Quick Check 12.3 ✅

1. A proposal lists a license fee and nothing else. Name three costs missing from it and say which of the six steps catches them.
2. Explain why the decision rule for a pilot has to be written before the pilot runs, and give one example of a rule that is not testable.
3. A colleague writes "vector search will replace keyword search within two years." Rewrite the sentence as a conditional prediction with a stated measurement.

---

## 12.4 The Management and Security Plan

Everything so far in this book was a piece. The plan is the document that holds the pieces together for one organization, in language a manager can act on and an auditor can check. This section shows its shape, the evidence habit that fills it, and the way the work in it maps to jobs.

### What the Plan Contains

A **management and security plan** is a single document that states how one organization's database is designed, protected, kept fast, recovered, and defended, with evidence for each claim. Nine sections cover it, and you built every one:

| Plan section | The question it answers | Chapters | Evidence it carries |
| --- | --- | --- | --- |
| 1. Scope and ownership | Which database, and who signs | 1 | Named owner and reviewer |
| 2. Architecture | Where it runs and why | 2, 3 | Version, size, table count |
| 3. Access control | Who may do what | 5 | Role and grant listing |
| 4. Compliance | Which rules apply and how | 4 | Classification and retention table |
| 5. Performance and capacity | What must stay fast | 8 | Execution plans and timings |
| 6. Recovery and availability | How fast it comes back | 9 | Drill time and count check |
| 7. Incident response | What happens when it fails | 10 | Contact list and containment step |
| 8. Skills matrix | Who does this work | 11, 12 | Task-to-role mapping |
| 9. Open items | What is still unanswered | all | Owner and blocker per item |

The template in `assets/code/chapter-12/management-security-plan-template.md` carries these headings with a prompt under each. Its outline looks like this:

```text
1. Scope and Ownership        6. Recovery and Availability
2. Architecture               7. Incident Response
3. Access Control             8. Skills Matrix
4. Compliance                 9. Open Items
5. Performance and Capacity
```

One rule governs the whole document. A blank cell is a finding, not an omission. Write "not decided yet," name who owes the answer, and move it to section 9. A plan with honest gaps is useful. A plan with invisible gaps is dangerous, because a reader assumes the silence means everything is fine.

### Evidence, Not Intention

Sections 2, 3, and 6 each need output from the server, and the queries are short. The architecture section needs four facts about the database it covers:

```sql
\connect copperwind_ops
-- Step 1: Record which database and which server version the evidence came from
-- Step 2: Measure the size the capacity section has to plan around
-- Step 3: Count the tables in scope, so the later sections cannot skip one
SELECT current_database() AS database_name,
       split_part(current_setting('server_version'), ' ', 1) AS server_version,
       pg_size_pretty(pg_database_size(current_database())) AS total_size,
       (SELECT COUNT(*) FROM pg_class
        WHERE relkind = 'r'
          AND relnamespace = 'public'::regnamespace) AS table_count;
-- Output:
--  database_name  | server_version | total_size | table_count
-- ----------------+----------------+------------+-------------
--  copperwind_ops | 17.11          | 15 MB      |           5
```

Four columns, one row, and every later section can be checked against it. The size includes the index Section 12.2 created, so a freshly loaded copy of Copperwind reads a little smaller. That is not a problem. It is the reason evidence carries the date it was taken.

The access section needs the grants themselves, read back from the server rather than copied from the request that asked for them:

```sql
-- Step 1: Create the role the plan's access section defines, with no login of its own
CREATE ROLE copperwind_reporting NOLOGIN;
-- Step 2: Grant only the two tables the monthly report reads, and nothing else
GRANT SELECT ON clients, tickets TO copperwind_reporting;
-- Step 3: Read the grants back, because the plan cites the server and not the ticket
SELECT grantee, table_name, privilege_type
FROM information_schema.role_table_grants
WHERE grantee LIKE 'copperwind\_%'
ORDER BY table_name;
-- Output:
-- CREATE ROLE
-- GRANT
--        grantee        | table_name | privilege_type
-- ----------------------+------------+----------------
--  copperwind_reporting | clients    | SELECT
--  copperwind_reporting | tickets    | SELECT
```

Two rows, and they are the two the plan claimed. Chapter 5 made this point with a role hierarchy. The plan makes it again at the document level: the access table in section 3 is a promise, and this query is the proof beside it.

### Fix It 12.1: The Summary Query That Would Not Group 🔧

Copperwind's plan needs one line per client sector, so its compliance section can say which regulations reach which clients. Your first attempt at the rollup stops before it prints anything.

**Symptom:** You ask for tickets per client sector and the server refuses the query.

```text
SELECT t.client_id, COUNT(*) AS ticket_count
FROM tickets AS t
JOIN clients AS c ON c.client_id = t.client_id
GROUP BY c.sector;
```

```text
ERROR:  column "t.client_id" must appear in the GROUP BY clause or be used in an aggregate function
```

**Diagnose:** Name the cause in one sentence before touching the code. The query groups by sector, so every column in the select list must either be one of the grouping columns or be wrapped in an aggregate, and `t.client_id` is neither.

**Repair:** Decide what the plan needs before you edit. The plan wants one row per sector, so `client_id` should not be a bare column at all. Count the distinct clients instead, which answers the plan's real question:

```sql
SELECT c.sector,
       COUNT(*) AS ticket_count,
       COUNT(DISTINCT t.client_id) AS client_count
FROM tickets AS t
JOIN clients AS c ON c.client_id = t.client_id
GROUP BY c.sector
ORDER BY ticket_count DESC;
-- Output:
--    sector   | ticket_count | client_count
-- ------------+--------------+--------------
--  Retail     |         4170 |            9
--  Healthcare |         4124 |            9
--  Nonprofit  |         4084 |            9
--  Education  |         3208 |            7
--  Legal      |         2654 |            6
```

**Verify:** How do you know it is fixed? Name the two signals: the query returns instead of erroring, and it returns exactly one row per sector, so the row count matches the number of sectors the plan lists.

### The Skills Matrix

A **skills matrix** is a table that maps the work recorded in a plan to the roles that own it in a larger organization, citing the plan's own evidence for each row. In a small organization one person covers all of that work, which is what you did in this book. In a larger one the work splits, and knowing the split lets you say what you have done in words a hiring manager or a department head already uses.

| Plan section | What you did in this book | Role that owns it elsewhere |
| --- | --- | --- |
| Architecture | Sized a database and placed it in a network tier (Chapters 1, 2) | Database administrator |
| Access control | Built roles, grants, and row-level security, then proved them (Chapter 5) | Database administrator with security review |
| Compliance | Classified data, wrote retention, separated protected columns (Chapter 4) | Data steward and compliance analyst |
| Performance | Read execution plans and measured a change (Chapter 8) | Database administrator |
| Recovery | Wrote targets and proved them with a timed restore (Chapter 9) | Database administrator and operations engineer |
| Incident response | Contained an incident without destroying evidence (Chapter 10) | Security analyst |
| Routine review | Ran a scheduled review against a benchmark (Chapter 11) | Security analyst and database administrator |

Fill the matrix from what your own plan shows, never from what you meant to do. The evidence column in the template is what keeps it honest. If section 6 of your plan has no drill time in it, the recovery row of your matrix has nothing to cite, and the fix is to run the drill.

### Try It Yourself 12.4: Turn a Gap into an Open Item 🛠️

A draft plan for the academy has a complete access table and a recovery section that reads "backups run nightly."

**Predict:** Before reading further, predict which two of the plan's nine sections that recovery sentence leaves unproven, and name the number the sentence is missing.

**Run:** Rewrite the recovery section as one open item in the section 9 format: the item, the owner, and what it blocks. Then write the two sentences you would add to section 6 once the missing measurement exists, leaving a blank where the number goes.

**Explain:** In one or two sentences, explain why moving the gap to section 9 is better than leaving the sentence as written, and name the reader who is misled by the original.

### Try It Yourself 12.5: Write the Evidence Queries for All Three 🛠️

The template is in `assets/code/chapter-12/management-security-plan-template.md`, and three sections of it ask for query output: architecture, access control, and recovery. No worked script follows this time. You write all three.

The architecture evidence is one row per database. The access evidence answers whether any table is readable by `PUBLIC`, which must be false on every row. The recovery evidence is the acceptance check a restore has to pass, which is one row per table with its expected count.

**Predict:** Name the approach before you type. For each of the three sections, say which catalog view or which tables you will read, and predict which of the three databases will report the largest table count and why.

**Run:** Write the three queries and run the architecture one in each of the three databases, the access one in `harquahala_academy`, and the recovery one in `harquahala_academy`. Compare your architecture rows and your recovery counts against these:

```text
 database_name  | server_version | total_size | table_count 
----------------+----------------+------------+-------------
 copperwind_ops | 17.11          | 15 MB      |           5

  database_name  | server_version | total_size | table_count 
-----------------+----------------+------------+-------------
 sandwash_clinic | 17.11          | 9790 kB    |           5

   database_name    | server_version | total_size | table_count 
--------------------+----------------+------------+-------------
 harquahala_academy | 17.11          | 10022 kB   |           9

    table_name     | row_count 
-------------------+-----------
 courses           |        40
 enrollments       |      6000
 grades            |      6000
 guardians         |      1201
 portal_accounts   |      1201
 sections          |       120
 staff             |        60
 student_guardians |      1253
 students          |       800
```

**Explain:** Your Copperwind size reads 15 MB only after Section 12.2 added an index, and a freshly loaded copy reads less. In one or two sentences, explain what that tells you about how a plan should record evidence, and name the field the template asks for that makes the difference readable.

### Quick Check 12.4 ✅

1. A plan's access section lists four roles and cites no query. Name what the section is missing and the one command that would supply it.
2. Explain why a blank cell in the plan belongs in section 9 rather than staying blank, and name the reader the blank misleads.
3. A colleague's skills matrix claims incident response experience, and the plan's section 7 is empty. Judge the claim and say what evidence would support it.

---

## 12.5 Summary and Retrieval 💡

### Key Concepts

* Current practice rearranges work you already know. A managed service absorbs labor and leaves judgment with you. Database DevOps ships changes as versioned files and records which ones ran. Zero trust removes the trusted network and restates verification, least privilege, and logging. Data governance keeps the inventory, the classification, and the owner list current.
* Emerging technology arrives as a claim. Machine learning proposes, and the execution plan decides. Vector search matches meaning where keyword search matches spelling, and it adds a model, storage, and an inexact answer. Distributed SQL buys survival across regions and charges for it in latency, complexity, and price. Confidential computing protects data in memory and leaves every other control in place. Privacy-enhancing technologies reduce what a released result reveals.
* Removing names does not de-identify a dataset. Combinations of ordinary fields can single out a person, so check the size of every group before you publish an aggregate and suppress the small ones.
* The six-step adoption method starts with a measured problem and lists every option, including doing nothing. It prices total cost of ownership and switching cost, then estimates the benefit in the same units. It names the risks with their controls and ends in a pilot whose decision rule was written first.
* Evidence has ranks. Your own measurement settles what happens here. Product documentation settles what a product claims. A standards body settles what a term means. Anything with no source named settles nothing.
* The management and security plan holds nine sections, and three of them carry query output as proof. A blank cell is a finding that belongs in the open items section with an owner beside it. The skills matrix maps the plan's work to the roles that own it, and every row cites the evidence already in the document.

### Key Terms

See course glossary for full definitions

* database DevOps, infrastructure as code, schema migration, zero trust, data governance, data steward (Section 12.1)
* embedding, vector search, distributed SQL, confidential computing, privacy-enhancing technology, differential privacy (Section 12.2)
* cost-benefit analysis, total cost of ownership, switching cost, pilot, evidence standard (Section 12.3)
* management and security plan, skills matrix (Section 12.4)

### Retrieval Practice

1. From memory, name the three demands of zero trust and one control from this book that satisfies each.
2. State the six steps of the adoption method in order, and name the step that keeps a pilot honest.
3. Explain why an index proposal has to be tested on your own data, and name the command that tests it.
4. From Chapter 10: Name the six stages of the incident response lifecycle in order, and state which stage produces the document that changes the next version of your plan.
5. From Chapter 8: A backup file and a standby server both hold a second copy of the data. Name one security control each copy inherits from the original, and say why a copy nobody tracks is a compliance problem.

---

## 12.6 Skills Lab 12A: Capstone: The Management and Security Plan

**Goal:** Choose one of the three organizations you have managed all book long and deliver its complete management and security plan. The plan carries query output from the server under its architecture, access, and recovery sections, an adoption decision for one emerging technology, and a skills matrix that cites the plan itself.

**Dataset or starter files:** `assets/code/chapter-12/` in the course data pack. `setup-copperwind.sql`, `setup-sandwash.sql`, and `setup-harquahala.sql` rebuild the three databases, and you need only the one you choose. `management-security-plan-template.md` is the plan you fill. `skills-lab-12a.sql` is the starter script with numbered markers, and `skills-lab-12a-answers.md` holds the plan, the adoption decision, the matrix, and the two Questions & Analysis answers. All three organizations and every record in them are fictional.

Choose Copperwind IT Services, Sandwash Family Clinic, or Harquahala Charter Academy. Every part below applies to the one you chose. Say which one you chose in the first line of your answer file, and say why in one sentence.

### Part 1: Foundation (Aligns with Objective 12.3)

1. From the extracted `cis376` folder, run the setup script for your organization as `postgres`. Under marker 1.1, run the architecture evidence query and paste the result. Fill sections 1 and 2 of the template from it, including the service model you recommend and the reason.
2. Under marker 1.2, list every table in your database with its row count, and under marker 1.3 check whether `PUBLIC` can read any of them. Paste both results. Fill the compliance table in section 4 with one row per regulation that applies, naming the data it covers and the control that answers it.
3. In the answer file, complete section 3 by naming at least three roles your organization needs, what each may read or change, and who approves it. Create one of them on the server with the organization prefix, grant it the minimum it needs, and paste the grant listing as evidence under marker 1.4.

### Part 2: Application (Aligns with Objectives 12.2 and 12.3)

1. Complete sections 5, 6, and 7 of the template. Under marker 2.1, capture the plan of the one report that must stay fast, using `EXPLAIN (COSTS OFF)`. Under marker 2.2, produce the recovery acceptance check: one row per table with its expected count. Paste both.
2. In section 6, set a recovery time objective and a recovery point objective, name who signs them, and state the backup method they imply. In section 7, name who is called first, the containment step that preserves evidence, and the notification obligation this data can trigger.
3. Pick one emerging technology from Section 12.2 and work the six-step method for your organization. Record one line per step in the answer file. Under marker 2.3, run one query that measures the problem the technology claims to solve, so step 1 rests on your own data rather than on the vendor's.

### Part 3: Extension (Aligns with Objectives 12.1 and 12.2)

1. Score your chosen technology against doing nothing, using a scoring query like the one in Section 12.3 under marker 3.1. State the weights you used and why the organization would choose them. Paste the result.
2. Write the recommendation as a conditional: what you recommend, the two measurements it rests on, and the change that would reverse it. Rank every claim you make against the five-rank evidence table and label each one in the text.
3. Fill section 8, the skills matrix, from your finished plan. One row per completed section, each citing the evidence already in the document. Then write a one-page summary for the data owner that names the plan's strongest section, its weakest, and the first open item you would close.

### Questions & Analysis 🤔

1. Your plan's section 9 lists the open items you could not close. Choose the one you consider most serious and explain, with evidence from your own plan, what it leaves unproven. Then describe what would have to happen for a data owner to sign the plan with that item still open.
2. Compare the technology you evaluated in Part 2 against doing nothing, using your Part 3 score as evidence. Explain which single number in your evaluation carries the most weight, and describe the measurement that would change your recommendation.

**Submission:** Submit one folder named `skills-lab-12a-lastname`. It holds `skills-lab-12a.sql` with every result pasted as `-- Output:` comment lines (or the saved psql output beside it). It also holds `skills-lab-12a-answers.md` with the completed plan, the six-step adoption record, the conditional recommendation, the skills matrix, and your two Questions & Analysis answers clearly labeled.

### Rubric: Skills Lab 12A

This lab is graded with the standard
[Skills Lab Rubric](../skills-lab-rubric.md): four criteria, five
levels from Mastery to Not Evident. The criteria are Technical
Accuracy and Efficiency, Output Quality, Documentation Quality, and
Analysis, Interpretation, and Response to QUESTION(s). The criteria
and levels are the same everywhere. Your instructor sets the point
values in your course. Check the syllabus and the Canvas rubric
attached to this lab for the values that apply to you.

---

## 12.7 Review Questions 🔄️

1. **Apply:** A law office moves its case database to a managed cloud service. Using the shared responsibility table, name three tasks the office stops doing, two decisions it keeps, and the one test it must still run itself before it can claim the data is recoverable.

2. **Analyze:** A food bank publishes a monthly table of donations by ZIP code and donor age band. Break down where re-identification could occur, name the check that would find it, and state what the food bank should change if a group holds fewer than five donors.

3. **Evaluate:** A vendor claims its distributed SQL platform gives "always available" service and cites a case study from a national retailer. Judge that claim for a single-campus school, rank the evidence on the five-rank table, and state the one measurement that would move the claim to rank 1.

4. **Create:** Design the skills matrix for a two-person IT shop that runs one regulated database. Name at least five tasks from this book, the role that owns each one, and the evidence in a plan that would prove the task was done rather than only intended.

---

## Further Reading 📖

* [PostgreSQL 17 Release Notes](https://www.postgresql.org/docs/17/release-17.html) - What the version you run shipped, and the first place to check any claim that PostgreSQL now does something.
* [PostgreSQL Documentation: High Availability, Load Balancing, and Replication](https://www.postgresql.org/docs/17/high-availability.html) - The replication and failover baseline that distributed SQL products build on, and the vocabulary to hold their claims against.
* [pgvector](https://github.com/pgvector/pgvector) - The extension's own documentation for vector columns, distance operators, and index methods in PostgreSQL.
* [NIST SP 800-207: Zero Trust Architecture](https://csrc.nist.gov/pubs/sp/800/207/final) - The federal description of zero trust, including the tenets Section 12.1 maps onto database controls.
* [NIST Glossary: Trusted Execution Environment](https://csrc.nist.gov/glossary/term/Trusted_Execution_Environment) - The standards-body definition of the protected processor region confidential computing rests on, with NIST IR 8320 named as its source publication.
* [NIST SP 800-188: De-Identifying Government Datasets](https://csrc.nist.gov/pubs/sp/800/188/final) - Re-identification risk, group-size checks, and the formal privacy methods Section 12.2 introduces.

---

## Course Conclusion: Where You Go from Here

You started this book with a server you had never installed and a role you had never held. You end it with a plan a manager could sign. Between those two points you granted and revoked access, encrypted a column, and read an audit trail. You tuned a report, restored a database on a clock, contained an incident, and judged a technology on evidence instead of enthusiasm. That sequence is the job, and you have now done all of it once.

Three habits are worth carrying past the last page. Measure before you change anything, because a change with no baseline cannot be defended. Follow every configuration with the query that proves it, because configuration without verification is a guess. Write down what you found while it is still true, because the next person to read your plan may be you, a year from now, at 4 a.m.

The engine changes and the questions do not. Oracle, MySQL, SQL Server, and every managed service in the cloud ask the same five questions this book asked. What are we building? Who may see it? What is it doing? How does it come back? What should we change? Take the plan you wrote in Skills Lab 12A to whatever server you meet next. The syntax will be different. The document will not.
