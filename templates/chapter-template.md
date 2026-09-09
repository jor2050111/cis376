<!--
GENERIC CHAPTER TEMPLATE for CIS376: Database Management and Security

Replace these placeholder tokens before authoring:
  CIS376      Course code (example: CIS123)
  Database Management and Security   Full course title
  community college students who have completed one SQL course and are moving into database administration and security       Who the students are and what they already know
  One prior SQL course (Introduction to Oracle: SQL, CIS276DA MySQL Database, or CIS276DB SQL Server Database)  Required prior courses or skills
  PostgreSQL 17, psql, pgAdmin 4, SQL  The course tech stack (languages, environments, libraries)

Code samples in this template come from a Python-based data analytics
course. Keep the structure and adapt every code example to
PostgreSQL 17, psql, pgAdmin 4, SQL.
-->

# Chapter N: [Descriptive Title]

[Opening narrative paragraph. Hook the reader with an industry-relevant scenario tied to the chapter topic. Make it meaningful to community college students who have completed one SQL course and are moving into database administration and security.]

[Second paragraph. Explain why this topic matters in Database Management and Security. Connect to course learning outcomes and to prior chapters where the connection is genuine.]

[Third paragraph. Preview what students will learn and do in this chapter. Set expectations for the difficulty level.]

## Module Overview 🧭

* **Estimated time:** X-Y hours
* **Prerequisites:** One prior SQL course (Introduction to Oracle: SQL, CIS276DA MySQL Database, or CIS276DB SQL Server Database), [specific chapter dependencies within this book]
* **Deliverables:** Skills Lab NA deliverable, Quick Checks

## Learning Objectives 🎯

By the end of this chapter, you will be able to:

