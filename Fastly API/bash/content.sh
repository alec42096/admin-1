#! /bin/bash
#
# Content.sh
# =================
# This script contains examples of using the Fastly API to check content on the edge of Fastly's network.
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

# Test a URL for presence on all edge nodes.
pretty-out "Testing: $1"
curl -X GET "https://api.fastly.com/content/edge_check?url=$1"
