# lib/monster_catcher/controllers/explore_controller.rb

require 'mithril/controllers/abstract_controller'
require 'mithril/controllers/mixins/help_actions'
require 'mithril/parsers/contextual_parser'
require 'monster_catcher/controllers'
require 'monster_catcher/controllers/mixins/character_helpers'

module MonsterCatcher::Controllers
  class ExploreController < Mithril::Controllers::AbstractController
    mixin Mithril::Controllers::Mixins::HelpActions
    mixin MonsterCatcher::Controllers::Mixins::CharacterHelpers
    
    def parser
      @parser ||= Mithril::Parsers::ContextualParser.new(self)
    end # method parser
    
    def current_node
      return nil if current_character.nil?
      
      current_character.current_node
    end # method current_node
    
    def node_string(node)
      return "You are forever lost in the void between worlds." if node.nil?
      
      "You are in #{node.name}."
    end # method node_string
    
    def edges_string(node)
      return "There is nowhere to go from here." if node.nil? || 0 == node.edges.count
      
      directions, locations = [], []
      node.edges.each do |edge|
        if edge.direction.nil?
          locations << "to #{edge.name}"
        elsif edge.name.nil?
          locations << edge.direction
        else
          locations << "#{edge.direction} to #{edge.name}"
        end # if-elsif-else
      end # each
      
      segments = directions.sort + locations.sort
      last_segment = segments.pop
      
      str = "You can go to the following locations: "
      str += segments.join(", ") + ", and " if 0 < segments.count
      str += "#{last_segment}."
      
      str
    end # method edges_string
    
    define_action :where do |session, arguments|
      text = (arguments[nil] || []).join(" ")
      
      if text =~ /^help/i
        return "The where command gives you information about your" +
          " character's current location. For the name of the location" +
          ", enter \"where am I\". For places you can go, enter \"where can" +
          " I go\". For both the name and places to go, enter \"where\"."
      end # if-elsif
      
      if text =~ /^am I/
        self.node_string current_node
      else
        "#{self.node_string current_node}\n\n#{self.edges_string current_node}"
      end # if-else
    end # define action
  end # class
end # module
