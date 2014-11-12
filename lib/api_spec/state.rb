class ApiSpec
  class State
    class << self
      def set(key, value)
        state[key.to_sym] = value
      end

      def get(key)
        state[key.to_sym]
      end

      def reset
        @state = {}
      end

      private

      def state
        @state ||= {}
      end
    end
  end
end
