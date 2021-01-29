module Soames
  module Detectors
    class BaseDetector
      class << self
        def build_default
          raise 'Must be implemented by the detector'
        end
      end

      def check_fraud(text)
        raise 'Must be implemented by the detector'
      end

      def detector_name
        self.to_s
      end
    end
  end
end