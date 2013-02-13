# spec/controllers/explore_controller_spec.rb

require 'monster_catcher/spec_helper'
require 'mithril/controllers/abstract_controller_helper'
require 'mithril/controllers/mixins/help_actions_helper'
require 'monster_catcher/controllers/mixins/character_helpers_helper'

require 'monster_catcher/controllers/explore_controller'

describe MonsterCatcher::Controllers::ExploreController do
  let :node do
    node = FactoryGirl.build :explore_node
    node.name = node.key.capitalize.gsub('_',' ')
    node.save
    node
  end # let
  let :character do FactoryGirl.create :character, :node_id => node.id; end
  let :request do
    FactoryGirl.build :request, :session => { :character_id => character.id }
  end # let request
  let :described_class do Class.new super(); end
  let :instance do described_class.new request; end
  
  it_behaves_like Mithril::Controllers::AbstractController
  it_behaves_like Mithril::Controllers::Mixins::HelpActions
  it_behaves_like MonsterCatcher::Controllers::Mixins::CharacterHelpers
  
  describe :current_node do
    specify { expect(instance).to respond_to(:current_node).with(0).arguments }
    
    specify { expect(instance.current_node).to eq node }
    
    context 'with no character' do
      let :request do super().tap { |req| req.session.delete :character_id }; end
      
      specify { expect(instance.current_node).to be nil }
    end # context
    
    context 'with a character but no node' do
      let :character do super().tap { |chr| chr.current_node = nil; chr.save }; end
      
      specify { expect(instance.current_node).to be nil }
    end # context
  end # describe
  
  describe "where action" do
    specify { expect(instance).to have_action :where }
    specify { expect(instance).to have_command "where" }
    specify { expect(instance.can_invoke? "where am I").to be true }
    
    context 'with help' do
      let :text do "where help"; end
      
      specify { expect(instance.invoke_command text).
        to match /the where command/i }
    end # context
    
    context 'with no node' do
      before :each do instance.stub :current_node do nil; end; end
      
      let :text do "where"; end
      
      specify { expect(instance.invoke_command text).
        to match /lost in the void between worlds/i }
    end # context
    
    context 'with "am I"' do
      let :text do "where am I"; end
      
      specify { expect(instance.invoke_command text).
        to match /you are in #{node.name}/i }
    end # context
    
    context 'with no arguments' do
      let :text do "where"; end
      
      specify { expect(instance.invoke_command text).
        to match /you are in #{node.name}/i }
    end # context
  end # describe
end # describe
