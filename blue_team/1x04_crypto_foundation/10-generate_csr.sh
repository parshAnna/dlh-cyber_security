#!/bin/bash
set -euo pipefail
if [ "$#" -lt 4 ] || [ "$#" -gt 5 ]; then
  echo "Usage: $0 OUTPUT_DIR COUNTRY STATE CITY [EXTRA_DNS]" >&2
  exit 2
fi
dir=$1; country=$2; state=$3; city=$4; extra=${5:-}
[[ "$country" =~ ^[A-Z]{2}$ && "$state" =~ ^[[:alnum:]\ .-]+$ && "$city" =~ ^[[:alnum:]\ .-]+$ ]] || { echo "Invalid location fields" >&2; exit 2; }
[[ -z "$extra" || "$extra" =~ ^[A-Za-z0-9.-]+$ ]] || { echo "Invalid additional DNS name" >&2; exit 2; }
mkdir -p "$dir"
chmod 700 "$dir"
[[ ! -e "$dir/portal_key.pem" && ! -L "$dir/portal_key.pem" && ! -e "$dir/portal.csr" && ! -L "$dir/portal.csr" ]] || { echo "Refusing to overwrite existing files" >&2; exit 1; }
umask 077
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -out "$dir/portal_key.pem"
subject="/C=$country/ST=$state/L=$city/O=MedDefense Health Systems/OU=Information Technology/CN=portal.meddefense.local"
san="DNS:portal.meddefense.local"
[[ -z "$extra" ]] || san="$san,DNS:$extra"
openssl req -new -sha256 -key "$dir/portal_key.pem" -out "$dir/portal.csr" -subj "$subject" -addext "subjectAltName=$san" -addext "keyUsage=critical,digitalSignature" -addext "extendedKeyUsage=serverAuth" -addext "basicConstraints=critical,CA:FALSE"
openssl req -verify -noout -in "$dir/portal.csr"
openssl req -in "$dir/portal.csr" -noout -subject -text | grep -A2 'Subject Alternative Name'
echo "LAB CSR created: $dir/portal.csr (not issuable for .local by a public CA)"
