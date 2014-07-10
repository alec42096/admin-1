#! /bin/bash
#
# backend.sh
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

# Set up a variable to save re-typing the whole lot for each API call.
export FASTLY_API_URL="https://api.fastly.com/service/$FASTLY_SERVICE_ID"

# The rest of the commands assume you have either got the correct configuration
# version via the API or by accessing https://app.fastly.com/

# List all backends
curl -G -H "$FASTLY_API_KEY" "$FASTLY_API_URL/version/103/backend"

# Create a backend
curl -X POST -H "$FASTLY_API_KEY" "$FASTLY_API_URL/version/103/backend" -d \
'hostname=test-1.test.com;port=80;name=test-1'

# Create a backend specified with JSON
curl "$FASTLY_API_URL/version/103/backend" -H 'Content-Type: application/json' -H "$FASTLY_API_KEY" -d \
'{"hostname":"test-2.test.com","port":"80","name":"test-2"}'

# List a specific backend
curl -G -H "$FASTLY_API_KEY" "$FASTLY_API_URL"'/version/103/backend/test-1'

# Update a backend
curl -X PUT -H "$FASTLY_API_KEY" "$FASTLY_API_URL/version/103/backend/test-1" -d \
'port=8000'

# Update a backend specified with JSON
curl -X PUT -H "$FASTLY_API_KEY" -H "Content-Type: application/json" --url "$FASTLY_API_URL/version/103/backend/test-2" -d \
'{"port":"8000"}'

# Delete a backend
curl -X DELETE -H "$FASTLY_API_KEY" --url "$FASTLY_API_URL/version/103/backend/test-1"
curl -X DELETE -H "$FASTLY_API_KEY" --url "$FASTLY_API_URL/version/103/backend/test-2"