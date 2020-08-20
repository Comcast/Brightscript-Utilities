#!/bin/bash
ROKU_DEV_TARGET=$1
ROKU_DEV_PASS=$2

if [ -z "$1" ]
  then
    echo ERROR: Missing Roku IP Address argument. Please pass the IP address of your Roku box as the first argument to the deploy script 1>&2
    exit 1 # terminate and indicate error
fi

echo "Wake up device"

# wake up/interrupt Roku - workaround for fw5.4 crash
curl -sS -d '' http://$ROKU_DEV_TARGET:8060/keypress/Home
curl -sS -d '' http://$ROKU_DEV_TARGET:8060/keypress/Home

echo "build & zip"

# build. zip _must_ change for Roku to accept re-deploy (grr!)
cd -- "$(dirname "$0")"
touch timestamp
zip -9 -r bundle source manifest

echo "deploy to roku device"
# deploy
curl -f -sS --user rokudev:$ROKU_DEV_PASS --anyauth -F "mysubmit=Install" -F "archive=@bundle.zip" -F "passwd=" http://$ROKU_DEV_TARGET/plugin_install  \
| python -c 'import sys, re; print "\n".join(re.findall("<font color=\"red\">(.*?)</font>", sys.stdin.read(), re.DOTALL))'

echo "Executing tests in 1 second..."

echo "Cleaning up bundle.zip output"
(sleep 3; rm bundle.zip)
