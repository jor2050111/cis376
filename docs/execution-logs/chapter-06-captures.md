# Chapter 6 hand captures

Chapter 6 quotes several outputs that the harness cannot produce on
the shared course cluster, because they depend on TLS being enabled
(the cluster must stay `ssl = off`), on a connection attempt that
fails (a failed `\connect` stops a psql script), or on timings that
change from run to run. Every one was captured for real on
2026-09-09 (PostgreSQL 17.11, OpenSSL 3.6.1) and pasted verbatim.

## Test cluster with TLS on (Section 6.3)

A throwaway cluster was created in the session scratchpad with
`initdb -U postgres --auth=trust`, port 5499, `listen_addresses =
'localhost'`, the certificate from `make-server-cert.sh` copied into
its data directory, `ssl = on`, and this `pg_hba.conf`:

```text
local     all   all                                    trust
hostssl   all   postgres             127.0.0.1/32      trust
hostssl   all   clinic_billing_app   127.0.0.1/32      scram-sha-256
hostnossl all   all                  0.0.0.0/0         reject
```

The cluster was stopped and deleted after the captures. The shared
cluster's `postgresql.conf` and `pg_hba.conf` were never touched.

Captured as `postgres` over TCP:

```text
 ssl
-----
 on

 ssl | version |         cipher         | bits
-----+---------+------------------------+------
 t   | TLSv1.3 | TLS_AES_256_GCM_SHA384 |  256
```

Captured as `clinic_billing_app` with `sslmode=disable` (the chapter
replaces port 5499 with 5432 and `postgres` with `sandwash_clinic` in
the quoted line, so it reads as the student's own server would print
it):

```text
psql: error: connection to server at "localhost" (127.0.0.1), port 5499 failed: FATAL:  pg_hba.conf rejects connection for host "127.0.0.1", user "clinic_billing_app", database "postgres", no encryption
```

Captured with `sslmode=verify-full sslrootcert=server.crt` (same
port substitution):

```text
psql: error: connection to server at "localhost" (127.0.0.1), port 5499 failed: server certificate for "copperwind-lab" does not match host name "localhost"
```

`pg_hba_file_rules` on the test cluster listed the four rules with
types `local`, `hostssl`, `hostssl`, `hostnossl` and no error column.

## Shared cluster, read-only probes (Section 6.3)

`sslmode=require` against the course cluster (ssl off), captured with
plain psql, no lock needed because it changes nothing:

```text
psql: error: connection to server at "localhost" (127.0.0.1), port 5432 failed: server does not support SSL, but SSL was required
```

`sslmode=prefer` against the same cluster connected and reported
`ssl = f` from `pg_stat_ssl`, which is the silent fallback the
chapter warns about.

## Timings (Section 6.4)

Captured through the harness with `\timing on` in a scratch chapter
(the harness prints psql's `Time:` lines). The chapter quotes them in
`text` fences because they change on every run:

```text
cost 4    Time: 0.759 ms
cost 8    Time: 10.405 ms
cost 10   Time: 41.200 ms
cost 12   Time: 164.537 ms
1,201 encrypt-then-decrypt round trips on guardians.email: Time: 447.164 ms
```

A full `UPDATE portal_accounts SET password_hash = crypt(..., gen_salt('bf', 10))`
over 1,201 rows took 50,244 ms in the first scratch run, which is the
"about a minute" the chapter's warning states.

## Errors quoted in Section 6.2

Both raised inside the harness against the reference solution's end
state (see `chapter-06-reference.sql`):

```text
ERROR:  permission denied for table patients
ERROR:  Wrong key or corrupt data
```
