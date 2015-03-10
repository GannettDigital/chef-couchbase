module Couchbase
  module Client
    private

    def uri_from_path(path)
      Chef::Log.info("dann check this out value is #{@new_resource.clusterip}")
      # URI.parse "http://#{@new_resource.username}:#{@new_resource.password}@localhost:8091#{path}"
      URI.parse "http://#{@new_resource.username}:#{@new_resource.password}@#{@new_resource.clusterip}:8091#{path}"
    end

    def post(path, params)
      Chef::Log.info("dann params are #{params}")
      response = Net::HTTP.post_form(uri_from_path(path), params)
      Chef::Log.error response.body unless response.is_a? Net::HTTPSuccess
      response.value
      response
    end

    def get(path)
      uri = uri_from_path path

      # response = Net::HTTP.start uri.host, uri.port do |http|
      Net::HTTP.start uri.host, uri.port do |http|
        request = Net::HTTP::Get.new uri.path
        request.basic_auth uri.user, uri.password
        http.request request
      end
    end
  end
end
