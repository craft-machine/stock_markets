module StockMarkets
  class Markets
    extend Enumerable

    class << self
      def each(&block)
        stock_markets_with_mics.values.each do |stock|
          block.call(stock)
        end
      end

      def [](stock_mic)
        stock_markets_with_mics[stock_mic]
      end

      def data_list
        stock_markets_with_mics.values
      end

      def table
        stock_markets_with_mics
      end

      def table_for_names
        stock_markets_with_names
      end

      private

      def stock_markets_with_mics
        @_stock_markets_with_mics ||= file_data_processor_data.load_data_for_mics!
      end

      def stock_markets_with_names
        @_stock_markets_with_names ||= file_data_processor_data.load_data_for_names!
      end

      def file_data_processor_data(file_data_processor_klass = FileDataProcessor)
        @_file_data_processor_data ||= file_data_processor_klass.new.load_from_disk!
      end
    end
  end
end
