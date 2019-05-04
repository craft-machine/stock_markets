require 'json'
require 'csv'

module StockMarkets
  class FileDataProcessor
    attr_accessor :data

    def initialize
      @data = []
    end

    def load_from_disk
      self.data = CSV.table(StockMarkets.configuration.data_file_path)
      self
    end

    def transform_to_hash
      raise TypeError, 'Invalid object of CSV provided!' unless data.instance_of?(CSV::Table)

      self.data = data.map do |data_row| 
        [data_row[:mic] || data_row[:name], data_row.to_h]
      end.to_h
      self
    end

    def load_data!
      load_from_disk.transform_to_hash.data
    end
  end
end
