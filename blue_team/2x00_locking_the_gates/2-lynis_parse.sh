#!/bin/bash
set -euo pipefail
[[ $# -eq 1 && -s "$1" && -r "$1" ]] || { echo "Usage: $0 readable-lynis-report.dat" >&2; exit 1; }
python3 - "$1" <<'PY'
import json, re, sys
index, findings = None, []
with open(sys.argv[1], encoding="utf-8", errors="replace") as report:
    while line := report.readline():
        key, sep, value = line.rstrip("\r\n").partition("=")
        if not sep: continue
        if key == "hardening_index":
            index = int(value.strip())
        if key not in {"warning[]", "suggestion[]", "manual_check[]"}: continue
        parts = value.split("|")
        while parts and not parts[0].strip(): parts.pop(0)
        test_id = "LYNIS"
        if parts and re.fullmatch(r"[A-Za-z][A-Za-z0-9_]*-[0-9]+|LYNIS", parts[0].strip()):
            test_id = parts.pop(0).strip()
        message = next(iter(parts), "").strip()
        findings.append({"severity": key[:-2], "test_id": test_id, "message": message})
if index is None: sys.exit("Missing hardening_index in report")
json.dump({"hardening_index": index, "findings": findings}, sys.stdout, indent=2)
print()
PY
