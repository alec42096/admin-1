#! /bin/bash
#
# Diff.sh
# =================
# This script contains examples of using the Fastly API to pull down a diff of two versions.
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

# The rest of the commands assume you have either got the correct configuration
# version via the API or by accessing https://app.fastly.com/

# Get a diff of two versions. Get the versions are two arguments from the command line.
pretty-out "Getting plain ol' text diff of version $1 to $2"
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/diff/from/$1/to/$2"

# Now get that with a different format
pretty-out "Getting html_simple diff of version $1 to $2"
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/diff/from/$1/to/$2?format=html_simple"

# Now get that with a different format
pretty-out "Getting html diff of version $1 to $2"
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/diff/from/$1/to/$2?format=html"