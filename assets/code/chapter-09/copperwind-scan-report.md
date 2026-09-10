# Copperwind Data Services: Configuration Scan Report

**Host:** clinic-db-01 (hosts `sandwash_clinic`)
**Engine:** PostgreSQL 17
**Benchmark:** CIS PostgreSQL Benchmark, profile Level 1 (adapted)
**Scanned by:** Copperwind Data Services, automated scanner
**Reviewed by:** (pending)
**Note:** Copperwind IT Services and Sandwash Family Clinic are
fictional. This report and its host are synthetic and describe no real
system.

## Summary

The scan checked the clinic database host against the benchmark and
returned five failed controls. Each is listed below with the rule it
failed and the observed state. Likelihood and impact are left for the
reviewer to assign, because both depend on how the clinic uses the
server. Rank the findings in Skills Lab 9A and match each to a control.

## Findings

| ID | Benchmark area | Finding | Observed state |
| -- | -------------- | ------- | -------------- |
| SC-01 | Patching | Server is behind on minor releases | Running 17.9; 17.11 is current |
| SC-02 | Access control | An application role can read every table | `clinic_app` holds SELECT on all tables in `public` |
| SC-03 | Encryption in motion | TLS is not required for connections | `ssl = off`; remote clients may connect in the clear |
| SC-04 | Backup protection | Backups sit on an unencrypted shared folder | Nightly dumps written to a share readable by all staff |
| SC-05 | Logging | Connections are not logged | `log_connections = off`; no record of who connected |

## How to use this report

1. Assign each finding a likelihood (1-5) and an impact (1-5) for the
   clinic, and multiply them for a risk score.
2. Order the findings by score and band them (Critical, High, Medium,
   Low).
3. Match each finding to a control and the chapter that teaches it, and
   name the owner of the fix.
4. File the ranked report with the recovery plan so the next scan can
   measure progress.
