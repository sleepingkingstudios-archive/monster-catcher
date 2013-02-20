# lib/monster_catcher/controllers/explore_controller.rb

require 'mithril/controllers/mixins/help_actions'
require 'monster_catcher/controllers/interactive_controller'
require 'monster_catcher/controllers/actions/look_action'
require 'monster_catcher/controllers/mixins/character_helpers'
require 'monster_catcher/models/explore/edge'
require 'monster_catcher/models/explore/node'
require 'monster_catcher/models/explore/region'

module MonsterCatcher::Controllers
  class ExploreController < InteractiveController
    mixin Mithril::Controllers::Mixins::HelpActions
    mixin MonsterCatcher::Controllers::Actions::LookAction
    mixin MonsterCatcher::Controllers::Mixins::CharacterHelpers
    
    def current_node
      return nil if current_character.nil?
      
      current_character.current_node
    end # method current_node
    
    def resolve_edge params
      return nil if current_node.nil?
      
      if params.has_key? :name
        return current_node.edges.find_by(:name => params[:name])
      elsif params.has_key? :direction
        return current_node.edges.find_by(:direction => params[:direction])
      end # if
      
      nil
    rescue Mongoid::Errors::DocumentNotFound
      nil
    end # method resolve_edge
    
    def resolve_node params
      return nil if (edge = resolve_edge params).nil?
      
      segments   = edge.path.split ":"
      node_key   = segments.pop
      region_key = segments.pop
      
      if region_key.nil? || region_key.empty?
        region = current_node.region
      else
        region = MonsterCatcher::Models::Explore::Region.find_by(:key => region_key)
      end # if-else
      
      node = region.nodes.find_by(:key => node_key)
    rescue Mongoid::Errors::DocumentNotFound
      nil
    end # method resolve_node
    
    def node_string(node)
      return "You are forever lost in the void between worlds." if node.nil?
      
      node.name.nil? ? "You are in #{node.region.name}." : "You are in #{node.name}."
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
      
      str = "You can go "
      str += segments.join(", ") + ", and " if 0 < segments.count
      str += "#{last_segment}."
      
      str
    end # method edges_string
    
    define_action :go do |session, arguments|
      key  = :receiver
      text = (arguments[nil] || []).join(" ")
      name = (arguments[key] || []).join(" ")
      
      if text =~ /^help/i
        return "The go command lets you move to a nearby location. To move" +
          " a specific direction, enter \"go DIRECTION\". To move to a named" +
          " location, enter \"go to LOCATION\"."
      elsif text.empty? && name.empty?
        return "Please choose a direction to go in or a named location to go" +
          " to. For assistance, enter \"go help\", or enter \"where can I" +
          " go\" for a list of destinations."
      end # if
      
      if name.empty?
        node = self.resolve_node :direction => text
        
        return "I'm sorry, I don't know how to go #{text} from here." if node.nil?
      else
        node = self.resolve_node :name => name
        
        return "I'm sorry, I don't know where #{name} is." if node.nil?
      end # if
      
      character = current_character
      character.current_node = node
      character.save!
      
      node.description
    end # method define_action
    
    define_action :where do |session, arguments|
      text = (arguments[nil] || []).join(" ")
      
      if text =~ /^help/i
        return "The where command gives you information about your" +
          " character's current location. For the name of the location" +
          ", enter \"where am I\". For places you can go, enter \"where can" +
          " I go\". For both the name and places to go, enter \"where\"."
      end # if
      
      if text =~ /^am I/
        self.node_string current_node
      elsif text =~ /^can I go/
        self.edges_string current_node
      else
        "#{self.node_string current_node}\n\n#{self.edges_string current_node}"
      end # if-else
    end # define action
  end # class
end # module
