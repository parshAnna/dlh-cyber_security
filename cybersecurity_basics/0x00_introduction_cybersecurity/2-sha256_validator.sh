#!/bin/bash

HASH=$(sha256sum "$1" | awk '{print $1}')

if [ "$HASH" = "$2" ]
then
	echo ok
else
	echo invalid
fi
