#!/bin/bash
subfinder -d $1 -silent | tee >(while read host; do ip=$(dig +short $host | grep -m1 '^[0-9]'); [ -n "$ip" ] && echo "$host,$ip"; done > $1.txt)
