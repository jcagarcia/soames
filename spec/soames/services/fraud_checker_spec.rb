require 'spec_helper'
require 'soames/services/fraud_checker'

RSpec.describe Soames::Services::FraudChecker do
  describe '.analyze' do
    context 'when the texts are equal' do
      it 'returns a fraud result' do
        result = described_class.analyze('Wadus', 'Wadus')

        expect(result.fraud?).to be true
        expect(result.fraud_level).to be (100.0)
        expect(result.matches.size).to eq 1
        expect(result.matches.first.text).to eq('Wadus')
        expect(result.matches.first.fraud_level).to eq(100.0)
      end
    end

    context 'when the text has part of fraud' do
      it 'returns a fraud result' do
        result = described_class.analyze('An informative and useful text', 'An informative text')

        expect(result.fraud?).to be true
        expect(result.fraud_level).to be > 50
        expect(result.matches.size).to eq 1
        expect(result.matches.first.text).to eq('An informative and useful text')
        expect(result.matches.first.fraud_level).to be > 50
      end
    end

    context 'when the text has only some coincident words' do
      it 'returns a NOT fraud result' do
        result = described_class.analyze('An informative text that a student can use in a homework', 'An informative text with lot of content to be compared from Wikipedia')

        expect(result.fraud?).to be false
        expect(result.fraud_level).to be < 50
        expect(result.matches.size).to eq 0
      end
    end

    context 'when the texts are really different' do
      it 'returns a NOT fraud result' do
        result = described_class.analyze('Homework done by a student without checking or copying from internet', 'This text from Internet is really useful for students and it can be copied easily.')

        expect(result.fraud?).to be false
        expect(result.fraud_level).to be < 20
        expect(result.matches.size).to eq 0
      end
    end

    context 'when a complete paragraph of the text is fraud' do
      it 'returns a fraud result' do
        text_from_student = p %{
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus posuere elit purus, vitae commodo felis molestie non. Maecenas ante sapien, euismod nec mi at, aliquam hendrerit libero.
          Mauris lacinia odio id nunc ultricies aliquam. Vivamus ultrices facilisis eros, sit amet tincidunt sem accumsan eu. Pellentesque sed leo ut velit iaculis ultrices. Nunc viverra malesuada
          laoreet. Proin pulvinar dui quis leo laoreet, sed mattis tortor commodo.

          Sherlock Holmes and Dr. Watson find themselves in a university town when a tutor and lecturer of St Luke's College, Mr. Hilton Soames, brings him an interesting problem. Soames had been 
          reviewing the galley proofs of an exam he was going to give when he left his office for an hour. When he returned, he found that his servant, Bannister, had entered the room but accidentally
          left his key in the lock when he left, and someone had disturbed the exam papers on his desk and left traces that show it had been partially copied. Bannister is devastated and collapses
          on a chair, but swears that he did not touch the papers. Soames found other clues in his office: pencil shavings, a broken pencil lead, a fresh cut in his desk surface, and a small blob of
          black clay speckled with sawdust.

          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus posuere elit purus, vitae commodo felis molestie non. Maecenas ante sapien, euismod nec mi at, aliquam hendrerit libero.
          Mauris lacinia odio id nunc ultricies aliquam. Vivamus ultrices facilisis eros, sit amet tincidunt sem accumsan eu. Pellentesque sed leo ut velit iaculis ultrices. Nunc viverra malesuada laoreet.
          Proin pulvinar dui quis leo laoreet, sed mattis tortor commodo.
        }

        text_from_internet = p %{
          Sherlock Holmes and Dr. Watson find themselves in a university town when a tutor and lecturer of St Luke's College, Mr. Hilton Soames, brings him an interesting problem. Soames had been 
          reviewing the galley proofs of an exam he was going to give when he left his office for an hour. When he returned, he found that his servant, Bannister, had entered the room but accidentally
          left his key in the lock when he left, and someone had disturbed the exam papers on his desk and left traces that show it had been partially copied. Bannister is devastated and collapses
          on a chair, but swears that he did not touch the papers. Soames found other clues in his office: pencil shavings, a broken pencil lead, a fresh cut in his desk surface, and a small blob of
          black clay speckled with sawdust.
        }

        result = described_class.analyze(text_from_student, text_from_internet)

        expect(result.fraud?).to be true
        expect(result.fraud_level).to be > 99
      end
    end

    context 'when a complete paragraph of the text is fraud but with some little changes' do
      it 'returns a fraud result' do
        text_from_student = p %{
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus posuere elit purus, vitae commodo felis molestie non. Maecenas ante sapien, euismod nec mi at, aliquam hendrerit libero.
          Mauris lacinia odio id nunc ultricies aliquam. Vivamus ultrices facilisis eros, sit amet tincidunt sem accumsan eu. Pellentesque sed leo ut velit iaculis ultrices. Nunc viverra malesuada
          laoreet. Proin pulvinar dui quis leo laoreet, sed mattis tortor commodo.

          Sherlock Holmes and Dr. Watson SOME TEXT TO DISTRACT find themselves in a university town when a tutor and CHANGES lecturer of St Luke's College, Mr. Hilton Soames, brings him an interesting
          problem. Soames had been CHANGING TEXT reviewing the galley proofs of an exam he was going to give DISTRACTING when he left his office for an hour. When he returned, WOW AWESOME CHANGE he found
          that I'M AN INTELLIGENT STUDENT his servant, Bannister, had entered the room but accidentally left his key in the lock when he left, THE BEST FRAUD EVER and someone had disturbed the exam papers
          on his desk and left traces that show it had been partially copied. Bannister is devastated and collapses WELCOME TO MY COPIED TEXT on a chair, but swears that he did not touch the papers. Soames 
          TEACHERS NEVER READ THE HOMEWORK found other clues in his office: pencil shavings, a broken pencil lead, a fresh cut in his desk surface, and a small blob of LONG TEXT HERE TO DISTRACT
          black clay speckled with sawdust.

          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus posuere elit purus, vitae commodo felis molestie non. Maecenas ante sapien, euismod nec mi at, aliquam hendrerit libero.
          Mauris lacinia odio id nunc ultricies aliquam. Vivamus ultrices facilisis eros, sit amet tincidunt sem accumsan eu. Pellentesque sed leo ut velit iaculis ultrices. Nunc viverra malesuada laoreet.
          Proin pulvinar dui quis leo laoreet, sed mattis tortor commodo.
        }

        text_from_internet = p %{
          Sherlock Holmes and Dr. Watson find themselves in a university town when a tutor and lecturer of St Luke's College, Mr. Hilton Soames, brings him an interesting problem. Soames had been 
          reviewing the galley proofs of an exam he was going to give when he left his office for an hour. When he returned, he found that his servant, Bannister, had entered the room but accidentally
          left his key in the lock when he left, and someone had disturbed the exam papers on his desk and left traces that show it had been partially copied. Bannister is devastated and collapses
          on a chair, but swears that he did not touch the papers. Soames found other clues in his office: pencil shavings, a broken pencil lead, a fresh cut in his desk surface, and a small blob of
          black clay speckled with sawdust.
        }

        result = described_class.analyze(text_from_student, text_from_internet)

        expect(result.fraud?).to be true
        expect(result.fraud_level).to be > 60
      end
    end
  end
end
