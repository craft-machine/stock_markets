# frozen_string_literal: true

require 'test_helper'

module StockMarkets
  describe 'FileDataProcessor' do
    let(:file_data_processor) { StockMarkets::FileDataProcessor.new }

    before do
      StockMarkets.configure do |config|
        config.data_file_path = 'test/helpers/example_data.csv'
      end
    end

    describe '#load_from_disk' do
      subject { file_data_processor.load_from_disk }

      describe 'when file exists' do
        it 'returns instance of FileDataProcessor' do
          expected = subject.class
          assert_equal(expected, file_data_processor.class)
        end

        it 'adds parsed csv rows to data attribute' do
          expected = CSV.table(StockMarkets.configuration.data_file_path)
          assert_equal(expected, subject.data)
        end
      end

      describe 'when file does not exist' do
        before do
          StockMarkets.configure do |config|
            config.data_file_path = 'some/fake/path'
          end
        end

        it 'raise an error' do
          assert_raises Errno::ENOENT do
            subject
          end
        end
      end
    end

    describe '#transform_to_hash' do
      subject { parsed_csv.transform_to_hash }

      let(:parsed_csv) { file_data_processor.load_from_disk }

      describe 'when there is valid object in data attribute' do
        it 'returns instance of Hash in data attribute' do
          expected = subject.data.class
          assert_equal(expected, Hash)
        end

        it 'returns instance of FileDataProcessor' do
          expected = subject.class
          assert_equal(expected, StockMarkets::FileDataProcessor)
        end

        it 'transforms data attribute into hash' do
          expected = subject.data.class
          assert_equal(expected, Hash)
        end
      end

      describe 'when data attribute was rewrote before to not CSV::Table object' do
        it 'raises an error' do
          parsed_csv.data = []
          assert_raises TypeError do
            subject
          end
        end
      end
    end

    describe '#load_data!' do
      subject { file_data_processor.load_data! }

      it 'extracts data from csv and trarform it to hash to hash' do
        assert_equal(subject.class, Hash)
      end
    end
  end
end
