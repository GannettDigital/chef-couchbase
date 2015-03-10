require "chef/resource"
require File.join(File.dirname(__FILE__), "credentials_attributes")

class Chef
  class Resource
    class XdcrStart < Resource
      include Couchbase::CredentialsAttributes

      def uuid(arg = nil)
        set_or_return(:uuid, arg, :kind_of => String, :name_attribute => true)
      end

      def to_cluster(arg = nil)
        set_or_return(:to_cluster, arg, :kind_of => String, :name_attribute => true)
      end

      def from_bucket(arg = nil)
        set_or_return(:from_bucket, arg, :kind_of => String, :name_attribute => true)
      end

      def to_bucket(arg = nil)
        set_or_return(:to_bucket, arg, :kind_of => String, :name_attribute => true)
      end

      def replication_type(arg = nil)
        set_or_return(:replication_type, arg, :kind_of => String, :name_attribute => true, :default => "continuous")
      end

      def username(arg = nil)
        set_or_return(:username, arg, :kind_of => String, :name_attribute => true)
      end

      def password(arg = nil)
        set_or_return(:password, arg, :kind_of => String, :name_attribute => true)
      end

      def initialize(*)
        super
        @action = :start_replication
        @allowed_actions.push :start_replication
        @resource_name = :xdcr_start
      end
    end
  end
end
