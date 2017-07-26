#!/usr/bin/env ruby
#
# Terminate running servers if they have been alive > server_limit_hours
# and the description doesn't contain safeword.

require 'rubygems'
require 'RightAPI/RightAPI'
require 'AWS'
require 'crack'
require 'time'
require 'pp'
#require 'rest-client'
#require 'AuthHMAC'

# Rightscale Credentials
user = ''
account = ''
password = ''

#AWS credentials
aws_user = '068S8XY7J4FFK4111Y02'
aws_pass = 'XxwAji4bPO5S8Tqb3U+MIq1B6Q0ozWLhoJiuXdGn'

ec2 = AWS::EC2::Base.new(:access_key_id => aws_user, :secret_access_key => aws_pass)

ec2_instances = {}

ec2.describe_instances.reservationSet.item.each do | rSetItem |
  rSetItem.instancesSet.item.each do |iSetItem|
    ec2_instances[iSetItem.instanceId] = iSetItem.instanceState.name
  end
end

puts ec2_instances.size
ec2_instances.keys.each do |key|
  if ec2_instances[key] == 'running'
    puts "#{key} => #{ec2_instances[key]}"
  else
    ec2_instances.delete(key)
  end
end
puts ec2_instances.size

api = RightAPI.new
api.log = true
api.login(:username => user, :password => password, :account => account)

rs_instances = {}
output = api.send("servers")
xml = Crack::XML.parse(output)
xml["servers"].each do |svr|
  if svr['state'] == 'operational' ||
     svr['state'] == 'booting' ||
     svr['state'] == 'stranded'
        puts "nickname: #{svr['nickname']}"
        puts "state:    #{svr['state']}"
        svr['href'] =~ /\/(\d+)$/
        id = $1
        tmpxml = Crack::XML.parse( api.send("servers/#{id}/settings"))
        puts "aws id:    #{tmpxml['settings']['aws_id']}"
	rs_instances[tmpxml['settings']['aws_id']] = { 'nickname' => tmpxml['settings']['nickname'], 'href' => svr['href']}
  end
end

# puts rs_instances.to_s
rs_instances.keys.each do | id |
  if ! ec2_instances.has_key id
    puts "Found unknown instance: #{id}"
  end
end
