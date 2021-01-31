require 'spec_helper'

RSpec.describe Soames::Configurable do
  let(:a_class) do
    Class.new do
      extend Soames::Configurable

    end
  end

  describe '.configure' do
    it 'yields a Configuration instance' do
      expect do |b|
        a_class.configure(&b)
      end.to yield_with_args(an_instance_of(Soames::Configurable::Configuration))
    end

    it 'configuration instance is memoized once configured' do
      a_class.configure {}
      configuration1 = a_class.configuration
      a_class.configure {}
      configuration2 = a_class.configuration

      expect(configuration1).to be(configuration2)
    end

    context 'configuration attributes' do
      let(:detectors) { [ double('a-detector') ] }

      it 'provided detectors are set' do
        a_class.configure do |config|
          config.detectors = detectors
        end

        expect(a_class.configuration.detectors).to eq(detectors)
      end
    end
  end

  describe '.default_configuration' do
    it 'default detectors are set' do
      expect(a_class.default_configuration.detectors).to include(an_instance_of(Soames::Detectors::FilesDetector))
    end
  end
end
