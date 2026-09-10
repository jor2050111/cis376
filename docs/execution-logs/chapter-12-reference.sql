-- Reference solution for Chapter 12, Try It Yourself 12.5
-- (Write the Evidence Queries for All Three). Never shipped in the chapter.
-- Chapter 12 is fading level C (problem-first): the chapter states the task,
-- the template, and the expected output, and the student writes every query.
-- This file is that solution.
--
-- Run as postgres from the extracted cis376 folder. The output lines below
-- were captured by running these blocks through tools/run_chapter_sql.py as
-- a scratch chapter on 2026-09-10 (PostgreSQL 17.11), after replaying the
-- state the chapter itself creates: the deploy schema in Section 12.1, the
-- index on tickets(status) in Section 12.2, and the copperwind_reporting
-- role in Section 12.4. Without that prelude, copperwind_ops reads 14 MB.
--
-- The task: three sections of management-security-plan-template.md ask for
-- query output. Section 2 (Architecture) needs one row per database.
-- Section 3 (Access Control) needs proof that no table is readable by
-- PUBLIC. Section 6 (Recovery and Availability) needs the acceptance check
-- a restore has to pass.

-- Step 1: Architecture evidence. Run the same query in each database, so
--         the plan's section 2 carries one comparable row per database.
\connect copperwind_ops
SELECT current_database() AS database_name,
       split_part(current_setting('server_version'), ' ', 1) AS server_version,
       pg_size_pretty(pg_database_size(current_database())) AS total_size,
       (SELECT COUNT(*) FROM pg_class
        WHERE relkind = 'r'
          AND relnamespace = 'public'::regnamespace) AS table_count;
-- Output:
--  database_name  | server_version | total_size | table_count
-- ----------------+----------------+------------+-------------
--  copperwind_ops | 17.11          | 15 MB      |           5

\connect sandwash_clinic
SELECT current_database() AS database_name,
       split_part(current_setting('server_version'), ' ', 1) AS server_version,
       pg_size_pretty(pg_database_size(current_database())) AS total_size,
       (SELECT COUNT(*) FROM pg_class
        WHERE relkind = 'r'
          AND relnamespace = 'public'::regnamespace) AS table_count;
-- Output:
--   database_name  | server_version | total_size | table_count
-- -----------------+----------------+------------+-------------
--  sandwash_clinic | 17.11          | 9790 kB    |           5

\connect harquahala_academy
SELECT current_database() AS database_name,
       split_part(current_setting('server_version'), ' ', 1) AS server_version,
       pg_size_pretty(pg_database_size(current_database())) AS total_size,
       (SELECT COUNT(*) FROM pg_class
        WHERE relkind = 'r'
          AND relnamespace = 'public'::regnamespace) AS table_count;
-- Output:
--    database_name    | server_version | total_size | table_count
-- --------------------+----------------+------------+-------------
--  harquahala_academy | 17.11          | 10022 kB   |           9

-- Step 2: Access evidence. Ask the server whether PUBLIC can read each
--         table, because the plan's access table is a promise until a
--         catalog answer sits beside it. Every row must read f.
SELECT c.relname AS table_name,
       has_table_privilege('public', c.oid, 'SELECT') AS public_can_select
FROM pg_class AS c
WHERE c.relkind = 'r'
  AND c.relnamespace = 'public'::regnamespace
ORDER BY c.relname;
-- Output:
--     table_name     | public_can_select
-- -------------------+-------------------
--  courses           | f
--  enrollments       | f
--  grades            | f
--  guardians         | f
--  portal_accounts   | f
--  sections          | f
--  staff             | f
--  student_guardians | f
--  students          | f

-- Step 3: Recovery evidence. One row per table with the count a restore
--         must reproduce, which turns the plan's acceptance check into a
--         comparison anyone can rerun after a drill.
SELECT 'courses' AS table_name, COUNT(*) AS row_count FROM courses
UNION ALL SELECT 'enrollments', COUNT(*) FROM enrollments
UNION ALL SELECT 'grades', COUNT(*) FROM grades
UNION ALL SELECT 'guardians', COUNT(*) FROM guardians
UNION ALL SELECT 'portal_accounts', COUNT(*) FROM portal_accounts
UNION ALL SELECT 'sections', COUNT(*) FROM sections
UNION ALL SELECT 'staff', COUNT(*) FROM staff
UNION ALL SELECT 'student_guardians', COUNT(*) FROM student_guardians
UNION ALL SELECT 'students', COUNT(*) FROM students
ORDER BY table_name;
-- Output:
--     table_name     | row_count
-- -------------------+-----------
--  courses           |        40
--  enrollments       |      6000
--  grades            |      6000
--  guardians         |      1201
--  portal_accounts   |      1201
--  sections          |       120
--  staff             |        60
--  student_guardians |      1253
--  students          |       800
--
-- Note for the instructor: the academy reports the largest table count of
-- the three, which is the answer the Predict step asks for. Its nine tables
-- carry the FERPA record set the plan has to cover, so a plan that lists
-- only students and grades has already missed seven tables.
