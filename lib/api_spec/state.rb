class ApiSpec
  class State
    class << self
      def set(key, value)
        state[key.to_sym] = value
      end

      def get(key)
        state[key.to_sym] || call_helper(key)
      end

      def register_helper(key, &block)
        helpers[key.to_sym] = block
      end

      def reset
        @state = {}
      end

      private

      def call_helper(key)
        if helpers[key.to_sym]
          helpers[key.to_sym].call
        else
          nil
        end
      end

      def state
        @state ||= {}
      end

      def helpers
        @helpers ||= {}
      end
    end
  end
end
