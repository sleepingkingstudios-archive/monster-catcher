# lib/monster_catcher/controllers/mixins/user_helpers.rb

require 'mithril/mixin'
require 'monster_catcher/controllers/mixins'
require 'monster_catcher/models/user'

module MonsterCatcher::Controllers::Mixins
  module UserHelpers
    extend Mithril::Mixin
    
    def current_user
      return nil if (user_id = request.session[:user_id]).nil?
      
      begin
        MonsterCatcher::Models::User.find user_id
      rescue Mongoid::Errors::DocumentNotFound
        nil
      end # begin-rescue
    end # method current_user
  end # module
end # module
