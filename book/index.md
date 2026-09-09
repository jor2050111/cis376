# CIS376: Database Management and Security

Welcome to the CIS376 textbook. Plan, secure, monitor, and recover PostgreSQL databases that meet business and regulatory requirements, from architecture through incident response.

## About This Textbook

This textbook is designed for **community college students who have completed one SQL course and are moving into database administration and security**. You already write queries. This book asks the questions that come after the query works: who may run it, what it exposes, how fast it runs, what happens when the server fails, and what the law requires when someone reads data they should not.

You work the whole book as the database administrator for Copperwind IT Services, a fictional managed services provider in Phoenix. Copperwind hosts databases for two regulated clients, a family clinic covered by HIPAA and a charter school covered by FERPA. Every chapter puts you on a live PostgreSQL server making a management or security decision for one of them.

### Course Learning Outcomes

This textbook teaches to the official course learning outcomes (CLOs) for CIS376:

* **CLO I (Analyze):** Analyze database architecture and design for business solutions.
* **CLO II (Evaluate):** Assess security management for database environments.
* **CLO III (Create):** Develop strategies to maintain optimal system performance, security and availability.
* **CLO IV (Evaluate):** Evaluate practices for database environment incident responses.
* **CLO V (Evaluate):** Critique current practices and future trends of database management and security.

Every chapter opens with three Module Learning Objectives and names the CLOs it serves, so you can see how the chapter work supports these outcomes.

## How This Textbook Is Organized

The textbook is divided into **four parts** spanning **12 chapters**. Instructors can map the same chapters into 9-, 12-, 14-, or 16-week courses without changing the chapter content. Course calendars, due dates, and exams belong in your course shell.

### Part I: Architecture and Design (Chapters 1-3)

Decide what to build, where it runs, and what shape the data takes. You set up your server, place and size a database for a business, and model data so the database defends its own correctness.

### Part II: Securing Access and Data (Chapters 4-6)

Decide who may see what, and prove it with configuration. You classify data under HIPAA and FERPA, grant least privilege by role, and encrypt what remains exposed.

### Part III: Monitoring, Performance, and Availability (Chapters 7-9)

Watch the server, keep it fast, and keep it recoverable. You configure auditing, tune queries with measured evidence, design redundancy, and run a recovery drill.

### Part IV: Response and Professional Practice (Chapters 10-12)

Respond when controls fail, keep the routine that prevents the next failure, and judge what comes next. You investigate a breach, build a scheduled review, and write the management and security plan for a whole database environment.

## Technology Stack

| Tool | Purpose |
|------|---------|
| **PostgreSQL 17** | The database server you manage and secure |
| **psql** | The command-line client for every script and check in this book |
| **pgAdmin 4** | The graphical client for browsing objects and reading plans |
| **SQL** | The language you already know, now used to configure and verify controls |
| **The course data pack** | Setup scripts, synthetic data, logs, backups, and starter files for every chapter |

## Getting Started

Start with [Chapter 1: Database Management and Security Fundamentals](chapters/chapter-01.md) to install your server, load the course databases, and take on the Copperwind role.
