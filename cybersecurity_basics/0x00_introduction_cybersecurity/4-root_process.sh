#!/bin/bash
ps aux | grep "^$1" | grep -v grep | grep -v "4-root_process.sh" | grep -v " 0.0  0.0 "