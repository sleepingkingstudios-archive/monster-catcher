# spec/monster_catcher/models/character_spec.rb

require 'monster_catcher/spec_helper'

require 'monster_catcher/models/character'

describe MonsterCatcher::Models::Character do
  describe :constructor do
    specify { expect(described_class).to construct.with(0..1).arguments }
  end # describe
  
  let :user do FactoryGirl.create :user; end
  let :attributes do
    attrs = FactoryGirl.attributes_for :character
    attrs.update :user_id => user.id
  end # let attributes
  
  describe "validation" do
    specify { expect(described_class.new attributes).to be_valid }
    
    describe "requires a name" do
      let :instance do
        instance = described_class.new(attributes.tap { |hsh| hsh.delete :name })
      end # instance
      
      specify { expect(instance).not_to be_valid }
      specify { expect(instance).to have_errors.on(:name).
        with_message(/can't be blank/i) }
    end # describe

    describe "requires a user" do
      let :instance do
        instance = described_class.new(attributes.tap { |hsh| hsh.delete :user_id })
      end # instance

      specify { expect(instance).not_to be_valid }
      specify { expect(instance).to have_errors.on(:user).
        with_message(/can't be blank/i) }
    end # describe
  end # describe validation
  
  let :instance do described_class.create attributes; end
  
  describe :user do
    let :new_user do FactoryGirl.create :user; end
    
    specify { expect(instance).to have_accessor(:user).with(user) }
    specify { expect(instance).to have_mutator(:user).with(new_user) }
  end # describe user
  
  describe :name do
    let :new_name do FactoryGirl.generate :character_name; end
    
    specify { expect(instance).to have_accessor(:name).with(attributes[:name]) }
    specify { expect(instance).to have_mutator(:name).with(new_name) }
  end # name
  
  describe :node_key do
    let :new_node_key do
      region = FactoryGirl.generate :explore_region_key
      node   = FactoryGirl.generate :explore_node_key
      "#{region}:#{node}"
    end # let
    
    specify { expect(instance).to have_accessor(:node_key).with(nil) }
    specify { expect(instance).to have_mutator(:node_key).with(new_node_key) }
    
    context 'with a node defined at creation' do
      let :attributes do super().update :node_key => new_node_key; end
      
      specify { expect(instance.node_key).to eq new_node_key }
    end # context
  end # describe node_id
  
  describe :current_node do
    let :node do FactoryGirl.create :explore_node; end
    let :node_key do "#{node.region.key}:#{node.key}"; end
    
    specify { expect(instance).to have_accessor(:current_node).with(nil) }
    
    context 'with a node defined at creation' do
      let :attributes do super().update :node_key => node_key; end
      
      specify { expect(instance.current_node).to eq node }
    end # context
    
    context 'with a node set via :node_key=' do
      specify 'returns the node' do
        instance.node_key = node_key
        expect(instance.current_node).to eq node
      end # specify
    end # context
  end # describe current_node
  
  describe :current_node= do
    specify { expect(instance).to respond_to(:current_node=).with(1).arguments }
    
    context 'with a nil value' do
      before :each do instance.current_node = nil; end
      
      specify { expect(instance.node_key).to be nil }
      specify { expect(instance.current_node).to be nil }
    end # context

    context 'with a valid node' do
      let :node do FactoryGirl.create :explore_node; end
      let :node_key do "#{node.region.key}:#{node.key}"; end
      
      before :each do instance.current_node = node; end

      specify { expect(instance.node_key).to eq node_key }
      specify { expect(instance.current_node).to eq node }
    end # context
  end # describe current_node=
  
  describe 'has many monsters' do
    let :monsters do [*0..2].map do FactoryGirl.create :monster; end; end
    
    specify { expect(instance).to have_accessor(:monsters).with([]) }
    specify { expect(instance).to have_mutator(:monsters).with(monsters) }
  end # describe
end # describe
