require 'stock_markets/version'
require 'stock_markets/file_data_processor'
require 'stock_markets/markets'
require 'stock_markets/configuration'

module StockMarkets
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
