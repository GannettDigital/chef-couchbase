require 'chef/provider'
require 'net/http'
require File.join(File.dirname(__FILE__), 'client')

class Chef
  class Provider
    # Provides Class CouchbaesServices < Provider
    class CouchbaseServices < Provider
      provides :couchbase_services
      include Couchbase::Client
      include Couchbase::ServicesData

      def load_current_resource
        @current_resource = Chef::Resource::CouchbaseServices.new @new_resource.name
        @current_resource.id @new_resource.id
        @current_resource.exists true if services_data
        @current_resource.services @new_resource.services
      end

      def action_set_services
        Chef::Log.warn(@new_resource.services)
        return if @current_resource.exists
        post '/node/controller/setupServices', 'services' => @new_resource.services
        @new_resource.updated_by_last_action true
        Chef::Log.info "#{@new_resource} modified"
      end
    end
  end
end
