#!/bin/bash -ex
#
# Api 1.5 :: Server examples
#
# First run the login script to obtain the authentication cookies.
# Once these have been retrieved you can manipulate Rightscale objects.
#

# Import some variables
source ../user-details.sh

# Set some useful base variables
BASEURL="https://us-3.rightscale.com"

# Get a list of servers
curl -v -b "mySavedCookies-$ACCT" -X "POST" -H "X-API-VERSION:1.5" -H "Accept: application/xml" -d "resource_type=servers" -d "tags[]=vagrant:box_name=rightscale" "$BASEURL/api/tags/by_tag"
