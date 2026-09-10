-- Skills Lab 5A: Roles for the Clinic
-- Name:
-- Run from the extracted cis376 folder, connected to sandwash_clinic:
--     psql -U postgres -d sandwash_clinic -f skills-lab-5a.sql
-- Paste each result under its query as -- Output: comment lines, or
-- save the psql output beside this file.

\echo === Part 1: Foundation ===

-- 1.1 Every login role on the server, with connection limit and expiry


-- 1.2 Four group roles, three login roles, and the membership query


\echo === Part 2: Application ===

-- 2.1 Grants for every cell of the matrix, each proved with has_*_privilege()


-- 2.2 Row-level security on appointments, patients, visit_notes, and pg_policies


-- 2.3 Row counts as clinic_evasquez, then as postgres for provider_id = 1


\echo === Part 3: Extension ===

-- 3.1 The access review: logins, memberships, effective privileges, columns, policies


-- 3.2 Remediation of the inherited over-grant, and the review query rerun

