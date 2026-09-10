-- Skills Lab 12A: Capstone: The Management and Security Plan
-- Name:
-- Organization chosen (Copperwind, Sandwash, or Harquahala):
--
-- Run the setup script for the organization you chose, from the
-- extracted cis376 folder. Only one of these is required:
--     psql -U postgres -d postgres -f assets/code/chapter-12/setup-copperwind.sql
--     psql -U postgres -d postgres -f assets/code/chapter-12/setup-sandwash.sql
--     psql -U postgres -d postgres -f assets/code/chapter-12/setup-harquahala.sql
--
-- Then work through the markers below in psql. Paste each result under
-- its query as -- Output: comment lines, or save the psql output file.
-- The written sections go in skills-lab-12a-answers.md, built from
-- management-security-plan-template.md.

\echo === Part 1: Foundation ===

-- 1.1 Architecture evidence: database name, server version, total size,
--     and the number of tables in scope (fills template section 2)


-- 1.2 Every table in your database with its row count


-- 1.3 Whether PUBLIC can read any table (every row must read f)


-- 1.4 Create one role your plan names, with the organization prefix,
--     grant it the minimum it needs, then read the grants back


\echo === Part 2: Application ===

-- 2.1 The plan of the one report that must stay fast, with
--     EXPLAIN (COSTS OFF) (fills template section 5)


-- 2.2 Recovery acceptance check: one row per table with its expected
--     count, so a restore can be ruled pass or fail (template section 6)


-- 2.3 One query that measures the problem your chosen technology
--     claims to solve, so step 1 of the method rests on your own data


\echo === Part 3: Extension ===

-- 3.1 Score your chosen technology against doing nothing, with the
--     weights your organization would choose
