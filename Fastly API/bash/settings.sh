#! /bin/bash
#
# Settings.sh
# =================
# This script contains examples of using the Fastly API to manipulate some default settings.
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
VERSION="24"
FASTLY_API_URL="$FASTLY_API_URL/version/$VERSION"

# The rest of the commands assume you have either got the correct configuration
# version via the API or by accessing https://app.fastly.com/

# First lets get the current values
pretty-out "Current service settings: "
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/settings"

# Now let's update those values
pretty-out "Setting defaults:"
curl -X PUT -sv -H "$FASTLY_API_KEY" \
  -H "Content-type: application/json" \
  "$FASTLY_API_URL/settings" -d \
'{
  "general.default_host":"www.test.com",
  "general.default_ttl":"1",
  "general.default_pci":"0"
}'

# Now let's see those changes
pretty-out "New values:"
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/settings"
