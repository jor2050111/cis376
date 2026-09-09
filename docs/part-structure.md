# CIS376 Textbook: 12-Chapter Structure (Authoritative)

**Course:** CIS376: Database Management and Security
**Structure:** 12 chapters organized into 4 thematic Parts
**Pacing:** Schedule-neutral. Instructors may use the book in 9-, 12-,
14-, or 16-week courses without changing chapter content. Calendars,
due dates, exams, and project pacing live in the course shell.
**Prerequisite:** One prior SQL course (Introduction to Oracle: SQL,
CIS276DA MySQL Database, or CIS276DB SQL Server Database). Chapters
bridge from SQL in one sentence and never reteach it.
**Last revised:** 2026-09-09

This document is the single authoritative plan for chapter order,
scope, and outcome coverage.

---

## Design Rationale

This plan synthesizes four sources:

1. **The district CLOs and course outline** (docs/CIS376_CLOs.md):
   every outcome and every outline line maps to a chapter.
2. **The previous 14-module Canvas build and its QM course map**
   (2025-03-01): the three MLOs per module and their CLO alignment
   were the one part of the old material worth keeping. This plan
   keeps their intent, tightens their verbs, and binds each to a
   teaching section.
3. **Mr. Vega's ruling of 2026-09-09:** the CLOs are management and
   security outcomes. SQL and database internals matter only as far
   as they serve a management or security decision. PostgreSQL 17 is
   the lab engine because roles, grants, row-level security,
   encryption, TLS, logging, backups, and execution plans all run for
   real on a free, cross-platform server.
4. **The textbook family structure:** 12 chapters in 4 Parts, the
   pattern proven by CIS215 and CIS133, with the five pedagogy
   upgrades built in from the first draft rather than retrofitted.

**Key design decisions:**

* **14 modules became 12 chapters through two merges.** Old modules 2
  (infrastructure) and 3 (requirements) merge into Chapter 2, because
  both are planning decisions made before a database exists. Old
  modules 13 (trends) and 14 (synthesis) merge into Chapter 12, the
  capstone. Old module 12 (best practices) becomes Chapter 11 and
  absorbs outline section III.F (routine performance and security
  analysis), which no old module covered.
* **Encryption moved earlier.** Old module 8 (encryption) now sits at
  Chapter 6, closing Part II, because encryption is an access decision
  in disguise: it answers "who can read this if every other control
  fails." Auditing (old module 7) opens Part III, because logs are the
  instrument every later chapter reads.
* **Every chapter runs SQL, but no chapter is about SQL.** Each
  chapter's hands-on work configures, inspects, or verifies a
  management or security control on a live PostgreSQL server. Query
  writing is assumed.
