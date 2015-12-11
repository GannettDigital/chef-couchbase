# rubocop:disable Metrics/LineLength
default['couchbase']['server']['edition'] = 'community'
default['couchbase']['server']['version'] = '4.0.0'

default['couchbase']['server']['username'] = 'Administrator'
default['couchbase']['server']['password'] = 'password'

# default['couchbase']['server']['memory_quota_mb'] = Couchbase::MaxMemoryQuotaCalculator.from_node(node).in_megabytes
default['couchbase']['server']['memory_quota_mb'] = 4000
default['couchbase']['server']['index_memory_quota_mb'] = 256
default['couchbase']['server']['services'] = 'data,query,index'
default['couchbase']['server']['services_api'] = 'kv,n1ql,index'

default['couchbase']['server']['port'] = 8091

case node['platform']
when 'debian'
  package_machine = node['kernel']['machine'] == 'x86_64' ? 'amd64' : 'x86'
  if node['couchbase']['server']['version'] < '3.0.0'
    Chef::Log.error("Couchbase Server does not have a Debian release for #{node['couchbase']['server']['version']}")
  else
    default['couchbase']['server']['package_file'] = "couchbase-server-#{node['couchbase']['server']['edition']}_#{node['couchbase']['server']['version']}-debian7_#{package_machine}.deb"
  end
when 'centos', 'redhat', 'amazon', 'scientific'
  package_machine = node['kernel']['machine'] == 'x86_64' ? 'x86_64' : 'x86'
  if node['couchbase']['server']['version'] < '3.0.0'
    default['couchbase']['server']['package_file'] = "couchbase-server-#{node['couchbase']['server']['edition']}_#{node['couchbase']['server']['version']}_#{package_machine}.rpm"
  else
    default['couchbase']['server']['package_file'] = "couchbase-server-#{node['couchbase']['server']['edition']}-#{node['couchbase']['server']['version']}-centos6.#{package_machine}.rpm"
  end
when 'ubuntu'
  package_machine = node['kernel']['machine'] == 'x86_64' ? 'amd64' : 'x86'
  if node['couchbase']['server']['version'] < '3.0.0'
    default['couchbase']['server']['package_file'] = "couchbase-server-#{node['couchbase']['server']['edition']}_#{node['couchbase']['server']['version']}_#{package_machine}.deb"
  else
    default['couchbase']['server']['package_file'] = "couchbase-server-#{node['couchbase']['server']['edition']}_#{node['couchbase']['server']['version']}-ubuntu12.04_#{package_machine}.deb"
  end
when 'windows'
  if node['kernel']['machine'] != 'x86_64'
    Chef::Log.error('Couchbase Server on Windows must be installed on a 64-bit machine')
  else
    default['couchbase']['server']['version'] = '3.0.0-beta'
    default['couchbase']['server']['package_file'] = "couchbase-server_#{node['couchbase']['server']['version']}-beta-windows_amd64.exe"
  end
else
  Chef::Log.error("Couchbase Server is not supported on #{node['platform_family']}")
end

default['couchbase']['server']['package_base_url'] = "http://packages.couchbase.com/releases/#{node['couchbase']['server']['version']}"
default['couchbase']['server']['package_full_url'] = "#{node['couchbase']['server']['package_base_url']}/#{node['couchbase']['server']['package_file']}"

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

default['couchbase']['server']['source']['bucket'] = 'default'
default['couchbase']['server']['remote']['bucket'] = 'default'
default['couchbase']['server']['setup_cluster'] = false
default['couchbase']['server']['run_cluster_init'] = true
default['couchbase']['server']['cluster_name'] = 'west_cluster'
default['couchbase']['server']['remote_cluster'] = 'remote_cluster'
default['couchbase']['server']['cluster_master'] = nil
