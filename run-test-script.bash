#!/bin/bash

[ -e $SENCHATESTOUTPUTFNAME ] && rm $SENCHATESTOUTPUTFNAME

GTIMECMD=$(which gtime)
if [ -x "$GTIMECMD" ]; then
  TIMECMD="$GTIMECMD"
else
  TIMECMD="time"
fi
$TIMECMD -v node $SENCHATESTSCRIPTNAME -show-pass true -sdk-url "http://127.0.0.1:1841/" -toolkits classic,modern -browsers $SENCHATESTBROWSERS 1>$SENCHATESTOUTPUTFNAME 2>&1
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     ./pslinux.bash;;
esac
[ -e $SENCHATESTARCHNAME ] && rm $SENCHATESTARCHNAME
7zz a -mx9 $SENCHATESTARCHNAME $SENCHATESTOUTPUTFNAME

