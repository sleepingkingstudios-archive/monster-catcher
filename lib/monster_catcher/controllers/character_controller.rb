# lib/monster_catcher/controllers/character_controller.rb

require 'mithril/controllers/abstract_controller'
require 'mithril/controllers/mixins/help_actions'
require 'monster_catcher/controllers'

module MonsterCatcher::Controllers
  class CharacterController < Mithril::Controllers::AbstractController
    mixin Mithril::Controllers::Mixins::HelpActions
    
    
  end # class
end # module
