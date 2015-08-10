#! /bin/bash
#
# Pricing_Extras.sh
# =================
# This script contains examples of using the Fastly API to list any pricing extras associated with an account.
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
FASTLY_API_URL="https://api.fastly.com/service/$FASTLY_SERVICE_ID"
VERSION="2"
FASTLY_API_URL="$FASTLY_API_URL/version/$VERSION"

# The rest of the commands assume you have either got the correct configuration
# version via the API or by accessing https://app.fastly.com/

# get the customer id
ID=`curl -X GET -H "$FASTLY_API_KEY" "https://api.fastly.com/current_customer" | sed -e 's/.*\"id\":\"\([A-Za-z0-9][A-Za-z0-9]*\).*/\1/'`
echo "ID: $ID"

curl -X GET -sv -H "$FASTLY_API_KEY" "https://api.fastly.com/customer/$ID/pricing_extra"
