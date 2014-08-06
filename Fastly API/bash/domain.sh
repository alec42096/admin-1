#! /bin/bash
#
# domain.sh
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

# Set up a variable to save re-typing the whole lot for each API call.
export FASTLY_API_URL="https://api.fastly.com/service/$FASTLY_SERVICE_ID"

# The rest of the commands assume you have either got the correct configuration
# version via the API or by accessing https://app.fastly.com/

# Create a domain for a service
pretty-out "Create a domain"
curl -X POST -H "$FASTLY_API_KEY" "$FASTLY_API_URL/version/129/domain" -d \
'name=test.jdade.me.uk'

# List all domains
pretty-out "List all domains"
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/version/129/domain"

# List the details of a specific domain
pretty-out "List the details of a domain"
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/version/129/domain/test.jdade.me.uk"

# Check all domains in a service
pretty-out "Check the DNS of all domains"
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/version/129/domain/check_all"

# Check a single domain
pretty-out "Check the DNS of a single domain"
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/version/129/domain/test.jdade.me.uk/check"

# Update a domain
pretty-out "Update a domain with a new value"
curl -X PUT -H "$FASTLY_API_KEY" "$FASTLY_API_URL/version/129/domain/test.jdade.me.uk" -d \
'name=test-updated.jdade.me.uk'

# Delete a domain
pretty-out "Delete the a domain"
curl -X DELETE -H "$FASTLY_API_KEY" "$FASTLY_API_URL/version/129/domain/test-updated.jdade.me.uk"

pretty-out ""
