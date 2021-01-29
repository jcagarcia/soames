require_relative 'base_detector'
require_relative 'model/detector_result'
require_relative '../services/fraud_checker'

module Soames
  module Detectors
    class LocalFolderDetector < BaseDetector
      class << self
        DEFAULT_HOME_PATH = File.expand_path('~').freeze

        def build_default
          new(folder: DEFAULT_HOME_PATH)
        end
      end

      def initialize(args = {})
        @folder = args[:folder]
      end

      def check_fraud(text)
        detector_result = Soames::Detectors::Model::DetectorResult.new

        files_in_folder = Dir.glob("#{@folder}/*")
        files_in_folder.each do |local_file|
          file = File.open(local_file)

          result = Soames::Services::FraudChecker.analyze(text, file.read)

          detector_result.add_source_result(source_name: local_file, fraud_level: result.fraud_level) if result.fraud?
        end

        detector_result
      end
    end
  end
end