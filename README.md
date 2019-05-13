# StockMarkets

[![Build Status](https://travis-ci.org/craft-machine/stock_markets.png?branch=master)](https://travis-ci.org/craft-machine/stock_markets)
[![Inline docs](https://inch-ci.org/github/craft-machine/stock_markets.svg?branch=master)](https://inch-ci.org/github/craft-machine/stock_markets)


This gem provides information about stock markets.
Supported ruby version starts from 2.3.1

## Bug reports

If you discover a problem with StockMarkets gem, please report it to:
https://github.com/craft-machine/stock_markets/issues

## Data source
https://www.iso20022.org/10383/iso-10383-market-identifier-codes - origin for data files

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'stock_markets'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install stock_markets

## Usage

To interact with markets data use class `StockMarkets::Markets`. This class provides `Enumerable` on class level.
Examples of using:

```ruby
# To get information about markets as hash, where key - MIC of market, value - market data
StockMarkets::Markets.table #=>  {"AIXK"=>{:continent=>"Asia", :country=>"Kazakhstan ", :name=>"....} }

# Some markets can be without mic in data source, that's why if you want get some additional information, you can use table_for_names
StockMarkets::Markets.table_for_names #=> { "TEMATIC INTERNALISER"=>{:country=>"FRANCE", :iso_country_code_iso_3166=>"FR", :mic=>"SGOE", ...} }

# To get information about markets as array(array of data for all markets)
StockMarkets::Markets.data_list #=> [{:continent=>"Asia", :country=>"Kazakhstan ", :name=>"Astana Internat..."}]

# Also you can iterate over markets with help of Enumerable module:
StockMarkets::Markets.map do |market|
  market[:country]
end
#=> ["GERMANY", "SWEDEN", ...]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/stock_markets. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the StockMarkets project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/stock_markets/blob/master/CODE_OF_CONDUCT.md).
