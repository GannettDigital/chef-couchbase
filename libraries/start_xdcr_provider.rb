require "chef/provider"
require File.join(File.dirname(__FILE__), "client")
require File.join(File.dirname(__FILE__), "cluster_data")

class Chef
  class Provider
    class XdcrStart < Provider
      include Couchbase::Client

      # rubocop:disable Metrics/AbcSize
      def load_current_resource
        @current_resource = Resource::XdcrStart.new @new_resource.name
        @current_resource.uuid @new_resource.uuid
        @current_resource.to_cluster @new_resource.to_cluster
        @current_resource.from_bucket @new_resource.from_bucket
        @current_resource.to_bucket @new_resource.to_bucket
        @current_resource.replication_type @new_resource.replication_type
        @current_resource.username @new_resource.username
        @current_resource.password @new_resource.password
      end
      # rubocop:enable Metrics/AbcSize

      def action_start_replication
        post "/controller/createReplication", create_params
        @new_resource.updated_by_last_action true
        Chef::Log.info "#{@new_resource} modified"
      end

      def create_params
        {
          "uuid" => new_resource.uuid,
          "fromBucket" => new_resource.from_bucket,
          "toBucket" => new_resource.to_bucket,
          "toCluster" => new_resource.to_cluster,
          "replicationType" => new_resource.replication_type,
          "username" => new_resource.username,
          "password" => new_resource.password
        }
      end
    end
  end
end
