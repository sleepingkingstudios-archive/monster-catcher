# lib/monster_catcher/models/explore/region.rb

require 'monster_catcher/models/explore'
require 'monster_catcher/models/explore/node'

module MonsterCatcher::Models::Explore
  class Region
    include Mongoid::Document
    include MonsterCatcher::Models::YAMLDocument
    
    field :key,  :type => String
    field :name, :type => String
    
    # Relations
    has_many :nodes, :class_name => "MonsterCatcher::Models::Explore::Node"
    
    # Validations
    validates_presence_of :key, :name
  end # class Region
end # module
