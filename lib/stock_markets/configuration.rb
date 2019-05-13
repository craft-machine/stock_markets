# frozen_string_literal: true

# global namespace of this gem
module StockMarkets
  # Class to handle configuration of gem
  class Configuration
    # @!attribute [rw] data_file_path
    # @return [String] absolute filepath to data of stock markets
    attr_accessor :data_file_path

    # class initialization method
    # @return [StockMarkets::Configuration] instance of object for configuration inside of this gem
    def initialize
      @data_file_path = File.expand_path('../../data/stock_markets.csv', __FILE__)
    end
  end
end
