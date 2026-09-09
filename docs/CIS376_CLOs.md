# CIS376 Course Learning Outcomes (Authoritative Reference)

**Course:** CIS376: Database Management and Security (MCCCD)
**Credits:** 4.0 (district course bank, first term 2023 Fall, Governing
Board approval 2022-08-23)
**Sources:** The district course outline and CLO list Mr. Vega kept in
`co-professor/01-teaching/08-cis376-database-management/cis376-course-outline.md`,
plus the QM course map for the previous Canvas build (2025-03-01),
which carried the elevated CLO wording and the per-module MLOs this
book refines.
**Last revised:** 2026-09-09

This document is the single authoritative reference for what the
textbook must teach. Every chapter maps back to these outcomes and to
the district course outline.

---

## Official Course Description

Overview of the functional areas, concepts and techniques of database
management and security. Topics include business and regulatory
requirements, database architecture and design, access control,
retrieval concepts, data auditing, incident response and optimal
database system performance, security and availability. Explores new
directions in database management and security.

## Prerequisite assumption

Students arrive from one SQL course (Introduction to Oracle: SQL,
CIS276DA MySQL Database, or CIS276DB SQL Server Database). The book
assumes SELECT, JOIN, GROUP BY, CREATE TABLE, primary and foreign keys,
and INSERT/UPDATE/DELETE. It never reteaches them. It bridges from them
in one sentence and moves on to management and security decisions.
Confirm the exact district requisite text against the course bank
before the syllabus ships (the ASU transfer record at
`aztransmac2.asu.edu`, id 175632, blocked automated retrieval on
2026-09-09).

---

## District Course Learning Outcomes (verbatim)

The district course bank states the outcomes this way. Roman numerals
match the course outline sections each outcome governs.

1. Understand database architecture and design for business solutions. (I)
2. Evaluate security management for database environments. (II)
3. Evaluate strategies to maintain optimal system performance, security and availability. (III)
4. Assess practices for database environment incident responses. (IV)
5. Evaluate current practices and future trends of database management and security. (V)

## Elevated Course Learning Outcomes (CLOs)

The previous Canvas build and its QM course map elevated the district
wording to measurable Revised Bloom's Taxonomy verbs. The textbook
keeps that wording, because "understand" fails the QM measurability
rule and because the Canvas alignment map already uses these
statements. Every chapter alignment block and the home page quote
these five lines word for word.

* **CLO I (Analyze):** Analyze database architecture and design for business solutions.
* **CLO II (Evaluate):** Assess security management for database environments.
* **CLO III (Create):** Develop strategies to maintain optimal system performance, security and availability.
* **CLO IV (Evaluate):** Evaluate practices for database environment incident responses.
* **CLO V (Evaluate):** Critique current practices and future trends of database management and security.

---

## CLO-to-Chapter Mapping

Adopted 2026-09-09 with the 12-chapter plan in `part-structure.md`.
The full CLO list appears on `book/index.md`, and every chapter
declares its aligned CLOs in a block after its MLO list. Both surfaces
quote the elevated CLO lines above verbatim.

| CLO | Primary chapters | Supporting chapters |
| --- | ---------------- | ------------------- |
| I. Analyze architecture and design | Ch 1, Ch 2, Ch 3 | Ch 4 |
| II. Assess security management | Ch 4, Ch 5, Ch 6, Ch 7 | Ch 1, Ch 9, Ch 10, Ch 11 |
| III. Develop performance, security, and availability strategies | Ch 8, Ch 9 | Ch 2, Ch 3, Ch 5, Ch 6, Ch 7, Ch 11, Ch 12 |
| IV. Evaluate incident response practices | Ch 10 | Ch 7, Ch 9 |
| V. Critique current practices and future trends | Ch 12 | Ch 1, Ch 3, Ch 8, Ch 10, Ch 11 |

Reading the mapping by chapter:

| Chapter | Aligned CLOs |
| ------- | ------------ |
| 1 | I, II, V |
| 2 | I, III |
| 3 | I, III, V |
| 4 | I, II, III |
| 5 | II, III |
| 6 | II, III |
| 7 | II, III, IV |
| 8 | III, V |
| 9 | II, III, IV |
| 10 | II, IV, V |
| 11 | II, III, V |
| 12 | I, II, III, IV, V |

Chapter 12 is the capstone. It is the one chapter that carries all
five CLOs, because its Skills Lab asks students to produce a complete
database management and security plan.

---

## District Course Outline (verbatim)

