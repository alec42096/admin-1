#! /bin/bash
#
# header.sh
# ==========
# This script contains examples of using the Fastly API to create, list, update, delete backends
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

# Create a header
pretty-out "Create a new header."
curl -X POST \
	-H "$FASTLY_API_KEY" \
	-H "Content-type: application/json" \
	-H "Accept: application/json" \
"$FASTLY_API_URL/header" -d \
'{
	"name":"cookie-lb",
	"type":"request",
	"action":"set",
	"dst":"client.identity",
	"src":"regsub(req.http.cookie, \"/session=(.*);/\",\"\\1\")",
	"ignore_if_set":"0",
	"priority":"10"
}'

# Show a header
pretty-out "Show a specific header"
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/header/cookie-lb"

# Change a header
pretty-out "Updating the header"
curl -X PUT -H "$FASTLY_API_KEY" "$FASTLY_API_URL/header/cookie-lb" \
	-H "Content-type: application/json" \
	-H "Accept: application/json" -d \
'{
	"name":"cookie-load-balancing"
}'

# Show all headers
pretty-out "Show all the headers"
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/header"

# Delete that header again now
pretty-out "Delete that header now"
curl -X DELETE -H "$FASTLY_API_KEY" "$FASTLY_API_URL/header/cookie-load-balancing"

pretty-out ""
