#! /bin/bash
#
# Response_object.sh
# =================
# This script contains examples of using the Fastly API to create, list, update, delete request settings.
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
VERSION="4"
FASTLY_API_URL="$FASTLY_API_URL/version/$VERSION"

# The rest of the commands assume you have either got the correct configuration
# version via the API or by accessing https://app.fastly.com/

# First lets list out the current response objects
pretty-out "Current response objects:"
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/response_object"

pretty-out "Now lets add a test response object"
curl -X POST -H "$FASTLY_API_KEY" \
  -H "Content-type: application/json" \
  "$FASTLY_API_URL/response_object" -d \
'{
  "status":"418",
  "response":"Im a teapot",
  "cache-condition":"",
  "request-condition":"",
  "name":"test-response",
  "content":"Im short and stout",
  "content_type":"text/plain"
}'

pretty-out "Verifying:"
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/response_object/test-response"

pretty-out "Now lets update that with better grammar"
curl -X PUT -H "$FASTLY_API_KEY" \
  -H "Content-type: application/json" \
  "$FASTLY_API_URL/response_object/test-response" -d \
'{
  "response":"I'\''m a teapot",
  "content":"I'\''m short and stout"
}'

pretty-out "Re-verifying:"
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/response_object/test-response"

pretty-out "Now lets clean that up"
curl -X DELETE -H "$FASTLY_API_KEY" "$FASTLY_API_URL/response_object/test-response"