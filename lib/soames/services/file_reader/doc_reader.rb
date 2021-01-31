module Soames
  module Services
    class FileReader
      class DocReader
        READER_EXTENSION = '.doc'

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