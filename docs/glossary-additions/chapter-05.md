# Glossary additions: Chapter 5

Terms bolded on first use in `book/chapters/chapter-05.md`, in the
definition-list format, alphabetical. `access control matrix` is
already in `book/glossary.md` and is not repeated here.

access review
:   The scheduled comparison of what a database server allows against what the data owner approved, recorded so the next review can measure drift from it.

connection limit
:   The maximum number of simultaneous sessions a role may hold, set with `CONNECTION LIMIT`. A cap on a service account protects availability when an application leaks connections.

default privileges
:   A standing rule, set with `ALTER DEFAULT PRIVILEGES`, that tells PostgreSQL what to grant on objects a role creates in the future. A plain `GRANT ... ON ALL TABLES` covers only the tables that exist at that moment.

drift
:   The difference between the access the data owner approved and the access the server allows, such as a forgotten account, a grant made "for now," or a policy lost when a table was rebuilt.

effective privileges
:   What a role can do once every membership it inherits is counted, as reported by `has_table_privilege()` and the other `has_*_privilege()` functions, not by the direct grants alone.

group role
:   A role that exists to hold privileges for its members. It normally cannot log in, and login roles receive privileges by becoming members of it.

inheritance
:   The rule that a member role automatically uses the privileges of the groups it belongs to, and of their groups, unless the member was created with `NOINHERIT`.

login role
:   A role with the `LOGIN` attribute, which allows a connection to start. A person and a service account are both login roles with different settings.

policy
:   A named row-level security rule attached to a table. Its `USING` expression must be true for a row to be visible to the roles the policy names.

privilege
:   A named permission on one object, held by one role, such as `SELECT` on a table, `USAGE` on a schema, or `CONNECT` on a database.

PUBLIC
:   The pseudo-role that stands for every role on the server. PostgreSQL grants it `CONNECT` on new databases and `USAGE` on the `public` schema by default.

role-based access control (RBAC)
:   The practice of granting privileges to job roles and assigning people to jobs, so that hiring and departures change memberships, not grants.

row-level security
:   A table-level control that filters which rows each role can see or change, enforced by policies that the table applies to every query from a role that is not its owner or a superuser.

SCRAM-SHA-256
:   PostgreSQL's default password scheme since version 14. The server stores a salted hash, and the challenge-response exchange never sends the password itself across the network.
