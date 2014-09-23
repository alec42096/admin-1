#! /usr/bin/env ruby

# s3-bucket-empty
# Enumerates over an S3 bucket and deletes each object / file found within.
#

require 'AWS-SDK'
require '~/.aws/keys'

# Set up the AWS access credentials and set some defaults.
AWS.config({:access_key_id => ACCESS_KEY_ID, :secret_access_key => SECRET_ACCESS_KEY, :region => 'eu-west-1', :use_ssl => :true, })

s3 = AWS::S3.new()

s3.buckets.each do |bucket|
	puts bucket.name
end

s3.buckets['jdade-htlogs'].objects.each do |obj|
	p "Deleting #{obj.key}"
	p "..."
	p "#{obj.delete}"
end