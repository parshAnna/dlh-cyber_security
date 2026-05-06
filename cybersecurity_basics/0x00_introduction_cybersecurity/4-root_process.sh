#!/bin/bash
ps aux | grep "^$1" | grep -v grep | grep -v awk | awk '!($5==0 && $6==0)'