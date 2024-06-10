#!/bin/bash

export SENCHATESTSCRIPTNAME=index-ross.js
export SENCHATESTBROWSERS=firefox
./run-test-script.bash


for i in $(seq 1 5);
do
export SENCHATESTOUTPUTFNAME="firefox-$i-ross.txt"
export SENCHATESTARCHNAME="firefox-$i-ross.7z"
./run-test-script.bash
done





