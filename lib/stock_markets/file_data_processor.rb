# frozen_string_literal: true
require 'csv'
require 'open-uri'


module StockMarkets
  # Class for handling processing of data file. Using configuration class to get absolute filepath to file
  class FileDataProcessor
    # The number of past years for which you need to select data
    LAST_UPDATE_MARKET_MINIMAL_YEARS_COUNT = 2
    # Value of status_date column inside of data file describing active stock market
    ACTIVE_MARKET_STATUS_NAME = 'ACTIVE'
    # Name of columnn with name inside of data file
    MARKET_NAME_CSV_COLUMN = :nameinstitution_description
    # Storing of parsed and mapped data
    # @!attribute [rw] data
    # @return [Hash] hash with data, parsed and mapped from source file
    attr_accessor :data

    # class initialization method
    # @return [StockMarkets::FileDataProcessor] instance of object for file data processing
    def initialize
      @data = []
      @parsed_csv = load_from_network || load_from_disk!
    end

    # method launches parsing of csv data file
    # @return [CSV::Table] instance of csv table
    def load_from_disk!
      CSV.table(StockMarkets.configuration.data_file_path)
    end

    # method launches downloading csv file and saving it to gem directory
    # @return [CSV::Table] instance of csv table
    def load_from_network
      file_path = StockMarkets.configuration.data_file_path
      File.open(file_path, 'w') do |_f|
        uri = URI.parse(StockMarkets.configuration.source_file_url)
        download = uri.open
        IO.copy_stream(download, file_path)
        CSV.new(download).each do |l|
          p l
        end
      end
      CSV.table(file_path)
    rescue SocketError
      puts 'No network or source is unavailable. Trying to load from local...'
    rescue OpenURI::HTTPError
      puts 'Invalid source_file_url provided. Trying to load from local...'
    end

    # method transforming csv table to hash and writing to data instance attribute 
    # @param key_name[Symbol] the name of column for csv data file
    # @raise [TypeError] raises if parsed_csv instance attribute not contains instance of CSV::Table
    # @return [StockMarkets::FileDataProcessor] instance with filled data instance attribute
    def transform_to_hash(key_name: :mic)
      raise TypeError, 'Invalid object of CSV provided!' unless parsed_csv.instance_of?(CSV::Table)

      self.data = parsed_csv.each_with_object({}) do |data_row, result_hash|
        if market_recently_updated_proc.call(data_row, key_name)
          result_hash[data_row[key_name.to_sym]] = data_row.to_h
        end
      end
      self
    end

    # method loads hash data.
    # @return [Hash] with MICs of stock markets as keys and their data as values
    def load_data_for_mics!
      transform_to_hash.data
    end

    # method loads hash data.
    # @return [Hash] with Names of stock markets as keys and their data as values
    def load_data_for_names!
      transform_to_hash(key_name: MARKET_NAME_CSV_COLUMN).data
    end

    private

    attr_accessor :parsed_csv

    # @private calculates minimum bound of stock markets' last data update
    def last_update_market_minimal_date
      return @_last_update_market_minimal_date if @_last_update_market_minimal_date

      current_month_date = Date.today - Date.today.mday + 1

      @_last_update_market_minimal_date = Date.new(current_month_date.year - LAST_UPDATE_MARKET_MINIMAL_YEARS_COUNT, 1, 1)
    end

    # @private returns proc, that selects recently updated stock markets
    def market_recently_updated_proc
      @_market_recently_updated_proc ||= proc do |data_row, key_name|
        (Date.parse(data_row[:status_date]) >= last_update_market_minimal_date) && 
        data_row[:status] == ACTIVE_MARKET_STATUS_NAME &&
        !data_row[key_name].nil?
      end
    end
  end
end
