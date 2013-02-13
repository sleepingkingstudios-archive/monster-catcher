# lib/monster_catcher/controllers/user_controller.rb

require 'mithril/controllers/abstract_controller'
require 'mithril/controllers/mixins/help_actions'

require 'monster_catcher/controllers'
require 'monster_catcher/models/user'

module MonsterCatcher::Controllers
  class UserController < Mithril::Controllers::AbstractController
    include MonsterCatcher::Models
    
    mixin Mithril::Controllers::Mixins::HelpActions
    
    def allow_registration?
      true
    end # method allow_registration?
    
    define_action :register do |session, arguments|
      if arguments.first =~ /help/
        return "The register command allows you to create a new user" +
          " account.\n\nFormat: \"register USERNAME PASSWORD\"."
      elsif !allow_registration?
        return "I'm sorry, but web registration is currently closed. If you" +
          " wish to create a user account, please contact the site" +
          " administrator."
      elsif 2 > arguments.count
        return "The register command requires a username and password. For" +
          " more information, enter \"register help\"."
      end # if-else
      
      username = arguments.shift
      password = arguments.shift
      
      user = User.where(:name => username)
      
      if user.exists?
        return "User \"#{username}\" already exists. Please select a" +
          " unique user name."
      end # if
      
      user = User.create :name => username, :password => password
      session[:user_id] = user.id
      
      "Your user account has been created. You are now logged in as" +
        " #{username}."
    end # action register
    
    define_action :login do |session, arguments|
      if arguments.first =~ /help/
        return "The login command starts a new user session. You must be" +
          " logged in to start or continue a game.\n\nFormat: \"login" +
          " USERNAME PASSWORD\"."
      elsif 2 > arguments.count
        return "The login command requires a username and password. For" +
          " more information, enter \"register help\"."
      end # if-else
      
      username = arguments.shift
      password = arguments.shift
      
      user = User.where(:name => username).first
      
      if user.nil? || !user.authenticate(password)
        return "Unable to authenticate user \"#{username}\"."
      end # if
      
      session[:user_id] = user.id
      
      "You are now logged in as #{username}."
    end # action login
  end # class
end # module
