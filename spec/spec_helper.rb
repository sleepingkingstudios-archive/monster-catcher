# spec/spec_helper.rb

require 'rspec'
require 'factory_girl'

RSpec.configure do |config|
  config.color_enabled = true
end # config

#=# Require Factories, Custom Matchers, &c #=#
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each { |f| require f }
