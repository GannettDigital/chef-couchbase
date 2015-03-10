require "chef/resource"
require File.join(File.dirname(__FILE__), "credentials_attributes")

class Chef
  class Resource
    class AddNode < Resource
      include Couchbase::CredentialsAttributes

      def hostname(arg = nil)
        set_or_return(:hostname, arg, :kind_of => String, :name_attribute => true)
      end

      def username(arg = nil)
        set_or_return(:username, arg, :kind_of => String, :name_attribute => true)
      end

      def password(arg = nil)
        set_or_return(:password, arg, :kind_of => String, :name_attribute => true)
      end

      def clusterip(arg = nil)
        set_or_return(:clusterip, arg, :kind_of => String, :name_attribute => true)
      end

      def initialize(*)
        super
        @action = :add_node_only
        @allowed_actions.push :add_node_only
        @resource_name = :add_node
      end
    end
  end
end
