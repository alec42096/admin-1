#!/usr/bin/env ruby

require 'fastly'

api_key='945c8ca9576229cc4ccedb2588aaf952'
id='2jZC3AxBXYlp3AfC6SLuX3'

fastly = Fastly.new(api_key: api_key)

service = fastly.search_services(id: id)

version = service.version

version = version.clone

version.upload_main_vcl('esi-example', File.read('/Users/jonthandade/Code/admin/vcl/esi-enable.vcl'))

version.activate! if version.validate