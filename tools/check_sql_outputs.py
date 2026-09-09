#!/usr/bin/env python3
"""Cross-check every ``-- Output:`` comment against the SQL execution log.

The textbook contract has two halves: chapter SQL must run against the
committed data pack (``run_chapter_sql.py`` enforces that half), and
every ``-- Output:`` comment must show what psql printed. This tool
enforces the second half. For each ``sql`` block it collects the
comment lines (``-- Output:`` plus the ``--`` continuation lines that
follow) and verifies each one appears, in order, among the lines the
harness captured for that block. Whitespace is collapsed before
comparing, because psql pads columns and chapters may trim them.

A block with no ``-- Output:`` comment is skipped: configuration
blocks that print only a command tag may omit the comment when the
prose states the result.

Usage (from the repo root, after run_chapter_sql.py):

    python3 tools/check_sql_outputs.py book/chapters/chapter-01.md

Exits non-zero if any recorded output line does not match the log.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
BLOCK_RE = re.compile(r"^```sql\n(.*?)^```", re.M | re.S)
HEADER_RE = re.compile(r"^--- block (\d+)/(\d+) --- \[(\w+)\]")


def norm(line: str) -> str:
    return re.sub(r"\s+", " ", line).strip()


def comment_lines(code: str) -> list[str]:
    recorded, in_output = [], False
    for line in code.splitlines():
        stripped = line.strip()
        if stripped.startswith("-- Output:"):
            recorded.append(stripped[len("-- Output:"):].strip())
            in_output = True
        elif in_output and stripped.startswith("--"):
            recorded.append(stripped[2:].strip())
        else:
            in_output = False
    return [r for r in recorded if r]


def log_outputs(log_path: Path) -> dict[int, list[str]]:
    outputs: dict[int, list[str]] = {}
    current = None
    for line in log_path.read_text(encoding="utf-8").splitlines():
        header = HEADER_RE.match(line)
        if header:
            current = int(header.group(1))
            outputs[current] = []
        elif current is not None and line.startswith("    "):
            body = line[4:]
            if not body.startswith(">>> "):
                outputs[current].append(body)
    return outputs


def main() -> None:
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    chapter = Path(sys.argv[1]).resolve()
    log_path = REPO / "docs" / "execution-logs" / chapter.with_suffix(".log").name
    if not log_path.exists():
        sys.exit(f"no log at {log_path}; run run_chapter_sql.py first")
    blocks = BLOCK_RE.findall(chapter.read_text(encoding="utf-8"))
    logged = log_outputs(log_path)
    mismatches = 0
    checked = 0
    for i, code in enumerate(blocks, 1):
        recorded = comment_lines(code)
        if not recorded:
            continue
        checked += 1
        actual = [norm(x) for x in logged.get(i, [])]
        pos = 0
        for rec in recorded:
            target = norm(rec)
            # Row-count footers like "(3 rows)" are optional in chapters.
            try:
                pos = actual.index(target, pos) + 1
            except ValueError:
                mismatches += 1
                print(f"block {i}: recorded {rec!r} not found in log output")
                print("   log had: " + " | ".join(actual[:6]))
                break
    print(f"{chapter.name}: {checked} block(s) with outputs checked, "
          f"{mismatches} mismatch(es)")
    sys.exit(1 if mismatches else 0)


if __name__ == "__main__":
    main()
