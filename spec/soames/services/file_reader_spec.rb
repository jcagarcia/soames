require 'spec_helper'
require 'soames/services/file_reader'

RSpec.describe Soames::Services::FileReader do
  before do
    @original_readers = Soames::Services::FileReader::FILE_READERS
  end

  after do
    Soames::Services::FileReader::FILE_READERS = @original_readers
  end

  describe '.read' do
    context 'when the provided path applies for some reader' do
      let(:a_reader) do
        double(:reader, applies?: true, read_from: nil)
      end

      before do
        Soames::Services::FileReader::FILE_READERS = [ a_reader ]
      end

      it 'delegates into the reader' do
        expect(a_reader).to receive(:read_from)

        described_class.read('document.doc')
      end
    end

    context 'when the provided path does not apply for any reader' do
      let(:another_reader) do
        double(:other_reader, applies?: false, read_from: nil)
      end

      before do
        Soames::Services::FileReader::FILE_READERS = [ another_reader ]
      end

      it 'do NOT delegate into the reader and it raises an exception' do
        expect(another_reader).to_not receive(:read_from)

        expect {
          described_class.read('document.wad')
        }.to raise_error "No reader available for .wad extension"
      end
    end
  end
end
