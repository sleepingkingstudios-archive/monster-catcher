# lib/monster_catcher/models/explore/edge.rb

require 'monster_catcher/models/explore'
require 'monster_catcher/models/explore/node'

module MonsterCatcher::Models::Explore
  class Edge
    include Mongoid::Document
    
    field :path,      :type => String
    field :name,      :type => String
    field :direction, :type => String
    
    # Relations
    embedded_in :node, :class_name => "MonsterCatcher::Models::Explore::Node"
    
    # Validations
    validates_presence_of :node, :path
    validates_presence_of :name, :if => lambda { direction.nil? },
      :message => 'either name or direction can\'t be blank'
    validates_presence_of :direction, :if => lambda { name.nil? },
      :message => 'either name or direction can\'t be blank'
  end # class Edge
end # module
