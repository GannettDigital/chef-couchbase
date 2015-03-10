require "chef/provider"
require File.join(File.dirname(__FILE__), "client")
require File.join(File.dirname(__FILE__), "cluster_data")

class Chef
  class Provider
    class XdcrRef < Provider
      include Couchbase::Client

      def load_current_resource
        @current_resource = Resource::XdcrRef.new @new_resource.name
        @current_resource.uuid @new_resource.uuid
        @current_resource.remote_node @new_resource.remote_node
        @current_resource.name @new_resource.remote_name
        @current_resource.username @new_resource.username
        @current_resource.password @new_resource.password
      end

      def action_create_ref
        post "/pools/default/remoteClusters", create_params
        @new_resource.updated_by_last_action true
        Chef::Log.info "#{@new_resource} modified"
      end

      def create_params
        {
          "uuid" => new_resource.uuid,
          "name" => new_resource.remote_name,
          "hostname" => new_resource.remote_node,
          "username" => new_resource.username,
          "password" => new_resource.password
        }
      end
    end
  end
end
