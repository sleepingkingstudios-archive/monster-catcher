# spec/monster_catcher/support/factories/monster_factory.rb

require 'monster_catcher/models/monsters/monster'

FactoryGirl.define do
  sequence :monster_name do |index| "Monster #{index}"; end
  
  factory :monster, :class => MonsterCatcher::Models::Monsters::Monster do
    species { create :monster_species }
    
    name  { generate :monster_name }
    types []
    level 50
    
    hit_points       { species.hit_points       * level / 100 }
    physical_attack  { species.physical_attack  * level / 100 }
    physical_defense { species.physical_defense * level / 100 }
    special_attack   { species.special_attack   * level / 100 }
    special_defense  { species.special_defense  * level / 100 }
  end # factory
end # define
