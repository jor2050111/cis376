#!/usr/bin/env python3
"""Generate every synthetic dataset and fixture in the CIS376 data pack.

Three fictional organizations (see docs/book-design-spec-2026-09-09.md):

* copperwind_ops       Copperwind IT Services, the MSP the student works for
* sandwash_clinic      Sandwash Family Clinic, a HIPAA covered entity
* harquahala_academy   Harquahala Charter Academy, a FERPA school

Design rules this script enforces:

* Base seed 376. A rerun is byte-identical (the asserts and the
  `--check` mode prove it).
* Standard library only, so the pack rebuilds on any machine with
  Python 3.
* The shared CSVs are written ONCE to assets/code/data/<org>/ and every
  chapter's setup script loads from there. The family default ships
  per-chapter copies, but the Copperwind ticket history alone is
  several megabytes, and twelve copies would bloat the repo and the
  student zip. Chapter independence is preserved: a chapter needs only
  the pack, never work saved from another chapter.
* Chapter-specific fixtures (a flat gradebook export, server log
  excerpts, a scan report, breach audit rows) are written to their
  chapter folders.
* Every engineered property a chapter depends on has an assert.

Usage (from the repo root):

    python3 assets/code/_generators/generate_course_data.py
    python3 assets/code/_generators/generate_course_data.py --check

`--check` regenerates into a temp directory and diffs against the
committed files, exiting non-zero on any difference.
"""

from __future__ import annotations

import argparse
import csv
import filecmp
import hashlib
import io
import random
import shutil
import sys
import tempfile
from datetime import date, datetime, timedelta
from pathlib import Path

SEED = 376
REPO = Path(__file__).resolve().parents[3]
ASSETS = REPO / "assets" / "code"

# --------------------------------------------------------------------------
# Family canon (from cis215/assets/code/_generators/generate_copperwind_data.py)
# --------------------------------------------------------------------------
TECHNICIANS = [
    ("Priya Sharma", "Deskside", 2019),
    ("Malik Johnson", "Deskside", 2021),
    ("Mei Lin", "Network Ops", 2018),
    ("Diego Ramos", "Deskside", 2022),
    ("Amara Okafor", "Network Ops", 2020),
    ("Sofia Reyes", "Deskside", 2023),
    ("Ethan Cole", "Deskside", 2024),
    ("Naomi Redhouse", "Network Ops", 2021),
]
CATEGORIES = ["Hardware", "Software", "Network", "Security", "Accounts"]
CATEGORY_WEIGHTS = [28, 30, 18, 9, 15]
PRIORITIES = ["Low", "Medium", "High", "Critical"]
PRIORITY_WEIGHTS = [35, 40, 20, 5]
VALLEY_CITIES = ["Phoenix", "Mesa", "Tempe", "Chandler", "Glendale",
                 "Scottsdale", "Gilbert", "Peoria", "Surprise", "Avondale"]

# 40 fictional Valley clients. The two regulated clients this book
# manages come first so their client_ids are stable (1 and 2).
CLIENTS = [
    ("Sandwash Family Clinic", "Healthcare"),
    ("Harquahala Charter Academy", "Education"),
    ("Agave Family Dental", "Healthcare"),
    ("Camelback Kids Clinic", "Healthcare"),
    ("Verde River Physical Therapy", "Healthcare"),
    ("Sunrise Ridge Counseling", "Healthcare"),
    ("Desert Bloom Optometry", "Healthcare"),
    ("Mesquite Legal Group", "Legal"),
    ("Ironwood Estate Planning", "Legal"),
    ("Salt River Immigration Law", "Legal"),
    ("Papago Title and Escrow", "Legal"),
    ("Canyon Trail Charter School", "Education"),
    ("Sonoran Early Learning Center", "Education"),
    ("Westgate Tutoring Collective", "Education"),
    ("Palo Verde Music Academy", "Education"),
    ("Cactus Wren Outfitters", "Retail"),
    ("Copper State Bike Shop", "Retail"),
    ("Monsoon Coffee Roasters", "Retail"),
    ("Red Rock Running Company", "Retail"),
    ("Dust Devil Hardware", "Retail"),
    ("Javelina Pet Supply", "Retail"),
    ("Ocotillo Home Goods", "Retail"),
    ("Valley Harvest Food Bank", "Nonprofit"),
    ("Second Saguaro Thrift", "Nonprofit"),
    ("Desert Paws Rescue", "Nonprofit"),
    ("Bridges Youth Mentoring", "Nonprofit"),
    ("Grand Canal Arts Council", "Nonprofit"),
    ("Tortolita Senior Center", "Nonprofit"),
    ("Mariposa Community Housing", "Nonprofit"),
    ("Gila Bend Veterinary", "Healthcare"),
    ("Superstition Orthodontics", "Healthcare"),
    ("Quail Run Chiropractic", "Healthcare"),
    ("Thunderbird Court Reporting", "Legal"),
    ("Encanto Notary Services", "Legal"),
    ("Roadrunner STEM Academy", "Education"),
    ("Kachina Driving School", "Education"),
    ("Sagebrush Garden Center", "Retail"),
    ("Apache Junction Auto Glass", "Retail"),
    ("Arcadia Neighborhood Alliance", "Nonprofit"),
    ("Hohokam Heritage Museum", "Nonprofit"),
]
assert len(CLIENTS) == 40

