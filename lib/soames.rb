require 'soames/version'
require 'soames/configurable'
require 'soames/loggable'
require 'soames/client'

module Soames
  extend Configurable
  extend Loggable
  extend Client
end