* **One recurring spine, two regulated clients.** Copperwind IT
  Services (the family's fictional MSP) manages databases for Sandwash
  Family Clinic (HIPAA) and Harquahala Charter Academy (FERPA). Every
  chapter returns to one of the three databases in one Try It Yourself
  and in the Skills Lab. Details in
  docs/book-design-spec-2026-09-09.md.

**Bloom's rule for every MLO (course-configured, mirrors CLAUDE.md):**
CIS376 is a 300-level course with a prerequisite, so the band is Apply
through Create. Every chapter carries at least one Analyze or Evaluate
MLO. Remember and Understand verbs never appear in an MLO. Every MLO
uses a measurable action verb and ends with its teaching-section
binding.

---

## Part I: Architecture and Design (Chapters 1-3)

**Theme:** decide what to build, where it runs, and what shape the data
takes before anyone can attack or misuse it
**Learning arc:** Map the management job -> Place and size the server -> Model the data for integrity
**Outcome alignment:** CLO I (primary), II, III, V (supporting)
**Bloom's focus:** Apply, Analyze, Evaluate, with one Create

### Chapter 1: Database Management and Security Fundamentals

**Subtitle:** MAP the database management job and its security stakes
**Outcome(s):** CLO I, II, V
**Outline section(s):** I.A.4 (tools and software), V.A (current
practice, introduced)

**Sections:**

* 1.1 The management view of a DBMS: what a DBMS does, and who is
  responsible for what (database administrator, security administrator,
  data owner, developer, auditor)
* 1.2 The CIA triad applied to databases: confidentiality, integrity,
  availability, the common threats to each, and the control families
  that answer them
* 1.3 Your lab environment: PostgreSQL 17, psql, and pgAdmin. Meet
  Copperwind IT Services and its two regulated clients. Load the three
  course databases from the data pack.
* 1.4 The management lifecycle this book follows: plan, secure,
  monitor, recover, review. How the five CLOs fit together.

**MLOs:**

* **1.1 (Analyze):** Distinguish the responsibilities of a database administrator, a security administrator, and a data owner across the functions of a DBMS (Section 1.1)
* **1.2 (Apply):** Apply the CIA triad to classify database threats and match each to the control family that addresses it (Section 1.2)
* **1.3 (Apply):** Install PostgreSQL, psql, and pgAdmin, load the course databases, and run a baseline health check on a server you manage (Section 1.3)

**Skills Lab 1A:** Stand Up the Copperwind Lab. Install, load all three
databases, produce a baseline health report (sizes, roles, settings),
and classify the first five threats in a Copperwind risk register.

**Prior-course parallel:** Old module 1 (fundamentals). The old chapter
spent 1,200 lines on database history and DBMS product lists. This
chapter spends its length on responsibilities, threats, and a working
server.
**Prerequisite bridge:** students know tables, keys, and queries. This
chapter asks who is allowed to run those queries and who answers when
they go wrong.

### Chapter 2: Infrastructure and Requirements

**Subtitle:** PLACE and SIZE a database server for a business
**Outcome(s):** CLO I, III
**Outline section(s):** I.A.1-3 (service model, network tiers, IAM),
I.B (hardware, size, throughput, usage), III.E (cloud security
services, introduced)

**Sections:**

* 2.1 Service models: on-premise, cloud infrastructure, and managed
  database services. Cost, control, compliance, and shared
  responsibility.
* 2.2 Network placement: security tiers and zones, the database tier,
  listen addresses, firewalls, and PostgreSQL's own gate
  (`pg_hba.conf`)
* 2.3 Identity and access management foundations: identity,
  authentication, authorization, service accounts, single sign-on,
  and what the database delegates to IAM (applied fully in Chapter 5)
* 2.4 Specification requirements: measuring size, throughput, and usage
  from a running server and turning the numbers into a hardware and
  growth estimate

**MLOs:**

* **2.1 (Evaluate):** Compare on-premise, cloud infrastructure, and managed database service models against the cost, control, and compliance needs of a given organization (Section 2.1)
* **2.2 (Create):** Design a network placement for a database server across security tiers and express its trusted-client rules in a host-based authentication file (Sections 2.2-2.3)
* **2.3 (Analyze):** Estimate database size, throughput, and hardware needs from measured usage statistics (Section 2.4)

**Skills Lab 2A:** Place and Size the Sandwash Clinic Database. Measure
the clinic database, project 3 years of growth, recommend a service
model, draw the tier placement, and write the `pg_hba.conf` rules.

**Prior-course parallel:** Old modules 2 and 3, merged.
**Prerequisite bridge:** none needed beyond connecting with a client.

### Chapter 3: Data Modeling and Integrity

**Subtitle:** MODEL data so the database defends its own correctness
**Outcome(s):** CLO I, III, V
**Outline section(s):** I.C.1 (integrity support), I.C.2 (usage
analysis, relational vs NoSQL)

**Sections:**

* 3.1 Integrity the database enforces: constraints (primary key,
  foreign key, unique, check, not null), transactions, and ACID under
  concurrent use
* 3.2 Usage analysis: transactional versus reporting workloads and why
  the same data takes two shapes (normalized tables, reporting views,
  and materialized views)
* 3.3 Relational, NoSQL, and Big Data: when each model fits, and JSONB
  as the relational bridge to semi-structured data
* 3.4 Normalization as an integrity and separation tool: reorganizing a
  flat import into Third Normal Form and what that buys security

**MLOs:**

* **3.1 (Apply):** Implement integrity constraints and transactions that keep a database consistent under concurrent use (Section 3.1)
* **3.2 (Evaluate):** Justify a relational, NoSQL, or hybrid data model for a transactional or reporting workload (Sections 3.2-3.3)
* **3.3 (Create):** Reorganize a flawed flat schema into Third Normal Form and explain how the redesign supports integrity and data separation (Section 3.4)

**Skills Lab 3A:** Redesign the Harquahala Gradebook. Normalize the
academy's flat gradebook export to 3NF, add the constraints that make
bad grades impossible to store, and build one reporting view.

**Prior-course parallel:** Old module 4.
**Prerequisite bridge:** students have written CREATE TABLE with keys.
This chapter treats each constraint as a security control.

**Part I milestone:** students can describe, place, size, and model a
database for a named organization and defend each decision.

---

## Part II: Securing Access and Data (Chapters 4-6)

**Theme:** decide who may see what, prove it with configuration, and
protect the data when every other control fails
**Learning arc:** Classify by regulation -> Grant by role -> Encrypt what remains exposed
**Outcome alignment:** CLO II (primary), I, III (supporting)
**Bloom's focus:** Apply, Analyze, Create

### Chapter 4: Compliance: HIPAA, FERPA, Retention, and Separation

**Subtitle:** CLASSIFY data under HIPAA and FERPA and build the separation the law expects
**Outcome(s):** CLO I, II, III
**Outline section(s):** I.D.1 (HIPAA), I.D.2 (FERPA), I.D.3
(separation, retention)

**Sections:**

* 4.1 HIPAA for the database team: protected health information, the
  Security Rule's administrative, physical, and technical safeguards,
  and the minimum necessary standard
* 4.2 FERPA for the database team: education records, directory
  information, legitimate educational interest, and parent versus
  eligible-student rights
* 4.3 Data classification and separation: classification levels,
  schemas as boundaries, views as column filters, and separating
  identifiers from sensitive attributes
* 4.4 Retention and disposal: retention schedules, secure deletion,
  legal holds, and documenting what was destroyed and when

**MLOs:**

* **4.1 (Analyze):** Classify data elements in a clinic database and a school database as protected health information, education records, directory information, or public data under HIPAA and FERPA (Sections 4.1-4.2)
* **4.2 (Apply):** Implement data separation with schemas and views so each user group sees only the columns its regulation allows (Section 4.3)
* **4.3 (Create):** Write a data retention and disposal policy that satisfies a stated regulatory requirement and can be enforced in the database (Section 4.4)

**Skills Lab 4A:** Classify and Separate Sandwash Clinic Data. Build a
classification register, move PHI behind a restricted schema, expose a
minimum-necessary view for front-desk staff, and write the clinic's
retention policy.

**Prior-course parallel:** Old module 5.

### Chapter 5: Access Control and Role-Based Security

**Subtitle:** GRANT the least privilege each role needs and prove it
**Outcome(s):** CLO II, III
**Outline section(s):** II.A.1-4 (service accounts, user management,
role-based access, access review), I.A.3 (IAM, applied)

**Sections:**

* 5.1 Authentication: login roles, password policy (SCRAM), connection
  limits, service accounts versus people, and what the server logs
* 5.2 Authorization: privileges, GRANT and REVOKE, schema USAGE, default
  privileges, and the least-privilege rule
* 5.3 Role-based access control: group roles, inheritance, and
  row-level security policies that filter rows by who is asking
* 5.4 Access reviews: querying the catalog for effective privileges,
  finding drift, and documenting the review

**MLOs:**

* **5.1 (Create):** Design an access control matrix for a database environment with at least three user roles and map each cell to a privilege (Sections 5.1-5.2)
* **5.2 (Apply):** Implement role-based access control with group roles, least-privilege grants, and row-level security policies (Section 5.3)
* **5.3 (Analyze):** Audit effective privileges from the system catalog and identify violations of least privilege (Section 5.4)

**Skills Lab 5A:** Roles for the Clinic. Design the matrix for four
clinic roles, implement it, add row-level security so providers see
only their own patients, and run an access review that catches a
planted over-grant.

**Prior-course parallel:** Old module 6.

### Chapter 6: Encryption at Rest and in Motion

**Subtitle:** ENCRYPT data where access control cannot reach
**Outcome(s):** CLO II, III
**Outline section(s):** II.C.1 (encryption at rest versus in motion),
II.C.2 (other retrieval concepts: hashing, tokenization)

**Sections:**

* 6.1 Encryption concepts for managers: symmetric, asymmetric, hashing,
  keys, and the threat each one answers
* 6.2 Data at rest: volume encryption, column encryption with pgcrypto,
  password hashing, and key management outside the database
* 6.3 Data in motion: TLS for client connections, server certificates,
  `sslmode`, and `hostssl` rules
* 6.4 Choosing controls: what encryption does and does not protect
  against, performance cost, and the questions to ask a cloud provider

**MLOs:**

* **6.1 (Analyze):** Contrast symmetric encryption, asymmetric encryption, and hashing by the threat each addresses in a database environment (Section 6.1)
* **6.2 (Apply):** Protect sensitive columns at rest with hashing and column-level encryption while keeping the data usable for authorized queries (Section 6.2)
* **6.3 (Apply):** Configure and verify TLS-protected connections so data in motion cannot be read on the network (Section 6.3)

**Skills Lab 6A:** Encrypt Harquahala Guardian Contacts. Hash portal
passwords, encrypt guardian contact fields with pgcrypto, verify TLS on
the connection, and write the key-handling procedure.

**Prior-course parallel:** Old module 8, moved earlier.

**Part II milestone:** students can classify a regulated dataset,
implement the roles and views that enforce the classification, and
encrypt what remains exposed, with evidence from the server.

---

## Part III: Monitoring, Performance, and Availability (Chapters 7-9)

**Theme:** watch the server, keep it fast, and keep it recoverable
**Learning arc:** Audit what happens -> Tune and replicate -> Plan recovery and close vulnerabilities
**Outcome alignment:** CLO III (primary), II, IV, V (supporting)
**Bloom's focus:** Apply, Analyze, Evaluate, Create

### Chapter 7: Auditing and Log Management

**Subtitle:** AUDIT database activity so every later chapter has evidence
**Outcome(s):** CLO II, III, IV
**Outline section(s):** II.B.1 (log management), II.B.2 (data security
reviews)

**Sections:**

* 7.1 What to audit and why: an auditing plan, event categories
  (logins, failed logins, DDL, privileged DML, role changes), and
  retention of logs
* 7.2 Server logging: `log_connections`, `log_statement`,
  `log_line_prefix`, log destinations and rotation, and reloading
  configuration
* 7.3 Application-level audit trails: triggers that write who, what,
  and when into an audit table, and protecting the audit table itself
* 7.4 Reading logs: classifying events as routine, suspicious, or
  violations, and running a data security review from the evidence

**MLOs:**

* **7.1 (Create):** Construct an auditing plan that names the database events to capture, where each is logged, and how long the logs are kept (Section 7.1)
* **7.2 (Apply):** Configure server logging and trigger-based audit trails that record who changed what and when (Sections 7.2-7.3)
* **7.3 (Analyze):** Interpret audit logs to classify events as routine, suspicious, or policy violations (Section 7.4)

**Skills Lab 7A:** An Audit Trail for Copperwind Tickets. Write the
plan, configure logging, add a trigger-based trail to the tickets
table, and review one day of shipped server logs.

**Prior-course parallel:** Old module 7.

### Chapter 8: Performance Tuning and Redundancy

**Subtitle:** TUNE for speed and DESIGN for availability, with numbers
**Outcome(s):** CLO III, V
**Outline section(s):** III.A.1-4 (code design, storage, network,
processing), III.B.1-5 (backup, high availability, tradeoffs, security)

**Sections:**

* 8.1 Measure before tuning: `EXPLAIN ANALYZE`, `pg_stat_statements`,
  and a baseline you can compare against
* 8.2 Tuning methods: indexes, query design, storage maintenance
  (`VACUUM`, `ANALYZE`), memory settings, and network round trips
* 8.3 Redundancy: logical backups (`pg_dump`), physical backups and
  WAL, streaming replication, and high availability on premise and in
  the cloud
* 8.4 Tradeoffs: cost and benefit of redundancy versus tuning, and the
  security exposure of replicas and backup files

**MLOs:**

* **8.1 (Apply):** Apply indexing and query tuning techniques and measure their effect on query response time with execution plans (Sections 8.1-8.2)
* **8.2 (Create):** Design a redundancy plan with backups and replication that meets a stated availability target on premise or in the cloud (Section 8.3)
* **8.3 (Evaluate):** Judge the cost, benefit, and security exposure of a redundancy design against a performance optimization for the same budget (Section 8.4)

**Skills Lab 8A:** Tune and Protect Copperwind Tickets. Baseline three
slow reports, fix them with indexes and query changes, measure the
gain, and design the backup and replication plan for a stated
availability target.

**Prior-course parallel:** Old module 9.

### Chapter 9: Disaster Recovery and Vulnerability Management

**Subtitle:** RECOVER from disaster and CLOSE the holes attackers use
**Outcome(s):** CLO II, III, IV
**Outline section(s):** III.C.1-3 (retention requirements, data
identification, recovery strategies), III.D.1-5 (patches, protocols,
scanning, SQL injection)

**Sections:**

* 9.1 Disaster recovery planning: recovery time objective, recovery
  point objective, data tiers, and retention requirements (years,
  media, offsite copies)
* 9.2 Recovery strategies and drills: restoring a logical backup,
  point-in-time recovery from WAL, and testing the plan against its
  targets
* 9.3 Vulnerability management: versions and patches, secure protocols,
  configuration scanning against a benchmark, and tracking findings
* 9.4 SQL injection: how it works, why parameterized queries stop it,
  and how least privilege limits the damage when they do not

**MLOs:**

* **9.1 (Create):** Formulate a disaster recovery plan with recovery time and recovery point objectives, data tiers, and a retention schedule for a regulated database (Section 9.1)
* **9.2 (Evaluate):** Validate a recovery plan by restoring a backup to a point in time and checking the result against the plan's targets (Section 9.2)
* **9.3 (Analyze):** Rank database vulnerabilities, including SQL injection and unpatched software, by likelihood and impact, and match each to a control (Sections 9.3-9.4)

**Skills Lab 9A:** Recover the Sandwash Clinic. Write the DR plan, run
a restore drill against a shipped backup, record the measured RTO and
RPO, and rank five vulnerabilities from a shipped scan report.

**Prior-course parallel:** Old module 10.

**Part III milestone:** students can produce evidence of what a
database is doing, make it measurably faster, and prove it can be
recovered within stated targets.

---

## Part IV: Response and Professional Practice (Chapters 10-12)

**Theme:** respond when controls fail, keep the routine that prevents
the next failure, and judge what comes next
**Learning arc:** Respond to an incident -> Run the routine -> Plan the whole system and look ahead
**Outcome alignment:** CLO IV, V (primary), I, II, III (supporting)
**Bloom's focus:** Analyze, Evaluate, Create

### Chapter 10: Incident Response

**Subtitle:** RESPOND to a database incident with evidence and obligations in hand
**Outcome(s):** CLO II, IV, V
**Outline section(s):** IV.A (scope analysis, damage control), IV.B
(usage log analysis), IV.C (regulatory compliance), IV.D (disaster
recovery in response)

**Sections:**

* 10.1 The incident response lifecycle: preparation, detection,
  containment, eradication, recovery, lessons learned, and who does
  what
* 10.2 Scope analysis and damage control: reading server logs and audit
  trails to establish origin, extent, and timeline, and containing
  access without destroying evidence
* 10.3 Regulatory obligations: HIPAA breach notification, FERPA
  requirements, state breach laws, and the GDPR and CCPA contrast
* 10.4 Recovery and after-action: applying the recovery plan inside an
  incident and writing the report that changes the next plan

**MLOs:**

* **10.1 (Create):** Construct a step-by-step incident response plan for three common database security scenarios (Section 10.1)
* **10.2 (Analyze):** Investigate database and server logs to trace the origin, scope, and timeline of a simulated breach (Section 10.2)
* **10.3 (Evaluate):** Determine the notification and recovery obligations an incident triggers under HIPAA, FERPA, and state breach laws (Sections 10.3-10.4)

**Skills Lab 10A:** The Harquahala Breach. Investigate shipped logs and
audit rows to reconstruct a breach, contain it, decide the notification
obligations, and write the after-action report.

**Prior-course parallel:** Old module 11.

### Chapter 11: Routine Analysis and Best Practices

**Subtitle:** REVIEW performance and security on a schedule, against a benchmark
**Outcome(s):** CLO II, III, V
**Outline section(s):** III.F.1-4 (logs, historical records, reports,
audits and their scheduling), III.E (cloud security services), V.A
(current practices)

**Sections:**

* 11.1 The routine: scheduled health checks, reports from catalog views
  and logs, and historical baselines that make change visible
* 11.2 Audits on a calendar: access audits, performance audits,
  compliance audits, and the schedule that keeps them from being
  skipped
* 11.3 Frameworks and benchmarks: CIS Benchmarks, NIST SP 800-53
  control families, OWASP guidance, and cloud provider security
  services
* 11.4 Measuring improvement: choosing metrics, capturing before and
  after, and reporting the change

**MLOs:**

* **11.1 (Create):** Build a routine performance and security review that runs on a schedule and reports from logs, catalog views, and historical baselines (Sections 11.1-11.2)
* **11.2 (Evaluate):** Critique a database configuration against an industry benchmark and select the controls worth adopting (Section 11.3)
* **11.3 (Evaluate):** Measure the effect of an adopted best practice with at least three quantifiable metrics (Section 11.4)

**Skills Lab 11A:** The Copperwind Monthly Review. Build the scheduled
review, benchmark the Copperwind server against a shipped checklist,
adopt three controls, and report the before-and-after metrics.

**Prior-course parallel:** Old module 12, plus outline section III.F
(a gap in the old build).

### Chapter 12: Current Practice, Future Trends, and Capstone

**Subtitle:** JUDGE what comes next and PLAN a whole database environment
**Outcome(s):** CLO I, II, III, IV, V
**Outline section(s):** V.A (current practices), V.B (future trends)

**Sections:**

* 12.1 Current practice: managed cloud databases, database DevOps and
  infrastructure as code, zero trust, and data governance programs
* 12.2 Emerging trends: AI and machine learning in administration,
  vector search, distributed SQL, confidential computing, and
  privacy-enhancing technologies
* 12.3 Evaluating adoption: a cost-benefit method for an emerging
  technology, with evidence standards
* 12.4 The management and security plan: bringing the eleven chapters
  into one document for one organization, and mapping the plan's
  skills to database roles

**MLOs:**

* **12.1 (Evaluate):** Appraise emerging database technologies and predict their effect on administration and security practice using current evidence (Sections 12.1-12.2)
* **12.2 (Evaluate):** Weigh the cost and benefit of adopting an emerging database technology for a specific organization (Section 12.3)
* **12.3 (Create):** Produce a complete database management and security plan that addresses architecture, access, compliance, performance, recovery, and response for one organization (Section 12.4)

**Skills Lab 12A:** Capstone: The Management and Security Plan. Choose
Copperwind, Sandwash, or Harquahala and deliver the full plan with
evidence from the server. The spine pays off here.

**Prior-course parallel:** Old modules 13 and 14, merged.

**Part IV milestone:** students can run an incident, run the routine,
and write the plan that a manager would sign.

---

## Outcome Coverage Matrix

| Outcome | Primary chapters | Supporting chapters | Coverage assessment |
| ------- | ---------------- | ------------------- | ------------------- |
| I. Analyze architecture and design | Ch 1, 2, 3 | Ch 4, 12 | Strong: a full Part |
| II. Assess security management | Ch 4, 5, 6, 7 | Ch 1, 9, 10, 11, 12 | Strong: a full Part plus auditing |
| III. Develop performance, security, availability strategies | Ch 8, 9 | Ch 2, 3, 5, 6, 7, 11, 12 | Strong: two dedicated chapters and the routine |
| IV. Evaluate incident response | Ch 10 | Ch 7, 9, 12 | Adequate: one dedicated chapter fed by auditing and recovery. Watch that Ch 10 stays evidence-driven, not narrative |
| V. Critique practices and trends | Ch 12 | Ch 1, 3, 8, 10, 11 | Adequate: dedicated capstone chapter plus a tradeoff section in five others |

## District Outline Coverage Map

See the Outline-to-Chapter Coverage table in docs/CIS376_CLOs.md.
Every outline line lands in a chapter.

---

## Cross-Chapter Dependencies

**Strict prerequisites:**

* Every chapter requires Chapter 1 (the lab environment and the three
  course databases). Each chapter's data pack folder still ships its
  own setup scripts, so a student can rebuild any database from that
  chapter alone.
* Chapter 5 assumes the classification vocabulary of Chapter 4 when
  it names roles. A one-sentence callback covers it.
* Chapter 10 reads the kind of logs Chapter 7 configures and applies
  the kind of plan Chapter 9 writes. Both are callbacks. The shipped
  logs and backup for Chapter 10 live in the Chapter 10 folder.

**Knowledge assumed across all chapters (from the prerequisite SQL
course):**

* SELECT with WHERE, JOIN, GROUP BY, and ORDER BY
* CREATE TABLE with primary and foreign keys
* INSERT, UPDATE, DELETE
* The idea of a client connecting to a server

**Never a dependency:** saved work from an earlier chapter. Callbacks
("you first met the clinic roles in Chapter 5") are welcome.
Dependencies ("continue from your Chapter 5 script") are banned.

---

## Prerequisite-to-CIS376 Bridge Map

The prerequisite is one of three SQL courses on three engines. The
bridge is therefore vocabulary, not chapters:

| Prerequisite engine | CIS376 bridge point |
| ------------------- | ------------------- |
| Oracle SQL | Chapter 1 notes that PostgreSQL schemas resemble Oracle schemas and that `psql` plays the role of SQL*Plus |
| MySQL | Chapter 1 notes that a PostgreSQL role covers both MySQL users and MySQL roles, and that `psql` replaces the `mysql` client |
| SQL Server | Chapter 1 notes that a PostgreSQL database plus schemas maps to a SQL Server database, and that `psql` replaces `sqlcmd` |

Every chapter uses standard SQL where it can and marks PostgreSQL-only
syntax the first time it appears.