FIRST_NAMES = [
    "Aaliyah", "Adrian", "Alma", "Andre", "Beatriz", "Benjamin", "Carla",
    "Carlos", "Celeste", "Daniel", "Dolores", "Elijah", "Esperanza",
    "Felix", "Gabriela", "Gavin", "Hana", "Hector", "Imani", "Isaac",
    "Jasmine", "Javier", "Jonah", "Kaya", "Leon", "Lucia", "Marcus",
    "Marisol", "Nadia", "Nathan", "Olivia", "Omar", "Paloma", "Quentin",
    "Rafael", "Renata", "Samuel", "Serena", "Tanya", "Tomas", "Uriel",
    "Valeria", "Victor", "Wren", "Xavier", "Yara", "Yusuf", "Zoe",
    "Ana", "Miguel", "Rosa", "Sebastian", "Talia", "Diego", "Noor",
    "Kenji", "Lena", "Mateo", "Nia", "Owen",
]
LAST_NAMES = [
    "Acosta", "Begay", "Bennett", "Castillo", "Chavez", "Chen", "Cruz",
    "Delgado", "Dominguez", "Espinoza", "Flores", "Foster", "Garcia",
    "Gomez", "Gutierrez", "Hernandez", "Ibarra", "Jackson", "Jimenez",
    "Kim", "Lopez", "Martinez", "Medina", "Mendoza", "Morales", "Nguyen",
    "Ortiz", "Padilla", "Patel", "Perez", "Ramirez", "Reyes", "Rivera",
    "Robinson", "Romero", "Salazar", "Sanchez", "Santos", "Silva",
    "Singh", "Torres", "Tsosie", "Valdez", "Vargas", "Vasquez", "Velasquez",
    "Washington", "Williams", "Yazzie", "Young",
]
STREETS = ["Camelback Rd", "Indian School Rd", "Thomas Rd", "McDowell Rd",
           "Bethany Home Rd", "Glendale Ave", "Northern Ave", "Dunlap Ave",
           "Peoria Ave", "Cactus Rd", "Thunderbird Rd", "Greenway Rd",
           "Bell Rd", "Union Hills Dr", "Baseline Rd", "Southern Ave"]


def write_csv(path: Path, header: list[str], rows: list[list]) -> None:
    """Write rows with a fixed dialect so reruns are byte-identical."""
    path.parent.mkdir(parents=True, exist_ok=True)
    buf = io.StringIO()
    writer = csv.writer(buf, lineterminator="\n")
    writer.writerow(header)
    writer.writerows(rows)
    path.write_text(buf.getvalue(), encoding="utf-8")


def person_name(rng: random.Random) -> tuple[str, str]:
    return rng.choice(FIRST_NAMES), rng.choice(LAST_NAMES)


def phone(rng: random.Random) -> str:
    return f"602-555-{rng.randint(0, 9999):04d}"


def ts(dt: datetime) -> str:
    return dt.strftime("%Y-%m-%d %H:%M:%S")


# --------------------------------------------------------------------------
# copperwind_ops
# --------------------------------------------------------------------------
TICKET_SUMMARIES = {
    "Hardware": ["Laptop will not power on", "Printer jams on every job",
                 "Monitor flickers after sleep", "Docking station not detected",
                 "Replace failing SSD", "Keyboard keys unresponsive"],
    "Software": ["Excel crashes on open", "Update failed to install",
                 "Email client stuck offline", "License activation error",
                 "PDF reader missing", "Browser extension breaks portal"],
    "Network": ["Wi-Fi drops in back office", "VPN will not connect",
                 "Slow file share access", "Switch port down",
                 "DNS resolution failing", "Guest network open to staff VLAN"],
    "Security": ["Phishing email reported", "Suspicious login alert",
                 "Malware quarantine review", "USB device policy violation",
                 "Password reset after compromise", "Firewall rule review"],
    "Accounts": ["New hire account setup", "Terminated user offboarding",
                 "Shared mailbox access", "MFA device replacement",
                 "Password reset request", "Group membership change"],
}


def month_range(start: date, months: int) -> list[date]:
    out, y, m = [], start.year, start.month
    for _ in range(months):
        out.append(date(y, m, 1))
        m += 1
        if m == 13:
            y, m = y + 1, 1
    return out


