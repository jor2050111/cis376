# Skills Lab 4A Answers: Classify and Separate Sandwash Clinic Data

**Name:**

## Part 1: Classification Register

One row per column in all five clinic tables. Levels: Public,
Internal, Confidential, Restricted. In the HIPAA identifier column,
name the identifier from 45 CFR 164.514(b) or write "no".

| Table | Column | Level | HIPAA identifier | Reason |
| ----- | ------ | ----- | ---------------- | ------ |
| providers | provider_id | | | |
| providers | full_name | | | |
| providers | specialty | | | |
| providers | npi | | | |
| patients | patient_id | | | |
| patients | first_name | | | |
| patients | last_name | | | |
| patients | date_of_birth | | | |
| patients | phone | | | |
| patients | email | | | |
| patients | address | | | |
| patients | insurance_member_id | | | |
| appointments | appointment_id | | | |
| appointments | patient_id | | | |
| appointments | provider_id | | | |
| appointments | scheduled_at | | | |
| appointments | status | | | |
| appointments | visit_type | | | |
| visit_notes | note_id | | | |
| visit_notes | appointment_id | | | |
| visit_notes | diagnosis_code | | | |
| visit_notes | note_text | | | |
| staff_accounts | account_id | | | |
| staff_accounts | username | | | |
| staff_accounts | role_name | | | |
| staff_accounts | provider_id | | | |

### The join path (Part 1, step 3)

## Part 2: Separation

### Tables moved to clinic_restricted and why

### Columns in clinic.frontdesk_schedule and why each is the minimum

### Evidence (point to the marker 2.3 output)

## Part 3: Retention Policy

Paste your completed `retention-policy-template.md` here, or attach it
beside this file.

### Memo to Dr. Vasquez

## Questions & Analysis

### Question 1

### Question 2
