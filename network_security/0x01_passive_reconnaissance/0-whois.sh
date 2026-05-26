#!/bin/bash
whois $1 | awk -F': *' '/^(Registrant|Admin|Tech) (Name|Organization|Street|City|State\/Province|Postal Code|Country|Phone|Phone Ext|Fax|Fax Ext|Email):/ {f=$1; v=$2; if(f~/Phone Ext$/||f~/Fax Ext$/)f=f":"; if(f~/Street$/)v=v" "; if(n)printf "\n"; printf "%s,%s",f,v; n++}' > $1.csv
