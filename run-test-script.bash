#!/bin/bash

[ -e $SENCHATESTOUTPUTFNAME ] && rm $SENCHATESTOUTPUTFNAME

GTIMECMD=$(which gtime)
if [ -x "$GTIMECMD" ]; then
  TIMECMD="$GTIMECMD"
else
  TIMECMD="time"
fi
date >$SENCHATESTOUTPUTFNAME 2>&1
$TIMECMD -v ./nodejsscript.bash 1>>$SENCHATESTOUTPUTFNAME 2>&1
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     ./pslinux.bash 1>>$SENCHATESTOUTPUTFNAME 2>&1
;;
esac
./print_version_information.bash 1>>$SENCHATESTOUTPUTFNAME 2>&1
date >>$SENCHATESTOUTPUTFNAME 2>&1
[ -e $SENCHATESTARCHNAME ] && rm $SENCHATESTARCHNAME
7zz a -mx9 $SENCHATESTARCHNAME $SENCHATESTOUTPUTFNAME

