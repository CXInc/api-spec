class ApiSpec
  class Configuration < Struct.new(:http_client)
  end

  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      set_defaults
      yield(configuration) if block_given?
    end

    private

    def set_defaults
      configuration.http_client = RestClient
    end
  end
end
