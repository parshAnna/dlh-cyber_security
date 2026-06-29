#!/bin/bash
find /home /var/www -xdev -type d -perm -0002 -print -exec chmod o-w {} + 2>/dev/null
