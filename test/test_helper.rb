$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'stock_markets'
require 'webmock/minitest'
require 'minitest/autorun'
require 'mocha/minitest'

include WebMock::API

WebMock.disable_net_connect!(allow: Regexp.new("https://www.iso20022.org"))
