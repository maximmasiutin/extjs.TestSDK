#!/bin/bash

export SENCHATESTSCRIPTNAME=index-ross.js
export SENCHATESTBROWSERS=firefox
export SENCHAOUTPUTFILENAMECLASS=firefox

for i in $(seq 1 5);
do
export SENCHATESTOUTPUTFNAME="$SENCHAOUTPUTFILENAMECLASS-$i-ross-$OSTYPE.txt"
echo "Output file: $SENCHATESTOUTPUTFNAME"
export SENCHATESTARCHNAME="$SENCHAOUTPUTFILENAMECLASS-$i-ross-$OSTYPE.7z"
echo "Archive name: $SENCHATESTARCHNAME"
./run-test-script.bash
done





