# spec/monster_catcher/support/factories/explore_region_factory.rb

require 'monster_catcher/models/explore/region'

FactoryGirl.define do
  sequence :explore_region_key do |index| "region_#{index}"; end
  
  factory :explore_region, :class => MonsterCatcher::Models::Explore::Region do
    key { generate :explore_region_key }
    
    name { key.capitalize.gsub('_',' ') }
  end # factory
end # define
