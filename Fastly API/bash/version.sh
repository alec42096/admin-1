#! /bin/bash
#
# version.sh
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

# Define a function to display the output nicely.
pretty-out() {
	echo
	echo "$1"
}

# Set up which configuration version to adjust
VERSION="1"
# Set up a variable to save re-typing the whole lot for each API call.
export FASTLY_API_URL="https://api.fastly.com/service/$FASTLY_SERVICE_ID"

# The rest of the commands assume you have either got the correct configuration
# version via the API or by accessing https://app.fastly.com/

# # List the versions
# pretty-out "Listing Versions:"
# curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/version"

# # Create a new version
# pretty-out "Creating new version"
# curl -X POST -H "$FASTLY_API_KEY" "$FASTLY_API_URL/version"

# # List a new version
# NUMBER=`curl -X POST -H "$FASTLY_API_KEY" "$FASTLY_API_URL/version" | sed -e 's/.*number":\([0-9][0-9]*\).*/\1/'`
# curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/version/$NUMBER"

# Debug / development version 
NUMBER="17"

# Update a version.
pretty-out "Add a comment to this version"
curl -X PUT -H "$FASTLY_API_KEY" \
	-H "Content-type: application/json" \
	-H "Accept: application/json" \
	"$FASTLY_API_URL/version/$NUMBER" -d \
'{"comment":"This is the test version."}'

# Cloning a 'good' version
pretty-out "!!!!!    Cloning version 1 to a new version    !!!!!!"
curl -X PUT -H "$FASTLY_API_KEY" "$FASTLY_API_URL/version/1/clone"


# Validate the new version is good to activate
pretty-out "Validate the new version"
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/version/18/validate"

# Now lets activate it
pretty-out "Activating the new version"
curl -X PUT -H "$FASTLY_API_KEY" "$FASTLY_API_URL/version/18/activate"

