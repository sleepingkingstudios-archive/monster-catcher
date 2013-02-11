# spec/monster_catcher/controllers/user_controller_spec.rb

require 'monster_catcher/spec_helper'
require 'mithril/controllers/abstract_controller_helper'
require 'mithril/controllers/mixins/help_actions_helper'

require 'monster_catcher/controllers/user_controller'

describe MonsterCatcher::Controllers::UserController do
  let :request do FactoryGirl.build :request; end
  let :described_class do Class.new super(); end
  let :instance do described_class.new request; end
  
  it_behaves_like Mithril::Controllers::AbstractController
  it_behaves_like Mithril::Controllers::Mixins::HelpActions
  
  describe :allow_registration? do
    specify { expect(instance).to respond_to(:allow_registration?).with(0).arguments }
  end # describe
  
  describe "register action" do
    let :username do FactoryGirl.generate :user_name; end
    let :password do FactoryGirl.generate :user_password; end
    
    specify { expect(instance).to have_action :register }
    specify { expect(instance).to have_command "register" }
    specify { expect(instance.can_invoke? "register #{username} #{password}").to be true }
    
    context "with registration disallowed" do
      before :each do instance.stub :allow_registration? do false; end; end
      
      specify { expect(instance.allow_registration?).to be false }
      
      context 'with "help"' do
        let :text do "register help"; end
        
        specify { expect(instance.invoke_command text).
          to match /the register command/i }
      end # context
      
      context 'with no arguments' do
        let :text do "register"; end
        
        specify { expect(instance.invoke_command text).
          to match /is currently closed/i }
      end # context
      
      context 'with other arguments' do
        let :text do "register #{username} #{password}"; end
        
        specify { expect(instance.invoke_command text).
          to match /is currently closed/i }
      end # context
    end # context
    
    context "with registration allowed" do
      before :each do instance.stub :allow_registration? do true; end; end
      
      specify { expect(instance.allow_registration?).to be true }
      
      context 'with "help"' do
        let :text do "register help"; end
        
        specify { expect(instance.invoke_command text).
          to match /the register command/i }
      end # context
      
      context 'with no arguments' do
        let :text do "register"; end
        
        specify { expect(instance.invoke_command text).
          to match /requires a username and password/i }
      end # context
      
      context 'with one argument' do
        let :text do "register #{username}"; end
        
        specify { expect(instance.invoke_command text).
          to match /requires a username and password/i }
      end # context
      
      context 'with a valid username and password' do
        let :text do "register #{username} #{password}"; end
        
        specify { expect(MonsterCatcher::Models::User.where :name => username).not_to exist }
        
        context 'with a user already defined' do
          before :each do
            FactoryGirl.create :user, :name => username
          end # before each
          
          specify 'returns error message' do
            expect(instance.invoke_command text).
              to match /user \"#{username}\" already exists/i
          end # specify
          
          specify 'does not create a new user' do
            user_count = MonsterCatcher::Models::User.count
            instance.invoke_command text
            expect(MonsterCatcher::Models::User.count).to eq user_count
          end # specify
        end # context
        
        context 'with user name available' do
          specify { expect(instance.invoke_command text).
            to match /user account has been created/i }
          
          specify { expect(instance.invoke_command text).
            to match /now logged in as #{username}/i }
          
          specify 'creates a new user with given username and password' do
            instance.invoke_command text
            user = MonsterCatcher::Models::User.where(:name => username).first
            expect(user).not_to be nil
            expect(user.name).to eq username
            expect(user.authenticate password).to be true
          end # specify
          
          specify 'updates the session with the new user\'s id' do
            instance.invoke_command text
            user = MonsterCatcher::Models::User.where(:name => username).first
            expect(user).not_to be nil
            expect(request.session[:user_id]).to eq user.id
          end # specify
        end # context
      end # context
    end # context
  end # describe
  
  describe "login action" do
    let :username do FactoryGirl.generate :user_name; end
    let :password do FactoryGirl.generate :user_password; end
    
    specify { expect(instance).to have_action :login }
    specify { expect(instance).to have_command "login" }
    specify { expect(instance.can_invoke? "login #{username} #{password}").to be true }
    
    context 'with "help"' do
      let :text do "login help"; end
      
      specify { expect(instance.invoke_command text).
        to match /the login command/i }
    end # context
    
    context 'with no arguments' do
      let :text do "login"; end
      
      specify { expect(instance.invoke_command text).
        to match /requires a username and password/i }
    end # context
    
    context 'with one argument' do
      let :text do "login #{username}"; end
      
      specify { expect(instance.invoke_command text).
        to match /requires a username and password/i }
    end # context
    
    context 'with an invalid username' do
      let :text do "login #{username} #{password}"; end
      
      specify { expect(instance.invoke_command text).
        to match /unable to authenticate user/i }
    end # context
    
    context 'with a user defined' do
      before :each do
        FactoryGirl.create :user, :name => username, :password => password
      end # before each
      
      context 'with "help"' do
        let :text do "login help"; end

        specify { expect(instance.invoke_command text).
          to match /the login command/i }
      end # context

      context 'with no arguments' do
        let :text do "login"; end

        specify { expect(instance.invoke_command text).
          to match /requires a username and password/i }
      end # context

      context 'with one argument' do
        let :text do "login #{username}"; end

        specify { expect(instance.invoke_command text).
          to match /requires a username and password/i }
      end # context

      context 'with an invalid username' do
        let :text do "login #{FactoryGirl.generate :user_name} #{password}"; end

        specify { expect(instance.invoke_command text).
          to match /unable to authenticate user/i }
      end # context

      context 'with an invalid password' do
        let :text do "login #{username} #{FactoryGirl.generate :user_password}"; end

        specify { expect(instance.invoke_command text).
          to match /unable to authenticate user/i }
      end # context
      
      context 'with a valid username and password' do
        let :text do "login #{username} #{password}"; end
        
        specify { expect(instance.invoke_command text).
          to match /now logged in as #{username}/i }
        
        specify 'updates the session with the new user\'s id' do
          instance.invoke_command text
          user = MonsterCatcher::Models::User.where(:name => username).first
          expect(request.session[:user_id]).to eq user.id
        end # specify
      end # context
    end # context
  end # describe
end # describe
