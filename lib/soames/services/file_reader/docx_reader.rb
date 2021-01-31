module Soames
  module Services
    class FileReader
      class DocxReader
        READER_EXTENSION = '.docx'

        class << self
          def applies?(extension)
            extension == READER_EXTENSION
          end

          def read_from(path)
            # TODO
          end
        end
      end
    end
  end
end