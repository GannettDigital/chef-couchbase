#
# Cookbook Name:: couchbase
# Provider:: cluster_init
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

action :init do
  return unless check_cluster(new_resource.username, new_resource.password) == false
  version = new_resource.version.split('.').first.to_i
  cmd = "#{new_resource.install_path}/bin/couchbase-cli cluster-init -c 127.0.0.1:8091 \
         -u #{new_resource.username} \
         -p #{new_resource.password} \
         --cluster-username=#{new_resource.username} \
         --cluster-password=#{new_resource.password} \
         --cluster-ramsize=#{new_resource.ramsize}"
  if version > 3
    cmd = "#{cmd} \
           --cluster-index-ramsize=#{new_resource.index_ramsize} \
           --services=#{new_resource.services}"
  end

  Chef::Log.warn("command is #{cmd}")
  execute 'cluster init to initialize server' do
    sensitive false
    command cmd
  end
end
