# config.ru

root_path = File.dirname(__FILE__)

require File.join root_path, 'config', 'environment'

#=# Require Initializers #=#
Dir[root_path + "lib/monster_catcher/extensions/**/*.rb"].each { |f| require f }

require File.join root_path, 'app'

run MonsterCatcher::App
