module Soames
  module Services
    class FraudChecker
      class << self
        def analyze(one, other)
          result = Result.new
          candidates_one = one.split('.')
          candidates_other = other.split('.')

          candidates_one.each do |candidate_one|
            candidates_other.each do |candidate_other|
              max_size = [candidate_one.size, candidate_other.size].max
              distance = levenshtein(candidate_one, candidate_other)
              fraud_level = (100 - ((distance.to_f * 100) / max_size.to_f)).truncate(2).to_f
              result.add_candidate(text: candidate_one, fraud_level: fraud_level)
            end
          end

          result
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
        attr_reader :candidates

        def initialize(candidates: [])
          @candidates = candidates
        end

        def add_candidate(text:, fraud_level:)
          @candidates << Candidate.new(text: text, fraud_level: fraud_level)
        end

        def fraud?
          return false unless matches.any?

          true
        end

        def fraud_level
          return 0.0 unless matches.any?

          (matches.map(&:fraud_level).inject{ |sum, el| sum + el }.to_f / matches.size).truncate(2).to_f
        end

        def matches
          @candidates.select do |candidate|
            candidate.fraud_level > 50
          end
        end

        class Candidate
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