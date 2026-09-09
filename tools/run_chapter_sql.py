#!/usr/bin/env python3
"""Execute every ``sql`` code block in a chapter against fresh databases.

The textbook contract requires every runnable example to execute
against the committed data pack, with its printed result recorded in
the text as ``-- Output:`` comment lines. This harness enforces the
first half and produces the evidence log for the second half
(``check_sql_outputs.py``).

How a chapter run works:

1. Drop every role whose name starts with an organization prefix
   (``copperwind_``, ``clinic_``, ``academy_``). Roles are cluster-wide,
   so a previous chapter's roles would otherwise leak into this one.
2. For each ``setup-<org>.sql`` in ``assets/code/chapter-NN/``, drop
   and recreate the database ``cis376_chNN_<org>`` and run the setup
   script against it from the repo root, so ``\\copy`` paths resolve.
3. Concatenate every fenced ``sql`` block, in file order, into one
   psql script with an ``\\echo`` marker after each block, and run it
   once with ``psql -f``. Blocks share the session, so a role or table
   an earlier block created is visible to later blocks, exactly as a
   student typing along would see it. The session starts connected to
   the chapter's first database (Copperwind if present). A block
   switches databases with ``\\connect <name>`` when the prose tells
   the student to. Real database names are rewritten to the
   per-chapter copies so chapters never collide.
4. Attribute errors to blocks by the script line number psql prints
   (``psql:script.sql:LINE: ERROR: ...``), write
   ``docs/execution-logs/chapter-NN.log``, and exit non-zero if any
   block raised.

Blocks tagged ``text`` and ``bash`` never run. Gapped completion
problems and broken Fix It code live in ``text`` fences for that
reason. Existing ``-- Output:`` comment lines are stripped before the
run so a stale comment can never be mistaken for a statement.

Usage (from the repo root):

    python3 tools/run_chapter_sql.py book/chapters/chapter-01.md

Environment: a local PostgreSQL 17 with a trusting superuser. Override
``PSQL`` (path to the psql binary) and ``PGUSER`` when the defaults do
not match the machine.
"""

from __future__ import annotations

import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
PSQL = os.environ.get("PSQL", "/opt/homebrew/opt/postgresql@17/bin/psql")
PGUSER = os.environ.get("PGUSER", "vega")
ROLE_PREFIXES = ("copperwind_", "clinic_", "academy_")
ORG_ORDER = ("copperwind", "sandwash", "harquahala")
REAL_DB = {"copperwind": "copperwind_ops", "sandwash": "sandwash_clinic",
           "harquahala": "harquahala_academy"}

BLOCK_RE = re.compile(r"^```sql\n(.*?)^```", re.M | re.S)
ERR_LINE_RE = re.compile(r"^psql:[^:]+:(\d+): (ERROR|FATAL|WARNING)(.*)$")


def psql(args: list[str], stdin: str | None = None) -> subprocess.CompletedProcess:
    """Run psql with the flags every call needs."""
    base = [PSQL, "-X", "-U", PGUSER, "-P", "pager=off"]
    env = dict(os.environ, LC_ALL="en_US.UTF-8", PGCONNECT_TIMEOUT="5")
    return subprocess.run(base + args, input=stdin, text=True,
                          capture_output=True, env=env, cwd=REPO)


def temp_db(chapter_num: int, org: str) -> str:
    return f"cis376_ch{chapter_num:02d}_{org}"


def drop_prefixed_roles() -> None:
    """Remove every course role so the chapter starts clean."""
    cond = " OR ".join(f"rolname LIKE '{p}%'" for p in ROLE_PREFIXES)
    roles = psql(["-d", "postgres", "-qAtc",
                  f"SELECT rolname FROM pg_roles WHERE {cond}"]).stdout.split()
    for role in roles:
        res = psql(["-d", "postgres", "-qc", f'DROP ROLE IF EXISTS "{role}";'])
        if "ERROR" in res.stderr:
            print(f"warning: could not drop role {role}: "
                  f"{res.stderr.strip()}", file=sys.stderr)


def rewrite_db_names(script: str, chapter_num: int) -> str:
    """Point \\connect and CREATE/DROP DATABASE at per-chapter copies."""
    for org, real in REAL_DB.items():
        script = re.sub(rf"\b{real}\b", temp_db(chapter_num, org), script)
    return script


def rebuild_databases(chapter_num: int) -> list[str]:
    """Run each setup script into its own fresh database."""
    folder = REPO / "assets" / "code" / f"chapter-{chapter_num:02d}"

    def order(p: Path) -> int:
        org = p.stem.split("-", 1)[1]
        return ORG_ORDER.index(org) if org in ORG_ORDER else 99

    databases = []
    for setup in sorted(folder.glob("setup-*.sql"), key=order):
        org = setup.stem.split("-", 1)[1]
        db = temp_db(chapter_num, org)
        psql(["-d", "postgres", "-qc",
              f'DROP DATABASE IF EXISTS "{db}" WITH (FORCE);'])
        res = psql(["-d", "postgres", "-qc", f'CREATE DATABASE "{db}";'])
        if "ERROR" in res.stderr:
            sys.exit(f"could not create {db}: {res.stderr}")
        script = rewrite_db_names(setup.read_text(encoding="utf-8"),
                                  chapter_num)
        # The student's script may create the database itself; the
        # harness already did, so that statement must not fail the run.
        script = re.sub(r"^\s*CREATE DATABASE[^;]*;\s*$", "", script,
                        flags=re.M | re.I)
        res = psql(["-d", db, "-q", "-v", "ON_ERROR_STOP=1"], stdin=script)
        if res.returncode != 0:
            sys.exit(f"setup failed for {db}:\n{res.stderr}\n{res.stdout}")
        databases.append(db)
    return databases


