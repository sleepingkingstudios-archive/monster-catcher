# lib/monster_catcher/controllers/user_controller.rb

require 'mithril/controllers/abstract_controller'
require 'mithril/controllers/mixins/help_actions'

require 'monster_catcher/controllers'

module MonsterCatcher::Controllers
  class UserController < Mithril::Controllers::AbstractController
    mixin Mithril::Controllers::Mixins::HelpActions
  end # class
end # module
