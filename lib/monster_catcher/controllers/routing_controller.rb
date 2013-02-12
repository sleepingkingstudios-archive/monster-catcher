# lib/monster_catcher/controllers/routing_controller.rb

require 'mithril/controllers/callback_controller'
require 'mithril/controllers/proxy_controller'
require 'mithril/controllers/mixins/callback_helpers'
require 'mithril/controllers/mixins/help_actions'
require 'monster_catcher/controllers'
require 'monster_catcher/controllers/user_controller'
require 'monster_catcher/controllers/mixins/character_helpers'
require 'monster_catcher/controllers/mixins/user_helpers'
require 'monster_catcher/models/user'

module MonsterCatcher::Controllers
  class RoutingController < Mithril::Controllers::ProxyController
    mixin Mithril::Controllers::Mixins::CallbackHelpers
    mixin Mithril::Controllers::Mixins::HelpActions
    mixin MonsterCatcher::Controllers::Mixins::CharacterHelpers
    mixin MonsterCatcher::Controllers::Mixins::UserHelpers
    
    include MonsterCatcher::Models
    
    def proxy
      return @proxy unless @proxy.nil?
      
      if has_callbacks? request.session
        @proxy = Mithril::Controllers::CallbackController.new request
      elsif current_user.nil?
        @proxy = MonsterCatcher::Controllers::UserController.new request
      else
        @proxy = MonsterCatcher::Controllers::CharacterController.new request
      end # if
    end # method proxy
    
    def invoke_command(text)
      super
    end # method invoke_command
  end # class
end # module
