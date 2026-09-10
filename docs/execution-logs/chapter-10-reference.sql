-- Reference solution for Chapter 10, Try It Yourself 10.3
-- (Contain the Clinic Login). Never shipped in the chapter.
-- Chapter 10 is fading level C (problem-first): the spine states the
-- goal, the inputs, and the expected output, and the student writes the
-- whole solution. This file is that solution.
--
-- Run as postgres from the extracted cis376 folder, after
-- assets/code/chapter-10/setup-sandwash.sql. Output lines were captured
-- by running this file's blocks through tools/run_chapter_sql.py as a
-- scratch chapter on 2026-09-10 (PostgreSQL 17.11).
--
-- The task: clinic_gyazzie, the front desk lead's login, is suspected of
-- compromise. Contain it so no one can use it, and leave every piece of
-- evidence about what it could reach readable in the catalog. Then prove
-- the containment and the surviving trail in one reading.

\connect sandwash_clinic

-- Step 1: Shut the door on new connections without removing the account.
--         The role, its privileges, and its ownership all stay in the
--         catalog, which is what the data owner will ask about.
ALTER ROLE clinic_gyazzie NOLOGIN;

-- Step 2: Close any session the account already holds. NOLOGIN stops the
--         next connection, not the one already inside.
SELECT COUNT(pg_terminate_backend(pid)) AS sessions_closed
FROM pg_stat_activity
WHERE usename = 'clinic_gyazzie';
-- Output:
--  sessions_closed
-- -----------------
--                0

-- Step 3: Prove all three facts in one row. The login is shut, the grants
--         that say what the account could read are still there, and no
--         session survives.
SELECT r.rolcanlogin AS can_still_log_in,
       (SELECT COUNT(*) FROM information_schema.role_table_grants
        WHERE grantee = 'clinic_gyazzie') AS surviving_grants,
       (SELECT COUNT(*) FROM pg_stat_activity
        WHERE usename = 'clinic_gyazzie') AS live_sessions
FROM pg_roles r
WHERE r.rolname = 'clinic_gyazzie';
-- Output:
--  can_still_log_in | surviving_grants | live_sessions
-- ------------------+------------------+---------------
--  f                |                3 |             0

-- What DROP ROLE would have cost, and why PostgreSQL argues the point:
--   DROP ROLE clinic_gyazzie;
--   ERROR:  role "clinic_gyazzie" cannot be dropped because some objects
--           depend on it
--   DETAIL:  privileges for table providers
-- Forcing the drop through means revoking every privilege first, and that
-- revoke destroys the record of what the account could reach.

-- Reversing the containment once the account is cleared:
--   ALTER ROLE clinic_gyazzie LOGIN PASSWORD '<a new value, not the old one>';
