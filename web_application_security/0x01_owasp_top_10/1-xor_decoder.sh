#!/bin/bash
python3 - $1 <<'PY'
import base64
import sys

text = sys.argv[1]
text = text.replace("{xor}", "", 1)
data = base64.b64decode(text)
decoded = bytes(map(lambda byte: byte ^ 95, data))
sys.stdout.write(decoded.decode("utf-8"))
sys.stdout.write("\n")
PY
