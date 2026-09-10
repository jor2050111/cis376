# Database Management and Security Plan (Template)

Fill this template for one organization. Every section asks for a
decision and the evidence behind it. A blank cell is a finding, so
write "not decided yet" and name the person who owes the answer rather
than leaving it empty.

Replace every bracketed prompt with your own text. Keep the numbering.

## 1. Scope and Ownership

* Organization and database this plan covers: [name]
* Data owner who signs the plan: [name and title]
* Database administrator who maintains it: [name]
* Security reviewer who approves access changes: [name]
* Date of this version and the date of the next review: [dates]

## 2. Architecture

State where the database runs and why that placement fits the data.

* Service model (on-premise, managed cloud service, or both): [choice]
* Network tier the database sits in and what may reach it: [answer]
* Server version and current size: [paste the architecture evidence query result]
* One sentence on why this placement, not the alternative: [answer]

## 3. Access Control

List every role, what it may read or change, and who approved it.

| Role | Purpose | Privileges granted | Approved by |
| ---- | ------- | ------------------ | ----------- |
| | | | |
| | | | |

* Evidence that the grants match this table: [paste the access evidence query result]
* Accounts reviewed and removed since the last version: [answer]

## 4. Compliance

Name the regulation, the data it covers, and the control that answers it.

| Regulation | Data covered | Control in this plan | Where the evidence lives |
| ---------- | ------------ | -------------------- | ------------------------ |
| | | | |
| | | | |

* Classification of every table in scope: [answer]
* Retention rule and the authority behind it: [answer]

## 5. Performance and Capacity

* The two or three reports that must stay fast, with their current timing: [answer]
* Indexes and settings this plan depends on: [answer]
* Projected size in 12 and 36 months, and the measurement behind it: [answer]

## 6. Recovery and Availability

* Recovery time objective and recovery point objective, with the owner who set them: [answers]
* Backup method, frequency, storage location, and retention: [answer]
* Date of the last restore drill and its measured time: [answer]
* Acceptance check the restore must pass: [paste the recovery evidence query result]

## 7. Incident Response

* Who is called first, and who declares an incident: [names]
* Containment step that preserves evidence: [answer]
* Notification obligations this data can trigger, and who decides: [answer]
* Where the after-action report is filed: [answer]

## 8. Skills Matrix

Fill this table last. It maps the work in this plan to the roles that
do it. Follow these steps so the matrix stays honest:

1. List only the plan sections you completed above.
2. For each one, name the task in the words you would use to a manager.
3. Name the role that owns the task in a larger organization.
4. Cite the evidence in this plan that shows you did the work.

| Plan section | Task you performed | Role that owns it | Evidence in this plan |
| ------------ | ------------------ | ----------------- | --------------------- |
| | | | |
| | | | |
| | | | |

## 9. Open Items

List anything the plan cannot answer yet, who owes the answer, and what
blocks the work until it arrives.

| Open item | Owner | Blocks what |
| --------- | ----- | ----------- |
| | | |
