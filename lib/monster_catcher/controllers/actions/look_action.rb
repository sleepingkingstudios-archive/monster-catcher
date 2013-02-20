# lib/monster_catcher/controllers/actions/look_action.rb
  
require 'mithril/controllers/mixins/actions_base'
require 'monster_catcher/controllers/actions'

module MonsterCatcher::Controllers::Actions
  module LookAction
    extend Mithril::Controllers::Mixins::MixinWithActions
    
    mixin Mithril::Controllers::Mixins::ActionsBase
    
    define_action :look do |session, arguments|
      text = (arguments[nil] || []).join(" ")
      
      if text =~ /^help/i
        return "The look command lets you examine your current location and" +
          " its surroundings."
      elsif current_node.nil?
        return "There is nothing but an echoing, timeless void. Hope you" +
          " brought a good book."
      elsif !arguments.has_key?(:target)
        return current_node.description
      end # if-elsif
      
      target = arguments[:target].first.gsub(/^the/,'').strip.downcase
      
      unless (action = object_actions["look"]).nil?
        object_actions["look"].each do |key, data|
          return data if key.gsub(/^the/,'').strip.downcase == target
        end # each
      end # unless
      
      message = "I'm sorry, I don't see "
      message += (target =~ /^[aeiou]/ ? "an " : "a ")
      message += "#{target}."
      
      message
    end # define action
  end # module
end # module
