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

    describe '#load_from_disk!' do
      subject { file_data_processor.load_from_disk! }

      describe 'when file exists' do
        it 'returns instance of CSV::Table' do
          expected = subject.class
          assert_equal(expected, CSV::Table)
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
      subject { file_data_processor.transform_to_hash }

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

        describe 'when keyword parameter key_name is provided' do
          describe 'when parameter under this name is present in data for market' do
            subject { file_data_processor.transform_to_hash(key_name: :country) }
            let(:stock_market_with_country) { CSV.table(StockMarkets.configuration.data_file_path).reject { |r| r[:country].nil? }[0] }

            it 'builds a hash with data from key_name as key' do
              assert_equal(subject.data.first.first, stock_market_with_country[:country])
            end
          end
        end

        describe 'when file contains also data about inactive markets(by status field)' do
          let(:active_market_status_name) { StockMarkets::FileDataProcessor::ACTIVE_MARKET_STATUS_NAME }
          let(:all_rows_from_csv) { CSV.table(StockMarkets.configuration.data_file_path) }
          let(:inactive_markets) { all_rows_from_csv.select { |row| row[:status] != active_market_status_name } }

          before do
            StockMarkets.configure do |config|
              config.data_file_path = 'test/helpers/example_data_with_inactive_markets_by_status_field.csv'
            end
          end

          it 'includes only active stock markets in result set' do
            expected = all_rows_from_csv.count - inactive_markets.count
            assert_equal(subject.data.count, expected)
          end
        end

        describe 'when file contains also data about inactive markets(by status_date field)' do
          let(:all_rows_from_csv) { CSV.table(StockMarkets.configuration.data_file_path) }
          let(:inactive_markets) { all_rows_from_csv.select { |row| Date.parse(row[:status_date]).year < Date.today.year - StockMarkets::FileDataProcessor::LAST_UPDATE_MARKET_MINIMAL_YEARS_COUNT } }

          before do
            StockMarkets.configure do |config|
              config.data_file_path = 'test/helpers/example_data_with_old_markets.csv'
            end
          end

          it 'includes only active stock markets in result set' do
            expected = all_rows_from_csv.count - inactive_markets.count
            assert_equal(subject.data.count, expected)
          end
        end
      end
    end

    describe '#load_from_disk!' do
      subject { file_data_processor.load_from_disk! }

      it 'extracts data from csv and trarforms it to hash(returns instance of StockMarkets::FileDataProcessor)' do
        assert_equal(subject.class, CSV::Table)
      end
    end

    describe '#load_data_for_mics!' do
      subject { file_data_processor.load_data_for_mics! }

      let(:mic_sample) { CSV.table(StockMarkets.configuration.data_file_path)[0][:mic] }

      it 'extracts data from csv and trarforms it to hash' do
        assert_equal(subject.class, Hash)
      end

      it 'returns hash in data with MICs of markets as keys' do
        assert_equal(subject.first.first, mic_sample)
      end
    end
  end
end
