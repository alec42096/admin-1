#! /bin/bash
#
# billing.sh
# ==========
# This script contains examples of using the Fastly API to get billing details. This API call requires 
# the username/password & cookie authentication. If your account has 2 factor authentication enabled
# you will need to obtain the cookie from a logged in browser session.
# They presume some familiarity with Fastly and APIs in general and should be used as examples only.
#
# Additional details on using this script can be found at http://docs.fastly.com.
#

if [ "$FASTLY_API_DEBUG" == "true" ]; then
	set -e
	set -x
fi

# Load the configuration file that contains the api key and service id.
source ~/.fastly/api-creds.sh

# Define a function to display the output nicely.
pretty-out() {
	echo
	echo "$1"
}

# Set up a variable to save re-typing the whole lot for each API call.
FASTLY_API_URL="https://api.fastly.com"

# The rest of the commands assume you have either got the correct configuration
# version via the API or by accessing https://app.fastly.com/

# As billing needs username/password authentication and won't accept the API Key
curl -c fastly-cookies -X POST -H "Content-type: application/json" "$FASTLY_API_URL/login" -d \
"{\"user\":\"$FASTLY_USERNAME\",\"password\":\"$FASTLY_PASSWORD\"}"


# Get the latest bill
YEAR="`date +%Y`"
MONTH=$(expr "`date +%m`" - 1)

if [[ ! $MONTH -gt 0 ]]; then
	YEAR=$(expr $YEAR - 1)
	MONTH="12"
fi

curl -X GET -b fastly-cookies "$FASTLY_API_URL/billing/year/$YEAR/month/$MONTH"

pretty-out "Cleaning up"
if [ -e fastly-cookies ] && [ -z $FASTLY_API_DEBUG ]; then
	rm -f fastly-cookies
fi