#
# Fastly Magento 2 Purge requestor
#
# Takes a URL and a service ID. Sends a purge for a url to Fastly with the necessary headers.
#

# token is <expiration>_<signature>
# signature is sha-1 key signed string
# Key: service ID
# String: <url path><expiration> where url path strips query paramaters

# Store the purging token
$X_Purge_Token = "";
$url = "";
$service = "";

if (count($ARGV) < 2 && count($ARGV) > 3) {
    echo("Incorrect number of arguments.");
    print_help();
    exit(1);
}

# Process arguments
foreach($ARGV as $arg) {
    if($arg)
}

exit(0);

function print_help(){
    echo("Usage: fastly-purge --service=id --url=an_url");
    echo("")
}

