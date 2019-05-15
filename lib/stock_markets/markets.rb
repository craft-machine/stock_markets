module StockMarkets
  # Class to access stock markets information.
  class Markets
    # extending default Ruby Enumerable module
    extend Enumerable

    class << self
      # override default each method to iterate over stock_markets(only for stock markets with mics)
      # @return [Array] collection of stock markets with mics
      def each(&block)
        stock_markets_with_mics.values.each do |stock|
          block.call(stock)
        end
      end

      # override default [] method to find stock market by mic
      # @param [String] mic of stock market
      # @return [Hash] data of stock market with passed mic or empty hash if no result
      def [](stock_mic)
        stock_markets_with_mics[stock_mic]
      end

      # calculates and returns data of stock markets with mics
      # @return [Array<Hash>] array of hashes with stock markets' data
      def data_list
        stock_markets_with_mics.values
      end

      # calculates data of stock markets that have mic
      # @return [Hash] hash with stock markets' data with mics as keys and data as values
      def table
        stock_markets_with_mics
      end

      # calculates data of all stock markets
      # @return [Hash] hash with stock markets' data with names as keys and data as values
      def table_for_names
        stock_markets_with_names
      end

      private

      # private. Calls file_data_processor to load data of stock_markets. Have lazy eval.
      # @return [Hash] hash with stock markets' data with mics as keys and data as values k
      def stock_markets_with_mics
        @_stock_markets_with_mics ||= file_data_processor.load_data_for_mics!
      end

      # private. Calls file_data_processor to load data of stock_markets. Have lazy eval.
      # @return [Hash] hash with stock markets' data with names as keys and data as values k
      def stock_markets_with_names
        @_stock_markets_with_names ||= file_data_processor.load_data_for_names!
      end

      # private. Instantiate new object of file_data_processor_klass(passed as param)
      # @param[FileDataProcessor] class name for file data processing
      # @return [FileDataProcessor] instance that using inside of this class
      def file_data_processor(file_data_processor_klass = FileDataProcessor)
        @_file_data_processor ||= file_data_processor_klass.new
      end
    end
  end
end
