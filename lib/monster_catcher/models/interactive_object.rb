# lib/monster_catcher/models/interactive_object.rb

require 'monster_catcher/models'

module MonsterCatcher::Models
  class InteractiveObject
    include Mongoid::Document
    
    field :key,     :type => String
    field :actions, :type => Hash
    
    def initialize attrs = nil, options = nil
      super
      
      unpack_actions
    end # method initialize
    
    def unpack_actions
      self.actions ||= {}
      action_keys = attributes.keys - fields.keys
      action_keys.reject! do |key| key =~ /^_/; end
      
      action_keys.each do |key|
        self.actions[key] = attributes[key]
        attributes.delete key
      end # each
    end # method unpack_actions
    private :unpack_actions
  end # class
end # module
