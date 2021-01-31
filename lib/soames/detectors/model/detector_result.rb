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

        def add_source_result(source_name:, matches:, fraud_level:)
          @sources << SourceResult.new(source_name: source_name, matches: matches, fraud_level: fraud_level)
        end

        class SourceResult
          attr_reader :source_name, :matches, :fraud_level

          def initialize(source_name:, matches:, fraud_level:)
            @source_name = source_name
            @matches = build_from_fraud_checker_matcher_model(matches)
            @fraud_level = fraud_level
          end

          def build_from_fraud_checker_matcher_model(matches)
            matches.map do |match|
              Match.new(text: match.text, fraud_level: match.fraud_level)
            end
          end

          class Match
            attr_reader :text, :fraud_level

            def initialize(text:, fraud_level:)
              @text = text
              @fraud_level = fraud_level
            end
          end
        end
      end
    end
  end
end