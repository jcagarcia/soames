require_relative 'detectors/files_detector'

module Soames
  module Configurable
    attr_reader :configuration

    DEFAULT_DETECTORS = [ Detectors::FilesDetector ].freeze

    class Configuration
      attr_accessor :detectors

      def initialize(args = {})
        @detectors = args[:detectors]
      end
    end

    def configure
      @configuration ||= Configuration.new
      yield @configuration
    end

    def default_configuration
      @configuration ||= Configuration.new(detectors: default_detectors)
    end

    def default_detectors
      DEFAULT_DETECTORS.map do |detector|
        detector.build_default
      end
    end
  end
end
