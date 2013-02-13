# config/logger.rb

require 'sinatra'
require 'logger'
require 'mithril'

root_path = File.dirname(__FILE__).gsub(/config$/,'')
file_name = {
  :development => "development.log",
  :test        => "spec.log"
}[Sinatra::Base.environment]

if file_name.nil?
  log_path = nil
else
  log_path = File.join root_path, 'log', file_name

  File.exists?(log_path) ?
    File.truncate(log_path, 0) :
    File.write(log_path, '')
end # if-else

Mithril.logger = Logger.new log_path
Mithril.logger.formatter = Proc.new do |severity, datetime, progname, message|
  "#{severity}: #{message}\n"
end # formatter
Mithril.logger << "Initializing logger, ENV = #{Sinatra::Base.environment}\n"
