#
# Cookbook Name:: couchbase
# Provider:: install_server
#
# Copyright 2015, GannettDigital
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

use_inline_resources

def build_rpm_name(version, edition)
  arch = node['kernel']['machine'] == 'x86_64' ? 'x86_64' : 'x86'
  if version < '3.0.0'
    return "couchbase-server-#{edition}_#{version}_#{arch}.rpm"
  else
    return "couchbase-server-#{edition}-#{version}-centos6.#{arch}.rpm"
  end
end

def build_deb_name(version, edition)
  arch = node['kernel']['machine'] == 'x86_64' ? 'amd64' : 'x86'
  if node['platform'] == 'ubuntu'
    return build_ubuntu_name(version, edition, arch)
  else
    if version < '3.0.0'
      Chef::Log.warn("Couchbase Server does not have a Debian release for #{version}")
    else
      return "couchbase-server-#{edition}_#{version}-debian7_#{arch}"
    end
  end
end

def build_ubuntu_name(version, edition, arch)
  if version < '3.0.0'
    return "couchbase-server-#{edition}_#{version}_{arch}.deb"
  else
    return "couchbase-server-#{edition}_#{version}-ubuntu12.04_#{arch}.deb"
  end
end

def build_windows_name(version, edition)
  arch = node['kernel']['machine'] == 'x86_64' ? 'amd64' : 'x86'
  if version < '3.0.1'
    Chef::Log.error("Couchbase Servers version #{version} is not available for Windows")
  end
  "couchbase-server-#{edition}_#{version}-windows_#{arch}.exe"
end

def get_file_name(version, edition)
  case node['platform']
  when 'debian', 'ubuntu'
    return build_deb_name(version, edition)
  when 'centos', 'redhat', 'scientific', 'amazon'
    return build_rpm_name(version, edition)
  when 'windows'
    return build_windows_name(version, edition)
  else
    Chef::Log.error("Couchbase server not supported on #{node['platform']}")
  end
end

def install_package(package)
  case node['platform']
  when 'debian', 'ubuntu'
    dpkg_package package
  when 'centos', 'redhat', 'scientific', 'amazon'
    rpm_package package
  when 'windows'
    install_windows(package)
  else
    Chef::Log.error('Not sure how we got here but there is now way to install the package')
  end
end

def install_windows(package)
  template "#{Chef::Config[:file_cache_path]}/setup.iss" do
    source 'setup.iss.erb'
    action :create
  end
  windows_package 'Couchbase Server' do
    source package
    options '/s'
    installer_type :custom
    action :install
  end
end

action :install do
  package_file = get_file_name(new_resource.version, new_resource.edition)
  url_base = "http://packages.couchbase.com/releases/#{new_resource.version}"

  package_full_url = "#{url_base}/#{package_file}"
  package_path = "#{Chef::Config[:file_cache_path]}/#{package_file}"

  Chef::Log.warn("package file is #{package_full_url}")

  remote_file package_path do
    source package_full_url
    action :create_if_missing
  end

  install_package(package_path)
end
