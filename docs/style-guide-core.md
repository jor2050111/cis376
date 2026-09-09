# Textbook Style Guide: Shared Core

This file is the course-agnostic writing law for every textbook in this
workspace (Python data analytics, HTML/CSS, SQL, C++, CompTIA A+, and
any future course). Each course repo keeps its own `docs/style-guide.md`
that layers course-specific guidance (audience calibration, tech-stack
conventions, dataset domains) on top of this core. When the two
disagree, the course guide wins for that course only.

A sync script copies this file into each course repo as
`docs/style-guide-core.md`. Edit the canonical copy in
`textbooks/shared/`, never the synced copy.

## Em Dash Policy

Do not use em dashes ("—", U+2014) anywhere in prose, headings, or code
comments. When you would reach for one, look at what comes immediately
after the dash position and choose by grammar, not habit:

1. A complete sentence follows -> end with a period and start a new
   sentence. This is the DEFAULT and it raises Flesch Reading Ease
   toward the target range.
2. A phrase that renames the noun just before it (an appositive) ->
   use a comma.
3. You are spelling out or itemizing what a term means, and a period
   would read as choppy (common inside bullets) -> use a colon.
4. The clause could be lifted out without breaking the sentence ->
   use parentheses.

Headings and titles: replace the em dash with a colon.
Example: "Try It Yourself 9.2 — Interpreting P-Values" becomes
"Try It Yourself 9.2: Interpreting P-Values".

Constraints:

* Never replace an em dash with a hyphen.
* Never replace an em dash with a semicolon. Avoid semicolons in prose
  entirely.
* Vary the choice across a passage so one mark does not dominate.
* If a bullet already opens with a colon, do not stack a second colon.
  Use a period instead.

Do not touch: hyphens in ranges ("4-5 hours"), minus signs and negative
numbers ("r = -1.0"), hyphenated compounds ("chi-square"), or anything
inside fenced code blocks or inline code.

## Voice and Tone

### Voice: Second Person

Always use "you" to address the student directly.

Good:

> You can confirm the drive is detected by checking the BIOS boot menu.

Bad:

> Students can confirm the drive is detected...
> One can confirm the drive is detected...
> We can confirm the drive is detected...

### Active Voice

Use active voice at least 95% of the time. Passive voice hides the
actor and slows the reader.

Good (HTML/CSS):

> The browser applies the last matching rule.

Bad:

> The last matching rule is applied by the browser.

### Sentence Length and Reading Level

* Watch sentence length while drafting, not after. Split any prose
  sentence that reaches about 35 words, and keep typical sentences
  well under 30.
* Default target: Flesch Reading Ease 60-70 for student-facing content.
* An advanced technical course may approve a lower target in its course
  style guide (an advanced course may approve a mid-50s band). The course guide records
  the approved number.
* Headings, tables, and code are exempt from sentence-length checks.

### Tone Calibration

Tone shifts by audience, so the exact register lives in each course
style guide. The invariants:

* Professional yet approachable. Never condescending, never breezy.
* Concrete examples for abstract concepts.
* Direct and confident. Say what to do, then why.
* Treat students as practitioners doing the work now. Never frame
  coursework as preparation for some later "real" work.

## Banned Vocabulary and Filler

Never use these words (AI tells):

* spot-on, spot on, indeed, delve, dive, embark
* nuances, journey, tapestry, navigate, crucial

Remove this filler on sight:

* basically, actually, really, very, quite, somewhat, rather
* "in order to" (use "to")
* at this point in time, during the course of
* at the end of the day, moving forward
* it is important to note, it should be mentioned, it is worth noting

Before finalizing any passage, scan for every item above and rewrite.

## Terminology Rules

| Use | Never use |
| --- | --------- |
| industry-relevant, industry-standard | real-world |
| transferable skills | soft skills, workplace readiness |
| Output Quality (rubric criterion) | Visualization Quality |

Framing rule: students ARE doing the work now. Do not write "this will
prepare you for" or "when you get a job you will". Present the task as
the work itself.

Tool and product names: every course guide keeps an exact-capitalization
table for its stack (for example, JupyterLab, MySQL, C++17, CompTIA A+).
Follow that table without exception, including at sentence starts.

## Heading and Markdown Conventions

### Heading Hierarchy

Strict hierarchy. Never skip levels.

* H1: chapter title only, once per chapter (`# Chapter N: [Title]`)
* H2: major sections with decimal numbering (`## N.1 [Topic]`)
* H3: subsections, Try It Yourself, Quick Checks, rubrics

Reserved decimal sections, identical across all textbooks:

* `## N.1` through `## N.4`: main content sections
* `## N.5 Summary and Retrieval`
* `## N.6 Skills Lab NA: [Title]`
* `## N.7 Review Questions`

### Heading Icons

All major section headings carry their designated icon. The Skills Lab
heading carries no icon.

```markdown
## Module Overview 🧭
## Learning Objectives 🎯
### Try It Yourself N.X: [Title] 🛠️
### Quick Check N.X ✅
## N.5 Summary and Retrieval 💡
## N.6 Skills Lab NA: [Title]  (NO ICON)
### Questions & Analysis 🤔
## N.7 Review Questions 🔄️
## Further Reading 📖
## Looking Ahead ⏩
```

The full chapter structure (section order, pedagogical components,
rubric) lives in each course's chapter template, not here.

### Bullets and Lists

