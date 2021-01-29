require_relative 'model/result'

module Soames
  module Client
    def check_fraud(text)
      result = Soames::Model::Result.new(text)

      detectors.each do |detector|
        detector_result = detector.check_fraud(text)
        result.add_detector_result(detector_result)
      end

      result
    end

    private

    def detectors
      @detectors ||= config.detectors
    end

    def config
      return Soames.default_configuration unless Soames.configuration

      Soames.configuration
    end
  end
end
