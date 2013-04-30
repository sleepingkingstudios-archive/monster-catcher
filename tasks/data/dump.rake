# tasks/data/dump.rake

namespace :data do
  task :dump => [:environment, :logger, :mongoid] do
    pattern = MonsterCatcher.root.join 'lib', 'monster_catcher', 'models', '**', '*.rb'
    Dir.glob(pattern).each do |file| require file; end
    
    include MonsterCatcher::Models
    
    Explore::Region.destroy_all
    Explore::Node.destroy_all
    
    Monsters::Species.destroy_all
    Monsters::Technique.destroy_all
  end # task
end # namespace
