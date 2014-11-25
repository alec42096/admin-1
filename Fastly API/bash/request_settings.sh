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
VERSION="4"
FASTLY_API_URL="$FASTLY_API_URL/version/$VERSION"

# The rest of the commands assume you have either got the correct configuration
# version via the API or by accessing https://app.fastly.com/

# First lets get any request settings currently configured.
pretty-out "Lets get the list of request settings"
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/request_settings"

# Now lets create a test one
pretty-out "Adding a test request setting"
curl -X POST -H "$FASTLY_API_KEY" \
  -H 'Content-type: application/json' \
  "$FASTLY_API_URL/request_settings" -d \
'{
  "hash_keys":null,
  "action":"lookup",
  "xff":"append",
  "force_ssl":"1",
  "geo_headers":"1",
  "name":"API_test",
  "bypassbusy_wait":"0",
  "default_host":"",
  "max_stale_age":"60"
}'

# Now lets list it to make sure it was added
pretty-out "Lets get the list of request settings"
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/request_settings/API_test"

# Now lets update that name
pretty-out "Updating the request setting to add a default host"
curl -X PUT -H "$FASTLY_API_KEY" \
  -H "Content-type: application/json" \
  "$FASTLY_API_URL/request_settings/API_test" -d \
'{
  "default_host":"www.example.com"
}'

# Now lets clean up again.
pretty-out "Now lets clean that back up."
curl -X DELETE -H "$FASTLY_API_KEY" "$FASTLY_API_URL/request_settings/API_test"