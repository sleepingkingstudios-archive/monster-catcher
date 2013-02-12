# spec/monster_catcher/controllers/character_controller_spec.rb

require 'monster_catcher/spec_helper'
require 'mithril/controllers/abstract_controller_helper'
require 'mithril/controllers/mixins/callback_helpers_helper'
require 'mithril/controllers/mixins/help_actions_helper'

require 'monster_catcher/controllers/character_controller'

describe MonsterCatcher::Controllers::CharacterController do
  let :request do FactoryGirl.build :request; end
  let :described_class do Class.new super(); end
  let :instance do described_class.new request; end
  
  it_behaves_like Mithril::Controllers::AbstractController
  it_behaves_like Mithril::Controllers::Mixins::CallbackHelpers
  it_behaves_like Mithril::Controllers::Mixins::HelpActions
  
  describe :current_user do
    specify { expect(instance).to respond_to(:current_user).with(0).arguments }
    
    specify { expect(instance.current_user).to be nil }
    
    context 'with an invalid user id' do
      let :user do FactoryGirl.build :user; end
      
      before :each do request.session[:user_id] = user.id; end
      
      specify { expect(instance.current_user).to be nil }
    end # context
    
    context 'with a valid user id' do
      let :user do FactoryGirl.create :user; end
      
      before :each do request.session[:user_id] = user.id; end
      
      specify { expect(instance.current_user).to eq user }
    end # context
  end # describe
  
  describe "new game action" do
    specify { expect(instance).to have_action :new_game }
    specify { expect(instance).to have_command "new game" }
    specify { expect(instance.can_invoke? "new game").to be true }
    
    context 'with help' do
      let :arguments do %w(help); end
      let :text do "new game #{arguments.join(" ")}"; end
      
      specify { expect(instance.invoke_command text).
        to match /the new game action/i }
    end # context
    
    context 'with no arguments' do
      let :text do "new game"; end
      let :callbacks do { "name" => "CharacterController,_char_name" }; end
      
      specify { expect(instance.invoke_command text).
        to match /please enter the name of your character/i }
      
      specify "sets up a callback" do
        instance.invoke_command text
        expect(request.session).to have_key :callbacks
        expect(request.session[:callbacks]).to eq callbacks
      end # specify
    end # context
  end # describe
  
  describe "char name action" do
    let :user do FactoryGirl.create :user; end
    let :request do FactoryGirl.build :request, :session => { :user_id => user.id }; end
    
    let :name do FactoryGirl.generate :character_name; end
    
    specify { expect(instance).not_to have_action :_char_name }
    specify { expect(instance).to have_action :_char_name, true }
    specify { expect(instance).not_to have_command "char name" }
    specify { expect(instance.can_invoke? "char name").to be false }
    
    specify { expect(instance.invoke_action :_char_name, [name], true).
      to match /welcome to the world of monster catcher/i }
    
    specify 'creates a new character for the current user' do
      instance.invoke_action :_char_name, [name], true
      expect(instance.current_user.character).not_to be nil
      expect(instance.current_user.character.name).to eq name
    end # specify
    
    specify 'updates the session with the character\'s id' do
      instance.invoke_action :_char_name, [name], true
      expect(request.session[:character_id]).
        to eq instance.current_user.character.id
    end # specify
  end # describe
end # describe
