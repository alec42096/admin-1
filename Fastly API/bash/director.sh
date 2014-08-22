#! /bin/bash
#
# Director.sh
# =================
# This script contains examples of using the Fastly API to create, list, update, delete directors.
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

# First lets list all the directors in the account
pretty-out "Listing the current directors"
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/director"

# Lets create a new director to test with
pretty-out "Creating test director."
curl -X POST -H "$FASTLY_API_KEY" \
	-H "Content-type: application/json" \
"$FASTLY_API_URL/director" -d \
'{
	"name":"test-director",
	"type":3,
	"quorum":75,
	"retries":3
}'

# Cleanup time. Lets remove that director.
pretty-out "Deleting the test director"
curl -X DELETE -H "$FASTLY_API_KEY" "$FASTLY_API_URL/director/test-director"