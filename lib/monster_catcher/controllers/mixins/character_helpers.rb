# lib/monster_catcher/controllers/mixins/character_helpers.rb

require 'mithril/mixin'
require 'monster_catcher/controllers/mixins'
require 'monster_catcher/models/character'

module MonsterCatcher::Controllers::Mixins
  module CharacterHelpers
    extend Mithril::Mixin
    
    def current_character
      return nil if (char_id = request.session[:character_id]).nil?
      
      begin
        MonsterCatcher::Models::Character.find char_id
      rescue Mongoid::Errors::DocumentNotFound
        nil
      end # begin-rescue
    end # method current_character
  end # module
end # module
