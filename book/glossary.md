# CIS376 Glossary

This glossary defines every technical term used in the CIS376 textbook. Each chapter bolds a term at first use, and the Key Terms list at the end of each chapter points you here for review. Every chapter uses these exact definitions.

## A

access control matrix
:   A table that lists each role against each protected object and states the privilege the role holds on it.

access review
:   The scheduled comparison of what a database server allows against what the data owner approved, recorded so the next review can measure drift from it.

ACID
:   The four guarantees a transaction makes: atomicity (all or nothing), consistency (constraints hold when it ends), isolation (concurrent transactions do not see each other's unfinished work), and durability (a committed change survives a crash).

administrative safeguards
:   The HIPAA Security Rule's policy and people requirements (45 CFR 164.308): risk analysis, workforce access rules, training, incident procedures, and contingency planning.

application tier
:   The network tier that runs business logic (the scheduling application, a reporting service, a scheduled job). It accepts connections from the presentation tier and is the only tier that should connect to the database.

authentication
:   The step that proves a claimed identity, by a password checked with SCRAM, a client certificate, or a ticket from a central directory. In PostgreSQL, `pg_hba.conf` chooses the method for each connection.

authorization
:   The step that decides what an authenticated identity may do: privileges, role memberships, and row-level security policies. It happens inside the database after authentication and is never delegated to an outside directory.

availability
:   The property that authorized users can reach data and systems when they need them. An outage is an availability failure even when nothing leaks.

## B

baseline
:   A measurement taken while a system is healthy (size, version, roles, response time) so later readings can show what changed.

Big Data
:   Datasets too large, too fast, or too varied for one server and one schema, spread across many machines. The traditional test is volume, velocity, and variety. Every copy across those machines is a place confidentiality can fail.

business associate
:   An outside organization that creates, receives, maintains, or transmits protected health information on a covered entity's behalf (45 CFR 160.103). A hosting provider such as Copperwind is one, and the Security Rule applies to it directly.

business associate agreement (BAA)
:   The written contract HIPAA requires before a covered entity may let a vendor, including a cloud provider, create, receive, store, or transmit protected health information. The vendor accepts its share of the safeguards in the agreement.

## C

capacity planning
:   The discipline of turning measured size, growth, throughput, and usage into a hardware purchase or a cloud tier, with a date by which the estimate must be re-measured.

CHECK constraint
:   A constraint that holds any true-or-false condition on a row, such as a status drawn from a fixed list or a date in the past. The database refuses any insert or update that makes the condition false.

CIA triad
:   The three properties every protected system must preserve: confidentiality, integrity, and availability. Every database threat attacks at least one of them.

cluster
:   One running PostgreSQL server, which holds many databases. Roles and server settings belong to the cluster, not to any one database.

confidentiality
:   The property that only authorized people and programs can read data, through queries, exports, backups, logs, or network traffic.

connection limit
:   The maximum number of simultaneous sessions a role may hold, set with `CONNECTION LIMIT`. A cap on a service account protects availability when an application leaks connections.

control
:   A safeguard that reduces the likelihood or the impact of a threat. Controls come in families such as access control, encryption, auditing, and backup.

covered entity
:   A health plan, a health care clearinghouse, or a health care provider that transmits health information electronically (45 CFR 160.103). HIPAA's rules apply to it.

## D

data classification
:   Assigning each data element a sensitivity level (Public, Internal, Confidential, Restricted) that decides how it is stored, who may see it, and how it is disposed of.

data owner
:   The business leader accountable for a dataset, who decides who has a legitimate need to see it. The DBA implements that decision and proves it took effect.

data tier
:   The most restricted network tier, which holds the database server. It accepts connections only from the application tier and a small set of administrative addresses, never from the internet.

database administrator (DBA)
:   The person who installs, configures, monitors, backs up, tunes, and recovers a DBMS and who implements access decisions made by data owners.

database management system (DBMS)
:   The software that stores data, enforces rules about it, controls who may reach it, logs activity, and recovers it after failure. PostgreSQL, Oracle Database, MySQL, and SQL Server are all DBMS products.

de-identification
:   The HIPAA standard (45 CFR 164.514(b)) under which health information stops being PHI once the eighteen listed identifiers are removed and there is no reasonable basis to identify anyone.

default privileges
:   A standing rule, set with `ALTER DEFAULT PRIVILEGES`, that tells PostgreSQL what to grant on objects a role creates in the future. A plain `GRANT ... ON ALL TABLES` covers only the tables that exist at that moment.

directory information
:   Information in an education record that would not generally be considered harmful or an invasion of privacy if disclosed (34 CFR 99.3). A school may release it only after public notice and only for students whose parents have not opted out (34 CFR 99.37).

disposal log
:   A record of each destruction run: the record series, the cutoff, the number of rows destroyed, the authority, who ran it, and when. Part of the documentation HIPAA keeps for six years.

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

## F

firewall
:   A device or software layer that permits or drops network traffic by address, port, and direction. Firewalls between tiers keep a database reachable only from the systems that need it.

functional dependency
:   A relationship in which one column's value determines another's, such as a patient determining a phone number. Third Normal Form requires every non-key column to depend on the table's key and nothing else.

## G

group role
:   A role that exists to hold privileges for its members. It normally cannot log in, and login roles receive privileges by becoming members of it.

growth
:   The rate at which a database's size rises over time, measured from the data (rows added per month) and expressed as a monthly rate for projection.

## H

host-based authentication
:   PostgreSQL's rule table, kept in `pg_hba.conf`, for deciding connection by connection whether to accept a client and how to verify its identity. Rules match top to bottom and the first match wins. A connection that matches no rule is refused.

## I

identity
:   A name a system recognizes: a login role, a person's account, or a certificate's subject. Identity is the claim that authentication proves and authorization acts on.

identity and access management (IAM)
:   The policies and systems that establish who someone is, prove it, and control what they may do. A database participates in IAM for identity and authentication but keeps authorization to itself.

infrastructure as a service (IaaS)
:   A service model in which a cloud provider rents virtual machines, storage, and networking. The customer installs, patches, and manages the operating system and the DBMS on the rented machine.

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

## L

least privilege
:   The rule that every account receives the minimum access its work requires and nothing more.

legal hold
:   A suspension of the retention schedule for specific records because of litigation, an investigation, a records request, or a complaint. A hold outranks the schedule and must be visible to the disposal run.

legitimate educational interest
:   The FERPA basis on which a school official may see an education record without consent (34 CFR 99.31(a)(1)). The school defines it and must use reasonable methods to limit officials to the records it covers.

login role
:   A role with the `LOGIN` attribute, which allows a connection to start. A person and a service account are both login roles with different settings.

lost update
:   A concurrency failure in which two transactions each read the same state, each act on it, and each commit, so one change silently overwrites or duplicates the other. A double booking is a lost update. A constraint checked at commit time prevents it.

## M

managed database service
:   A cloud offering in which the provider installs, patches, backs up, and replicates the DBMS while the customer keeps every decision about data, access, and retention.

management lifecycle
:   The five-stage loop this book follows: Plan, Secure, Monitor, Recover, Review. Each stage maps to one course outcome.

materialized view
:   A view whose query result is stored as real rows on disk. Reads are fast, and the rows are only as current as the last REFRESH MATERIALIZED VIEW, so the refresh schedule is a decision to write down.

meta-command
:   A psql instruction that begins with a backslash, such as `\l` or `\dt`. Meta-commands are handled by the client and are not SQL.

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

## P

pgAdmin
:   The graphical client for PostgreSQL, used to browse objects, read execution plans, and inspect privileges.

physical safeguards
:   The HIPAA Security Rule's requirements for facilities, workstations, and media (45 CFR 164.310), including the disposal of media that held PHI.

policy
:   A named row-level security rule attached to a table. Its `USING` expression must be true for a row to be visible to the roles the policy names.

PostgreSQL
:   The free, open-source DBMS this book uses as its lab server. Version 17 is the course target.

presentation tier
:   The network tier that faces users: web servers and portals. It is reachable from the internet, is assumed to be attacked, and must never hold a database.

privilege
:   A named permission on one object, held by one role, such as `SELECT` on a table, `USAGE` on a schema, or `CONNECT` on a database.

protected health information (PHI)
:   Individually identifiable health information that a covered entity or business associate holds or transmits in any form (45 CFR 160.103). Health information becomes PHI when joined to any of eighteen identifiers such as a name, a date, a phone number, or a member number.

psql
:   PostgreSQL's command-line client. Every script and captured output in this book runs through it.

PUBLIC
:   The pseudo-role that stands for every role on the server. PostgreSQL grants it `CONNECT` on new databases and `USAGE` on the `public` schema by default.

## Q

## R

reporting workload
:   A pattern of few large reads that scan many rows and can take time, such as a monthly rollup by provider. It wants the data joined and summed, in a shape built from the normalized tables.

retention schedule
:   A written table that names each record series, the event that starts its clock, how long it is kept, how it is destroyed, and the authority for the rule.

role
:   A PostgreSQL account that can be a user (a role that can log in), a group (a role that holds privileges for others), or both.

role-based access control (RBAC)
:   The practice of granting privileges to job roles and assigning people to jobs, so that hiring and departures change memberships, not grants.

row-level security
:   A table-level control that filters which rows each role can see or change, enforced by policies that the table applies to every query from a role that is not its owner or a superuser.

## S

schema
:   A named container for tables, views, and other objects inside one database. A role needs USAGE on a schema before it can reach anything inside it, which makes the schema a security boundary.

SCRAM-SHA-256
:   PostgreSQL's default password scheme since version 14. The server stores a salted hash, and the challenge-response exchange never sends the password itself across the network.

secure deletion
:   Removal of data from every place it could still be read (the table, the write-ahead log, backups, replicas, and exports), with a record that proves it.

security administrator
:   The person who sets access policy, reviews privileges, watches logs for misuse, and leads the response when a control fails.

Security Rule
:   The HIPAA regulation at 45 CFR Part 164, Subpart C, that protects electronic protected health information through administrative, physical, and technical safeguards.

security tier
:   A group of systems that share the same exposure and the same rules about who may connect to them. Also called a zone. The classic layout has presentation, application, and data tiers separated by firewalls.

semi-structured data
:   Records that share a core of fixed fields and then vary, such as an intake form whose questions change every quarter. The fixed part belongs in constrained columns and the variable part in JSONB.

separation of duties
:   The principle that no single person should be able to request access, grant it, use it, and erase the record of having done so.

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

staging table
:   A temporary landing table with no constraints that holds an import exactly as it arrived, so the data can be inspected with queries before anything trusts it. It is dropped once the load is proven.

superuser
:   A PostgreSQL role that bypasses every permission check. Used to build the lab and then set aside.

surrogate key
:   A system-generated identifier with no business meaning, used as a primary key so that it never has to change when a name, a phone number, or any other business attribute does.

## T

technical safeguards
:   The HIPAA Security Rule's controls inside the system (45 CFR 164.312): access control, audit controls, integrity, person or entity authentication, and transmission security.

Third Normal Form (3NF)
:   The design state in which every non-key column depends on the key, the whole key, and nothing but the key. Meeting it removes update anomalies and gives each fact one place to be guarded.

threat
:   Anything that could violate the confidentiality, integrity, or availability of data.

throughput
:   The amount of work a server handles per unit of time, such as rows inserted per hour or queries per second. PostgreSQL keeps cumulative counters in `pg_stat_user_tables` and `pg_stat_database`.

transaction
:   A group of SQL statements that either all take effect or all fail together, bounded by BEGIN and COMMIT or ROLLBACK.

transactional workload
:   A pattern of many small reads and writes, each touching a few rows and each needing to finish now, such as a front desk booking one appointment. Normalized tables with constraints serve it.

## U

update anomaly
:   The result of storing one fact in more than one row: the fact is changed in one place and not the others, so the data disagrees with itself. Normalization removes it by storing the fact once.

usage
:   When the load arrives and who generates it. Usage analysis finds the peak hour, day, or season a server must be sized for.

## V

view
:   A named query that behaves like a table but stores no rows. It fixes one definition of a report and gives a reporting role a privilege boundary, since the role can be granted the view and not the tables behind it.

## W

working set
:   The part of a database that daily queries touch. A server whose memory holds the working set answers most queries without reading disk.

## X

## Y

## Z
