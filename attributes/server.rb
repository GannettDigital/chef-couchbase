default['couchbase']['server']['edition'] = 'community'
default['couchbase']['server']['version'] = '4.0.0'

default['couchbase']['server']['username'] = 'Administrator'
default['couchbase']['server']['password'] = 'password'

default['couchbase']['server']['index_memory_quota_mb'] = 256
default['couchbase']['server']['memory_quota_mb'] = Couchbase::MaxMemoryQuotaCalculator.from_node(node).in_megabytes(node)
#default['couchbase']['server']['memory_quota_mb'] = 4000

default['couchbase']['server']['services'] = 'data,query,index'
default['couchbase']['server']['services_api'] = 'kv,n1ql,index'

default['couchbase']['server']['port'] = 8091

case node['platform_family']
when 'windows'
  default['couchbase']['server']['service_name'] = 'CouchbaseServer'
  default['couchbase']['server']['install_dir'] = File.join('C:', 'Program Files', 'Couchbase', 'Server')
else
  default['couchbase']['server']['service_name'] = 'couchbase-server'
  default['couchbase']['server']['install_dir'] = '/opt/couchbase'
end

default['couchbase']['server']['database_path'] = File.join(node['couchbase']['server']['install_dir'], 'var', 'lib', 'couchbase', 'data')
default['couchbase']['server']['index_path'] = File.join(node['couchbase']['server']['install_dir'], 'var', 'lib', 'couchbase', 'data')
default['couchbase']['server']['log_dir'] = File.join(node['couchbase']['server']['install_dir'], 'var', 'lib', 'couchbase', 'logs')

# default['couchbase']['server']['setup_cluster'] = false
default['couchbase']['server']['run_cluster_init'] = true
# default['couchbase']['server']['cluster_name'] = 'west_cluster'
# default['couchbase']['server']['remote_cluster'] = 'remote_cluster'
# default['couchbase']['server']['cluster_master'] = nil
