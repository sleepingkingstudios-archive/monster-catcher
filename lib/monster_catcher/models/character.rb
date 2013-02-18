# lib/monster_catcher/models/character.rb

require 'monster_catcher/models'
require 'monster_catcher/models/explore/node'
require 'monster_catcher/models/explore/region'
require 'monster_catcher/models/user'

module MonsterCatcher::Models
  class Character
    include Mongoid::Document
    
    field :name,     :type => String
    field :node_key, :type => String
    
    # Relations
    belongs_to :user, :class_name => "MonsterCatcher::Models::User"
    
    # Validations
    validates_presence_of :name
    validates_presence_of :user
    
    def current_node
      return nil if self.node_key.nil?
      
      begin
        segments   = self.node_key.split(':')
        node_key   = segments.pop
        region_key = segments.pop
        
        region = MonsterCatcher::Models::Explore::Region.find_by(:key => region_key)
        node   = region.nodes.find_by(:key => node_key)
      rescue Mongoid::Errors::DocumentNotFound
        nil
      end # begin-rescue
    end # method current_user
    
    def current_node=(node)
      if node.is_a? MonsterCatcher::Models::Explore::Node
        self.node_key = "#{node.region.key}:#{node.key}"
      else
        self.node_key = nil
      end # if-else
    end # method current_node
  end # class
end # module
