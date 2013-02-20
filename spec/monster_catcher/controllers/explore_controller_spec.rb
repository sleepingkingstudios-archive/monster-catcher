# spec/controllers/explore_controller_spec.rb

require 'monster_catcher/spec_helper'
require 'mithril/controllers/mixins/help_actions_helper'
require 'monster_catcher/controllers/interactive_controller_helper'
require 'monster_catcher/controllers/actions/look_action_helper'
require 'monster_catcher/controllers/mixins/character_helpers_helper'

require 'monster_catcher/controllers/explore_controller'

describe MonsterCatcher::Controllers::ExploreController do
  let :node do
    node = FactoryGirl.build :explore_node
    node.name = node.key.capitalize.gsub('_',' ')
    node.save
    node
  end # let
  let :node_key do "#{node.region.key}:#{node.key}"; end
  let :character do FactoryGirl.create :character, :node_key => node_key; end
  let :request do
    FactoryGirl.build :request, :session => { :character_id => character.id }
  end # let request
  let :described_class do Class.new super(); end
  let :instance do described_class.new request; end
  
  it_behaves_like Mithril::Controllers::Mixins::HelpActions
  it_behaves_like MonsterCatcher::Controllers::InteractiveController
  it_behaves_like MonsterCatcher::Controllers::Actions::LookAction
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
  
  describe :resolve_edge do
    specify { expect(instance).to respond_to(:resolve_edge).with(1).argument }
    
    context 'with no current node' do
      before :each do instance.stub :current_node do nil; end; end
      
      specify { expect(instance.resolve_edge Hash.new).to be nil }
    end # context
    
    context 'with an empty params hash' do
      specify { expect(instance.resolve_edge Hash.new).to be nil }
    end # context
    
    context 'with an invalid name' do
      let :name do FactoryGirl.generate(:explore_node_key).to_s.gsub('_',' '); end
      
      specify { expect(instance.resolve_edge(:name => name)).to be nil }
    end # context
    
    context 'with an invalid direction' do
      specify { expect(instance.resolve_edge(:direction => "north")).to be nil }
    end # context
    
    context 'with a valid name' do
      let :key do FactoryGirl.generate(:explore_node_key); end
      let :name do key.to_s.gsub('_',' '); end
      let! :edge do node.edges.create :path => key, :name => name; end
      
      specify { expect(instance.resolve_edge :name => name).to eq edge }
    end # context

    context 'with a valid direction' do
      let :key do FactoryGirl.generate(:explore_node_key); end
      let! :edge do node.edges.create :path => key, :direction => "south"; end

      specify { expect(instance.resolve_edge :direction => "south").to eq edge }
    end # context
  end # describe
  
  describe :resolve_node do
    specify { expect(instance).to respond_to(:resolve_node).with(1).argument }
    
    context 'with no current node' do
      before :each do instance.stub :current_node do nil; end; end
      
      specify { expect(instance.resolve_node Hash.new).to be nil }
    end # context
    
    context 'with an empty params hash' do
      specify { expect(instance.resolve_node Hash.new).to be nil }
    end # context
    
    context 'with an invalid name' do
      let :name do FactoryGirl.generate(:explore_node_key).to_s.gsub('_',' '); end
      
      specify { expect(instance.resolve_node(:name => name)).to be nil }
    end # context
    
    context 'with an invalid direction' do
      specify { expect(instance.resolve_node(:direction => "north")).to be nil }
    end # context
    
    context 'with a valid edge but no node' do
      let :key do FactoryGirl.generate(:explore_node_key); end
      let :name do key.to_s.gsub('_',' '); end
      let! :edge do node.edges.create :path => key, :name => name; end
      
      specify { expect(instance.resolve_node :name => name).to be nil }
    end # context
    
    context 'with a valid edge and node in the same region' do
      let :destination do FactoryGirl.create :explore_node, :region => node.region; end
      let :name do destination.key.to_s.gsub('_',' '); end
      let! :edge do node.edges.create :path => destination.key, :name => name; end
      
      specify { expect(instance.resolve_node :name => name).to eq destination }
    end # context

    context 'with a valid edge and node in another region' do
      let :destination do FactoryGirl.create :explore_node; end
      let :name do destination.key.to_s.gsub('_',' '); end
      let :path do "#{destination.region.key}:#{destination.key}"; end
      let! :edge do node.edges.create :path => path, :name => name; end

      specify { expect(instance.resolve_node :name => name).to eq destination }
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
  
  describe "go action" do
    let :text do "go to valhalla"; end
    
    specify { expect(instance).to have_action :go }
    specify { expect(instance).to have_command "go" }
    specify { expect(instance.can_invoke? text).to be true }
    
    context 'with "help"' do
      let :text do "go help"; end
      
      specify { expect(instance.invoke_command text).
        to match /the go command/i }
    end # context
    
    context 'with no arguments' do
      let :text do "go"; end
      
      specify { expect(instance.invoke_command text).
        to match /please choose a direction to go in or a named location to go to/i }
    end # context
    
    context 'with an invalid direction' do
      let :direction do "east"; end
      let :text do "go #{direction}"; end
      
      specify { expect(instance.invoke_command text).
        to match /i'm sorry, I don't know how to go #{direction} from here/i }
    end # context
    
    context 'with an invalid named location' do
      let :name do FactoryGirl.generate(:explore_node_key).to_s.gsub('_',' '); end
      let :text do "go to #{name}"; end
      
      specify { expect(instance.invoke_command text).
        to match /i'm sorry, I don't know where #{name} is/i }
    end # context
    
    context 'with edges defined' do
      let :nodes do [].tap do |ary|
        3.times do ary << FactoryGirl.create(:explore_node, :region => node.region); end
        ary << FactoryGirl.create(:explore_node)
      end; end # let
      let :edges do
        paths = nodes.map(&:key)
        node.edges.create :path => paths[0], :direction => "north east"
        node.edges.create :path => paths[1], :name => nodes[1].key.gsub('_',' ')
        node.edges.create :path => paths[2],
          :name => nodes[2].key.gsub('_',' '), :direction => "south west"
        node.edges.create :path => "#{nodes[3].region.key}:#{nodes[3].key}",
          :direction => "down once more"
        
        node.edges
      end # let
      
      context 'with a valid direction' do
        let :text do "go #{edges[0].direction}"; end
        
        specify { expect(instance.invoke_command text).
          to match /#{nodes[0].description}/i }
        
        specify 'updates the current node' do
          instance.invoke_command text
          expect(instance.current_character.current_node).to eq nodes[0]
        end # specify
      end # context
      
      context 'with a valid name' do
        let :text do "go to #{edges[1].name}"; end
        
        specify { expect(instance.invoke_command text).
          to match /#{nodes[1].description}/i }
        
        specify 'updates the current node' do
          instance.invoke_command text
          expect(instance.current_character.current_node).to eq nodes[1]
        end # specify
      end # context
      
      context 'with a valid direction (and name)' do
        let :text do "go #{edges[2].direction}"; end

        specify { expect(instance.invoke_command text).
          to match /#{nodes[2].description}/i }

        specify 'updates the current node' do
          instance.invoke_command text
          expect(instance.current_character.current_node).to eq nodes[2]
        end # specify
      end # context

      context 'with a valid name (and direction)' do
        let :text do "go to #{edges[2].name}"; end

        specify { expect(instance.invoke_command text).
          to match /#{nodes[2].description}/i }

        specify 'updates the current node' do
          instance.invoke_command text
          expect(instance.current_character.current_node).to eq nodes[2]
        end # specify
      end # context
      
      context 'with a valid name and direction' do
        let :text do "go #{edges[2].direction} to #{edges[2].name}"; end

        specify { expect(instance.invoke_command text).
          to match /#{nodes[2].description}/i }

        specify 'updates the current node' do
          instance.invoke_command text
          expect(instance.current_character.current_node).to eq nodes[2]
        end # specify
      end # context

      context 'with a valid direction to another region' do
        let :text do "go #{edges[3].direction}"; end

        specify { expect(instance.invoke_command text).
          to match /#{nodes[3].description}/i }

        specify 'updates the current node' do
          instance.invoke_command text
          expect(instance.current_character.current_node).to eq nodes[3]
        end # specify
      end # context
    end # context
  end # describe
end # describe
