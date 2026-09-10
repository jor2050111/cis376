-- Reference solution for Chapter 6, Try It Yourself 6.3
-- (Encrypt the Clinic's Insurance Numbers). Never shipped in the
-- chapter. Run as postgres from the extracted cis376 folder after
-- setup-sandwash.sql. Output lines were captured by running this
-- file through tools/run_chapter_sql.py as a scratch chapter on
-- 2026-09-09 (PostgreSQL 17.11, pgcrypto 1.3).
--
-- The three gaps in the chapter's text fence resolve to:
--   gap 1: pgp_sym_encrypt   (plaintext to ciphertext with the column key)
--   gap 2: hmac              (keyed lookup hash; digest() would be guessable)
--   gap 3: pgp_sym_decrypt   (ciphertext back to plaintext, one row)

\connect sandwash_clinic
CREATE EXTENSION IF NOT EXISTS pgcrypto;
-- Output:
-- CREATE EXTENSION

-- Step 1: Add a ciphertext column and a keyed lookup column beside the plaintext
ALTER TABLE patients
  ADD COLUMN insurance_member_id_enc bytea,
  ADD COLUMN insurance_member_id_lookup bytea;
-- Step 2: Encrypt every value with the column key, and fingerprint it with the lookup key
UPDATE patients
SET insurance_member_id_enc = pgp_sym_encrypt(insurance_member_id, 'Sandwash-Ch6-ColumnKey-2026!'),
    insurance_member_id_lookup = hmac(insurance_member_id, 'Sandwash-Ch6-LookupKey-2026!', 'sha256');
-- Step 3: Prove every ciphertext decrypts back to its plaintext before the plaintext goes
SELECT COUNT(*) AS patients,
       COUNT(*) FILTER (WHERE pgp_sym_decrypt(insurance_member_id_enc, 'Sandwash-Ch6-ColumnKey-2026!') = insurance_member_id) AS round_trips_ok
FROM patients;
-- Step 4: Drop the plaintext. Encryption with the plaintext still beside it protects nothing.
ALTER TABLE patients DROP COLUMN insurance_member_id;
CREATE INDEX patients_member_lookup_idx ON patients (insurance_member_id_lookup);
-- Step 5: Only billing may read the ciphertext. The key travels with the billing query, never with the table.
CREATE ROLE clinic_billing NOLOGIN;
GRANT SELECT (patient_id, first_name, last_name, insurance_member_id_enc, insurance_member_id_lookup)
  ON patients TO clinic_billing;
-- Step 6: Find one patient by member id through the lookup column, then decrypt that row only
SET ROLE clinic_billing;
SELECT patient_id, last_name,
       pgp_sym_decrypt(insurance_member_id_enc, 'Sandwash-Ch6-ColumnKey-2026!') AS insurance_member_id
FROM patients
WHERE insurance_member_id_lookup = hmac('CPR-407977684', 'Sandwash-Ch6-LookupKey-2026!', 'sha256');
RESET ROLE;
-- Output:
-- ALTER TABLE
-- UPDATE 600
--  patients | round_trips_ok
-- ----------+----------------
--       600 |            600
--
-- ALTER TABLE
-- CREATE INDEX
-- CREATE ROLE
-- GRANT
-- SET
--  patient_id | last_name | insurance_member_id
-- ------------+-----------+---------------------
--           1 | Dominguez | CPR-407977684
--
-- RESET

-- Cross-checks for the Explain prompt and the front-desk refusal.
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'patients'
  AND column_name LIKE 'insurance%'
ORDER BY ordinal_position;
SELECT has_column_privilege('clinic_billing', 'patients', 'insurance_member_id_enc', 'SELECT') AS billing_reads_ciphertext,
       has_column_privilege('clinic_billing', 'patients', 'phone', 'SELECT') AS billing_reads_phone;
-- Output:
--         column_name         | data_type
-- ----------------------------+-----------
--  insurance_member_id_enc    | bytea
--  insurance_member_id_lookup | bytea
--
--  billing_reads_ciphertext | billing_reads_phone
-- --------------------------+---------------------
--  t                        | f

CREATE ROLE clinic_frontdesk NOLOGIN;
GRANT SELECT (patient_id, first_name, last_name, phone) ON patients TO clinic_frontdesk;
SELECT has_column_privilege('clinic_frontdesk', 'patients', 'insurance_member_id_enc', 'SELECT') AS frontdesk_reads_ciphertext;
-- Output:
-- CREATE ROLE
-- GRANT
--  frontdesk_reads_ciphertext
-- ----------------------------
--  f

-- The front-desk refusal quoted in Section 6.2 (this block raises on purpose).
SET ROLE clinic_frontdesk;
SELECT patient_id,
       pgp_sym_decrypt(insurance_member_id_enc, 'Sandwash-Ch6-ColumnKey-2026!') AS insurance_member_id
FROM patients
WHERE patient_id = 1;
RESET ROLE;
-- Output:
-- SET
-- ERROR:  permission denied for table patients
-- RESET

-- Fix It 6.1: the passphrase without its final character (raises on purpose).
SET ROLE clinic_billing;
SELECT patient_id,
       pgp_sym_decrypt(insurance_member_id_enc, 'Sandwash-Ch6-ColumnKey-2026') AS insurance_member_id
FROM patients
WHERE patient_id = 1;
RESET ROLE;
-- Output:
-- SET
-- ERROR:  Wrong key or corrupt data
-- RESET

-- Fix It 6.1 repair: the correct passphrase, same query.
SET ROLE clinic_billing;
SELECT patient_id,
       pgp_sym_decrypt(insurance_member_id_enc, 'Sandwash-Ch6-ColumnKey-2026!') AS insurance_member_id
FROM patients
WHERE patient_id = 1;
RESET ROLE;
-- Output:
-- SET
--  patient_id | insurance_member_id
-- ------------+---------------------
--           1 | CPR-407977684
--
-- RESET

-- Section 6.4: the two plans quoted in the chapter.
EXPLAIN (COSTS OFF)
SELECT patient_id
FROM patients
WHERE pgp_sym_decrypt(insurance_member_id_enc, 'Sandwash-Ch6-ColumnKey-2026!') = 'CPR-407977684';
EXPLAIN (COSTS OFF)
SELECT patient_id
FROM patients
WHERE insurance_member_id_lookup = hmac('CPR-407977684', 'Sandwash-Ch6-LookupKey-2026!', 'sha256');
-- Output:
--                                                      QUERY PLAN
-- --------------------------------------------------------------------------------------------------------------------
--  Seq Scan on patients
--    Filter: (pgp_sym_decrypt(insurance_member_id_enc, 'Sandwash-Ch6-ColumnKey-2026!'::text) = 'CPR-407977684'::text)
--
--                                                            QUERY PLAN
-- --------------------------------------------------------------------------------------------------------------------------------
--  Bitmap Heap Scan on patients
--    Recheck Cond: (insurance_member_id_lookup = '\xd5daf0afa601bd47bf3a34a9b64994e0dcf02f84a6f5dfcde4dc1a3862cbd5a4'::bytea)
--    ->  Bitmap Index Scan on patients_member_lookup_idx
--          Index Cond: (insurance_member_id_lookup = '\xd5daf0afa601bd47bf3a34a9b64994e0dcf02f84a6f5dfcde4dc1a3862cbd5a4'::bytea)
