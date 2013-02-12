# lib/monster_catcher/models/character.rb

require 'monster_catcher/models'
require 'monster_catcher/models/user'

module MonsterCatcher::Models
  class Character
    include Mongoid::Document
    
    field :name, type: String
    
    # Relations
    belongs_to :user, :class_name => "MonsterCatcher::Models::User"
    
    # Validations
    validates_presence_of :name
    validates_presence_of :user
  end # class
end # module
