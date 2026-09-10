-- Reference solution for Chapter 7, Try It Yourself 7.3
-- (Complete the Visit Notes Trail). Never shipped in the chapter.
-- Run as postgres from the extracted cis376 folder after
-- setup-sandwash.sql. Output lines were captured by running this
-- file through tools/run_chapter_sql.py as a scratch chapter on
-- 2026-09-09 (PostgreSQL 17.11).
--
-- The three gaps in the chapter's text fence resolve to:
--   gap 1: TG_OP      (the trigger variable naming INSERT, UPDATE, or DELETE)
--   gap 2: RETURN     (every trigger function must end by returning a row)
--   gap 3: AFTER      (record only changes that passed every constraint)

-- The Section 7.3 blocks the student runs before the TIY.
\connect sandwash_clinic
CREATE TABLE audit_log (
  audit_id   bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  changed_at timestamptz NOT NULL DEFAULT clock_timestamp(),
  changed_by text NOT NULL,
  table_name text NOT NULL,
  operation  text NOT NULL,
  old_row    jsonb,
  new_row    jsonb
);
CREATE FUNCTION clinic_audit_change() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO audit_log (changed_by, table_name, operation, old_row, new_row)
  VALUES (current_user, TG_TABLE_NAME, TG_OP, to_jsonb(OLD), to_jsonb(NEW));
  RETURN NEW;
END;
$$;
CREATE TRIGGER appointments_audit
  AFTER INSERT OR UPDATE OR DELETE ON appointments
  FOR EACH ROW EXECUTE FUNCTION clinic_audit_change();
CREATE ROLE clinic_scheduler_app LOGIN
  PASSWORD 'Sandwash-Ch7-Scheduler-2026!';
GRANT SELECT, UPDATE ON appointments TO clinic_scheduler_app;
GRANT INSERT ON audit_log TO clinic_scheduler_app;
SET ROLE clinic_scheduler_app;
UPDATE appointments
SET status = 'Cancelled'
WHERE appointment_id = 1;
RESET ROLE;
-- Output:
-- CREATE TABLE
-- CREATE FUNCTION
-- CREATE TRIGGER
-- CREATE ROLE
-- GRANT
-- GRANT
-- SET
-- UPDATE 1
-- RESET

-- The TIY script with the gaps filled.
CREATE FUNCTION visit_notes_audit_change() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO audit_log (changed_by, table_name, operation, old_row, new_row)
  VALUES (current_user, TG_TABLE_NAME, TG_OP,
          jsonb_build_object('note_id', OLD.note_id, 'diagnosis_code', OLD.diagnosis_code),
          jsonb_build_object('note_id', NEW.note_id, 'diagnosis_code', NEW.diagnosis_code));
  RETURN NEW;
END;
$$;
CREATE TRIGGER visit_notes_audit
  AFTER UPDATE ON visit_notes
  FOR EACH ROW EXECUTE FUNCTION visit_notes_audit_change();
GRANT SELECT, UPDATE ON visit_notes TO clinic_scheduler_app;
SET ROLE clinic_scheduler_app;
UPDATE visit_notes
SET diagnosis_code = 'Z00.00'
WHERE note_id = 1;
RESET ROLE;
SELECT audit_id, changed_by, table_name, operation, old_row, new_row
FROM audit_log
WHERE table_name = 'visit_notes';
-- Output:
-- CREATE FUNCTION
-- CREATE TRIGGER
-- GRANT
-- SET
-- UPDATE 1
-- RESET
--  audit_id |      changed_by      | table_name  | operation |                 old_row                 |                  new_row
-- ----------+----------------------+-------------+-----------+-----------------------------------------+--------------------------------------------
--         2 | clinic_scheduler_app | visit_notes | UPDATE    | {"note_id": 1, "diagnosis_code": "I10"} | {"note_id": 1, "diagnosis_code": "Z00.00"}

-- Cross-check for the Predict prompt: two rows in the trail, both by the application.
SELECT COUNT(*) AS trail_rows,
       COUNT(*) FILTER (WHERE changed_by = 'clinic_scheduler_app') AS by_application
FROM audit_log;
-- Output:
--  trail_rows | by_application
-- ------------+----------------
--           2 |              2
