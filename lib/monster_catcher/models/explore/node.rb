# lib/monster_catcher/models/explore/node.rb

require 'monster_catcher/models/explore'
require 'monster_catcher/models/explore/region'

module MonsterCatcher::Models::Explore
  class Node
    include Mongoid::Document
    include MonsterCatcher::Models::YAMLDocument
    
    field :key,         :type => String
    field :name,        :type => String
    field :description, :type => String
    
    # Relations
    belongs_to :region, :class_name => "MonsterCatcher::Models::Explore::Region"
    embeds_many :edges, :class_name => "MonsterCatcher::Models::Explore::Edge"
    
    # Validations
    validates_presence_of :key, :region
  end # class Node
end # module
