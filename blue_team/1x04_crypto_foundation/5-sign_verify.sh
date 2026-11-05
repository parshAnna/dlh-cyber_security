#!/bin/bash
set -euo pipefail
usage() { echo "Usage: $0 sign FILE PRIVATE_KEY | verify FILE SIGNATURE PUBLIC_KEY" >&2; exit 2; }
[ "$#" -ge 1 ] || usage
case "$1" in
  sign)
    [ "$#" -eq 3 ] || usage
    [ -f "$2" ] && [ -r "$3" ] || { echo "Missing input file or private key" >&2; exit 2; }
    [ ! -e "$2.sig" ] && [ ! -L "$2.sig" ] || { echo "Signature already exists: $2.sig" >&2; exit 2; }
    umask 077
    openssl dgst -sha256 -sign "$3" -out "$2.sig" "$2"
    echo "Signature created: $2.sig"
    ;;
  verify)
    [ "$#" -eq 4 ] || usage
    [ -f "$2" ] && [ -r "$3" ] && [ -r "$4" ] || { echo "Missing file, signature, or public key" >&2; exit 2; }
    openssl dgst -sha256 -verify "$4" -signature "$3" "$2"
    ;;
  *) usage ;;
esac
