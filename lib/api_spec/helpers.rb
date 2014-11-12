require "rest-client"

module ApiSpec
  class ErrorResponse < Struct.new(:code, :body)
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
          @response = RestClient.get parameters.url,
            headers.merge(params: parameters.query)
        when :post
          @response = RestClient.post parameters.url, parameters.body,
            headers.merge(content_type: :json)
        when :put
          @response = RestClient.put parameters.url, parameters.body,
            headers.merge(content_type: :json)
        when :delete
          @response = RestClient.delete parameters.url,
            headers
        else
          fail "Unsupported method: #{method}"
        end

        if ENV["API_SPEC_DEBUG"]
          puts "@response = #{@response}"
        end
      rescue RestClient::Exception => e
        @response = ErrorResponse.new(e.http_code, e.http_body)
        puts "Error response body: #{ @response.body }"
      end
    end
  end
end
