#
# Cookbook Name:: couchbase
# Recipe:: xdcr
#

# src_cluster_name = node['couchbase']['server']['cluster_name']
remote_cluster_name = node['couchbase']['server']['remote_cluster']

# if Chef::Config[:solo]
#  Chef::Log.warn("This recipe uses search, chef solo does not support search.")
# else
#   src_cluster = search(:node, "couchbase:#{src_cluster_name}")
# end

# delete this line src_node = src_cluster[0]["ipaddress"]

if Chef::Config[:solo]
  Chef::Log.warn("This recipe uses search, chef solo does not support search.")
else
  remote_cluster = search(:node, "couchbase:#{remote_cluster_name}")
end
remote_node = remote_cluster[0]["ipaddress"]

username = node['couchbase']['server']['username']
password = node['couchbase']['server']['password']

Chef::Log.info "Get uuid information of the remote cluster"
# foodcritic complained about this, not sure this is proper but it has not broke my testing yet.
# s_uuid = `curl 'http://#{username}:#{password}@#{remote_node}:8091/pools' | \
# python -mjson.tool |sed -e 's/[","]/''/g' | awk -F "uuid: " '{print $2}'`
s_uuid = Mixlib::ShellOut.new("curl 'http://#{username}:#{password}@#{remote_node}:8091/pools' | \
  python -mjson.tool |sed -e 's/[\",\"]/''/g' | \
  awk -F \"uuid: \" '{print $2}'")
s_uuid run_command
s_uuid error!

uuid = s_uuid.strip

xdcr_ref "Create XDCR Replication reference  " do
  uuid uuid
  remote_name "remote_link"
  remote_node remote_node
  username node['couchbase']['server']['username']
  password node['couchbase']['server']['password']
end

xdcr_start "Setting up replication from bucket default to default" do
  uuid uuid
  to_cluster "remote_link"
  from_bucket "default"
  to_bucket "default"
  replication_type "continuous"
  username node['couchbase']['server']['username']
  password node['couchbase']['server']['password']
end
