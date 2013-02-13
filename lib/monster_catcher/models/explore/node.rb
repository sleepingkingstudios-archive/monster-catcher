# lib/monster_catcher/models/explore/node.rb

require 'monster_catcher/models/explore'

module MonsterCatcher::Models::Explore
  class Node
    include Mongoid::Document
    
    field :key,         :type => String
    field :name,        :type => String
    field :description, :type => String
    
    # Validations
    validates_presence_of :key
  end # class Node
end # module
