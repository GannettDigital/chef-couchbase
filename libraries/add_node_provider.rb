require "chef/provider"
require File.join(File.dirname(__FILE__), "client")
require File.join(File.dirname(__FILE__), "cluster_data")

class Chef
  class Provider
    class AddNode < Provider
      include Couchbase::Client

      def load_current_resource
        @current_resource = Resource::AddNode.new @new_resource.name
        @current_resource.username @new_resource.username
        @current_resource.password @new_resource.password
        @current_resource.hostname @new_resource.hostname
        @current_resource.clusterip @new_resource.clusterip
      end

      #      def action_print_only
      #          response = get "/pools/default"
      #          Chef::Log.error response.body unless response.kind_of?(Net::HTTPSuccess) || response.body.empty?
      #          response.value
      #          log "repomse is #{response.body}"
      #          JSONCompat.from_json response.body
      #      end

      def action_add_node_only
        begin
              # Chef::Log.info ("value of clusterip is " + new_resource.clusterip)
              post "/controller/addNode", create_params
              @new_resource.updated_by_last_action true
              Chef::Log.info "#{@new_resource} modified"
            end

            rescue SystemCallError
              Chef::Log "error adding node is " + $ERROR_INFO
      end

      def create_params
        {
          "hostname" => new_resource.hostname,
          "user" => new_resource.username,
          "password" => new_resource.password
        }
      end
    end
  end
end
