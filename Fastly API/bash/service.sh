#! /bin/bash
#
# Service.sh
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
FASTLY_API_URL="https://api.fastly.com/"

# The rest of the commands assume you have either got the correct configuration
# version via the API or by accessing https://app.fastly.com/

# Lets list out the current services
pretty-out "Listing the services (and versions)"
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/service"

# Lets get the details of a service
pretty-out "Getting details for a service"
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/service/$FASTLY_SERVICE_ID/details"

# Get the basic information for a service
pretty-out "Getting basic information for the service"
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/service/$FASTLY_SERVICE_ID"

# Search for a service
pretty-out "Search for a service"
read -p "Enter the name to search for: " NAME
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/service/search?name=$NAME"

# Create a new service
TS=`date +%s` # keep the timestamp for re-use later
pretty-out "Creating a test service"
curl -X POST -H "$FASTLY_API_KEY" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  "$FASTLY_API_URL/service" -d \
'{
  "name":"api-test-'$TS'",
  "customer_id":"$FASTLY_CUSTOMER_ID"
}'

# Need to get that service ID again to store as a variable.
SERVICE_ID=`curl -s -H "$FASTLY_API_KEY" "$FASTLY_API_URL/service/search?name=api-test-$TS" | sed -e 's/.*,"id":"\([A-Za-z0-9]*\)".*/\1/'`

# Lets update that service now
pretty-out "Now lets update the name and add a comment for the service."
curl -X PUT -H "$FASTLY_API_KEY" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  "$FASTLY_API_URL/service/$SERVICE_ID" -d \
'{
  "name":"new-test-name-'$TS'",
  "comment":"new-test-comment-'$TS'"
}'

# Now lets see what domains are on the service
pretty-out "Lets get a list of domains associated with this service"
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/service/$SERVICE_ID/domain"

# And finally let's clean up that test service
pretty-out "Cleaning up. Deleting created service"
curl -X DELETE -H "$FASTLY_API_KEY" "$FASTLY_API_URL/service/$SERVICE_ID"
