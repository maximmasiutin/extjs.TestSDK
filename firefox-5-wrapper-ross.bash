#!/bin/bash

export SENCHATESTSCRIPTNAME=index-ross.js
export SENCHATESTBROWSERS=firefox

for i in $(seq 1 5);
do
export SENCHATESTOUTPUTFNAME="firefox-$i-ross.txt"
echo "Output file: $SENCHATESTOUTPUTFNAME"
export SENCHATESTARCHNAME="firefox-$i-ross.7z"
echo "Archive name: $SENCHATESTARCHNAME"
./run-test-script.bash
done





