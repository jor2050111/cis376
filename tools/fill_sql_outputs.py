#!/usr/bin/env python3
"""Write harness-captured output into each ``sql`` block's ``-- Output:`` lines.

Authors draft a chapter, run ``run_chapter_sql.py``, then run this tool
to paste the captured output into every ``sql`` block that carries an
``-- Output:`` marker. Existing output comment lines under the marker
are replaced. Blocks without the marker are left alone, so a
configuration block can stay silent when the prose states its result.

The psql row-count footer ("(1 row)") is dropped, and connection
messages ("You are now connected ...") are dropped because they name
the author's login role rather than the student's.

Usage (from the repo root, after run_chapter_sql.py):

    python3 tools/fill_sql_outputs.py book/chapters/chapter-01.md

Review the diff afterward. The tool pastes what ran. Whether what ran
is what the prose claims is still the author's job.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
BLOCK_RE = re.compile(r"(^```sql\n)(.*?)(^```)", re.M | re.S)
HEADER_RE = re.compile(r"^--- block (\d+)/(\d+) --- \[(\w+)\]")
FOOTER_RE = re.compile(r"^\(\d+ rows?\)$")
SKIP_PREFIXES = ("You are now connected", ">>> ")


def log_outputs(log_path: Path) -> dict[int, list[str]]:
    outputs: dict[int, list[str]] = {}
    current = None
    for line in log_path.read_text(encoding="utf-8").splitlines():
        header = HEADER_RE.match(line)
        if header:
            current = int(header.group(1))
            outputs[current] = []
        elif current is not None and line.startswith("    "):
            body = line[4:].rstrip()
            if body.startswith(SKIP_PREFIXES) or FOOTER_RE.match(body.strip()):
                continue
            outputs[current].append(body)
    return outputs


def replace_output(code: str, captured: list[str]) -> str:
    lines = code.splitlines()
    try:
        idx = next(i for i, ln in enumerate(lines)
                   if ln.strip().startswith("-- Output:"))
    except StopIteration:
        return code
    # Drop existing continuation comment lines after the marker.
    j = idx + 1
    while j < len(lines) and lines[j].strip().startswith("--"):
        j += 1
    while captured and not captured[-1].strip():
        captured.pop()
    while captured and not captured[0].strip():
        captured.pop(0)
    new = ["-- Output:"] + [("-- " + ln).rstrip() for ln in captured]
    return "\n".join(lines[:idx] + new + lines[j:]) + "\n"


def main() -> None:
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    chapter = Path(sys.argv[1]).resolve()
    log_path = REPO / "docs" / "execution-logs" / chapter.with_suffix(".log").name
    outputs = log_outputs(log_path)
    text = chapter.read_text(encoding="utf-8")
    counter = {"n": 0, "filled": 0}

    def sub(m: re.Match) -> str:
        counter["n"] += 1
        code = m.group(2)
        new_code = replace_output(code, list(outputs.get(counter["n"], [])))
        if new_code != code:
            counter["filled"] += 1
        return m.group(1) + new_code + m.group(3)

    new_text = BLOCK_RE.sub(sub, text)
    chapter.write_text(new_text, encoding="utf-8")
    print(f"{chapter.name}: {counter['filled']} of {counter['n']} blocks filled")


if __name__ == "__main__":
    main()
