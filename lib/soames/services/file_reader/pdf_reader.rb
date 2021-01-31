module Soames
  module Services
    class FileReader
      class PdfReader
        READER_EXTENSION = '.pdf'

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