#! /bin/bash
#
# Cache_Settings.sh
# =================
# This script contains examples of using the Fastly API to create, list, update, delete headers.
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

# List all cache settings
pretty-out "Listing all cache settings"
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/cache_settings"

# Create a new cache setting
pretty-out "Creating a new cache setting"
curl -X POST -H "$FASTLY_API_KEY" \
	-H "Content-type: application/json" \
	-H "Accept: application/json" \
"$FASTLY_API_URL/cache_settings" -d \
'{
	"name":"Test Cache Setting",
	"ttl":"18000",
	"stale_ttl":"72000",
	"action":"cache"
}'

# Now lets pull that one
pretty-out "Getting Test Cache Setting"
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/cache_settings/Test%20Cache%20Setting"

# Now lets change how long stale content is kept for.
pretty-out "Updating stale ttl."
curl -X PUT -H "$FASTLY_API_KEY" \
	-H "Content-type: application/json" \
	-H "Accept: application/json" \
"$FASTLY_API_URL/cache_settings/Test%20Cache%20Setting" -d \
'{"stale_ttl":"96000"}'

# And finally lets remove that rule now
pretty-out "Deleting the test cache setting."
curl -X DELETE -H "$FASTLY_API_KEY" "$FASTLY_API_URL/cache_settings/Test%20Cache%20Setting"

pretty-out ""