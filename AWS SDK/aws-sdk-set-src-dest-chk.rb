#!/usr/bin/env ruby

require 'rubygems'
require 'aws-sdk'
require '/var/spool/cloud/meta-data.rb'

if ENV['ENABLE_SOURCE_CHECKING'].downcase == 'true'
  check = true
elsif ENV['ENABLE_SOURCE_CHECKING'].downcase == 'false'
  check = false
else
  printf(STDERR, "Input \'ENABLE_SOURCE_CHECKING\' has an invalid value.\n")
  exit 1 
end
  

cloud = AWS::EC2.new(
	{
		:access_key_id => "#{ENV['ACCESS_KEY_ID']}",
		:secret_access_key => "#{ENV['SECRET_ACCESS_KEY']}",
		:region => (ENV['EC2_LOCAL_HOSTNAME']).gsub(/.*\.(.*)\.compute.*/, '\1')
	}
)

me = cloud.instances["#{ENV['EC2_INSTANCE_ID']}"]
puts "Instance #{ENV['EC2_INSTANCE_ID']} exists: #{me.exists?}"

# printf("Checking source / destination checking: ")
if check == me.source_dest_check?
  puts "Source / destination checking already correctly set"
else
  me.source_dest_check = check
end