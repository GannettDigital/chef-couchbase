def check_cluster(username, password)
  uri = URI('http://localhost:8091/pools/default')
  check = Net::HTTP::Get.new(uri)
  check.basic_auth username, password
  res = Net::HTTP.start(uri.hostname, uri.port, :open_timeout => 10) { |http| http.request(check) }
  if res.code == '200'
    return true
  else
    return false
  end
end

def check_bucket(username, password, bucket)
  uri = URI("http://localhost:8091/pools/default/buckets/#{bucket}")
  check = Net::HTTP::Get.new(uri)
  check.basic_auth username, password
  res = Net::HTTP.start(uri.hostname, uri.port, :open_timeout => 10) { |http| http.request(check) }
  Chef::Log.warn("res code is #{res.code}")
  if res.code == '200'
    return true
  else
    return false
  end
end
