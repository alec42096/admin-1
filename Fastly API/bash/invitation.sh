#! /bin/bash
#
# Invites.sh
# =================
# This script contains examples of using the Fastly API to manage invitations.
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

# session authentication cookie login. This only works if two factor authentication is disabled.
curl -c fastly-cookies -X POST -H "Content-type: application/json" "https://api.fastly.com/login" -d \
"{\"user\":\"$FASTLY_USERNAME\",\"password\":\"$FASTLY_PASSWORD\"}"

# Set up a variable to save re-typing the whole lot for each API call.
FASTLY_API_URL="https://api.fastly.com/service/$FASTLY_SERVICE_ID"
VERSION="2"
FASTLY_API_URL="$FASTLY_API_URL/version/$VERSION"

# The rest of the commands assume you have either got the correct configuration
# version via the API or by accessing https://app.fastly.com/

# Lets get a list of all invitations sent
pretty-out "Listing all invitations"
curl -X GET -b fastly-cookies "https://api.fastly.com/invitation"

# Now lets send a nice new invite.
pretty-out "Inviting a test user with limited access"
curl -X POST -b fastly-cookies -H "Content-type: application/json" \
	"https://api.fastly.com/invitation" -d \
"{
	\"email\":\"$1\",
	\"role\":\"user\"
}"

# Now lets list that new invitation
pretty-out "Listing all invitations, again"
curl -X GET -b fastly-cookies "https://api.fastly.com/invitation"

# Now lets cancel that test invite!
pretty-out "Cancelling invite for $1"
ID=`curl -X GET -b fastly-cookies "https://api.fastly.com/invitation" | sed -e "s/.*$1.*\"id\":\"\([A-Za-z0-9][A-Za-z0-9]*\)\".*/\1/"`
curl -X PUT -b fastly-cookies "https://api.fastly.com/invitation/$ID/cancel"