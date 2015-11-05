module Couchbase
  # Provides Module PoolData
  module PoolData
    private

    def pool_memory_quota_mb
      (pool_data['storageTotals']['ram']['quotaTotal'] / pool_data['nodes'].size / 1024 / 1024).to_i
    end

    def pool_data
      return @pool_data if instance_variable_defined? '@pool_data'

      @pool_data ||= begin
        response = get "/pools/#{@new_resource.pool}"
        response.error! unless response.is_a?(Net::HTTPSuccess) || response.is_a?(Net::HTTPNotFound)
        Chef::JSONCompat.from_json response.body if response.is_a? Net::HTTPSuccess
      end
    end
  end
end
