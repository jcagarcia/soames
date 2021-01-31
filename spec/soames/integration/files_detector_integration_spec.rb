require 'spec_helper'
require 'soames'

RSpec.describe Soames do
  let(:local_files_folder) do
    "#{File.dirname(__FILE__)}/../../utils/local_files/integration"
  end

  before do
    Soames.configure do |config|
      config.detectors = [
        Soames::Detectors::FilesDetector.new(folder: local_files_folder)
      ]
    end
  end

  describe '.check_fraud' do
    context 'when part of the text has been copied' do
      let(:text_to_check) do
        p %{
          This text has been made by an student. At the beginning everything seems to be ok. No copy, and no fraud detected here. However, after some lines...

          Sherlock Holmes and Dr. Watson find themselves SOMETIMES THE STUDENT INTRODUCES CHANGES TO PREVENT FRAUD DETECTORS in a university town when a tutor and lecturer 
          of St Luke's College, Mr. Hilton Soames, brings him MORE CHANGES HERE TO PREVENT DETECTORS OF FRAUD
          an interesting problem. Soames had been reviewing the galley proofs of an exam he was going to give when he left his office for an hour. When he returned,
          he found that his servant, MORE SENTENCES WRITTEN BY THE STUDENT TO PREVENT FRAUD
          Bannister, had entered the room but accidentally left his key in the lock when he left, and someone had disturbed the exam papers on his desk and left traces that show 
          it had been partially copied. Bannister I'M THE BEST STUDENT, THIS FRAUD IS NOT DETECTABLE is devastated and collapses on a chair, but swears that he did not touch the papers.
          Soames found other clues in his office: pencil shavings, ALSO THE TEACHERS NEVER READ OUR COMPLETE TEXTS, SO MY TEACHER WILL NOT REALIZE ABOUT THE FRAUD
          a broken pencil lead, a fresh cut in his desk surface, and a small blob of black clay speckled with sawdust. Soames wants to uncover the cheater and prevent him from taking the exam,
          since it is for a sizeable scholarship. Three students who will take the exam live above him in the same building. The first, FRAUD FRAUD Gilchrist, is athletic, being a hurdler and a long-jumper,
          and industrious (in contrast MORE CHANGES MORE MORE STUDENT CHANGES to his father who squandered his fortune in horse racing); MORE CHANGES HERE TO PREVENT FRAUD the second, Daulat Ras, is described as quiet and methodical; the third is Miles McLaren, 
          a gifted man but thoroughly dissolute and given to gambling. CHANGING HERE

          After this copied paragraph, the text continues without any kind of copy or fraud.
        }
      end

      it 'returns a complete information about the fraud analysis' do
        result = Soames.check_fraud(text_to_check)

        expect(result.original_text).to eq(text_to_check)
        expect(result.fraud?).to be true
        expect(result.fraud_level).to eq(81.14)

        detector_results = result.detectors_results

        expect(detector_results.size).to eq 1

        check_files_detector(detector_results)
      end

      private

      def check_files_detector(detector_results)
        files_detector_result = detector_results.find do |detector|
          detector.detector_name == 'files_detector'
        end

        expect(files_detector_result.detector_name).to eq 'files_detector'
        expect(files_detector_result.fraud?).to be true
        expect(files_detector_result.fraud_level).to eq(81.14)

        sources = files_detector_result.sources

        expect(sources.size).to eq 4
        expect(sources[0].source_name).to include('The Adventure of the Three Students.docx')
        expect(sources[0].fraud_level).to eq(76.17)
        expect(sources[0].fraud?).to be true
        expect(sources[0].matches.size).to eq(9)

        expect(sources[1].source_name).to include('The Adventure of the Three Students.pdf')
        expect(sources[1].fraud_level).to eq(81.14)
        expect(sources[1].fraud?).to be true
        expect(sources[1].matches.size).to eq(9)

        expect(sources[2].source_name).to include('The Adventure of the Three Students.odt')
        expect(sources[2].fraud_level).to eq(76.17)
        expect(sources[2].fraud?).to be true
        expect(sources[2].matches.size).to eq(9)

        expect(sources[3].source_name).to include('The Adventure of the Three Students.txt')
        expect(sources[3].fraud_level).to eq(76.17)
        expect(sources[3].fraud?).to be true
        expect(sources[3].matches.size).to eq(9)
      end
    end

    context 'when NOT fraud in any of the checked files' do
      let(:text_to_check) do
        "A txt content"
      end

      it 'returns a complete information about the fraud analysis' do
        result = Soames.check_fraud(text_to_check)

        expect(result.original_text).to eq(text_to_check)
        expect(result.fraud?).to be false
        expect(result.fraud_level).to eq(0.0)

        detector_results = result.detectors_results

        expect(detector_results.size).to eq 1

        check_files_detector(detector_results)
      end

      it 'the result can be represented as a hash' do
        result = Soames.check_fraud(text_to_check)

        expect(result.to_h).to eq({
          original_text: text_to_check,
          fraud?: false,
          fraud_level: 0.0,
          detectors_results: [
            {
              detector_name: 'files_detector',
              fraud?: false,
              fraud_level: 0.0,
              sources: []
            }
          ]
        })
      end

      private

      def check_files_detector(detector_results)
        files_detector_result = detector_results.find do |detector|
          detector.detector_name == 'files_detector'
        end

        expect(files_detector_result.detector_name).to eq 'files_detector'
        expect(files_detector_result.fraud?).to be false
        expect(files_detector_result.fraud_level).to eq(0.0)

        sources = files_detector_result.sources

        expect(sources.size).to eq 0
      end
    end
  end
end
