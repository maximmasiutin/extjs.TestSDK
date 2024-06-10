#!/bin/bash

export SENCHATESTSCRIPTNAME=run-tests.js
export SENCHATESTBROWSERS=firefox

for i in $(seq 1 5);
do
export SENCHATESTOUTPUTFNAME=firefox-$i-run-tests.txt
export SENCHATESTARCHNAME=firefox-$i-run-tests.7z
./run-test-script.bash
done
