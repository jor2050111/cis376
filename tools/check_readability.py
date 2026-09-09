#!/usr/bin/env python3
"""Measure visible textbook prose with the project readability method."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path

import textstat

ROOT = Path(__file__).resolve().parents[1]
FILES = [
    ROOT / "book" / "index.md",
    ROOT / "book" / "glossary.md",
    ROOT / "book" / "skills-lab-rubric.md",
    *sorted((ROOT / "book" / "chapters").glob("chapter-*.md")),
]
# An opening fence is three or more backticks or tildes, optionally
# followed by an info string. A closing fence must be a pure run of
# the SAME character, at least as long as the opener. A weaker rule
# lets fence content (a "~~~~~^^^^^" traceback caret line) toggle the
# state and corrupt parsing for the rest of the file (2026-07-28).
FENCE_OPEN_RE = re.compile(r"^(`{3,}|~{3,})")
COMMENT_RE = re.compile(r"<!--.*?-->", re.DOTALL)
LINK_RE = re.compile(r"\[([^\]]+)\]\([^)]*\)")
URL_RE = re.compile(r"https?://\S+")
HTML_RE = re.compile(r"<[^>]+>")
MARKUP_RE = re.compile(r"[*_#>`~]+")


def visible_text(path: Path) -> str:
    """Return visible prose while excluding code, tables, and targets."""
    kept: list[str] = []
    fence_char, fence_len = None, 0
    for raw_line in path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if fence_char is None:
            fence_open = FENCE_OPEN_RE.match(line)
            if fence_open:
                fence_char = fence_open.group(1)[0]
                fence_len = len(fence_open.group(1))
                continue
        else:
            if (line == fence_char * len(line)
                    and len(line) >= fence_len):
                fence_char, fence_len = None, 0
            continue
        if line.startswith("|"):
            continue
        kept.append(raw_line)
    text = "\n".join(kept)
    text = COMMENT_RE.sub(" ", text)
    text = LINK_RE.sub(r"\1", text)
    text = URL_RE.sub(" ", text)
    text = HTML_RE.sub(" ", text)
    text = MARKUP_RE.sub("", text)
    return re.sub(r"\s+", " ", text).strip()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    results = []
    all_text = []
    for path in FILES:
        text = visible_text(path)
        all_text.append(text)
        score = textstat.flesch_reading_ease(text)
        result = {
            "file": path.relative_to(ROOT).as_posix(),
            "flesch_reading_ease": round(score, 1),
        }
        results.append(result)
        print(f"{result['file']}|flesch={result['flesch_reading_ease']:.1f}")
    combined = round(textstat.flesch_reading_ease(" ".join(all_text)), 1)
    report = {"files": results, "combined_flesch_reading_ease": combined}
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(
            json.dumps(report, indent=2) + "\n",
            encoding="utf-8",
        )
    print(f"TOTAL|files={len(results)}|combined_flesch={combined:.1f}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
