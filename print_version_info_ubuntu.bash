#!/bin/bash

lsb_release -a 2>&1
java -version 2>&1
echo "Node.js version: $(node --version)" 
echo "npm version: $(npm --version)" 
echo "npx version: $(npx --version)" 
echo "Playwright version: $(npx playwright -V)"

SENCHACMD=$(which sencha)
if [ -x "$SENCHACMD" ]; then
  $SENCHACMD which || echo ""
else
  echo "Sencha is not installed"
fi

openssl version -a
