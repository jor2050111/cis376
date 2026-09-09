# Revised Bloom's Taxonomy Reference: Shared Core

This file guides learning-objective writing for every textbook in this
workspace, whatever the stack (Python data analytics, HTML/CSS, SQL,
C++, CompTIA A+). Each course repo keeps its own
`docs/blooms-taxonomy-reference.md` (or a section in its style guide)
that sets the Bloom's-level emphasis for that course's audience. This
core defines the framework, the verbs, and the objective format.

The Revised Bloom's Taxonomy (Anderson & Krathwohl, 2001) organizes
cognitive work into six levels, from recall to original creation. Each
level builds on the ones below it.

```
CREATE          ▲
EVALUATE        │ Increasing
ANALYZE         │ Complexity
APPLY           │
UNDERSTAND      │
REMEMBER        │
                ▼
```

## The Six Levels

### Level 1: Remember

**Definition:** Retrieve relevant knowledge from long-term memory.
Recognize or recall facts, terms, and procedures.

**Action verbs:** list, recall, define, identify, label, recognize,
name, state, locate, match

**Example objectives:**

* **Define** the four box model components: content, padding, border,
  and margin (HTML/CSS)
* **Identify** the connector types used by SATA and NVMe storage
  devices (CompTIA A+)
* **List** the clauses of a SELECT statement in execution order (SQL)

### Level 2: Understand

**Definition:** Construct meaning from instruction. Explain ideas and
concepts in your own words.

**Action verbs:** explain, describe, summarize, paraphrase, interpret,
classify, discuss, illustrate, infer, contrast (basic)

**Example objectives:**

* **Explain** how an INNER JOIN and a LEFT JOIN produce different
  result sets from the same tables (SQL)
* **Describe** how pass-by-value differs from pass-by-reference when a
  function modifies its argument (C++)
* **Interpret** the summary statistics a data profile reports and what
  each one says about the dataset (data analytics)

### Level 3: Apply

**Definition:** Carry out or use a procedure in a given situation.

**Action verbs:** implement, calculate, solve, demonstrate, use,
perform, execute, apply, construct (basic), modify, operate, complete

**Example objectives:**

* **Implement** data cleaning operations that detect and handle
  missing values in a provided dataset (data analytics)
* **Construct** a responsive menu bar using flexbox and the `nav`
  element (HTML/CSS)
* **Perform** a clean operating system installation on a virtual
  machine and verify device drivers load (CompTIA A+)

### Level 4: Analyze

**Definition:** Break material into parts and determine how the parts
relate to one another and to an overall structure or purpose.

**Action verbs:** differentiate, distinguish, categorize, compare,
organize, deconstruct, examine, diagram, investigate, relate

**Example objectives:**

* **Compare** the assumptions and appropriate use cases for t-tests,
  chi-square tests, and ANOVA (data analytics)
* **Differentiate** normalized and denormalized schema designs based
  on the query workload each serves (SQL)
* **Examine** a failing boot sequence to isolate the faulty component
  (CompTIA A+)

### Level 5: Evaluate

**Definition:** Make judgments based on criteria and standards.

**Action verbs:** critique, judge, justify, argue, defend, evaluate,
assess, appraise, recommend, prioritize, validate

**Example objectives:**

* **Assess** the objectives, limitations, and scope of a proposed data
  analysis project (data analytics)
* **Critique** a page layout against WCAG 2.1 AA success criteria and
  recommend corrections (HTML/CSS)
* **Justify** a storage upgrade recommendation based on customer
  workload and budget (CompTIA A+)

### Level 6: Create

**Definition:** Put elements together to form a coherent whole.
Reorganize elements into a new pattern or structure.

**Action verbs:** design, formulate, build, compose, develop, generate,
produce, construct (complex), plan, devise, deliver

**Example objectives:**

* **Design** a relational schema for a multi-tenant inventory system,
  including keys and constraints (SQL)
* **Build** a class hierarchy that models a library's media types with
  shared and specialized behavior (C++)
* **Compose** a data narrative that aligns analytical findings with
  stakeholder values and goals (data analytics)

## Writing Measurable Module Objectives

### Format

Every module (chapter) states exactly 3 Module Learning Objectives
(MLOs), introduced with:

> By the end of this module, you will be able to:

Each objective follows this format:

```markdown
* **MLO-N.Y (Bloom's Level):** [Verb] [measurable outcome]
```

