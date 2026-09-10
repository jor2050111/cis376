-- Skills Lab 9A: Recover the Sandwash Clinic
-- Name:
-- Run from the extracted cis376 folder:
--     psql -U postgres -d postgres -f assets/code/chapter-09/setup-sandwash.sql
-- Then work through the markers below in psql. Paste each result under
-- its query as -- Output: comment lines, or save the psql output file.

\echo === Part 1: Foundation ===

-- 1.1 Measure the clinic: count appointments and visit_notes, and find
--     the date range of appointments (this informs the RTO and RPO)


\echo === Part 2: Application ===

-- 2.1 Create an empty drill database named clinic_restore_drill


-- 2.2 Restore sandwash_clinic-backup.sql into the drill (note the time)


-- 2.3 Compare restored counts against your Part 1 counts, label each
--     table match or MISMATCH, and rule the drill pass or fail


\echo === Part 3: Extension ===

-- 3.1 Record the copperwind-scan-report.md findings in a tracking table
--     with a likelihood and an impact, then produce the ranked list


-- 3.2 Drop the drill database when the drill is complete