def build_copperwind(rng: random.Random, out: Path) -> dict:
    org = out / "copperwind"
    # clients
    client_rows = []
    for i, (name, sector) in enumerate(CLIENTS, 1):
        start = date(2019, 1, 1) + timedelta(days=rng.randint(0, 2000))
        client_rows.append([i, name, sector, rng.choice(VALLEY_CITIES),
                            start.isoformat()])
    write_csv(org / "clients.csv",
              ["client_id", "client_name", "sector", "city", "contract_start"],
              client_rows)

    # technicians
    tech_rows = [[i, n, t, f"{y}-{rng.randint(1, 12):02d}-{rng.randint(1, 28):02d}"]
                 for i, (n, t, y) in enumerate(TECHNICIANS, 1)]
    write_csv(org / "technicians.csv",
              ["technician_id", "full_name", "team", "hire_date"], tech_rows)

    # tickets: 30 months, ~3 percent monthly growth, total pinned to 18240
    months = month_range(date(2024, 1, 1), 30)
    base = 383.0
    counts = [round(base * (1.03 ** k)) for k in range(30)]
    # Spread the rounding remainder over the last six months so the
    # growth curve stays smooth and the total is pinned.
    remainder = 18240 - sum(counts)
    for k in range(abs(remainder)):
        counts[29 - (k % 6)] += 1 if remainder > 0 else -1
    assert sum(counts) == 18240 and counts[-1] > counts[0] * 2
    # Security clusters: March 2025 and February 2026 carry a spike.
    spike_months = {date(2025, 3, 1), date(2026, 2, 1)}
    ticket_rows, note_rows = [], []
    ticket_id, note_id = 0, 0
    for month_start, n in zip(months, counts):
        next_month = month_range(month_start, 2)[1]
        days = (next_month - month_start).days
        for _ in range(n):
            ticket_id += 1
            opened = datetime.combine(month_start, datetime.min.time()) + timedelta(
                days=rng.randint(0, days - 1), hours=rng.randint(7, 18),
                minutes=rng.randint(0, 59), seconds=rng.randint(0, 59))
            weights = list(CATEGORY_WEIGHTS)
            if month_start in spike_months:
                weights[3] = 40  # Security spike
            category = rng.choices(CATEGORIES, weights)[0]
            priority = rng.choices(PRIORITIES, PRIORITY_WEIGHTS)[0]
            client_id = rng.randint(1, 40)
            tech = rng.randint(1, 8)
            hours = {"Low": 48, "Medium": 24, "High": 8, "Critical": 3}[priority]
            resolve = rng.expovariate(1 / hours)
            closed = opened + timedelta(hours=resolve)
            status = "Closed"
            if opened > datetime(2026, 6, 15) and rng.random() < 0.5:
                status, closed = "Open", None
            summary = rng.choice(TICKET_SUMMARIES[category])
            ticket_rows.append([ticket_id, client_id, tech, category, priority,
                                ts(opened), ts(closed) if closed else "",
                                status, summary])
            for k in range(rng.choices([1, 2, 3], [55, 35, 10])[0]):
                note_id += 1
                noted = opened + timedelta(minutes=rng.randint(5, 600) * (k + 1))
                note_rows.append([note_id, ticket_id, rng.randint(1, 8), ts(noted),
                                  rng.choice(["Contacted user", "Remote session started",
                                              "Parts ordered", "Escalated to Network Ops",
                                              "Resolved and confirmed with user",
                                              "Waiting on vendor", "Onsite visit scheduled",
                                              "Root cause documented"])])
    write_csv(org / "tickets.csv",
              ["ticket_id", "client_id", "technician_id", "category", "priority",
               "opened_at", "closed_at", "status", "summary"], ticket_rows)
    write_csv(org / "ticket_notes.csv",
              ["note_id", "ticket_id", "author_id", "noted_at", "note_text"],
              note_rows)
    assert len(ticket_rows) == 18240
    sec_by_month = {}
    for r in ticket_rows:
        key = r[5][:7]
        sec_by_month[key] = sec_by_month.get(key, 0) + (r[3] == "Security")
    assert sec_by_month["2025-03"] > 2 * sec_by_month["2025-02"]
    assert sec_by_month["2026-02"] > 2 * sec_by_month["2026-01"]

    # login_events: 12,000 rows, one failed-login burst from a single address
    usernames = ["copperwind_app", "copperwind_reports", "mlin", "nredhouse",
                 "ecole", "psharma", "aokafor", "dramos", "sreyes", "mjohnson"]
    office_ips = ["10.20.5.14", "10.20.5.22", "10.20.5.31", "10.20.5.40",
                  "10.20.7.8", "10.20.7.9"]
    login_rows = []
    event_id = 0
    start = datetime(2026, 6, 1)
    for _ in range(11800):
        event_id += 1
        when = start + timedelta(seconds=rng.randint(0, 60 * 86400))
        user = rng.choice(usernames)
        ok = rng.random() > 0.03
        login_rows.append([event_id, user, ts(when), rng.choice(office_ips),
                           "t" if ok else "f"])
    burst_start = datetime(2026, 7, 19, 2, 11, 0)
    for k in range(200):
        event_id += 1
        login_rows.append([event_id, rng.choice(["postgres", "admin", "copperwind_app",
                                                  "root", "backup"]),
                           ts(burst_start + timedelta(seconds=k * 7)),
                           "203.0.113.77", "t" if k == 199 else "f"])
    login_rows.sort(key=lambda r: r[2])
    for i, r in enumerate(login_rows, 1):
        r[0] = i
    write_csv(org / "login_events.csv",
              ["event_id", "username", "event_time", "source_ip", "success"],
              login_rows)
    assert len(login_rows) == 12000
    assert sum(1 for r in login_rows if r[3] == "203.0.113.77" and r[4] == "f") == 199
    return {"tickets": len(ticket_rows), "notes": len(note_rows),
            "logins": len(login_rows)}


# --------------------------------------------------------------------------
# sandwash_clinic
# --------------------------------------------------------------------------
SPECIALTIES = ["Family Medicine", "Family Medicine", "Family Medicine",
               "Pediatrics", "Pediatrics", "Internal Medicine",
               "Internal Medicine", "Nurse Practitioner", "Nurse Practitioner",
               "Physician Assistant", "Behavioral Health", "Family Medicine"]
DIAGNOSIS_CODES = ["Z00.00", "J06.9", "I10", "E11.9", "M54.5", "J45.909",
                   "F41.1", "K21.9", "E78.5", "N39.0", "L30.9", "R51.9"]
VISIT_TYPES = ["Annual physical", "Sick visit", "Follow-up", "Telehealth",
               "Well child", "Chronic care"]
INSURERS = ["AZB", "SUN", "CPR", "MRC", "DES"]


