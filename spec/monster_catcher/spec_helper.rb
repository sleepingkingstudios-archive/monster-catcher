# spec/monster_catcher/spec_helper.rb

require 'rspec'
require 'factory_girl'

require 'mithril/spec_helper'

RSpec.configure do |config|
  config.color_enabled = true
end # config

#=# Require Environment #=#
require File.dirname(__FILE__).gsub('spec/monster_catcher', '/') + "config/environment"

#=# Require Factories, Custom Matchers, &c #=#
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each { |f| require f }
