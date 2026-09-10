# Glossary additions: Chapter 12

Terms bolded on first use in `book/chapters/chapter-12.md`, in the
definition-list format, alphabetical. Terms already in
`book/glossary.md` (data classification, data owner, de-identification,
least privilege, managed database service, shared responsibility model,
tokenization) are not repeated. Chapter 12 uses `pilot` for a limited
adoption trial, which is unrelated to any other use of the word in the
book.

confidential computing
:   A hardware-based protection that keeps data encrypted while a program computes on it, by running the work inside a processor-protected region of memory that the operating system and the hypervisor cannot read.

cost-benefit analysis
:   The comparison that weighs what an option costs over its life against what it returns, measured against the alternatives, including doing nothing.

data governance
:   The program that keeps four answers current for an organization's data: what it holds, how sensitive each piece is, who decides access, and how long it is kept.

data steward
:   The person inside a business unit who maintains the meaning of the data, including what a column means, which values are valid, and which records are authoritative.

database DevOps
:   The practice of shipping database changes the way an application ships code, in small versioned files that are reviewed before they run and applied by a tool rather than by hand.

differential privacy
:   A privacy method that adds measured noise to a published result, so that any one person's presence in or absence from the data cannot change the answer enough to be detected.

distributed SQL
:   A database that spreads one logical database across many servers, and often across regions, while still offering SQL and transactions that span the whole set.

embedding
:   A list of numbers a model produces from a piece of text, built so that texts with similar meaning produce lists that sit near each other.

evidence standard
:   The rule applied to a claim before it is allowed into a decision, which ranks sources from your own measurement down to a claim with no source named.

infrastructure as code
:   The practice of keeping server configuration in files under version control, so the configuration is reviewed, repeatable, and readable instead of remembered.

management and security plan
:   A single document that states how one organization's database is designed, protected, kept fast, recovered, and defended, with evidence recorded under each claim.

pilot
:   A limited trial of a technology with a stated scope, a stated duration, and a decision rule written before the trial starts.

privacy-enhancing technology
:   Any method that lets an organization use data while reducing what the data reveals about an individual, including de-identification, tokenization, and differential privacy.

schema migration
:   One versioned file that moves a database from one known state to the next, carrying an identifier, a description, and the statements that make the change.

skills matrix
:   A table that maps the work recorded in a management and security plan to the roles that own that work in a larger organization, citing the plan's own evidence for each row.

switching cost
:   What it would take to leave a product later, including how the data comes out, in what format, and how much work the move requires.

total cost of ownership
:   The full cost of an option over its life, including the license or hosting fee, the migration work, the training, the extra monitoring, and the staff time to run it.

trusted execution environment
:   A region of memory protected by the system processor, which the operating system and the hypervisor cannot read into. Confidential computing runs a database workload inside one.

vector search
:   A search that finds rows whose embeddings sit closest to the embedding of the question, so results are ranked by similarity of meaning rather than by matching words.

zero trust
:   A design principle that removes the idea of a trusted network location, so every request authenticates, receives only what it needs, and is logged as if it might be hostile.
