#! /bin/bash
#
# Vcl.sh
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
VERSION="32"
FASTLY_API_URL="$FASTLY_API_URL/version/$VERSION"

# The rest of the commands assume you have either got the correct configuration
# version via the API or by accessing https://app.fastly.com/

# Lets get the VCLs for the version.
pretty-out "This versions uploaded vcls: "
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/vcl"

# Lets create a test vcl to see one.
pretty-out "Let's upload a test vcl (This uses X-URL-Form-Encoded data): "
curl -X POST  -H "$FASTLY_API_KEY" "$FASTLY_API_URL/vcl" \
-d 'name=test' \
--data-urlencode "content=$(cat fastly-boilerplate.vcl)"

# Now lets get that VCL.
pretty-out "Now lets check that: "
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/vcl/test"

# Lets update its name and content
curl -X PUT -H "$FASTLY_API_KEY" "$FASTLY_API_URL/vcl/test" \
-d 'name=tested' \
--data-urlencode "content=$(cat custom-503.vcl)"

# And lets see how this gets merged into the generated vcl.
pretty-out "Now lets make it the main vcl: "
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/vcl/tested/main"

# And now lets see the content of the vcl.
pretty-out "And now that with HTML highlighting: "
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/vcl/tested/content"

# And now the downloadable version.
pretty-out "The raw downloadable version: "
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/vcl/tested/download"

# And lets see how this gets merged into the generated vcl.
pretty-out "This merges with the rest of the configuration: "
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/generated_vcl"

# And lets see how this gets merged into the generated vcl. This time with formatted HTML
pretty-out "And now to see that with html formatting: "
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/generated_vcl/content"

# And lets clean it up.
pretty-out "Cleaning it up: "
curl -X DELETE -H "$FASTLY_API_KEY" "$FASTLY_API_URL/vcl/tested"

