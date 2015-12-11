require 'net/http'
require 'json'

# I know this is a bit of a mess to begin with
# This whole thing needs to be rewritten as a class
# rubocop:disable Metrics/MethodLength
def get_node_json(ipaddress, username, password)
  uri = URI("http://#{ipaddress}:8091/pools/default")
  check = Net::HTTP::Get.new(uri)
  check.basic_auth username, password
  begin
    res = Net::HTTP.start(uri.hostname, uri.port, :open_timeout => 10) { |http| http.request(check) }
    return unless res.code == '200'
    body = JSON.parse(res.body)
    return body
  rescue # => e
    return
  end
end

# Return true if node is part of cluster.
# Determined by nodes having entries in json.
# rubocop:enable Metrics/MethodLength
def found_cluster(jvalue)
  if jvalue['nodes'].length > 1
    return true
  else
    return false
  end
end

# check if target node is not in a cluster. This is a negative so if
# node is found in cluster return false.
def not_in_cluster(jvalue, selfipaddress)
  hostcheck = selfipaddress + ':8091'
  jvalue['nodes'].each do |ncheck|
    return false if ncheck['hostname'] == hostcheck
  end
  true
end

# build a hash of known nodes including port.
# Default prefix needs to be added here to make things easier.
# Default prefix is ns_1@
def get_known_nodes_from_json(jvalue)
  prefix = 'ns_1@'
  separator = ','
  known_nodes = ''
  jvalue['nodes'].each do |known|
    known_nodes = known_nodes + separator + prefix + known['hostname'].sub(/:8091/, '')
  end
  known_nodes
end

# get the timestamp of the node from the server info json.
def get_timestamp(jvalue)
  timestamp = ''
  jvalue['nodes'].each do |cnode|
    ts = Time.now.to_i
    timestamp = ts - cnode['uptime'].to_i
  end
  timestamp
end

# build nested hash of:
# knownodes - nodes that are known to the cluster for reblance purposes
# nodetojoin - ip address of the "master" node to join the server to.
def join_to_cluster(jvalue, selfipaddress, clusterip)
  return unless not_in_cluster(jvalue, selfipaddress)
  joinarray = {}
  clusternodes = get_known_nodes_from_json(jvalue)
  joinarray['knownnodes'] = "ns_1@#{selfipaddress}" + clusternodes
  joinarray['nodetojoin'] = clusterip
  joinarray
end

# iterate through nodes in searchhash, get json and check if node is in a cluster.
# if node in cluster return that node otherwise add to hash of nodes no in a cluster.
# create a nested hash where the ip address is the key and the value is the up time.
# rubocop:disable MethodLength, Next
def probe_nodes(searchhash, selfipaddress, username, password, probe = {})
  probe['joinhash'] = {}
  searchhash.each do |node|
    info = get_node_json(node['ipaddress'], username, password)
    if info
      if found_cluster(info)
        probe['joinarray'] = join_to_cluster(info, selfipaddress, node['ipaddress'])
      elsif node['ipaddress'] != selfipaddress
        ip = node['ipaddress']
        probe['joinhash'][ip] = get_timestamp(info)
      end
    end
  end
  probe
end

# loop through 3 times to make sure at least one node in the cluster is up.
# If we do not get a hit in 30 seconds something else is wrong.
# rubocop:enable MethodLength, Next
def loopit(searchhash, selfipaddress, username, password)
  i = 0
  while i < 3
    probearray = probe_nodes(searchhash, selfipaddress, username, password)
    if probearray
      return probearray['joinarray'] if probearray['joinarray']
      return pickit(probearray['joinhash'], selfipaddress) unless probearray['joinhash'].empty?
    end
    i += 1
    sleep 10
  end
end

# this sorts the joinhash hash by values which are time stamps where the largest timestamp
# is the oldest node and that is the node we want to set as the master node.
def pickit(joinhash, selfipaddress)
  joinarray = {}
  pick = joinhash.sort.reverse.pop
  joinarray['nodetojoin'] = pick[0]
  joinarray['knownnodes'] = 'ns_1@' + selfipaddress + ',ns_1@' + joinarray['nodetojoin']
  joinarray
end

def node_to_join(searchhash, selfipaddress, username, password)
  joinarray = loopit(searchhash, selfipaddress, username, password)
  joinarray
end

# target=node_to_join(cluster,selfipaddress,username,password)
# print "goning to join #{target}"
