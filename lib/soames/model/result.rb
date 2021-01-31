module Soames
  module Model
    class Result
      attr_reader :original_text, :detectors_results

      def initialize(original_text)
        @original_text = original_text
        @detectors_results = []
      end

      def add_detector_result(result)
        @detectors_results << result
      end

      def fraud?
        return false unless fraud_level

        fraud_level > 50
      end

      def fraud_level
        return 0.0 unless @detectors_results.any?

        @detectors_results.map(&:fraud_level).max
      end

      def to_h
        {
          original_text: original_text,
          fraud?: fraud?,
          fraud_level: fraud_level,
          detectors_results: @detectors_results.map(&:to_h)
        }
      end
    end
  end
end