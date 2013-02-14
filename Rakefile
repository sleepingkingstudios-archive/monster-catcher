# Rakefile

task :console => "data:models" do
  require 'irb'
  
  include MonsterCatcher::Models
  
  ARGV.clear
  IRB.start
end # task console

namespace :data do
  task :dump => "data:models" do
    include MonsterCatcher::Models
    
    Explore::Node.destroy_all
  end # task
  
  task :load => :dump do
    require 'open-uri'
    remote_root   = 'https://raw.github.com/sleepingkingstudios/hinomoto/master/'
    manifest_path = File.join remote_root, 'manifest.yml'
    
    manifest = YAML::load open(manifest_path).read
    
    manifest["regions"].each do |region, nodes|
      nodes.each do |node, value|
        node_path = File.join remote_root, 'regions', region, node
        node_data = YAML::load open node_path
        
        Explore::Node.create node_data
      end # each
    end # each
  end # task load
  
  task :models => [:logger, :mongoid] do
    root_path = File.dirname(__FILE__)
    Dir[root_path + "/lib/monster_catcher/models/**/*.rb"].each { |f| require f }
  end # task
end # namespace

task :default => :interactive

task :environment do
  require File.join File.dirname(__FILE__), 'config', 'environment'
end # task

task :interactive => [:logger, :mongoid] do
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

task :mongoid => :environment do
  require 'mongoid'
  Mongoid.load! File.join(File.dirname(__FILE__), 'config', 'mongoid.yml'), Sinatra::Base.environment
end # task
