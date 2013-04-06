# spec/monster_catcher/support/factories/monster_factory.rb

require 'monster_catcher/models/monsters/monster'

FactoryGirl.define do
  sequence :monster_name do |index| "Monster #{index}"; end
  
  factory :monster, :class => MonsterCatcher::Models::Monsters::Monster do
    species { create :monster_species }
    
    name  { generate :monster_name }
    types []
    level 50
    
    hit_points       { species.hit_points       * (50 + 2 * level) }
    physical_attack  { species.physical_attack  * (50 + 2 * level) }
    physical_defense { species.physical_defense * (50 + 2 * level) }
    special_attack   { species.special_attack   * (50 + 2 * level) }
    special_defense  { species.special_defense  * (50 + 2 * level) }
    speed            { species.speed            * (50 + 2 * level) }
  end # factory
end # define
