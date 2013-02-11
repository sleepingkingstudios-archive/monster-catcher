# spec/monster_catcher/spec_helper.rb

require 'rspec'
require 'factory_girl'

require 'mithril/spec_helper'

root_path = File.dirname(__FILE__).gsub('spec/monster_catcher', '/')

#=# Require Environment #=#
require File.join root_path, "config", "environment"

#=# Connect to Datastore #=#
require 'mongoid'
Mongoid.load! File.join(root_path, 'config', 'mongoid.yml'), :test

#=# Require Factories, Custom Matchers, &c #=#
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.color_enabled = true
  config.include(MonsterCatcher::Support::Matchers)
end # config
