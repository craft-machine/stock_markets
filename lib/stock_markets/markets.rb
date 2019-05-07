module StockMarkets
  class Markets
    extend Enumerable

    class << self
      def each(&block)
        stock_markets.values.each do |stock|
          block.call(stock)
        end
      end

      def [](stock_name_or_mic)
        stock_markets[stock_name_or_mic]
      end

      def data_list
        stock_markets.values
      end

      def table
        stock_markets
      end

      private

      def stock_markets
        @_stock_markets ||= FileDataProcessor.new.load_data!
      end
    end
  end
end
