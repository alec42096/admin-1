#! /bin/bash
#
# Docs.sh
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

# Get the full docs unfiltered
pretty-out "Getting full docs"
curl -X GET "https://api.fastly.com/docs"

# Now lets get just one specific section
pretty-out "Docs for the service endpoint"
curl -X GET "https://api.fastly.com/docs/subject/service"

# Now lets run a search
pretty-out "Lets see if we can find references to backends"
curl -X GET "https://api.fastly.com/docs/section/%2E%2Abackend%2E%2A"

# Now lets run an inverted search
pretty-out "Lets see if we can find references to anything not backends"
curl -X GET "https://api.fastly.com/docs/section/%2E%2Abackend%2E%2A?invert=true"