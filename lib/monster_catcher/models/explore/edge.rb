# lib/monster_catcher/models/explore/edge.rb

require 'monster_catcher/models/explore'
require 'monster_catcher/models/explore/node'

module MonsterCatcher::Models::Explore
  class Edge
    include Mongoid::Document
    
    field :path, :type => String
    field :name, :type => String
    
    # Relations
    embedded_in :node, :class_name => "MonsterCatcher::Models::Explore::Node"
    
    # Validations
    validates_presence_of :name, :node, :path
  end # class Edge
end # module
