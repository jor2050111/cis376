# CIS376 Textbook Development - Claude Code Project Context

**Project Name:** CIS376 - Database Management and Security Textbook
**Purpose:** Plan, secure, monitor, and recover PostgreSQL databases that meet business and regulatory requirements, from architecture through incident response.
**Target Audience:** community college students who have completed one SQL course and are moving into database administration and security
**Prerequisites:** One prior SQL course (Introduction to Oracle: SQL, CIS276DA MySQL Database, or CIS276DB SQL Server Database)
**Primary Tools:** PostgreSQL 17, psql, pgAdmin 4, SQL

## Task Management

- Use CLAUDE_CODE_TASK_LIST_ID=cis376-spring27
- When not using Remote Control, reference active-tasks.md on
  Google Drive (co-professor/_SYSTEM/) for cross-device task state
- All global rules apply (see ~/.claude/CLAUDE.md)

## Shared Files: Synced, Never Hand-Edited

The textbook family shares one set of canonical support files in
`../shared/`. The sync script (`../shared/tools/sync-shared.sh`) copies
them into this repo:

- `book/stylesheets/colors.css` and `book/stylesheets/brand.css`
  (design tokens and theme mapping)
- `.github/workflows/docs.yml` (build and deploy workflow)
- Lint configuration
- `tools/` QA scripts (sentence length, output comments, chapter code runs).
  This course adds its own SQL tools beside them: `run_chapter_sql.py`,
  `check_sql_outputs.py`, `check_course_structure.py`,
  `check_readability.py`. Those four are course-owned, not synced.
- The style-guide core, synced to `docs/style-guide-core.md`
  (`docs/style-guide.md` is the course-specific layer on top of it)

One reference is seeded once at setup rather than synced:
`docs/blooms-taxonomy-reference.md` starts as a copy of
`../shared/blooms-taxonomy-reference.md` and then adapts its examples
to this course.

Never edit the synced copies in this repo. Edit the canonical file in
`../shared/`, then re-run the sync script so every textbook updates
together.

## Project Structure

```
textbooks/cis376/       # local folder = GitHub repo: cis376
├── CLAUDE.md                          # This file - project context
├── README.md                          # Human-readable project overview
├── zensical.toml                      # Zensical site config (docs_dir = book)
├── requirements-docs.txt              # Pinned Zensical version for builds
├── .github/
│   └── workflows/
│       └── docs.yml                   # Build + deploy to GitHub Pages (synced)
├── .vscode/
│   └── settings.json                  # Workspace settings
├── book/                              # PUBLISHED textbook (single source of truth)
│   ├── index.md                       # Site home page
│   ├── glossary.md                    # Published glossary
│   ├── skills-lab-rubric.md               # Universal Skills Lab rubric (synced)
│   ├── chapters/
│   │   └── chapter-01.md ... chapter-12.md
│   ├── stylesheets/
│   │   ├── colors.css                 # Design tokens (synced)
│   │   └── brand.css                  # Token mapping onto Zensical theme (synced)
│   └── assets/
│       └── images/screenshots/        # Site images referenced by chapters
├── assets/
│   └── code/                          # Student data pack (labs load from here)
│       ├── chapter-01/ ... chapter-12/
│       └── _generators/               # Seeded synthetic-data scripts
├── templates/
│   ├── chapter-template.md
│   ├── skills-lab-rubric-template.md
│   ├── try-it-yourself-template.md
│   └── exercise-template.md
├── tools/                             # QA scripts (synced)
├── docs/                              # Authoring/dev references (NOT published)
│   ├── CIS376_CLOs.md          # Authoritative course reference
│   ├── part-structure.md              # 12 chapters in 4 Parts
│   ├── style-guide.md                 # Course layer over the synced core
│   ├── style-guide-core.md            # Synced from ../shared/
│   └── blooms-taxonomy-reference.md   # Seeded from ../shared/ at setup
└── site/                              # Zensical build output (gitignored)
```

## Writing Standards: Em Dash Policy

Em dash policy for all student-facing and textbook prose, headings, and
code comments:

Do not use em dashes ("—", U+2014). When you would reach for one, look at
what comes immediately after the dash position and choose by grammar, not
habit:

1. A complete sentence follows -> end with a period and start a new
   sentence. This is the DEFAULT and it raises Flesch Reading Ease toward
   my 60-70 target.
2. A phrase that renames the noun just before it (an appositive) -> use a
   comma.
