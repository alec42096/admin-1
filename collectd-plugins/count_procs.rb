total_procs = 0
httpd_procs = 0
File.open(ARGV[0]).each do |line|
  #puts line
  total_procs+=1
  if line =~ /httpd/
	httpd_procs+=1
  end
end

puts "There were #{total_procs} processes, of which #{httpd_procs} were httpd"