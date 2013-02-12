# lib/monster_catcher/models/user.rb

require 'bcrypt'

require 'monster_catcher/models'
require 'monster_catcher/models/character'

module MonsterCatcher::Models
  class User
    include Mongoid::Document
    
    field :name,  type: String
    field :crypt, type: String
    
    attr_accessor :password
    
    attr_accessible :name, :password
    
    # Relations
    has_one :character, :class_name => "MonsterCatcher::Models::Character"
    
    # Validations
    validates_presence_of :name, :password
    
    # Callbacks
    before_save :encrypt_password
    
    def authenticate(password)
      secret = BCrypt::Password.new(crypt)
      secret == password
    end # method authenticate
    
    def encrypt_password
      return if @password.nil?
      self.crypt = BCrypt::Password.create(@password)
      @password = nil
    end # encrypt_password
    private :encrypt_password
  end # class User
end # module
