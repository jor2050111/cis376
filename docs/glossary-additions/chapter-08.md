# Glossary additions: Chapter 8

Terms bolded on first use in `book/chapters/chapter-08.md`, in the
definition-list format, alphabetical. The maintainer merges these into
`book/glossary.md` under the matching letter headings. `baseline`
already exists from Chapter 1 and is not repeated here. `write-ahead
log (WAL)` is bolded again here after Chapter 2 introduced it, and is
included so a definition ships if Chapter 2 did not add one; merge only
one copy.

ANALYZE
:   The command that refreshes the statistics the planner uses to choose an execution plan. Autovacuum runs it in the background, and you run it by hand after a bulk load so the next plan reflects the new data.

backup
:   A copy of a database, stored so it can be restored after data is lost or corrupted. A backup is restored after an outage, unlike a standby, which takes over during one.

backup plan
:   The written record that names, for each database, its recovery point and recovery time objectives, its backup method, its replication, and the owner who signs those numbers.

execution plan
:   PostgreSQL's step-by-step account of how it will run a query: which tables it reads, in what order, and how it joins them. `EXPLAIN` shows the plan and `EXPLAIN ANALYZE` runs the query and reports what happened.

expression index
:   An index built on the result of a function or expression, such as `lower(last_name)`, so a query that filters on that same expression can use it. A plain index on the bare column cannot answer a transformed value.

failover
:   Promoting a standby server to primary when the primary fails. Done by hand it takes as long as a person needs to notice and act; automated with a monitoring tool it drops to seconds.

high availability
:   A design in which a standby server takes over during an outage, rather than being restored after one, so the recovery time objective can be measured in seconds.

index
:   A sorted structure the server keeps beside a table so it can find rows by a column's value without reading every row. It speeds reads and slightly slows writes, because each change must update it.

index scan
:   A plan step that reads an index to locate matching rows and then fetches only those rows, instead of reading the whole table. Its appearance in a plan is the usual sign that an index is doing its job.

pg_dump
:   The utility that writes one database to a file as the SQL needed to rebuild it or as a compressed archive. It captures the database as of the moment the dump started, so later writes are not included.

pg_stat_statements
:   An extension that records every statement the server runs, with call count and total and mean time, so an administrator can sort by cost and find the slowest query. It must be loaded at server start through `shared_preload_libraries`.

point-in-time recovery
:   Restoring a base backup and then replaying archived write-ahead log up to a chosen moment, which shrinks the recovery point objective from a full backup interval to seconds.

primary
:   In replication, the server that accepts writes and streams its changes to one or more standby servers.

recovery point objective (RPO)
:   The maximum amount of recent data, measured in time, that an organization can afford to lose in a failure. The data owner sets it, and the backup method must meet it.

recovery time objective (RTO)
:   The maximum length of time, from failure to restored service, that an organization can tolerate. The data owner sets it, and the recovery method must meet it.

replication
:   Keeping a live second copy of a database on another server by continuously copying changes, so the copy can serve reads or take over on failure.

sequential scan
:   A plan step that reads every row in a table and discards the ones that do not match the filter. It is efficient for small tables and the cost tuning tries to remove on large ones.

standby
:   A server that continuously replays the primary's write-ahead log to stay ready to take over, and can also serve read-only queries.

streaming replication
:   Replication in which the primary sends its write-ahead log to a standby as it is written, keeping the standby seconds behind and ready for failover.

VACUUM
:   The command that reclaims the space held by dead rows left behind by updates and deletes. Plain `VACUUM` frees the space for reuse while the table stays in use; `VACUUM FULL` rewrites the table and returns space to the operating system, but locks the table while it runs.

work_mem
:   The setting that caps the memory a single sort or hash may use before it spills to disk. It applies per operation and per connection, so a large value multiplied across many connections can exhaust server memory.

write-ahead log (WAL)
:   PostgreSQL's record of every change, written to disk before the change reaches the table. It powers crash recovery and, when archived, point-in-time recovery and streaming replication.
