#!/usr/bin/env ruby

require 'rubygems'
require 'HTTPClient'

client = HTTPClient.new
log = File.open("/tmp/url-errors.txt", 'w')
statuses = Hash.new(0)
total_reqs = 0

('a'..'z').each do |char_1|
  ('a'..'z').each do |char_2|
    ('a'..'z').each do |char_3|
      url = "http://"+char_1+char_2+char_3+".zportal.nl/"
      res = client.get(url)
      statuses[res.status] += 1
      total_reqs +=1
      print("#{url} => #{res.status}\tstatuses:")
      statuses.each do |status, count|
        print(" #{status}: #{count} #{((count / total_reqs)*100)}%")
      end
      print("\n")
      if res.status > 399
        log.puts("url: #{url} => #{res.status}")
      end
    end
  end
end

log.close
