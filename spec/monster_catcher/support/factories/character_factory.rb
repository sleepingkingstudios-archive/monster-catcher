# spec/monster_catcher/support/factories/character_factory.rb

require 'monster_catcher/models/character'

FactoryGirl.define do
  sequence :character_name do |index| "character_#{index}"; end
  
  factory :character, :class => MonsterCatcher::Models::Character do
    user
    
    name { generate :character_name }
  end # factory
end # define
