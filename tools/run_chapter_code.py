"""Execute every python code block in a chapter and log the outputs.

The textbook's standard requires every code example to run against the
committed data pack files, with the printed outputs recorded in the
text as `# Output:` comments. This harness enforces the first half of
that contract and produces the evidence log for the second half.

Blocks in one chapter share a namespace and run in file order, so a
later block may use variables an earlier block defined. Only fenced
blocks tagged `python` execute; `sql`, `text`, and untagged fences are
documentation and are skipped.

Usage (from the repo root):

    python tools/run_chapter_code.py book/chapters/chapter-01.md

Writes docs/execution-logs/chapter-NN.log and exits non-zero if any
block raises.
"""

import io
import re
import sys
import traceback
from contextlib import redirect_stdout
from pathlib import Path

import matplotlib

# Part III chapters draw figures. The headless backend keeps
# plt.show() from opening windows while the harness runs blocks.
matplotlib.use("Agg")

REPO = Path(__file__).resolve().parents[1]

BLOCK_RE = re.compile(r"^```python\n(.*?)^```", re.M | re.S)
MAGIC_RE = re.compile(r"^\s*[%!]")


def neutralize_magics(code: str) -> str:
    """Comment out IPython magics and shell escapes.

    Lines like `%matplotlib inline` or `!pip install` are valid in the
    students' JupyterLab notebooks but are not Python syntax, so the
    harness comments them out instead of failing the block.
    """
    return "\n".join(
        "# [magic] " + ln if MAGIC_RE.match(ln) else ln
        for ln in code.splitlines()
    )


def run_chapter(chapter_path: Path) -> int:
    """Run all python blocks in one chapter; return failure count."""
    text = chapter_path.read_text()
    blocks = BLOCK_RE.findall(text)
    namespace: dict = {}
    failures = 0
    lines = [f"Execution log: {chapter_path.name}",
             f"Python blocks found: {len(blocks)}", ""]
    for i, code in enumerate(blocks, 1):
        header = f"--- block {i}/{len(blocks)} ---"
        first = next((ln for ln in code.splitlines()
                      if ln.strip() and not ln.strip().startswith("#")),
                     "(comments only)")
        buf = io.StringIO()
        try:
            with redirect_stdout(buf):
                exec(compile(neutralize_magics(code),
                             f"{chapter_path.name}:block{i}",
                             "exec"), namespace)
            status = "OK"
        except Exception:
            status = "FAIL"
            failures += 1
            buf.write(traceback.format_exc())
        finally:
            # Notebook cells finish their figures; blocks must too,
            # or one block's axes leak into the next block's plot.
            import matplotlib.pyplot as plt
            plt.close("all")
        lines.append(f"{header} [{status}] {first.strip()}")
        out = buf.getvalue().rstrip()
        if out:
            lines.extend("    " + ln for ln in out.splitlines())
        lines.append("")
    log_dir = REPO / "docs" / "execution-logs"
    log_dir.mkdir(parents=True, exist_ok=True)
    log_path = log_dir / (chapter_path.stem + ".log")
    log_path.write_text("\n".join(lines) + "\n")
    print(f"{chapter_path.name}: {len(blocks)} blocks, "
          f"{failures} failures -> {log_path.relative_to(REPO)}")
    return failures


if __name__ == "__main__":
    import os
    os.chdir(REPO)  # chapter code loads data pack paths from the root
    total = 0
    for arg in sys.argv[1:]:
        total += run_chapter(Path(arg).resolve())
    sys.exit(1 if total else 0)
