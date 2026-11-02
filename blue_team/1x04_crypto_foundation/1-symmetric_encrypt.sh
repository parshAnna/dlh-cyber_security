#!/bin/bash
set -euo pipefail
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 INPUT OUTPUT {cbc|gcm}" >&2
  exit 2
fi
input=$1
output=$2
mode=$3
cert="$HOME/.config/meddefense-crypto/recipient.crt"
if [ ! -f "$input" ] || [ "$input" = "$output" ] || [ -e "$output" ]; then
  echo "Input missing, output exists, or paths are identical" >&2
  exit 2
fi
umask 077
case "$mode" in
cbc) openssl enc -aes-256-cbc -salt -pbkdf2 -iter 200000 -in "$input" -out "$output" ;;
gcm) [ -r "$cert" ] || { echo "Missing certificate: $cert" >&2; exit 1; }
  openssl cms -encrypt -binary -aes-256-gcm -outform DER -in "$input" -out "$output" "$cert" ;;
*) echo "Mode must be cbc or gcm" >&2; exit 2 ;;
esac
echo "Created: $output ($mode)"
