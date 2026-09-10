#!/bin/sh
# Chapter 6, Section 6.3: make a self-signed server certificate for
# your own PostgreSQL lab server.
#
# Run this from your server's data directory (SHOW data_directory;
# in psql tells you where it is), then set ssl = on in postgresql.conf
# and restart. The key file must be readable by the server's account
# only, or PostgreSQL refuses to start.
#
# This script generates a NEW key on your machine. The data pack ships
# the command, never a key. Do not copy server.key anywhere else.

openssl req -new -x509 -days 365 -nodes -text \
  -out server.crt -keyout server.key \
  -subj "/CN=copperwind-lab"
chmod og-rwx server.key

# Read back what you made. The subject is the name the certificate
# claims, and sslmode=verify-full compares it with the host name you
# connect to.
openssl x509 -in server.crt -noout -subject -dates
