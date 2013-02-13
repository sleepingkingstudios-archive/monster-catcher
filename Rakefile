# Rakefile

task :console => [:environment, :logger, :mongoid] do
  require 'irb'
  
  root_path = File.dirname(__FILE__)
  Dir[root_path + "/lib/monster_catcher/models/*.rb"].each { |f| require f }
  
  include MonsterCatcher::Models
  
  ARGV.clear
  IRB.start
end # task console

task :default => :interactive

task :environment do
  require File.join File.dirname(__FILE__), 'config', 'environment'
end # task

task :interactive => [:environment, :logger, :mongoid] do
  require 'monster_catcher/controllers/routing_controller'
  require 'mithril/request'
  
  Mithril.logger << "~~~~~\nBegin interactive session...\n\n"
  
  puts "Welcome to Monster Catcher!"
  print "> "
  
  request = Mithril::Request.new
  
  while input = STDIN.gets.strip
    Mithril.logger.info "input = #{input}"
    
    if input =~ /quit/i
      puts "Thanks for playing!"
      break
    end # if
    
    controller = MonsterCatcher::Controllers::RoutingController.new request
    
    puts controller.invoke_command input
    puts request.session.inspect
    print "> "
  end # while
end # task

task :logger do
  root_path = File.dirname(__FILE__)
  require File.join root_path, 'config', 'logger'
end # task

task :mongoid do
  require 'mongoid'
  Mongoid.load! File.join(File.dirname(__FILE__), 'config', 'mongoid.yml'), :development
end # task
