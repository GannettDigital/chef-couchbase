#
# Cookbook Name:: couchbase
# Provider:: node_directories
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
require 'English'

def couch_up(path, username, password)
  i = 0
  while i < 3
    cmd = Mixlib::ShellOut.new("#{path}/bin/couchbase-cli server-info -c 127.0.0.1:8091 -u #{username} -p #{password} > /dev/null")
    cmd.run_command
    ready = $CHILD_STATUS.success?
    return if ready == true
    i += 1
    sleep 10
  end
  Chef::Application.fatal!('Couchbase server has not come up within 30 seconds cannot continue')
end

action :add do
  couch_up(new_resource.install_path, new_resource.username, new_resource.password)

  if check_cluster(new_resource.username, new_resource.password) == false
    cmd = "#{new_resource.install_path}/bin/couchbase-cli node-init -c 127.0.0.1:8091 \
           -u #{new_resource.username} \
           -p #{new_resource.password} \
           --node-init-data-path=#{new_resource.database_path} \
           --node-init-index-path=#{new_resource.index_path}"
    execute 'node-init set data and index paths' do
      sensitive true
      command cmd
    end
  end
end