I. Foundation of database architecture and design
   A. Infrastructure architecture
      1. Service model (on-premise vs. cloud)
      2. Network security tiers/zones (deploy database at a secure/dedicated tier - network placement and mapping)
      3. Identity and access management
      4. Tools and software
   B. Database specification requirements
      1. Hardware
      2. Size
      3. Throughput
      4. Usage
   C. Data model
      1. Database integrity support
      2. Data usage analysis
         a. Transactional vs. reporting/analysis
         b. Relational vs noSQL/Big Data
         c. Other
   D. Business and regulatory requirements
      1. Health Insurance Portability and Accountability Act (HIPAA)
      2. Family Educational Rights and Privacy Act (FERPA)
      3. Data compliance
         a. Separation
         b. Retention
         c. Other
   E. Other

II. Database security management
   A. Access control
      1. Service account authentication and authorization
      2. User management (passwords, profiles, privileges, roles)
      3. Role based access
      4. Security/compliance access review
   B. Data auditing
      1. Log management
      2. Data security reviews
   C. Retrieval concepts
      1. Encryption for data at rest versus data in motion
      2. Other

III. Optimal system performance, security and availability
   A. Performance tuning methods and considerations
      1. Code design
      2. Storage mechanism
      3. Network issues
      4. Processing
   B. Redundancy in design and storage
      1. Backup
      2. High availability options
         a. On premise
         b. Cloud
      3. Advantages
      4. Disadvantages
      5. Security considerations
   C. Disaster recovery
      1. Business and regulatory requirements
         a. Data retention policies
            (1) Number of years
            (2) Type/format of media
            (3) Offsite/remote storage
            (4) Other
         b. Other
      2. Identification of data
      3. Recovery strategies
   D. Vulnerability management
      1. Security patches
      2. Security protocols
      3. Vulnerability scanning
      4. Structured Query Language (SQL) injection
      5. Other
   E. Database security alternate solutions
      1. Cloud security services
      2. Other
   F. Routine system performance and security analysis
      1. Logs
      2. Historical records
      3. Reports
      4. Audits
         a. Access
         b. Performance
         c. Regulatory compliance
         d. Scheduling

IV. Incident response
   A. Scope analysis/damage control
   B. Usage log analysis
   C. Regulatory compliance
   D. Disaster recovery

V. Database management and security
   A. Current practices
   B. Future trends

---

## Outline-to-Chapter Coverage

| Outline section | Chapter(s) |
| --------------- | ---------- |
| I.A.1 Service model | Ch 2 |
| I.A.2 Network security tiers | Ch 2 |
| I.A.3 Identity and access management | Ch 2 (introduced), Ch 5 (applied) |
| I.A.4 Tools and software | Ch 1 (PostgreSQL, psql, pgAdmin), Ch 2 |
| I.B Specification requirements (hardware, size, throughput, usage) | Ch 2 |
| I.C.1 Integrity support | Ch 3 |
| I.C.2 Data usage analysis (OLTP vs reporting, relational vs NoSQL) | Ch 3 |
| I.D.1 HIPAA | Ch 4 |
| I.D.2 FERPA | Ch 4 |
| I.D.3 Separation, retention | Ch 4 (policy), Ch 9 (retention in recovery planning) |
| II.A Access control (service accounts, users, roles, access review) | Ch 5 |
| II.B Data auditing (log management, security reviews) | Ch 7 |
| II.C Encryption at rest versus in motion | Ch 6 |
| III.A Performance tuning (code, storage, network, processing) | Ch 8 |
| III.B Redundancy (backup, HA on premise and cloud, tradeoffs, security) | Ch 8 |
| III.C Disaster recovery (retention, data identification, strategies) | Ch 9 |
| III.D Vulnerability management (patches, protocols, scanning, SQL injection) | Ch 9 |
| III.E Cloud security services | Ch 2 (introduced), Ch 11 |
| III.F Routine performance and security analysis (logs, records, reports, audits) | Ch 11 |
| IV.A Scope analysis and damage control | Ch 10 |
| IV.B Usage log analysis | Ch 10 (builds on Ch 7) |
| IV.C Regulatory compliance in response | Ch 10 |
| IV.D Disaster recovery in response | Ch 10 (builds on Ch 9) |
| V.A Current practices | Ch 11, Ch 12 |
| V.B Future trends | Ch 12 |

Every outline line lands in at least one chapter. Sections that recur
(IAM, retention, cloud security) are introduced once and applied later,
which the part structure records as callbacks, never dependencies.
