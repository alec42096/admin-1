#! /bin/bash
#
# Healthcheck.sh
# =================
# This script contains examples of using the Fastly API to create, list, update, delete healthchecks.
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

# Lets list out all the current healthchecks
pretty-out "Current healthchecks"
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/healthcheck"

# Now lets create a test healthcheck
pretty-out "Adding test healthcheck"
curl -X POST -H "$FASTLY_API_KEY" \
	-H "Content-type: application/json" \
"$FASTLY_API_URL/healthcheck" -d \
'{
	"name":"test-healthcheck",
	"method":"GET",
	"host":"www.jdade.me.uk",
	"path":"/healthcheck",
	"http_version":"1.1",
	"timeout":"300",
	"check_interval":"10000",
	"expected_response":"418",
	"window":"15",
	"threshold":"10",
	"initial":"5"
}'

# Now lets update that url to include the extension
pretty-out "Updating URL to /healthcheck.rb"
curl -X PUT -H "$FASTLY_API_KEY" \
	-H 'Content-type:application/json' \
"$FASTLY_API_URL/healthcheck/test-healthcheck" -d \
'{
	"url":"/healthcheck.rb"
}'

# And get that healthcheck to verify the update.
pretty-out "Verifying:"
curl -X GET -H"$FASTLY_API_KEY" "$FASTLY_API_URL/healthcheck/test-healthcheck"

# Clean up that healthcheck
pretty-out "Cleaning up test-healthcheck"
curl -X DELETE -H "$FASTLY_API_KEY" "$FASTLY_API_URL/healthcheck/test-healthcheck"