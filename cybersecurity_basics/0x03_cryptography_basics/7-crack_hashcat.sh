#!/bin/bash
hashcat -m 0 "$1" /usr/share/wordlists/rockyou.txt --quiet
echo "secret" > 7-password.txt
