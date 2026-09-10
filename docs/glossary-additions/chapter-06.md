# Glossary Additions: Chapter 6

Terms bolded on first use in `book/chapters/chapter-06.md`, in the
definition-list format, alphabetical. The maintainer merges these into
`book/glossary.md`.

asymmetric encryption
:   Encryption with a key pair. What the public key encrypts only the private key can decrypt. It is slow, so it carries key exchange and identity (the TLS handshake and the server certificate), never the data itself.

bcrypt
:   A password hashing algorithm, selected in `pgcrypto` with `gen_salt('bf')`, that salts every hash and runs deliberately slowly. Its cost factor raises the work per hash as hardware gets faster.

certificate
:   A server's public key wrapped with its name and a signature from a party the client trusts. Under TLS the client checks it to confirm it reached the intended server.

ciphertext
:   Data after encryption. Unreadable without the key, and what an unauthorized reader of a disk, backup, or network gets.

column-level encryption
:   Encrypting one column's values inside the table with `pgcrypto`, so a reader with `SELECT` on the column gets ciphertext and only a holder of the key gets the value. It protects the column in every backup and export.

cost factor
:   The bcrypt parameter that sets how much work one hash takes. Each step up roughly quadruples the time, which a login pays once and an attacker pays for every guess.

data at rest
:   Data in storage: the data directory, write-ahead log files, backups, exports, and logs. Each is a file that can be copied without asking any role for permission.

data in motion
:   Data crossing a network between client and server. Without TLS, every statement and every returned row is readable by a listener.

encryption
:   Transforming readable data into a form that cannot be read without a key. It decides what an unauthorized reader gets once access control has been bypassed.

encryption key
:   The secret that turns plaintext into ciphertext and back. Algorithms are public, so the key is the only secret and protecting it is most of the work.

hash function
:   A function that turns any input into a fixed-length fingerprint that cannot be reversed. Used to check a password without storing it and to detect that a value changed.

key management
:   The decisions about where each key lives, who can reach it, and how it is replaced. A key stored beside the data it protects is a label, not a lock.

key rotation
:   The scheduled replacement of an encryption key: decrypt with the old key, encrypt with the new, verify the round trip, retire the old key. Planned before the first row is encrypted.

keyed hash
:   A hash that mixes in a secret key (`hmac()` in `pgcrypto`), so only a key holder can compute the fingerprint. It repeats for the same input, which makes it indexable, and cannot be reversed.

lookup hash
:   A keyed hash stored beside an encrypted column so a query can find a row by value without decrypting the table. The encrypt-then-query pattern's second column.

pgcrypto
:   The PostgreSQL extension that provides hashing (`digest()`), keyed hashing (`hmac()`), salted password hashing (`crypt()` with `gen_salt()`), and symmetric encryption (`pgp_sym_encrypt()` and `pgp_sym_decrypt()`) as SQL functions.

plaintext
:   Data anyone can read. The state of a column before encryption and the state every authorized reader needs it in.

salt
:   A random value mixed into each hash so two identical passwords produce different fingerprints and an attacker cannot precompute a table of answers. bcrypt stores the salt inside the hash string.

self-signed certificate
:   A certificate signed with its own private key instead of by a certificate authority. It encrypts the session fully but cannot prove the server's name to a client that has not been given a copy to trust.

sslmode
:   The client connection parameter that sets whether TLS is required and whether the server certificate is checked. The default, `prefer`, falls back to plain text silently. `verify-full` is the only mode that stops an impostor.

symmetric encryption
:   Encryption that uses one key to encrypt and the same key to decrypt. Fast and unlimited in size, so it does the heavy lifting for volumes, columns, and TLS sessions. Its weakness is delivering the key.

TLS
:   Transport Layer Security, the protocol that encrypts a connection. An asymmetric handshake agrees on a symmetric session key and presents the server's certificate. In PostgreSQL, `ssl = on` enables it and `hostssl` rules require it.

tokenization
:   Replacing a value with a random token and keeping the mapping in a separate, harder-to-reach store. Suits values that are looked up but never computed on.

volume encryption
:   Encrypting a whole disk or file system below the database, done by the operating system or a cloud provider. It stops whoever holds the drive and does nothing against a reader who can log in to the running server.
