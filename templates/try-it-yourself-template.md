# Try It Yourself Template (Predict-Run-Explain Pattern): CIS376

**Purpose:** the Predict-Run-Explain pattern forces active learning by requiring predictions before answers. Retrieval attempts before seeing content improve retention by 30-50% (Roediger & Butler, 2011).

## Format

```markdown
### Try It Yourself N.X: [Descriptive Title] 🛠️

**Predict:** [Question requiring a prediction BEFORE executing code or
examining results. Focus on reasoning about WHY something would happen,
not just WHAT.]

**Run:** [Specific code to execute, file to examine, or task to
perform. Keep it focused: 2-7 minutes.]

**Explain:** [Prompt requiring a 1-2 sentence explanation of WHY the
result occurred. Connect to the concept being taught, not just a
description of the output.]
```

## Guidelines

* **Predict** questions target reasoning or common misconceptions, not just output guessing
* **Run** tasks stay short: 2-5 minutes for introductory courses, 3-7 minutes for advanced courses
* **Explain** prompts emphasize WHY and WHEN decisions matter, not just WHAT happened
* Focus on common pitfalls in PostgreSQL 17, psql, pgAdmin 4, SQL, calibrated to community college students who have completed one SQL course and are moving into database administration and security
* 1-2 exercises per major section, placed immediately after a new concept
* Pattern within a section: Teach, Show, Try, Build

## Pattern Variations

Pick the variation that fits the concept. All keep the three steps.

* **Code prediction (most common):** show unfamiliar code, ask for the specific output before running
* **Error prediction:** show broken code, ask students to identify the error before running, then read the message
* **Output comparison:** run two similar approaches and ask when each one wins
* **Conceptual prediction (no code):** ask students to choose and justify an approach before any execution
* **Result exploration:** ask for an estimate (size, shape, count), then check against the actual data

## Writing Each Step

**Predict:** make it specific enough that students cannot skip it. Offer concrete choices ("will this print 3, 5, or raise an error?") and target a misconception. Students should spend 30-60 seconds here.

**Run:** provide complete, runnable code or an exact task. Be specific about what to observe. One concept per exercise. Multi-step procedures belong in the Skills Lab, not here.

**Explain:** require causal reasoning ("why" or "how"), limited to 1-2 sentences. Never ask "what did you observe" (that is the Run step) or anything students can copy from the text.

## Examples (from a Python-based course, adapt to PostgreSQL 17, psql, pgAdmin 4, SQL)

### Example: Analytical Reasoning Context

```markdown
### Try It Yourself 7.2: Correlation vs. Causation 🛠️

**Predict:** The dataset shows a strong positive correlation (r = 0.87)
between ice cream sales and drowning incidents. Before running any
further analysis, what would you conclude about causation? What
confounding variable might explain this relationship?

**Run:** Execute the code to calculate partial correlations controlling
for temperature. Compare the original correlation with the partial
correlation.

**Explain:** Why did the correlation change after controlling for
temperature? What does this tell you about drawing conclusions from
correlation alone?
```

### Example: Error Prediction Context

```markdown
### Try It Yourself 4.1: Column Name Errors 🛠️

**Predict:** The code below contains an error. Before running it,
identify what you think the error will be.

    import pandas as pd
    df_sales = pd.read_csv('sales.csv')
    print(df_sales['Total_Sales'])  # Actual column name is 'total_sales'

**Run:** Run the code and read the error message carefully.

**Explain:** What type of error occurred? How could you prevent this
error in the future?
```

## Anti-Patterns to Avoid

* Predict questions that just ask "What will the output be?" with no reasoning required (too narrow)
* Vague prompts like "What do you think will happen?" (skippable)
* Run tasks longer than 7 minutes (too long for retrieval practice)
* Run steps without complete, executable code when code is required
* Explain prompts answerable with "It worked" (too shallow)
* Explain prompts that let students copy a sentence from the text
* Questions that reteach One prior SQL course (Introduction to Oracle: SQL, CIS276DA MySQL Database, or CIS276DB SQL Server Database) concepts instead of building on them

## Alignment and Placement

Each Try It Yourself supports at least one Module Learning Objective:

* Exercise targets a specific MLO
* Bloom's level matches the MLO level (an Apply MLO gets a hands-on Run step)
* Difficulty fits the chapter position
* Builds toward the Skills Lab assessment

Balance with Quick Checks: Try It Yourself gives hands-on application embedded during content 🛠️. Quick Checks give retrieval practice at the end of each major section ✅. Use both in every section.

## Why This Works (Research Backing)

* **Desirable difficulty (Bjork, 1994):** harder work during learning improves long-term retention
* **Testing effect (Roediger & Butler, 2011):** retrieval attempts before learning content improve retention by 30-50%
* **Metacognition:** students discover what they do NOT know, reducing the illusion of competence
* **Active learning (Freeman et al., 2014):** active engagement reduces failure rates by 55% compared to passive learning

Remember: Try It Yourself exercises are learning tools, not assessment. Keep stakes low so students feel safe making mistakes and learning from them.

## Final Checklist

* [ ] All three steps present (Predict, Run, Explain)
* [ ] Predict targets a misconception or requires a specific choice
* [ ] Run provides complete, executable code (if a coding exercise)
* [ ] Run takes 2-7 minutes maximum
* [ ] Explain requires causal reasoning, limited to 1-2 sentences
* [ ] Exercise aligns with at least one MLO
* [ ] Placement immediately follows the concept introduction
* [ ] Title is descriptive and specific
