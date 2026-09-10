# Chapter 10 hand captures

Every `text` fence in `book/chapters/chapter-10.md` that shows server
output was captured from a real run on 2026-09-10 (PostgreSQL 17.11,
Homebrew, macOS, cluster `TimeZone = America/Phoenix`). No throwaway
cluster was needed, because nothing in this chapter depends on a server
restart or on a `postgresql.conf` change. The shared cluster's
configuration was never touched.

## Section 10.2: the three raw log lines

Method: copied byte for byte from
`assets/code/chapter-10/postgresql-2026-09-03.log`, lines 1, 261, and
299. Verified with `sed -n '1p;261p;299p'`.

## Fix It 10.1: the wrong output

Method: a scratch chapter named `chapter-10.md` in a scratch directory,
run through `tools/run_chapter_sql.py`, which picks the setup scripts by
the chapter number in the file name. The scratch chapter held the audit
and log loads followed by the broken block:

```sql
SET TimeZone = 'UTC';
SELECT current_setting('TimeZone') AS report_zone,
       COUNT(*) AS events_in_window,
       COUNT(*) FILTER (WHERE severity = 'FATAL') AS failed_logins,
       min(logged_at) AS first_event,
       max(logged_at) AS last_event
FROM server_log
WHERE logged_at >= '2026-09-02 23:00:00'
  AND logged_at <  '2026-09-03 03:00:00';
```

The captured result, pasted into the chapter's second `text` fence:

```text
 report_zone | events_in_window | failed_logins |      first_event       |       last_event
-------------+------------------+---------------+------------------------+------------------------
 UTC         |               47 |             0 | 2026-09-02 23:00:59+00 | 2026-09-03 00:57:52+00
```

The repair block runs in the chapter itself under the harness, so its
output came from `tools/fill_sql_outputs.py` and is verified by
`tools/check_sql_outputs.py`. Both blocks set `TimeZone` explicitly, so
the bug reproduces identically on a student machine in any zone.

## Try It Yourself 10.3: the expected output

Method: `docs/execution-logs/chapter-10-reference.sql` was split into
`sql` fences in the same scratch chapter and run through the harness
against `sandwash_clinic` built from
`assets/code/chapter-10/setup-sandwash.sql`. The two result tables in
the chapter's `text` fence are that run's output.

`sessions_closed` is 0 and `live_sessions` is 0 because a lab copy holds
no live connection for `clinic_gyazzie`. On a server where the account
was in use, both numbers would be larger, and the chapter says so.

## Section 10.2: the DROP ROLE error quoted inline

Captured from the same scratch run, as a fourth block after the
containment:

```text
ERROR:  role "clinic_gyazzie" cannot be dropped because some objects depend on it
DETAIL:  privileges for table providers
```

The chapter quotes the `ERROR:` line inline in
"Containment Without Destroying Evidence". It is not the chapter's Fix
It, which is the time zone bug above.

## Exposure counts used to write Skills Lab 10A

Not printed in the chapter, because Part 1.3 of the lab asks students to
produce them. Captured through the harness so the lab is known to be
answerable:

| Measure | Value |
| ------- | ----- |
| Guardian rows exported | 1201 |
| Grade rows exported | 6000 |
| Distinct students exposed | 449 |
| Exposed students with `directory_opt_out` | 27 |
| Students in the database | 800 |
| Students opted out of directory information | 49 |
