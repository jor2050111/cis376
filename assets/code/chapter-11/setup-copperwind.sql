-- CHAPTER-SPECIFIC: do not regenerate
-- Sets up copperwind_ops, Copperwind IT Services' operations database,
-- in the state Chapter 11 starts from: the base tables plus the two
-- login roles Copperwind's Data Services team created for the ticket
-- application and the monthly reports. One of those roles holds more
-- than the signed access list allows, and Section 11.2 finds it.
-- Run from the extracted cis376 folder:
--     psql -U postgres -d postgres -f assets/code/chapter-11/setup-copperwind.sql
-- The script is idempotent: it drops and recreates every table it owns
-- and every role whose name starts with copperwind_.

SELECT 'CREATE DATABASE copperwind_ops'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'copperwind_ops') \gexec
\connect copperwind_ops

-- Roles are cluster-wide, so a rerun must remove the chapter's roles
-- before it recreates them. DROP OWNED BY revokes every privilege and
-- default privilege a role holds in this database, which is what
-- otherwise blocks DROP ROLE.
DO $$
DECLARE
  copperwind_role text;
BEGIN
  FOR copperwind_role IN
    SELECT rolname FROM pg_roles WHERE rolname LIKE 'copperwind\_%'
  LOOP
    EXECUTE format('DROP OWNED BY %I', copperwind_role);
    EXECUTE format('DROP ROLE %I', copperwind_role);
  END LOOP;
END
$$;

DROP SCHEMA IF EXISTS review CASCADE;
DROP TABLE IF EXISTS login_events, ticket_notes, tickets, technicians, clients CASCADE;

CREATE TABLE clients (
  client_id      integer PRIMARY KEY,
  client_name    text NOT NULL,
  sector         text NOT NULL,
  city           text NOT NULL,
  contract_start date NOT NULL
);

CREATE TABLE technicians (
  technician_id integer PRIMARY KEY,
  full_name     text NOT NULL,
  team          text NOT NULL,
  hire_date     date NOT NULL
);

CREATE TABLE tickets (
  ticket_id     integer PRIMARY KEY,
  client_id     integer NOT NULL REFERENCES clients (client_id),
  technician_id integer NOT NULL REFERENCES technicians (technician_id),
  category      text NOT NULL,
  priority      text NOT NULL,
  opened_at     timestamp NOT NULL,
  closed_at     timestamp,
  status        text NOT NULL,
  summary       text NOT NULL
);

CREATE TABLE ticket_notes (
  note_id   integer PRIMARY KEY,
  ticket_id integer NOT NULL REFERENCES tickets (ticket_id),
  author_id integer NOT NULL REFERENCES technicians (technician_id),
  noted_at  timestamp NOT NULL,
  note_text text NOT NULL
);

CREATE TABLE login_events (
  event_id   integer PRIMARY KEY,
  username   text NOT NULL,
  event_time timestamp NOT NULL,
  source_ip  inet NOT NULL,
  success    boolean NOT NULL
);

\copy clients      FROM 'assets/code/data/copperwind/clients.csv'      WITH (FORMAT csv, HEADER true)
\copy technicians  FROM 'assets/code/data/copperwind/technicians.csv'  WITH (FORMAT csv, HEADER true)
\copy tickets      FROM 'assets/code/data/copperwind/tickets.csv'      WITH (FORMAT csv, HEADER true, NULL '')
\copy ticket_notes FROM 'assets/code/data/copperwind/ticket_notes.csv' WITH (FORMAT csv, HEADER true)
\copy login_events FROM 'assets/code/data/copperwind/login_events.csv' WITH (FORMAT csv, HEADER true)

-- The two service roles Copperwind runs against this database. The
-- ticket application holds exactly what the signed access list says.
-- The reporting role holds a blanket grant somebody applied in a hurry,
-- which is the drift Section 11.2 audits and Section 11.4 closes.
CREATE ROLE copperwind_app LOGIN PASSWORD 'Copperwind-Ch11-App-2026!';
CREATE ROLE copperwind_reports LOGIN PASSWORD 'Copperwind-Ch11-Reports-2026!';

GRANT USAGE ON SCHEMA public TO copperwind_app, copperwind_reports;
GRANT SELECT, INSERT ON tickets, ticket_notes TO copperwind_app;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO copperwind_reports;

ANALYZE;
