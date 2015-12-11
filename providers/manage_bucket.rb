#
# Cookbook Name:: couchbase
# Provider:: manage_bucket
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

def base_command(action)
  "#{new_resource.install_path}/bin/couchbase-cli #{action} -c 127.0.0.1:8091 \
   -u #{new_resource.username} \
   -p #{new_resource.password} \
   --bucket=#{new_resource.bucket_name}"
end

def set_bucket_flush
  return 0 unless new_resource.bucket_flush
  1
end

def create_bucket_options
  flush = set_bucket_flush
  "--bucket-eviction-policy=#{new_resource.bucket_eviction} \
   --bucket-type=#{new_resource.bucket_type} --bucket-port=#{new_resource.bucket_port} \
   --bucket-ramsize=#{new_resource.bucket_ramsize} --bucket-priority=#{new_resource.bucket_priority} \
   --bucket-replica=#{new_resource.bucket_replicas} --enable-flush=#{flush}"
end

def create_bucket_cmd(command)
  base = base_command(command)
  options = create_bucket_options
  unless new_resource.bucket_password.nil?
    options = "#{options} --bucket-password=#{new_resource.bucket_password}"
  end

  "#{base} #{options}"
end

def delete_bucket_cmd
  "#{new_resource.install_path}/bin/couchbase-cli bucket-delete -c 127.0.0.1:8091 \
   -u #{new_resource.username} \
   -p #{new_resource.password} \
   --bucket=#{new_resource.bucket_name}"
end

def cmd_execute(cmd, command)
  execute "executing #{command}" do
    sensitive false
    command cmd
  end
end

action :edit do
  command = 'bucket-edit'
  command = 'bucket-create' unless check_bucket(new_resource.username, new_resource.password, new_resource.bucket_name) == true

  cmd = create_bucket_cmd(command)

  cmd_execute(cmd, command)
end

action :create do
  command = 'bucket-create'
  command = 'bucket-edit' unless check_bucket(new_resource.username, new_resource.password, new_resource.bucket_name) == false

  cmd = create_bucket_cmd(command)

  cmd_execute(cmd, command)
end

action :delete do
  return unless check_bucket(new_resource.username, new_resource.password, new_resource.bucket_name) == true
  cmd = delete_bucket_cmd

  cmd_execute(cmd, 'bucket-delete')
end
