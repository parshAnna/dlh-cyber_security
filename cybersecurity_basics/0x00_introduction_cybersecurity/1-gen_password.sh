#!/bin/bash
tr -dc "[:alnum:]" < /dev/urandom 2>/dev/null | head -c "$1"; echo
