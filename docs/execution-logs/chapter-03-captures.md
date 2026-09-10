# Chapter 3 hand captures

The harness (`tools/run_chapter_sql.py`) marks a block FAIL when a
statement raises, so the two blocks in Chapter 3 that must raise live
in `text` fences. Both error lines were captured by running the
statement in a scratch chapter through the harness against the
chapter-03 setup scripts on 2026-09-09 (PostgreSQL 17.11) and pasting
the `ERROR:` and `DETAIL:` lines verbatim.

## Try It Yourself 3.2 transcript

Scratch block, run after `appointments_status_check` existed:

```text
BEGIN;
UPDATE appointments SET status = 'Complete' WHERE appointment_id = 2;
ROLLBACK;
```

Harness log lines:

```text
ERROR:  new row for relation "appointments" violates check constraint "appointments_status_check"
DETAIL:  Failing row contains (2, 122, 4, 2021-01-20 17:00:00, Complete, Follow-up).
```

The psql prompts in the chapter transcript (`=#`, `=*#`, `-*#`, `=!#`)
are psql 17's defaults for outside a transaction, inside one, a
continuation line inside one, and inside a failed one. They were
added by hand around the captured lines.

## Fix It 3.1 error

Scratch block, run against the freshly built `sandwash_clinic` (600
patients, so `patient_id` 601 does not exist):

```text
INSERT INTO appointments (appointment_id, patient_id, provider_id, scheduled_at, status, visit_type)
VALUES (6001, 601, 3, '2026-06-02 09:00:00', 'Scheduled', 'Follow-up');
```

Harness log lines:

```text
ERROR:  insert or update on table "appointments" violates foreign key constraint "appointments_patient_id_fkey"
DETAIL:  Key (patient_id)=(601) is not present in table "patients".
```
