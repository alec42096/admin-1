#! /bin/bash
#
# Condition.sh
# =================
# This script contains examples of using the Fastly API to create, list, update, delete conditions.
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

# First lets list out all the conditions already present
pretty-out "Listing all the conditions in the service"
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/condition"

# Now lets create a few test conditions
pretty-out "Creating test REQUEST condition"
curl -X POST -H "$FASTLY_API_KEY" \
	-H "Content-type: application/json" \
	-H "Accept: application/json" \
"$FASTLY_API_URL/condition" -d \
'
{
	"type":"REQUEST",
	"comment":"Test REQUEST condition",
	"name":"test_request_condition",
	"statement":"req.url ~ \"?food=pie$\""
}
'

pretty-out "Creating test CACHE condition"
curl -X POST -H "$FASTLY_API_KEY" \
	-H "Content-type: application/json" \
	-H "Accept: application/json" \
"$FASTLY_API_URL/condition" -d \
'
{
	"type":"CACHE",
	"comment":"Test CACHE condition",
	"name":"test_cache_condition",
	"statement":"beresp.http.cookie ~ \"PHPSESSID\""
}
'

pretty-out "Creating test RESPONSE condition"
curl -X POST -H "$FASTLY_API_KEY" \
	-H "Content-type: application/json" \
	-H "Accept: application/json" \
"$FASTLY_API_URL/condition" -d \
'
{
	"type":"RESPONSE",
	"comment":"Test RESPONSE condition",
	"name":"test_response_condition",
	"statement":"resp.status == 304"
}
'

# Now lets update one of those
pretty-out "Updating the response condition to match any redirection"
curl -X PUT -H "$FASTLY_API_KEY" \
	-H "Content-type: application/json" \
"$FASTLY_API_URL/condition/test_response_condition" -d \
'{
	"statement":"resp.status == 304 || resp.status == 307 || resp.status == 308 || resp.status == 302"
}'

# Now lets list those again to see the changes
# First lets list out all the conditions already present
pretty-out "Listing all the conditions in the service"
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/condition"

# And finally lets clean those up
pretty-out "Removing test conditions"
curl -X DELETE -H "$FASTLY_API_KEY" "$FASTLY_API_URL/condition/test_request_condition"
curl -X DELETE -H "$FASTLY_API_KEY" "$FASTLY_API_URL/condition/test_cache_condition"
curl -X DELETE -H "$FASTLY_API_KEY" "$FASTLY_API_URL/condition/test_response_condition"