def build_sandwash(rng: random.Random, out: Path) -> dict:
    org = out / "sandwash"
    provider_rows = []
    for i in range(1, 13):
        f, l = person_name(rng)
        title = "Dr." if SPECIALTIES[i - 1] in ("Family Medicine", "Pediatrics",
                                                "Internal Medicine") else ""
        full = f"{title} {f} {l}".strip()
        provider_rows.append([i, full, SPECIALTIES[i - 1],
                              f"{rng.randint(1000000000, 1999999999)}"])
    provider_rows[0][1] = "Dr. Elena Vasquez"  # medical director, data owner
    write_csv(org / "providers.csv",
              ["provider_id", "full_name", "specialty", "npi"], provider_rows)

    patient_rows = []
    for i in range(1, 601):
        f, l = person_name(rng)
        dob = date(1940, 1, 1) + timedelta(days=rng.randint(0, 30000))
        email = f"{f.lower()}.{l.lower()}{rng.randint(1, 99)}@example.org"
        addr = f"{rng.randint(100, 9999)} W {rng.choice(STREETS)}, Phoenix, AZ 850{rng.randint(10, 51)}"
        member = f"{rng.choice(INSURERS)}-{rng.randint(100000000, 999999999)}"
        patient_rows.append([i, f, l, dob.isoformat(), phone(rng), email, addr, member])
    write_csv(org / "patients.csv",
              ["patient_id", "first_name", "last_name", "date_of_birth", "phone",
               "email", "address", "insurance_member_id"], patient_rows)

    appt_rows, note_rows = [], []
    note_id = 0
    # Every provider has patients: assign each patient a primary provider
    primary = {i: rng.randint(1, 12) for i in range(1, 601)}
    for i in range(1, 6001):
        patient_id = rng.randint(1, 600)
        provider_id = primary[patient_id] if rng.random() < 0.8 else rng.randint(1, 12)
        when = datetime(2019, 1, 2, 8, 0) + timedelta(
            days=rng.randint(0, 2700), minutes=15 * rng.randint(0, 36))
        status = rng.choices(["Completed", "No-show", "Cancelled", "Scheduled"],
                             [78, 7, 8, 7])[0]
        if when > datetime(2026, 9, 1):
            status = "Scheduled"
        appt_rows.append([i, patient_id, provider_id, ts(when), status,
                          rng.choice(VISIT_TYPES)])
        if status == "Completed" and rng.random() < 0.96:
            note_id += 1
            note_rows.append([note_id, i, rng.choice(DIAGNOSIS_CODES),
                              rng.choice(["Reviewed symptoms and history.",
                                          "Vitals stable. Continue current plan.",
                                          "Discussed lab results with patient.",
                                          "Medication adjusted. Recheck in 6 weeks.",
                                          "Referred to specialist.",
                                          "Preventive counseling provided."])])
    write_csv(org / "appointments.csv",
              ["appointment_id", "patient_id", "provider_id", "scheduled_at",
               "status", "visit_type"], appt_rows)
    write_csv(org / "visit_notes.csv",
              ["note_id", "appointment_id", "diagnosis_code", "note_text"], note_rows)
    providers_with_patients = {r[2] for r in appt_rows}
    assert providers_with_patients == set(range(1, 13))
    old_notes = sum(1 for a in appt_rows if a[3] < "2020-09-01")
    assert old_notes > 500  # retention window material for Ch 4 and Ch 9

    staff_rows = []
    roles = (["provider"] * 12 + ["frontdesk"] * 4 + ["billing"] * 2
             + ["office_manager", "it_admin"])
    for i, role in enumerate(roles, 1):
        if role == "provider":
            full = provider_rows[i - 1][1].replace("Dr. ", "")
            provider_id = i
        else:
            f, l = person_name(rng)
            full = f"{f} {l}"
            provider_id = ""
        username = (full.split()[0][0] + full.split()[-1]).lower()
        staff_rows.append([i, username, role, provider_id])
    staff_rows[16][1], staff_rows[18][1] = "gyazzie", "treyes"
    seen: set[str] = set()
    for row in staff_rows:
        base = row[1]
        while row[1] in seen:
            row[1] = base + str(len(seen))
        seen.add(row[1])
    assert len({r[1] for r in staff_rows}) == len(staff_rows)
    write_csv(org / "staff_accounts.csv",
              ["account_id", "username", "role_name", "provider_id"], staff_rows)
    return {"patients": len(patient_rows), "appointments": len(appt_rows),
            "notes": len(note_rows)}


# --------------------------------------------------------------------------
# harquahala_academy
# --------------------------------------------------------------------------
COURSE_NAMES = ["Reading", "Mathematics", "Science", "Social Studies",
                "Art", "Music", "Physical Education", "Spanish"]
STAFF_ROLES = ["Teacher"] * 44 + ["Registrar", "Counselor", "Counselor",
                                   "Admin", "Admin"] + ["Teacher"] * 11


