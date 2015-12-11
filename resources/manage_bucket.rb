#
# Cookbook Name:: couchbase
# Resource:: manage_bucket
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

actions :create, :edit, :delete

attribute :bucket_name, :kind_of => String, :name_attribute => true
attribute :bucket_type, :kind_of => String, :default => 'couchbase'
attribute :bucket_ramsize, :kind_of => Integer
attribute :bucket_replicas, :kind_of => Integer, :default => '1'
attribute :bucket_priority, :kind_of => String, :default => 'high'
attribute :bucket_password, :kind_of => String, :default => nil
attribute :bucket_eviction, :kind_of => String, :default => 'valueOnly'
attribute :bucket_port, :kind_of => Integer, :default => '11211'
attribute :bucket_flush, :kind_of => [TrueClass, FalseClass], :default => false
attribute :bucket_index_replica, :kind_of => [TrueClass, FalseClass], :default => false
attribute :bucket_enable_priority, :kind_of => String, :default => 'low'
attribute :install_path, :kind_of => String, :default => '/opt/couchbase'
attribute :username, :kind_of => String, :default => 'Administrator'
attribute :password, :kind_of => String, :default => 'password'

def initialize(*args)
  super
  @action = :create
end
