module Soames
  module Services
    class FileReader
      class TxtReader
        READER_EXTENSION = '.txt'

        class << self
          def applies?(extension)
            extension == READER_EXTENSION
          end

          def read_from(path)
            File.open(path).read
          end
        end
      end
    end
  end
end