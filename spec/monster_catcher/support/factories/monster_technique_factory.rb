# spec/monster_catcher/support/factories/monster_technique_factory.rb

require 'monster_catcher/models/monsters/technique'

FactoryGirl.define do
  sequence :monster_technique_name do |index| "Technique_#{index}"; end
  
  factory :monster_technique, :class => MonsterCatcher::Models::Monsters::Technique do
    name { generate :monster_technique_name }
    types [:physical]
    
    damage   100
    accuracy 100
  end # factory
end # define
