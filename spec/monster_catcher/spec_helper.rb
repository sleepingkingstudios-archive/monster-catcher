# spec/monster_catcher/spec_helper.rb

require 'rspec'
require 'factory_girl'
require 'database_cleaner'

require 'mithril/spec_helper'

root_path = File.dirname(__FILE__).gsub('spec/monster_catcher', '/')

#=# Require Environment #=#
require File.join root_path, "config", "environment"

#=# Require Extensions #=#
Dir[root_path + "lib/monster_catcher/extensions/**/*.rb"].each { |f| require f }

#=# Connect to Datastore #=#
require 'mongoid'
Mongoid.load! File.join(root_path, 'config', 'mongoid.yml'), :test

#=# Require Factories, Custom Matchers, &c #=#
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each { |f| require f }

DatabaseCleaner.strategy = :truncation

RSpec.configure do |config|
  config.color_enabled = true
  config.include(MonsterCatcher::Support::Matchers)
  
  config.after :each do
    DatabaseCleaner.clean
  end # after each
end # config