* ALWAYS use asterisks (`* `) for bullet points, NEVER dashes (`- `).
  Asterisks render consistently across markdown processors and export
  tools.
* Use parallel structure: every item takes the same grammatical form.
* Use exactly 4 spaces to indent continuation paragraphs and code
  blocks inside list items. Never mix tabs and spaces.

### Inline Formatting

* **Bold** for the first mention of a key term in each chapter
* *Italic* for emphasis only
* `Inline code` for function names, variables, file names, commands,
  selectors, and short code expressions
* Never use inline code for emphasis

### Tables

* Use pipe tables for maximum compatibility.
* Include a header row.
* Keep tables simple: no code blocks, images, or nested lists in cells.

### Images

* PNG format only (never JPEG for screenshots or diagrams)
* Under 200KB, captured at 2x resolution, cropped with enough context
* Naming convention: `ch[NN]-[description].png`
* Relative paths from the project root
* Descriptive alt text on every image (see Accessibility)

### Links

Use descriptive link text that states the destination. Never "click
here" or a bare URL in prose.

Good:

> The [MDN flexbox guide](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_flexible_box_layout) covers axis alignment in depth.

## Accessibility (WCAG 2.1 AA)

Every chapter must satisfy these before it ships:

* Every image has descriptive alt text: what is shown, why it matters,
  which elements are important.
* Link text is meaningful on its own (screen readers list links out of
  context).
* Heading hierarchy is correct and unbroken, so screen readers can
  outline the page.
* Every table has a header row.
* Color is never the only way to convey information.
* Code appears in proper code blocks, never in screenshots.
* Sufficient color contrast in any custom-styled element.

## Code-Block Conventions (All Languages)

These rules apply whether the block holds Python, SQL, HTML, CSS, C++,
or a command-line transcript.

### Fencing

Always use fenced code blocks with the correct language identifier
(`python`, `sql`, `html`, `css`, `cpp`, `bash`, `text`). Never use bare
fences or indented code blocks.

### Every Code Example Must

* Be correct: it runs (or renders, or executes) without errors against
  the course's committed files and stated tool versions.
* Be complete: show all imports, includes, setup statements, or
  preamble the reader needs. Never assume earlier context.
* Be concise: only the elements that teach the concept.
* Use descriptive, semantic names. Generic names (`data`, `temp`,
  `result`, `x`) are banned outside loop counters and coordinates.
  Course guides define language-specific naming schemes.
* Include expected output as a comment or an adjacent labeled block,
  using the language's own comment syntax. Never hardcode an output
  the committed files cannot reproduce. Run the code first.
* Introduce one new concept at a time. Progressive complexity, never
  compound novelty.

### Comments Explain WHY, Not WHAT

Comment the reasoning, the assumption, or the pitfall. Do not restate
the code.

Example (SQL):

```sql
-- LEFT JOIN keeps customers with zero orders, which the
-- retention report must count.
SELECT c.customer_name, COUNT(o.order_id) AS order_count
FROM customers AS c
LEFT JOIN orders AS o ON o.customer_id = c.customer_id
GROUP BY c.customer_name;
-- Output: one row per customer, order_count 0 for inactive customers
```

Example (C++):

```cpp
#include <vector>

// Reserve up front: the sensor loop appends 10,000 readings and
// repeated reallocation would dominate the runtime.
std::vector<double> readings;
readings.reserve(10000);
```

### Language-Specific Style

Formatting law for each language (PEP 8, CSS property ordering, SQL
keyword casing, C++ brace style, and so on) lives in the course style
guide. The core rule is only this: pick the community-standard style
for the language and apply it without exception.

## Callouts and Admonitions

The published sites render admonition blocks natively. Use them
sparingly so they keep their signal value.

* **Note** for context the main text should not interrupt itself for.
* **Tip** for a shortcut or professional habit.
* **Warning** for actions that lose data, break builds, or cost money.

Rules:

* At most 2-3 admonitions per chapter section.
* Never nest admonitions or stack two in a row.
* An admonition never carries required instructions. If the student
  must do it, put it in the numbered steps.
* All prose rules (em dash policy, banned words, second person) apply
  inside admonitions.

## Glossary Conventions

* Define every technical term on first use in each chapter: bold the
  term, give a one-or-two-sentence plain definition, then use it.
* Add every new term to the course glossary (`book/glossary.md`). The
  glossary is the single source of truth for definitions.
* Glossary entries use definition-list markup under the term's letter
  heading, in alphabetical order. The term sits on its own line (no
  bold, no trailing colon) and the definition follows on the next line
  after a colon and three spaces:

  ```markdown
  alt text
  :   The text that stands in for an image when its pixels cannot.
  ```

* The glossary page carries no authoring instructions. Rules like
  these live in the style guide and CLAUDE.md, never on the published
  page students read.
* Never alternate between synonyms for a defined term. Pick one name
  and keep it textbook-wide.
* Chapter "Key Terms" sections list terms and point to the glossary.
  They never duplicate the definitions.

Example (CompTIA A+):

> **POST** (power-on self-test) is the firmware's hardware check that
> runs before the operating system loads. When POST fails, the board
> reports the failure through beep codes or diagnostic LEDs.

## Export and Conversion

Design content to survive conversion (Google Docs review copies, PDF):

* Syntax highlighting disappears, so output comments must make code
  readable as plain monospace text.
* Keep tables simple. Styling does not transfer.
* Use 4-space indentation for list continuations so numbering survives
  code blocks inside lists.
* Test conversion periodically with Pandoc.
