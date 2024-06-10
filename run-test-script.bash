#!/bin/bash

[ -e $SENCHATESTOUTPUTFNAME ] && rm $SENCHATESTOUTPUTFNAME

GTIMECMD=$(which gtime)
if [ -x "$GTIMECMD" ]; then
  TIMECMD="$GTIMECMD"
else
  TIMECMD="time"
fi
$TIMECMD -v ./nodejsscript.bash 1>$SENCHATESTOUTPUTFNAME 2>&1
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     ./pslinux.bash;;
esac
[ -e $SENCHATESTARCHNAME ] && rm $SENCHATESTARCHNAME
7zz a -mx9 $SENCHATESTARCHNAME $SENCHATESTOUTPUTFNAME

