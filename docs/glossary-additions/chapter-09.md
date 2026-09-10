# Glossary additions: Chapter 9

Terms bolded on first use in `book/chapters/chapter-09.md`, in the
definition-list format, alphabetical. Terms already in
`book/glossary.md` (control, data tier, least privilege, retention
schedule, threat) are not repeated. Chapter 9 uses `data criticality
tier` for a recovery grouping, which is distinct from the network
`data tier` defined in Chapter 2.

base backup
:   A physical, byte-for-byte copy of a database cluster's files, taken as the starting point for point-in-time recovery. WAL is replayed on top of it to reach a chosen moment.

configuration benchmark
:   A published checklist of hardening rules for a system, such as the Center for Internet Security's PostgreSQL Benchmark. A scan reports which rules a server passes and which it fails.

data criticality tier
:   A grouping of data by how much its loss or downtime harms the business, where each tier carries its own recovery time objective, recovery point objective, and backup frequency.

disaster recovery plan
:   The written plan that states how a database is brought back after it goes out of service, including its recovery time objective, recovery point objective, data criticality tiers, and retention requirements.

impact
:   In a vulnerability ranking, how much harm a finding would do if it were used, scored so it can be combined with likelihood into one risk score.

likelihood
:   In a vulnerability ranking, how easily a finding could be used, scored so it can be combined with impact into one risk score.

logical backup
:   A backup produced by `pg_dump` as a file of SQL statements that rebuild the data by replaying them. It restores into an empty database on any compatible server.

parameterized query
:   A query that sends its SQL text and its values to the server separately, so a value can only ever be treated as data and never as SQL. It is the primary defense against SQL injection.

physical backup
:   A byte-for-byte copy of a database's data files, as opposed to a logical backup of SQL statements. It is the basis for point-in-time recovery.

point-in-time recovery (PITR)
:   Recovery that starts from a base backup and replays archived write-ahead log forward to a chosen instant, so a database can be restored to the moment just before a failure.

recovery point objective (RPO)
:   The largest amount of recent data a business can afford to lose in a disaster, measured in time. It decides how often backups must run.

recovery time objective (RTO)
:   The longest acceptable time from the moment a database goes down to the moment it is serving users again. It decides which recovery method is fast enough.

restore drill
:   A rehearsal that restores a real backup into a throwaway database, verifies the result against the recovery plan, and times the restore, run on a schedule before any disaster.

retention requirements
:   The rules stating how long each class of backup is kept, on what media, and how many copies are held offsite, often with a regulatory floor.

secure protocol
:   A network protocol that protects data in transit so a listener learns nothing, such as TLS for client-to-database connections.

security patch
:   A vendor fix for a known software flaw, shipped for PostgreSQL in minor releases that correct defects without changing query behavior.

SQL injection
:   An attack that slips SQL into a value the application treated as plain data, so the attacker's text runs as part of the query. Parameterized queries prevent it.

vulnerability
:   A weakness in software or configuration that an attacker or an accident could use to break confidentiality, integrity, or availability.

vulnerability management
:   The scheduled routine of finding weaknesses, ranking them by likelihood and impact, matching each to a control, fixing or accepting it, and rescanning to measure progress.

write-ahead log (WAL)
:   PostgreSQL's running record of every change, written before the change reaches the data files. It underlies crash recovery, replication, and point-in-time recovery.
