# Chapter 6: Encryption at Rest and in Motion

Ethan Cole's laptop was in the back seat for twenty minutes. When he came back from the pharmacy, the window was broken and the bag was gone. The laptop held last night's copy of the Sandwash Family Clinic database, pulled for a restore test. Every role, every grant, and every row-level policy you built in Chapter 5 was still on the server. None of them travelled with the file. Whoever opens that copy reads 600 insurance member numbers with no password at all.

In your SQL course, a column held text and `SELECT` returned it. Chapter 4 decided which columns each group may see. Chapter 5 built the roles and policies that enforce the decision, as long as every reader comes through the server. This chapter is for every other reader: the stolen backup, the retired disk, the listener on the network, and the attacker who dumps a table. Access control decides who may ask. **Encryption** decides what an unauthorized reader gets, and the answer should be nothing.

You will learn three tools (symmetric encryption, asymmetric encryption, and hashing) by the threat each one answers. You will hash the academy's portal passwords and encrypt the clinic's insurance numbers with `pgcrypto`, then keep the encrypted column usable for the one role that needs it. You will put TLS on the connection and prove it from the catalog. Then you will decide what encryption does not fix, what it costs, and what to ask a cloud provider. Mei Lin wants the clinic done first. Naomi Redhouse wants to see the keys, and where they are not.

## Module Overview 🧭

* **Estimated time:** 5-6 hours, including one server restart of your own
* **Prerequisites:** One prior SQL course (Introduction to Oracle: SQL, CIS276DA MySQL Database, or CIS276DB SQL Server Database). Chapter 1 (the lab environment and the three course databases). Chapter 5 supplies the role and column-grant vocabulary, and one sentence recalls it where needed.
* **Deliverables:** Skills Lab 6A folder (`skills-lab-6a.sql` and `skills-lab-6a-answers.md`), Quick Checks

## Learning Objectives 🎯

By the end of this chapter, you will be able to:

* **6.1 (Analyze):** Contrast symmetric encryption, asymmetric encryption, and hashing by the threat each addresses in a database environment (Section 6.1)
* **6.2 (Apply):** Protect sensitive columns at rest with hashing and column-level encryption while keeping the data usable for authorized queries (Section 6.2)
* **6.3 (Apply):** Configure and verify TLS-protected connections so data in motion cannot be read on the network (Section 6.3)

### This chapter aligns with the following Course Learning Outcomes

* **CLO II (Evaluate):** Assess security management for database environments.
* **CLO III (Create):** Develop strategies to maintain optimal system performance, security and availability.

---

## 6.1 Encryption Concepts for Managers

You do not need to design a cipher. You need to pick the right one for a threat and manage its keys. Every encryption decision in this book comes down to three tools, and each tool answers a different question. Start with the vocabulary. **Plaintext** is data anyone can read. **Ciphertext** is the same data after encryption, unreadable without a key. An **encryption key** is the secret that turns one into the other. Modern algorithms are public and well studied. The key is the only secret, and protecting it is most of the job.

| Tool | Keys | Reversible? | The question it answers |
| --- | --- | --- | --- |
| Symmetric encryption | One shared key | Yes, with the key | How do I store or send data so only key holders can read it? |
| Asymmetric encryption | A public key and a private key | Yes, with the private key | How do two parties who share no secret agree on one, and how do I know who I am talking to? |
| Hashing | No key (or one key for a keyed hash) | No | How do I check a value or spot a change without storing the value itself? |

### Symmetric Encryption: One Key, Both Directions

**Symmetric encryption** uses one key to encrypt and the same key to decrypt. It is fast, and it handles any amount of data, so it does the heavy lifting everywhere: the encrypted disk, the encrypted column, and the body of every TLS session. Its weakness is delivery. Whoever encrypts and whoever decrypts must both hold the key, and the key must travel between them without a listener seeing it. The clinic's column key in Section 6.2 is symmetric. So is the session key that carries your queries in Section 6.3.

### Asymmetric Encryption: A Public Lock and a Private Key

**Asymmetric encryption** uses a pair of keys. What one key encrypts, only the other can decrypt. The public key can be handed to anyone. The private key never leaves its owner. That solves the delivery problem: a client encrypts a fresh symmetric key with the server's public key, and only the server can open it. Asymmetric encryption is slow, so it never carries the data itself. It carries the handshake. It also proves identity. A **certificate** is a server's public key wrapped with its name and a signature from someone the client trusts. When your psql session opens under TLS, the certificate is how the client knows it reached the clinic's server and not an impostor.

### Hashing: One Direction, No Way Back

A **hash function** turns any input into a fixed-length fingerprint, and no key or trick turns the fingerprint back into the input. Change one character of the input and the whole fingerprint changes. That makes hashing the right tool for two jobs a database has: checking a password without storing it, and detecting that a value changed. Two refinements matter. A **salt** is a random value mixed into each hash, so two people with the same password get different fingerprints and an attacker cannot precompute a table of answers. A **keyed hash** mixes in a secret key instead, so only a key holder can compute the fingerprint at all. Section 6.2 uses both.

Hashing is not encryption. The clinic cannot hash a member number and read it back on the next claim. Encryption keeps data usable for someone. Hashing keeps it checkable by everyone and readable by no one.

### The Threat Each One Answers

Name the reader you are worried about, and the tool follows:

| The unauthorized reader | Tool | Where you meet it |
| --- | --- | --- |
| Holds the disk, the backup, or the laptop | Symmetric encryption of the volume | Section 6.2 |
| Holds a legitimate connection to a table they should not read | Symmetric encryption of the column | Section 6.2 |
| Steals the password table | Salted hashing | Section 6.2 |
| Listens on the network between client and server | TLS: asymmetric handshake, symmetric session | Section 6.3 |
| Pretends to be your server | Server certificate | Section 6.3 |

The table has a fourth column you must add yourself: who holds the key. **Key management** is the set of decisions about where each key lives, who can reach it, and how it is replaced. A key stored beside the data it protects is a label, not a lock. Chapter 4's minimum-necessary rule applies to keys before it applies to rows.

### Try It Yourself 6.1: Match the Law Office's Threats 🛠️

**Predict:** A law office keeps case files in a database. Its partners fear four things: a backup tape lost in transit, a paralegal reading a partner's billing rates, a coffee-shop network capturing a remote login, and a breached password table. Before you read further, write down which of the three tools answers each fear and which key, if any, the fix depends on.

