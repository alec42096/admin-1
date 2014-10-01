<?php

# Create a curl object for purging.
$purger = curl_init();
curl_setopt($purger, CURLOPT_CUSTOMREQUEST, "PURGE");
curl_setopt($purger, CURLOPT_RETURNTRANSFER, 1);

# Populate an array of URLs to purge. This should be overridden for your own use.
$urls = array("http://gibber.mcflibber.not", "http://gibber.mcflibber.not/", "http://gibber.mcflibber.not/list-all-headers.php");

# Loop over the URLs, updating the URL to purge on each iteration
foreach ($urls AS $url)
{
        # $url = Varnish_Config::$module_settings['fastly_url'] . "purge/" . preg_replace("/^http(s?):\/\//", '', $url);
        curl_setopt($purger, CURLOPT_URL, $url);
        curl_exec($purger);
        $code = curl_getinfo($purger, CURLINFO_HTTP_CODE);
        $content = curl_multi_getcontent($purger);
        $results[] = "{$url} : {$code} : {$content}\r\n";
}

# We're done with the purging object now so let's get rid of it.
curl_close($purger);

# For logging / testing lets shove those results out.
foreach ($results AS $res)
{
        echo "$res\n";
}

?>
