require "HTTPClient"

def purge(api_key, s_key, service_id)
  res = HTTPClient.post("https://api.fastly.com/service/#{service_id}/purge/#{s_key}","",{"Fastly-Key" => $api_key})
  logger.debug("Purge failed: #{s_key} => #{res.reason_phrase}") if res.status != 200
end

purge( ENV['FASTLY_KEY'], "test_key", ENV['FASTLY_SERVICE_ID'])
