# Ruby find certificate
#
# Can be used as a library for various SSL functions

require 'openssl' or raise "Could not import TLS library"
require 'socket' or raise "Could not load sockets library"
require 'pry' or raise "Could not load pry debugging library"
require 'getoptlong' or raise "Could not load shell option parser"

BASEURL = "global-ssl.fastly.net"

def check_cert(cert_name, name)
  cert = fetch_cert(cert_name)
  domains = san_domains(cert)
  if domains.include?(name)
    puts "#{name} found on #{cert_name}"
  else
    # check wildcards
    name_parts = name.split(/\./).reverse
    domains.each do |domain|
      domain_parts = domain.split(/\./).reverse
      next if domain_parts.last != "*"
      next if name_parts.length != domain_parts.length
        if name_parts.slice(0..-2) == domain_parts.slice(0..-2)
          puts "Wildcard match found: #{domain_parts.reverse.join('.')} for #{name} on #{cert_name}"
        end
    end
  end
  # binding.pry
end

def build_url(host, base=BASEURL)
  "#{host}.#{base}"
end

def fetch_cert(name)
  begin
    tcp_client = TCPSocket.new name, 443
    ssl_client = OpenSSL::SSL::SSLSocket.new tcp_client
    ssl_client.connect
    cert = OpenSSL::X509::Certificate.new(ssl_client.peer_cert)
    return cert
  rescue SocketError
    print "Error retrieving certificate #{name}"
  ensure
    ssl_client.sysclose
    tcp_client.close
  end
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

("a".."l").each do |cert|
  #puts "Cert: #{cert}"
    threads[cert] = Thread.new {
    url = build_url(cert)
    Thread.current[:res] = check_cert(url, name)
  }
end

threads.keys.each do |cert|
  t = threads[cert].join
  #puts t[:res]
end
