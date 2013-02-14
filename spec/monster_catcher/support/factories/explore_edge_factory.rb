# spec/monster_catcher/support/factories/explore_edge_factory.rb

require 'monster_catcher/models/explore/edge'

FactoryGirl.define do
  factory :explore_edge, :class => MonsterCatcher::Models::Explore::Edge do
    node { create :explore_node }
    
    path { generate :explore_node_key }
    
    name { path.to_s.gsub '_',' ' }
  end # factory
end # define
