# tasks/mongoid.rake

task :mongoid => :environment do
  require 'mongoid'
  
  Mongoid.load! MonsterCatcher.root.join('config', 'mongoid.yml'), Sinatra::Base.environment
end # task
