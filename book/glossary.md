# CIS376 Glossary

This glossary defines every technical term used in the CIS376 textbook. Each chapter bolds a term at first use, and the Key Terms list at the end of each chapter points you here for review. Every chapter uses these exact definitions.

## A

access audit
:   The audit that compares the privileges a server grants and the accounts it holds against the access list the data owner signed, and reports every difference in both directions.

access control matrix
:   A table that lists each role against each protected object and states the privilege the role holds on it.

access review
:   The scheduled comparison of what a database server allows against what the data owner approved, recorded so the next review can measure drift from it.

ACID
:   The four guarantees a transaction makes: atomicity (all or nothing), consistency (constraints hold when it ends), isolation (concurrent transactions do not see each other's unfinished work), and durability (a committed change survives a crash).

action item
:   A line in an after-action report that names what will change, who owns it, when it is due, and the evidence that will prove it happened. A change with no owner and no date is a wish, not an action item.

administrative safeguards
:   The HIPAA Security Rule's policy and people requirements (45 CFR 164.308): risk analysis, workforce access rules, training, incident procedures, and contingency planning.

after-action report
:   The written product of the lessons-learned phase, covering the summary, timeline, scope, root cause, what worked and what did not, and the action items. It is the part of incident response that changes the next incident.

ANALYZE
:   The command that refreshes the statistics the planner uses to choose an execution plan. Autovacuum runs it in the background, and you run it by hand after a bulk load so the next plan reflects the new data.

append-only
:   A table that every role except its owner may add rows to and never change or remove rows from. An audit trail is append-only so that the role that changed the data cannot change the record of the change.

application tier
:   The network tier that runs business logic (the scheduling application, a reporting service, a scheduled job). It accepts connections from the presentation tier and is the only tier that should connect to the database.

asymmetric encryption
:   Encryption with a key pair. What the public key encrypts only the private key can decrypt. It is slow, so it carries key exchange and identity (the TLS handshake and the server certificate), never the data itself.

audit
:   A comparison of what a review measured against a stated standard, reporting every difference. A review produces numbers, and an audit judges those numbers against the list, the plan, or the regulation they are supposed to match.

audit controls
:   The HIPAA technical safeguard (45 CFR 164.312(b)) that requires mechanisms to record and examine activity in systems that hold electronic protected health information. Server logging and trigger-based audit trails are how a database team implements it.

audit event
:   One action on the database that the auditing plan says to record, such as a login, a failed login, a DDL statement, a change to a protected row, or a role change.

audit trail
:   A table inside the database that a trigger fills with the before-and-after of each protected change, the role that made it, and the time. It records which rows changed, which the server log cannot.

auditing plan
:   The written decision about which database events matter, where each one is recorded, who reviews the record, and how long it is kept. The data owner rules on what matters and the administrator decides how to capture it.

authentication
:   The step that proves a claimed identity, by a password checked with SCRAM, a client certificate, or a ticket from a central directory. In PostgreSQL, `pg_hba.conf` chooses the method for each connection.

authorization
:   The step that decides what an authenticated identity may do: privileges, role memberships, and row-level security policies. It happens inside the database after authentication and is never delegated to an outside directory.

availability
:   The property that authorized users can reach data and systems when they need them. An outage is an availability failure even when nothing leaks.

## B

backup
:   A copy of a database, stored so it can be restored after data is lost or corrupted. A backup is restored after an outage, unlike a standby, which takes over during one.

backup plan
:   The written record that names, for each database, its recovery point and recovery time objectives, its backup method, its replication, and the owner who signs those numbers.

base backup
:   A physical, byte-for-byte copy of a database cluster's files, taken as the starting point for point-in-time recovery. WAL is replayed on top of it to reach a chosen moment.

baseline
:   A measurement taken while a system is healthy (size, version, roles, response time) so later readings can show what changed.

bcrypt
:   A password hashing algorithm, selected in `pgcrypto` with `gen_salt('bf')`, that salts every hash and runs deliberately slowly. Its cost factor raises the work per hash as hardware gets faster.

before-and-after report
:   A report that pairs a metric's value from before a control was adopted with its value afterward, states the change, and names the direction that counts as an improvement for each metric.

Big Data
:   Datasets too large, too fast, or too varied for one server and one schema, spread across many machines. The traditional test is volume, velocity, and variety. Every copy across those machines is a place confidentiality can fail.

breach
:   An incident in which protected data was acquired, accessed, used, or disclosed without authorization. Only this rung of the ladder starts legal notification clocks. HIPAA presumes a breach from an impermissible use or disclosure unless a risk assessment shows a low probability of compromise (45 CFR 164.402).

business associate
:   An outside organization that creates, receives, maintains, or transmits protected health information on a covered entity's behalf (45 CFR 160.103). A hosting provider such as Copperwind is one, and the Security Rule applies to it directly.

business associate agreement (BAA)
:   The written contract HIPAA requires before a covered entity may let a vendor, including a cloud provider, create, receive, store, or transmit protected health information. The vendor accepts its share of the safeguards in the agreement.

## C

California Consumer Privacy Act (CCPA)
:   A California privacy statute that creates a private right of action for a consumer whose nonencrypted and nonredacted personal information is exposed by a failure to maintain reasonable security (California Civil Code 1798.150). It sets no notification deadline of its own.

capacity planning
:   The discipline of turning measured size, growth, throughput, and usage into a hardware purchase or a cloud tier, with a date by which the estimate must be re-measured.

capture
:   One run of a review's metric set, stored in the review archive with the date it was taken, so it can be compared against any other run.

certificate
:   A server's public key wrapped with its name and a signature from a party the client trusts. Under TLS the client checks it to confirm it reached the intended server.

CHECK constraint
:   A constraint that holds any true-or-false condition on a row, such as a status drawn from a fixed list or a date in the past. The database refuses any insert or update that makes the condition false.

CIA triad
:   The three properties every protected system must preserve: confidentiality, integrity, and availability. Every database threat attacks at least one of them.

ciphertext
:   Data after encryption. Unreadable without the key, and what an unauthorized reader of a disk, backup, or network gets.

cluster
:   One running PostgreSQL server, which holds many databases. Roles and server settings belong to the cluster, not to any one database.

column-level encryption
:   Encrypting one column's values inside the table with `pgcrypto`, so a reader with `SELECT` on the column gets ciphertext and only a holder of the key gets the value. It protects the column in every backup and export.

compliance audit
:   The audit that collects the evidence a regulation or an internal policy requires, each item recorded with the query output or file that produced it and the date it was produced.

confidential computing
:   A hardware-based protection that keeps data encrypted while a program computes on it, by running the work inside a processor-protected region of memory that the operating system and the hypervisor cannot read.

confidentiality
:   The property that only authorized people and programs can read data, through queries, exports, backups, logs, or network traffic.

configuration benchmark
:   A published checklist of hardening rules for a system, such as the Center for Internet Security's PostgreSQL Benchmark. A scan reports which rules a server passes and which it fails.

configuration parameter
:   A named server setting, such as `log_statement`, read from `postgresql.conf` and shown with its current value and change rules in the `pg_settings` view.

configuration reload
:   Telling a running PostgreSQL server to reread `postgresql.conf` and `pg_hba.conf` without stopping, requested with `pg_reload_conf()`. Settings whose context is `postmaster` still need a restart, and `pg_settings.pending_restart` says which.

connection limit
:   The maximum number of simultaneous sessions a role may hold, set with `CONNECTION LIMIT`. A cap on a service account protects availability when an application leaks connections.

containment
:   The response phase that stops harm from continuing without erasing the record of how it happened. In PostgreSQL the pairing that does both is `ALTER ROLE ... NOLOGIN` plus `pg_terminate_backend()`.

control
:   A safeguard that reduces the likelihood or the impact of a threat. Controls come in families such as access control, encryption, auditing, and backup.

control family
:   A group of related security controls in a framework, named by a short code such as AC for access control or AU for audit and accountability, so an organization can plan and report across products.

control framework
:   A published catalog that organizes security controls into families for planning and reporting across a whole information system, such as NIST Special Publication 800-53. A framework spans products, while a benchmark hardens one.

cost factor
:   The bcrypt parameter that sets how much work one hash takes. Each step up roughly quadruples the time, which a login pays once and an attacker pays for every guess.

cost-benefit analysis
:   The comparison that weighs what an option costs over its life against what it returns, measured against the alternatives, including doing nothing.

covered entity
:   A health plan, a health care clearinghouse, or a health care provider that transmits health information electronically (45 CFR 160.103). HIPAA's rules apply to it.

## D

data at rest
:   Data in storage: the data directory, write-ahead log files, backups, exports, and logs. Each is a file that can be copied without asking any role for permission.

data classification
:   Assigning each data element a sensitivity level (Public, Internal, Confidential, Restricted) that decides how it is stored, who may see it, and how it is disposed of.

data criticality tier
:   A grouping of data by how much its loss or downtime harms the business, where each tier carries its own recovery time objective, recovery point objective, and backup frequency.

data governance
:   The program that keeps four answers current for an organization's data: what it holds, how sensitive each piece is, who decides access, and how long it is kept.

data in motion
:   Data crossing a network between client and server. Without TLS, every statement and every returned row is readable by a listener.

data owner
:   The business leader accountable for a dataset, who decides who has a legitimate need to see it. The DBA implements that decision and proves it took effect.

data security review
:   The written record of a log reading: the scope, the method, the findings with counts and times, the actions taken, and the residual risk, signed so the next review can compare against it.

data steward
:   The person inside a business unit who maintains the meaning of the data, including what a column means, which values are valid, and which records are authoritative.

data tier
:   The most restricted network tier, which holds the database server. It accepts connections only from the application tier and a small set of administrative addresses, never from the internet.

database administrator (DBA)
:   The person who installs, configures, monitors, backs up, tunes, and recovers a DBMS and who implements access decisions made by data owners.

database DevOps
:   The practice of shipping database changes the way an application ships code, in small versioned files that are reviewed before they run and applied by a tool rather than by hand.

database management system (DBMS)
:   The software that stores data, enforces rules about it, controls who may reach it, logs activity, and recovers it after failure. PostgreSQL, Oracle Database, MySQL, and SQL Server are all DBMS products.

de-identification
:   The HIPAA standard (45 CFR 164.514(b)) under which health information stops being PHI once the eighteen listed identifiers are removed and there is no reasonable basis to identify anyone.

default privileges
:   A standing rule, set with `ALTER DEFAULT PRIVILEGES`, that tells PostgreSQL what to grant on objects a role creates in the future. A plain `GRANT ... ON ALL TABLES` covers only the tables that exist at that moment.

differential privacy
:   A privacy method that adds measured noise to a published result, so that any one person's presence in or absence from the data cannot change the answer enough to be detected.

directory information
:   Information in an education record that would not generally be considered harmful or an invasion of privacy if disclosed (34 CFR 99.3). A school may release it only after public notice and only for students whose parents have not opted out (34 CFR 99.37).

disaster recovery plan
:   The written plan that states how a database is brought back after it goes out of service, including its recovery time objective, recovery point objective, data criticality tiers, and retention requirements.

disposal log
:   A record of each destruction run: the record series, the cutoff, the number of rows destroyed, the authority, who ran it, and when. Part of the documentation HIPAA keeps for six years.

distributed SQL
:   A database that spreads one logical database across many servers, and often across regions, while still offering SQL and transactions that span the whole set.

document store
:   A NoSQL database that keeps each record as a self-contained JSON document with fields that can differ from record to record. It trades constraints, joins, and fine-grained access control for flexibility.

drift
:   The difference between the access the data owner approved and the access the server allows, such as a forgotten account, a grant made "for now," or a policy lost when a table was rebuilt.

## E

education record
:   Any record directly related to a student that a school, or a party acting for it, maintains (34 CFR 99.3). FERPA governs its disclosure.

effective privileges
:   What a role can do once every membership it inherits is counted, as reported by `has_table_privilege()` and the other `has_*_privilege()` functions, not by the direct grants alone.

eligible student
:   A student who has reached 18 or is attending a postsecondary institution. FERPA rights transfer from the parents to the eligible student (34 CFR 99.5).

embedding
:   A list of numbers a model produces from a piece of text, built so that texts with similar meaning produce lists that sit near each other.

encryption
:   Transforming readable data into a form that cannot be read without a key. It decides what an unauthorized reader gets once access control has been bypassed.

encryption key
:   The secret that turns plaintext into ciphertext and back. Algorithms are public, so the key is the only secret and protecting it is most of the work.

encryption safe harbor
:   The provision under which protected data rendered unusable, unreadable, or indecipherable by an approved method is not treated as unsecured, so its exposure requires no notification. State breach statutes take the same shape by defining a breach only for unencrypted data.

eradication
:   The response phase that removes the condition an incident used, not only the symptom it produced. Revoking an over-granted privilege is eradication. Locking the account that used it is containment.

event
:   Anything the server records. An event becomes a security incident when it violates a policy or threatens confidentiality, integrity, or availability, and becomes a breach when protected data was acquired or disclosed.

event classification
:   The reading step of auditing, in which every logged event receives one of three labels, routine, suspicious, or violation, according to the rules in the auditing plan rather than the text of the line.

evidence standard
:   The rule applied to a claim before it is allowed into a decision, which ranks sources from your own measurement down to a claim with no source named.

execution plan
:   PostgreSQL's step-by-step account of how it will run a query: which tables it reads, in what order, and how it joins them. `EXPLAIN` shows the plan and `EXPLAIN ANALYZE` runs the query and reports what happened.

expression index
:   An index built on the result of a function or expression, such as `lower(last_name)`, so a query that filters on that same expression can use it. A plain index on the bare column cannot answer a transformed value.

## F

failover
:   Promoting a standby server to primary when the primary fails. Done by hand it takes as long as a person needs to notice and act; automated with a monitoring tool it drops to seconds.

firewall
:   A device or software layer that permits or drops network traffic by address, port, and direction. Firewalls between tiers keep a database reachable only from the systems that need it.

forensic timeline
:   An ordered account of an incident in which every row carries an instant, the source of the evidence, and the event, under one stated time zone. Without the stated zone the times cannot be checked by anyone else.

functional dependency
:   A relationship in which one column's value determines another's, such as a patient determining a phone number. Third Normal Form requires every non-key column to depend on the table's key and nothing else.

## G

General Data Protection Regulation (GDPR)
:   The European Union regulation that requires a controller to notify the supervisory authority of a personal data breach without undue delay and, where feasible, within 72 hours of becoming aware of it (Article 33). Data subjects are notified when the risk to them is high (Article 34).

group role
:   A role that exists to hold privileges for its members. It normally cannot log in, and login roles receive privileges by becoming members of it.

growth
:   The rate at which a database's size rises over time, measured from the data (rows added per month) and expressed as a monthly rate for projection.

## H

hash function
:   A function that turns any input into a fixed-length fingerprint that cannot be reversed. Used to check a password without storing it and to detect that a value changed.

high availability
:   A design in which a standby server takes over during an outage, rather than being restored after one, so the recovery time objective can be measured in seconds.

host-based authentication
:   PostgreSQL's rule table, kept in `pg_hba.conf`, for deciding connection by connection whether to accept a client and how to verify its identity. Rules match top to bottom and the first match wins. A connection that matches no rule is refused.

## I

identity
:   A name a system recognizes: a login role, a person's account, or a certificate's subject. Identity is the claim that authentication proves and authorization acts on.

identity and access management (IAM)
:   The policies and systems that establish who someone is, prove it, and control what they may do. A database participates in IAM for identity and authentication but keeps authorization to itself.

impact
:   In a vulnerability ranking, how much harm a finding would do if it were used, scored so it can be combined with likelihood into one risk score.

incident commander
:   The role that owns the sequence, the clock, and the record of decisions during an incident. It does not own the technical fix or the notification decision.

incident response plan
:   The written sequence a team follows during an incident, covering preparation, detection and analysis, containment, eradication, recovery, and lessons learned, with the people and the exit test for each phase named in advance.

index
:   A sorted structure the server keeps beside a table so it can find rows by a column's value without reading every row. It speeds reads and slightly slows writes, because each change must update it.

index scan
:   A plan step that reads an index to locate matching rows and then fetches only those rows, instead of reading the whole table. Its appearance in a plan is the usual sign that an index is doing its job.

infrastructure as a service (IaaS)
:   A service model in which a cloud provider rents virtual machines, storage, and networking. The customer installs, patches, and manages the operating system and the DBMS on the rented machine.

infrastructure as code
:   The practice of keeping server configuration in files under version control, so the configuration is reviewed, repeatable, and readable instead of remembered.

inheritance
:   The rule that a member role automatically uses the privileges of the groups it belongs to, and of their groups, unless the member was created with `NOINHERIT`.

integrity
:   The property that data is correct and complete and that every change to it is authorized and recorded.

integrity constraint
:   A rule the database checks on every insert and update and refuses to break. The five types are PRIMARY KEY, FOREIGN KEY, UNIQUE, NOT NULL, and CHECK. Constraints run on every path into a table, not only through the application.

## J

JSONB
:   PostgreSQL's binary JSON column type. A document is parsed once at insert time and stored in a searchable form, so semi-structured data can live inside a row whose other columns stay under constraints.

## K

key management
:   The decisions about where each key lives, who can reach it, and how it is replaced. A key stored beside the data it protects is a label, not a lock.

key rotation
:   The scheduled replacement of an encryption key: decrypt with the old key, encrypt with the new, verify the round trip, retire the old key. Planned before the first row is encrypted.

keyed hash
:   A hash that mixes in a secret key (`hmac()` in `pgcrypto`), so only a key holder can compute the fingerprint. It repeats for the same input, which makes it indexable, and cannot be reversed.

## L

least privilege
:   The rule that every account receives the minimum access its work requires and nothing more.

legal hold
:   A suspension of the retention schedule for specific records because of litigation, an investigation, a records request, or a complaint. A hold outranks the schedule and must be visible to the disposal run.

legitimate educational interest
:   The FERPA basis on which a school official may see an education record without consent (34 CFR 99.31(a)(1)). The school defines it and must use reasonable methods to limit officials to the records it covers.

likelihood
:   In a vulnerability ranking, how easily a finding could be used, scored so it can be combined with impact into one risk score.

log line prefix
:   The `log_line_prefix` format that stamps the front of every server log line. Escapes such as `%m` (time), `%p` (process), `%u` (role), `%d` (database), and `%h` (client address) decide whether a line can name who did what and from where.

log rotation
:   The server's switch to a new log file after `log_rotation_age` minutes or `log_rotation_size` kilobytes. Rotation never deletes old files, so retention is a scheduled job unless a cyclic filename with `log_truncate_on_rotation` is used.

logging collector
:   The background process, enabled with `logging_collector = on`, that captures the server's output and writes it to files in `log_directory`. Its context is `postmaster`, so turning it on needs a restart.

logical backup
:   A backup produced by `pg_dump` as a file of SQL statements that rebuild the data by replaying them. It restores into an empty database on any compatible server.

login role
:   A role with the `LOGIN` attribute, which allows a connection to start. A person and a service account are both login roles with different settings.

lookup hash
:   A keyed hash stored beside an encrypted column so a query can find a row by value without decrypting the table. The encrypt-then-query pattern's second column.

lost update
:   A concurrency failure in which two transactions each read the same state, each act on it, and each commit, so one change silently overwrites or duplicates the other. A double booking is a lost update. A constraint checked at commit time prevents it.

## M

managed audit log service
:   A cloud service that collects database logs into storage the database's own administrators cannot quietly edit, and applies its own retention rules to them.

managed database service
:   A cloud offering in which the provider installs, patches, backs up, and replicates the DBMS while the customer keeps every decision about data, access, and retention.

managed key service
:   A cloud service that holds encryption keys in hardware, rotates them on a schedule, and records every use, so key custody sits outside the database that the keys protect.

managed secret service
:   A cloud service that stores application credentials outside the application, releases them to authorized callers on request, and rotates them on a schedule without taking the application down.

management and security plan
:   A single document that states how one organization's database is designed, protected, kept fast, recovered, and defended, with evidence recorded under each claim.

management lifecycle
:   The five-stage loop this book follows: Plan, Secure, Monitor, Recover, Review. Each stage maps to one course outcome.

materialized view
:   A view whose query result is stored as real rows on disk. Reads are fast, and the rows are only as current as the last REFRESH MATERIALIZED VIEW, so the refresh schedule is a decision to write down.

meta-command
:   A psql instruction that begins with a backslash, such as `\l` or `\dt`. Meta-commands are handled by the client and are not SQL.

metric set
:   The fixed list of measurements a routine review takes, defined once (in PostgreSQL, as a view) so that every run measures the same things the same way no matter who runs it.

minimum necessary standard
:   The HIPAA requirement to limit protected health information to the minimum needed for a use, disclosure, or request (45 CFR 164.502(b)), implemented by naming classes of workers and the PHI each class needs (45 CFR 164.514(d)).

## N

normalization
:   Organizing tables so that each fact is stored once, in the table whose key determines it. The management payoff is one constraint, one GRANT, one column to encrypt, and one row to delete per fact.

NoSQL
:   A family of databases that drop the fixed-table relational model: document stores, key-value stores, wide-column stores, and graph databases. Each trades away some integrity or access-control features for flexibility or scale.

## O

on-premise
:   A service model in which the organization owns the hardware, the operating system, and the DBMS and runs them in a room it controls.

OWASP
:   The Open Worldwide Application Security Project, a nonprofit that publishes free application and database security guidance, including the cheat sheet series this book cites.

## P

parameterized query
:   A query that sends its SQL text and its values to the server separately, so a value can only ever be treated as data and never as SQL. It is the primary defense against SQL injection.

performance audit
:   The audit that compares the current cost of the work against the last capture, using execution plans, the index inventory, table sizes, and index-usage counters.

personal information
:   The category of data a state breach statute protects, defined by a closed list and not by intuition. Arizona defines it as a name plus at least one specified data element, or an email address or username with the password that opens the account (A.R.S. 18-551(7)).

pg_dump
:   The utility that writes one database to a file as the SQL needed to rebuild it or as a compressed archive. It captures the database as of the moment the dump started, so later writes are not included.

pg_stat_statements
:   An extension that records every statement the server runs, with call count and total and mean time, so an administrator can sort by cost and find the slowest query. It must be loaded at server start through `shared_preload_libraries`.

pgAdmin
:   The graphical client for PostgreSQL, used to browse objects, read execution plans, and inspect privileges.

pgcrypto
:   The PostgreSQL extension that provides hashing (`digest()`), keyed hashing (`hmac()`), salted password hashing (`crypt()` with `gen_salt()`), and symmetric encryption (`pgp_sym_encrypt()` and `pgp_sym_decrypt()`) as SQL functions.

physical backup
:   A byte-for-byte copy of a database's data files, as opposed to a logical backup of SQL statements. It is the basis for point-in-time recovery.

physical safeguards
:   The HIPAA Security Rule's requirements for facilities, workstations, and media (45 CFR 164.310), including the disposal of media that held PHI.

pilot
:   A limited trial of a technology with a stated scope, a stated duration, and a decision rule written before the trial starts.

plaintext
:   Data anyone can read. The state of a column before encryption and the state every authorized reader needs it in.

point-in-time recovery
:   Restoring a base backup and then replaying archived write-ahead log up to a chosen moment, which shrinks the recovery point objective from a full backup interval to seconds.

point-in-time recovery (PITR)
:   Recovery that starts from a base backup and replays archived write-ahead log forward to a chosen instant, so a database can be restored to the moment just before a failure.

policy
:   A named row-level security rule attached to a table. Its `USING` expression must be true for a row to be visible to the roles the policy names.

PostgreSQL
:   The free, open-source DBMS this book uses as its lab server. Version 17 is the course target.

presentation tier
:   The network tier that faces users: web servers and portals. It is reachable from the internet, is assumed to be attacked, and must never hold a database.

primary
:   In replication, the server that accepts writes and streams its changes to one or more standby servers.

privacy-enhancing technology
:   Any method that lets an organization use data while reducing what the data reveals about an individual, including de-identification, tokenization, and differential privacy.

privilege
:   A named permission on one object, held by one role, such as `SELECT` on a table, `USAGE` on a schema, or `CONNECT` on a database.

privilege drift
:   The slow accumulation of privileges that nobody approved, caused by grants made under pressure and never revoked. Drift moves in one direction unless an access audit checks for it.

protected health information (PHI)
:   Individually identifiable health information that a covered entity or business associate holds or transmits in any form (45 CFR 160.103). Health information becomes PHI when joined to any of eighteen identifiers such as a name, a date, a phone number, or a member number.

psql
:   PostgreSQL's command-line client. Every script and captured output in this book runs through it.

PUBLIC
:   The pseudo-role that stands for every role on the server. PostgreSQL grants it `CONNECT` on new databases and `USAGE` on the `public` schema by default.

## Q

quantifiable metric
:   A number taken the same way before and after a change, which moves when the control works and stays put when it does not. A usable metric is specific, stable, cheap to collect, and responsive to the control it measures.

## R

recovery point objective (RPO)
:   The maximum amount of recent data, measured in time, that an organization can afford to lose in a failure. The data owner sets it, and the backup method must meet it.

recovery time objective (RTO)
:   The maximum length of time, from failure to restored service, that an organization can tolerate. The data owner sets it, and the recovery method must meet it.

replication
:   Keeping a live second copy of a database on another server by continuously copying changes, so the copy can serve reads or take over on failure.

reporting workload
:   A pattern of few large reads that scan many rows and can take time, such as a monthly rollup by provider. It wants the data joined and summed, in a shape built from the normalized tables.

restore drill
:   A rehearsal that restores a real backup into a throwaway database, verifies the result against the recovery plan, and times the restore, run on a schedule before any disaster.

retention requirements
:   The rules stating how long each class of backup is kept, on what media, and how many copies are held offsite, often with a regulatory floor.

retention schedule
:   A written table that names each record series, the event that starts its clock, how long it is kept, how it is destroyed, and the authority for the rule.

review archive
:   A durable table that stores one row per metric per run of a routine review, so any two runs can be joined and change over time becomes visible instead of remembered.

review calendar
:   The schedule that names how often each review and audit runs, who owns it, what evidence it produces, and where that evidence is filed.

role
:   A PostgreSQL account that can be a user (a role that can log in), a group (a role that holds privileges for others), or both.

role-based access control (RBAC)
:   The practice of granting privileges to job roles and assigning people to jobs, so that hiring and departures change memberships, not grants.

root cause
:   The condition without which an incident could not have happened. A root cause names a decision or a missing control, never a person.

routine
:   The event classification for an event the auditing plan expects, such as a known account connecting during business hours. Chapter 11 uses the word in its ordinary sense instead, for work done on a schedule. See `routine review`.

routine review
:   A fixed set of measurements taken on a fixed schedule, whether or not anything looks wrong. It needs three things to stay a routine: a fixed metric set, a durable archive, and a calendar.

row-level security
:   A table-level control that filters which rows each role can see or change, enforced by policies that the table applies to every query from a role that is not its owner or a superuser.

## S

salt
:   A random value mixed into each hash so two identical passwords produce different fingerprints and an attacker cannot precompute a table of answers. bcrypt stores the salt inside the hash string.

schema
:   A named container for tables, views, and other objects inside one database. A role needs USAGE on a schema before it can reach anything inside it, which makes the schema a security boundary.

schema migration
:   One versioned file that moves a database from one known state to the next, carrying an identifier, a description, and the statements that make the change.

scope analysis
:   The reading step of an investigation, which establishes where an incident came from, how far it reached, and when it started and stopped, using the server log and the audit trail as its evidence.

SCRAM-SHA-256
:   PostgreSQL's default password scheme since version 14. The server stores a salted hash, and the challenge-response exchange never sends the password itself across the network.

secure deletion
:   Removal of data from every place it could still be read (the table, the write-ahead log, backups, replicas, and exports), with a record that proves it.

secure protocol
:   A network protocol that protects data in transit so a listener learns nothing, such as TLS for client-to-database connections.

security administrator
:   The person who sets access policy, reviews privileges, watches logs for misuse, and leads the response when a control fails.

security incident
:   An event, or a set of events, that violates a security policy or threatens confidentiality, integrity, or availability. An outage is a security incident even when no data leaked.

security patch
:   A vendor fix for a known software flaw, shipped for PostgreSQL in minor releases that correct defects without changing query behavior.

security posture service
:   A cloud service that scores a database's configuration against a published benchmark on a schedule and opens a finding for each control that fails.

Security Rule
:   The HIPAA regulation at 45 CFR Part 164, Subpart C, that protects electronic protected health information through administrative, physical, and technical safeguards.

security tier
:   A group of systems that share the same exposure and the same rules about who may connect to them. Also called a zone. The classic layout has presentation, application, and data tiers separated by firewalls.

self-signed certificate
:   A certificate signed with its own private key instead of by a certificate authority. It encrypts the session fully but cannot prove the server's name to a client that has not been given a copy to trust.

semi-structured data
:   Records that share a core of fixed fields and then vary, such as an intake form whose questions change every quarter. The fixed part belongs in constrained columns and the variable part in JSONB.

separation of duties
:   The principle that no single person should be able to request access, grant it, use it, and erase the record of having done so.

sequential scan
:   A plan step that reads every row in a table and discards the ones that do not match the filter. It is efficient for small tables and the cost tuning tries to remove on large ones.

server log
:   The text file PostgreSQL writes as it runs. With the right settings it holds every connection, every failed connection, and whichever statements `log_statement` says to keep.

service account
:   A login role used by an application or a scheduled job instead of a person. Each service gets its own role, its own connection rule, and no human users.

service model
:   The arrangement that decides which parts of a database system an organization operates and which parts a provider operates: on-premise, infrastructure as a service, or a managed database service.

shared responsibility model
:   The cloud rule that the provider secures the cloud and the customer secures what they put in it. Where the line falls depends on the service model. Roles, privileges, data classification, retention, and key ownership stay with the customer under every model.

single sign-on (SSO)
:   An arrangement in which a person proves identity once to a central service and every other system accepts that proof. PostgreSQL can accept it through methods such as `ldap`, `gss`, and `cert`, but the role and its privileges must still exist inside the cluster.

size
:   The number of bytes a database or table occupies today, including indexes and overflow storage, as reported by `pg_database_size()` and `pg_total_relation_size()`.

skills matrix
:   A table that maps the work recorded in a management and security plan to the roles that own that work in a larger organization, citing the plan's own evidence for each row.

specified data element
:   One of the data types a state breach statute lists as making a name into personal information. Arizona's list holds Social Security, driver license, passport, and taxpayer identification numbers, a private key, a financial account number with its access code, a health insurance identification number, medical or mental health treatment information, and biometric data (A.R.S. 18-551(11)).

SQL injection
:   An attack that slips SQL into a value the application treated as plain data, so the attacker's text runs as part of the query. Parameterized queries prevent it.

sslmode
:   The client connection parameter that sets whether TLS is required and whether the server certificate is checked. The default, `prefer`, falls back to plain text silently. `verify-full` is the only mode that stops an impostor.

staging table
:   A temporary landing table with no constraints that holds an import exactly as it arrived, so the data can be inspected with queries before anything trusts it. It is dropped once the load is proven.

standby
:   A server that continuously replays the primary's write-ahead log to stay ready to take over, and can also serve read-only queries.

streaming replication
:   Replication in which the primary sends its write-ahead log to a standby as it is written, keeping the standby seconds behind and ready for failover.

superuser
:   A PostgreSQL role that bypasses every permission check. Used to build the lab and then set aside.

surrogate key
:   A system-generated identifier with no business meaning, used as a primary key so that it never has to change when a name, a phone number, or any other business attribute does.

suspicious
:   The event classification for an event the auditing plan did not expect and cannot yet explain, such as a burst of failed logins before dawn. A person must explain it before it becomes routine.

switching cost
:   What it would take to leave a product later, including how the data comes out, in what format, and how much work the move requires.

symmetric encryption
:   Encryption that uses one key to encrypt and the same key to decrypt. Fast and unlimited in size, so it does the heavy lifting for volumes, columns, and TLS sessions. Its weakness is delivering the key.

## T

technical safeguards
:   The HIPAA Security Rule's controls inside the system (45 CFR 164.312): access control, audit controls, integrity, person or entity authentication, and transmission security.

Third Normal Form (3NF)
:   The design state in which every non-key column depends on the key, the whole key, and nothing but the key. Meeting it removes update anomalies and gives each fact one place to be guarded.

threat
:   Anything that could violate the confidentiality, integrity, or availability of data.

throughput
:   The amount of work a server handles per unit of time, such as rows inserted per hour or queries per second. PostgreSQL keeps cumulative counters in `pg_stat_user_tables` and `pg_stat_database`.

TLS
:   Transport Layer Security, the protocol that encrypts a connection. An asymmetric handshake agrees on a symmetric session key and presents the server's certificate. In PostgreSQL, `ssl = on` enables it and `hostssl` rules require it.

tokenization
:   Replacing a value with a random token and keeping the mapping in a separate, harder-to-reach store. Suits values that are looked up but never computed on.

total cost of ownership
:   The full cost of an option over its life, including the license or hosting fee, the migration work, the training, the extra monitoring, and the staff time to run it.

transaction
:   A group of SQL statements that either all take effect or all fail together, bounded by BEGIN and COMMIT or ROLLBACK.

transactional workload
:   A pattern of many small reads and writes, each touching a few rows and each needing to finish now, such as a front desk booking one appointment. Normalized tables with constraints serve it.

trigger
:   A rule attached to a table that runs a function when rows are inserted, updated, or deleted, either before or after the change and once per row or once per statement.

trigger function
:   A function that returns the type `trigger` and runs when its trigger fires. In PL/pgSQL it sees `OLD`, `NEW`, `TG_OP`, and `TG_TABLE_NAME`, and it must end by returning a row or the server raises an error when the trigger fires.

trusted execution environment
:   A region of memory protected by the system processor, which the operating system and the hypervisor cannot read into. Confidential computing runs a database workload inside one.

## U

unsecured protected health information
:   Protected health information that has not been rendered unusable, unreadable, or indecipherable to unauthorized persons by a technology or methodology the Secretary of Health and Human Services specifies (45 CFR 164.402). Only a breach of unsecured protected health information triggers HIPAA notification.

update anomaly
:   The result of storing one fact in more than one row: the fact is changed in one place and not the others, so the data disagrees with itself. Normalization removes it by storing the fact once.

usage
:   When the load arrives and who generates it. Usage analysis finds the peak hour, day, or season a server must be sized for.

## V

VACUUM
:   The command that reclaims the space held by dead rows left behind by updates and deletes. Plain `VACUUM` frees the space for reuse while the table stays in use; `VACUUM FULL` rewrites the table and returns space to the operating system, but locks the table while it runs.

vector search
:   A search that finds rows whose embeddings sit closest to the embedding of the question, so results are ranked by similarity of meaning rather than by matching words.

view
:   A named query that behaves like a table but stores no rows. It fixes one definition of a report and gives a reporting role a privilege boundary, since the role can be granted the view and not the tables behind it.

violation
:   The event classification for an event that breaks a written rule in the auditing plan, whoever did it and whatever the reason, such as a role change made by an account the plan does not authorize.

volume encryption
:   Encrypting a whole disk or file system below the database, done by the operating system or a cloud provider. It stops whoever holds the drive and does nothing against a reader who can log in to the running server.

vulnerability
:   A weakness in software or configuration that an attacker or an accident could use to break confidentiality, integrity, or availability.

vulnerability management
:   The scheduled routine of finding weaknesses, ranking them by likelihood and impact, matching each to a control, fixing or accepting it, and rescanning to measure progress.

## W

work_mem
:   The setting that caps the memory a single sort or hash may use before it spills to disk. It applies per operation and per connection, so a large value multiplied across many connections can exhaust server memory.

working set
:   The part of a database that daily queries touch. A server whose memory holds the working set answers most queries without reading disk.

write-ahead log (WAL)
:   PostgreSQL's record of every change, written to disk before the change reaches the table. It powers crash recovery and, when archived, point-in-time recovery and streaming replication.

## X

## Y

## Z

zero trust
:   A design principle that removes the idea of a trusted network location, so every request authenticates, receives only what it needs, and is logged as if it might be hostile.
