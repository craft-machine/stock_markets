# frozen_string_literal: true

module StockMarkets
  class Configuration
    attr_accessor :data_file_path

    def initialize
      @data_file_path = File.expand_path('../../data/stock_markets.csv', __FILE__)
    end
  end
end
