# Chapter 6 Data Pack: Encryption at Rest and in Motion

Chapter 6 works in two databases. The clinic carries the spine Try It
Yourself (encrypting `insurance_member_id`), the Fix It, and the TLS
reading. The academy carries the password hashing and the Skills Lab.
Run each script from the extracted `cis376` folder:

```text
psql -U postgres -d postgres -f assets/code/chapter-06/setup-sandwash.sql
psql -U postgres -d postgres -f assets/code/chapter-06/setup-harquahala.sql
```

## Contents

| File | Purpose |
| ---- | ------- |
| `setup-sandwash.sql` | Creates `sandwash_clinic` and loads the clinic tables. `insurance_member_id` is plaintext, as the chapter finds it |
| `setup-harquahala.sql` | Creates `harquahala_academy` and loads the school's tables. `portal_accounts.password_hash` holds the placeholder values the chapter replaces |
| `make-server-cert.sh` | The `openssl` command from Section 6.3 that generates a self-signed server certificate and key in your data directory. Ships the command only. Never a key |
| `tls-config-excerpt.conf` | The three `postgresql.conf` lines and the two `pg_hba.conf` rules from Section 6.3, ready to copy into your own files |
| `skills-lab-6a.sql` | Starter script for Skills Lab 6A with numbered markers for each part |
| `skills-lab-6a-answers.md` | Starter answer file with the verification table, the key-handling procedure template, and the two Questions & Analysis answers |

The CSV files the scripts load live in `assets/code/data/`. Its README
holds the data dictionary for every table.

## Which parts use which files

| Chapter part | Database | Script |
| ------------ | -------- | ------ |
| Section 6.2 (pgcrypto, column encryption, Try It Yourself 6.3, Fix It 6.1) | `sandwash_clinic` | `setup-sandwash.sql` |
| Section 6.2 (password hashing, Try It Yourself 6.2) | `harquahala_academy` | `setup-harquahala.sql` |
| Section 6.3 (TLS reading, `clinic_billing_app`, Try It Yourself 6.4) | `sandwash_clinic` | `setup-sandwash.sql`, `make-server-cert.sh`, `tls-config-excerpt.conf` |
| Section 6.4 (cost measurements) | `sandwash_clinic` | `setup-sandwash.sql` |
| Skills Lab 6A | `harquahala_academy` | `setup-harquahala.sql`, `make-server-cert.sh`, `tls-config-excerpt.conf`, `skills-lab-6a.sql`, `skills-lab-6a-answers.md` |

Rerunning `setup-sandwash.sql` restores the plaintext
`insurance_member_id` column, so you can run Try It Yourself 6.3 again
from the start. Rerunning `setup-harquahala.sql` restores the
placeholder password hashes and the plaintext guardian contacts.

## Keys and certificates

No file in this folder holds a private key, a column key, or a lookup
key. The chapter's passphrases (`Sandwash-Ch6-ColumnKey-2026!` and the
others) are visibly fake teaching values. Replace them with your own in
the lab, keep them out of your submission, and never commit
`server.key` to a repository.

## Fictional data

Copperwind IT Services, Sandwash Family Clinic, and Harquahala Charter
Academy are fictional organizations created for this textbook. All
names, patients, students, staff, and records are synthetic. Any
resemblance to a real organization or person is coincidental.
