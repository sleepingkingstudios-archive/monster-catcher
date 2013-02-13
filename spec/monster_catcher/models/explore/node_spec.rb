# spec/monster_catcher/models/explore/node_spec.rb

require 'monster_catcher/spec_helper'

require 'monster_catcher/models/explore/node'

describe MonsterCatcher::Models::Explore::Node do
  describe :constructor do
    specify { expect(described_class).to construct.with(0..1).arguments }
  end # describe
  
  let :attributes do FactoryGirl.attributes_for :explore_node; end
  
  describe "validation" do
    let :instance do described_class.new attributes; end
    
    specify { expect(instance).to be_valid }
    
    describe "requires a key" do
      let :instance do
        instance = described_class.new(attributes.tap { |hsh| hsh.delete :key })
      end # instance
      
      specify { expect(instance).not_to be_valid }
      specify { expect(instance).to have_errors.on(:key).
        with_message(/can't be blank/i) }
    end # describe
  end # describe
  
  describe "creation" do
    let :instance do described_class.new attributes; end
    
    specify { expect { instance.save }.not_to raise_error }
  end # describe
  
  let :instance do described_class.create attributes; end
  
  describe :key do
    specify { expect(instance).to respond_to(:key).with(0).arguments }
    
    specify { expect(instance.key).to eq attributes[:key] }
  end # describe
  
  describe :key= do
    let :key do FactoryGirl.generate :explore_node_key; end
    
    specify { expect(instance).to respond_to(:key=).with(1).arguments }
    
    specify 'updates the value' do
      instance.key = key
      expect(instance.key).to eq key
    end # specify
  end # describe
  
  describe :name do
    specify { expect(instance).to respond_to(:name).with(0).arguments }
    
    specify { expect(instance.name).to be nil }
    
    context 'initialized with name' do
      let :name do FactoryGirl.generate(:explore_node_key).upcase.gsub('_',' '); end
      let :attributes do
        attrs = FactoryGirl.attributes_for :explore_node
        attrs.update :name => name
      end # let
      
      specify { expect(instance.name).to eq name }
    end # context
  end # describe
  
  describe :name= do
    let :name do instance.key.gsub('_',' ').gsub(/node/i,'Spot'); end
    
    specify { expect(instance).to respond_to(:name=).with(1).arguments }
    
    specify 'updates the value' do
      instance.name = name
      expect(instance.name).to eq name
    end # specify
  end # describe
  
  describe :description do
    specify { expect(instance).to respond_to(:description).with(0).arguments }
    
    specify { expect(instance.description).to eq attributes[:description] }
  end # describe
  
  describe :description= do
    let :description do
      "#{instance.key.capitalize.gsub('_',' ')} is a dank hellhole."
    end # let
    
    specify { expect(instance).to respond_to(:description=).with(1).arguments }
    
    specify 'updates the value' do
      instance.description = description
      expect(instance.description).to eq description
    end # specify
  end # describe
end # describe
