"""Cross-check every `# Output:` comment against the execution log.

The textbook contract has two halves: chapter code must run against the
committed data pack (run_chapter_code.py enforces that half), and every
`# Output:` comment must show what the code really printed. This tool
enforces the second half. For each python block it collects the comment
lines (`# Output: ...` plus aligned `#` continuation lines) and verifies
each one matches a line the harness captured for that block, in order.
Whitespace is collapsed before comparing, because chapters align their
comment columns for readability.

Usage (from the repo root, after run_chapter_code.py):

    python tools/check_output_comments.py book/chapters/chapter-01.md

Exits non-zero if any recorded output line does not match the log.
"""

import re
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]

BLOCK_RE = re.compile(r"^```python\n(.*?)^```", re.M | re.S)
HEADER_RE = re.compile(r"^--- block (\d+)/(\d+) --- \[(\w+)\]")


def norm(line: str) -> str:
    """Collapse runs of whitespace so alignment differences vanish."""
    return re.sub(r"\s+", " ", line).strip()


def comment_lines(code: str) -> list[str]:
    """Extract the output-comment lines from one code block."""
    recorded = []
    in_output = False
    for line in code.splitlines():
        stripped = line.strip()
        if stripped.startswith("# Output:"):
            recorded.append(stripped[len("# Output:"):].strip())
            in_output = True
        elif in_output and re.match(r"^#(?!!)\s", stripped):
            recorded.append(stripped.lstrip("#").strip())
        else:
            in_output = False
    return [r for r in recorded if r]


def log_outputs(log_path: Path) -> dict[int, list[str]]:
    """Parse the harness log into {block_number: output_lines}."""
    outputs: dict[int, list[str]] = {}
    current = None
    for line in log_path.read_text().splitlines():
        header = HEADER_RE.match(line)
        if header:
            current = int(header.group(1))
            outputs[current] = []
        elif current is not None and line.startswith("    "):
            outputs[current].append(line[4:])
    return outputs


def check_chapter(chapter_path: Path) -> int:
    """Return the count of unmatched output-comment lines."""
    log_path = REPO / "docs" / "execution-logs" / (
        chapter_path.stem + ".log")
    if not log_path.exists():
        print(f"{chapter_path.name}: no log; run the harness first")
        return 1
    blocks = BLOCK_RE.findall(chapter_path.read_text())
    logged = log_outputs(log_path)
    failures = 0
    checked = 0
    for i, code in enumerate(blocks, 1):
        recorded = comment_lines(code)
        if not recorded:
            continue
        actual = [norm(ln) for ln in logged.get(i, [])]
        cursor = 0
        r = 0
        while r < len(recorded):
            # A long printed line may be wrapped across several
            # comment lines for the 79-char limit; try widening the
            # window until the joined text matches one log line.
            matched_span = 0
            candidate = ""
            for span in range(1, 4):
                if r + span > len(recorded):
                    break
                candidate = norm(" ".join(recorded[r:r + span]))
                if candidate in actual[cursor:]:
                    cursor = actual.index(candidate, cursor) + 1
                    matched_span = span
                    break
            if matched_span:
                checked += matched_span
                r += matched_span
            else:
                failures += 1
                print(f"  block {i}: comment not in log output: "
                      f"{recorded[r]!r}")
                r += 1
    print(f"{chapter_path.name}: {checked} output lines verified, "
          f"{failures} mismatches")
    return failures


if __name__ == "__main__":
    total = 0
    for arg in sys.argv[1:]:
        total += check_chapter(Path(arg).resolve())
    sys.exit(1 if total else 0)
