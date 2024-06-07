#!/bin/bash

npm i 1>/dev/null 2>&1
killall -9 node 1>/dev/null 2>&1

GTIMECMD=$(which gtime)
if [ -x "$GTIMECMD" ]; then
  TIMECMD="$GTIMECMD"
else
  TIMECMD="time"
fi
$TIMECMD -v ./run-false-positive-tests.bash 1>false-positive-all-browsers.txt 2>&1

