#! /bin/bash -ex

COOKIE='fastly.session='
ORIGIN_SERVICE=''
ORIGIN_VERSION=''
DESTINATION_SERVICE=''

curl -H "Cookie:$COOKIE" -X PUT "https://app.fastly.com/service/$ORIGIN_SERVICE/version/$ORIGIN_VERSION/copy/to/$DESTINATION_SERVICE"
