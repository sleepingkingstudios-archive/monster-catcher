# lib/monster_catcher/models/monsters/technique.rb

require 'monster_catcher/models/monsters'

module MonsterCatcher::Models::Monsters
  class Technique
    include Mongoid::Document
    
    field :name,  :type => String
    field :types, :type => Array
    
    field :damage,   :type => Integer
    field :accuracy, :type => Integer
  end # class Technique
end # module
