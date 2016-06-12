require "httpclient"
require "syslog/logger"

// set up basic for requests
url = 'http://www.inde-test.jdade.me.uk/'
c = HTTPClient.new

// set up logging
results = ['200':0, '300':0, '400':0, '500':0, hits:0]
log = Syslog.logger.new('monitoring')

while true do

    start = Time.now
    r = c.get url
    if r.status >= 100 && r.status < 300
        results[:'200'] += 1
    elsif r.status >= 300 && r.status < 400
        results[:'300'] += 1
    elsif r.status >= 400 && r.status < 500
        results[:'400'] += 1
    end
    results[:hits] += 1 if /HIT/.match(r.headers['X-Cache'])
    log.info "2xx = "+results[:'200']+", 3xx = "+results[:'300']+", 4xx = "+results[:'400']+", 5xx = "+results[:'500']
    Thread.sleep(Time.now + 0.5 - start)
end