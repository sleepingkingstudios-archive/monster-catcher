# config/environment.rb

require 'rubygems'
require 'bundler'

Bundler.require

root_path = File.dirname(__FILE__).gsub('/config','')

$LOAD_PATH << File.join(root_path, 'lib')

#=# Require Initializers #=#
Dir[root_path + "lib/monster_catcher/extensions/**/*.rb"].each { |f| require f }
