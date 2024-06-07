#!/bin/bash

export SENCHATESTSCRIPTNAME=run-tests.js
export SENCHATESTBROWSERS=firefox

i=1
export SENCHATESTOUTPUTFNAME=firefox-$i-run-tests.txt
export SENCHATESTARCHNAME=firefox-$i-run-tests.7z

./run-test-script.bash
