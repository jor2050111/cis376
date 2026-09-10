-- Skills Lab 3A: Redesign the Harquahala Gradebook
-- Name:
-- Run from the extracted cis376 folder:
--     psql -U postgres -d postgres -f skills-lab-3a.sql
-- Paste each result under its query as -- Output: comment lines, or
-- save the psql output beside this file. The Part 2 CHECK constraint
-- error is a required paste.

\connect harquahala_academy

\echo === Part 1: Foundation ===

-- 1.1 Staging table gradebook_import (six text columns, no constraints)
--     and the \copy load from assets/code/chapter-03/, then a row count


-- 1.2 Three anomaly queries: rare teacher-name spellings, duplicated rows,
--     term_grade outside A through F


-- 1.3 (Answer file) The constraint that would have prevented each anomaly


\echo === Part 2: Application ===

-- 2.1 Schema gradebook and the 3NF tables with keys, foreign keys,
--     UNIQUE, NOT NULL, and the term_grade CHECK


-- 2.2 Parent-first load from gradebook_import, teacher variants resolved,
--     duplicates removed, row counts for every target table


-- 2.3 The invalid-grade row loaded as is: paste the CHECK error here


\echo === Part 3: Extension ===

-- 3.1 View gradebook.section_grade_distribution, role academy_reporting,
--     and the has_table_privilege proof


-- 3.2 The view run for the misspelled teacher's sections

