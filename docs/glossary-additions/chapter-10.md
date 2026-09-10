# Glossary additions: Chapter 10

Terms bolded on first use in `book/chapters/chapter-10.md`, in the
definition-list format, alphabetical. Terms already in
`book/glossary.md` (audit trail, covered entity, education record,
event classification, protected health information, routine, server
log, suspicious, violation) are not repeated. Chapter 10 defines a
plain `event` as the base of the incident ladder, which is broader than
the `audit event` Chapter 7 defined as one recordable action.

action item
:   A line in an after-action report that names what will change, who owns it, when it is due, and the evidence that will prove it happened. A change with no owner and no date is a wish, not an action item.

after-action report
:   The written product of the lessons-learned phase, covering the summary, timeline, scope, root cause, what worked and what did not, and the action items. It is the part of incident response that changes the next incident.

breach
:   An incident in which protected data was acquired, accessed, used, or disclosed without authorization. Only this rung of the ladder starts legal notification clocks. HIPAA presumes a breach from an impermissible use or disclosure unless a risk assessment shows a low probability of compromise (45 CFR 164.402).

California Consumer Privacy Act (CCPA)
:   A California privacy statute that creates a private right of action for a consumer whose nonencrypted and nonredacted personal information is exposed by a failure to maintain reasonable security (California Civil Code 1798.150). It sets no notification deadline of its own.

containment
:   The response phase that stops harm from continuing without erasing the record of how it happened. In PostgreSQL the pairing that does both is `ALTER ROLE ... NOLOGIN` plus `pg_terminate_backend()`.

encryption safe harbor
:   The provision under which protected data rendered unusable, unreadable, or indecipherable by an approved method is not treated as unsecured, so its exposure requires no notification. State breach statutes take the same shape by defining a breach only for unencrypted data.

eradication
:   The response phase that removes the condition an incident used, not only the symptom it produced. Revoking an over-granted privilege is eradication. Locking the account that used it is containment.

event
:   Anything the server records. An event becomes a security incident when it violates a policy or threatens confidentiality, integrity, or availability, and becomes a breach when protected data was acquired or disclosed.

forensic timeline
:   An ordered account of an incident in which every row carries an instant, the source of the evidence, and the event, under one stated time zone. Without the stated zone the times cannot be checked by anyone else.

General Data Protection Regulation (GDPR)
:   The European Union regulation that requires a controller to notify the supervisory authority of a personal data breach without undue delay and, where feasible, within 72 hours of becoming aware of it (Article 33). Data subjects are notified when the risk to them is high (Article 34).

incident commander
:   The role that owns the sequence, the clock, and the record of decisions during an incident. It does not own the technical fix or the notification decision.

incident response plan
:   The written sequence a team follows during an incident, covering preparation, detection and analysis, containment, eradication, recovery, and lessons learned, with the people and the exit test for each phase named in advance.

personal information
:   The category of data a state breach statute protects, defined by a closed list and not by intuition. Arizona defines it as a name plus at least one specified data element, or an email address or username with the password that opens the account (A.R.S. 18-551(7)).

root cause
:   The condition without which an incident could not have happened. A root cause names a decision or a missing control, never a person.

scope analysis
:   The reading step of an investigation, which establishes where an incident came from, how far it reached, and when it started and stopped, using the server log and the audit trail as its evidence.

security incident
:   An event, or a set of events, that violates a security policy or threatens confidentiality, integrity, or availability. An outage is a security incident even when no data leaked.

specified data element
:   One of the data types a state breach statute lists as making a name into personal information. Arizona's list holds Social Security, driver license, passport, and taxpayer identification numbers, a private key, a financial account number with its access code, a health insurance identification number, medical or mental health treatment information, and biometric data (A.R.S. 18-551(11)).

unsecured protected health information
:   Protected health information that has not been rendered unusable, unreadable, or indecipherable to unauthorized persons by a technology or methodology the Secretary of Health and Human Services specifies (45 CFR 164.402). Only a breach of unsecured protected health information triggers HIPAA notification.
