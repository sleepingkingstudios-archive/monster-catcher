# lib/monster_catcher/models/monsters/monster.rb

require 'monster_catcher/models/monsters'
require 'monster_catcher/models/monsters/species'

module MonsterCatcher::Models::Monsters
  class Monster
    include Mongoid::Document
    
    field :name,  :type => String
    field :types, :type => Array
    field :level, :type => Integer
    
    field :hit_points,       :type => Integer
    field :physical_attack,  :type => Integer
    field :physical_defense, :type => Integer
    field :special_attack,   :type => Integer
    field :special_defense,  :type => Integer
    
    #=# Relations #=#
    belongs_to :species, :class_name => "MonsterCatcher::Models::Monsters::Species"
    
    #=# Validation #=#
    validates :species, :presence => true
  end # class
end # module
