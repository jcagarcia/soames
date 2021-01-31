require 'spec_helper'
require 'soames/services/file_reader/txt_reader'

RSpec.describe Soames::Services::FileReader::TxtReader do
  describe '.applies?' do
    context 'when the provided file is a .txt file' do
      it 'return true' do
        result = described_class.applies?('.txt')

        expect(result).to be true
      end
    end

    context 'when the provided file is NOT a .txt file' do
      it 'return false' do
        result = described_class.applies?('.wad')

        expect(result).to be false
      end
    end
  end

  describe '.read_from' do
    context 'when the path is valid' do
      it 'return the content of the file' do
        path_one = "#{File.dirname(__FILE__)}/../../../utils/local_files/txt_files/sample.txt"
        path_two = "#{File.dirname(__FILE__)}/../../../utils/local_files/txt_files/sample_two.txt"

        result = described_class.read_from(path_one)
        expect(result).to eq('A txt content')

        result = described_class.read_from(path_two)
        expect(result).to eq('Another txt content')
      end
    end

    context 'when the path is NOT valid' do
      it 'raises an error' do
        invalid_path = "#{File.dirname(__FILE__)}/wadus.txt"

        expect {
          described_class.read_from(invalid_path)
        }.to raise_error 'Error reading the .txt file. Error => No such file or directory @ rb_sysopen - /opt/spec/soames/services/file_reader/wadus.txt'
      end
    end
  end
end
