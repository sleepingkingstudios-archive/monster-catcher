# lib/monster_catcher/models/monsters/species.rb

require 'monster_catcher/models/monsters'
require 'monster_catcher/models/monsters/monster'

module MonsterCatcher::Models::Monsters
  class Species
    include Mongoid::Document
    
    field :name,  :type => String
    field :types, :type => Array
    
    field :hit_points,       :type => Float
    field :physical_attack,  :type => Float
    field :physical_defense, :type => Float
    field :special_attack,   :type => Float
    field :special_defense,  :type => Float
    field :speed,            :type => Float
    
    def attribute_keys
      [ "hit_points", "physical_attack", "physical_defense", "special_attack",
        "special_defense", "speed" ]
    end # method attribute_keys
    
    def build level, params = {}
      config = { :species => self,
        :name => params[:name] || self.name,
        :types => types,
        :level => level,
      } # end attributes
      
      attribute_keys.each do |key|
        config[key] = self[key] * (50 + 2 * level)
      end # each
      
      return Monster.new config
    end # method build
  end # class
end # module
