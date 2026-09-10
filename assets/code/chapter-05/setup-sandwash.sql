-- CHAPTER-SPECIFIC: do not regenerate
-- Sets up sandwash_clinic, the Sandwash Family Clinic database (HIPAA),
-- in the state Chapter 5 starts from: the base tables plus the login
-- roles the clinic's previous host left behind. Skills Lab 5A reviews
-- those roles.
-- Run from the extracted cis376 folder:
--     psql -U postgres -d postgres -f assets/code/chapter-05/setup-sandwash.sql
-- The script is idempotent: it drops and recreates every table it owns
-- and every role whose name starts with clinic_.

SELECT 'CREATE DATABASE sandwash_clinic'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'sandwash_clinic') \gexec
\connect sandwash_clinic

-- Roles are cluster-wide, so a rerun must remove the chapter's roles
-- before it recreates them. DROP OWNED BY revokes every privilege and
-- default privilege a role holds in this database, which is what
-- otherwise blocks DROP ROLE.
DO $$
DECLARE
  clinic_role text;
BEGIN
  FOR clinic_role IN
    SELECT rolname FROM pg_roles WHERE rolname LIKE 'clinic\_%'
  LOOP
    EXECUTE format('DROP OWNED BY %I', clinic_role);
    EXECUTE format('DROP ROLE %I', clinic_role);
  END LOOP;
END
$$;

DROP TABLE IF EXISTS staff_accounts, visit_notes, appointments, patients, providers CASCADE;

CREATE TABLE providers (
  provider_id integer PRIMARY KEY,
  full_name   text NOT NULL,
  specialty   text NOT NULL,
  npi         char(10) NOT NULL UNIQUE
);

CREATE TABLE patients (
  patient_id          integer PRIMARY KEY,
  first_name          text NOT NULL,
  last_name           text NOT NULL,
  date_of_birth       date NOT NULL,
  phone               text,
  email               text,
  address             text,
  insurance_member_id text
);

CREATE TABLE appointments (
  appointment_id integer PRIMARY KEY,
  patient_id     integer NOT NULL REFERENCES patients (patient_id),
  provider_id    integer NOT NULL REFERENCES providers (provider_id),
  scheduled_at   timestamp NOT NULL,
  status         text NOT NULL,
  visit_type     text NOT NULL
);

CREATE TABLE visit_notes (
  note_id        integer PRIMARY KEY,
  appointment_id integer NOT NULL REFERENCES appointments (appointment_id),
  diagnosis_code text NOT NULL,
  note_text      text NOT NULL
);

CREATE TABLE staff_accounts (
  account_id  integer PRIMARY KEY,
  username    text NOT NULL UNIQUE,
  role_name   text NOT NULL,
  provider_id integer REFERENCES providers (provider_id)
);

\copy providers      FROM 'assets/code/data/sandwash/providers.csv'      WITH (FORMAT csv, HEADER true)
\copy patients       FROM 'assets/code/data/sandwash/patients.csv'       WITH (FORMAT csv, HEADER true)
\copy appointments   FROM 'assets/code/data/sandwash/appointments.csv'   WITH (FORMAT csv, HEADER true)
\copy visit_notes    FROM 'assets/code/data/sandwash/visit_notes.csv'    WITH (FORMAT csv, HEADER true)
\copy staff_accounts FROM 'assets/code/data/sandwash/staff_accounts.csv' WITH (FORMAT csv, HEADER true, NULL '')

ANALYZE;

-- Accounts inherited from the clinic's previous host. Copperwind took
-- over the database with these already in place. Chapter 5's Skills
-- Lab reviews them against the clinic's access control matrix.
CREATE ROLE clinic_backup_svc LOGIN
  PASSWORD 'Sandwash-Vendor-Backup-2024!'
  CONNECTION LIMIT 1;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO clinic_backup_svc;

CREATE ROLE clinic_reports_svc LOGIN
  PASSWORD 'Sandwash-Vendor-Reports-2024!';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO clinic_reports_svc;
GRANT INSERT, UPDATE, DELETE ON visit_notes TO clinic_reports_svc;
