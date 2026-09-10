-- Skills Lab 6A: Encrypt Harquahala Guardian Contacts
-- Name:
-- Run from the extracted cis376 folder, connected to harquahala_academy:
--     psql -U postgres -d harquahala_academy -f skills-lab-6a.sql
-- Paste each result under its query as -- Output: comment lines, or
-- save the psql output beside this file. Never paste a key or a
-- passphrase into this file. Replace every teaching passphrase with
-- your own and keep it in your password manager.

\echo === Part 1: Foundation ===

-- 1.1 Enable pgcrypto, prove it from pg_extension, count the plain: placeholders


-- 1.2 Replace every password_hash with a bcrypt hash at cost 10, then recount


-- 1.3 Three accounts checked against a right password and a wrong one


\echo === Part 2: Application ===

-- 2.1 The six-step pattern on guardians.phone and guardians.email (round trips before the drop)


-- 2.2 academy_registrar and academy_teacher, column grants, has_column_privilege() on phone_enc


-- 2.3 Lookup by phone as the registrar, then the same query as the teacher


\echo === Part 3: Extension ===

-- 3.1 The four-check TLS verification sequence as academy_portal_app with sslmode=require


-- 3.2 The sslmode=verify-full attempt

