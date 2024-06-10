#!/bin/bash

export SENCHATESTSCRIPTNAME=run.js
export SENCHATESTBROWSERS=chromium,firefox
export SENCHAOUTPUTFILENAMECLASS=chromium-and-firefox

for i in $(seq 1 1);
do
export SENCHATESTOUTPUTFNAME="$SENCHAOUTPUTFILENAMECLASS-$i-run-$OSTYPE.txt"
echo "Output file: $SENCHATESTOUTPUTFNAME"
export SENCHATESTARCHNAME="$SENCHAOUTPUTFILENAMECLASS-$i-run-$OSTYPE.7z"
echo "Archive name: $SENCHATESTARCHNAME"
./run-test-script.bash
done





