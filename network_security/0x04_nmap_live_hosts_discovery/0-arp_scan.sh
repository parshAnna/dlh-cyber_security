#!/bin/bash
if [ "$(id -u)" -eq 0 ]; then
    nmap -sn -PR "$1"
else
    sudo nmap -sn -PR "$1"
fi