**Run:** Build a four-row table with the columns Fear, Tool, Key holder, and What the attacker gets after the fix. Fill every cell. For the password table, write what a thief holds after the fix and why it does not log them in.

**Explain:** In one or two sentences, explain why the coffee-shop fear needs two tools instead of one, and which of the two carries the actual queries.

### Quick Check 6.1 ✅

1. A colleague proposes hashing the clinic's insurance member numbers "so they are protected." State which of the two jobs hashing does, and why the billing office would reject the proposal within a week.
2. Contrast the key a stolen backup needs with the key a stolen password table needs, and explain why one of those thefts becomes harmless while the other only becomes slow.

---

## 6.2 Data at Rest: Volume, Column, and Password

**Data at rest** is data sitting in storage: the data directory, the write-ahead log (WAL) files, every backup, every export, and the server log. Each one is a file, and a file can be copied without asking any role for permission. Two layers of encryption answer that, and they answer different readers.

**Volume encryption** encrypts a whole disk or file system below the database. The operating system does it (BitLocker, FileVault, LUKS, or a cloud provider's encrypted volume). Anyone who steals the drive, the laptop, or a decommissioned server gets nothing. Anyone who logs in to the running server gets everything, because the operating system decrypts the volume for every process that reads it. PostgreSQL does not encrypt its own data files, so volume encryption is the floor for every server that holds PHI or education records. It is a floor, not a ceiling. Ethan's stolen backup was safe only if the laptop's disk was encrypted and locked.

**Column-level encryption** encrypts one column's values inside the table. A reader with `SELECT` on the column gets ciphertext. A reader with the key gets the value. This layer answers the threat volume encryption cannot: the connection that is allowed to read the table but has no business reading that column. It also protects the column inside every backup and export, because the ciphertext is what gets copied. The cost is that the database can no longer index, sort, or search the column by value, and this section shows you how to keep it usable anyway.

### The pgcrypto Extension

**pgcrypto** is the PostgreSQL extension that provides hashing, salted password hashing, keyed hashes, and symmetric encryption as SQL functions. It ships with the server but stays off until a superuser enables it in each database. Enable it in the clinic database and prove it from the catalog:

```sql
\connect sandwash_clinic
CREATE EXTENSION IF NOT EXISTS pgcrypto;
SELECT extname AS extension, extversion AS version
FROM pg_extension
WHERE extname = 'pgcrypto';
-- Output:
-- CREATE EXTENSION
--  extension | version
-- -----------+---------
--  pgcrypto  | 1.3
```

### Hash the Portal Passwords

The academy's parent portal stores each guardian's login in `portal_accounts`. Look at what the previous host left in the `password_hash` column:

```sql
\connect harquahala_academy
CREATE EXTENSION IF NOT EXISTS pgcrypto;
SELECT account_id, username, password_hash
FROM portal_accounts
WHERE account_id <= 3
ORDER BY account_id;
-- Output:
-- CREATE EXTENSION
--  account_id |     username      |   password_hash
-- ------------+-------------------+--------------------
--           1 | talia.espinoza897 | plain:5b54bdceca11
--           2 | lena.young108     | plain:6c63752edb15
--           3 | elijah.chavez390  | plain:004621ebcdd3
```

The column is named `password_hash`, and it holds a placeholder that the generator produced from a plain value. Treat every one of the 1,201 rows as a breach waiting to happen. The fix is `crypt()` with `gen_salt()`. The **bcrypt** algorithm (`'bf'`) is built for passwords. It is deliberately slow, and it salts every hash. Its **cost factor** doubles the work with each step up, so you can make it slower as hardware gets faster. Hash the same password twice and compare the results:

```sql
SELECT left(hash_one, 7) AS scheme_and_cost,
       length(hash_one) AS hash_length,
       hash_one <> hash_two AS different_hashes
FROM (SELECT crypt('Harquahala-Ch6-Portal-2026!', gen_salt('bf', 10)) AS hash_one,
             crypt('Harquahala-Ch6-Portal-2026!', gen_salt('bf', 10)) AS hash_two) AS two_hashes;
-- Output:
--  scheme_and_cost | hash_length | different_hashes
-- -----------------+-------------+------------------
--  $2a$10$         |          60 | t
```

Same password, two different results. Every stored string starts with the scheme (`$2a$`) and the cost (`10`), then a 22-character salt, then the hash itself, 60 characters in all. Because the salt is stored inside the string, checking a password needs no separate lookup: hash the attempt with the stored string as the salt and compare. Try It Yourself 6.2 does that for three accounts, and Skills Lab 6A does it for all 1,201.

!!! warning "Hashing the whole table takes about a minute"
    Cost 10 spends about 40 milliseconds per hash on a current laptop, so 1,201 rows take close to a minute. That is the point. A login page pays 40 milliseconds once. An attacker who stole the table pays it for every guess. Do not lower the cost to make the lab faster.

### Try It Yourself 6.2: Hash Three Accounts and Check Them 🛠️

**Predict:** The script below replaces three placeholder hashes and then checks one right password and one wrong one against each. Before you run it, predict the value of `right_password` and `wrong_password` for each row, and predict whether the three stored hashes will be identical, since the three accounts get the same password.

**Run:** Run the block as `postgres` in `harquahala_academy`. The wrong password differs from the right one by case only.

```sql
UPDATE portal_accounts
SET password_hash = crypt('Harquahala-Ch6-Portal-2026!', gen_salt('bf', 10))
WHERE account_id <= 3;
SELECT account_id,
       left(password_hash, 7) AS scheme_and_cost,
       length(password_hash) AS hash_length,
       password_hash = crypt('Harquahala-Ch6-Portal-2026!', password_hash) AS right_password,
       password_hash = crypt('harquahala-ch6-portal-2026!', password_hash) AS wrong_password
FROM portal_accounts
WHERE account_id <= 3
ORDER BY account_id;
-- Output:
-- UPDATE 3
--  account_id | scheme_and_cost | hash_length | right_password | wrong_password
-- ------------+-----------------+-------------+----------------+----------------
--           1 | $2a$10$         |          60 | t              | f
--           2 | $2a$10$         |          60 | t              | f
--           3 | $2a$10$         |          60 | t              | f
```

**Explain:** In one or two sentences, explain how `crypt(attempt, password_hash)` knows which salt to use, and why the portal never needs to store the salt in a second column.

### Column Encryption: The Encrypt-Then-Query Pattern

Chapter 4 classified `insurance_member_id` as PHI, and Chapter 5 limited it to the billing role with a column grant. That grant stops a role. It does not stop a backup. `pgp_sym_encrypt()` encrypts a value with a passphrase and returns `bytea`, and `pgp_sym_decrypt()` reverses it. Encrypt the same value twice and read the result back:

```sql
\connect sandwash_clinic
SELECT pgp_sym_encrypt('CPR-407977684', 'Sandwash-Ch6-ColumnKey-2026!')
         <> pgp_sym_encrypt('CPR-407977684', 'Sandwash-Ch6-ColumnKey-2026!') AS ciphertexts_differ,
       pg_typeof(pgp_sym_encrypt('CPR-407977684', 'Sandwash-Ch6-ColumnKey-2026!')) AS stored_as,
       pgp_sym_decrypt(pgp_sym_encrypt('CPR-407977684', 'Sandwash-Ch6-ColumnKey-2026!'),
                       'Sandwash-Ch6-ColumnKey-2026!') AS round_trip;
-- Output:
--  ciphertexts_differ | stored_as |  round_trip
-- --------------------+-----------+---------------
--  t                  | bytea     | CPR-407977684
```

The two ciphertexts differ, on purpose, and the value comes back intact. `pgp_sym_encrypt()` adds a random salt each time, so an attacker who sees two rows cannot tell whether they hold the same member number. That same property means `WHERE insurance_member_id_enc = ...` can never find a row, and an index on the ciphertext is useless. Billing still needs to find a patient by member number.

The answer is a second column: a **lookup hash**. A plain `digest()` would work for searching, but a plain hash of a 13-character member number is guessable by anyone who can enumerate member numbers. A keyed hash with `hmac()` is searchable only by a holder of the lookup key:

```sql
SELECT left(encode(digest('CPR-407977684', 'sha256'), 'hex'), 16) AS digest_prefix,
       left(encode(hmac('CPR-407977684', 'Sandwash-Ch6-LookupKey-2026!', 'sha256'), 'hex'), 16) AS hmac_prefix,
       hmac('CPR-407977684', 'Sandwash-Ch6-LookupKey-2026!', 'sha256')
         = hmac('CPR-407977684', 'Sandwash-Ch6-LookupKey-2026!', 'sha256') AS hmac_repeats;
-- Output:
--   digest_prefix   |   hmac_prefix    | hmac_repeats
-- ------------------+------------------+--------------
--  4e31546f0c006c21 | d5daf0afa601bd47 | t
```

The keyed hash repeats for the same input, so it can be indexed and compared. It cannot be reversed, and it cannot be computed without the lookup key. Put the two columns together and you have the pattern this section is named for:

1. Add a `bytea` column for the ciphertext and a `bytea` column for the lookup hash.
2. Encrypt every value with the column key and fingerprint it with the lookup key.
3. Prove every ciphertext decrypts back to its plaintext.
4. Drop the plaintext column. Ciphertext beside plaintext protects nothing.
5. Grant the ciphertext column only to the role that holds the column key.
6. Query through the lookup column, and decrypt only the rows the query returns.

Step 6 is the performance rule as well as the security rule. Decrypting a row costs work, and decrypting every row to find one is a full scan of the table. Section 6.4 measures it.

### Keys Outside the Database

Both passphrases above appear in the SQL, which is fine in a textbook and wrong on a server. Anything in a statement ends up in the server log once statement logging is on (Chapter 7 turns it on). Anything in a table travels with every backup. Anything in a function body is readable by any role that can read `pg_proc`. The column key belongs in the billing application's secret store, and the application passes it with each query. The database holds ciphertext and never holds the key. HHS describes that arrangement when it says the key must be stored apart from the data it protects (Further Reading). It is what makes a stolen backup unreadable instead of merely inconvenient.

Two more decisions belong in the procedure you write in Skills Lab 6A. **Key rotation** is the scheduled replacement of a key: decrypt with the old key, encrypt with the new, verify the round trip, retire the old key. It has to be planned before the first row is encrypted, because a key you cannot rotate is a key you cannot revoke. And the data owner, not the DBA, approves who holds the key. The DBA who can read every ciphertext and also holds the key has recreated the superuser problem from Chapter 1 in a new place.

### Try It Yourself 6.3: Encrypt the Clinic's Insurance Numbers 🛠️

You are Copperwind's database administrator, and Dr. Vasquez has approved encrypting `insurance_member_id` with billing as the only reader. The script below applies the six-step pattern to the clinic's `patients` table. Three function names are missing.

**Predict:** For each `____`, write down the function that belongs there and one phrase saying why that function and not its neighbor. The first gap turns plaintext into ciphertext. The second builds the lookup column, and `digest()` is the wrong answer. The third reverses the first, for one row. Then predict the two result tables: how many round trips succeed out of 600, and which patient the lookup finds.

**Run:** Copy the script into a file, fill the gaps, and run it as `postgres` in `sandwash_clinic` after the `CREATE EXTENSION` block above. Compare your output with the expected output that follows.

```text
-- Step 1: Add a ciphertext column and a keyed lookup column beside the plaintext
ALTER TABLE patients
  ADD COLUMN insurance_member_id_enc bytea,
  ADD COLUMN insurance_member_id_lookup bytea;
-- Step 2: Encrypt every value with the column key, and fingerprint it with the lookup key
UPDATE patients
SET insurance_member_id_enc = ____(insurance_member_id, 'Sandwash-Ch6-ColumnKey-2026!'),
    insurance_member_id_lookup = ____(insurance_member_id, 'Sandwash-Ch6-LookupKey-2026!', 'sha256');
-- Step 3: Prove every ciphertext decrypts back to its plaintext before the plaintext goes
SELECT COUNT(*) AS patients,
       COUNT(*) FILTER (WHERE pgp_sym_decrypt(insurance_member_id_enc, 'Sandwash-Ch6-ColumnKey-2026!') = insurance_member_id) AS round_trips_ok
FROM patients;
-- Step 4: Drop the plaintext. Encryption with the plaintext still beside it protects nothing.
ALTER TABLE patients DROP COLUMN insurance_member_id;
CREATE INDEX patients_member_lookup_idx ON patients (insurance_member_id_lookup);
-- Step 5: Only billing may read the ciphertext. The key travels with the billing query, never with the table.
CREATE ROLE clinic_billing NOLOGIN;
GRANT SELECT (patient_id, first_name, last_name, insurance_member_id_enc, insurance_member_id_lookup)
  ON patients TO clinic_billing;
-- Step 6: Find one patient by member id through the lookup column, then decrypt that row only
SET ROLE clinic_billing;
SELECT patient_id, last_name,
       ____(insurance_member_id_enc, 'Sandwash-Ch6-ColumnKey-2026!') AS insurance_member_id
FROM patients
WHERE insurance_member_id_lookup = hmac('CPR-407977684', 'Sandwash-Ch6-LookupKey-2026!', 'sha256');
RESET ROLE;
```

```text
 patients | round_trips_ok
----------+----------------
      600 |            600

 patient_id | last_name | insurance_member_id
------------+-----------+---------------------
          1 | Dominguez | CPR-407977684
```

**Explain:** In one or two sentences, explain why Step 3 must run before Step 4 and what you would do if it reported 599. Then state what the front desk sees if it runs the Step 6 query, and why the answer is not ciphertext.

The front desk's answer is worth seeing. A role with a column grant that does not include the ciphertext column gets a refusal, and PostgreSQL names the table, not the column:

```text
SET ROLE clinic_frontdesk;
SELECT patient_id,
       pgp_sym_decrypt(insurance_member_id_enc, 'Sandwash-Ch6-ColumnKey-2026!') AS insurance_member_id
FROM patients
WHERE patient_id = 1;
```

```text
ERROR:  permission denied for table patients
```

Two locks stand between the front desk and a member number. The grant refuses the column, and the key was never theirs. Either one alone would hold.

### Fix It 6.1: The Key That Was Almost Right 🔧

A billing analyst at the clinic copied the column key from a ticket into a saved query, and the first claim run failed.

**Symptom:** The Step 6 query from Try It Yourself 6.3, run as `clinic_billing`, stops with an error instead of a member number. The saved query held the passphrase without its final character.

```text
SET ROLE clinic_billing;
SELECT patient_id,
       pgp_sym_decrypt(insurance_member_id_enc, 'Sandwash-Ch6-ColumnKey-2026') AS insurance_member_id
FROM patients
WHERE patient_id = 1;
```

```text
ERROR:  Wrong key or corrupt data
```

**Diagnose:** State the cause in one sentence before you change anything. The error offers two explanations. Which one can you rule out, and what single fact rules it out?

**Repair:** Do not touch the table. Correct the passphrase in the query and rerun it. The rerun, captured from the reference solution, returns the row:

```text
 patient_id | insurance_member_id
------------+---------------------
          1 | CPR-407977684
```

State what changed and what did not. Then state where the analyst should have fetched the key from, and why a ticket was the wrong place.

**Verify:** How do you know the data was never corrupt? Name the Step 3 count that proves it and explain why one successful decrypt is weaker evidence than that count.

### Quick Check 6.2 ✅

1. Copperwind's cloud provider encrypts every volume by default. Explain what that protects the clinic against and name the reader it does not stop, then state which layer in this section stops that reader.
2. A developer proposes storing the column key in a `clinic_settings` table "so every query can find it." Judge the proposal using the backup argument from this section, and state where the key belongs instead.

---

## 6.3 Data in Motion: TLS on the Connection

Chapter 2's `pg_hba.conf` used one rule type, `hostssl`, and promised that this chapter would make it work. Here is why it matters. Without encryption, every statement you type and every row the server returns crosses the network as readable text. SCRAM-SHA-256 keeps your password off the wire (Chapter 5). It does nothing for the query after login. A listener on the clinic's network, or on the coffee-shop network a remote provider uses, reads patient rows as they pass. **Data in motion** is data on the network, and **TLS** (Transport Layer Security) is the protocol that encrypts it.

TLS gives a connection three things. Confidentiality: the session is encrypted with a symmetric key that the client and server agree on through an asymmetric handshake. Integrity: a changed packet is detected. Authentication: the server presents a certificate, so the client can confirm it reached the right server. All three depend on one file pair on the server: a certificate and the private key behind it.

### Read the Server's Current State

Start with what the server says about itself. `SHOW` and `pg_settings` are PostgreSQL-specific, and both read the running configuration:

```sql
SELECT name, setting
FROM pg_settings
WHERE name IN ('ssl', 'ssl_cert_file', 'ssl_key_file', 'ssl_min_protocol_version')
ORDER BY name;
-- Output:
--            name           |  setting
-- --------------------------+------------
--  ssl                      | off
--  ssl_cert_file            | server.crt
--  ssl_key_file             | server.key
--  ssl_min_protocol_version | TLSv1.2
```

A fresh install has TLS off, expects the certificate and key to be named `server.crt` and `server.key` in the data directory, and refuses anything older than TLS 1.2 once TLS is on. Two of those defaults are fine. The first is the one you change.

### Make a Server Certificate

A **self-signed certificate** is one you sign with its own private key instead of paying a certificate authority to sign it. It encrypts the session as well as any other certificate. What it cannot do is prove the server's name to a client that has never seen it, because no third party vouched for it. That is acceptable for a lab and for servers whose clients you also control, where you hand each client a copy of the certificate to trust. A public-facing server uses a certificate a recognized authority signed. The data pack ships this command in `make-server-cert.sh`. Run it in a terminal from your data directory:

```bash
openssl req -new -x509 -days 365 -nodes -text \
  -out server.crt -keyout server.key \
  -subj "/CN=copperwind-lab"
chmod og-rwx server.key
```

`-x509` makes it self-signed, `-days 365` sets a one-year life, and `-nodes` leaves the key unencrypted so the server can start unattended. The `chmod` matters: PostgreSQL refuses to start with a key file that other users can read. `CN=copperwind-lab` is the name the certificate claims, and the client side, later in this section, comes back to it. The data pack ships the command and never the key. A private key that is in a data pack, a repository, or a ticket is not private.

### Turn TLS On

One line in `postgresql.conf` enables TLS, and two more name the files. The defaults already match the file names above, so name them anyway, for the reader who inherits the server:

```text
ssl = on
ssl_cert_file = 'server.crt'
ssl_key_file = 'server.key'
```

`ssl` cannot be reloaded. Restart the server (`pg_ctl restart`, or the service manager your installer registered). After your restart, the same catalog reads differently. This output was captured on a test cluster with TLS on. It appears on your server only after your own restart:

```text
 ssl
-----
 on

 ssl | version |         cipher         | bits
-----+---------+------------------------+------
 t   | TLSv1.3 | TLS_AES_256_GCM_SHA384 |  256
```

The second query reads `pg_stat_ssl`, a PostgreSQL view with one row per connection, filtered to your own backend with `pg_backend_pid()`. That row is your evidence. `SHOW ssl` says the server offers TLS. `pg_stat_ssl` says this connection is using it.

### Require It at the Gate: hostssl

Offering TLS is not requiring it. A client that asks for a plain connection still gets one, and a `host` rule in `pg_hba.conf` accepts either kind. The `hostssl` type matches only encrypted connections, and `hostnossl` matches only plain ones. Put them together so the clinic's billing account can connect one way and no way else. First create the account the rule names:

```sql
CREATE ROLE clinic_billing_app LOGIN
  PASSWORD 'Sandwash-Ch6-Billing-2026!'
  CONNECTION LIMIT 3;
SELECT rolname AS role_name, rolcanlogin AS can_login, rolconnlimit AS conn_limit
FROM pg_roles
WHERE rolname = 'clinic_billing_app';
-- Output:
-- CREATE ROLE
--      role_name      | can_login | conn_limit
-- --------------------+-----------+------------
--  clinic_billing_app | t         |          3
```

Replace the password with one of your own. Then add these rules to `pg_hba.conf` above any `host` rule that could match the same client, and reload with `pg_reload_conf()`. The data pack ships them in `tls-config-excerpt.conf`:

```text
# TYPE      DATABASE         USER                ADDRESS         METHOD
hostssl     sandwash_clinic  clinic_billing_app  127.0.0.1/32    scram-sha-256
hostnossl   all              all                 0.0.0.0/0       reject
```

Chapter 2 taught that rule order is a security decision, and it still is. The `reject` line catches every plain TCP connection that reaches it, so it belongs below the `hostssl` rules and above nothing you still need. After the reload, `pg_hba_file_rules` shows both, and a plain connection as the billing account gets this refusal (captured on the test cluster):

```text
psql: error: connection to server at "localhost" (127.0.0.1), port 5432 failed: FATAL:  pg_hba.conf rejects connection for host "127.0.0.1", user "clinic_billing_app", database "sandwash_clinic", no encryption
```

Read the last two words. The server names the reason, and the same line lands in the server log with a timestamp, which Chapter 7 will teach you to read.

### The Client Side: sslmode

The server can offer TLS and require it. The client decides whether to check the certificate. **sslmode** is the connection parameter that sets the client's policy, and its default is the one to worry about:

| `sslmode` | Encrypts? | Checks the certificate? | Use it when |
| --- | --- | --- | --- |
| `disable` | No | No | Never for PHI or education records |
| `prefer` (default) | If offered | No | Never on purpose. It falls back to plain text silently |
| `require` | Yes | No | Lab servers and self-signed certificates you have not distributed |
| `verify-ca` | Yes | Signed by a trusted root | You hold a copy of the signing certificate |
| `verify-full` | Yes | Signed and the name matches | Production. This is the only mode that stops an impostor |

Two refusals show the modes working. Against a server with TLS off, `require` refuses to connect instead of falling back. This one was captured against the course cluster before any change:

```text
psql "host=localhost dbname=sandwash_clinic user=postgres sslmode=require"
psql: error: connection to server at "localhost" (127.0.0.1), port 5432 failed: server does not support SSL, but SSL was required
```

Against the test cluster with the self-signed certificate installed, `verify-full` refused because the certificate claims `copperwind-lab` and the client asked for `localhost`:

```text
psql: error: connection to server at "localhost" (127.0.0.1), port 5432 failed: server certificate for "copperwind-lab" does not match host name "localhost"
```

That refusal is the certificate doing its job. A production certificate carries the host name clients use, and every application connection string says `sslmode=verify-full`. The `prefer` default would have connected in both cases and told nobody. Set `sslmode` explicitly in every connection string Copperwind writes, and the `PGSSLMODE` environment variable for every psql session.

### The TLS Verification Sequence

Every TLS change gets the same four checks, in order, and the first three are queries. Run them now on your unchanged server, so you know the "before" answers. Rerun them after your restart in Skills Lab 6A and the answers flip:

```sql
-- Step 1: Does the server offer TLS at all? (off now, on after your restart)
SHOW ssl;
-- Step 2: Is THIS connection encrypted? (f now, t after you reconnect with sslmode=require)
SELECT ssl, version, cipher
FROM pg_stat_ssl
WHERE pid = pg_backend_pid();
-- Step 3: Does the gate require it? (0 now, 1 or more after your hostssl rules load)
SELECT COUNT(*) FILTER (WHERE type = 'hostssl') AS hostssl_rules,
       COUNT(*) FILTER (WHERE type = 'host') AS host_rules
FROM pg_hba_file_rules;
-- Output:
--  ssl
-- -----
--  off
--
--  ssl | version | cipher
-- -----+---------+--------
--  f   |         |
--
--  hostssl_rules | host_rules
-- ---------------+------------
--              0 |          4
```

Step 4 is the client: connect with `sslmode=require` and expect success, then `sslmode=disable` and expect the `reject` refusal above. Paste all four results into the lab. A TLS setup with three of the four is a TLS setup someone can bypass.

### Try It Yourself 6.4: Prove Which Path You Are On 🛠️

**Predict:** On the same machine, psql can reach the server two ways: a local socket, or TCP to `localhost`. Before you run anything, predict what `inet_server_addr()` returns on each path, and whether `pg_stat_ssl.ssl` can ever be true on the socket path.

**Run:** Reconnect over TCP and read both facts about your own connection. The three-argument form of `\connect` takes the database, the role, and the host:

```sql
\connect sandwash_clinic postgres localhost
SELECT inet_server_addr() AS server_addr,
       inet_client_addr() AS client_addr,
       ssl
FROM pg_stat_ssl
WHERE pid = pg_backend_pid();
-- Output:
--  server_addr | client_addr | ssl
-- -------------+-------------+-----
--  127.0.0.1   | 127.0.0.1   | f
```

**Explain:** In one or two sentences, explain why `hostssl` rules never apply to a socket connection. Then say what that means for the `local` line in `pg_hba.conf` on a server other people can log in to.

### Quick Check 6.3 ✅

1. A remote provider's connection string reads `sslmode=prefer`, and she says "it works, so it must be encrypted." State the two queries that settle the question and the answer each gives when she is wrong.
2. Contrast `require` and `verify-full` by the attacker each one stops, and explain why a self-signed certificate forces a choice between them.

---

## 6.4 Choosing Controls

Encryption is the control people reach for first, because it sounds absolute. It is not. It protects against a named reader, costs measurable work, and moves the problem to the key. This section gives you the three questions to ask before you encrypt anything: what does this stop, what does it cost, and who holds the key.

### What Encryption Does Not Protect Against

Lay the three layers against the readers from Section 6.1, plus the ones people forget:

| Reader | Volume encryption | Column encryption | TLS |
| --- | --- | --- | --- |
| Stolen disk or backup file | Stops | Stops the column | No effect |
| Listener on the network | No effect | Stops the column | Stops |
| Role with `SELECT` on the table | No effect | Stops the column | No effect |
| Role with `SELECT` and the key | No effect | No effect | No effect |
| The application, once it has decrypted | No effect | No effect | No effect |
| SQL injection through the application | No effect | Stops only columns the app does not decrypt | No effect |
| A superuser on the running server | No effect | Stops the column, until they find the key | No effect |

Read the fourth and fifth rows twice. Encryption never stops an authorized reader, and the application that holds the key is the most authorized reader there is. Chapter 5's least privilege and Chapter 9's parameterized queries are what limit that reader. Encryption limits everyone else. That is why HIPAA treats encrypted PHI as a safe harbor: a stolen encrypted copy whose key was not stolen is not a reportable breach (Further Reading). The safe harbor holds only if the key was stored apart from the data, which is the whole of Section 6.2's key argument.

**Tokenization** is the close cousin worth naming. It replaces a value with a random token and keeps the mapping in a separate, harder-to-reach store. The database holds tokens that mean nothing on their own. It suits values that are looked up but never computed on, such as card numbers, and it is usually a service you buy, not a function you call.

### What It Costs

Every layer costs storage, work, or both, and the numbers are yours to measure before the data owner asks. Ciphertext is bigger than plaintext, and the lookup hash adds a fixed 32 bytes:

```sql
SELECT pg_column_size('CPR-407977684'::text) AS plaintext_bytes,
       length(pgp_sym_encrypt('CPR-407977684', 'Sandwash-Ch6-ColumnKey-2026!')) AS ciphertext_bytes,
       length(hmac('CPR-407977684', 'Sandwash-Ch6-LookupKey-2026!', 'sha256')) AS lookup_bytes;
-- Output:
--  plaintext_bytes | ciphertext_bytes | lookup_bytes
-- -----------------+------------------+--------------
--               17 |               79 |           32
```

PostgreSQL stores a 13-character member number in 17 bytes (the characters plus a short header). The two protected columns hold about 110 bytes for the same value. Across 600 patients that is nothing. Across a claims history of millions of rows it is a sizing change for Chapter 2's projection. Work is the larger cost. This transcript, captured with psql's `\timing` meta-command on the author's laptop, shows why Step 6 of the pattern decrypts only the rows a query returns. Your numbers will differ. The shape will not:

```text
harquahala_academy=# \timing on
harquahala_academy=# SELECT COUNT(*) AS decrypted_rows
FROM (SELECT pgp_sym_decrypt(pgp_sym_encrypt(email, 'k'), 'k') FROM guardians) AS all_rows;
 decrypted_rows
----------------
           1201
Time: 447.164 ms
```

Nearly half a second to decrypt 1,201 short values. A query that decrypts a column to filter on it does this on every row, every time. The plans from the reference solution show the difference the lookup column makes:

```text
 Seq Scan on patients
   Filter: (pgp_sym_decrypt(insurance_member_id_enc, '...'::text) = 'CPR-407977684'::text)

 Bitmap Heap Scan on patients
   Recheck Cond: (insurance_member_id_lookup = '\xd5daf0af...'::bytea)
   ->  Bitmap Index Scan on patients_member_lookup_idx
```

The first plan decrypts 600 rows to find one. The second reads the index and decrypts one. Chapter 8 teaches you to read these plans in full. For now, read the first line of each.

Password hashing has a cost you choose. The transcript below shows one bcrypt hash at four cost factors on the same laptop. Each step of two roughly quadruples the time:

```text
harquahala_academy=# SELECT left(crypt('Harquahala-Ch6-Portal-2026!', gen_salt('bf', 4)), 7) AS cost_4;
Time: 0.759 ms
harquahala_academy=# SELECT left(crypt('Harquahala-Ch6-Portal-2026!', gen_salt('bf', 8)), 7) AS cost_8;
Time: 10.405 ms
harquahala_academy=# SELECT left(crypt('Harquahala-Ch6-Portal-2026!', gen_salt('bf', 10)), 7) AS cost_10;
Time: 41.200 ms
harquahala_academy=# SELECT left(crypt('Harquahala-Ch6-Portal-2026!', gen_salt('bf', 12)), 7) AS cost_12;
Time: 164.537 ms
```

Pick the highest cost a login can afford. A parent logging in to the portal will not notice 165 milliseconds. An attacker with a stolen table trying a billion guesses will. TLS, for comparison, costs a few milliseconds per new connection for the handshake and almost nothing per query after it. Applications that open one connection per query pay the handshake every time, which is one more reason applications reuse connections instead of opening one per query.

### Questions to Ask a Cloud Provider

Chapter 2's shared responsibility model left keys with the customer under every service model. A managed database service will say it encrypts everything. Ask what that sentence means:

* Who holds the volume encryption key, and can the clinic supply its own?
* Is the connection between the provider's own tiers encrypted, or only the connection from Copperwind?
* Are backups and snapshots encrypted with the same key as the volume, and who can restore one?
* When a key is rotated, what happens to old backups?
* Which staff at the provider can reach the running server, and what log proves it?
* Does the service run `pgcrypto`, or an equivalent, so column encryption stays possible?

Write the answers into the business associate agreement (Chapter 2) or do not sign it. A provider that cannot answer the first question has told you who holds the key.

### Try It Yourself 6.5: Choose Controls for the Food Bank 🛠️

**Predict:** A nonprofit food bank stores donor names, gift amounts, and the last four digits of donor cards, on a managed cloud database, and volunteers log in from home. Before you write anything, predict which of the three layers the food bank needs, which one it already has without asking, and which column deserves the pgcrypto pattern.

**Run:** Build a table with the columns Data element, Reader you fear, Layer, Key holder, and Cost you would measure first. Fill it for the three data elements. Then write the one question you would ask the provider before turning anything on.

**Explain:** In one or two sentences, explain why the volunteer at home is the reader that decides the TLS row. Then explain why the `sslmode` you choose for her is a separate decision from the one you make for the provider's own network.

### Quick Check 6.4 ✅

1. A clinic manager reads that "encrypted data cannot be breached" and asks why the chapter still needed roles and policies. Using two rows from the table in this section, explain what encryption leaves uncovered.
2. The billing team wants member-number search "to be fast." Judge the two plans from this section and state which column the search should use, then name the one thing that column cannot do that the ciphertext column can.

---

## 6.5 Summary and Retrieval 💡

### Key Concepts

* Three tools, three questions. Symmetric encryption protects stored or sent data for key holders. Asymmetric encryption lets two strangers agree on a key and proves a server's identity through a certificate. Hashing checks a value without keeping it. The key is the only secret, so key management is most of the work.
* Data at rest sits in files, and files copy without asking a role. Volume encryption stops whoever holds the disk. Column encryption with `pgcrypto` stops whoever holds a connection but not the key, and it protects the column in every backup.
* Passwords are hashed, never encrypted. `crypt()` with `gen_salt('bf')` salts every hash and makes each guess slow. The salt lives inside the stored string, so checking a password is one function call.
* The encrypt-then-query pattern keeps an encrypted column usable. Ciphertext goes in one column and a keyed lookup hash in another. The plaintext is dropped, the ciphertext is granted to one role, and decryption touches only the rows a query returns. The key travels with the query and never lives in the database.
* Data in motion needs TLS. The server needs a certificate and key and `ssl = on`. The gate needs `hostssl` rules with a `hostnossl ... reject` below them. The client needs an explicit `sslmode`, because the default `prefer` falls back to plain text in silence. Four checks prove it, and three of them are queries.
* Encryption never stops an authorized reader or the application holding the key. It costs storage and work you can measure. A cloud provider's "encrypted by default" is a question, not an answer, until you know who holds the key.

Part II ends here. You can now classify a regulated dataset (Chapter 4), implement the roles and views that enforce the classification (Chapter 5), and encrypt what remains exposed, with evidence from the server for every step.

### Key Terms

See course glossary for full definitions

* encryption, plaintext, ciphertext, encryption key, symmetric encryption, asymmetric encryption, certificate, hash function, salt, keyed hash, key management (Section 6.1)
* data at rest, volume encryption, column-level encryption, pgcrypto, bcrypt, cost factor, lookup hash, key rotation (Section 6.2)
* data in motion, TLS, self-signed certificate, sslmode (Section 6.3)
* tokenization (Section 6.4)

### Retrieval Practice

1. From memory, name the three tools from Section 6.1 and the one question each answers, then state which of the three is not reversible and why that is the point.
2. List the six steps of the encrypt-then-query pattern in order and say which step protects performance as well as confidentiality.
3. State the four checks of the TLS verification sequence and the "before" answer each one gives on a fresh install.
4. From Chapter 4: State the two conditions that make a column PHI, and explain why encrypting `insurance_member_id` does not change its classification in the register.
5. From Chapter 2: Name the three gates a connection passes to reach a database in the data tier, and say which of the three this chapter's `hostssl` rule belongs to.

---

## 6.6 Skills Lab 6A: Encrypt Harquahala Guardian Contacts

**Goal:** Replace the parent portal's placeholder password hashes with salted bcrypt hashes. Encrypt guardian phone numbers and email addresses with the encrypt-then-query pattern so the registrar can still find a guardian by phone. Prove TLS on your own connection, and write the key-handling procedure Principal Whitfield will sign.

**Dataset or starter files:** `assets/code/chapter-06/` in the course data pack. `setup-harquahala.sql` rebuilds `harquahala_academy` with the placeholder hashes in place. `make-server-cert.sh` holds the certificate command from Section 6.3, and `tls-config-excerpt.conf` holds the `postgresql.conf` and `pg_hba.conf` lines. `skills-lab-6a.sql` is the starter script with numbered markers. `skills-lab-6a-answers.md` holds the verification table, the key-handling procedure, and the two Questions & Analysis answers. The setup script loads the CSVs in `assets/code/data/harquahala/`. The academy and every record in it are fictional.

Principal Whitfield has ruled, and the ruling is your specification:

* Every portal password is stored as a bcrypt hash at cost 10 or higher. No placeholder remains.
* Guardian `phone` and `email` are encrypted at rest. The registrar's role may decrypt them. Teachers may not read the ciphertext at all.
* The registrar must be able to find a guardian by phone number without decrypting the table.
* The column key and the lookup key live outside the database, and the procedure says who holds them and how they are rotated.
* Every connection to the academy database from an application account is encrypted.

### Part 1: Foundation (Aligns with Objective 6.2)

1. From the extracted `cis376` folder, run `setup-harquahala.sql` as `postgres`. Under marker 1.1, enable `pgcrypto` and paste the `pg_extension` row that proves it. Then count the accounts whose `password_hash` starts with `plain:`.
2. Under marker 1.2, replace every `password_hash` with `crypt(username || '-Portal-2026!', gen_salt('bf', 10))`. Using the username inside the password gives each account a different password without shipping a list. Expect the statement to take about a minute. Then rerun the count from 1.1 and paste both counts side by side.
3. Under marker 1.3, pick three accounts and check each against its right password and one wrong password, following Try It Yourself 6.2. Paste the result. In the answer file, record the bcrypt cost you used and the time the `UPDATE` took.

### Part 2: Application (Aligns with Objectives 6.1 and 6.2)

1. Under marker 2.1, apply the six-step pattern from Section 6.2 to `guardians.phone` and `guardians.email`. Add `phone_enc`, `email_enc`, and `phone_lookup`. Encrypt with a column key of your own and fingerprint `phone` with a lookup key of your own. Prove 1,201 round trips for each column before you drop the two plaintext columns. Index `phone_lookup`. Paste every result.
2. Under marker 2.2, create `academy_registrar` and `academy_teacher` as `NOLOGIN` roles. Grant the registrar `SELECT` on `guardian_id`, `full_name`, `relationship`, `phone_enc`, `email_enc`, and `phone_lookup`. Grant the teacher `SELECT` on `guardian_id`, `full_name`, and `relationship` only. Prove both grants with `has_column_privilege()` on `phone_enc`, one `t` and one `f`.
3. Under marker 2.3, `SET ROLE academy_registrar` and find every guardian whose phone is `602-555-6946` through the lookup column, decrypting `phone_enc` and `email_enc` for the rows returned. Then `SET ROLE academy_teacher` and run the same query, and paste the refusal. In the answer file, record how many rows the registrar's lookup returned and explain the number, because this data has guardians who share a phone.

### Part 3: Extension (Aligns with Objectives 6.1 and 6.3)

1. Run `make-server-cert.sh` in your data directory, add the three `postgresql.conf` lines from `tls-config-excerpt.conf`, and restart your server. Add a `hostssl` rule for a new login role `academy_portal_app` (your own visibly fake password, connection limit 5) and the `hostnossl ... reject` rule, then reload. Under marker 3.1, run the four-check verification sequence from Section 6.3 as `academy_portal_app` with `sslmode=require`. Paste the three query results and the `sslmode=disable` refusal.
2. Under marker 3.2, connect once more with `sslmode=verify-full` and paste what happens. In the answer file, explain the result in two sentences and state what a production certificate would need to change.
3. Write the key-handling procedure for Principal Whitfield in the answer file, using the template there. Name the two keys, who holds each, and where each is stored. State how the registrar's application receives the column key. Give the rotation schedule and the five statements a rotation runs. State what the academy does in the first hour after a key is suspected stolen. Close with one paragraph on what the encryption does not protect against, naming two readers from the table in Section 6.4.

### Questions & Analysis 🤔

1. Using your Part 2.3 output as evidence, explain what the registrar can do that a teacher cannot, then explain what a teacher who somehow obtained the column key still could not do. Name the one reader in Section 6.4's table that neither the grant nor the key stops, and state which chapter's control limits that reader.
2. Your Part 1 `UPDATE` took a measured time at cost 10. Using that number and the four timings in Section 6.4, justify a cost factor for the portal, given about 1,200 guardians who log in a few times a month. Then explain why you hashed the passwords but encrypted the phone numbers, and what would go wrong if you had done the reverse.

**Submission:** Submit one folder named `skills-lab-6a-lastname`. It holds `skills-lab-6a.sql` with every result pasted as `-- Output:` comment lines (or the saved psql output beside it). It also holds `skills-lab-6a-answers.md` with the verification table, the key-handling procedure, and your two Questions & Analysis answers clearly labeled. Never include `server.key`, a column key, or a lookup key in the submission. The procedure names where they live. It does not contain them.

### Rubric: Skills Lab 6A

This lab is graded with the standard
[Skills Lab Rubric](../skills-lab-rubric.md): four criteria, five
levels from Mastery to Not Evident. The criteria are Technical
Accuracy and Efficiency, Output Quality, Documentation Quality, and
Analysis, Interpretation, and Response to QUESTION(s). The criteria
and levels are the same everywhere. Your instructor sets the point
values in your course. Check the syllabus and the Canvas rubric
attached to this lab for the values that apply to you.

---

## 6.7 Review Questions 🔄️

1. **Apply:** A bike shop stores customer emails, order totals, and staff login passwords in one database on an encrypted cloud volume. For each of the three columns, state whether it needs hashing, column encryption, nothing beyond the volume, or a different control, and give one sentence of reasoning per column.

2. **Analyze:** A credit union's auditor finds that member account numbers are encrypted with `pgp_sym_encrypt()` and the passphrase is stored in a table named `app_config` in the same database. Break down what a stolen backup exposes, what a role with `SELECT` on both tables exposes, and which single change restores the protection the encryption was supposed to provide.

3. **Evaluate:** A city parks department's vendor says its reservation system "uses SSL," and the connection string reads `sslmode=prefer`. Judge whether the department's data in motion is protected, name the query that would settle it in one row, and state the two changes you would require before signing off.

4. **Create:** Design the key-handling procedure for a law office that encrypts client Social Security numbers in one column. Name the keys, their holders, where each is stored, how the application receives the column key at startup, the rotation steps in order, and the evidence query that proves a rotation completed without loss.

---

## Further Reading 📖

* [PostgreSQL Documentation: pgcrypto](https://www.postgresql.org/docs/17/pgcrypto.html) - Every function this chapter used, including the `crypt()` algorithms, the `gen_salt()` cost limits, and the `pgp_sym_*` options.
* [PostgreSQL Documentation: Encryption Options](https://www.postgresql.org/docs/17/encryption-options.html) - The one-page map of where PostgreSQL can encrypt (columns, connections, volumes, passwords) and where it cannot.
* [PostgreSQL Documentation: Secure TCP/IP Connections with SSL](https://www.postgresql.org/docs/17/ssl-tcp.html) - Certificate files, their permissions, and the `openssl` commands for self-signed and CA-signed setups.
* [PostgreSQL Documentation: SSL Support in libpq](https://www.postgresql.org/docs/17/libpq-ssl.html) - The `sslmode` table in full, with the exact protection each mode gives against eavesdropping and impersonation.
* [NIST SP 800-57 Part 1 Rev. 5: Recommendation for Key Management](https://csrc.nist.gov/pubs/sp/800/57/pt1/r5/final) - The reference for key lifetimes, rotation, and separation of key holders behind Section 6.2's procedure.
* [HHS: Guidance to Render Unsecured PHI Unusable, Unreadable, or Indecipherable](https://www.hhs.gov/hipaa/for-professionals/breach-notification/guidance/index.html) - The breach safe harbor, which requires NIST-tested encryption and a key stored apart from the data.
* [OWASP Password Storage Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html) - Why passwords are hashed with a slow, salted algorithm and how to choose the work factor.

---

## Looking Ahead ⏩

Part II is complete. The clinic's data is classified, the roles enforce the classification, and the columns and connections that remained exposed are now encrypted. Every control so far answers "who may read this." Chapter 7 opens Part III with a different question: what happened? You will turn on the server's connection and statement logs, build a trigger-based audit trail that records who changed which row and when, and read a day of logs to tell routine from suspicious. The `FATAL` line the `reject` rule wrote in this chapter is the first entry in that evidence.