* MLO = Module Learning Objective prefix
* N = module or chapter number
* Y = sequential objective number (1, 2, 3)
* Bloom's Level = the taxonomy level in parentheses

**Example:**

```markdown
* **MLO-4.1 (Understand):** Explain how the CSS cascade resolves
  conflicting rules using specificity and source order
* **MLO-4.2 (Apply):** Construct a two-column page layout using CSS
  Grid with named template areas
* **MLO-4.3 (Analyze):** Compare Grid and flexbox layouts for a given
  design and select the better fit
```

### Every Objective Must Be

* **Measurable.** An assessment can verify it.
* **Specific.** The reader knows exactly what the student will do.
* **Achievable.** Realistic for the module's scope and time budget.
* **Action-oriented.** It starts with one Bloom's verb.

### Rules

* One verb per objective. "Implement and evaluate" is two objectives.
* Each objective maps to a specific section number (MLO-4.2 maps to
  section 4.2), which enables assessment traceability.
* Assessments (Skills Labs, quizzes, projects) cite the MLOs they
  measure.
* Banned verbs, never measurable: know, learn, understand (as the
  verb), appreciate, become familiar with, be aware of.

### Bad-to-Good Fixes

| Broken objective | Problem | Fixed objective |
| ---------------- | ------- | --------------- |
| Understand pointers | Not measurable | **Explain** what a dangling pointer is and how it occurs (C++) |
| Learn about subqueries | Not action-oriented | **Construct** a correlated subquery that filters rows by a per-group aggregate (SQL) |
| Appreciate the importance of backups | Cannot be assessed | **Implement** a scheduled backup and verify a test restore (CompTIA A+) |
| Apply your web skills | Too broad | **Apply** media queries to adapt a page layout at two breakpoints (HTML/CSS) |

## Matching Bloom's Emphasis to the Course

The right distribution depends on where the course sits in a sequence.
Each course guide records its emphasis. The general pattern:

| Level | Introductory course | Advanced course |
| ----- | ------------------- | --------------- |
| Remember | Primary (new terms and facts) | Minimal (assume prerequisite mastery) |
| Understand | Primary (explaining concepts) | Occasional (new advanced concepts only) |
| Apply | Primary (using tools) | Frequent (advanced techniques) |
| Analyze | Occasional (basic comparisons) | Frequent (comparing approaches) |
| Evaluate | Rare (capstone work) | Frequent (judging scope, designs, results) |
| Create | Rare (final projects) | Frequent (designing solutions) |

Within an introductory course, shift the mix over the term: early
modules lean Remember/Understand with one Apply, middle modules lean
Apply, and late modules add Analyze. Reserve Evaluate and Create for
capstone-style work.

## Matching Assessment Types to Levels

Align every assessment item with the level of the objective it
measures. Testing an Apply objective with a definition quiz breaks
alignment.

| Level | Assessment types that fit |
| ----- | ------------------------- |
| Remember | Multiple choice on definitions, matching, labeling a diagram, fill-in-the-blank syntax |
| Understand | Explain in your own words, interpret an output or error message, classify examples, compare two approaches at a high level |
| Apply | Write code or configuration to meet a spec, modify working code for new requirements, execute a procedure on new inputs, calculate results |
| Analyze | Compare approaches and justify the choice, trace and deconstruct code or a schema, diagnose a fault from symptoms, categorize problems by solution strategy |
| Evaluate | Critique a submitted design against stated criteria, defend a recommendation, review code or a layout against a standard, prioritize competing fixes |
| Create | Design and build an original artifact (schema, program, page, analysis, repair plan), open-ended project with a rubric |

## Common Mistakes to Avoid

* Using a vague verb (know, learn, understand) instead of a measurable
  one.
* Writing an objective no assessment in the module measures.
* Packing two verbs into one objective.
* Pitching the level wrong for the course (a Create objective in week
  2 of an intro course, or a Remember objective in an advanced course
  whose prerequisite already covered the term).
* Leaving an objective unmapped to a section number.
* Mixing wildly inconsistent levels within one module without a
  reason.

## References

* Bloom, B. S. (1956). *Taxonomy of Educational Objectives.*
* Anderson, L. W., & Krathwohl, D. R. (2001). *A Taxonomy for
  Learning, Teaching, and Assessing: A Revision of Bloom's Taxonomy of
  Educational Objectives.*
