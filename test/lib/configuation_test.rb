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

    describe '#source_file_url' do
      it "default value is url to source ile" do
        data_file_path = Configuration.new.source_file_url
        expected_file_path = 'https://www.iso20022.org/sites/default/files/ISO10383_MIC/ISO10383_MIC.csv'
        assert_equal data_file_path, expected_file_path
      end
    end

    describe '#source_file_url=' do
      it 'can set value' do
        config = Configuration.new
        config.source_file_url = 'some_url'
        assert_equal 'some_url', config.source_file_url
      end
    end
  end
end