def build_harquahala(rng: random.Random, out: Path) -> dict:
    org = out / "harquahala"
    student_rows = []
    for i in range(1, 801):
        f, l = person_name(rng)
        grade = rng.randint(0, 8)
        dob = date(2026 - 5 - grade, 1, 1) + timedelta(days=rng.randint(0, 364))
        opt_out = "t" if rng.random() < 0.08 else "f"
        student_rows.append([i, f, l, dob.isoformat(), grade, opt_out])
    write_csv(org / "students.csv",
              ["student_id", "first_name", "last_name", "date_of_birth",
               "grade_level", "directory_opt_out"], student_rows)
    opt_outs = sum(1 for r in student_rows if r[5] == "t")
    assert 45 <= opt_outs <= 85

    guardian_rows, link_rows = [], []
    gid = 0
    for s in student_rows:
        n_guard = rng.choices([1, 2], [40, 60])[0]
        for k in range(n_guard):
            gid += 1
            f = rng.choice(FIRST_NAMES)
            last = s[2] if rng.random() < 0.7 else rng.choice(LAST_NAMES)
            email = f"{f.lower()}.{last.lower()}{rng.randint(1, 999)}@example.org"
            guardian_rows.append([gid, f"{f} {last}", phone(rng), email,
                                  rng.choice(["Mother", "Father", "Guardian",
                                              "Grandparent"])])
            link_rows.append([s[0], gid, "t" if k == 0 else "f"])
        if gid >= 1200:
            break
    # Students past the cutoff still need at least one guardian link.
    linked = {r[0] for r in link_rows}
    for s in student_rows:
        if s[0] not in linked:
            link_rows.append([s[0], rng.randint(1, len(guardian_rows)), "t"])
    write_csv(org / "guardians.csv",
              ["guardian_id", "full_name", "phone", "email", "relationship"],
              guardian_rows)
    write_csv(org / "student_guardians.csv",
              ["student_id", "guardian_id", "is_primary"], link_rows)

    staff_rows = []
    for i in range(1, 61):
        f, l = person_name(rng)
        staff_rows.append([i, f"{f} {l}", STAFF_ROLES[i - 1]])
    staff_rows[44] = [45, "Luis Ortega", "Registrar"]
    staff_rows[47] = [48, "Dana Whitfield", "Admin"]
    staff_rows[0] = [1, "Keisha Bell", "Teacher"]
    write_csv(org / "staff.csv", ["staff_id", "full_name", "role_name"], staff_rows)

    course_rows = []
    cid = 0
    for grade in range(0, 9):
        for name in COURSE_NAMES[: 4 if grade < 3 else 5]:
            cid += 1
            course_rows.append([cid, f"Grade {grade} {name}", grade])
    course_rows = course_rows[:40]
    write_csv(org / "courses.csv", ["course_id", "course_name", "grade_level"],
              course_rows)

    teachers = [r[0] for r in staff_rows if r[2] == "Teacher"]
    section_rows = []
    sid = 0
    for c in course_rows:
        for term in ("Fall 2025", "Spring 2026", "Fall 2026"):
            sid += 1
            section_rows.append([sid, c[0], rng.choice(teachers), term])
    write_csv(org / "sections.csv",
              ["section_id", "course_id", "staff_id", "term"], section_rows)

    enroll_rows, grade_rows = [], []
    eid = 0
    by_grade = {}
    for sec in section_rows:
        course = course_rows[sec[1] - 1]
        by_grade.setdefault(course[2], []).append(sec)
    for s in student_rows:
        for sec in by_grade[s[4]]:
            if len(enroll_rows) >= 6000:
                break
            eid += 1
            enroll_rows.append([eid, s[0], sec[0]])
            letter = rng.choices(["A", "B", "C", "D", "F"], [30, 35, 22, 9, 4])[0]
            grade_rows.append([eid, letter, rng.choice(["", "", "Strong effort",
                                                        "Missing assignments",
                                                        "Improved this term"])])
    write_csv(org / "enrollments.csv",
              ["enrollment_id", "student_id", "section_id"], enroll_rows)
    write_csv(org / "grades.csv", ["enrollment_id", "term_grade", "comments"],
              grade_rows)
    assert len(enroll_rows) == 6000

    portal_rows = []
    seen_users: set[str] = set()
    for g in guardian_rows:
        username = g[3].split("@")[0]
        while username in seen_users:
            username += "x"
        seen_users.add(username)
        fake_hash = hashlib.sha256(f"seed{SEED}-{g[0]}".encode()).hexdigest()
        portal_rows.append([g[0], g[0], username, f"plain:{fake_hash[:12]}"])
    write_csv(org / "portal_accounts.csv",
              ["account_id", "guardian_id", "username", "password_hash"],
              portal_rows)

    # Chapter 3 fixture: flat gradebook export with planted anomalies
    flat = []
    teacher_name = {r[0]: r[1] for r in staff_rows}
    course_name = {r[0]: r[1] for r in course_rows}
    section_by_id = {r[0]: r for r in section_rows}
    student_by_id = {r[0]: r for r in student_rows}
    for e, g in zip(enroll_rows[:1200], grade_rows[:1200]):
        s = student_by_id[e[1]]
        sec = section_by_id[e[2]]
        flat.append([f"{s[1]} {s[2]}", s[4], course_name[sec[1]], sec[3],
                     teacher_name[sec[2]], g[1]])
    # anomalies: teacher name variants, a duplicate, an invalid grade
    target_teacher = flat[0][4]
    variants = [target_teacher.upper(), target_teacher.replace(" ", "  "),
                target_teacher.split()[0] + " " + target_teacher.split()[1][0] + "."]
    n_var = 0
    for row in flat:
        if row[4] == target_teacher and n_var < 3:
            row[4] = variants[n_var]
            n_var += 1
    flat.append(list(flat[10]))
    flat[20][5] = "E"
    write_csv(ASSETS / "chapter-03" / "harquahala_gradebook_export.csv",
              ["student_name", "grade_level", "course_name", "term",
               "teacher_name", "term_grade"], flat)
    return {"students": len(student_rows), "guardians": len(guardian_rows),
            "enrollments": len(enroll_rows)}


# --------------------------------------------------------------------------
# Log fixtures (chapters 7 and 10)
# --------------------------------------------------------------------------
def log_line(when: datetime, pid: int, user: str, db: str, level: str,
             msg: str) -> str:
    stamp = when.strftime("%Y-%m-%d %H:%M:%S.") + f"{when.microsecond // 1000:03d} MST"
    return f"{stamp} [{pid}] {user}@{db} {level}:  {msg}"