def run_blocks(chapter_path: Path, databases: list[str],
               chapter_num: int) -> int:
    """Run all sql blocks in one psql script; return failure count."""
    text = chapter_path.read_text(encoding="utf-8")
    blocks = BLOCK_RE.findall(text)
    script_lines = ["\\set ON_ERROR_STOP 0"]
    spans: list[tuple[int, int]] = []
    for i, code in enumerate(blocks, 1):
        start = len(script_lines) + 1
        body = [ln for ln in code.splitlines()
                if not ln.lstrip().startswith("--")]
        script_lines.extend(body)
        spans.append((start, len(script_lines)))
        script_lines.append(f"\\echo __BLOCK_END_{i}__")
    script = rewrite_db_names("\n".join(script_lines) + "\n", chapter_num)

    with tempfile.NamedTemporaryFile("w", suffix=".sql", delete=False,
                                     dir=REPO / "docs" / "execution-logs",
                                     prefix=f"run-ch{chapter_num:02d}-",
                                     encoding="utf-8") as fh:
        fh.write(script)
        script_path = Path(fh.name)
    try:
        res = psql(["-d", databases[0], "-f", str(script_path)])
    finally:
        script_path.unlink(missing_ok=True)

    # Split stdout on the markers; attribute stderr lines by number.
    # Students see the real database names, so the log shows them too.
    outputs: list[str] = []
    rest = res.stdout
    for org, real in REAL_DB.items():
        rest = rest.replace(temp_db(chapter_num, org), real)
    for i in range(1, len(blocks) + 1):
        marker = f"__BLOCK_END_{i}__\n"
        chunk, sep, rest = rest.partition(marker)
        outputs.append(chunk if sep else chunk)
    errors: dict[int, list[str]] = {i: [] for i in range(1, len(blocks) + 1)}
    current_block = None
    for line in res.stderr.splitlines():
        m = ERR_LINE_RE.match(line)
        if m:
            lineno = int(m.group(1))
            current_block = next(
                (i for i, (a, b) in enumerate(spans, 1) if a <= lineno <= b),
                None)
            if current_block and m.group(2) in ("ERROR", "FATAL"):
                errors[current_block].append(
                    f"{m.group(2)}{m.group(3)}")
        elif current_block and line.startswith(("DETAIL:", "HINT:",
                                                 "LINE ", "CONTEXT:")):
            if errors[current_block]:
                errors[current_block].append(line)

    lines = [f"Execution log: {chapter_path.name}",
             f"SQL blocks found: {len(blocks)}",
             f"Databases: {', '.join(databases)}", ""]
    failures = 0
    for i, code in enumerate(blocks, 1):
        status = "FAIL" if errors[i] else "OK"
        failures += status == "FAIL"
        first = next((ln for ln in code.splitlines()
                      if ln.strip() and not ln.strip().startswith("--")),
                     "(comments only)")
        lines.append(f"--- block {i}/{len(blocks)} --- [{status}]")
        lines.append(f"    >>> {first}")
        for out_line in outputs[i - 1].rstrip("\n").splitlines():
            lines.append("    " + out_line)
        for e in errors[i]:
            lines.append("    " + e)
        lines.append("")
    lines.append(f"Failures: {failures}")
    log_path = REPO / "docs" / "execution-logs" / chapter_path.with_suffix(".log").name
    log_path.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"{chapter_path.name}: {len(blocks)} blocks, "
          f"{failures} failure(s) -> {log_path.relative_to(REPO)}")
    return failures


def main() -> None:
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    chapter_path = Path(sys.argv[1]).resolve()
    chapter_num = int(re.search(r"chapter-(\d+)", chapter_path.name).group(1))
    (REPO / "docs" / "execution-logs").mkdir(parents=True, exist_ok=True)
    # Databases first: a role that owns objects in a chapter database
    # cannot be dropped until that database is gone.
    for org in ORG_ORDER:
        psql(["-d", "postgres", "-qc",
              f'DROP DATABASE IF EXISTS "{temp_db(chapter_num, org)}" WITH (FORCE);'])
    drop_prefixed_roles()
    databases = rebuild_databases(chapter_num)
    if not databases:
        sys.exit("no setup-*.sql found for this chapter")
    failures = run_blocks(chapter_path, databases, chapter_num)
    sys.exit(1 if failures else 0)


if __name__ == "__main__":
    main()
