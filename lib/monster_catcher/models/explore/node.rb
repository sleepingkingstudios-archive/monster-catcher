# lib/monster_catcher/models/explore/node.rb

require 'yaml'

require 'monster_catcher/models/explore'

module MonsterCatcher::Models::Explore
  class Node
    include Mongoid::Document
    
    def initialize(attrs = nil, options = nil)
      if attrs.is_a?(String) && attrs =~ /^---/
        attrs = YAML::load attrs
      end # if
      
      super(attrs, options)
    end # method initialize
    
    field :key,         :type => String
    field :name,        :type => String
    field :description, :type => String
    
    # Validations
    validates_presence_of :key
  end # class Node
end # module
