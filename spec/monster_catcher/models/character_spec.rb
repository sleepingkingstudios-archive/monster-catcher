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
    specify { expect(instance).to respond_to(:user).with(0).arguments }
    specify { expect(instance.user).to eq user }
  end # describe user
  
  describe :user= do
    specify { expect(instance).to respond_to(:user=).with(1).arguments }
    
    specify "updates the value" do
      new_user = FactoryGirl.create :user
      instance.user = new_user
      expect(instance.user).to eq new_user
    end # specify
  end # describe user=
  
  describe :name do
    specify { expect(instance).to respond_to(:name).with(0).arguments }
    
    specify { expect(instance.name).to eq attributes[:name] }
  end # describe name
  
  describe :name= do
    let :name do FactoryGirl.generate :character_name; end
    
    specify { expect(instance).to respond_to(:name).with(0).arguments }
    
    specify 'updates the value' do
      instance.name = name
      expect(instance.name).to eq name
    end # specify
  end # describe name=
  
  describe :node_id do
    specify { expect(instance).to respond_to(:node_id).with(0).arguments }
    
    specify { expect(instance.node_id).to be nil }
    
    context 'with a node defined at creation' do
      let :node do FactoryGirl.create :explore_node; end
      let :attributes do super().update :node_id => node.id; end
      
      specify { expect(instance.node_id).to eq node.id }
    end # context
  end # describe node_id
  
  describe :node_id= do
    let :node do FactoryGirl.create :explore_node; end
    
    specify { expect(instance).to respond_to(:node_id=).with(1).arguments }
    
    specify 'updates the value' do
      instance.node_id = node.id
      expect(instance.node_id).to eq node.id
    end # specify
  end # describe node_id=
  
  describe :current_node do
    specify { expect(instance).to respond_to(:current_node).with(0).arguments }
    
    specify { expect(instance.current_node).to be nil }
    
    context 'with a node defined at creation' do
      let :node do FactoryGirl.create :explore_node; end
      let :attributes do super().update :node_id => node.id; end
      
      specify { expect(instance.current_node).to eq node }
    end # context
    
    context 'with a node set via :node=' do
      let :node do FactoryGirl.create :explore_node; end
      
      specify 'returns the node' do
        instance.node_id = node.id
        expect(instance.current_node).to eq node
      end # specify
    end # context
  end # describe current_node
  
  describe :current_node= do
    specify { expect(instance).to respond_to(:current_node=).with(1).arguments }
    
    context 'with a nil value' do
      before :each do instance.current_node = nil; end
      
      specify { expect(instance.node_id).to be nil }
      specify { expect(instance.current_node).to be nil }
    end # context

    context 'with a valid node' do
      let :node do FactoryGirl.create :explore_node; end
      before :each do instance.current_node = node; end

      specify { expect(instance.node_id).to eq node.id }
      specify { expect(instance.current_node).to eq node }
    end # context
  end # describe current_node=
end # describe
