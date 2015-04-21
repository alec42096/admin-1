#! /bin/bash
#
# Stats.sh
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

# The rest of the commands assume you have either got the correct configuration
# version via the API or by accessing https://app.fastly.com/

START_TIME=$(date +%s)
END_TIME=$(($START_TIME-86400))

# Lets get the stats for the last day
pretty-out "Last day's stats: "
curl -X GET -H "$FASTLY_API_KEY" "$FASTLY_API_URL/stats/summary?start_time=$START_TIME&end_time=$END_TIME"

MONTH=""

pretty-out ""