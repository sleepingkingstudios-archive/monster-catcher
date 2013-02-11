# Rakefile

task :application => [:database, :environment]

task :database do
  require 'yaml'
  require 'mongo_mapper'
  config = YAML::load File.read File.join File.dirname(__FILE__), 'config', 'database.yml'
  MongoMapper.setup(config, 'development')
end # task

task :environment do
  require File.join File.dirname(__FILE__), 'config', 'environment'
end # task

task :mongoid do
  require 'mongoid'
  Mongoid.load! File.join(File.dirname(__FILE__), 'config', 'mongoid.yml'), :production
end # task
