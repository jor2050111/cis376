-- Reference solution for Chapter 9, Try It Yourself 9.2
-- (Recover Copperwind and Prove the Drill). Never shipped in the chapter.
-- Chapter 9 is fading level C (problem-first): the spine states the goal,
-- the inputs, and the acceptance check, and the student writes the whole
-- solution. This file is that solution.
--
-- Run as postgres from the extracted cis376 folder. Output lines were
-- captured by running this file's blocks through tools/run_chapter_sql.py
-- as a scratch chapter on 2026-09-09 (PostgreSQL 17.11).
--
-- The task: Copperwind's recovery plan sets these post-restore counts as
-- the acceptance check. A dump (copperwind_ops-backup.sql) arrived. Restore
-- it into a drill database the setup scripts do not own, then prove the
-- restored counts match the plan and rule the drill pass or fail.

-- Step 1: An empty target, so no old rows can hide a bad restore
\connect copperwind_ops
DROP DATABASE IF EXISTS copperwind_restore_drill;
CREATE DATABASE copperwind_restore_drill;

-- Step 2: Replay the dump into the empty target (from a shell this is
--         psql -U postgres -d copperwind_restore_drill -f
--         assets/code/chapter-09/copperwind_ops-backup.sql)
\connect copperwind_restore_drill
\i assets/code/chapter-09/copperwind_ops-backup.sql

-- Step 3: Compare the restored counts against the plan in one query and
--         flag any table that does not match
WITH plan (table_name, expected_rows) AS (
  VALUES ('clients', 40), ('technicians', 8), ('tickets', 18240),
         ('ticket_notes', 28326), ('login_events', 12000)
),
restored (table_name, restored_rows) AS (
  SELECT 'clients', COUNT(*) FROM clients
  UNION ALL SELECT 'technicians', COUNT(*) FROM technicians
  UNION ALL SELECT 'tickets', COUNT(*) FROM tickets
  UNION ALL SELECT 'ticket_notes', COUNT(*) FROM ticket_notes
  UNION ALL SELECT 'login_events', COUNT(*) FROM login_events
)
SELECT p.table_name,
       p.expected_rows,
       r.restored_rows,
       CASE WHEN p.expected_rows = r.restored_rows
            THEN 'match' ELSE 'MISMATCH' END AS verdict
FROM plan AS p
JOIN restored AS r ON r.table_name = p.table_name
ORDER BY p.table_name;
-- Output:
--   table_name  | expected_rows | restored_rows | verdict
-- --------------+---------------+---------------+---------
--  clients      |            40 |            40 | match
--  login_events |         12000 |         12000 | match
--  technicians  |             8 |             8 | match
--  ticket_notes |         28326 |         28326 | match
--  tickets      |         18240 |         18240 | match
--
-- Ruling: every table matches the plan, so the restore drill PASSES the
-- count acceptance check. The student still records the wall-clock restore
-- time and compares it against the plan's recovery time objective, and
-- confirms the dump's own timestamp against the recovery point objective.

-- Step 4: Leave nothing behind. The drill database is disposable.
\connect copperwind_ops
DROP DATABASE IF EXISTS copperwind_restore_drill;
