require "httpclient"
require "syslog/logger"

# set up basic for requests
url = 'http://www.inde-test.jdade.me.uk/'
c = HTTPClient.new

# set up logging
results = {twos:0, threes:0, fours:0, fives:0, hits:0}
log = Syslog::Logger.new('monitor')

while true do

    start = Time.now
    r = c.get url
    if r.status >= 100 && r.status < 300
        results[:twos] += 1
    elsif r.status >= 300 && r.status < 400
        results[:threes] += 1
    elsif r.status >= 400 && r.status < 500
        results[:fours] += 1
    elsif r.status >= 500 && r.status < 600
        results[:fives] += 1
    end
    results[:hits] += 1 if /HIT/.match(r.headers['X-Cache'])
    log.info "2xx = "+results[:twos].to_s+", 3xx = "+results[:threes].to_s+", 4xx = "+results[:fours].to_s+", 5xx = "+results[:fives].to_s+", Hits = "+results[:hits].to_s
    sleep(Time.now + 0.5 - start)
end
