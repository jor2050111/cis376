# CIS376 - Database Management and Security

**Plan, secure, monitor, and recover PostgreSQL databases that meet business and regulatory requirements, from architecture through incident response.**

## Project Overview

This project is the OER textbook for CIS376 (Database Management and Security) at
Phoenix College. It publishes as a static website built with Zensical and
deployed to GitHub Pages. The book follows the shared textbook-family
structure: QM-aligned chapters, Predict-Run-Explain exercises, Quick
Checks, and a Skills Lab with a locked universal rubric in every chapter.

### Target Audience

* community college students who have completed one SQL course and are moving into database administration and security
* Prerequisites: One prior SQL course (Introduction to Oracle: SQL, CIS276DA MySQL Database, or CIS276DB SQL Server Database)

### Key Technologies Covered

* PostgreSQL 17, psql, pgAdmin 4, SQL

### Course Learning Outcomes (CLOs)

The authoritative CLO reference is
[docs/CIS376_CLOs.md](docs/CIS376_CLOs.md). It contains the
official district competencies, elevated CLOs with Bloom's verbs, the
CLO-to-chapter mapping, and the full course outline.

## Project Structure

```
cis376/
├── CLAUDE.md                          # Claude Code project context (AI assistant guide)
├── README.md                          # This file
├── zensical.toml                      # Zensical site config (docs_dir = book)
├── requirements-docs.txt              # Pinned Zensical version for builds
├── .github/workflows/docs.yml         # Build + deploy to GitHub Pages (synced from ../shared/)
├── book/                              # PUBLISHED textbook (single source of truth)
│   ├── index.md                       # Site home page
│   ├── glossary.md                    # Published glossary
│   ├── chapters/chapter-01.md ... chapter-12.md
│   ├── stylesheets/                   # Sonoran Nightfall design system (synced)
│   └── assets/images/screenshots/     # Site images referenced by chapters
├── assets/
│   └── code/                          # Student data pack (labs load from here)
│       ├── chapter-01/ ... chapter-12/
│       └── _generators/               # Seeded synthetic-data scripts
├── templates/
│   ├── chapter-template.md            # Standard chapter structure
│   ├── exercise-template.md           # Exercise format reference
│   ├── skills-lab-rubric-template.md  # Locked universal rubric
│   └── try-it-yourself-template.md    # Predict-Run-Explain template
├── tools/                             # QA scripts (synced from ../shared/)
├── docs/                              # Authoring references (NOT published)
│   ├── style-guide.md                 # Writing and formatting standards (core synced)
│   ├── blooms-taxonomy-reference.md   # Learning objective guidelines (synced)
│   ├── CIS376_CLOs.md          # Official Course Learning Outcomes
│   └── part-structure.md              # 12-chapter organization into 4 Parts
└── site/                              # Zensical build output (gitignored)
```

Files marked "synced" are copied from the family-wide canonical set in
`../shared/` by `../shared/tools/sync-shared.sh`. Edit the canonical
copies there, never the synced copies here.

## Getting Started

### Prerequisites

* Git (for version control)
* Python 3.12+ (builds the site)
* The tools in PostgreSQL 17, psql, pgAdmin 4, SQL (for testing code examples)

### Initial Setup

1. **Clone the repository:**

   ```bash
   git clone https://github.com/jor2050111/cis376.git
   cd cis376
   ```

2. **Review foundation files:**

   * [CLAUDE.md](CLAUDE.md) - Project context for Claude Code
   * [docs/style-guide.md](docs/style-guide.md) - Writing standards
   * [templates/chapter-template.md](templates/chapter-template.md) - Chapter structure
   * [docs/part-structure.md](docs/part-structure.md) - Course organization

## Building the Site Locally

The textbook publishes as a static site. To build and preview it on your
machine:

```bash
python3 -m venv .venv
.venv/bin/pip install -r requirements-docs.txt
.venv/bin/zensical serve          # preview at http://localhost:8000
.venv/bin/zensical build --clean  # output -> site/ (gitignored)
```

`zensical.toml` sets `docs_dir = "book"`, so only `book/` publishes.
Authoring references in `docs/` stay out of the site.

## Deployment

Every push to `main` triggers `.github/workflows/docs.yml`, which builds
the site with the pinned Zensical version and publishes it to GitHub
Pages. One-time repo setup: Settings -> Pages -> Source = "GitHub
Actions".

Live site: <https://jor2050111.github.io/cis376/>

To hand a single chapter to a reviewer as a Word document:

```bash
pandoc book/chapters/chapter-01.md -o chapter-01.docx --extract-media=./media
```

## Development Workflow

### Creating a New Chapter

1. **Review prerequisites:** identify what students already know from
   One prior SQL course (Introduction to Oracle: SQL, CIS276DA MySQL Database, or CIS276DB SQL Server Database) and plan the bridge into new content.
2. **Generate with Claude Code:** use the chapter template at
   `templates/chapter-template.md` and the style guide at
   `docs/style-guide.md`. Follow the full process in
   [CLAUDE.md](CLAUDE.md).
3. **Review and refine:** check learning objectives against Bloom's
   Taxonomy, test all code examples, and verify terminology against the
   glossary.

### Quality Checklist

Before finalizing a chapter:

* [ ] Exactly 3 learning objectives at the course's target Bloom's levels
* [ ] Second-person voice ("you") throughout
* [ ] All code tested and working
* [ ] All imports, includes, or links present in code blocks
* [ ] Terminology matches glossary
* [ ] Heading hierarchy correct (no skipped levels)
* [ ] Prerequisite concepts referenced, not retaught
* [ ] Datasets ship in the course data pack (assets/code/chapter-NN/)
* [ ] Skills Lab with 3 parts, Questions & Analysis, and the locked universal rubric
* [ ] Quick Checks and Try It Yourself exercises included

The full checklist lives in [CLAUDE.md](CLAUDE.md).

## Reference Documents

### For Content Creation

* [CLAUDE.md](CLAUDE.md) - Complete project context for AI-assisted development
* [templates/chapter-template.md](templates/chapter-template.md) - Chapter structure template
* [docs/CIS376_CLOs.md](docs/CIS376_CLOs.md) - Official Course Learning Outcomes

### For Style and Standards

* [docs/style-guide.md](docs/style-guide.md) - Comprehensive writing and formatting guide
* [book/glossary.md](book/glossary.md) - Technical terminology reference
* [docs/blooms-taxonomy-reference.md](docs/blooms-taxonomy-reference.md) - Learning objective guidelines

## License

<!-- TODO: Specify license (e.g., CC BY-NC-SA 4.0 for educational materials) -->

## Contact

Jorge Vega, Phoenix College
Jorge.Vega@PhoenixCollege.edu

---

**Status:** Initial Scaffolding - Active Development

**Current Chapter Count:** 0 of 12 (scaffolding only)
