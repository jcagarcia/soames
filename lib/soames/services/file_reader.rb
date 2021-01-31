require_relative 'file_reader/doc_reader'
require_relative 'file_reader/docx_reader'
require_relative 'file_reader/odt_reader'
require_relative 'file_reader/pdf_reader'
require_relative 'file_reader/txt_reader'

module Soames
  module Services
    class FileReader
      FILE_READERS = [ DocReader, DocxReader, OdtReader, PdfReader, TxtReader ]

      class << self
        def read(path)
          extension = File.extname(path)

          reader = FILE_READERS.find do |file_reader|
            file_reader.applies?(extension)
          end

          raise "No reader available for #{extension} extension" unless reader

          reader.read_from(path)
        rescue => e
          Soames.logger.error "Error reading file #{path}"
          raise e
        end
      end
    end
  end
end