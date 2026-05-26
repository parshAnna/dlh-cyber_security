#!/bin/bash
find / -type d -perm -0002 -print -exec chmod go-w {} \; 2>/dev/null
