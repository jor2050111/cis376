# Copperwind Managed Database Benchmark v2.1 (PostgreSQL 17)

**Owner:** Copperwind Data Services
**Approved by:** Naomi Redhouse, security lead
**Applies to:** every PostgreSQL 17 database Copperwind hosts for a client
**Profiles:** Level 1 controls apply to every managed database. Level 2
controls apply to databases that hold regulated data.

Copperwind IT Services is fictional and so is this benchmark. It is
written in the shape published benchmarks use, including the Center for
Internet Security's PostgreSQL Benchmark: a numbered control, a title,
a rationale, an audit procedure, and a remediation. The controls below
are Copperwind's own wording and its own short subset. Use the
published benchmark itself when you harden a server you are paid to
run. This file exists so you can score one database end to end in a
single sitting.

Score each control PASS, FAIL, or NOT APPLICABLE from the audit output.
Record the observed value beside the score. A control you cannot audit
is a FAIL until you can.

---

## CW-BM-01 Connection logging is enabled

**Profile:** Level 1
**Rationale:** Without a record of who connected and when, no access
review and no incident timeline can start. The connection log is the
cheapest evidence a database produces.
**Audit:** `SHOW log_connections;`
**Expected:** `on`
**Remediation:** Set `log_connections = on` in `postgresql.conf` and
reload the configuration.
**Taught in:** Chapter 7

## CW-BM-02 Statement logging records data definition changes

**Profile:** Level 1
**Rationale:** A table dropped or a column added without a record is a
change nobody can explain later. Logging data definition statements
catches structural change without logging every query.
**Audit:** `SHOW log_statement;`
**Expected:** `ddl`
**Remediation:** Set `log_statement = 'ddl'` in `postgresql.conf` and
reload the configuration.
**Taught in:** Chapter 7

## CW-BM-03 The log line prefix identifies role, database, and host

**Profile:** Level 1
**Rationale:** A log line with only a timestamp cannot answer who did
this or from where. The prefix carries the identity every review needs.
**Audit:** `SHOW log_line_prefix;`
**Expected:** `%m [%p] %u@%d %h `
**Remediation:** Set `log_line_prefix` in `postgresql.conf` to include
`%u`, `%d`, and `%h`, then reload the configuration.
**Taught in:** Chapter 7

## CW-BM-04 Client connections use TLS

**Profile:** Level 1
**Rationale:** A query that crosses the network in the clear can be
read by anyone on the path, and so can its result. Client data in
motion is protected only when the server offers TLS and the host rules
require it.
**Audit:** `SHOW ssl;`
**Expected:** `on`
**Remediation:** Install a server certificate and key, set `ssl = on`
in `postgresql.conf`, restart the server, and require `hostssl` rules
in `pg_hba.conf`.
**Taught in:** Chapter 6

## CW-BM-05 Passwords are stored with SCRAM-SHA-256

**Profile:** Level 1
**Rationale:** SCRAM-SHA-256 stores a salted hash and never sends the
password across the network. Weaker schemes leave a password an
attacker can replay.
**Audit:** `SHOW password_encryption;`
**Expected:** `scram-sha-256`
**Remediation:** Set `password_encryption = 'scram-sha-256'` in
`postgresql.conf`, reload, and reset every existing password so it is
rehashed under the new scheme.
**Taught in:** Chapter 5

## CW-BM-06 Write-ahead log archiving is enabled

**Profile:** Level 2
**Rationale:** A database that keeps no write-ahead log archive can be
restored only to its last full backup. Regulated data with a recovery
point objective under a day needs point-in-time recovery.
**Audit:** `SHOW archive_mode;`
**Expected:** `on`
**Remediation:** Set `archive_mode = on` and an `archive_command` in
`postgresql.conf`, then restart the server.
**Taught in:** Chapter 9

## CW-BM-07 Row-level security is available

**Profile:** Level 2
**Rationale:** Policies that filter rows by the connected role stop
working the moment row-level security is switched off server wide. The
setting must stay on for the policies to mean anything.
**Audit:** `SHOW row_security;`
**Expected:** `on`
**Remediation:** Set `row_security = on` (the default) and remove any
role-level or database-level override that turns it off.
**Taught in:** Chapter 5

## CW-BM-08 The statement collector is preloaded

**Profile:** Level 1
**Rationale:** Without the statement collector, no report can name the
query that costs the most, and performance review falls back to
guesswork and complaints.
**Audit:** `SHOW shared_preload_libraries;`
**Expected:** a list that includes `pg_stat_statements`
**Remediation:** Add `pg_stat_statements` to `shared_preload_libraries`
in `postgresql.conf`, restart the server, then run
`CREATE EXTENSION pg_stat_statements;` in each managed database.
**Taught in:** Chapters 8 and 11

## CW-BM-09 PUBLIC holds no CONNECT privilege on a managed database

**Profile:** Level 1
**Rationale:** PostgreSQL grants CONNECT to PUBLIC by default, so every
role on the cluster can reach every database unless the grant is
removed. A client's database should accept only the roles that serve it.
**Audit:** `SELECT has_database_privilege('public', current_database(), 'CONNECT');`
**Expected:** `f`
**Remediation:** `REVOKE CONNECT ON DATABASE <name> FROM PUBLIC;` then
grant CONNECT to each role that needs it.
**Taught in:** Chapters 5 and 11

## CW-BM-10 Every granted table privilege appears on the signed access list

**Profile:** Level 1
**Rationale:** Privileges drift upward. A grant made during an outage
outlives the outage, and nobody notices until an audit compares what
the server allows against what the data owner approved.
**Audit:** Compare `information_schema.table_privileges` for every role
in the client's prefix against the signed access list, and report every
row that appears in one and not the other.
**Expected:** no unapproved grants and no missing grants
**Remediation:** Revoke every grant that is not on the list, grant every
approved privilege that is missing, and record both in the review.
**Taught in:** Chapters 5 and 11

---

## Scoring record

| Control | Profile | Observed value | Score | Note |
| ------- | ------- | -------------- | ----- | ---- |
| CW-BM-01 | Level 1 | | | |
| CW-BM-02 | Level 1 | | | |
| CW-BM-03 | Level 1 | | | |
| CW-BM-04 | Level 1 | | | |
| CW-BM-05 | Level 1 | | | |
| CW-BM-06 | Level 2 | | | |
| CW-BM-07 | Level 2 | | | |
| CW-BM-08 | Level 1 | | | |
| CW-BM-09 | Level 1 | | | |
| CW-BM-10 | Level 1 | | | |

**Score:** ____ of 10 controls pass.

Copperwind IT Services, Sandwash Family Clinic, and Harquahala Charter
Academy are fictional organizations created for this textbook. All
names, patients, students, staff, and records are synthetic. Any
resemblance to a real organization or person is coincidental.
