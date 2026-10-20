#!/usr/bin/env python3
"""Set the mtime of every tracked file to the time of its last commit.

A fresh git checkout gives every file the checkout time as its mtime. Franklin
uses the source file's mtime for the sitemap's <lastmod> (and as a fallback
RSS pubDate), so without this every page looks like it changed on build day.

Reads the history in a single `git log` pass. Needs a full clone
(`fetch-depth: 0` in actions/checkout); in a shallow clone, files untouched
since the shallow boundary get the boundary commit's date.

Blog posts (`blog/YYYY/MM/*.md`) are the exception: their commits are mostly
site-wide mechanical edits (link fixes, markup changes), which aren't
significant updates to the post. They get their `published` date instead, or
`updated` if the post sets one (`@def updated = "12 August 2021"`) after a real
revision.

Usage: python3 .github/scripts/set_mtimes_from_git.py   (from the repository root)
"""
import calendar
import datetime
import os
import re
import subprocess

BLOG_POST = re.compile(r"^blog/\d{4}/\d{2}/[^/]+\.md$")


def post_date(name):
    """Unix time of a blog post's `updated` or `published` date, or None."""
    with open(name, encoding="utf-8") as f:
        text = f.read()
    for var in ("updated", "published"):
        m = re.search(rf'^\s*(?:@def\s+)?{var}\s*=\s*"([^"]+)"', text, re.M)
        if m:
            try:
                d = datetime.datetime.strptime(m.group(1).strip(), "%d %B %Y")
            except ValueError:
                print(f"warning: {name}: can't parse {var} = {m.group(1)!r}; using git date")
                return None
            return calendar.timegm(d.timetuple())
    return None


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

    n_posts = 0
    for name in tracked:
        if BLOG_POST.match(name) and os.path.isfile(name):
            t = post_date(name)
            if t is not None:
                mtimes[name] = t
                n_posts += 1

    n = 0
    for name, t in mtimes.items():
        try:
            os.utime(name, (t, t), follow_symlinks=False)
            n += 1
        except (FileNotFoundError, NotImplementedError):
            pass
    print(f"set mtime on {n} of {len(tracked)} tracked files "
          f"({n_posts} blog posts from their published/updated date, the rest from git)")


if __name__ == "__main__":
    main()
