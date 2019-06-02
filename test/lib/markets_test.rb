# frozen_string_literal: true

require 'test_helper'

module StockMarkets
  describe 'Markets' do
    let(:markets) { StockMarkets::Markets }

    before do
      StockMarkets.configure do |config|
        config.data_file_path = 'test/helpers/example_data.csv'
      end
      StockMarkets::FileDataProcessor.any_instance.stubs(:load_from_network).returns(nil)
    end

    describe '.table' do
      subject { markets.table }

      it 'returns data from csv file parsed into hash' do
        assert_equal(subject.class, Hash)
      end
    end

    describe '.data_list' do
      subject { markets.data_list }

      it 'returns data about markets as array' do
        assert_equal(subject.class, Array)
      end

      it 'returns data from values of method .table' do
        assert_equal(subject.first, markets.table.first.last)
      end
    end

    describe '.[]' do
      describe 'when market with passed mic is present' do
        subject { markets[existing_market_name] }

        let(:existing_market_name) { markets.table.first.first }
        it 'returns data about market with passed name or mic as hash' do
          assert_equal(subject.class, Hash)
        end
      end

      describe 'when market with passed mic is not present' do
        subject { markets[fake_market_name] }

        let(:fake_market_name) { 'fake name' }
        it 'returns data about market with passed mic as hash' do
          assert_equal(subject.class, NilClass)
        end
      end
    end
  end
end
