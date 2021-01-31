module Soames
  module Detectors
    module Model
      class DetectorResult
        attr_reader :sources, :detector_name

        def initialize(detector_name:)
          @detector_name = detector_name
          @sources = []
        end

        def fraud?
          return false unless fraud_level

          fraud_level > 50
        end

        def fraud_level
          return 0.0 unless @sources.any?

          @sources.map(&:fraud_level).max
        end

        def add_source_result(source_name:, matches:, fraud_level:)
          @sources << SourceResult.new(source_name: source_name, matches: matches, fraud_level: fraud_level)
        end

        def to_h
          {
            detector_name: @detector_name,
            fraud?: fraud?,
            fraud_level: fraud_level,
            sources: @sources.map(&:to_h)
          }
        end

        class SourceResult
          attr_reader :source_name, :matches, :fraud_level

          def initialize(source_name:, matches:, fraud_level:)
            @source_name = source_name
            @matches = build_from_fraud_checker_matcher_model(matches)
            @fraud_level = fraud_level
          end

          def fraud?
            return 0.0 unless fraud_level

            fraud_level > 50
          end

          def build_from_fraud_checker_matcher_model(matches)
            matches.map do |match|
              Match.new(text: match.text, fraud_level: match.fraud_level)
            end
          end

          def to_h
            {
              source_name: @source_name,
              fraud_level: @fraud_level,
              matches: @matches.map(&:to_h)
            }

          end

          class Match
            attr_reader :text, :fraud_level

            def initialize(text:, fraud_level:)
              @text = text
              @fraud_level = fraud_level
            end

            def to_h
              {
                text: @text,
                fraud_level: @fraud_level
              }
            end
          end
        end
      end
    end
  end
end