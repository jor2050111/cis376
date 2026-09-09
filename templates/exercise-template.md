# Exercise Template (CIS376: Database Management and Security)

**Note:** This textbook structure uses the Skills Lab format (see the chapter template) instead of separate graded exercises. Use this template only when supplementary standalone exercises are needed (practice sets, review packets, workshop activities).

## Skills Lab Format (Primary: Use This)

See `/templates/chapter-template.md` Section N.6 for the Skills Lab format with:

* Part 1: Foundation
* Part 2: Application
* Part 3: Extension
* Questions & Analysis (2 questions)
* The locked universal rubric

## Standalone Exercise Format (Supplementary Only)

```markdown
**[Foundation/Application/Extension]: [Descriptive Exercise Title]**

**Objective:** [Specify which learning objective(s) this addresses]

**Scenario:** [Provide an industry-relevant context that makes the
exercise meaningful to community college students who have completed one SQL course and are moving into database administration and security. Scenarios should involve genuine
decisions, not just tool usage.]

**Dataset or starter files:** [Specify the file(s) from the course data
pack (assets/code/chapter-NN/)]

**Tasks:**
1. [Specific, actionable step]
2. [Step building on the previous one with increased complexity]
3. [Step requiring decision-making or justification]
[Continue as needed]

**Expected Output:** [Clearly describe what a working solution produces,
including any written analysis or justification required]

**Hints:** [Provide 1-2 hints that guide thinking without giving away
the solution]
```

## Difficulty Calibration

**Foundation:**

* Applies ONE concept from the chapter
* Clear guidance, but requires reasoning (not just copying code)
* 20-30 minutes expected completion
* 90% of CIS376 students should complete successfully

**Application:**

* Combines 2-3 concepts with judgment required
* Less structured, requires choosing approaches
* 45-60 minutes expected completion
* 70% of CIS376 students should complete successfully

**Extension:**

* Integrates concepts across chapters with professional-quality output
* Open-ended, may require communication or presentation
* 60-90 minutes expected completion
* Stretch goal for motivated students

## Optional Components for Fuller Exercises

Add any of these blocks when a standalone exercise needs more scaffolding. Code samples below come from a Python-based course. Adapt them to PostgreSQL 17, psql, pgAdmin 4, SQL.

### Starter Code

```python
# EXAMPLE from a Python-based course. Adapt to PostgreSQL 17, psql, pgAdmin 4, SQL.
# Starter code for Exercise [Chapter].[Number]
# TODO: [What students need to implement]

import pandas as pd

def your_function_name():
    """[Docstring describing what to implement]."""
    # Your code here
    pass
```

### Progressive Hints (collapsible)

```markdown
<details>
<summary>Click to reveal Hint 1</summary>

[Subtle guidance without giving away the solution]

</details>

<details>
<summary>Click to reveal Hint 2</summary>

[More specific guidance if students are still stuck]

</details>
```

### Solution (collapsible)

```markdown
<details>
<summary>Click to reveal solution (try the exercise first!)</summary>

[Well-commented code showing one correct approach. Explain key
decisions and why this approach works. Point out alternatives.]

</details>
```

### Common Mistakes

List 2-3 errors students often make with this type of problem. For each one, give the mistake, why it happens, and how to fix it.

### Reflection Questions

1. [Question prompting students to think about what they learned]
2. [Question about alternative approaches or trade-offs]
3. [Question connecting the exercise to industry applications]
