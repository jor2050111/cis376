-- Reference solution for Chapter 11, Try It Yourself 11.5
-- (Put the Academy on the Same Routine). Never shipped in the chapter.
-- Chapter 11 is fading level C (problem-first): the block states the
-- metric list, the shipped baselines file, and the expected output, and
-- the student writes the whole solution. This file is that solution.
--
-- Run as postgres from the extracted cis376 folder. The output lines
-- below were captured by running this file's blocks through
-- tools/run_chapter_sql.py as a scratch chapter on 2026-09-10
-- (PostgreSQL 17.11).
--
-- The task: Copperwind manages harquahala_academy on the same monthly
-- routine it runs on its own database. Given the academy's six metrics
-- and the shipped review archive, build the archive in the academy
-- database, capture the 2026-09-01 values, and report every metric
-- against its 2026-08-01 baseline with the change.

-- Step 1: Build the archive in the academy's own database, in its own
--         schema, so the review never sits beside the student tables
\connect harquahala_academy
CREATE SCHEMA IF NOT EXISTS review;
CREATE TABLE review.metrics (
  captured_on   date   NOT NULL,
  database_name text   NOT NULL,
  metric_name   text   NOT NULL,
  metric_value  bigint NOT NULL,
  PRIMARY KEY (captured_on, database_name, metric_name)
);

-- Step 2: Define the academy's six metrics once, as a view, so every
--         month's run measures the same things the same way
CREATE VIEW review.monthly_metrics AS
SELECT 'students_rows' AS metric_name, COUNT(*) AS metric_value FROM students
UNION ALL SELECT 'enrollments_rows', COUNT(*) FROM enrollments
UNION ALL SELECT 'directory_opt_outs', COUNT(*) FROM students
  WHERE directory_opt_out
UNION ALL SELECT 'portal_accounts_rows', COUNT(*) FROM portal_accounts
UNION ALL SELECT 'staff_rows', COUNT(*) FROM staff
UNION ALL SELECT 'indexes_total', COUNT(*) FROM pg_index
  WHERE indrelid IN (SELECT oid FROM pg_class
                     WHERE relnamespace = 'public'::regnamespace
                       AND relkind = 'r');

-- Step 3: Load the shipped archive and capture this month's numbers
\copy review.metrics FROM 'assets/code/chapter-11/review-baselines.csv' WITH (FORMAT csv, HEADER true)
INSERT INTO review.metrics (captured_on, database_name, metric_name, metric_value)
SELECT DATE '2026-09-01', current_database(), metric_name, metric_value
FROM review.monthly_metrics;

-- Step 4: Compare the two captures and show the change on every metric
SELECT last_month.metric_name,
       last_month.metric_value AS baseline_2026_08_01,
       this_month.metric_value AS current_2026_09_01,
       this_month.metric_value - last_month.metric_value AS change
FROM review.metrics AS last_month
JOIN review.metrics AS this_month
  ON this_month.database_name = last_month.database_name
 AND this_month.metric_name = last_month.metric_name
 AND this_month.captured_on = DATE '2026-09-01'
WHERE last_month.captured_on = DATE '2026-08-01'
  AND last_month.database_name = current_database()
ORDER BY last_month.metric_name;
-- Output:
--      metric_name      | baseline_2026_08_01 | current_2026_09_01 | change
-- ----------------------+---------------------+--------------------+--------
--  directory_opt_outs   |                  44 |                 49 |      5
--  enrollments_rows     |                5940 |               6000 |     60
--  indexes_total        |                  10 |                 10 |      0
--  portal_accounts_rows |                1188 |               1201 |     13
--  staff_rows           |                  61 |                 60 |     -1
--  students_rows        |                 793 |                800 |      7
