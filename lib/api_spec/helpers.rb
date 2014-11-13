require "rest-client"

# Make RestClient compatible with rack test helpers
RestClient::Response.class_eval do
  alias_method :status, :code
end

class ApiSpec
  class ErrorResponse < Struct.new(:status, :body)
  end

  module Helpers
    extend self

    def test_headers
      {"X-Test-Name" => $test_name}
    end

    def make_request(method, path, table)
      parameters = ApiSpec::Parameters.new(method, path, table)
      headers = parameters.headers.merge(test_headers)

      begin
        case method
        when :get
          @response = http_client.get parameters.url,
            headers.merge(params: parameters.query)
        when :post
          @response = http_client.post parameters.url, parameters.body,
            headers
        when :put
          @response = http_client.put parameters.url, parameters.body,
            headers
        when :delete
          @response = http_client.delete parameters.url,
            headers
        else
          fail "Unsupported method: #{method}"
        end

        if ENV["API_SPEC_DEBUG"]
          puts "@response = #{@response.body}"
        end
      rescue RestClient::Exception => e
        @response = ErrorResponse.new(e.http_code, e.http_body)
        puts "Error response body: #{ @response.body }"
      end
    end

    def http_client
      ApiSpec.configuration.http_client
    end
  end
end
