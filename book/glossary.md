# CIS376 Glossary

This glossary defines every technical term used in the CIS376 textbook. Each chapter bolds a term at first use, and the Key Terms list at the end of each chapter points you here for review. Every chapter uses these exact definitions.

## A

access control matrix
:   A table that lists each role against each protected object and states the privilege the role holds on it.

availability
:   The property that authorized users can reach data and systems when they need them. An outage is an availability failure even when nothing leaks.

## B

baseline
:   A measurement taken while a system is healthy (size, version, roles, response time) so later readings can show what changed.

## C

CIA triad
:   The three properties every protected system must preserve: confidentiality, integrity, and availability. Every database threat attacks at least one of them.

cluster
:   One running PostgreSQL server, which holds many databases. Roles and server settings belong to the cluster, not to any one database.

confidentiality
:   The property that only authorized people and programs can read data, through queries, exports, backups, logs, or network traffic.

control
:   A safeguard that reduces the likelihood or the impact of a threat. Controls come in families such as access control, encryption, auditing, and backup.

## D

data owner
:   The business leader accountable for a dataset, who decides who has a legitimate need to see it. The DBA implements that decision and proves it took effect.

database administrator (DBA)
:   The person who installs, configures, monitors, backs up, tunes, and recovers a DBMS and who implements access decisions made by data owners.

database management system (DBMS)
:   The software that stores data, enforces rules about it, controls who may reach it, logs activity, and recovers it after failure. PostgreSQL, Oracle Database, MySQL, and SQL Server are all DBMS products.

## E

## F

## G

## H

## I

integrity
:   The property that data is correct and complete and that every change to it is authorized and recorded.

## J

## K

## L

least privilege
:   The rule that every account receives the minimum access its work requires and nothing more.

## M

managed database service
:   A cloud offering in which the provider installs, patches, backs up, and replicates the DBMS while the customer keeps every decision about data, access, and retention.

management lifecycle
:   The five-stage loop this book follows: Plan, Secure, Monitor, Recover, Review. Each stage maps to one course outcome.

meta-command
:   A psql instruction that begins with a backslash, such as `\l` or `\dt`. Meta-commands are handled by the client and are not SQL.

## N

## O

## P

pgAdmin
:   The graphical client for PostgreSQL, used to browse objects, read execution plans, and inspect privileges.

PostgreSQL
:   The free, open-source DBMS this book uses as its lab server. Version 17 is the course target.

psql
:   PostgreSQL's command-line client. Every script and captured output in this book runs through it.

## Q

## R

role
:   A PostgreSQL account that can be a user (a role that can log in), a group (a role that holds privileges for others), or both.

## S

security administrator
:   The person who sets access policy, reviews privileges, watches logs for misuse, and leads the response when a control fails.

separation of duties
:   The principle that no single person should be able to request access, grant it, use it, and erase the record of having done so.

superuser
:   A PostgreSQL role that bypasses every permission check. Used to build the lab and then set aside.

## T

threat
:   Anything that could violate the confidentiality, integrity, or availability of data.

## U

## V

## W

## X

## Y

## Z
