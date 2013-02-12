# lib/monster_catcher/controllers/character_controller.rb

require 'mithril/controllers/abstract_controller'
require 'mithril/controllers/mixins/callback_helpers'
require 'mithril/controllers/mixins/help_actions'
require 'monster_catcher/controllers'
require 'monster_catcher/controllers/mixins/user_helpers'
require 'monster_catcher/models/user'

module MonsterCatcher::Controllers
  class CharacterController < Mithril::Controllers::AbstractController
    mixin Mithril::Controllers::Mixins::CallbackHelpers
    mixin Mithril::Controllers::Mixins::HelpActions
    mixin MonsterCatcher::Controllers::Mixins::UserHelpers
    
    define_action :new_game do |session, arguments|
      if arguments.first =~ /help/i
        return "The new game action creates a new character and starts a" +
          " game of Monster Catcher."
      end # if
      
      callbacks = { "" => { :controller => CharacterController, :action => :_char_name } }
      callbacks = self.serialize_callbacks callbacks
      self.set_callbacks request.session, callbacks
      
      "Please enter the name of your character."
    end # action new game
    
    define_action :_char_name, :private => true do |session, arguments|
      return nil if (user = current_user).nil?
      
      name = arguments.first
      
      user.create_character :name => name
      request.session.update :character_id => user.character.id
      
      "Welcome to the world of Monster Catcher, #{name}!"
    end # private action char name 
  end # class
end # module
