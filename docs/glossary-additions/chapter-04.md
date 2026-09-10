# Glossary Additions: Chapter 4

Terms bolded on first use in Chapter 4, in definition-list format,
alphabetical. The maintainer merges these into `book/glossary.md`.

administrative safeguards
:   The HIPAA Security Rule's policy and people requirements (45 CFR 164.308): risk analysis, workforce access rules, training, incident procedures, and contingency planning.

business associate
:   An outside organization that creates, receives, maintains, or transmits protected health information on a covered entity's behalf (45 CFR 160.103). A hosting provider such as Copperwind is one, and the Security Rule applies to it directly.

covered entity
:   A health plan, a health care clearinghouse, or a health care provider that transmits health information electronically (45 CFR 160.103). HIPAA's rules apply to it.

data classification
:   Assigning each data element a sensitivity level (Public, Internal, Confidential, Restricted) that decides how it is stored, who may see it, and how it is disposed of.

de-identification
:   The HIPAA standard (45 CFR 164.514(b)) under which health information stops being PHI once the eighteen listed identifiers are removed and there is no reasonable basis to identify anyone.

directory information
:   Information in an education record that would not generally be considered harmful or an invasion of privacy if disclosed (34 CFR 99.3). A school may release it only after public notice and only for students whose parents have not opted out (34 CFR 99.37).

disposal log
:   A record of each destruction run: the record series, the cutoff, the number of rows destroyed, the authority, who ran it, and when. Part of the documentation HIPAA keeps for six years.

education record
:   Any record directly related to a student that a school, or a party acting for it, maintains (34 CFR 99.3). FERPA governs its disclosure.

eligible student
:   A student who has reached 18 or is attending a postsecondary institution. FERPA rights transfer from the parents to the eligible student (34 CFR 99.5).

legal hold
:   A suspension of the retention schedule for specific records because of litigation, an investigation, a records request, or a complaint. A hold outranks the schedule and must be visible to the disposal run.

legitimate educational interest
:   The FERPA basis on which a school official may see an education record without consent (34 CFR 99.31(a)(1)). The school defines it and must use reasonable methods to limit officials to the records it covers.

minimum necessary standard
:   The HIPAA requirement to limit protected health information to the minimum needed for a use, disclosure, or request (45 CFR 164.502(b)), implemented by naming classes of workers and the PHI each class needs (45 CFR 164.514(d)).

physical safeguards
:   The HIPAA Security Rule's requirements for facilities, workstations, and media (45 CFR 164.310), including the disposal of media that held PHI.

protected health information (PHI)
:   Individually identifiable health information that a covered entity or business associate holds or transmits in any form (45 CFR 160.103). Health information becomes PHI when joined to any of eighteen identifiers such as a name, a date, a phone number, or a member number.

retention schedule
:   A written table that names each record series, the event that starts its clock, how long it is kept, how it is destroyed, and the authority for the rule.

schema
:   A named container for tables, views, and other objects inside one database. A role needs USAGE on a schema before it can reach anything inside it, which makes the schema a security boundary.

secure deletion
:   Removal of data from every place it could still be read (the table, the write-ahead log, backups, replicas, and exports), with a record that proves it.

Security Rule
:   The HIPAA regulation at 45 CFR Part 164, Subpart C, that protects electronic protected health information through administrative, physical, and technical safeguards.

technical safeguards
:   The HIPAA Security Rule's controls inside the system (45 CFR 164.312): access control, audit controls, integrity, person or entity authentication, and transmission security.
