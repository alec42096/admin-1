#! /bin/bash

if [ "$FASTLY_API_DEBUG" == "true" ]; then
	set -e
	set -x
fi

# Load the configuration file that contains the api key and service id
source ~/.fastly/api-creds.sh

# Set up a variable to save re-typing the whole lot for each API call.
export FASTLY_API_URL="https://api.fastly.com/service/$FASTLY_SERVICE_ID"

# List all backends
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/version/1/backend"

# List a specific backend
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/version/1/backend/"

# Create a new backend
curl -X PUT -H "$FASTLY_API_KEY" "$FASTLY_API_URL/version/102/bakend" -d \
{

}