3. You are spelling out or itemizing what a term means, and a period would
   read as choppy (common inside bullets) -> use a colon.
4. The clause could be lifted out without breaking the sentence -> use
   parentheses.

Headings and titles: replace the em dash with a colon.
Example: "Try It Yourself 9.2 — Interpreting P-Values" becomes
"Try It Yourself 9.2: Interpreting P-Values".

Constraints:

- Never replace an em dash with a hyphen.
- I do not use semicolons in my natural voice so avoid those. (This
  supersedes any older note that allowed semicolons.)
- Vary the choice across a passage so one mark does not dominate.
- If a bullet already opens with a colon, do not stack a second colon; use
  a period instead.

Do not touch: hyphens in ranges ("4-5 hours"), minus signs and negative
numbers ("r = -1.0"), hyphenated compounds ("chi-square"), or anything
inside fenced code blocks or inline code.

## Writing Standards: Sentence Length

* Watch sentence length while drafting, not after. Split any prose
  sentence that reaches about 35 words, and keep typical sentences
  well under 30. This applies to chapter prose, lab tasks, review
  questions, and summary bullets. Headings, tables, and code are
  exempt.
* Approved split patterns: parallel sentences for roadmaps
  ("You will X. You will Y."), a colon plus a short series for
  itemization, a bulleted checklist when the sentence is secretly a
  habit list (which also fits Canvas), and a period at the natural
  clause seam everywhere else.
* Flesch Reading Ease target for this course: 60-70. CIS376 is a
  300-level course, so chapters 4 and 10 (regulation-heavy vocabulary:
  HIPAA, FERPA, breach notification) may land as low as 55. Every
  other chapter aims for 60-70. Any chapter may land slightly above
  55 when the author's educator judgment says the section's
  vocabulary calls for it, and the chapter report must say so.
  Confirmed by Mr. Vega 2026-09-09.
* Run `python3 tools/check_sentence_length.py book/chapters/chapter-NN.md`
  with the style sweeps. It flags prose sentences at 35 words or more.

## Critical Writing Standards

### CHAPTER LENGTH AND SCOPE (CRITICAL!)

**Each chapter targets ~600 lines of markdown (approximately 20 readable pages).**

**Course Structure:**

- **12 chapters** organized into 4 thematic Parts (see docs/part-structure.md)
- Schedule-neutral. Course calendars, due dates, and exams live in
  the Canvas shell, never in a chapter (family gate G2).

**Scope Guidelines:**

- **4-5 main sections** (H2 headings) maximum
- **2-4 subsections** (H3) per main section
- **8-15 code examples** total per chapter
- **Code example length for this course:** typical SQL examples run
  3-20 lines. A configuration excerpt (`postgresql.conf`,
  `pg_hba.conf`) may reach 15 lines when the whole excerpt is the
  point. Prefer the shortest example that teaches the decision.
- **One Skills Lab** with three parts (replaces separate exercises)
- **Depth matches the audience:** build on what community college students who have completed one SQL course and are moving into database administration and security already know
- **Focus on WHY and WHEN:** teach decision-making, not just syntax

**What to AVOID:**

- Reteaching prerequisite content (reference it, do not repeat it)
- Skipping directly to complex topics without bridging from prerequisite knowledge
- Exhaustive reference coverage (focus on decision-making)
- Trying to cover every possible technique for a topic

### Voice and Tone

- **Voice:** Second person ("you") for direct engagement
- **Tone:** Collegial and professional, treating students as emerging practitioners
- **Technical level:** Assumes One prior SQL course (Introduction to Oracle: SQL, CIS276DA MySQL Database, or CIS276DB SQL Server Database)
- **Avoid:** Academic passive voice, overly formal language, condescending explanations of basics
- **NEVER use em dashes.** Apply the four-way rule in "Writing Standards: Em Dash Policy" above (period, comma, colon, or parentheses, never a semicolon)

### Chapter Structure Requirements (QM-Aligned Hybrid Structure)

Every chapter MUST follow this structure:

