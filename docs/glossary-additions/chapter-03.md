# Glossary additions: Chapter 3

Terms bolded on first use in `book/chapters/chapter-03.md`, in the
definition-list format, alphabetical. The maintainer merges these into
`book/glossary.md` under the matching letter headings. `integrity`,
`control`, `least privilege`, and `role` already exist from Chapter 1
and are not repeated here.

ACID
:   The four guarantees a transaction makes: atomicity (all or nothing), consistency (constraints hold when it ends), isolation (concurrent transactions do not see each other's unfinished work), and durability (a committed change survives a crash).

Big Data
:   Datasets too large, too fast, or too varied for one server and one schema, spread across many machines. The traditional test is volume, velocity, and variety. Every copy across those machines is a place confidentiality can fail.

CHECK constraint
:   A constraint that holds any true-or-false condition on a row, such as a status drawn from a fixed list or a date in the past. The database refuses any insert or update that makes the condition false.

document store
:   A NoSQL database that keeps each record as a self-contained JSON document with fields that can differ from record to record. It trades constraints, joins, and fine-grained access control for flexibility.

functional dependency
:   A relationship in which one column's value determines another's, such as a patient determining a phone number. Third Normal Form requires every non-key column to depend on the table's key and nothing else.

integrity constraint
:   A rule the database checks on every insert and update and refuses to break. The five types are PRIMARY KEY, FOREIGN KEY, UNIQUE, NOT NULL, and CHECK. Constraints run on every path into a table, not only through the application.

JSONB
:   PostgreSQL's binary JSON column type. A document is parsed once at insert time and stored in a searchable form, so semi-structured data can live inside a row whose other columns stay under constraints.

lost update
:   A concurrency failure in which two transactions each read the same state, each act on it, and each commit, so one change silently overwrites or duplicates the other. A double booking is a lost update. A constraint checked at commit time prevents it.

materialized view
:   A view whose query result is stored as real rows on disk. Reads are fast, and the rows are only as current as the last REFRESH MATERIALIZED VIEW, so the refresh schedule is a decision to write down.

normalization
:   Organizing tables so that each fact is stored once, in the table whose key determines it. The management payoff is one constraint, one GRANT, one column to encrypt, and one row to delete per fact.

NoSQL
:   A family of databases that drop the fixed-table relational model: document stores, key-value stores, wide-column stores, and graph databases. Each trades away some integrity or access-control features for flexibility or scale.

reporting workload
:   A pattern of few large reads that scan many rows and can take time, such as a monthly rollup by provider. It wants the data joined and summed, in a shape built from the normalized tables.

semi-structured data
:   Records that share a core of fixed fields and then vary, such as an intake form whose questions change every quarter. The fixed part belongs in constrained columns and the variable part in JSONB.

staging table
:   A temporary landing table with no constraints that holds an import exactly as it arrived, so the data can be inspected with queries before anything trusts it. It is dropped once the load is proven.

surrogate key
:   A system-generated identifier with no business meaning, used as a primary key so that it never has to change when a name, a phone number, or any other business attribute does.

Third Normal Form (3NF)
:   The design state in which every non-key column depends on the key, the whole key, and nothing but the key. Meeting it removes update anomalies and gives each fact one place to be guarded.

transaction
:   A group of SQL statements that either all take effect or all fail together, bounded by BEGIN and COMMIT or ROLLBACK.

transactional workload
:   A pattern of many small reads and writes, each touching a few rows and each needing to finish now, such as a front desk booking one appointment. Normalized tables with constraints serve it.

update anomaly
:   The result of storing one fact in more than one row: the fact is changed in one place and not the others, so the data disagrees with itself. Normalization removes it by storing the fact once.

view
:   A named query that behaves like a table but stores no rows. It fixes one definition of a report and gives a reporting role a privilege boundary, since the role can be granted the view and not the tables behind it.
