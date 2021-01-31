require_relative 'base_detector'
require_relative 'model/detector_result'
require_relative '../services/file_reader'
require_relative '../services/fraud_checker'

module Soames
  module Detectors
    class FilesDetector < BaseDetector
      ALLOWED_EXTENSIONS = [ '.txt', '.doc', '.odt', '.docx', '.pdf' ].freeze

      attr_reader :folder

      def initialize(args = {})
        @folder = args[:folder]
      end

      def check_fraud(text)
        detector_result = Soames::Detectors::Model::DetectorResult.new(detector_name: detector_name)

        files_in_folder = Dir.glob("#{@folder}/*")
        files_in_folder.each do |local_file|
          next unless ALLOWED_EXTENSIONS.include? File.extname(local_file)

          begin
            text_from_file = Soames::Services::FileReader.read(local_file)

            result = Soames::Services::FraudChecker.analyze(text, text_from_file)

            detector_result.add_source_result(source_name: local_file, matches: result.matches, fraud_level: result.fraud_level)
          rescue => e
            Soames.logger.error e.message
          end
        end

        detector_result
      end

      def detector_name
        'files_detector'
      end

      class << self
        DEFAULT_HOME_PATH = File.expand_path('~').freeze

        def build_default
          new(folder: DEFAULT_HOME_PATH)
        end
      end
    end
  end
end