def build_logs(rng: random.Random) -> None:
    # Chapter 7: one business day of Copperwind server logs with a
    # failed-login burst and one privileged DDL change.
    day = datetime(2026, 8, 14, 0, 0, 0)
    lines = []
    pid = 40000
    users = ["copperwind_app", "copperwind_reports", "mlin", "ecole", "nredhouse"]
    for _ in range(420):
        when = day + timedelta(seconds=rng.randint(6 * 3600, 19 * 3600))
        user = rng.choice(users)
        pid += rng.randint(1, 3)
        lines.append((when, log_line(when, pid, user, "copperwind_ops", "LOG",
                                     f"connection authorized: user={user} database=copperwind_ops "
                                     f"application_name=psql")))
        if rng.random() < 0.15:
            lines.append((when + timedelta(seconds=rng.randint(1, 90)),
                          log_line(when, pid, user, "copperwind_ops", "LOG",
                                   "statement: SELECT count(*) FROM tickets WHERE status = 'Open'")))
    burst = day + timedelta(hours=2, minutes=11)
    for k in range(60):
        when = burst + timedelta(seconds=k * 5)
        pid += 1
        lines.append((when, log_line(when, pid, "postgres", "copperwind_ops", "FATAL",
                                     'password authentication failed for user "postgres"')))
        lines.append((when, log_line(when, pid, "postgres", "copperwind_ops", "DETAIL",
                                     "Connection matched file \"/etc/postgresql/17/main/pg_hba.conf\" "
                                     "line 12: \"host all all 0.0.0.0/0 scram-sha-256\"")))
    ddl_when = day + timedelta(hours=15, minutes=42, seconds=9)
    pid += 1
    lines.append((ddl_when, log_line(ddl_when, pid, "ecole", "copperwind_ops", "LOG",
                                     "statement: ALTER ROLE copperwind_reports WITH SUPERUSER")))
    lines.sort(key=lambda t: t[0])
    text = "\n".join(l for _, l in lines) + "\n"
    (ASSETS / "chapter-07").mkdir(parents=True, exist_ok=True)
    (ASSETS / "chapter-07" / "postgresql-2026-08-14.log").write_text(text, encoding="utf-8")
    assert text.count("password authentication failed") == 60
    assert "WITH SUPERUSER" in text

    # Chapter 10: the Harquahala breach. An over-privileged reporting
    # account exports guardian contacts at 02:13 from an outside address,
    # after a burst of failed logins the night before.
    breach_day = datetime(2026, 9, 3)
    lines = []
    pid = 51000
    for _ in range(260):
        when = breach_day - timedelta(days=1) + timedelta(seconds=rng.randint(7 * 3600, 18 * 3600))
        user = rng.choice(["academy_app", "academy_reports", "lortega", "kbell"])
        pid += 1
        lines.append((when, log_line(when, pid, user, "harquahala_academy", "LOG",
                                     f"connection authorized: user={user} database=harquahala_academy "
                                     f"application_name=psql")))
    night = breach_day - timedelta(days=1) + timedelta(hours=23, minutes=48)
    for k in range(35):
        when = night + timedelta(seconds=k * 9)
        pid += 1
        lines.append((when, log_line(when, pid, "academy_reports", "harquahala_academy", "FATAL",
                                     'password authentication failed for user "academy_reports"')))
    success = breach_day + timedelta(hours=2, minutes=9, seconds=41)
    pid += 1
    lines.append((success, log_line(success, pid, "academy_reports", "harquahala_academy", "LOG",
                                    "connection authorized: user=academy_reports database=harquahala_academy "
                                    "application_name=psql")))
    lines.append((success, log_line(success, pid, "academy_reports", "harquahala_academy", "LOG",
                                    "connection received: host=198.51.100.23 port=51844")))
    q1 = success + timedelta(minutes=1, seconds=12)
    lines.append((q1, log_line(q1, pid, "academy_reports", "harquahala_academy", "LOG",
                               "statement: SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'")))
    q2 = success + timedelta(minutes=3, seconds=30)
    lines.append((q2, log_line(q2, pid, "academy_reports", "harquahala_academy", "LOG",
                               "statement: COPY (SELECT full_name, phone, email FROM guardians) TO STDOUT WITH CSV HEADER")))
    q3 = success + timedelta(minutes=4, seconds=2)
    lines.append((q3, log_line(q3, pid, "academy_reports", "harquahala_academy", "LOG",
                               "statement: COPY (SELECT s.first_name, s.last_name, s.date_of_birth, g.term_grade "
                               "FROM students s JOIN enrollments e ON e.student_id = s.student_id "
                               "JOIN grades g ON g.enrollment_id = e.enrollment_id) TO STDOUT WITH CSV HEADER")))
    q4 = success + timedelta(minutes=5, seconds=48)
    lines.append((q4, log_line(q4, pid, "academy_reports", "harquahala_academy", "LOG",
                               "disconnection: session time: 0:05:48.201 user=academy_reports "
                               "database=harquahala_academy host=198.51.100.23 port=51844")))
    lines.sort(key=lambda t: t[0])
    text = "\n".join(l for _, l in lines) + "\n"
    (ASSETS / "chapter-10").mkdir(parents=True, exist_ok=True)
    (ASSETS / "chapter-10" / "postgresql-2026-09-03.log").write_text(text, encoding="utf-8")
    assert text.count("COPY (SELECT") == 2

    # Chapter 10 audit rows: the trail an audit trigger would have kept.
    audit = [["audit_id", "changed_at", "db_user", "table_name", "operation", "row_summary"]]
    aid = 0
    for _ in range(140):
        when = breach_day - timedelta(days=rng.randint(1, 20), seconds=rng.randint(0, 86400))
        aid += 1
        audit.append([aid, ts(when), rng.choice(["lortega", "kbell", "academy_app"]),
                      rng.choice(["grades", "enrollments", "students"]),
                      rng.choice(["UPDATE", "INSERT"]),
                      f"student_id={rng.randint(1, 800)}"])
    aid += 1
    audit.append([aid, ts(breach_day - timedelta(days=3, hours=9)), "dwhitfield", "pg_authid",
                  "GRANT", "GRANT SELECT ON ALL TABLES IN SCHEMA public TO academy_reports"])
    audit[1:] = sorted(audit[1:], key=lambda r: r[1])
    for i, r in enumerate(audit[1:], 1):
        r[0] = i
    write_csv(ASSETS / "chapter-10" / "academy_audit_trail.csv", audit[0], audit[1:])


