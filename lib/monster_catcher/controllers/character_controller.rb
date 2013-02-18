# lib/monster_catcher/controllers/character_controller.rb

require 'mithril/controllers/abstract_controller'
require 'mithril/controllers/mixins/callback_helpers'
require 'mithril/controllers/mixins/help_actions'
require 'mithril/errors/action_error'
require 'monster_catcher/controllers'
require 'monster_catcher/controllers/mixins/character_helpers'
require 'monster_catcher/controllers/mixins/user_helpers'
require 'monster_catcher/models/user'

module MonsterCatcher::Controllers
  class CharacterController < Mithril::Controllers::AbstractController
    mixin Mithril::Controllers::Mixins::CallbackHelpers
    mixin Mithril::Controllers::Mixins::HelpActions
    mixin MonsterCatcher::Controllers::Mixins::CharacterHelpers
    mixin MonsterCatcher::Controllers::Mixins::UserHelpers
    
    define_action :new_game do |session, arguments|
      if arguments.first =~ /help/i
        return "The new game action creates a new character and starts a" +
          " game of Monster Catcher."
      elsif current_user.nil?
        raise Mithril::Errors::ActionError.new "expected current user not to be nil",
          self.class, :_char_name, session, arguments
      elsif !current_user.character.nil?
        return "You have already created a character. To resume your" +
          " previous game, enter \"resume game\"."
      end # if
      
      callbacks = { "" => { :controller => CharacterController, :action => :_char_name } }
      callbacks = self.serialize_callbacks callbacks
      self.set_callbacks request.session, callbacks
      
      "Please enter the name of your character."
    end # action new game
    
    define_action :continue_game do |session, arguments|
      if arguments.first =~ /help/i
        return "The continue game command lets you resume a game with a" +
          "previously-created character."
      elsif current_user.nil?
        raise Mithril::Errors::ActionError.new "expected current user not to be nil",
          self.class, :_char_name, session, arguments
      elsif !current_character.nil?
        raise Mithril::Errors::ActionError.new "already a character selected",
          self.class, :_char_name, session, arguments
      elsif current_user.character.nil?
        return "You have not yet created a character. To start a game with a" +
          " new character, enter \"new game\"."
      end # if
      
      character = current_user.character
      request.session.update :character_id => character.id
      
      str = "Welcome back to the world of Monster Catcher, #{character.name}!"
      
      unless (node = character.current_node).nil?
        str += "\n\nYou are currently in " + (node.name.nil? ? node.region.name : node.name) + "."
      end # unless
      
      str
    end # action continue game
    
    define_action :_char_name, :private => true do |session, arguments|
      if (user = current_user).nil?
        request.session.delete :callbacks
        raise Mithril::Errors::ActionError.new "expected current user not to be nil",
          self.class, :_char_name, session, arguments
      elsif !user.character.nil?
        request.session.delete :callbacks
        raise Mithril::Errors::ActionError.new "current user already has character",
          self.class, :_char_name, session, arguments
      elsif (name = arguments.join(" ")).empty?
        return "Please enter the name of your character."
      end # if
      
      region = MonsterCatcher::Models::Explore::Region.find_by(:key => "bird_town")
      node   = region.nodes.find_by(:key => "main_square")
      
      character = user.create_character :name => name, :node_id => node.id
      request.session.update :character_id => character.id
      request.session.delete :callbacks
      
      "Welcome to the world of Monster Catcher, #{name}!\n\n#{node.description}"
    end # private action char name 
  end # class
end # module
