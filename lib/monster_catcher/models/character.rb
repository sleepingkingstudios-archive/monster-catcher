# lib/monster_catcher/models/character.rb

require 'monster_catcher/models'
require 'monster_catcher/models/explore/node'
require 'monster_catcher/models/user'

module MonsterCatcher::Models
  class Character
    include Mongoid::Document
    
    field :name,    :type => String
    field :node_id, :type => Moped::BSON::ObjectId
    
    # Relations
    belongs_to :user, :class_name => "MonsterCatcher::Models::User"
    
    # Validations
    validates_presence_of :name
    validates_presence_of :user
    
    def current_node
      return nil if self.node_id.nil?
      
      begin
        MonsterCatcher::Models::Explore::Node.find node_id
      rescue Mongoid::Errors::DocumentNotFound
        nil
      end # begin-rescue
    end # method current_user
    
    def current_node=(node)
      if node.is_a? MonsterCatcher::Models::Explore::Node
        self.node_id = node.id
      else
        self.node_id = nil
      end # if-else
    end # method current_node
  end # class
end # module
