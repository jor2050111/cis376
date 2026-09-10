# Glossary additions: Chapter 11

Terms bolded on first use in `book/chapters/chapter-11.md` plus the
Key Terms this chapter lists, in the definition-list format,
alphabetical. The maintainer merges these into `book/glossary.md` under
the matching letter headings.

Two terms this chapter bolds already exist and are not repeated here:
`baseline` (Chapter 1) and `configuration benchmark` (Chapter 9).

Two near-collisions the maintainer should read before merging:

* `routine` already exists as Chapter 7's event classification. This
  chapter adds `routine review`, which is a different idea. Keep both.
* `audit trail`, `auditing plan`, `audit event`, `audit controls`, and
  `access review` already exist from Chapters 5 and 7. This chapter
  adds the bare term `audit` and the three named audits. They do not
  overlap with the existing entries, which describe records rather than
  the comparison that produces them.

access audit
:   The audit that compares the privileges a server grants and the accounts it holds against the access list the data owner signed, and reports every difference in both directions.

audit
:   A comparison of what a review measured against a stated standard, reporting every difference. A review produces numbers, and an audit judges those numbers against the list, the plan, or the regulation they are supposed to match.

before-and-after report
:   A report that pairs a metric's value from before a control was adopted with its value afterward, states the change, and names the direction that counts as an improvement for each metric.

capture
:   One run of a review's metric set, stored in the review archive with the date it was taken, so it can be compared against any other run.

compliance audit
:   The audit that collects the evidence a regulation or an internal policy requires, each item recorded with the query output or file that produced it and the date it was produced.

control family
:   A group of related security controls in a framework, named by a short code such as AC for access control or AU for audit and accountability, so an organization can plan and report across products.

control framework
:   A published catalog that organizes security controls into families for planning and reporting across a whole information system, such as NIST Special Publication 800-53. A framework spans products, while a benchmark hardens one.

managed audit log service
:   A cloud service that collects database logs into storage the database's own administrators cannot quietly edit, and applies its own retention rules to them.

managed secret service
:   A cloud service that stores application credentials outside the application, releases them to authorized callers on request, and rotates them on a schedule without taking the application down.

managed key service
:   A cloud service that holds encryption keys in hardware, rotates them on a schedule, and records every use, so key custody sits outside the database that the keys protect.

metric set
:   The fixed list of measurements a routine review takes, defined once (in PostgreSQL, as a view) so that every run measures the same things the same way no matter who runs it.

OWASP
:   The Open Worldwide Application Security Project, a nonprofit that publishes free application and database security guidance, including the cheat sheet series this book cites.

performance audit
:   The audit that compares the current cost of the work against the last capture, using execution plans, the index inventory, table sizes, and index-usage counters.

privilege drift
:   The slow accumulation of privileges that nobody approved, caused by grants made under pressure and never revoked. Drift moves in one direction unless an access audit checks for it.

quantifiable metric
:   A number taken the same way before and after a change, which moves when the control works and stays put when it does not. A usable metric is specific, stable, cheap to collect, and responsive to the control it measures.

review archive
:   A durable table that stores one row per metric per run of a routine review, so any two runs can be joined and change over time becomes visible instead of remembered.

review calendar
:   The schedule that names how often each review and audit runs, who owns it, what evidence it produces, and where that evidence is filed.

routine review
:   A fixed set of measurements taken on a fixed schedule, whether or not anything looks wrong. It needs three things to stay a routine: a fixed metric set, a durable archive, and a calendar.

security posture service
:   A cloud service that scores a database's configuration against a published benchmark on a schedule and opens a finding for each control that fails.
