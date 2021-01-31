module Soames
  module Services
    class FileReader
      class OdtReader
        READER_EXTENSION = '.odt'

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