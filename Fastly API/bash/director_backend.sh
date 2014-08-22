#! /bin/bash
#
# Director_Backend.sh
# =================
# This script contains examples of using the Fastly API to create, list, update, delete director backends.
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

# First lets create a director and two backends for testing with.
pretty-out "creating two backends and a director."
curl -X POST -H "$FASTLY_API_KEY" -H "Content-type: application/json" -H "Accept: application/json" "$FASTLY_API_URL/director" -d '{"name":"test-director", "type":"4"}'
curl "$FASTLY_API_URL/backend" -H 'Content-Type: application/json' -H "$FASTLY_API_KEY" -d '{"hostname":"test-2.test.com","port":"80","name":"test-1","auto_loadbalance":"true"}'
curl "$FASTLY_API_URL/backend" -H 'Content-Type: application/json' -H "$FASTLY_API_KEY" -d '{"hostname":"test-2.test.com","port":"80","name":"test-2","auto_loadbalance":"true"}'

# Now the real code begins...
# Unlike other API examples we cannot list an empty set to start with.
# Let's add those backends to the director.
pretty-out "Adding backends to the director"
curl -X POST -H "$FASTLY_API_KEY" "$FASTLY_API_URL/director/test-director/backend/test-1"
curl -X POST -H "$FASTLY_API_KEY" "$FASTLY_API_URL/director/test-director/backend/test-2"

# Now we can get that data to verify
pretty-out "Listing the backend relationships"
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/director/test-director/backend/test-1"
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/director/test-director/backend/test-2"

# And now lets remove those relationships
# Now we can get that data to verify
pretty-out "Removing the backend relationships"
curl -X DELETE -H "$FASTLY_API_KEY" "$FASTLY_API_URL/director/test-director/backend/test-1"
curl -X DELETE -H "$FASTLY_API_KEY" "$FASTLY_API_URL/director/test-director/backend/test-2"

# And of course the final cleanup
pretty-out "Cleaning up."
curl -X DELETE "$FASTLY_API_URL/backend/test-1" -H "$FASTLY_API_KEY"
curl -X DELETE "$FASTLY_API_URL/backend/test-2" -H "$FASTLY_API_KEY"
curl -X DELETE -H "$FASTLY_API_KEY" "$FASTLY_API_URL/director/test-director"
