require 'spec_helper'
require 'soames/detectors/files_detector'
require 'soames/services/fraud_checker'

RSpec.describe Soames::Detectors::FilesDetector do
  let(:local_files_folder) do
    "#{File.dirname(__FILE__)}/../../utils/local_files/txt_files"
  end

  describe '.build_default' do
    it 'return a new instance with the default configuration' do
      result = described_class.build_default

      expect(result).to be_a Soames::Detectors::FilesDetector
      expect(result.folder).to eq('/root')
    end
  end

  describe '#check_fraud' do
    let(:detector_instance) do
      described_class.new(folder: local_files_folder)
    end

    let(:a_fraud_candidate) do
      Soames::Services::FraudChecker::Result::Candidate.new(text: 'A text', fraud_level: 80.0)
    end
    let(:another_fraud_candidate) do
      Soames::Services::FraudChecker::Result::Candidate.new(text: 'Another text', fraud_level: 100.0)
    end
    let(:no_fraud_candidate) do
      Soames::Services::FraudChecker::Result::Candidate.new(text: 'Original text', fraud_level: 23.3)
    end

    let(:fraud_checker_result) do
      Soames::Services::FraudChecker::Result.new(candidates: [ a_fraud_candidate, another_fraud_candidate, no_fraud_candidate ])
    end

    before do
      allow(Soames::Services::FraudChecker).to receive(:analyze).and_return(fraud_checker_result)
    end

    it 'delegates into the fraud checker service' do
      expect(Soames::Services::FraudChecker).to receive(:analyze).with('a text', anything).twice

      detector_instance.check_fraud('a text')
    end

    it 'returns an instance of detectors result' do
      result = detector_instance.check_fraud('a text')

      expect(result.fraud_level).to eq(90.0)
      expect(result.sources.size).to eq(2)

      expect(result.sources.first.source_name).to include(local_files_folder)
      expect(result.sources.first.matches.size).to eq(2)
      expect(result.sources.first.matches.first.text).to eq('A text')
      expect(result.sources.first.matches.first.fraud_level).to eq(80.0)
      expect(result.sources.first.matches.last.text).to eq('Another text')
      expect(result.sources.first.matches.last.fraud_level).to eq(100.0)
      expect(result.sources.first.fraud_level).to eq(90.00)

      expect(result.sources.last.source_name).to include(local_files_folder)
      expect(result.sources.last.matches.size).to eq(2)
      expect(result.sources.last.matches.first.text).to eq('A text')
      expect(result.sources.last.matches.first.fraud_level).to eq(80.0)
      expect(result.sources.last.matches.last.text).to eq('Another text')
      expect(result.sources.last.matches.last.fraud_level).to eq(100.0)
      expect(result.sources.last.fraud_level).to eq(90.00)
    end


    context 'when the folder contains' do
      context '.txt files' do
        let(:local_files_folder) do
          "#{File.dirname(__FILE__)}/../../utils/local_files/txt_files"
        end

        it 'delegates into the fraud checker service with the text inside a .txt file' do
          expect(Soames::Services::FraudChecker).to receive(:analyze).with('a text', anything).twice
          expect(Soames::Services::FileReader::TxtReader).to receive(:read_from).twice

          detector_instance.check_fraud('a text')
        end
      end

      context '.doc files' do
        let(:local_files_folder) do
          "#{File.dirname(__FILE__)}/../../utils/local_files/doc_files"
        end

        it 'delegates into the fraud checker service with the text inside a .doc file' do
          expect(Soames::Services::FraudChecker).to receive(:analyze).with('a text', anything).twice
          expect(Soames::Services::FileReader::DocReader).to receive(:read_from).twice

          detector_instance.check_fraud('a text')
        end
      end

      context '.docx files' do
        let(:local_files_folder) do
          "#{File.dirname(__FILE__)}/../../utils/local_files/docx_files"
        end

        it 'delegates into the fraud checker service with the text inside a .docx file' do
          expect(Soames::Services::FraudChecker).to receive(:analyze).with('a text', anything).twice
          expect(Soames::Services::FileReader::DocxReader).to receive(:read_from).twice

          detector_instance.check_fraud('a text')
        end
      end

      context '.odt files' do
        let(:local_files_folder) do
          "#{File.dirname(__FILE__)}/../../utils/local_files/odt_files"
        end

        it 'delegates into the fraud checker service with the text inside a .odt file' do
          expect(Soames::Services::FraudChecker).to receive(:analyze).with('a text', anything).twice
          expect(Soames::Services::FileReader::OdtReader).to receive(:read_from).twice

          detector_instance.check_fraud('a text')
        end
      end

      context '.pdf files' do
        let(:local_files_folder) do
          "#{File.dirname(__FILE__)}/../../utils/local_files/pdf_files"
        end

        it 'delegates into the fraud checker service with the text inside a .pdf file' do
          expect(Soames::Services::FraudChecker).to receive(:analyze).with('a text', anything).twice
          expect(Soames::Services::FileReader::PdfReader).to receive(:read_from).twice

          detector_instance.check_fraud('a text')
        end
      end

      context 'no valid files' do
        let(:local_files_folder) do
          "#{File.dirname(__FILE__)}/../../utils/local_files/no_valid_files"
        end

        it 'does NOT delegate into the fraud checker service' do
          expect(Soames::Services::FraudChecker).to_not receive(:analyze)

          detector_instance.check_fraud('a text')
        end
      end
    end
  end
end
