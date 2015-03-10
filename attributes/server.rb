# rubocop:disable Metrics/LineLength
default['couchbase']['server']['edition'] = "community"
default['couchbase']['server']['version'] = "3.0.1"

default['couchbase']['server']['username'] = "Administrator"
default['couchbase']['server']['password'] = "password"

default['couchbase']['server']['memory_quota_mb'] = 4000
# default['couchbase']['server']['memory_quota_mb'] = Couchbase::MaxMemoryQuotaCalculator.from_node(node).in_megabytes

# only supports version 3.0.0 and higher due to file name changes for package_file
case node['platform']
when "debian"
  package_machine = node['kernel']['machine'] == "x86_64" ? "amd64" : "x86"
  default['couchbase']['server']['package_file'] = "couchbase-server-#{node['couchbase']['server']['edition']}_#{node['couchbase']['server']['version']}-debian7_#{package_machine}.deb"
when "centos", "redhat", "amazon", "scientific"
  package_machine = node['kernel']['machine'] == "x86_64" ? "x86_64" : "x86"
  default['couchbase']['server']['package_file'] = "couchbase-server-#{node['couchbase']['server']['edition']}-#{node['couchbase']['server']['version']}-centos6.#{package_machine}.rpm"
when "ubuntu"
  package_machine = node['kernel']['machine'] == "x86_64" ? "amd64" : "x86"
  default['couchbase']['server']['package_file'] = "couchbase-server-#{node['couchbase']['server']['edition']}_#{node['couchbase']['server']['version']}-ubuntu12.04_#{package_machine}.deb"
when "windows"
  if node['kernel']['machine'] != 'x86_64'
    Chef::Log.error("Couchbase Server on Windows must be installed on a 64-bit machine")
  else
    default['couchbase']['server']['package_file'] = "couchbase-server_#{node['couchbase']['server']['version']}-windows_amd64.exe"
  end
else
  Chef::Log.error("Couchbase Server is not supported on #{node['platform_family']}")
end

default['couchbase']['server']['package_base_url'] = "http://packages.couchbase.com/releases/#{node['couchbase']['server']['version']}"
default['couchbase']['server']['package_full_url'] = "#{node['couchbase']['server']['package_base_url']}/#{node['couchbase']['server']['package_file']}"

case node['platform_family']
when "windows"
  default['couchbase']['server']['install_dir'] = "C:\\Program Files\\Couchbase\\Server\\"
  default['couchbase']['server']['database_path'] = "#{node['couchbase']['server']['install_dir']}\var\lib\couchbase\data"
  default['couchbase']['server']['log_dir'] = "#{node['couchbase']['server']['install_dir']}\var\lib\couchbase\logs"
else
  default['couchbase']['server']['install_dir'] = "/opt/couchbase"
  default['couchbase']['server']['database_path'] = "#{node['couchbase']['server']['install_dir']}/var/lib/couchbase/data"
  default['couchbase']['server']['log_dir'] = "#{node['couchbase']['server']['install_dir']}/var/lib/couchbase/logs"
end

default['couchbase']['server']['source']['bucket'] = "default"
default['couchbase']['server']['remote']['bucket'] = "default"
default['couchbase']['server']['cluster_name'] = "west_cluster"
default['couchbase']['server']['remote_cluster'] = "remote_cluster"
