# frozen_string_literal: true
require 'csv'

module StockMarkets
  class FileDataProcessor
    LAST_UPDATE_MARKET_MINIMAL_YEARS_COUNT = 2
    ACTIVE_MARKET_STATUS_NAME = 'ACTIVE'
    MARKET_NAME_CSV_COLUMN = :nameinstitution_description

    attr_accessor :data

    def initialize
      @data = []
      @parsed_csv = load_from_disk!
    end

    def load_from_disk!
      self.parsed_csv = CSV.table(StockMarkets.configuration.data_file_path)
    end

    def transform_to_hash(key_name: :mic)
      raise TypeError, 'Invalid object of CSV provided!' unless parsed_csv.instance_of?(CSV::Table)

      self.data = parsed_csv.each_with_object({}) do |data_row, result_hash|
        if market_recently_updated_proc.call(data_row, key_name)
          result_hash[data_row[key_name.to_sym]] =  data_row.to_h
        end
      end
      self
    end

    def load_data_for_mics!
      transform_to_hash.data
    end

    def load_data_for_names!
      transform_to_hash(key_name: MARKET_NAME_CSV_COLUMN).data
    end

    private

    attr_accessor :parsed_csv

    def last_update_market_minimal_date
      return @_last_update_market_minimal_date if @_last_update_market_minimal_date

      current_month_date = Date.today - Date.today.mday + 1

      @_last_update_market_minimal_date = Date.new(current_month_date.year - LAST_UPDATE_MARKET_MINIMAL_YEARS_COUNT, 1, 1)
    end

    def market_recently_updated_proc
      @_market_recently_updated_proc ||= proc do |data_row, key_name|
        (Date.parse(data_row[:status_date]) >= last_update_market_minimal_date) && 
        data_row[:status] == ACTIVE_MARKET_STATUS_NAME &&
        !data_row[key_name].nil?
      end
    end
  end
end
