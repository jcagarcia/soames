require 'spec_helper'

RSpec.describe Soames::Loggable do
  let(:a_class) do
    Class.new do
      extend Soames::Loggable
    end
  end

  describe  '#logger' do
    it 'returns a logger instance' do
      expect(a_class.logger).to be_an_instance_of(Logger)
    end
  end
end
