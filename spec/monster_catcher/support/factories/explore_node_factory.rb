# spec/monster_catcher/support/factories/explore_node_factory.rb

require 'monster_catcher/models/explore/node'

FactoryGirl.define do
  sequence :explore_node_key do |index| "node_#{index}"; end
  
  factory :explore_node, :class => MonsterCatcher::Models::Explore::Node do
    key { generate :explore_node_key }
    
    description { "#{key.capitalize.gsub('_',' ')} is a picturesque bit of countryside." }
    
    region { create :explore_region }
  end # factory
end # define
