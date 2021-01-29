module Soames
  module Services
    class FraudChecker
      class << self
        def analyze(one, other)
          longer_text = [one.size, other.size].max
          result = levenshtein(one, other)

          fraud_level = (100 - ((result.to_f * 100) / longer_text.to_f)).truncate(2).to_f 

          puts "LONGER TEXT #{longer_text}"
          puts "RESULT #{result}"
          puts "FRAUD LEVEL #{fraud_level}"

          return Result.new(fraud: true, fraud_level: fraud_level) if fraud_level > 60.0

          Result.new(fraud: false, fraud_level: fraud_level)
        end

        private

        def levenshtein(one, other)
          other = other.to_s
          distance = Array.new(one.size + 1, 0)
          (0..one.size).each do |i|
            distance[i] = Array.new(other.size + 1)
            distance[i][0] = i
          end
          (0..other.size).each do |j|
            distance[0][j] = j
          end

          (1..one.size).each do |i|
            (1..other.size).each do |j|
              distance[i][j] = [distance[i - 1][j] + 1,
                                distance[i][j - 1] + 1,
                                distance[i - 1][j - 1] + ((one[i - 1] == other[j - 1]) ? 0 : 1)].min
            end
          end
          distance[one.size][other.size]
        end
      end

      class Result
        attr_reader :fraud_level

        def initialize(fraud: false, fraud_level: 0.0)
          @fraud = fraud
          @fraud_level = fraud_level
        end

        def fraud?
          @fraud
        end
      end
    end
  end
end