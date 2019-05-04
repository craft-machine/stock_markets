module StockMarkets
  class Configuration
    attr_accessor :data_file_path

    def initialize
      @data_file_path = 'lib/data/stock_markets.csv'
    end
  end
end
