-- Skills Lab 10A: The Harquahala Breach
-- Name:
-- Run from the extracted cis376 folder:
--     psql -U postgres -d postgres -f assets/code/chapter-10/setup-harquahala.sql
-- Then work through the markers below in psql. Paste each result under
-- its query as -- Output: comment lines, or save the psql output file.

\connect harquahala_academy

\echo === Part 1: Foundation ===

-- 1.1 Declare the evidence time zone, then load academy_audit_trail.csv
--     and postgresql-2026-09-03.log into tables. Report the row count and
--     the date range of each.


-- 1.2 Answer the three scope questions: the failed-login summary, the
--     session that followed with its source address, and the statements
--     that ran with the exported column list pulled out of each


-- 1.3 Measure the exposure. Guardians in the first export. For the second
--     export, grade rows, distinct students, and how many of those
--     students have directory_opt_out set to true


\echo === Part 2: Application ===

-- 2.1 Merged timeline from both sources, ordered, with the report's time
--     zone as a column


-- 2.2 Contain the compromised account, then prove three things: the login
--     is shut, no session survives, and its privileges are still readable


-- 2.3 Decide whether a restore is needed and prove it with two
--     independent witnesses. Then eradicate the root cause and read the
--     catalog back to show the opening is closed


\echo === Part 3: Extension ===

-- 3.1 Build the notification decision table for this incident, using the
--     exported column list from 1.2 as the facts and a citation on every
--     row
