# Rakefile

task :console => "data:models" do
  require 'irb'
  
  include MonsterCatcher::Models
  
  ARGV.clear
  IRB.start
end # task console

namespace :data do
  def get_yaml(*path)
    path = File.join @remote_root, *path
    YAML::load open path
  end # method get_yaml
  
  task :dump => "data:models" do
    include MonsterCatcher::Models
    
    Explore::Region.destroy_all
    Explore::Node.destroy_all
  end # task
  
  task :load => :dump do
    require 'open-uri'
    
    @remote_root = 'https://raw.github.com/sleepingkingstudios/hinomoto/master/'
    
    manifest = get_yaml 'manifest.yml'
    
    region_paths = []
    node_paths   = {}
    
    manifest["regions"].each do |region, nodes|
      if region =~ /.yml$/
        region_paths << File.join('regions', region)
      elsif !nodes.nil?
        node_paths[region] ||= []
        nodes.each do |node, value|
          node_paths[region] << File.join('regions', region, node)
        end # each
      end # elsif
    end # each
    
    region_paths.each do |path| Explore::Region.create get_yaml path; end
    
    node_paths.each do |key, paths|
      region = Explore::Region.find_by(:key => key)
      
      paths.each do |path|
        node = Explore::Node.new get_yaml path
        node.region = region
        node.save
        
        edges = node.instance_variable_get :@edges
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
