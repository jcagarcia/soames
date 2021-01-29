require 'spec_helper'
require 'soames/detectors/local_folder_detector'
require 'soames/services/fraud_checker'

RSpec.describe Soames::Detectors::LocalFolderDetector do
  let(:local_files_folder) do
    "#{File.dirname(__FILE__)}/../../utils/local_files"
  end

  describe '.build_default' do
    it 'return a new instance with the default configuration' do
      result = described_class.build_default

      expect(result).to be_a Soames::Detectors::LocalFolderDetector
    end
  end

  describe '#check_fraud' do
    let(:detector_instance) do
      described_class.new(folder: local_files_folder)
    end
    let(:fraud_checker_result) do
      Soames::Services::FraudChecker::Result.new(fraud: true, fraud_level: 100.0)
    end

    before do
      allow(Soames::Services::FraudChecker).to receive(:analyze).and_return(fraud_checker_result)
    end

    it 'returns an instance of detectors result' do
      result = detector_instance.check_fraud('a text')

      expect(result.fraud_level).to eq(100.0)
      expect(result.sources.size).to eq(2)

      expect(result.sources.first.source_name).to include(local_files_folder)
      expect(result.sources.first.fraud_level).to eq(100.00)

      expect(result.sources.last.source_name).to include(local_files_folder)
      expect(result.sources.last.fraud_level).to eq(100.00)
    end
  end
end
