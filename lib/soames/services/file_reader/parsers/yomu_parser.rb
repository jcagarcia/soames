require 'yomu'

module Soames
  module Services
    class FileReader
      module Parsers
        class YomuParser
          class << self
            def text_from(path)
              text = Yomu.new(path).text

              sanitize(text)
            rescue
              Soames.logger.error "[YOMU] Error reading #{path} file."

              raise "[YOMU] Error reading #{path} file."
            end

            private

            def sanitize(text)
              text.split("\n").map(&:strip).reject { |t| t.empty? }.join('. ')
            end
          end
        end
      end
    end
  end
end