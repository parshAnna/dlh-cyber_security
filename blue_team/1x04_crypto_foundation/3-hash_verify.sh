#!/bin/bash
set -euo pipefail
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 FILE EXPECTED_SHA256" >&2
  exit 1
fi
file=$1
expected=${2,,}
if [ ! -f "$file" ] || [ ! -r "$file" ]; then
  echo "INTEGRITY FAILED - expected $expected got unavailable"
  exit 1
fi
if [[ ! "$expected" =~ ^[0-9a-f]{64}$ ]]; then
  echo "Expected a 64-character hexadecimal SHA-256 hash" >&2
  exit 1
fi
actual=$(sha256sum -- "$file" | awk '{print $1}')
if [ "$actual" = "$expected" ]; then
  echo "INTEGRITY OK"
  exit 0
fi
echo "INTEGRITY FAILED - expected $expected got $actual"
exit 1
