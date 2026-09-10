# Records Retention and Disposal Policy: Sandwash Family Clinic

This template is fictional and exists for Skills Lab 4A. Fill every
field. Where a field asks for an authority, cite the regulation
section or the clinic policy that sets the rule.

**Policy number:** RM-4
**Policy owner (data owner):**
**Administered by (database administrator):**
**Approved by (security review):**
**Effective date:**
**Review cycle:**

## 1. Purpose

State in two or three sentences why the clinic keeps records for a
defined period and destroys them at the end of it. Name the two risks
the policy balances.

## 2. Scope

Name the database, the schemas, and the record series this policy
covers. State what it does not cover (paper records, email, the
practice management vendor's copies).

## 3. Definitions

Define, in your own words: record series, trigger event, retention
period, disposition, legal hold, secure deletion, disposal log.

## 4. Retention Schedule

One row per record series. Add rows as needed.

| Series | Records (tables and columns) | Trigger event | Retention period | Disposition | Authority |
| ------ | ---------------------------- | ------------- | ---------------- | ----------- | --------- |
| VN-01 | | | | | |
| AP-01 | | | | | |
| SEC-01 | | | | | |
| LH-01 | | | | | |
| | | | | | |

## 5. Legal Holds

* Who may place a hold:
* Where a hold is recorded (table name and columns):
* How the disposal run detects an active hold:
* Who may release a hold, and how the release is recorded:

## 6. Disposal Procedure

* Schedule (how often the run happens and on what date):
* Approval required before the run (who, and what count they approve):
* The statement pattern (transaction, delete with hold exclusion, log
  insert from the returned count):
* Post-run verification (the query that proves only held rows remain):
* Space reclamation (VACUUM, and who confirms it ran):

## 7. Copies Outside the Table

For each location, state how long destroyed rows may persist there
and what removes them.

| Location | Persists until | Removed by |
| -------- | -------------- | ---------- |
| Dead tuples in the table | | |
| Write-ahead log | | |
| Logical backups | | |
| Physical backups and archived WAL | | |
| Replicas | | |
| Exports and reports | | |

## 8. Documentation and Retention of This Policy

State how long the disposal log, hold records, and this policy are
kept, and cite the HIPAA documentation retention requirement.

## 9. Roles and Responsibilities

| Role | Responsibility |
| ---- | -------------- |
| Data owner | |
| Office manager | |
| Database administrator | |
| Security lead | |
