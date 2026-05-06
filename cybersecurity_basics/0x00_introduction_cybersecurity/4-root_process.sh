#!/bin/bash
ps -u "$1" aux | grep -v " 0.0  0.0 "