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
      describe 'when file exists' do
        it 'returns instance of FileDataProcessor' do
          expected = file_data_processor.load_from_disk.class
          assert_equal(expected, file_data_processor.class)
        end

        it 'adds parsed csv rows to data attribute' do
          expected = CSV.table(StockMarkets.configuration.data_file_path)
          assert_equal(expected, file_data_processor.load_from_disk.data)
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
            file_data_processor.load_from_disk
          end
        end
      end
    end

    describe '#transform_to_hash' do
      describe 'when there is valid object in data attribute' do
        it 'returns instance of Hash in data attribute' do
          expected = file_data_processor.load_from_disk.transform_to_hash.data.class
          assert_equal(expected, Hash)
        end

        it 'returns instance of FileDataProcessor' do
          expected = file_data_processor.load_from_disk.transform_to_hash.class
          assert_equal(expected, StockMarkets::FileDataProcessor)
        end

        it 'transform data attribute into hash' do
          expected = file_data_processor.load_from_disk.transform_to_hash.data.class
          assert_equal(expected, Hash)
        end
      end

      describe 'when data attribute was rewrote before to not CSV::Table object' do
        it 'raise an error' do
          previous_state = file_data_processor.load_from_disk
          previous_state.data = []
          assert_raises TypeError do
            previous_state.transform_to_hash
          end
        end
      end
    end

    describe '#load_data!' do
    end
  end
end
