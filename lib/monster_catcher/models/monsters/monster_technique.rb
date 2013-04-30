# lib/monster_catcher/models/monsters/monster_technique.rb

require 'monster_catcher/models/monsters'
require 'monster_catcher/models/monsters/monster'
require 'monster_catcher/models/monsters/technique'

module MonsterCatcher::Models::Monsters
  class MonsterTechnique
    include Mongoid::Document
    
    #=# Relations #=#
    embedded_in :monster,  :class_name => "MonsterCatcher::Models::Monsters::Monster"
    belongs_to :technique, :class_name => "MonsterCatcher::Models::Monsters::Technique"
    
    #=# Validation #=#
    validates :monster,   :presence => true
    validates :technique, :presence => true
  end # class
end # module
