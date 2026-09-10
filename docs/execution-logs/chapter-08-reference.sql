-- Reference solution for Chapter 8, Try It Yourself 8.2
-- (Tune the Enrollment Lookup). Never shipped in the chapter.
-- Run as postgres from the extracted cis376 folder after
-- setup-harquahala.sql. Output lines were captured by running this
-- file through tools/run_chapter_sql.py as a scratch chapter on
-- 2026-09-09 (PostgreSQL 17.11).
--
-- The three gaps in the chapter's text fence resolve to:
--   gap 1: ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF
--          (the EXPLAIN option in Step 1: runs the query and reports
--          actual rows without the run-to-run timings)
--   gap 2: INDEX        (CREATE INDEX builds the sorted structure)
--   gap 3: student_id   (the column the page filters one student at a time)

\connect harquahala_academy

-- Step 1: Measure the lookup as it runs today, before any change
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF)
SELECT e.section_id, s.term
FROM enrollments AS e
JOIN sections AS s ON s.section_id = e.section_id
WHERE e.student_id = 42;
-- Output:
--                           QUERY PLAN
-- --------------------------------------------------------------
--  Hash Join (actual rows=15 loops=1)
--    Hash Cond: (e.section_id = s.section_id)
--    ->  Seq Scan on enrollments e (actual rows=15 loops=1)
--          Filter: (student_id = 42)
--          Rows Removed by Filter: 5985
--    ->  Hash (actual rows=120 loops=1)
--          Buckets: 1024  Batches: 1  Memory Usage: 14kB
--          ->  Seq Scan on sections s (actual rows=120 loops=1)

-- Step 2: Index the column the page filters one student at a time
CREATE INDEX enrollments_student_id_idx
  ON enrollments (student_id);

-- Step 3: Re-run the identical query and read the new plan
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF)
SELECT e.section_id, s.term
FROM enrollments AS e
JOIN sections AS s ON s.section_id = e.section_id
WHERE e.student_id = 42;
-- Output:
--                                          QUERY PLAN
-- ---------------------------------------------------------------------------------------------
--  Hash Join (actual rows=15 loops=1)
--    Hash Cond: (e.section_id = s.section_id)
--    ->  Index Scan using enrollments_student_id_idx on enrollments e (actual rows=15 loops=1)
--          Index Cond: (student_id = 42)
--    ->  Hash (actual rows=120 loops=1)
--          Buckets: 1024  Batches: 1  Memory Usage: 14kB
--          ->  Seq Scan on sections s (actual rows=120 loops=1)
