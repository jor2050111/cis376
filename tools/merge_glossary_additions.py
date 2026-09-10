#!/usr/bin/env python3
"""Merge docs/glossary-additions/chapter-NN.md into book/glossary.md.

Chapter agents write their new terms to per-chapter addition files so
that parallel authors never edit the published glossary at the same
time. This tool folds every addition file into the glossary, keeps the
letter headings, sorts terms case-insensitively within each letter, and
refuses to overwrite an existing definition (the first definition wins
and the conflict is printed for the maintainer to resolve by hand).

Entry format in both files (definition-list markup):

    term
    :   Definition sentence or two.

Usage (from the repo root):

    python3 tools/merge_glossary_additions.py            # merge all
    python3 tools/merge_glossary_additions.py --check    # report only
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
GLOSSARY = REPO / "book" / "glossary.md"
ADDITIONS = REPO / "docs" / "glossary-additions"
ENTRY_RE = re.compile(r"^(?P<term>[^\n:][^\n]*)\n:\s{3}(?P<definition>.+?)(?=\n\n|\Z)", re.M | re.S)


def parse_entries(text: str) -> dict[str, str]:
    entries = {}
    for m in ENTRY_RE.finditer(text):
        term = m.group("term").strip()
        if term.startswith("#") or term.startswith("*"):
            continue
        entries[term] = " ".join(m.group("definition").split())
    return entries


def letter_of(term: str) -> str:
    for ch in term:
        if ch.isalpha():
            return ch.upper()
    return "#"


def render(head: str, entries: dict[str, str]) -> str:
    by_letter: dict[str, list[tuple[str, str]]] = {}
    for term, definition in entries.items():
        by_letter.setdefault(letter_of(term), []).append((term, definition))
    out = [head.rstrip("\n"), ""]
    for letter in [chr(c) for c in range(ord("A"), ord("Z") + 1)]:
        out.append(f"## {letter}")
        out.append("")
        for term, definition in sorted(by_letter.get(letter, []),
                                       key=lambda t: t[0].lower()):
            out.append(term)
            out.append(f":   {definition}")
            out.append("")
    return "\n".join(out).rstrip("\n") + "\n"


def main() -> None:
    check = "--check" in sys.argv
    text = GLOSSARY.read_text(encoding="utf-8")
    head = text.split("\n## ", 1)[0]
    existing = parse_entries(text)
    merged = dict(existing)
    conflicts, added = [], []
    for path in sorted(ADDITIONS.glob("chapter-*.md")):
        for term, definition in parse_entries(path.read_text(encoding="utf-8")).items():
            if term in merged:
                if " ".join(merged[term].split()) != definition:
                    conflicts.append((path.name, term))
                continue
            merged[term] = definition
            added.append((path.name, term))
    for name, term in conflicts:
        print(f"CONFLICT (kept existing): {term!r} redefined in {name}")
    print(f"existing {len(existing)}, added {len(added)}, total {len(merged)}")
    if check:
        return
    GLOSSARY.write_text(render(head, merged), encoding="utf-8")
    print(f"wrote {GLOSSARY.relative_to(REPO)}")


if __name__ == "__main__":
    main()
