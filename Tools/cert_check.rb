# Ruby find certificate
#
# Can be used as a library for various SSL functions

require "openssl" or raise "Could not import TLS library"
require "socket" or raise "Could not load sockets library"
require 'pry' or raise "Could not load pry debugging library"
require 'getoptlong' or raise "Could not load shell option parser"

BASEURL = "global-ssl.fastly.net"

def check_cert(cert_name, name)
  cert = fetch_cert(cert_name)
  domains = san_domains(cert)
  if domains.include?(name)
    p "#{name} found on #{cert_name}"
  end
  #binding.pry
end

def build_url(host, base=BASEURL)
  "#{host}.#{base}"
end

def fetch_cert(name) 
  tcp_client = TCPSocket.new name, 443
  ssl_client = OpenSSL::SSL::SSLSocket.new tcp_client
  ssl_client.connect
  cert = OpenSSL::X509::Certificate.new(ssl_client.peer_cert)
  ssl_client.sysclose
  tcp_client.close
  return cert
end

def san_domains(cert)
  ext_list = Array.new()
  cert.extensions.each do |ext|
    ext = ext.to_h
    if ext["oid"] == "subjectAltName"
      ext_list = ext["value"].split(",").map { |name|
        name.sub("DNS:", "").lstrip
      }
    end
  end
  return ext_list
end

name = ARGV[0]
threads = Hash.new()

("a".."j").each do |cert|
  puts "Cert: #{cert}"
    threads[cert] = Thread.new {
    url = build_url(cert)
    Thread.current[:res] = check_cert(url, name)
  }
end

threads.keys.each do |cert|
  t = threads[cert].join
  #puts t[:res]
end
 