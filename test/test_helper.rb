$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'stock_markets'
require 'webmock/minitest'
require 'minitest/autorun'
require 'mocha/minitest'

include WebMock::API

file_data = File.read('test/helpers/example_data.csv')
WebMock.disable_net_connect!(allow: Regexp.new("https://www.iso20022.org"))
stub_request(:any, Regexp.new("https://www.iso20022.org")).with(body: file_data)
