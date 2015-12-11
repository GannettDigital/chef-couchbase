module Couchbase
  # Provides Module ServicesData
  module ServicesData
    private

    def services_data
      return @services_data if instance_variable_defined? '@services_data'

      @services_data ||= begin
        response = get '/pools/default'
        response.error! unless response.is_a?(Net::HTTPSuccess) || response.is_a?(Net::HTTPNotFound)
        Chef::JSONCompat.from_json response.body if response.is_a? Net::HTTPSuccess
      end
    end
  end
end
