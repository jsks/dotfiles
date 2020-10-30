#!/usr/bin/env python3
#
# Python script that toggles blocking the 20 most visited sites in
# chrome through /etc/hosts for a distraction free workflow.
###

from bs4 import BeautifulSoup
from collections import defaultdict
from pathlib import Path
from shutil import chown, copy
from time import time
from urllib.parse import urlparse
from urllib.request import urlopen

import re
import os
import sqlite3
import sys

def error(*args):
    print(*args, file = sys.stderr)
    sys.exit(1)

def alexa(country):
    p = Path("/tmp").joinpath(*["work_mode", country])
    Path.mkdir(p.parent, exist_ok = True)

    if p.is_file() and (time() - p.stat().st_mtime) / (60 * 60 * 24) < 30:
        cached_sites = p.read_text().split("\n")
        if len(cached_sites) == 50:
            return cached_sites

    try:
        print(f"Downloading top sites for {country}...")
        html = urlopen("https://www.alexa.com/topsites/countries/" + country).read().decode('utf-8')
        soup = BeautifulSoup(html, "html.parser")

        ll = soup.find_all("div", class_ = "DescriptionCell")
        sites = [e.a.get_text().lower() for e in ll]

        p.write_text("\n".join(sites))
        chown(p, user = "cloud")

        return sites
    except:
        print("Unable to download, skipping alexa list for " + country, file = sys.stderr)
        return []


exceptions = ["127.0.0.1", "localhost", "azure", "dropbox", "github",
              "gitlab", "google", "stackoverflow", "vasttrafik",
              "wikipedia"]
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
        db_file = Path("/home").joinpath(*[os.getenv("SUDO_USER"), ".config", "chromium",
                                           "Default", "History"])
    else:
        error(f"Platform error: '{sys.platform}' not supported")

    if not Path.is_file(db_file):
        error(f"Unable to open database file: {db_file}")

    # If chrome/chromium is open then History will be locked so copy
    # to a local directory before attempting to open
    target = Path("/tmp").joinpath(*["work_mode", "History"])
    Path.mkdir(target.parent, parents = True, exist_ok = True)
    copy(db_file, target)
    chown(db_file, user = "cloud")

    db = sqlite3.connect(target)
    db.row_factory = sqlite3.Row

    # Base our counts on when URLs were explicitly typed in address
    # bar
    rows = db.execute("select url, typed_count from urls;").fetchall()

    d = defaultdict(int)
    pattern = re.compile("^(chrome|file)://")
    for row in rows:
        if pattern.match(row["url"]):
            continue

        domain = urlparse(row["url"]).netloc.replace("www.", "")
        d[domain] += row["typed_count"]

    block = set()
    keys = sorted(d, key = d.get, reverse = True)

    for k in keys:
        if len(block) >= 20 or d[k] < 2:
            break

        if not any (x in k for x in exceptions):
            block.add(k)

    # Grab also Alexa top 50
    top_50 = alexa("US") + alexa("SE") + alexa("NO")
    for site in top_50:
        if not any (x in site for x in exceptions):
            block.add(site)

    f.write(header + "\n")

    print("Blocking...")
    for site in block:
        print("\t", site)
        f.write(f"127.0.0.1 {site}\n")
        f.write(f"127.0.0.1 www.{site}\n")

    f.write(header + "\n")
