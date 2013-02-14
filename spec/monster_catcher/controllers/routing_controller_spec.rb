# spec/controllers/routing_controller_spec.rb

require 'monster_catcher/spec_helper'
require 'mithril/controllers/proxy_controller_helper'
require 'mithril/controllers/mixins/callback_helpers_helper'
require 'mithril/controllers/mixins/help_actions_helper'
require 'monster_catcher/controllers/mixins/character_helpers_helper'
require 'monster_catcher/controllers/mixins/user_helpers_helper'

require 'mithril/controllers/callback_controller'
require 'mithril/errors/callback_error'
require 'monster_catcher/controllers/character_controller'
require 'monster_catcher/controllers/routing_controller'
require 'monster_catcher/controllers/user_controller'

describe MonsterCatcher::Controllers::RoutingController do
  let :request do FactoryGirl.build :request; end
  let :described_class do Class.new super(); end
  let :instance do described_class.new request; end
  
  it_behaves_like Mithril::Controllers::ProxyController
  it_behaves_like Mithril::Controllers::Mixins::CallbackHelpers
  it_behaves_like Mithril::Controllers::Mixins::HelpActions
  it_behaves_like MonsterCatcher::Controllers::Mixins::CharacterHelpers
  it_behaves_like MonsterCatcher::Controllers::Mixins::UserHelpers
  
  describe :namespaces do
    specify { expect(instance.namespaces).to include "Mithril::Controllers" }
    specify { expect(instance.namespaces).to include "MonsterCatcher::Controllers" }
  end # describe
  
  context 'with a callback waiting' do
    let :callback_command do
      FactoryGirl.generate(:action_key).to_s.gsub('_',' ')
    end # let
    let :callback_action do FactoryGirl.generate :action_key; end
    
    before :each do
      klass = Class.new Mithril::Controllers::AbstractController
      klass.send :define_action, callback_action do |session, arguments| arguments; end
      MonsterCatcher::Controllers.const_set :Mock, Module.new
      MonsterCatcher::Controllers::Mock.const_set :MockController, klass
    end # before each
    
    after :each do
      MonsterCatcher::Controllers::Mock.send :remove_const, :MockController
      MonsterCatcher::Controllers.send :remove_const, :Mock
    end # after each
    
    let :callbacks do
      { callback_command => "Mock::MockController,#{callback_action}" }
    end # let
    let :request do
      FactoryGirl.build :request, :session => { :callbacks => callbacks }
    end # let
    
    specify { expect(instance.has_callbacks? instance.request.session).to be true }
    
    specify { expect(instance.proxy).to be_a Mithril::Controllers::CallbackController }
    
    describe "invokes the callback" do
      let :arguments do %w(with arguments); end
      let :text do "#{callback_command} #{arguments.join(" ")}"; end
      
      specify { expect(instance).to have_command callback_command }
      specify { expect(instance.can_invoke? text).to be true }
      
      specify { expect(instance.invoke_command text).to eq arguments }
    end # describe
    
    describe "invokes the callback via an empty command" do
      let :callback_command do ""; end
      let :arguments do %w(with arguments); end
      let :text do "#{arguments.join(" ")}"; end
      
      specify { expect(instance.can_invoke? text).to be true }
      
      specify { expect(instance.invoke_command text).to eq arguments }
    end # describe
  end # context
  
  context 'with no user logged in' do
    specify { expect(instance.current_user).to be nil }
    
    specify { expect(instance.proxy).to be_a MonsterCatcher::Controllers::UserController }
    
    describe "registration" do
      before :each do
        instance.proxy.stub :allow_registration? do true; end
      end # before each
      
      let :attributes do FactoryGirl.attributes_for :user; end
      let :text do "register #{attributes[:name]} #{attributes[:password]}"; end
      
      specify { expect(instance.can_invoke? text).to be true }
      
      specify { expect(instance.invoke_command text)
        .to match /now logged in as #{attributes[:name]}/i }
      
      specify 'creates a new user' do
        instance.invoke_command text
        user = MonsterCatcher::Models::User.where(:name => attributes[:name]).first
        expect(user).not_to be nil
        expect(user.name).to eq attributes[:name]
        expect(user.authenticate attributes[:password]).to be true
      end # specify
      
      specify 'updates the session with the new user\'s id' do
        instance.invoke_command text
        user = MonsterCatcher::Models::User.where(:name => attributes[:name]).first
        expect(user).not_to be nil
        expect(request.session[:user_id]).to eq user.id
      end # specify
    end # describe registration
    
    describe "logging in" do
      let :attributes do FactoryGirl.attributes_for :user; end
      let :text do "login #{attributes[:name]} #{attributes[:password]}"; end
      
      before :each do FactoryGirl.create :user, attributes; end
      
      specify { expect(instance.can_invoke? text).to be true }
      
      specify { expect(instance.invoke_command text)
        .to match /now logged in as #{attributes[:name]}/i }
      
      specify 'updates the session with the new user\'s id' do
        instance.invoke_command text
        user = MonsterCatcher::Models::User.where(:name => attributes[:name]).first
        expect(user).not_to be nil
        expect(request.session[:user_id]).to eq user.id
      end # specify
    end # describe
  end # context
  
  context 'with a user logged in' do
    let :user do FactoryGirl.create :user; end
    let :request do FactoryGirl.build :request, :session => { :user_id => user.id }; end
    
    specify { expect(instance.current_user).to eq user }
    
    specify { expect(instance.current_character).to be nil }
    
    specify { expect(instance.proxy).to be_a MonsterCatcher::Controllers::CharacterController }
    
    describe "starting a new game" do
      let :callbacks do { "" => "CharacterController,_char_name" }; end
      
      specify { expect(instance).to have_command "new game" }
      
      specify { expect(instance.invoke_command "new game").
        to match /enter the name of your character/i }
      
      specify "sets up a callback" do
        instance.invoke_command "new game"
        expect(request.session).to include :callbacks => callbacks
      end # specify
      
      context 'with the callback set' do
        let :character_name do FactoryGirl.generate :character_name; end
        let :text do character_name; end
        
        before :each do request.session.update :callbacks => callbacks; end
        
        specify { expect(instance.can_invoke? text).to be true }
        
        specify { expect(instance.invoke_command text).
          to match /welcome to the world of monster catcher/i }
        
        specify { expect(instance.invoke_command text).
          to match /#{character_name}/i }
        
        specify 'creates a new character for the current user' do
          instance.invoke_command text
          expect(instance.current_character).not_to be nil
          expect(instance.current_character).to eq instance.current_user.character
          expect(instance.current_character.name).to eq character_name
        end # specify

        specify 'updates the session with the character\'s id' do
          instance.invoke_command text
          expect(request.session[:character_id]).
            to eq instance.current_character.id
        end # specify
      end # context
    end # describe
  end # context
  
  context 'with a character selected' do
    let :user do FactoryGirl.create :user; end
    let :character do FactoryGirl.create :character, :user_id => user.id; end
    let :request do
      super().tap { |req| req.session.update :character_id => character.id, :user_id => user.id }
    end # let
    
    specify { expect(instance.current_user).to eq user }
    
    specify { expect(instance.current_character).to eq character }
    
    specify { expect(instance.proxy).to be_a MonsterCatcher::Controllers::ExploreController }
    
    specify { expect(instance.invoke_command "where am I").
      to match /lost in the void between worlds/i }
  end # context
end # describe
