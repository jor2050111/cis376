# Glossary additions: Chapter 7

Terms bolded on first use in `book/chapters/chapter-07.md`, in the
definition-list format, alphabetical. `JSONB`, `retention schedule`,
`separation of duties`, and `superuser` are already in
`book/glossary.md` and are not repeated here.

append-only
:   A table that every role except its owner may add rows to and never change or remove rows from. An audit trail is append-only so that the role that changed the data cannot change the record of the change.

audit controls
:   The HIPAA technical safeguard (45 CFR 164.312(b)) that requires mechanisms to record and examine activity in systems that hold electronic protected health information. Server logging and trigger-based audit trails are how a database team implements it.

audit event
:   One action on the database that the auditing plan says to record, such as a login, a failed login, a DDL statement, a change to a protected row, or a role change.

audit trail
:   A table inside the database that a trigger fills with the before-and-after of each protected change, the role that made it, and the time. It records which rows changed, which the server log cannot.

auditing plan
:   The written decision about which database events matter, where each one is recorded, who reviews the record, and how long it is kept. The data owner rules on what matters and the administrator decides how to capture it.

configuration parameter
:   A named server setting, such as `log_statement`, read from `postgresql.conf` and shown with its current value and change rules in the `pg_settings` view.

configuration reload
:   Telling a running PostgreSQL server to reread `postgresql.conf` and `pg_hba.conf` without stopping, requested with `pg_reload_conf()`. Settings whose context is `postmaster` still need a restart, and `pg_settings.pending_restart` says which.

data security review
:   The written record of a log reading: the scope, the method, the findings with counts and times, the actions taken, and the residual risk, signed so the next review can compare against it.

event classification
:   The reading step of auditing, in which every logged event receives one of three labels, routine, suspicious, or violation, according to the rules in the auditing plan rather than the text of the line.

log line prefix
:   The `log_line_prefix` format that stamps the front of every server log line. Escapes such as `%m` (time), `%p` (process), `%u` (role), `%d` (database), and `%h` (client address) decide whether a line can name who did what and from where.

log rotation
:   The server's switch to a new log file after `log_rotation_age` minutes or `log_rotation_size` kilobytes. Rotation never deletes old files, so retention is a scheduled job unless a cyclic filename with `log_truncate_on_rotation` is used.

logging collector
:   The background process, enabled with `logging_collector = on`, that captures the server's output and writes it to files in `log_directory`. Its context is `postmaster`, so turning it on needs a restart.

routine
:   The event classification for an event the auditing plan expects, such as a known account connecting during business hours.

server log
:   The text file PostgreSQL writes as it runs. With the right settings it holds every connection, every failed connection, and whichever statements `log_statement` says to keep.

suspicious
:   The event classification for an event the auditing plan did not expect and cannot yet explain, such as a burst of failed logins before dawn. A person must explain it before it becomes routine.

trigger
:   A rule attached to a table that runs a function when rows are inserted, updated, or deleted, either before or after the change and once per row or once per statement.

trigger function
:   A function that returns the type `trigger` and runs when its trigger fires. In PL/pgSQL it sees `OLD`, `NEW`, `TG_OP`, and `TG_TABLE_NAME`, and it must end by returning a row or the server raises an error when the trigger fires.

violation
:   The event classification for an event that breaks a written rule in the auditing plan, whoever did it and whatever the reason, such as a role change made by an account the plan does not authorize.
