require "chef/resource"
require File.join(File.dirname(__FILE__), "credentials_attributes")

class Chef
  class Resource
    class CouchbasePool < Resource
      include Couchbase::CredentialsAttributes

      def pool(arg = nil)
        set_or_return(:pool, arg, :kind_of => String, :name_attribute => true)
      end

      def exists(arg = nil)
        set_or_return(:exists, arg, :kind_of => [TrueClass, FalseClass], :required => true)
      end

      def memory_quota_mb(arg = nil)
        set_or_return(:memory_quota_mb, arg, :kind_of => Integer, :required => true, :callbacks => {
                        "must be at least 256" => ->(quota) { quota >= 256 }
                      })
      end

      def initialize(*)
        Chef::Log.info("Dann initializing pool")
        super
        @action = :modify_if_existing
        @allowed_actions.push :modify_if_existing
        @resource_name = :couchbase_provider
      end
    end
  end
end
