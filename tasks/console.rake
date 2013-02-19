# tasks/console.rake

task :console => [:environment, :logger, :mongoid] do
  require 'irb'
  
  pattern = MonsterCatcher.root.join 'lib', 'monster_catcher', 'models', '**', '*.rb'
  Dir.glob(pattern).each do |file| require file; end
  
  include MonsterCatcher::Models
  
  ARGV.clear
  IRB.start
end # task console
