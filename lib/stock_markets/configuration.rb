# frozen_string_literal: true

# global namespace of this gem
module StockMarkets
  # Class to handle configuration of gem
  class Configuration
    # @!attribute [rw] data_file_path
    # @return [String] absolute filepath to data of stock markets
    attr_accessor :data_file_path
    # @!attribute [rw] source_file_url
    # @return [String] url for csv file with stock markets
    attr_accessor :source_file_url

    # class initialization method
    # @return [StockMarkets::Configuration] instance of object for configuration inside of this gem
    def initialize
      @data_file_path = File.expand_path('../../data/stock_markets.csv', __FILE__)
      @source_file_url = 'https://www.iso20022.org/sites/default/files/ISO10383_MIC/ISO10383_MIC.csv'
    end
  end
end
