# Glossary Additions: Chapter 2

Terms bolded on first use in Chapter 2 that do not yet appear in
`book/glossary.md`. Definition-list format, alphabetical. Chapter 2
also bolds `managed database service`, which Chapter 1 already
defined, so it is not repeated here.

application tier
:   The network tier that runs business logic (the scheduling application, a reporting service, a scheduled job). It accepts connections from the presentation tier and is the only tier that should connect to the database.

authentication
:   The step that proves a claimed identity, by a password checked with SCRAM, a client certificate, or a ticket from a central directory. In PostgreSQL, `pg_hba.conf` chooses the method for each connection.

authorization
:   The step that decides what an authenticated identity may do: privileges, role memberships, and row-level security policies. It happens inside the database after authentication and is never delegated to an outside directory.

business associate agreement (BAA)
:   The written contract HIPAA requires before a covered entity may let a vendor, including a cloud provider, create, receive, store, or transmit protected health information. The vendor accepts its share of the safeguards in the agreement.

capacity planning
:   The discipline of turning measured size, growth, throughput, and usage into a hardware purchase or a cloud tier, with a date by which the estimate must be re-measured.

data tier
:   The most restricted network tier, which holds the database server. It accepts connections only from the application tier and a small set of administrative addresses, never from the internet.

firewall
:   A device or software layer that permits or drops network traffic by address, port, and direction. Firewalls between tiers keep a database reachable only from the systems that need it.

growth
:   The rate at which a database's size rises over time, measured from the data (rows added per month) and expressed as a monthly rate for projection.

host-based authentication
:   PostgreSQL's rule table, kept in `pg_hba.conf`, for deciding connection by connection whether to accept a client and how to verify its identity. Rules match top to bottom and the first match wins. A connection that matches no rule is refused.

identity
:   A name a system recognizes: a login role, a person's account, or a certificate's subject. Identity is the claim that authentication proves and authorization acts on.

identity and access management (IAM)
:   The policies and systems that establish who someone is, prove it, and control what they may do. A database participates in IAM for identity and authentication but keeps authorization to itself.

infrastructure as a service (IaaS)
:   A service model in which a cloud provider rents virtual machines, storage, and networking. The customer installs, patches, and manages the operating system and the DBMS on the rented machine.

on-premise
:   A service model in which the organization owns the hardware, the operating system, and the DBMS and runs them in a room it controls.

presentation tier
:   The network tier that faces users: web servers and portals. It is reachable from the internet, is assumed to be attacked, and must never hold a database.

security tier
:   A group of systems that share the same exposure and the same rules about who may connect to them. Also called a zone. The classic layout has presentation, application, and data tiers separated by firewalls.

service account
:   A login role used by an application or a scheduled job instead of a person. Each service gets its own role, its own connection rule, and no human users.

service model
:   The arrangement that decides which parts of a database system an organization operates and which parts a provider operates: on-premise, infrastructure as a service, or a managed database service.

shared responsibility model
:   The cloud rule that the provider secures the cloud and the customer secures what they put in it. Where the line falls depends on the service model. Roles, privileges, data classification, retention, and key ownership stay with the customer under every model.

single sign-on (SSO)
:   An arrangement in which a person proves identity once to a central service and every other system accepts that proof. PostgreSQL can accept it through methods such as `ldap`, `gss`, and `cert`, but the role and its privileges must still exist inside the cluster.

size
:   The number of bytes a database or table occupies today, including indexes and overflow storage, as reported by `pg_database_size()` and `pg_total_relation_size()`.

throughput
:   The amount of work a server handles per unit of time, such as rows inserted per hour or queries per second. PostgreSQL keeps cumulative counters in `pg_stat_user_tables` and `pg_stat_database`.

usage
:   When the load arrives and who generates it. Usage analysis finds the peak hour, day, or season a server must be sized for.

working set
:   The part of a database that daily queries touch. A server whose memory holds the working set answers most queries without reading disk.
