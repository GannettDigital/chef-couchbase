#
# Cookbook Name:: couchbase
# Recipe:: setup_cluster
#

# cluster_name = node["cluster_name"]
cluster_name = node['couchbase']['server']['cluster_name']
# selfipaddress = ""
# known_nodes=prefix+self.node["ipaddress"]

# selfipaddress = node['ipaddress'] if node["ipaddress"] != selfipaddress
selfipaddress = node['ipaddress']

# for vagrant testing set and attribute vagrant = true in your role or Vagrant file.
if Chef::Config[:solo] && !node['vagrant']
  Chef::Log.warn("This recipe uses search and Chef solo does not support search.")
else
  cluster = search(:node, "role:#{cluster_name}")
end

unless cluster.empty?
  target = node_to_join(cluster, selfipaddress, node['couchbase']['server']['username'], node['couchbase']['server']['password'])
end

if target
  add_node cluster_name do
    hostname node["ipaddress"]
    username node['couchbase']['server']['username']
    password node['couchbase']['server']['password']
    clusterip target['nodetojoin']
  end
  ejectednodes = ""
  cluster_rebal "Rebalance-In Nodes to form a cluster  " do
    ejected_nodes ejectednodes
    known_nodes target['knownnodes']
    username node['couchbase']['server']['username']
    password node['couchbase']['server']['password']
    clusterip target['nodetojoin']
  end
end

ruby_block "wait for rebalance completion " do
  block do
    sleep 5
  end
end

# couchbase_bucket "#{cluster_name}" do
#  memory_quota_mb 100

#  username node['couchbase']['server']['username']
#  password node['couchbase']['server']['password']
# end
