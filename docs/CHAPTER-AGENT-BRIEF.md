# Chapter Author Brief (read before writing any chapter)

You are writing one chapter of the CIS376 textbook. Chapter 1 is
finished and is the exemplar for voice, structure, block formats, and
verified output. Match it.

## Read first, in this order

1. `CLAUDE.md` (project law, style, locked counts, icons)
2. `docs/book-design-spec-2026-09-09.md` (spine, data, YOUR chapter's
   row in Section 4, block formats in Section 5, SQL conventions,
   QA protocol)
3. `docs/part-structure.md` (YOUR chapter's sections, MLOs, Skills
   Lab, CLOs, and the neighbors before and after it)
4. `docs/CIS376_CLOs.md` (quote the elevated CLO lines verbatim)
5. `docs/style-guide.md` and `docs/style-guide-core.md`
6. `book/chapters/chapter-01.md` (the exemplar) and `templates/chapter-template.md`
7. `assets/code/data/README.md` and `assets/code/_generators/generate_course_data.py`
   (exact table and column names)

## What you deliver

1. `book/chapters/chapter-NN.md`: 600-700 lines, the full N.1-N.7
   anatomy, exactly the counts in spec Section 3.1, every `sql` block
   verified through the harness with `-- Output:` lines filled from
   the log.
2. `assets/code/chapter-NN/README.md`: contents table, the load
   command, which parts use which files, and the fictional disclaimer
   verbatim (spec Section 1.4).
3. `assets/code/chapter-NN/skills-lab-Na.sql` and
   `skills-lab-Na-answers.md` starters (copy the Chapter 1 pattern).
4. Any chapter-specific fixture the spec assigns you (a starter
   `pg_hba.conf`, a scan report, a backup dump, a benchmark checklist,
   a plan template). Fixtures are files students read or load. Keep
   them small and fictional.
5. If your chapter needs a different starting state than the base
   setup script provides (schemas already separated, roles already
   created), edit YOUR chapter folder's `setup-<org>.sql` and put
   `-- CHAPTER-SPECIFIC: do not regenerate` on line 1. Never edit
   another chapter's folder or `assets/code/data/`.
6. `docs/glossary-additions/chapter-NN.md`: every term you bold on
   first use, in the definition-list format
   (`term` on one line, `:   definition` on the next), alphabetical.
   Do NOT edit `book/glossary.md` yourself. Other agents are writing
   at the same time and the maintainer merges the additions.
7. For fading level B or C (chapters 5-12): the reference solution in
   `docs/execution-logs/chapter-NN-reference.sql`, run through the
   harness (as a scratch chapter) so its output is real.
8. `docs/execution-logs/chapter-NN.log` (the harness writes it).

## The verification workflow (mandatory)

```bash
python3 tools/run_chapter_sql.py book/chapters/chapter-NN.md   # zero failures
python3 tools/fill_sql_outputs.py book/chapters/chapter-NN.md  # pastes captured output under each -- Output: marker
python3 tools/check_sql_outputs.py book/chapters/chapter-NN.md # zero mismatches
python3 tools/check_course_structure.py book/chapters/chapter-NN.md  # zero errors
python3 tools/check_sentence_length.py book/chapters/chapter-NN.md   # zero flagged
python3 tools/check_readability.py | grep chapter-NN            # 60-70 (55 floor for ch 4 and 10)
.venv/bin/zensical build --clean                                # "No issues found"
```

Plus the sweeps: no em dash (U+2014), no semicolon in prose (SQL
statements are exempt), none of the banned words or filler in
`docs/style-guide-core.md`, no "real-world", "soft skills", or
"prepare you for". Verify every Further Reading URL with
`curl -sIL <url> | head -1` (200 or 3xx to a 200). Prefer PostgreSQL
docs, NIST, HHS, ED.gov, OWASP, CIS.

Every `-- Output:` line in the chapter must come from the harness.
Write the marker, run the harness, run the fill tool, then READ the
pasted output and make sure the prose around it describes it
truthfully. If the output is not what you expected, fix the query or
the prose, never the output. Fix It errors are captured the same way:
run the broken statement through a scratch chapter and paste the final
`ERROR:` line. Never invent an error message.

## Cluster etiquette

Other chapter agents run at the same time on the same local PostgreSQL
cluster. The harness holds a lock while it runs, rebuilds the three
databases from YOUR chapter's setup scripts, and leaves them in your
chapter's end state. Do not assume that state survives: another agent
may rebuild a moment later. Therefore:

* Do every verification through the harness. For exploration, write a
  scratch file named `chapter-NN.md` (your number) in a scratch
  directory, put `sql` fences in it, and run the harness on it. The
  harness picks the setup scripts by the chapter number in the file
  name.
* If you must run `pg_dump` or another command against a live
  database, wrap it: `python3 tools/locked.py -- sh -c '...'` and
  rebuild inside that same shell with plain `psql -f` on the chapter's
  setup script, then dump. Never call the harness inside `locked.py`:
  both take the same lock and the pair deadlocks (it happened in wave
  one and stalled two other agents).
* Never paste `\du`, `\l`, or `\dt` output that shows owners or roles
  from the author's cluster. Use catalog queries filtered to the
  course prefixes (`copperwind_`, `clinic_`, `academy_`).
* Every role you create carries the organization prefix so the
  harness can clean it up.

## Things that fail review

* An MLO without a `(Section N.X)` binding, or with a Remember or
  Understand verb.
* A Try It Yourself missing any of the three labels, or numbered out
  of reading order.
* A Fix It with an invented error, or with Predict/Run/Explain labels.
* Gapped code (`____`) in a `sql` fence. Gaps live in `text` fences.
* A configuration change with no verifying query after it.
* Course pacing language ("this week", "before the midterm").
* A dependency on another chapter's saved work.
* Real company, hospital, or school names anywhere except Further
  Reading and standards bodies.
* Passwords reused across chapters, or any password that looks real.
* Reteaching SQL. One bridging sentence, then the management or
  security decision.

## Reporting back

When you finish, report: the line count, the harness result (blocks,
failures), the structure checker result, the sentence and readability
numbers, the list of files you created, the glossary terms you added,
the Fix It error you captured (verbatim), any URL that failed
verification and what you replaced it with, and anything you were
unsure about. Do not commit. The maintainer reviews and commits.
