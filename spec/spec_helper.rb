$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'onnistuu_fi'
require 'rspec-html-matchers'

RSpec.configure do |config|
  config.include RSpecHtmlMatchers
end
