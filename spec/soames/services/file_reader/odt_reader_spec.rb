require 'spec_helper'
require 'soames/services/file_reader/odt_reader'

RSpec.describe Soames::Services::FileReader::OdtReader do
  describe '.applies?' do
    context 'when the provided file is a .odt file' do
      it 'return true' do
        result = described_class.applies?('.odt')

        expect(result).to be true
      end
    end

    context 'when the provided file is NOT a .odt file' do
      it 'return false' do
        result = described_class.applies?('.wad')

        expect(result).to be false
      end
    end
  end

  describe '.read_from' do
    context 'when the path is valid' do
      it 'return the content of the file' do
        path_one = "#{File.dirname(__FILE__)}/../../../utils/local_files/odt_files/sample.odt"
        path_two = "#{File.dirname(__FILE__)}/../../../utils/local_files/odt_files/sample_two.odt"

        result = described_class.read_from(path_one)
        expect(result).to eq('Title. A odt content')

        result = described_class.read_from(path_two)
        expect(result).to eq('Another Title. Another odt content')
      end
    end

    context 'when the path is NOT valid' do
      it 'raises an error' do
        invalid_path = "#{File.dirname(__FILE__)}/wadus.odt"

        expect {
          described_class.read_from(invalid_path)
        }.to raise_error 'Error reading the .odt file.'
      end
    end
  end
end
