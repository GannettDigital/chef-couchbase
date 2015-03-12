require "chef/provider"
require File.join(File.dirname(__FILE__), "client")
require File.join(File.dirname(__FILE__), "pool_data")

class Chef
  class Provider
    class CouchbasePool < Provider
      include Couchbase::Client
      include Couchbase::PoolData

      def load_current_resource
        @current_resource = Resource::CouchbasePool.new @new_resource.name
        @current_resource.pool @new_resource.pool
        # @current_resource.exists !!pool_data
        @current_resource.exists true if pool_data
        @current_resource.memory_quota_mb pool_memory_quota_mb if @current_resource.exists
      end

      def action_modify_if_existing
        # unless @current_resource.exists
        return unless @current_resource.exists
        post "/pools/#{@new_resource.pool}", "memoryQuota" => @new_resource.memory_quota_mb
        @new_resource.updated_by_last_action true
        Chef::Log.info "#{@new_resource} created"
      end
    end
  end
end
