module Soames
  module Detectors
    module Model
      class DetectorResult
        attr_reader :sources

        def initialize
          @sources = []
        end

        def fraud_level
          @sources.map(&:fraud_level).max
        end

        def add_source_result(source_name:, fraud_level:)
          @sources << SourceResult.new(source_name: source_name, fraud_level: fraud_level)
        end

        class SourceResult
          attr_reader :source_name, :fraud_level

          def initialize(source_name:, fraud_level:)
            @source_name = source_name
            @fraud_level = fraud_level
          end
        end
      end
    end
  end
end