curl -v -H 'Content-Type: application/json' -d '{"auth":{"RAX-KSKEY:apiKeyCredentials":{"username": "insert-username", "apiKey": "xxxxxxxxxx"}}}' 'https://identity.api.rackspacecloud.com/v2.0/tokens'

curl -H 'Accept: application/json' -X GET 'https://storage101.ord1.clouddrive.com/v1/id_xxxxxxxxxx_id/logging_varnish?format=json' -H 'X-Auth-Token: xxxxxxxxxxx'

curl -H 'Accept: application/json' -H "Content-Type: text/plain" -X PUT 'https://storage101.ord1.clouddrive.com/v1/id_xxxxxxxxxx_id/logging_varnish/test_file.txt' -H 'X-Auth-Token: xxxxxxxxxxxxxxx' -H "Content-Length: 0"
