#!/usr/bin/ruby

module FreeIIS
  require 'net/http'

  def domain_free?(domain_name, top_level = "se")
    uri = URI(URI.encode("http://free.iis.se/free?q=#{domain_name.strip}.#{top_level}"))
    ret = Net::HTTP.get(uri)
    return ret.include? "free"
  end

end


include FreeIIS
request_counter = 0
time = Time.now

ARGF.each_line do |e|
  puts e if domain_free? e
  request_counter += 1

  if request_counter < 33 && (Time.now - time)*1000 > 1000
    sleep(Time.now - time)
    time = Time.now
  elsif request_counter >= 33
    request_counter = 0
    time = Time.now
  end
end
