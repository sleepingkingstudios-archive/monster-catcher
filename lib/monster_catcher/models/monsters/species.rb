# lib/monster_catcher/models/monsters/species.rb

require 'monster_catcher/models/monsters'

module MonsterCatcher::Models::Monsters
  class Species
    include Mongoid::Document
    
    field :name,  :type => String
    field :types, :type => Array
    
    field :hit_points,       :type => Integer
    field :physical_attack,  :type => Integer
    field :physical_defense, :type => Integer
    field :special_attack,   :type => Integer
    field :special_defense,  :type => Integer
  end # class
end # module
