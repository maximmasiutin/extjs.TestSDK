#!/bin/bash

npm i 1>/dev/null 2>&1
killall -9 node 1>/dev/null 2>&1
chmod +x ./run-false-positive-tests.sh
gtime -v ./run-false-positive-tests.sh 1>false-positive-all-browsers.txt 2>&1