# --------------------------------------------------------------------------
# Setup scripts and propagation
# --------------------------------------------------------------------------
CHAPTER_ORGS = {
    1: ["copperwind", "sandwash", "harquahala"],
    2: ["copperwind", "sandwash"],
    3: ["harquahala", "sandwash"],
    4: ["sandwash", "harquahala"],
    5: ["sandwash", "harquahala"],
    6: ["harquahala", "sandwash"],
    7: ["copperwind", "sandwash"],
    8: ["copperwind", "harquahala"],
    9: ["sandwash", "copperwind"],
    10: ["harquahala", "sandwash"],
    11: ["copperwind", "harquahala"],
    12: ["copperwind", "sandwash", "harquahala"],
}

SETUP_SQL = {
    "copperwind": r"""-- Sets up copperwind_ops, Copperwind IT Services' operations database.
-- Run from the extracted cis376 folder:
--     psql -U postgres -d postgres -f assets/code/chapter-NN/setup-copperwind.sql
-- The script is idempotent: it drops and recreates every table it owns.

SELECT 'CREATE DATABASE copperwind_ops'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'copperwind_ops') \gexec
\connect copperwind_ops

DROP TABLE IF EXISTS login_events, ticket_notes, tickets, technicians, clients CASCADE;

CREATE TABLE clients (
  client_id      integer PRIMARY KEY,
  client_name    text NOT NULL,
  sector         text NOT NULL,
  city           text NOT NULL,
  contract_start date NOT NULL
);

CREATE TABLE technicians (
  technician_id integer PRIMARY KEY,
  full_name     text NOT NULL,
  team          text NOT NULL,
  hire_date     date NOT NULL
);

CREATE TABLE tickets (
  ticket_id     integer PRIMARY KEY,
  client_id     integer NOT NULL REFERENCES clients (client_id),
  technician_id integer NOT NULL REFERENCES technicians (technician_id),
  category      text NOT NULL,
  priority      text NOT NULL,
  opened_at     timestamp NOT NULL,
  closed_at     timestamp,
  status        text NOT NULL,
  summary       text NOT NULL
);

CREATE TABLE ticket_notes (
  note_id   integer PRIMARY KEY,
  ticket_id integer NOT NULL REFERENCES tickets (ticket_id),
  author_id integer NOT NULL REFERENCES technicians (technician_id),
  noted_at  timestamp NOT NULL,
  note_text text NOT NULL
);

CREATE TABLE login_events (
  event_id   integer PRIMARY KEY,
  username   text NOT NULL,
  event_time timestamp NOT NULL,
  source_ip  inet NOT NULL,
  success    boolean NOT NULL
);

\copy clients      FROM 'assets/code/data/copperwind/clients.csv'      WITH (FORMAT csv, HEADER true)
\copy technicians  FROM 'assets/code/data/copperwind/technicians.csv'  WITH (FORMAT csv, HEADER true)
\copy tickets      FROM 'assets/code/data/copperwind/tickets.csv'      WITH (FORMAT csv, HEADER true, NULL '')
\copy ticket_notes FROM 'assets/code/data/copperwind/ticket_notes.csv' WITH (FORMAT csv, HEADER true)
\copy login_events FROM 'assets/code/data/copperwind/login_events.csv' WITH (FORMAT csv, HEADER true)

ANALYZE;
""",
    "sandwash": r"""-- Sets up sandwash_clinic, the Sandwash Family Clinic database (HIPAA).
-- Run from the extracted cis376 folder:
--     psql -U postgres -d postgres -f assets/code/chapter-NN/setup-sandwash.sql
-- The script is idempotent: it drops and recreates every table it owns.

SELECT 'CREATE DATABASE sandwash_clinic'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'sandwash_clinic') \gexec
\connect sandwash_clinic

DROP TABLE IF EXISTS staff_accounts, visit_notes, appointments, patients, providers CASCADE;

CREATE TABLE providers (
  provider_id integer PRIMARY KEY,
  full_name   text NOT NULL,
  specialty   text NOT NULL,
  npi         char(10) NOT NULL UNIQUE
);

CREATE TABLE patients (
  patient_id          integer PRIMARY KEY,
  first_name          text NOT NULL,
  last_name           text NOT NULL,
  date_of_birth       date NOT NULL,
  phone               text,
  email               text,
  address             text,
  insurance_member_id text
);

CREATE TABLE appointments (
  appointment_id integer PRIMARY KEY,
  patient_id     integer NOT NULL REFERENCES patients (patient_id),
  provider_id    integer NOT NULL REFERENCES providers (provider_id),
  scheduled_at   timestamp NOT NULL,
  status         text NOT NULL,
  visit_type     text NOT NULL
);

CREATE TABLE visit_notes (
  note_id        integer PRIMARY KEY,
  appointment_id integer NOT NULL REFERENCES appointments (appointment_id),
  diagnosis_code text NOT NULL,
  note_text      text NOT NULL
);

CREATE TABLE staff_accounts (
  account_id  integer PRIMARY KEY,
  username    text NOT NULL UNIQUE,
  role_name   text NOT NULL,
  provider_id integer REFERENCES providers (provider_id)
);

\copy providers      FROM 'assets/code/data/sandwash/providers.csv'      WITH (FORMAT csv, HEADER true)
\copy patients       FROM 'assets/code/data/sandwash/patients.csv'       WITH (FORMAT csv, HEADER true)
\copy appointments   FROM 'assets/code/data/sandwash/appointments.csv'   WITH (FORMAT csv, HEADER true)
\copy visit_notes    FROM 'assets/code/data/sandwash/visit_notes.csv'    WITH (FORMAT csv, HEADER true)
\copy staff_accounts FROM 'assets/code/data/sandwash/staff_accounts.csv' WITH (FORMAT csv, HEADER true, NULL '')

ANALYZE;
""",
    "harquahala": r"""-- Sets up harquahala_academy, the Harquahala Charter Academy database (FERPA).
-- Run from the extracted cis376 folder:
--     psql -U postgres -d postgres -f assets/code/chapter-NN/setup-harquahala.sql
-- The script is idempotent: it drops and recreates every table it owns.

SELECT 'CREATE DATABASE harquahala_academy'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'harquahala_academy') \gexec
\connect harquahala_academy

DROP TABLE IF EXISTS portal_accounts, grades, enrollments, sections, courses,
  staff, student_guardians, guardians, students CASCADE;

CREATE TABLE students (
  student_id         integer PRIMARY KEY,
  first_name         text NOT NULL,
  last_name          text NOT NULL,
  date_of_birth      date NOT NULL,
  grade_level        smallint NOT NULL,
  directory_opt_out  boolean NOT NULL DEFAULT false
);

CREATE TABLE guardians (
  guardian_id  integer PRIMARY KEY,
  full_name    text NOT NULL,
  phone        text,
  email        text,
  relationship text NOT NULL
);

CREATE TABLE student_guardians (
  student_id  integer NOT NULL REFERENCES students (student_id),
  guardian_id integer NOT NULL REFERENCES guardians (guardian_id),
  is_primary  boolean NOT NULL,
  PRIMARY KEY (student_id, guardian_id)
);

CREATE TABLE staff (
  staff_id  integer PRIMARY KEY,
  full_name text NOT NULL,
  role_name text NOT NULL
);

CREATE TABLE courses (
  course_id   integer PRIMARY KEY,
  course_name text NOT NULL,
  grade_level smallint NOT NULL
);

CREATE TABLE sections (
  section_id integer PRIMARY KEY,
  course_id  integer NOT NULL REFERENCES courses (course_id),
  staff_id   integer NOT NULL REFERENCES staff (staff_id),
  term       text NOT NULL
);

CREATE TABLE enrollments (
  enrollment_id integer PRIMARY KEY,
  student_id    integer NOT NULL REFERENCES students (student_id),
  section_id    integer NOT NULL REFERENCES sections (section_id)
);

CREATE TABLE grades (
  enrollment_id integer PRIMARY KEY REFERENCES enrollments (enrollment_id),
  term_grade    char(1) NOT NULL,
  comments      text
);

CREATE TABLE portal_accounts (
  account_id    integer PRIMARY KEY,
  guardian_id   integer NOT NULL REFERENCES guardians (guardian_id),
  username      text NOT NULL UNIQUE,
  password_hash text NOT NULL
);

\copy students          FROM 'assets/code/data/harquahala/students.csv'          WITH (FORMAT csv, HEADER true)
\copy guardians         FROM 'assets/code/data/harquahala/guardians.csv'         WITH (FORMAT csv, HEADER true)
\copy student_guardians FROM 'assets/code/data/harquahala/student_guardians.csv' WITH (FORMAT csv, HEADER true)
\copy staff             FROM 'assets/code/data/harquahala/staff.csv'             WITH (FORMAT csv, HEADER true)
\copy courses           FROM 'assets/code/data/harquahala/courses.csv'           WITH (FORMAT csv, HEADER true)
\copy sections          FROM 'assets/code/data/harquahala/sections.csv'          WITH (FORMAT csv, HEADER true)
\copy enrollments       FROM 'assets/code/data/harquahala/enrollments.csv'       WITH (FORMAT csv, HEADER true)
\copy grades            FROM 'assets/code/data/harquahala/grades.csv'            WITH (FORMAT csv, HEADER true, NULL '')
\copy portal_accounts   FROM 'assets/code/data/harquahala/portal_accounts.csv'   WITH (FORMAT csv, HEADER true)

ANALYZE;
""",
}


