-- Skills Lab 7A: An Audit Trail for Copperwind Tickets
-- Name:
-- Run from the extracted cis376 folder, connected to copperwind_ops:
--     psql -U postgres -d copperwind_ops -f skills-lab-7a.sql
-- Paste each result under its query as -- Output: comment lines, or
-- save the psql output beside this file.

\echo === Part 1: Foundation ===

-- 1.1 Logging settings on your server, with context (pg_settings)


-- 1.2 login_events by success and username, then by hour of day


\echo === Part 2: Application ===

-- 2.1 pg_reload_conf() and the pending_restart query after your postgresql.conf edit
--     (paste the new-session SHOW transcript in the answer file)


-- 2.2 log_statement = 'all' on copperwind_reports, proved with pg_db_role_setting


-- 2.3 tickets_audit, copperwind_audit_change(), the trigger, and copperwind_ticket_app


-- 2.4 Three changes as copperwind_ticket_app, then the trail read back


-- 2.5 has_table_privilege() for all four privileges, and the refused DELETE


\echo === Part 3: Extension ===

-- 3.1 Load postgresql-2026-08-14.log, parse it into server_log, confirm every line parsed


-- 3.2 The classification query with Mei Lin's rules


-- 3.3 The exact violation line, the burst per minute, and the login_events correlation

