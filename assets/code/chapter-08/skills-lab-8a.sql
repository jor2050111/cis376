-- Skills Lab 8A: Tune and Protect Copperwind Tickets
-- Name:
-- Run from the extracted cis376 folder, connected to copperwind_ops:
--     psql -U postgres -d copperwind_ops -f skills-lab-8a.sql
-- Paste each plan under its query as -- Output: comment lines, or
-- save the psql output beside this file. Use
--   EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF)
-- for the plans you paste, and plain EXPLAIN ANALYZE to read the
-- execution time you record as a baseline.

\echo === Part 1: Foundation ===

-- 1.1 Baseline plans for three slow reports, before any change:
--     open tickets for one client, one ticket's notes timeline,
--     and tickets opened in a given month


-- 1.2 For each report, the plan line that shows the slow step and
--     the ratio of rows read to rows returned


\echo === Part 2: Application ===

-- 2.1 Add the index each report needs (plain index, or an expression
--     index / rewritten range filter for the monthly report)


-- 2.2 Re-run the identical plans and paste them beside the baseline


-- 2.3 One large sort with work_mem set low, then set high, with both
--     Sort Method lines


\echo === Part 3: Extension ===

-- 3.1 wal_level, archive_mode, and max_wal_senders from pg_settings


-- 3.2 (In the answer file) the completed redundancy-plan-template.md
--     and the security section naming controls that travel with each copy
