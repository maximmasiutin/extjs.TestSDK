#!/bin/bash
echo ""
node $SENCHATESTSCRIPTNAME -show-pass true -sdk-url "http://127.0.0.1:1841/" -toolkits classic,modern -browsers $SENCHATESTBROWSERS
echo ""
./print_version_information.bash
echo ""

