# Chapter 11 hand captures

Every `text` fence in `book/chapters/chapter-11.md` that shows server
output was captured from a real run on 2026-09-10 (PostgreSQL 17.11,
Homebrew, macOS). Two of the three came from the shared course cluster
through `tools/run_chapter_sql.py`. The third needed a server restart,
so it came from a throwaway instance. The shared cluster on port 5432
was never reconfigured and never restarted.

## Fix It 11.1: the error line

Captured by running the two broken statements as a scratch chapter
through `tools/run_chapter_sql.py` against `copperwind_ops` on the
shared cluster:

```text
CREATE EXTENSION pg_stat_statements;
SELECT queryid, calls, query FROM pg_stat_statements
ORDER BY total_exec_time DESC LIMIT 3;
```

The `CREATE EXTENSION` succeeds and prints `CREATE EXTENSION`. The
`SELECT` raises, and the final error line is the one the chapter
prints, verbatim:

```text
ERROR:  pg_stat_statements must be loaded via "shared_preload_libraries"
```

Confirmed in the same run that `SHOW shared_preload_libraries;` returns
an empty string on this cluster, and that
`SELECT name, context, pending_restart FROM pg_settings WHERE name =
'shared_preload_libraries';` returns `postmaster` and `f`. The chapter
cites the `context` value in the Repair step rather than printing that
row.

## Fix It 11.1: the Verify transcript

Method: `initdb` into a scratch directory with `-U postgres
--auth=trust`, then `postgresql.conf` set to `port = 5477` and
`listen_addresses = '127.0.0.1'`, and the server started with `pg_ctl`.
Port 5477 was chosen because Chapter 6 used 5499 and Chapter 7 used
5439. The instance was stopped and deleted after the capture.

Steps, in order:

1. Started the instance. `SHOW shared_preload_libraries;` returned an
   empty string. `CREATE EXTENSION pg_stat_statements;` succeeded and
   `SELECT count(*) FROM pg_stat_statements;` raised the same error line
   as above, which confirms the bug reproduces on a clean install.
2. Appended `shared_preload_libraries = 'pg_stat_statements'` and
   `pg_stat_statements.track = 'top'` to `postgresql.conf`, then
   `pg_ctl restart`.
3. Created `clients`, `technicians`, and `tickets` in the instance's
   `postgres` database with the same DDL the chapter's setup script
   uses, loaded them with `\copy` from `assets/code/data/copperwind/`,
   and ran `ANALYZE`, so the captured query text looks like Copperwind's
   own reports rather than a synthetic demo.
4. `SELECT pg_stat_statements_reset();` then ran two representative
   monthly-report statements: the category rollup three times and the
   open-tickets-by-client lookup five times, each in its own `psql -c`
   session.
5. Captured `SHOW shared_preload_libraries;` and the top two statements
   by total execution time.

The chapter's `text` fence reproduces both results with the psql
`(N rows)` footers dropped, matching the style of the `sql` blocks. The
two query rows are truncated to 44 characters by the `left(query, 44)`
call in the capture query itself, not by hand. Nothing else was edited.
Timings and call counts vary from run to run, and the chapter prose says
so before the fence.

## Try It Yourself 11.5: the expected output

Not a hand capture. The reference solution
(`docs/execution-logs/chapter-11-reference.sql`) was run as a scratch
chapter through `tools/run_chapter_sql.py` on 2026-09-10 against
`harquahala_academy` built from `assets/code/chapter-11/
setup-harquahala.sql`. The `text` fence in the chapter is the harness
log's table for that block, with the `(6 rows)` footer dropped.

## What was deliberately not captured

`pg_stat_user_tables.idx_scan` is named in Section 11.2 and never
printed. Those counters move every time anyone touches the database, so
no value would survive a rerun of the harness. The chapter says this in
prose and sends the reader to their own server for the reading.
