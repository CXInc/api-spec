module ApiSpec
  class Parameters
    attr_reader :query

    def initialize(method, path, table = nil)
      @method = method
      @path = path

      @path_params = {}
      @query = {}
      @form = {}
      @json = {}
      @cookie = {}
      @header = {}

      load_table(table) if table
    end

    def url
      interpolated_path = @path.scan(/\{(.*?)\}/).reduce(@path) do |path, match|
        key = match.first
        value = @path_params[key]

        raise StandardError.new("Missing #{key}") unless value

        path.gsub /\{#{key}\}/, URI.encode(value)
      end

      "http://localhost:#{$port}#{interpolated_path}"
    end

    def method_missing(name)
      State.get(name)
    end

    def body
      if @json.any?
        @json.to_json
      elsif @form.any?
        @form
      else
        ""
      end
    end

    def headers
      @header.merge(cookie_header)
    end

    def cookie_header
      string = @cookie
        .map { |key, value| "#{key}=#{value}" }
        .join("; ")

      { "Cookie" => string }
    end

    private

    def load_table(table)
      table.hashes.each do |hash|
        matches = hash[:value].match(/\{(.*)\}/)
        key = hash["parameter name"]

        value = if matches
          method = matches[1]
          hash[:value].gsub(/\{#{method}\}/, send(method).to_s)
        else
          hash[:value]
        end

        set_param(hash["parameter type"], key, value)
      end
    end

    def set_param(type, key, value)
      case type
      when "path"
        @path_params[key] = value
      when "query"
        @query[key] = value
      when "json"
        parts = key.split("/")

        hash = parts.reverse.reduce(nil) do |acc, part|
          if part.match(/\d+/)
            [acc || json_value(value)]
          else
            if acc
              {part => acc}
            else
              {part => json_value(value)}
            end
          end
        end

        @json.merge!(hash)
      when "form"
        @form[key] = value
      when "cookie"
        @cookie[key] = value
      when "header"
        @header[key] = value
      else
        fail "Unrecognized parameter type: #{type}"
      end
    end

    def json_value(value_string)
      JSON.parse("{\"value\":#{value_string}}")["value"]
    rescue JSON::ParserError
      value_string
    end
  end
end
