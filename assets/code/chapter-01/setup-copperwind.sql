-- Sets up copperwind_ops, Copperwind IT Services' operations database.
-- Run from the extracted cis376 folder:
--     psql -U postgres -d postgres -f assets/code/chapter-01/setup-copperwind.sql
-- The script is idempotent: it drops and recreates every table it owns.

SELECT 'CREATE DATABASE copperwind_ops'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'copperwind_ops') \gexec
\connect copperwind_ops

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

ANALYZE;
