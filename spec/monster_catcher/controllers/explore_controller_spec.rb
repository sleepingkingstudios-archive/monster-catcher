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
  
  describe :node_string do
    specify { expect(instance).to respond_to(:node_string).with(1).arguments }
    
    specify { expect(instance.node_string node).to eq "You are in #{node.name}." }
    
    context 'with a nameless node' do
      before :each do node.name = nil; end
      
      specify { expect(instance.node_string node).to eq "You are in #{node.region.name}." }
    end # context
  end # describe
  
  describe :edges_string do
    specify { expect(instance).to respond_to(:edges_string).with(1).arguments }

    specify { expect(instance.edges_string node).to eq "There is nowhere to go from here." }
    
    context 'with edges defined on the node' do
      before :each do
        node.edges.create :path => FactoryGirl.generate(:explore_node_key), :direction => "north"
        node.edges.create :path => FactoryGirl.generate(:explore_node_key), :direction => "east"
        node.edges.create :path => FactoryGirl.generate(:explore_node_key), :name => "blind man's bluff"
        node.edges.create :path => FactoryGirl.generate(:explore_node_key), :name => "dead man's tree"
        node.edges.create :path => FactoryGirl.generate(:explore_node_key), :name => "neverland",
          :direction => "second star to the right, and straight on 'till morning"
      end # before each
      
      specify { expect(instance.edges_string node).to match /you can go/i }
      
      specify "lists each of the nodes" do
        text = instance.edges_string node
        
        node.edges.each do |edge|
          expect(text).to match /#{edge.direction}/ unless edge.direction.nil?
          expect(text).to match /to #{edge.name}/ unless edge.name.nil?
        end # each
      end # specify
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
      
      specify { expect(instance.invoke_command text).
        to match /nowhere to go from here/i }
    end # context
    
    context 'with "am I"' do
      let :text do "where am I"; end
      
      specify { expect(instance.invoke_command text).
        to match /you are in #{node.name}/i }
    end # context

    context 'with "can I go"' do
      let :text do "where can I go"; end

      specify { expect(instance.invoke_command text).
        to match /nowhere to go from here/i }
      
      context 'with edges defined on the node' do
        before :each do
          node.edges.create :path => FactoryGirl.generate(:explore_node_key), :direction => "north"
        end # before each
        
        specify { expect(instance.invoke_command text).
          to match /you can go/i }
      end # context
    end # context
    
    context 'with no arguments' do
      let :text do "where"; end
      
      specify { expect(instance.invoke_command text).
        to match /you are in #{node.name}/i }
    end # context
  end # describe
end # describe
