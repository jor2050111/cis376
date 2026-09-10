-- Skills Lab 4A: Classify and Separate Sandwash Clinic Data
-- Name:
-- Run from the extracted cis376 folder:
--     psql -U postgres -d postgres -f assets/code/chapter-04/setup-sandwash.sql
--     psql -U postgres -d sandwash_clinic -f skills-lab-4a.sql
-- Paste each result under its query as -- Output: comment lines, or
-- save the psql output beside this file.

\connect sandwash_clinic

\echo === Part 1: Foundation ===

-- 1.1 Every column in the five clinic tables, with its data type


-- 1.2 The join path from visit_notes to a patient's name


\echo === Part 2: Application ===

-- 2.1 Create clinic_restricted, move the Restricted tables, create clinic
--     (justify each move in a comment)


-- 2.2 Create clinic_frontdesk and the view clinic.frontdesk_schedule
--     (explicit column list, then GRANT USAGE and GRANT SELECT)


-- 2.3 Prove the boundary: has_schema_privilege(), has_table_privilege(),
--     then SET ROLE clinic_frontdesk, count the view, RESET ROLE


\echo === Part 3: Extension ===

-- 3.1 Legal-hold table, disposal-log table, one hold, then the VN-01
--     disposal run for cutoff 2020-09-01 in one transaction. Paste the
--     log row and the after-count.

