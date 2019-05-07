# frozen_string_literal: true

require 'test_helper'

module StockMarkets
  describe 'Configuration' do
    describe '#data_file_path' do
      it "default value is 'lib/data/stock_markets.csv'" do
        data_file_path = Configuration.new.data_file_path
        expected_file_path = File.expand_path('../../../lib/data/stock_markets.csv', __FILE__)
        assert_equal data_file_path, expected_file_path
      end
    end

    describe '#data_file_path=' do
      it 'can set value' do
        config = Configuration.new
        config.data_file_path = 'helpers/some_data.log'
        assert_equal 'helpers/some_data.log', config.data_file_path
      end
    end
  end
end
