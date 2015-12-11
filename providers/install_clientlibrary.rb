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

def set_debian_repo
  apt_repository 'couchbase' do
    url 'http://packages.couchbase.com/ubuntu'
    distrbution node['lsb']['codename']
    components['main']
    key 'http://packages/couchbase.com/ubuntu/couchbase.key'
  end
end

def rhel_version
  case node['platform_version'].split('.').first.to_i
  when 5
    return '5.5'
  when 6
    return '6.2'
  when 7
    return '7'
  else
    Chef::Log.error("Platform version #{node_version} is not supported by Couchbase C library")
  end
end

def set_rpm_repo
  version = rhel_version

  yum_repository 'couchbase' do
    name 'couchbase'
    description 'Couchbase package repository'
    url "http://packages.couchbase.com/rpm/#{version}/$basearch"
    gpgkey 'http://packages.couchbase.com/rpm/couchbase-rpm.key'
    action :add
  end
end

def install_libraries
  %w(libcouchbase2 libcouchbase-devel).each do |p|
    package p do
      action :install
    end
  end
end

action :install do
  case node['platform_family']
  when 'debian'
    set_debian_repo
  when 'rhel'
    set_rpm_repo
  else
    Chef::Log.error("Platform family #{node['platform_family']} not supported by Couchbase C library")
    return
  end

  install_libraries
end
