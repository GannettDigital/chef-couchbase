require "chef/resource"
require File.join(File.dirname(__FILE__), "credentials_attributes")

class Chef
  class Resource
    class XdcrRef < Resource
      include Couchbase::CredentialsAttributes

      def uuid(arg = nil)
        set_or_return(:uuid, arg, :kind_of => String, :name_attribute => true)
      end

      def remote_node(arg = nil)
        set_or_return(:remote_node, arg, :kind_of => String, :name_attribute => true)
      end

      def remote_name(arg = nil)
        set_or_return(:remote_name, arg, :kind_of => String, :name_attribute => true)
      end

      def username(arg = nil)
        set_or_return(:username, arg, :kind_of => String, :name_attribute => true)
      end

      def password(arg = nil)
        set_or_return(:password, arg, :kind_of => String, :name_attribute => true)
      end

      def initialize(*)
        super
        @action = :create_ref
        @allowed_actions.push :create_ref
        @resource_name = :xdcr_ref
      end
    end
  end
end
