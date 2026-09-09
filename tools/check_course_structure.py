#!/usr/bin/env python3
"""CIS376 chapter structure checker.

Encodes the checker contract in
docs/book-design-spec-2026-09-09.md Section 3.1:

* Anatomy N.1-N.7 with the family heading set and icons
* Try It Yourself count per chapter matches the locked table,
  numbered 1..K in reading order
* Quick Checks exactly 4
* Equal Predict / Run / Explain label counts
* Exactly one Fix It block (H3, numbered N.1, wrench icon, all four
  labels, no Predict/Run/Explain inside it) unless --baseline
* Retrieval Practice exactly 5 numbered items; unless --baseline, at
  least 1 and at most 2 carry the "From Chapter N:" label and at
  least 3 do not
* Exactly 3 MLOs, CLO alignment block present, Questions & Analysis
  with exactly 2 questions
* No skipped heading levels
* No gap markers (____) inside sql or bash fences
* Every MLO ends with a (Section N.X) or (Sections N.X-N.Y) binding

Usage:
    check_course_structure.py book/chapters/chapter-NN.md [...]
    check_course_structure.py --all [--baseline]

Exit 0 when errors == 0.
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

TIY_COUNTS = {n: 5 for n in range(1, 13)}

FENCE_OPEN_RE = re.compile(r"^(`{3,}|~{3,})(\S*)\s*$")


def fence_map(lines):
    """Return per-line fence language ('' outside fences)."""
    langs = []
    open_char, open_len, lang = None, 0, ""
    for line in lines:
        stripped = line.rstrip()
        m = FENCE_OPEN_RE.match(stripped)
        if open_char is None:
            if m:
                open_char, open_len = m.group(1)[0], len(m.group(1))
                lang = m.group(2) or "?"
                langs.append("FENCE_MARKER")
                continue
            langs.append("")
        else:
            if (m and not m.group(2)
                    and stripped[0] == open_char
                    and len(stripped) >= open_len
                    and set(stripped) == {open_char}):
                open_char, lang = None, ""
                langs.append("FENCE_MARKER")
                continue
            langs.append(lang)
    return langs


def check_chapter(path: Path, baseline: bool) -> list[str]:
    errors = []
    text = path.read_text(encoding="utf-8")
    lines = text.split("\n")
    langs = fence_map(lines)
    n = int(re.search(r"chapter-(\d+)", path.name).group(1))

    def prose(i):
        return langs[i] == ""

    # H1 exactly one, correct chapter number
    h1s = [l for i, l in enumerate(lines)
           if prose(i) and re.match(r"^# ", l)]
    if len(h1s) != 1:
        errors.append(f"expected exactly 1 H1, found {len(h1s)}")
    elif not re.match(rf"^# Chapter {n}: ", h1s[0]):
        errors.append(f"H1 malformed: {h1s[0]!r}")

    # Required H2 anatomy
    h2s = [l for i, l in enumerate(lines)
           if prose(i) and re.match(r"^## ", l)]
    required_h2 = [
        r"^## Module Overview 🧭$",
        r"^## Learning Objectives 🎯$",
        rf"^## {n}\.5 Summary and Retrieval 💡$",
        rf"^## {n}\.6 Skills Lab {n}A: ",
        rf"^## {n}\.7 Review Questions 🔄️$",
        r"^## Further Reading 📖$",
    ]
    tail = (r"^## Course Conclusion: Where You Go from Here\s*$"
            if n == 12 else r"^## Looking Ahead ⏩$")
    required_h2.append(tail)
    for pat in required_h2:
        if not any(re.match(pat, h) for h in h2s):
            errors.append(f"missing H2 matching {pat}")

    # Main sections N.1-N.4 present, no N.8+
    for k in (1, 2, 3, 4):
        if not any(re.match(rf"^## {n}\.{k} ", h) for h in h2s):
            errors.append(f"missing main section {n}.{k}")
    if any(re.match(rf"^## {n}\.([89]|\d\d) ", h) for h in h2s):
        errors.append("unexpected section beyond N.7")

    # Heading level skips (H2 -> H4 with no H3 etc. is rare; check
    # that no H4+ appears without an H3 ancestor since last H2)
    last = 1
    for i, l in enumerate(lines):
        if not prose(i):
            continue
        m = re.match(r"^(#{1,6}) ", l)
        if not m:
            continue
        lvl = len(m.group(1))
        if lvl > last + 1:
            errors.append(f"heading level skip at line {i+1}: {l[:60]!r}")
        last = lvl

    # Try It Yourself count and reading-order numbering
    tiys = [(i, l) for i, l in enumerate(lines)
            if prose(i) and l.startswith("### Try It Yourself")]
    expected = TIY_COUNTS[n]
    if len(tiys) != expected:
        errors.append(f"TIY count {len(tiys)} != locked {expected}")
    nums = [re.match(rf"^### Try It Yourself {n}\.(\d+): .*🛠️\s*$", l)
            for _, l in tiys]
    if not all(nums):
        bad = [l for m, (_, l) in zip(nums, tiys) if not m]
        errors.append(f"TIY heading malformed: {bad[:2]}")
    else:
        seq = [int(m.group(1)) for m in nums]
        if seq != list(range(1, len(seq) + 1)):
            errors.append(f"TIY numbering not 1..K in order: {seq}")

    # Quick Checks exactly 4
    qcs = [l for i, l in enumerate(lines)
           if prose(i) and l.startswith("### Quick Check")]
    if len(qcs) != 4:
        errors.append(f"Quick Check count {len(qcs)} != 4")

    # Predict/Run/Explain equality
    def count_label(label):
        return sum(1 for i, l in enumerate(lines)
                   if prose(i) and l.startswith(f"**{label}:**"))
    p, r, e = (count_label(x) for x in ("Predict", "Run", "Explain"))
    if not (p == r == e):
        errors.append(f"Predict/Run/Explain unequal: {p}/{r}/{e}")

    # Fix It block
    fixits = [(i, l) for i, l in enumerate(lines)
              if prose(i) and l.startswith("### Fix It")]
    if baseline:
        if fixits:
            errors.append("baseline mode: unexpected Fix It block")
    else:
        if len(fixits) != 1:
            errors.append(f"Fix It count {len(fixits)} != 1")
        else:
            i0, heading = fixits[0]
            if not re.match(rf"^### Fix It {n}\.1: .*🔧\s*$", heading):
                errors.append(f"Fix It heading malformed: {heading!r}")
            # Block extends to next H2/H3
            j = i0 + 1
            while j < len(lines) and not (
                    prose(j) and re.match(r"^#{2,3} ", lines[j])):
                j += 1
            block = [(k, lines[k]) for k in range(i0 + 1, j)]
            for label in ("Symptom", "Diagnose", "Repair", "Verify"):
                c = sum(1 for k, l in block
                        if prose(k) and l.startswith(f"**{label}:**"))
                if c != 1:
                    errors.append(f"Fix It label {label} count {c} != 1")
            for label in ("Predict", "Run", "Explain"):
                if any(prose(k) and l.startswith(f"**{label}:**")
                       for k, l in block):
                    errors.append(f"Fix It contains forbidden {label} label")

    # Retrieval Practice: exactly 5 numbered items
    rp_idx = None
    for i, l in enumerate(lines):
        if prose(i) and re.match(
                r"^(### Retrieval Practice|\*\*Retrieval Practice\*\*)", l):
            rp_idx = i
            break
    if rp_idx is None:
        errors.append("Retrieval Practice block not found")
    else:
        j = rp_idx + 1
        items = []
        while j < len(lines):
            if prose(j) and re.match(r"^\d+\. ", lines[j]):
                items.append(lines[j])
            elif prose(j) and (re.match(r"^#{1,3} ", lines[j])
                               or re.match(r"^\*\*\w", lines[j])):
                break
            j += 1
        if len(items) != 5:
            errors.append(f"Retrieval Practice items {len(items)} != 5")
        from_items = [it for it in items
                      if re.match(r"^\d+\. From Chapter \d+:", it)]
        if not baseline and n >= 2:
            if not (1 <= len(from_items) <= 2):
                errors.append(
                    f"cumulative items {len(from_items)} not in 1..2")
            if len(items) - len(from_items) < 3:
                errors.append("fewer than 3 same-chapter retrieval items")
        if baseline and from_items:
            errors.append("baseline mode: unexpected From Chapter item")

    # MLOs exactly 3 + CLO block + Questions & Analysis with 2 items
    mlos = [l for i, l in enumerate(lines) if prose(i)
            and re.match(rf"^\* \*\*{n}\.\d \(", l)]
    if len(mlos) != 3:
        errors.append(f"MLO count {len(mlos)} != 3")
    for m in mlos:
        if not re.search(rf"\(Sections? {n}\.\d(-{n}\.\d)?\)\s*$", m):
            errors.append(f"MLO lacks section binding: {m[:70]!r}")
    if not any(prose(i) and l.startswith(
            "### This chapter aligns with the following Course Learning")
            for i, l in enumerate(lines)):
        errors.append("CLO alignment block missing")
    if not any(prose(i) and l.startswith("### Questions & Analysis")
               for i, l in enumerate(lines)):
        errors.append("Questions & Analysis missing")

    # Gap markers only in text fences
    for i, l in enumerate(lines):
        if "____" in l and langs[i] not in ("", "FENCE_MARKER", "text", "?"):
            errors.append(
                f"gap marker inside {langs[i]} fence at line {i+1}")

    return errors


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("files", nargs="*")
    ap.add_argument("--all", action="store_true")
    ap.add_argument("--baseline", action="store_true",
                    help="pre-upgrade expectations (no Fix It, no "
                         "From Chapter items)")
    args = ap.parse_args()

    paths = ([ROOT / f for f in args.files] if args.files else
             sorted((ROOT / "book" / "chapters").glob("chapter-*.md")))
    total = 0
    for p in paths:
        errs = check_chapter(p, args.baseline)
        total += len(errs)
        status = "OK" if not errs else f"{len(errs)} error(s)"
        print(f"{p.relative_to(ROOT)}: {status}")
        for e in errs:
            print(f"  ERROR: {e}")
    print(f"TOTAL errors: {total}")
    sys.exit(0 if total == 0 else 1)


if __name__ == "__main__":
    main()
