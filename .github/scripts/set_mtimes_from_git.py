#!/usr/bin/env python3
"""Set the mtime of every tracked file to the time of its last commit.

A fresh git checkout gives every file the checkout time as its mtime. Franklin
uses the source file's mtime for the sitemap's <lastmod> (and as a fallback
RSS pubDate), so without this every page looks like it changed on build day.

Reads the history in a single `git log` pass. Needs a full clone
(`fetch-depth: 0` in actions/checkout); in a shallow clone, files untouched
since the shallow boundary get the boundary commit's date.

Usage: python3 .github/scripts/set_mtimes_from_git.py   (from the repository root)
"""
import os
import subprocess


def main():
    tracked = set(
        subprocess.run(
            ["git", "ls-files", "-z"], check=True, capture_output=True
        ).stdout.decode("utf-8", "surrogateescape").split("\0")
    )
    tracked.discard("")

    # Output: "\x01<unix time>\0\n<file>\0<file>\0\x01<unix time>\0..."
    log = subprocess.run(
        ["git", "log", "-z", "--no-renames", "--name-only", "--format=%x01%ct"],
        check=True, capture_output=True,
    ).stdout.decode("utf-8", "surrogateescape")

    mtimes = {}
    ts = None
    for tok in log.split("\0"):
        if tok.startswith("\x01"):
            ts = int(tok[1:])
            continue
        name = tok.lstrip("\n")
        # Keep the newest commit time (log order is not strictly by date).
        if name in tracked and ts is not None and ts > mtimes.get(name, 0):
            mtimes[name] = ts

    n = 0
    for name, t in mtimes.items():
        try:
            os.utime(name, (t, t), follow_symlinks=False)
            n += 1
        except (FileNotFoundError, NotImplementedError):
            pass
    print(f"set mtime from git history on {n} of {len(tracked)} tracked files")


if __name__ == "__main__":
    main()
