require 'spec_helper'
require 'soames/client'
require 'soames/detectors/model/detector_result'

RSpec.describe Soames::Client do
  let(:a_client) do
    Module.new do
      extend Soames::Client
    end
  end

  describe '.check_fraud' do
    let(:a_detector) do
      double(:a_detector, check_fraud: instance_double(Soames::Detectors::Model::DetectorResult, fraud_level: 93.35), default?: false)
    end
    let(:another_detector) do
      double(:another_detector, check_fraud: instance_double(Soames::Detectors::Model::DetectorResult, fraud_level: 25.44), default?: false)
    end

    before do
      Soames.configure do |config|
        config.detectors = [ a_detector, another_detector ]
      end
    end

    it 'delegates in the configured detectors to check the fraud' do
      expect(a_detector).to receive(:check_fraud).with('wadus')

      a_client.check_fraud('wadus')
    end

    it 'returns a model with the result of the fraud analysis including specific information of each detector' do
      result = a_client.check_fraud('wadus')

      expect(result.fraud?).to be true
      expect(result.fraud_level).to eq(93.35)
      expect(result.original_text).to eq('wadus')
      expect(result.detector_results.size).to eq(2)
      expect(result.detector_results.first.fraud_level).to eq(93.35)
      expect(result.detector_results.last.fraud_level).to eq(25.44)
    end

    context 'when the gem is not configured' do
      let(:a_default_detector) do
        double(:a_detector, check_fraud: nil, default?: true)
      end

      let(:default_configuration) do
        double(:configuration, detectors: [ a_default_detector ])
      end

      before do
        allow(Soames).to receive(:configuration).and_return(nil)
        allow(Soames).to receive(:default_configuration).and_return(default_configuration)
      end

      it 'delegates into the default detectors' do
        expect(a_default_detector).to receive(:check_fraud).with('wadus')

        a_client.check_fraud('wadus')
      end
    end
  end
end
