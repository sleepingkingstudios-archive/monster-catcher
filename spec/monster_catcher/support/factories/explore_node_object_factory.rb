# spec/monster_catcher/support/factories/explore_node_object_factory.rb

require 'monster_catcher/models/explore/node_object'

FactoryGirl.define do
  sequence :explore_node_object_key do |index| "object #{index}"; end
  
  factory :explore_node_object, :class => MonsterCatcher::Models::Explore::NodeObject do
    node { create :explore_node }
    
    key { generate :explore_node_object_key }
  end # factory
end # define
