# Rakefile

require_relative 'lib/monster_catcher'
Dir.glob(MonsterCatcher.root.join 'tasks', '**', '*.rake').each { |r| import r }

task :default => :interactive
