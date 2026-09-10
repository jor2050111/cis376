# Chapter 12 Capture Notes

Where every printed result in Chapter 12 came from, so any of them can
be reproduced.

## Server used

PostgreSQL 17.11 (Homebrew build) on the local cluster, port 5432,
captured 2026-09-10. No cluster configuration was changed for this
chapter, and no server restart was needed, so no throwaway cluster on a
spare port was required.

## How the chapter's outputs were produced

Every `sql` block in `book/chapters/chapter-12.md` ran through
`tools/run_chapter_sql.py`, which rebuilds `copperwind_ops`,
`sandwash_clinic`, and `harquahala_academy` from the three setup
scripts in this folder and then runs the blocks in reading order in one
session. The `-- Output:` comment lines were pasted from that run's log
by `tools/fill_sql_outputs.py` and re-checked by
`tools/check_sql_outputs.py`.

## Two results that depend on order

* The Copperwind size in Section 12.4 reads larger than a freshly
  loaded copy, because Section 12.1 adds the `deploy` schema and
  Section 12.2 adds an index on `tickets(status)`. The chapter says so
  where the number appears.
* The grant listing in Section 12.4 shows only `copperwind_reporting`,
  because that block creates the role two lines earlier. A rerun of the
  setup script drops it again.

## The Fix It error

The error line in Fix It 12.1 was captured by running the broken
statement through the same harness against a scratch chapter on
2026-09-10. It is quoted from the run, not written by hand:

```text
ERROR:  column "t.client_id" must appear in the GROUP BY clause or be used in an aggregate function
```

## The Try It Yourself 12.5 expected output

Try It Yourself 12.5 is problem-first, so the chapter shows the result
without the queries. That result came from the reference solution in
`docs/execution-logs/chapter-12-reference.sql`, run through the harness
after the same state changes the chapter makes.
