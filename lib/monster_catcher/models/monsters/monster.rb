# lib/monster_catcher/models/monsters/monster.rb

require 'monster_catcher/models/monsters'
require 'monster_catcher/models/monsters/monster_technique'
require 'monster_catcher/models/monsters/species'
require 'monster_catcher/models/monsters/technique'

module MonsterCatcher::Models::Monsters
  class Monster
    include Mongoid::Document
    
    class << self
      # Generates the fields and methods for keeping track of a monster's
      # attributes, such as hit points, speed, and special attack. The
      # following fields are created:
      # 
      # base_#{key} [Integer] The base value of that attribute for that
      #   monster. The base value is a function of species, a bit of random
      #   variance by instance, and (approximately) level.
      # 
      # @param [String, Symbol] key 
      def attribute key
        (@attributes ||= []) << (key = key.to_s).intern
        
        field :"base_#{key}", :type => Integer
        
        define_method key do
          self.send key
        end # method key
      end # class method attribute
    end # class << self
    
    field :name,  :type => String
    field :types, :type => Array
    field :level, :type => Integer
    
    attribute :hit_points
    attribute :physical_attack
    attribute :physical_defense
    attribute :special_attack
    attribute :special_defense
    attribute :speed
    
    #=# Relations #=#
    embeds_many :monster_techniques, :class_name => "MonsterCatcher::Models::Monsters::MonsterTechnique"
    
    belongs_to :species, :class_name => "MonsterCatcher::Models::Monsters::Species"
    belongs_to :trainer, :polymorphic => true
    
    #=# Validation #=#
    validates :species, :presence => true
    
    def techniques
      return [] if self.monster_techniques.nil? || self.monster_techniques.empty?
      
      Technique.where(:_id.in => self.monster_techniques.map(&:technique_id)).to_a
    end # pseudo-relation techniques
    
    def techniques= techniques
      self.monster_techniques.destroy_all
      self.monster_techniques = techniques.map do |technique|
        MonsterCatcher::Models::Monsters::MonsterTechnique.new({ :technique => technique })
      end # map
    end # pseudo-relation techniques
  end # class
end # module
