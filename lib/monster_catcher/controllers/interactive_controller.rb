# lib/monster_catcher/controllers/interactive_controller.rb

require 'mithril/controllers/abstract_controller'
require 'mithril/parsers/contextual_parser'
require 'monster_catcher/controllers'

module MonsterCatcher::Controllers
  class InteractiveController < Mithril::Controllers::AbstractController
    def parser
      @parser ||= Mithril::Parsers::ContextualParser.new(self)
    end # method parser
    
    def interactive_objects
      [] # override this in sub-classes!
    end # method interactive objects
    
    def object_actions
      @object_actions = Hash.new
      interactive_objects.each do |object|
        object.actions.each do |action, value|
          (@object_actions[action] ||= {})[object.key] = value
        end # each
      end # each
      
      @object_actions
    end # method object actions
  end # class
end # module
