# spec/monster_catcher/support/factories/monster_species_factory.rb

require 'monster_catcher/models/monsters/species'

FactoryGirl.define do
  sequence :monster_species_name do |index| "Species_#{index}"; end
  
  factory :monster_species, :class => MonsterCatcher::Models::Monsters::Species do
    name { generate :monster_species_name }
    
    types []
    
    hit_points       1.00
    physical_attack  1.00
    physical_defense 1.00
    special_attack   1.00
    special_defense  1.00
    speed            1.00
  end # factory
end # define