def write_setup_scripts() -> None:
    """Write the base setup script for every org into every chapter that
    uses it. A chapter that needs a different starting state (schemas
    already separated, roles pre-created) keeps a hand-edited copy and
    lists itself in KEEP so this step does not overwrite it."""
    keep_marker = "-- CHAPTER-SPECIFIC: do not regenerate"
    for chapter, orgs in CHAPTER_ORGS.items():
        folder = ASSETS / f"chapter-{chapter:02d}"
        folder.mkdir(parents=True, exist_ok=True)
        for org in orgs:
            path = folder / f"setup-{org}.sql"
            if path.exists() and keep_marker in path.read_text(encoding="utf-8"):
                continue
            path.write_text(SETUP_SQL[org].replace("chapter-NN", f"chapter-{chapter:02d}"),
                            encoding="utf-8")


def generate(target_assets: Path) -> dict:
    global ASSETS
    ASSETS = target_assets
    data = ASSETS / "data"
    rng = random.Random(SEED)
    summary = {}
    summary["copperwind"] = build_copperwind(rng, data)
    summary["sandwash"] = build_sandwash(rng, data)
    summary["harquahala"] = build_harquahala(rng, data)
    build_logs(rng)
    write_setup_scripts()
    return summary


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true",
                        help="regenerate into a temp dir and diff against assets/code")
    args = parser.parse_args()
    if not args.check:
        summary = generate(REPO / "assets" / "code")
        for org, counts in summary.items():
            print(org, counts)
        return
    committed = REPO / "assets" / "code"
    with tempfile.TemporaryDirectory() as tmp:
        tmp_assets = Path(tmp) / "code"
        generate(tmp_assets)
        differences = []
        for path in tmp_assets.rglob("*"):
            if path.is_file():
                other = committed / path.relative_to(tmp_assets)
                if not other.exists() or not filecmp.cmp(path, other, shallow=False):
                    differences.append(str(path.relative_to(tmp_assets)))
    if differences:
        print("DIFFERENT:", *differences, sep="\n  ")
        sys.exit(1)
    print("byte-identical rerun confirmed")


if __name__ == "__main__":
    main()
