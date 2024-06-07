set OUTPUTNAME=chromium-1-sdk-excluded-windows.txt
del %OUTPUTNAME%
node run-tests.js -show-pass true -sdk-url "http://127.0.0.1:1841/" -toolkits classic,modern -browsers chromium 1>%OUTPUTNAME% 2>&1
