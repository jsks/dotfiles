#!/usr/bin/env python3
#
# Python script that toggles blocking the 20 most visited sites in
# chrome through /etc/hosts for a distraction free workflow.
###

from collections import defaultdict
from shutil import copy
from urllib.parse import urlparse
from pathlib import Path

import os
import sqlite3
import sys

def error(*args):
    print(*args, file = sys.stderr)
    sys.exit(1)

exceptions = ["github", "gitlab", "google", "wikipedia"]
header = "########## Work Mode"

if not os.access("/etc/hosts", os.W_OK):
    error("Permissions error: unable to write to /etc/hosts")

with open("/etc/hosts", "r+") as f:
    lines = f.readlines()

    # Toggle enable/disabling of blocking depending on whether our
    # headers are present in /etc/hosts
    idx = [i for i, x in enumerate(lines) if header in x]
    if len(idx) == 2:
        print("Disabling work-mode")

        f.seek(0)
        for i in range(len(lines)):
            if idx[0] <= i <= idx[1]:
                continue

            f.write(lines[i])

        f.truncate()
        sys.exit(0)
    elif len(idx) > 0:
        error(f"Parse error: /etc/hosts contains {len(idx)} work-mode header(s)")

    if sys.platform == "darwin":
        db_file = Path.home().joinpath(*["Library", "Application Support",
                                         "Google", "Chrome", "Default", "History"])
    elif sys.platform == "linux":
        db_file = Path.home().joinpath(*[".config", "chromium",
                                         "Default", "History"])
    else:
        error(f"Platform error: '{sys.platform}' not supported")

    if not Path.is_file(db_file):
        error("Error: unable to find history database")

    # If chrome/chromium is open then History will be locked so copy
    # to a local directory before attempting to open
    target = Path.home().joinpath(*[".cache", "work_mode", "History"])
    Path.mkdir(target.parent, parents = True, exist_ok = True)
    copy(db_file, target)

    db = sqlite3.connect(target)
    db.row_factory = sqlite3.Row

    # Base our counts on when URLs were explicitly typed in address
    # bar
    rows = db.execute("select url, typed_count from urls;").fetchall()

    d = defaultdict(int)
    for row in rows:
        domain = urlparse(row["url"]).netloc.replace("www.", "")
        d[domain] += row["typed_count"]

    block = []
    keys = sorted(d, key = d.get, reverse = True)

    for k in keys:
        if len(block) >= 20 or d[k] < 2:
            break

        if not any (x in k for x in exceptions):
            block.append(k)

    f.write(header + "\n")

    print("Blocking...")
    for site in block:
        print("\t", site)
        f.write(f"127.0.0.1 {site}\n")
        f.write(f"127.0.0.1 www.{site}\n")

    f.write(header + "\n")
