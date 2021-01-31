require_relative 'parsers/yomu_parser'

module Soames
  module Services
    class FileReader
      class PdfReader
        READER_EXTENSION = '.pdf'.freeze

        class << self
          def applies?(extension)
            extension == READER_EXTENSION
          end

          def read_from(path)
            Parsers::YomuParser.text_from(path)
          rescue
            Soames.logger.error "Error reading the #{READER_EXTENSION} file"

            raise "Error reading the #{READER_EXTENSION} file."
          end
        end
      end
    end
  end
end