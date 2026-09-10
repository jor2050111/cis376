-- Skills Lab 2A: Place and Size the Sandwash Clinic Database
-- Name:
-- Run from the extracted cis376 folder:
--     psql -U postgres -d postgres -f skills-lab-2a.sql
-- Paste each result under its query as -- Output: comment lines, or
-- save the psql output beside this file.

\connect sandwash_clinic

\echo === Part 1: Foundation ===

-- 1.1 Every table: row count, total size, bytes per row


-- 1.2 Appointments by month for the last 12 full months, and the average


-- 1.3 Visit notes per appointment (the ratio)


\echo === Part 2: Application ===

-- 2.1 36-month storage projection (Step 1 through Step 4, labeled)


\echo === Part 3: Extension ===

-- 3.1 The pg_hba_file_rules query you would run before pg_reload_conf(),
--     with a comment naming the two things you would check in its output

