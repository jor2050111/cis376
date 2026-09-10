-- CHAPTER-SPECIFIC: do not regenerate
-- Sets up harquahala_academy, the Harquahala Charter Academy database
-- (FERPA), in the state the academy's server was in on the morning of
-- 2026-09-03: the base tables plus the two service logins, including the
-- reporting role that was over-granted on 2026-08-30. Chapter 10 traces
-- that grant and Skills Lab 10A closes it.
-- Run from the extracted cis376 folder:
--     psql -U postgres -d postgres -f assets/code/chapter-10/setup-harquahala.sql
-- The script is idempotent: it drops and recreates every table it owns
-- and every role whose name starts with academy_.

SELECT 'CREATE DATABASE harquahala_academy'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'harquahala_academy') \gexec
\connect harquahala_academy

-- Roles are cluster-wide, so a rerun must remove the chapter's roles
-- before it recreates them. DROP OWNED BY revokes every privilege a role
-- holds in this database, which is what otherwise blocks DROP ROLE.
DO $$
DECLARE
  academy_role text;
BEGIN
  FOR academy_role IN
    SELECT rolname FROM pg_roles WHERE rolname LIKE 'academy\_%'
  LOOP
    EXECUTE format('DROP OWNED BY %I', academy_role);
    EXECUTE format('DROP ROLE %I', academy_role);
  END LOOP;
END
$$;

DROP TABLE IF EXISTS portal_accounts, grades, enrollments, sections, courses,
  staff, student_guardians, guardians, students CASCADE;

CREATE TABLE students (
  student_id         integer PRIMARY KEY,
  first_name         text NOT NULL,
  last_name          text NOT NULL,
  date_of_birth      date NOT NULL,
  grade_level        smallint NOT NULL,
  directory_opt_out  boolean NOT NULL DEFAULT false
);

CREATE TABLE guardians (
  guardian_id  integer PRIMARY KEY,
  full_name    text NOT NULL,
  phone        text,
  email        text,
  relationship text NOT NULL
);

CREATE TABLE student_guardians (
  student_id  integer NOT NULL REFERENCES students (student_id),
  guardian_id integer NOT NULL REFERENCES guardians (guardian_id),
  is_primary  boolean NOT NULL,
  PRIMARY KEY (student_id, guardian_id)
);

CREATE TABLE staff (
  staff_id  integer PRIMARY KEY,
  full_name text NOT NULL,
  role_name text NOT NULL
);

CREATE TABLE courses (
  course_id   integer PRIMARY KEY,
  course_name text NOT NULL,
  grade_level smallint NOT NULL
);

CREATE TABLE sections (
  section_id integer PRIMARY KEY,
  course_id  integer NOT NULL REFERENCES courses (course_id),
  staff_id   integer NOT NULL REFERENCES staff (staff_id),
  term       text NOT NULL
);

CREATE TABLE enrollments (
  enrollment_id integer PRIMARY KEY,
  student_id    integer NOT NULL REFERENCES students (student_id),
  section_id    integer NOT NULL REFERENCES sections (section_id)
);

CREATE TABLE grades (
  enrollment_id integer PRIMARY KEY REFERENCES enrollments (enrollment_id),
  term_grade    char(1) NOT NULL,
  comments      text
);

CREATE TABLE portal_accounts (
  account_id    integer PRIMARY KEY,
  guardian_id   integer NOT NULL REFERENCES guardians (guardian_id),
  username      text NOT NULL UNIQUE,
  password_hash text NOT NULL
);

\copy students          FROM 'assets/code/data/harquahala/students.csv'          WITH (FORMAT csv, HEADER true)
\copy guardians         FROM 'assets/code/data/harquahala/guardians.csv'         WITH (FORMAT csv, HEADER true)
\copy student_guardians FROM 'assets/code/data/harquahala/student_guardians.csv' WITH (FORMAT csv, HEADER true)
\copy staff             FROM 'assets/code/data/harquahala/staff.csv'             WITH (FORMAT csv, HEADER true)
\copy courses           FROM 'assets/code/data/harquahala/courses.csv'           WITH (FORMAT csv, HEADER true)
\copy sections          FROM 'assets/code/data/harquahala/sections.csv'          WITH (FORMAT csv, HEADER true)
\copy enrollments       FROM 'assets/code/data/harquahala/enrollments.csv'       WITH (FORMAT csv, HEADER true)
\copy grades            FROM 'assets/code/data/harquahala/grades.csv'            WITH (FORMAT csv, HEADER true, NULL '')
\copy portal_accounts   FROM 'assets/code/data/harquahala/portal_accounts.csv'   WITH (FORMAT csv, HEADER true)

ANALYZE;

-- The academy's two service logins. Replace both passwords on any
-- server that is not a lab copy.
CREATE ROLE academy_app LOGIN
  PASSWORD 'Harquahala-Ch10-App-2026!';
GRANT SELECT, INSERT, UPDATE ON students, enrollments, grades TO academy_app;

-- The reporting login. The GRANT below is the one Principal Whitfield
-- ran on 2026-08-30 to unblock a board report. It is the over-grant
-- Section 10.2 traces and Skills Lab 10A revokes.
CREATE ROLE academy_reports LOGIN
  PASSWORD 'Harquahala-Ch10-Reports-2026!';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO academy_reports;
