#!/bin/bash
printf "  \n" "$2" "$1" | sha256sum -c --status 2>/dev/null && echo ok || echo invalid
