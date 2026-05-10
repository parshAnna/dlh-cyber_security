#!/usr/bin/env bash
find "$1" -user user2 -exec chown user3 {} \;
