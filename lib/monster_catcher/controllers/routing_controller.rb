# lib/monster_catcher/controllers/routing_controller.rb

require 'mithril/controllers/proxy_controller'
require 'mithril/controllers/mixins/help_actions'
require 'monster_catcher/controllers'
require 'monster_catcher/controllers/user_controller'

module MonsterCatcher::Controllers
  class RoutingController < Mithril::Controllers::ProxyController
    mixin Mithril::Controllers::Mixins::HelpActions
    
    def current_user
      nil
    end # method current_user
    
    def proxy
      return @proxy unless @proxy.nil?
      
      if current_user.nil?
        @proxy ||= MonsterCatcher::Controllers::UserController.new request
      end # if
    end # method proxy
  end # class
end # module