1. **Chapter Title** (H1) - `# Chapter N: [Title]`
2. **Narrative Introduction** - 2-3 engaging paragraphs setting context with an industry scenario
3. **Module Overview** - Time estimate, prerequisites, deliverables (QM Standard 3)
4. **Learning Objectives** - Exactly 3 MLOs with decimal numbering and RBT tags, followed by the CLO alignment block (this chapter's aligned CLOs, quoted verbatim from docs/CIS376_CLOs.md)
5. **Main Content Sections** - 4-5 numbered sections (N.1, N.2, etc.) with:
   - **Try It Yourself** exercises (Predict-Run-Explain pattern)
   - **Quick Checks** (2-3 retrieval questions after each major section)
6. **Summary and Retrieval** - Key concepts + Key Terms list + Retrieval Practice prompts
7. **Skills Lab** - Single multi-part project with the shared universal rubric
8. **Review Questions** - 4 questions at varying cognitive levels
9. **Further Reading** - 3-6 external resources
10. **Looking Ahead** - 2-3 sentences previewing next chapter (the final chapter instead ends with "Course Conclusion: Where You Go from Here", no icon)

**CRITICAL PEDAGOGICAL COMPONENTS:**

- **Decimal Numbering:** Sections use format N.1, N.2, N.3, etc.
- **Predict-Run-Explain:** Active learning pattern forcing predictions before answers
- **Quick Checks:** Spaced retrieval practice throughout chapter (not just at end)
- **Skills Lab:** Authentic assessment with the locked rubric, not isolated exercises

### Decimal Section Numbering

**All main content sections use decimal numbering format: N.1, N.2, N.3, etc.**

**Reserved section numbers (the same across every textbook in the family):**

- N.1 through N.4: Main content sections
- N.5: Summary and Retrieval (always, physically before the lab)
- N.6: Skills Lab (always)
- N.7: Review Questions (always)

### Learning Objectives Format

**Requirements:**

- Exactly 3 Module Learning Objectives (MLOs) per chapter
- Use Bloom's Taxonomy action verbs
- **Bloom's focus for this course:** Apply through Create. CIS376 is
  a 300-level course with a SQL prerequisite. Every chapter carries at
  least one Analyze or Evaluate MLO. Remember and Understand never
  appear as MLO levels. Every MLO uses a measurable action verb and
  ends with its teaching-section binding, `(Section N.X)` or
  `(Sections N.X-N.Y)`. The same rule is recorded in
  docs/part-structure.md.
- Format: `**N.Y (Bloom's Level):** [Verb] [measurable outcome]`
- N = chapter number, Y = sequential MLO number (1, 2, 3)
- Start with: "By the end of this chapter, you will be able to:"

**Example:**

```markdown
## Learning Objectives 🎯

By the end of this chapter, you will be able to:

* **1.1 (Apply):** [Verb] [measurable outcome]
* **1.2 (Analyze):** [Verb] [measurable outcome]
* **1.3 (Evaluate):** [Verb] [measurable outcome]
```

**Alignment Requirements:**

- Each MLO must map to a specific section number (N.1, N.2, etc.)
- Skills Lab parts must explicitly align with MLOs (e.g., "Aligns with Objectives 1.1 and 1.3")
- MLO numbers enable assessment traceability
- After the MLO list, add `### This chapter aligns with the following Course Learning Outcomes` with this chapter's aligned CLOs (usually 1-3), quoted verbatim from the mapping table in docs/CIS376_CLOs.md. No heading icon.

**Bloom's Taxonomy Action Verbs:**

See `docs/blooms-taxonomy-reference.md` (synced from ../shared/) for the
verb lists at every level. Pull verbs from the course's target levels.

### Module Overview (QM Standard 3)

Every chapter must include a Module Overview section immediately after the narrative introduction:

```markdown
## Module Overview 🧭

* **Estimated time:** 4-5 hours
* **Prerequisites:** One prior SQL course (Introduction to Oracle: SQL, CIS276DA MySQL Database, or CIS276DB SQL Server Database), [specific chapter dependencies]
* **Deliverables:** Skills Lab NA deliverable, Quick Checks
```

### Try It Yourself Exercises (Predict-Run-Explain Pattern)

**Format:**

```markdown
### Try It Yourself N.X: [Descriptive Title] 🛠️

**Predict:** [Question requiring prediction/guess before executing]
**Run:** [Execute code, observe result, or discuss]
**Explain:** [Why did this happen? Justify in 1-2 sentences]
```

**Guidelines:**

- Embed 1-2 "Try It Yourself" exercises per major section
- Keep tasks quick (3-7 minutes each)
- Focus on decision-making, not just syntax
- Prediction step is MANDATORY

### Quick Checks (Spaced Retrieval Practice)

**Format:**

```markdown
### Quick Check N.X ✅

1. [Question at a course-target Bloom's level - use concept in new context]
2. [Question at a course-target Bloom's level - compare or evaluate approaches]
```

**Placement:**

- Add Quick Check after each major section (N.1, N.2, N.3, N.4)
- Typically 2-3 questions per Quick Check

### Skills Lab Format (Replaces Traditional Exercises)

**Structure:**

```markdown
## N.6 Skills Lab NA: [Project Title]

**Goal:** [One sentence describing an authentic task]
**Dataset:** [Provided file(s) in assets/code/chapter-NN/. Name the file and its source. Students load it, never hand-type it.]

### Part 1: Foundation (Aligns with Objective N.1)
[Tasks all students complete - builds on prerequisite skills]

### Part 2: Application (Aligns with Objectives N.1 and N.3)
[Intermediate synthesis requiring judgment]

### Part 3: Extension (Aligns with Objectives N.2 and N.3)
[Advanced/creative problem-solving - may involve presentation or stakeholder communication]

### Questions & Analysis 🤔

[Exactly 2 critical-thinking questions tied to the lab tasks and MLOs. Placed after Part 3, before Submission. Students answer in the written sections of the deliverable. The answers carry significant rubric weight.]

**Submission:** [Format and requirements]
```

**Rubric (single-source, shared by every textbook in the family):**

Every Skills Lab uses ONE universal rubric: a 4-criterion, 5-level
table (levels scored 4 down to 0 as a reference scale, never as a
course point total). The canonical
master is `../shared/skills-lab-rubric.md`. The sync script
(`../shared/tools/sync-shared.sh`) copies it to
`book/skills-lab-rubric.md`, a published page in the site nav. Never
hand-edit the synced copy, and never paste or reword the table inside
a chapter. Edit the master, then re-run the sync so every book updates
together.

How chapters reference it:

- Chapter 1 displays the full rubric by transcluding it at build time
  with the snippet include `--8<-- "skills-lab-rubric.md:rubric"`
  (pymdownx.snippets is enabled in zensical.toml).
- Chapters 2-12 use a short reference block that links to the rubric
  page. Copy the pattern from any existing chapter or from
  `templates/skills-lab-rubric-template.md`.

The four criteria, in order:

- **Technical Accuracy and Efficiency**
- **Output Quality**
- **Documentation Quality**
- **Analysis, Interpretation, and Response to QUESTION(s)**

Levels are Mastery (4), Proficiency (3), Developing (2), Emerging (1),
Not Evident (0). "A note on points" sits inside the snippet block
BEFORE the table. It says the numbers are a reference scale, the
instructor sets point values per course, and students read the
syllabus and the Canvas rubric for their values. No chapter or rubric
page states a point total (no "16 points", no "40 points"). Mr. Vega
ruled this on 2026-09-08 after students asked why Canvas showed 40
points.

**Key principles:**

- All parts use the SAME dataset (builds progressively)
- Part 1 required for all students
- Part 3 can stretch into stakeholder communication
- Rubric makes expectations transparent
- Mirrors industry-relevant tasks

### Datasets and the Course Data Pack

Every Skills Lab loads provided files (datasets, starter files, or media
as the course requires). Students never hand-type datasets. Each
chapter's files live in `assets/code/chapter-NN/`, and every folder has
a README data dictionary (contents, types, source, license).

**Loading convention:** students download ONE course data pack zip from
Canvas, extract it, and save their work at the extracted `cis376`
root, so every load uses one path pattern:

```
assets/code/chapter-01/[filename]
```

**Standard load pattern for this course:** each chapter folder ships
one `setup-<database>.sql` per database it uses plus the CSVs it
loads with `\copy`. Students run it from the extracted `cis376` root:

```text
psql -U postgres -d postgres -f assets/code/chapter-01/setup-copperwind.sql
```

The script creates the database if needed, connects to it, drops and
recreates its tables and roles, and loads the CSVs. It is idempotent.
The three course databases are `copperwind_ops`, `sandwash_clinic`,
and `harquahala_academy` (see docs/book-design-spec-2026-09-09.md).

**Rules for any new dataset:**

- For tabular data: minimum 50 rows and 5 columns
- Real public data where it fits (cite source and license in the folder
  README)
- Seeded synthetic data when the lab needs engineered properties
  (guaranteed missing values, quality issues to find, significant test
  results)
- Names in the file match the names used in lab code exactly
- Run code against the real file before writing outputs into the text.
  Never hardcode an output the file cannot reproduce.

**Synthetic data is reproducible:** seeded generator scripts live in
`assets/code/_generators/` (fixed base seed documented in HANDOFF.md,
byte-identical on rerun, with asserts that verify the engineered
properties). Rebuild the data pack with the command documented in
`HANDOFF.md`.

### Code Standards

**All code examples must:**

- Be correct (builds/runs without errors)
- Be concise (only essential elements)
- Be understandable (descriptive names, clear logic)
- Follow the standard style guide for PostgreSQL 17, psql, pgAdmin 4, SQL
- Include required imports, includes, or links at the top
- Include documentation comments for functions or reusable blocks
- Include output comments showing expected results
- Use descriptive names throughout

**Semantic naming (REQUIRED):**
Use content-bearing names for data objects and variables. Generic names
(`data`, `result`, `temp`) are banned in chapter code. Exceptions: a
parameter inside a general-purpose function may stay generic, short-lived
derived values may shorten when the name still says what the data is, and
deliberately broken teaching code may violate the rule. Course
convention: SQL keywords UPPERCASE, identifiers lowercase snake_case,
one clause per line. Every role a chapter creates carries its
organization prefix (`copperwind_`, `clinic_`, `academy_`). Table
aliases are short but meaningful, and only inside queries of two or
three tables.

**Tool version targets (course-configured):**
PostgreSQL 17 (17.11 verified locally on 2026-09-09), psql 17,
pgAdmin 4 (current release), pgcrypto and pg_stat_statements from the
contrib package. Test all chapter code against PostgreSQL 17 with the
harness in `tools/run_chapter_sql.py`. Mark PostgreSQL-only syntax on
first use in each chapter.

### Summary and Retrieval Format

```markdown
## N.5 Summary and Retrieval 💡

**Key Concepts**

* [Bullet point summary of main ideas]

**Key Terms** (See course glossary for full definitions)

* [Terms grouped by section]

**Retrieval Practice**

1. [Active recall prompt at a course-target Bloom's level]
2. [Active recall prompt at a course-target Bloom's level]
3. [Active recall prompt at a course-target Bloom's level]
```

### Markdown Formatting

**Heading hierarchy:**

- H1: Chapter title only
- H2: Major sections with decimal numbering
- H3: Subsections within numbered sections
- Never skip heading levels

**CRITICAL: Heading Icons (REQUIRED for ALL chapters):**

```markdown
## Module Overview 🧭
## Learning Objectives 🎯
### This chapter aligns with the following Course Learning Outcomes  (NO ICON)
### Try It Yourself N.X: [Title] 🛠️
### Quick Check N.X ✅
## N.5 Summary and Retrieval 💡
## N.6 Skills Lab NA: [Title]  (NO ICON)
### Questions & Analysis 🤔
## N.7 Review Questions 🔄️
## Further Reading 📖
## Looking Ahead ⏩
## Course Conclusion: Where You Go from Here  (final chapter, NO ICON)
```

**Lists:**

- **CRITICAL: Always use asterisks (`* `) for bullet points, NEVER dashes (`- `)**
- Use parallel structure
- Use exactly 4 spaces for multi-paragraph list items

**Images:**

- PNG format only (never JPEG)
- Use relative paths from project root
- Include descriptive alt text
- Naming: `ch[NN]-[description].png`

**Tables:**

- Use pipe tables for maximum compatibility
- Keep simple (avoid nested content)

**Inline formatting:**

- **Bold** for first mention of key terms
- *Italic* for emphasis
- `Inline code` for function names, variables, file names

### Terminology Consistency

**Standard terms (course-configured):**

- PostgreSQL (never Postgres in prose, never PostGreSQL)
- psql (lowercase, even at a sentence start: rewrite the sentence)
- pgAdmin (lowercase p, capital A)
- pgcrypto, pg_dump, pg_restore, pg_hba.conf, postgresql.conf (as
  the project spells them, in inline code)
- SQL, DBMS, RDBMS, HIPAA, FERPA, PHI, RBAC, TLS, RTO, RPO, WAL
  (spell out on first use in each chapter)
- row-level security (lowercase, hyphenated), role (never "user"
  for a PostgreSQL login: PostgreSQL has roles)
- on-premise (hyphenated adjective, matches the district outline)
- database administrator (spell out on first use, then DBA)

**Always:**

- Define technical terms on first use
- Add new terms to `book/glossary.md`
- Use glossary as single source of truth

### File Naming Conventions

**Chapters:** `chapter-[NN].md` (e.g., `chapter-01.md`)
**Screenshots:** `ch[NN]-[description].png` (e.g., `ch01-setup-overview.png`)
**Data files:** `[descriptive_name].[ext]` in the chapter's data pack folder

## Content Creation Workflow

### When generating a new chapter:

1. **Review requirements:**
   - Read `/templates/chapter-template.md`
   - Review `/docs/style-guide.md` and `/docs/part-structure.md`
   - Check `book/glossary.md` for terminology
   - Review One prior SQL course (Introduction to Oracle: SQL, CIS276DA MySQL Database, or CIS276DB SQL Server Database) materials for prerequisite content

2. **Create outline first:**
   - Show chapter structure
   - List concepts per section
   - Identify where code examples go
   - Note prerequisite knowledge assumed

3. **Generate content progressively:**
   - Write introduction and learning objectives
   - Develop each section with code examples
   - Add Try It Yourself exercises after major sections
   - Add Quick Checks for retrieval practice
   - Create Skills Lab with the locked rubric
   - Create summary and review questions

4. **Quality checks:**
   - Verify all code runs correctly against the data pack files
   - Check terminology against glossary
   - Ensure learning objectives are measurable at the course's target Bloom's levels
   - Confirm heading hierarchy is correct
   - Validate no prerequisite content is unnecessarily repeated
   - Build the site locally (`zensical build --clean`) with no issues

## Publishing the Textbook

The textbook is published as a static website built with **Zensical**
(https://zensical.org), the successor to Material for MkDocs. It deploys to
**GitHub Pages** automatically on every push to `main`.

**Configuration:** `zensical.toml` at the repo root sets `docs_dir = "book"`.
Published content lives only in `book/`. Authoring references in `docs/` are
not part of the site.

**Local build and preview:**

```bash
python3 -m venv .venv
.venv/bin/pip install -r requirements-docs.txt
.venv/bin/zensical serve          # preview at http://localhost:8000
.venv/bin/zensical build --clean  # output -> site/ (gitignored)
```

**Deployment:** `.github/workflows/docs.yml` builds the site and publishes it
to GitHub Pages. One-time repo setup: Settings -> Pages -> Source =
"GitHub Actions". Live URL: https://jor2050111.github.io/cis376/

**Design for the web build:**

- Pipe tables, admonitions, and fenced code blocks render natively
- Math uses `pymdownx.arithmatex` (write LaTeX in `$...$` or `$$...$$`)
- Brand colors live in `book/stylesheets/colors.css` and `brand.css` (synced)

### Optional: Google Docs export

To hand a single chapter to a reviewer as a Word document, Pandoc still works:

```bash
pandoc book/chapters/chapter-01.md -o chapter-01.docx --extract-media=./media
```

Expect losses: syntax highlighting becomes plain monospace, table styling and
colors do not transfer, and list numbering can restart after code blocks.

## Reference Files

**Always consult these files:**

- `/templates/chapter-template.md` - QM-aligned hybrid structure
- `book/skills-lab-rubric.md` - Universal Skills Lab rubric (synced from ../shared/)
- `/templates/try-it-yourself-template.md` - Predict-Run-Explain pattern
- `/docs/style-guide-core.md` - Shared writing law (synced)
- `/docs/style-guide.md` - Course-specific writing standards
- `book/glossary.md` - Canonical term definitions
- `/docs/blooms-taxonomy-reference.md` - Learning objective guidance
- `/docs/part-structure.md` - 12-chapter organization into 4 Parts
- `/docs/CIS376_CLOs.md` - Authoritative course reference (CLOs, district competencies, course outline, chapter mapping)

## Quality Checklist

Before considering a chapter complete, verify:

**Structure & Organization:**

- [ ] Decimal numbering used for all main sections (N.1, N.2, etc.)
- [ ] Section order: N.5 Summary, N.6 Skills Lab, N.7 Review Questions
- [ ] Module Overview includes time/prerequisites/deliverables
- [ ] Narrative introduction (2-3 paragraphs) sets context
- [ ] "Looking Ahead" preview included ("Course Conclusion: Where You Go from Here" in the final chapter)
- [ ] Heading hierarchy correct (no skipped levels)

**Learning Objectives:**

- [ ] Exactly 3 MLOs with N.Y numbering and RBT tags
- [ ] Format: **N.Y (Bloom's Level):** [Verb] [outcome]
- [ ] Each MLO maps to specific section number
- [ ] Bloom's verbs at the course's target levels
- [ ] CLO alignment block after the MLO list (verbatim outcome text)

**Pedagogical Components:**

- [ ] "Try It Yourself" exercises embedded in sections (1-2 per major section)
- [ ] All "Try It Yourself" use Predict-Run-Explain pattern
- [ ] Quick Checks after each major section (2-3 questions each)
- [ ] Skills Lab with 3 parts (Foundation/Application/Extension)
- [ ] Rubric follows the single-source pattern (chapter 1 transcludes, chapters 2-12 link)
- [ ] Questions & Analysis (2 questions) after Part 3, before Submission
- [ ] Skills Lab loads a provided dataset from assets/code/chapter-NN/
- [ ] Skills Lab parts explicitly align with MLOs

**Content Quality:**

- [ ] Second-person voice ("you") used throughout
- [ ] All code examples tested and working (run on the course's target tool versions)
- [ ] Data objects and variables use semantic names
- [ ] All imports, includes, or links included in code blocks
- [ ] Prerequisite content referenced, not repeated
- [ ] Terminology matches glossary
- [ ] Zero em dashes and zero banned vocabulary (grep before commit)

**Summary & Assessment:**

- [ ] Summary includes Key Concepts + Key Terms + Retrieval Practice
- [ ] Key Terms reference glossary (not duplicate definitions)
- [ ] Retrieval Practice has 3-5 active recall prompts
- [ ] Review questions span the course's target Bloom's levels
- [ ] Further Reading has 3-6 curated resources

**Technical:**

- [ ] Screenshots have descriptive alt text
- [ ] All new terms added to `book/glossary.md`
- [ ] Chapter length ~600 lines (approximately 20 pages)
- [ ] `zensical build --clean` reports no issues

## CIS376 Course Learning Outcomes (CLOs)

**Authoritative reference:** `/docs/CIS376_CLOs.md` contains official
district competencies, elevated CLOs, Bloom's analysis, CLO-to-chapter
mapping, and full course outline.

Quick reference (add the elevated CLOs here during setup so chapter
sessions do not need to open the full document):

- **CLO I (Analyze):** Analyze database architecture and design for business solutions.
- **CLO II (Evaluate):** Assess security management for database environments.
- **CLO III (Create):** Develop strategies to maintain optimal system performance, security and availability.
- **CLO IV (Evaluate):** Evaluate practices for database environment incident responses.
- **CLO V (Evaluate):** Critique current practices and future trends of database management and security.

Spine, data landscape, per-chapter plan, block formats, and the QA
protocol: `docs/book-design-spec-2026-09-09.md`. Read it before
writing any chapter.

## Project Goals

**Primary objective:** Create a professional textbook that carries
community college students who have completed one SQL course and are moving into database administration and security to the measurable outcomes in `/docs/CIS376_CLOs.md`.

**Success criteria:**

- QM-aligned chapter structure with research-backed pedagogy
- Consistent voice and structure across all 12 chapters
- Clear, working code examples that follow the PostgreSQL 17, psql, pgAdmin 4, SQL style standards
- Progressive skill building across the 4 Parts
- Measurable learning objectives at the course's target Bloom's levels
- Active learning through Predict-Run-Explain and Quick Checks
- Authentic files shipped in the course data pack
- Clean Zensical build that deploys to GitHub Pages

## Session Instructions

**When starting a new session:**

1. Review CLAUDE.md (this file) and HANDOFF.md
2. Read relevant template files
3. Check glossary for terminology
4. Review One prior SQL course (Introduction to Oracle: SQL, CIS276DA MySQL Database, or CIS276DB SQL Server Database) materials for prerequisite assumptions

**During content creation:**

1. Follow chapter template structure
2. Apply style guide consistently
3. Use Bloom's taxonomy at the course's target levels for learning objectives
4. Test all code examples against the data pack
5. Add new terms to glossary

**Before completing work:**

1. Run quality checklist
2. Compare with other chapters for consistency
3. Verify code runs correctly
4. Check terminology consistency
5. Build the site locally with no issues

---

**Remember:** This file has higher authority than chat prompts. When in doubt, refer back to these standards. Consistency across chapters is critical for student success.
