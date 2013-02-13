# lib/monster_catcher/controllers/explore_controller.rb

require 'mithril/controllers/abstract_controller'
require 'mithril/controllers/mixins/help_actions'
require 'monster_catcher/controllers'
require 'monster_catcher/controllers/mixins/character_helpers'

module MonsterCatcher::Controllers
  class ExploreController < Mithril::Controllers::AbstractController
    mixin Mithril::Controllers::Mixins::HelpActions
    mixin MonsterCatcher::Controllers::Mixins::CharacterHelpers
    
    def current_node
      return nil if current_character.nil?
      
      current_character.current_node
    end # method current_node
    
    define_action :where do |session, arguments|
      if arguments.first =~ /help/i
        return "The where command gives you information about your" +
          " character's current location. For the name of the location" +
          ", enter \"where am I\". For places you can go, enter \"where can" +
          " I go\". For both the name and places to go, enter \"where\"."
      elsif current_node.nil?
        return "You are forever lost in the void between worlds."
      end # if-elsif
      
      location_str = "You are in #{current_node.name}."
      
      text = arguments.join(" ")
      if text =~ /^am I/
        location_str
      else
        location_str
      end # if-else
    end # define action
  end # class
end # module
