# Redundancy Plan Template

One row per database. The RPO and RTO are business decisions the data
owner signs, not technical defaults. Fill every cell, and never leave
the sign-off column blank.

* **RPO (recovery point objective):** the most recent data you can
  afford to lose, in time.
* **RTO (recovery time objective):** the longest you can be down.
* **Backup method:** how a restorable copy is made (for example,
  nightly `pg_dump`, `pg_dump` plus WAL archive for point-in-time
  recovery).
* **Replication:** none, a warm standby, or an automatic-failover pair.
* **Owner sign-off:** the named person who accepts the RPO and RTO.

| Database | RPO | RTO | Backup method | Replication | Owner sign-off |
| -------- | --- | --- | ------------- | ----------- | -------------- |
| | | | | | |
| | | | | | |
| | | | | | |

## Notes

* State the security controls each copy inherits: encryption of the
  backup file, the access control on where it is stored, and the
  retention rule that says when it is destroyed.
* A backup you have never restored is a guess. Record the date of the
  last successful restore drill beside each database.
