#!/usr/bin/env python3
"""Run one command while holding the harness lock.

The SQL harness rebuilds the three course databases and the course
roles on the shared local cluster, and it serializes itself with a
file lock. Any other command that touches the cluster (a pg_dump for a
backup fixture, an exploratory psql session that must see a specific
chapter's state) should hold the same lock, or a concurrent harness
run will rebuild the database underneath it.

Usage (from the repo root):

    python3 tools/locked.py -- pg_dump -U postgres copperwind_ops -f out.sql
    python3 tools/locked.py -- sh -c 'python3 tools/run_chapter_sql.py book/chapters/chapter-09.md && pg_dump ...'

Everything after ``--`` runs as a child process with the lock held.
"""

from __future__ import annotations

import fcntl
import os
import subprocess
import sys
import tempfile


def main() -> None:
    argv = sys.argv[1:]
    if argv and argv[0] == "--":
        argv = argv[1:]
    if not argv:
        sys.exit(__doc__)
    lock_path = os.path.join(tempfile.gettempdir(), "cis376-harness.lock")
    with open(lock_path, "w") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        env = dict(os.environ, LC_ALL="en_US.UTF-8")
        env.setdefault("PATH", "")
        env["PATH"] = "/opt/homebrew/opt/postgresql@17/bin:" + env["PATH"]
        result = subprocess.run(argv, env=env)
    sys.exit(result.returncode)


if __name__ == "__main__":
    main()
