#! /bin/bash
#
# Event_Log.sh
# =================
# This script contains examples of using the Fastly API to pull various parts of the API documentation.
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

# Get the default 20 most recent events
pretty-out "Last 20 events"
curl -X GET -H "$FASTLY_API_KEY" "https://api.fastly.com/event_log/$FASTLY_SERVICE_ID"

# Get a set number of events
pretty-out "Getting the last 100 events"
curl -X GET -H "$FASTLY_API_KEY" "https://api.fastly.com/event_log/$FASTLY_SERVICE_ID?limit=100"

# Getting all events since....
pretty-out "Getting events since a particular unix timestamp"
curl -X GET -H "$FASTLY_API_KEY" "https://api.fastly.com/event_log/$FASTLY_SERVICE_ID?after=1408444752634"