# lib/monster_catcher/extensions/mithril/controllers/mixins/callback_helpers.rb

require 'mithril/controllers/mixins/callback_helpers'

module Mithril::Controllers::Mixins
  module CallbackHelpers
    alias :core_namespaces :namespaces
    
    def namespaces
      @namespaces ||= core_namespaces + %w(MonsterCatcher::Controllers)
    end # method namespaces
  end # module
end # module
