# spec/monster_catcher/controllers/character_controller_spec.rb

require 'monster_catcher/spec_helper'
require 'mithril/controllers/abstract_controller_helper'
require 'mithril/controllers/mixins/callback_helpers_helper'
require 'mithril/controllers/mixins/help_actions_helper'
require 'mithril/errors/action_error'
require 'monster_catcher/controllers/mixins/character_helpers_helper'
require 'monster_catcher/controllers/mixins/user_helpers_helper'

require 'monster_catcher/controllers/character_controller'

describe MonsterCatcher::Controllers::CharacterController do
  let :request do FactoryGirl.build :request; end
  let :described_class do Class.new super(); end
  let :instance do described_class.new request; end
  
  it_behaves_like Mithril::Controllers::AbstractController
  it_behaves_like Mithril::Controllers::Mixins::CallbackHelpers
  it_behaves_like Mithril::Controllers::Mixins::HelpActions
  it_behaves_like MonsterCatcher::Controllers::Mixins::CharacterHelpers
  it_behaves_like MonsterCatcher::Controllers::Mixins::UserHelpers
  
  describe "new game action" do
    let :user do FactoryGirl.create :user; end
    let :request do super().tap { |req| req.session.update :user_id => user.id }; end
    
    specify { expect(instance).to have_action :new_game }
    specify { expect(instance).to have_command "new game" }
    specify { expect(instance.can_invoke? "new game").to be true }
    
    context 'with help' do
      let :arguments do %w(help); end
      let :text do "new game #{arguments.join(" ")}"; end
      
      specify { expect(instance.invoke_command text).
        to match /the new game action/i }
    end # context
    
    context 'with an invalid user' do
      let :user do FactoryGirl.build :user; end
      let :text do "new game"; end
      
      specify { expect { instance.invoke_command text }.
        to raise_error Mithril::Errors::ActionError, /user not to be nil/i }
        
      specify "does not set up a callback" do
        begin
          instance.invoke_command text
        rescue Mithril::Errors::ActionError; end
        
        expect(request.session).not_to have_key :callbacks
      end # specify
    end # context
    
    context 'with a character already defined' do
      let :character do FactoryGirl.create :character, :user => user; end
      let :request do
        super().tap { |req| req.session.update :character_id => character.id }
      end # let
      let :text do "new game"; end
      
      specify { expect(instance.invoke_command text).
        to match /already created a character/i }
        
      specify "does not set up a callback" do
        instance.invoke_command text
        expect(request.session).not_to have_key :callbacks
      end # specify
    end # context
    
    context 'with no arguments' do
      let :text do "new game"; end
      let :callbacks do { "" => "CharacterController,_char_name" }; end
      
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
    let :callbacks do { "" => "CharacterController,_char_name" }; end
    let :request do FactoryGirl.build :request, :session =>
      { :user_id => user.id, :callbacks => callbacks }
    end # let
    
    let :name do FactoryGirl.generate :character_name; end
    
    let! :starter_region do
      MonsterCatcher::Models::Explore::Region.create! :key => "village_aether", :name => "the Village of Aether"
    end # let
    let! :starter_node do
      FactoryGirl.create :explore_node, :key => "main_square", :region => starter_region
    end # let
    let :node_key do
      "#{starter_region.key}:#{starter_node.key}"
    end # let
    
    specify { expect(instance).not_to have_action :_char_name }
    specify { expect(instance).to have_action :_char_name, true }
    specify { expect(instance).not_to have_command "char name" }
    specify { expect(instance.can_invoke? "char name").to be false }
    
    specify { expect(instance.invoke_action :_char_name, [name], true).
      to match /welcome to the world of monster catcher/i }

    specify { expect(instance.invoke_action :_char_name, [name], true).
      to match /#{name}/i }
    
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
    
    specify 'sets the character\'s initial location' do
      instance.invoke_action :_char_name, [name], true
      expect(instance.current_user.character.node_key).to eq node_key
    end # specify
    
    specify 'clears the callback from the session' do
      instance.invoke_action :_char_name, [name], true
      expect(request.session).not_to have_key :callbacks
    end # specify
    
    context 'without a valid user' do
      let :user do FactoryGirl.build :user; end
      
      specify { expect { instance.invoke_action :_char_name, [name], true}.
        to raise_error Mithril::Errors::ActionError, /user not to be nil/i }
      
      specify 'clears the callback from the session' do
        begin
          instance.invoke_action :_char_name, [name], true
        rescue Mithril::Errors::ActionError; end
        expect(request.session).not_to have_key :callbacks
      end # specify
    end # context
    
    context 'with an empty character name' do
      let :name do ""; end
      
      specify { expect(instance.invoke_action :_char_name, [name], true).
        to match /please enter the name of your character/i }
      
      specify 'does not clear the callback from the session' do
        instance.invoke_action :_char_name, [name], true
        expect(request.session).to have_key :callbacks
      end # specify
    end # context
    
    context 'with a character already defined' do
      let :character do FactoryGirl.create :character, :user => user; end
      let :request do
        super().tap { |req| req.session.update :character_id => character.id }
      end # let
      
      specify { expect { instance.invoke_action :_char_name, [name], true}.
        to raise_error Mithril::Errors::ActionError, /current user already has character/i }
      
      specify 'clears the callback from the session' do
        begin
          instance.invoke_action :_char_name, [name], true
        rescue Mithril::Errors::ActionError; end
        expect(request.session).not_to have_key :callbacks
      end # specify
    end # context
  end # describe
  
  describe "continue game action" do
    let :text do "continue game"; end
    let :user do FactoryGirl.create :user; end
    let :request do super().tap { |req| req.session.update :user_id => user.id }; end
    
    specify { expect(instance).to have_action :continue_game }
    specify { expect(instance).to have_command "continue game" }
    specify { expect(instance.can_invoke? text).to be true }
    
    context 'with help' do
      let :text do "continue game help"; end
      
      specify { expect(instance.invoke_command text).
        to match /the continue game command/i }
    end # context
    
    context 'with an invalid user' do
      let :user do FactoryGirl.build :user; end
      
      specify { expect { instance.invoke_command text }.
        to raise_error Mithril::Errors::ActionError, /user not to be nil/i }
        
      specify "does not set character" do
        begin
          instance.invoke_command text
        rescue Mithril::Errors::ActionError; end
        
        expect(request.session).not_to have_key :character_id
      end # specify
    end # context
    
    context 'with a character already defined' do
      let :character do FactoryGirl.create :character, :user => user; end
      let :request do
        super().tap { |req| req.session.update :character_id => character.id }
      end # let
      
      specify { expect { instance.invoke_command text }.
        to raise_error Mithril::Errors::ActionError, /already a character selected/i }
        
      specify "does not set character" do
        begin
          instance.invoke_command text
        rescue Mithril::Errors::ActionError; end
        
        expect(request.session[:character_id]).to eq character.id
      end # specify
    end # context
    
    context 'user does not have a character' do
      specify { expect(instance.invoke_command text).
        to match /not yet created a character/i }
        
      specify "does not set character" do
        instance.invoke_command text
        expect(request.session).not_to have_key :character_id
      end # specify
    end # context
    
    context 'user has a character' do
      let! :character do FactoryGirl.create :character, :user => user; end
      
      specify { expect(instance.invoke_command text).
        to match /welcome back to the world of monster catcher/i }
        
      specify 'updates the session with the character\'s id' do
        instance.invoke_command text
        expect(request.session[:character_id]).to eq character.id
      end # specify
    end # context
  end # describe
end # describe
