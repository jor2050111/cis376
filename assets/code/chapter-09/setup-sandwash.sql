-- Sets up sandwash_clinic, the Sandwash Family Clinic database (HIPAA).
-- Run from the extracted cis376 folder:
--     psql -U postgres -d postgres -f assets/code/chapter-09/setup-sandwash.sql
-- The script is idempotent: it drops and recreates every table it owns.

SELECT 'CREATE DATABASE sandwash_clinic'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'sandwash_clinic') \gexec
\connect sandwash_clinic

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
