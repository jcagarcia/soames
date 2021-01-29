require 'logger'

module Soames
  module Loggable
    def logger
      @logger ||= Logger.new(STDOUT)
    end
  end
end
