module Soames
  module Model
    class Result
      attr_reader :original_text, :detector_results

      def initialize(original_text)
        @original_text = original_text
        @detector_results = []
      end

      def add_detector_result(result)
        @detector_results << result
      end

      def fraud_level
        @detector_results.map(&:fraud_level).max
      end
    end
  end
end