* **N.1 (Bloom's Level):** [Action verb] [measurable outcome aligned with Section N.1]
* **N.2 (Bloom's Level):** [Action verb] [measurable outcome aligned with Section N.2]
* **N.3 (Bloom's Level):** [Action verb] [measurable outcome aligned with Section N.4]

[Pick Bloom's levels to match the course level. Introductory courses target Remember, Understand, and Apply. Advanced courses target Apply, Analyze, Evaluate, and Create.]

### This chapter aligns with the following Course Learning Outcomes

* **CLO N.** [Verbatim outcome text from docs/CIS376_CLOs.md]

[List only this chapter's aligned CLOs (usually 1-3), taken from the
CLO-to-chapter mapping table in docs/CIS376_CLOs.md. Quote the
outcome text word for word. No heading icon on this block.]

---

## N.1 [First Major Topic]

[Introduction to this topic: 2-3 paragraphs. Bridge briefly from One prior SQL course (Introduction to Oracle: SQL, CIS276DA MySQL Database, or CIS276DB SQL Server Database) knowledge, then introduce the new concept.]

[Content paragraphs with inline **bold** for the first mention of key terms.]

[Code example if applicable:]

```python
# EXAMPLE from a Python-based data analytics course.
# Adapt the language, libraries, and task to PostgreSQL 17, psql, pgAdmin 4, SQL.
# Include all necessary imports or setup at the top.
import pandas as pd
import numpy as np

# Comments explain reasoning, not syntax
def analyze_cohort_retention(
    df: pd.DataFrame,
    cohort_col: str,
    period_col: str
) -> pd.DataFrame:
    """Calculate retention by cohort period."""
    retention = (
        df.groupby([cohort_col, period_col])
        .size()
        .unstack(fill_value=0)
    )
    return retention
# Output: Pivot table with cohorts as rows, periods as columns
```

[Additional explanation of the approach and its significance.]

### Try It Yourself N.1: [Descriptive Title] 🛠️

**Predict:** [Question requiring a prediction before executing code or examining results. Focus on reasoning about WHY, not just WHAT.]

**Run:** [Specific code to execute or task to perform. Keep it short: 2-7 minutes depending on course level.]

**Explain:** [Prompt requiring a 1-2 sentence explanation of WHY the result supports or contradicts the prediction.]

[More content as needed...]

### Quick Check N.1 ✅

1. [Question at a Bloom's level matching the course: recall or apply the concept]
2. [Question one level up: explain, compare, or evaluate]
3. [Optional third question for dense sections]

---

## N.2 [Second Major Topic]

[Follow the same pattern as N.1:]

* Bridge from prior knowledge
* Content with code examples
* Try It Yourself exercise (Predict-Run-Explain) 🛠️
* Quick Check questions ✅

---

## N.3 [Third Major Topic]

[Follow same pattern...]

---

## N.4 [Fourth Major Topic]

[Follow same pattern...]

---

## N.5 Summary and Retrieval 💡

### Key Concepts

* [Bullet point summarizing first major concept: 2-3 sentences max]
* [Second major concept]
* [Third major concept]
* [Fourth major concept]
* [Include 4-6 bullets total, aligned with the main sections]

### Key Terms

See course glossary for full definitions

* [Term 1], [term 2], [term 3] (Section N.1)
* [Term 4], [term 5] (Section N.2)
* [Term 6], [term 7] (Section N.3)
* [Group terms by the section where they were introduced]

### Retrieval Practice

1. [Active recall question at the course's base Bloom's level, answered without looking back]
2. [Question requiring explanation or comparison from memory]
3. [Question requiring application or justification of a decision]
4. [Optional fourth question for deeper processing]
5. [Optional fifth question if the chapter is dense]

---

## N.6 Skills Lab NA: [Descriptive Project Title]

**Goal:** [One sentence describing the authentic task students will complete]

**Dataset or starter files:** [Provided file(s) in `assets/code/chapter-NN/`. Name each file and its source. Students load provided files from the course data pack, never hand-type them.]

### Part 1: Foundation (Aligns with Objective N.1)

[Tasks all students must complete. Scaffolded for success. Builds on One prior SQL course (Introduction to Oracle: SQL, CIS276DA MySQL Database, or CIS276DB SQL Server Database) skills while introducing chapter-specific techniques.]

1. [Task with clear guidance]
2. [Task building on the previous step]
3. [Task demonstrating the core chapter concept]

### Part 2: Application (Aligns with Objectives N.1 and N.3)

[Intermediate synthesis requiring students to combine skills and make judgment calls. Less structured than Part 1.]

1. [Task requiring students to choose an approach and justify it]
2. [Task combining multiple chapter concepts]
3. [Task producing insight, not just output]

### Part 3: Extension (Aligns with Objectives N.2 and N.3)

[Advanced or creative problem-solving. May involve communication, presentation, or stakeholder considerations. Can be bonus for introductory courses.]

1. [Open-ended question or challenge]
2. [Task requiring professional-quality output or presentation]
3. [Task connecting to an industry application]

### Questions & Analysis 🤔

[Exactly 2 critical-thinking questions tied to the lab tasks and MLOs. Students answer in written form inside their submission. The answers carry significant rubric weight and feed the fourth rubric criterion.]

1. [Question connecting a Part 2 or Part 3 result to a decision or interpretation. Require students to cite their own output as evidence.]
2. [Question asking students to compare approaches or propose a follow-up, justifying the choice.]

**Submission:** Submit one file or folder named `skills-lab-Na-lastname` with the extension PostgreSQL 17, psql, pgAdmin 4, SQL uses (for example, `.ipynb` in a Python notebook course, `.sql` in a database course, or a zipped site folder in a web course). Include your code, outputs, and written explanations for each part, with your Questions & Analysis answers clearly labeled.

### Rubric: Skills Lab NA

[Do not paste the rubric table here. Chapter 1 transcludes the canonical table with `--8<-- "skills-lab-rubric.md:rubric"` after a two-line lead-in. Chapters 2-12 use the short link block. See `/templates/skills-lab-rubric-template.md` for both patterns.]

---

## N.7 Review Questions 🔄️

[Four questions spanning four Bloom's levels appropriate to the course. Introductory courses: Remember, Understand, Apply, Analyze. Advanced courses: Apply, Analyze, Evaluate, Create.]

1. **[Level 1]:** [Question at the course's base level]

2. **[Level 2]:** [Question requiring explanation, interpretation, or comparison]

3. **[Level 3]:** [Question presenting a new scenario or requiring judgment]

4. **[Level 4]:** [Question requiring analysis of relationships or design of a solution]

---

## Further Reading 📖

* [Resource 1 Title](URL) - [One sentence explaining what this resource offers]
* [Resource 2 Title](URL) - [Why this is valuable for community college students who have completed one SQL course and are moving into database administration and security]
* [Resource 3 Title](URL) - [What students will learn]

**Note:** Curate 3-6 resources matched to community college students who have completed one SQL course and are moving into database administration and security. Include official documentation, tutorials, industry articles, or interactive exercises at the right depth for the course level.

---

## Looking Ahead ⏩

[2-3 sentences previewing the next chapter. In the final chapter, title this section "Course Conclusion: Where You Go from Here" (no icon) and close the course instead of previewing. Show how this chapter's concepts lead naturally into the next topic. Build anticipation for the next skill.]

---

<!-- TEMPLATE NOTES (Delete before publishing):

STRUCTURE CHECKLIST:
* [ ] Decimal numbering for all main sections (N.1, N.2, etc.)
* [ ] Module Overview with time/prerequisites/deliverables
* [ ] Exactly 3 Learning Objectives in N.Y (Bloom's Level) format
* [ ] CLO alignment block after the MLO list (verbatim outcome text
      from docs/CIS376_CLOs.md, no heading icon)
* [ ] 4-5 main content sections
* [ ] Try It Yourself in each section (Predict-Run-Explain)
* [ ] Quick Check after each section
* [ ] Section order: N.5 Summary, N.6 Skills Lab, N.7 Review Questions
* [ ] Skills Lab with 3 parts, Questions & Analysis, and the locked universal rubric
* [ ] Summary with Key Concepts, Key Terms, Retrieval Practice
* [ ] 4 Review Questions spanning Bloom's levels matched to the course
* [ ] 3-6 Further Reading resources
* [ ] Looking Ahead preview

LENGTH GUIDELINES:
* Target: 600-700 lines total (approximately 20 printed pages)
* 4-5 main sections (N.1 through N.4)
* 8-15 code examples total
* Each code example: 5-25 lines max (shorter for introductory courses)
* Try It Yourself: 1-2 per section
* Quick Checks: 2-3 questions per section

COURSE-SPECIFIC REQUIREMENTS (adapt each to PostgreSQL 17, psql, pgAdmin 4, SQL):
* Bloom's level band matches the course level (intro: Remember-Apply.
  Advanced: Apply-Create.)
* Bridge from One prior SQL course (Introduction to Oracle: SQL, CIS276DA MySQL Database, or CIS276DB SQL Server Database) concepts (reference them, do not reteach)
* Second person voice ("you") throughout
* Tone matched to community college students who have completed one SQL course and are moving into database administration and security
* Split prose sentences before they reach 35 words
* All code tested and working on PostgreSQL 17, psql, pgAdmin 4, SQL
* All imports or setup included in every code block
* Follow the course style guide (example: PEP 8 with 79-char lines in
  Python courses. Define an equivalent for other stacks.)
* Bold key terms on first use
* Add all new terms to the course glossary
* Datasets and starter files ship in the course data pack
  (assets/code/chapter-NN/)
* Semantic variable naming per course convention (example: the df_
  prefix for DataFrames in Python courses)
* Emphasize reasoning and decision-making over syntax

BULLET FORMATTING:
* ALWAYS use asterisks (* ) for bullets, NEVER dashes (- )

HEADING ICONS (REQUIRED, identical across all chapters):
* Module Overview 🧭
* Learning Objectives 🎯
* This chapter aligns with the following Course Learning Outcomes (NO ICON)
* Try It Yourself N.X 🛠️
* Quick Check N.X ✅
* Summary and Retrieval N.5 💡
* Skills Lab N.6 (NO ICON)
* Questions & Analysis 🤔
* Review Questions N.7 🔄️
* Further Reading 📖
* Looking Ahead ⏩
* Course Conclusion: Where You Go from Here (final chapter, NO ICON)

-->
