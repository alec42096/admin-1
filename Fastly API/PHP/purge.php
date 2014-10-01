<?php

$purger = curl_init();
$urls = array("http://gibber.mcflibber.not", "http://gibber.mcflibber.not/", "http://gibber.mcflibber.not/list-all-headers.php");
foreach ($urls AS $url)
{
        # $url = Varnish_Config::$module_settings['fastly_url'] . "purge/" . preg_replace("/^http(s?):\/\//", '', $url);
        curl_setopt($purger, CURLOPT_URL, $url);
        curl_setopt($purger, CURLOPT_CUSTOMREQUEST, "PURGE");
        $content = curl_exec($purger);
        $code = curl_getinfo($purger, CURLINFO_HTTP_CODE);
        $results[] = "{$url} : {$code} : {$content}\r\n";
}

curl_close($purger);

foreach ($results AS $res)
{
        echo "$res\n";
}

?>
