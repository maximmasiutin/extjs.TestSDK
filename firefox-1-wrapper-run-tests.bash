#!/bin/bash

OUTPUTFNAME=firefox-1-run-tests.txt
ARCHNAME=firefox-1-run-tests.7z
[ -e $OUTPUTFNAME ] && rm $OUTPUTFNAME
node run-tests.js -show-pass true -sdk-url "http://127.0.0.1:1841/" -toolkits classic,modern -browsers firefox 1>$OUTPUTFNAME 2>&1
[ -e $ARCHNAME ] && rm $ARCHNAME
7zz a -mx9 $ARCHNAME $OUTPUTFNAME

