-- Reference solution for Chapter 5, Try It Yourself 5.3
-- (Complete the Teacher Policy). Never shipped in the chapter.
-- Run as postgres from the extracted cis376 folder after
-- setup-harquahala.sql. Output lines were captured by running this
-- file through tools/run_chapter_sql.py as a scratch chapter on
-- 2026-09-09 (PostgreSQL 17.11).
--
-- The three gaps in the chapter's text fence resolve to:
--   gap 1: NOLOGIN        (a group role never logs in itself)
--   gap 2: ENABLE         (ALTER TABLE grades ENABLE ROW LEVEL SECURITY)
--   gap 3: current_user   (the login role asking, matched to staff_logins)

\connect harquahala_academy

-- The mapping block from Section 5.3 (the student runs it before the TIY).
CREATE TABLE staff_logins AS
SELECT staff_id,
       'academy_' || lower(replace(full_name, ' ', '_')) AS login_role
FROM staff;
ALTER TABLE staff_logins ADD PRIMARY KEY (staff_id);
ALTER TABLE staff_logins ADD UNIQUE (login_role);
-- Output:
-- SELECT 60
-- ALTER TABLE
-- ALTER TABLE

-- Step 1: One group role for every teacher. It never logs in itself.
CREATE ROLE academy_teacher NOLOGIN;
-- Step 2: The minimum a teacher needs, read only
GRANT SELECT ON sections, enrollments, grades, staff_logins TO academy_teacher;
-- Step 3: Turn on row filtering for grades
ALTER TABLE grades ENABLE ROW LEVEL SECURITY;
-- Step 4: Keep only the rows from sections the current login teaches
CREATE POLICY teacher_own_sections ON grades
  FOR SELECT
  TO academy_teacher
  USING (enrollment_id IN (
    SELECT e.enrollment_id
    FROM enrollments AS e
    JOIN sections AS s ON s.section_id = e.section_id
    JOIN staff_logins AS sl ON sl.staff_id = s.staff_id
    WHERE sl.login_role = current_user));
-- Step 5: One teacher's login, a member of the group
CREATE ROLE academy_keisha_bell LOGIN
  PASSWORD 'Harquahala-Ch5-Teacher-2026!'
  IN ROLE academy_teacher;
-- Step 6: Prove it as the teacher, then step back out
SET ROLE academy_keisha_bell;
SELECT term_grade, COUNT(*) AS students
FROM grades
GROUP BY term_grade
ORDER BY term_grade;
RESET ROLE;
-- Output:
-- CREATE ROLE
-- GRANT
-- ALTER TABLE
-- CREATE POLICY
-- CREATE ROLE
-- SET
--  term_grade | students
-- ------------+----------
--  A          |       68
--  B          |       52
--  C          |       47
--  D          |       17
--  F          |        5
--
-- RESET

-- Cross-check for the Explain prompt: 189 rows visible to the teacher,
-- and 189 grade rows in the sections staff_id 1 teaches.
SET ROLE academy_keisha_bell;
SELECT COUNT(*) AS grades_visible
FROM grades;
RESET ROLE;
SELECT COUNT(*) AS grades_in_her_sections
FROM grades AS g
JOIN enrollments AS e ON e.enrollment_id = g.enrollment_id
JOIN sections AS s ON s.section_id = e.section_id
WHERE s.staff_id = 1;
-- Output:
-- SET
--  grades_visible
-- ----------------
--             189
--
-- RESET
--  grades_in_her_sections
-- ------------------------
--                     189
