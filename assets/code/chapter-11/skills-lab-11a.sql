-- Skills Lab 11A: The Copperwind Monthly Review
-- Name:
-- Run from the extracted cis376 folder:
--     psql -U postgres -d postgres -f assets/code/chapter-11/setup-copperwind.sql
-- Then work through the markers below in psql. Paste each result under
-- its query as -- Output: comment lines, or save the psql output file.

\connect copperwind_ops

\echo === Part 1: Foundation ===

-- 1.1 Create the review schema and the archive table, then load
--     review-baselines.csv into it


-- 1.2 Define your own metric set as a view (at least six metrics from
--     at least three families) and capture it as of DATE '2026-09-01'


-- 1.3 Report every metric the shipped archive holds against its
--     2026-08-01 baseline, with a change column


\echo === Part 2: Application ===

-- 2.1 Access audit: load copperwind-access-list.csv into
--     review.approved_access and produce the drift table


-- 2.2 Performance audit: the index inventory plus an
--     EXPLAIN (COSTS OFF) plan for the monthly client report


-- 2.3 Benchmark score: compare the eight setting controls in
--     copperwind-benchmark-checklist.md against pg_settings.
--     Audit CW-BM-09 and CW-BM-10 with the commands the checklist gives


\echo === Part 3: Extension ===

-- 3.1 Define a control-metric view for your three adopted controls and
--     capture it as of DATE '2026-09-01'


-- 3.2 Adopt the three controls, each followed by the reading that
--     proves it took effect


-- 3.3 Capture the same view as of DATE '2026-09-15' and produce the
--     before-and-after report with a change column
