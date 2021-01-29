require 'spec_helper'
require 'soames/services/fraud_checker'

RSpec.describe Soames::Services::FraudChecker do
  describe '.analyze' do
    context 'when the texts are equal' do
      it 'returns a fraud result' do
        result = described_class.analyze('Wadus', 'Wadus')

        expect(result.fraud?).to be true
        expect(result.fraud_level).to be (100.0)
      end
    end

    context 'when the text has part of fraud' do
      it 'returns a fraud result' do
        result = described_class.analyze('An informative and useful text', 'An informative text')

        expect(result.fraud?).to be true
        expect(result.fraud_level).to be > 60
      end
    end

    context 'when the text has only some coincident words' do
      it 'returns a NOT fraud result' do
        result = described_class.analyze('An informative text that a student can use in a homework', 'An informative text with lot of content to be compared from Wikipedia')

        expect(result.fraud?).to be false
        expect(result.fraud_level).to be < 60
      end
    end

    context 'when the texts are really different' do
      it 'returns a NOT fraud result' do
        result = described_class.analyze('Homework done by a student without checking or copying from internet', 'This text from Internet is really useful for students and it can be copied easily.')

        expect(result.fraud?).to be false
        expect(result.fraud_level).to be < 20
      end
    end
  end
end
