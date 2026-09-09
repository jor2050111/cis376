"""Flag prose sentences that run 35 words or longer.

Mr. Vega's sentence-length standard (2026-07-07, recorded in each
textbook's CLAUDE.md): watch sentence length while drafting, split
anything that reaches about 35 words, and keep typical sentences well under 30. This tool
is the watching half. It strips fenced code, tables, and headings
(which exempts the locked rubric automatically), joins each remaining
paragraph, and reports every sentence at or over the threshold with
its word count and starting line.

Usage (from the repo root):

    python tools/check_sentence_length.py book/chapters/chapter-06.md

Exits non-zero if any sentence reaches the threshold, so the pipeline
notices. Splitting judgment stays with the author; the tool only
refuses to let a long sentence pass unseen.
"""

import re
import sys
from pathlib import Path

THRESHOLD = 35

# An opening fence is three or more backticks or tildes, optionally
# followed by an info string (```python, ~~~text). A closing fence
# must be a pure run of the SAME character, at least as long as the
# opener, with nothing else on the line. Anything weaker lets content
# inside a fence toggle the state: a Python 3.12 traceback caret line
# ("~~~~~^^^^^") pasted into a text fence corrupted parsing for the
# rest of the file before this rule existed (2026-07-28).
FENCE_OPEN_RE = re.compile(r"^(`{3,}|~{3,})")
ABBREV = ("vs.", "e.g.", "i.e.", "Mr.", "Dr.", "St.", "No.", "U.S.")
# A sentence may end at .!? or at .!? followed by a closing quote,
# parenthesis, or bracket; the next one starts with a capital-ish char.
SENTENCE_SPLIT = re.compile(
    r"(?:(?<=[.!?])|(?<=[.!?][\"')\]]))\s+(?=[A-Z\"'(*`])")
ITEM_RE = re.compile(r"^\s*(\*|\d+\.)\s+")


def paragraphs(lines):
    """Yield (start_line, text) for prose paragraphs only.

    Each list item counts as its own paragraph, so term lists and
    numbered tasks never merge into one false mega-sentence.
    """
    buf, start = [], None
    fence_char, fence_len = None, 0
    for n, raw in enumerate(lines, 1):
        line = raw.rstrip()
        stripped = line.strip()
        if fence_char is None:
            fence_open = FENCE_OPEN_RE.match(stripped)
            if fence_open:
                fence_char = fence_open.group(1)[0]
                fence_len = len(fence_open.group(1))
                line = ""
        elif (stripped == fence_char * len(stripped)
                and len(stripped) >= fence_len):
            fence_char, fence_len = None, 0
            line = ""
        skip = (fence_char is not None or not line.strip()
                or line.lstrip().startswith(("|", "#", "<!--", "-->")))
        if skip:
            if buf:
                yield start, " ".join(buf)
                buf, start = [], None
            continue
        text = line.strip().lstrip(">").strip()
        if ITEM_RE.match(text) and buf:
            yield start, " ".join(buf)
            buf, start = [], None
        text = ITEM_RE.sub("", text)
        if not buf:
            start = n
        buf.append(text)
    if buf:
        yield start, " ".join(buf)


def sentences(text):
    """Split a paragraph into sentences, tolerating abbreviations."""
    parts = SENTENCE_SPLIT.split(text)
    merged = []
    for part in parts:
        if merged and merged[-1].endswith(ABBREV):
            merged[-1] = merged[-1] + " " + part
        else:
            merged.append(part)
    return merged


def check_file(path: Path) -> int:
    """Report long sentences in one file; return the flag count."""
    flagged = 0
    counts = []
    for start, text in paragraphs(path.read_text().splitlines()):
        for sentence in sentences(text):
            words = len(sentence.split())
            counts.append(words)
            if words >= THRESHOLD:
                flagged += 1
                print(f"  line {start}: {words} words: "
                      f"{sentence[:70]}...")
    total = len(counts)
    avg = sum(counts) / total if total else 0
    longest = max(counts) if counts else 0
    print(f"{path.name}: {total} sentences, average {avg:.1f} words, "
          f"longest {longest}, flagged (>= {THRESHOLD}): {flagged}")
    return flagged


if __name__ == "__main__":
    total_flagged = 0
    for arg in sys.argv[1:]:
        total_flagged += check_file(Path(arg).resolve())
    sys.exit(1 if total_flagged else 0)
