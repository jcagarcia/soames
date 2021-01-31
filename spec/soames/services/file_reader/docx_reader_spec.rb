require 'spec_helper'
require 'soames/services/file_reader/docx_reader'

RSpec.describe Soames::Services::FileReader::DocxReader do
  describe '.applies?' do
    context 'when the provided file is a .docx file' do
      it 'return true' do
        result = described_class.applies?('.docx')

        expect(result).to be true
      end
    end

    context 'when the provided file is NOT a .docx file' do
      it 'return false' do
        result = described_class.applies?('.wad')

        expect(result).to be false
      end
    end
  end

  describe '.read_from' do
    context 'when the path is valid' do
      it 'return the content of the file' do
        path_one = "#{File.dirname(__FILE__)}/../../../utils/local_files/docx_files/sample.docx"
        path_two = "#{File.dirname(__FILE__)}/../../../utils/local_files/docx_files/sample_two.docx"

        result = described_class.read_from(path_one)
        expect(result).to eq('Title. A docx content')

        result = described_class.read_from(path_two)
        expect(result).to eq('Another Title. Another docx content')
      end
    end

    context 'when the path is NOT valid' do
      it 'raises an error' do
        invalid_path = "#{File.dirname(__FILE__)}/wadus.docx"

        expect {
          described_class.read_from(invalid_path)
        }.to raise_error 'Error reading the .docx file.'
      end
    end
  end
end
