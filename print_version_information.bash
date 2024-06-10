#!/bin/bash

echo ""
case "$OSTYPE" in
  darwin*)  echo "OSX" ;; 
  linux*)   lsb_release -a 2>&1;sudo lshw 2>&1;lscpu 2>&1;;
  msys*)    echo "sw_vers" 2>&1;;
  cygwin*)  echo "ver" ;;
esac
echo ""
java -version 2>&1
echo ""
echo "node.js version: $(node --version)"
echo "npm version: $(npm --version)"
echo "Playwright version: $(npx playwright -V)"
echo "PhantomJS version: $(phantomjs -v)"
echo ""
SENCHACMD=$(which sencha)
if [ -x "$SENCHACMD" ]; then
  $SENCHACMD which || echo ""
else
  echo "Sencha is not installed"
fi
echo ""
openssl version -a
echo ""
