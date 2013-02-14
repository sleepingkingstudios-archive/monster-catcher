# spec/monster_catcher/models/explore/node_spec.rb

require 'monster_catcher/spec_helper'

require 'monster_catcher/models/explore/region'

describe MonsterCatcher::Models::Explore::Region do
  describe :constructor do
    specify { expect(described_class).to construct.with(0..1).arguments }
  end # describe
  
  let :attributes do FactoryGirl.attributes_for :explore_region; end
  
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
    
    describe "requires a name" do
      let :instance do
        instance = described_class.new(attributes.tap { |hsh| hsh.delete :name })
      end # instance
      
      specify { expect(instance).not_to be_valid }
      specify { expect(instance).to have_errors.on(:name).
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
    let :key do FactoryGirl.generate :explore_region_key; end
    
    specify { expect(instance).to respond_to(:key=).with(1).arguments }
    
    specify 'updates the value' do
      instance.key = key
      expect(instance.key).to eq key
    end # specify
  end # describe
  
  describe :name do
    specify { expect(instance).to respond_to(:name).with(0).arguments }
    
    specify { expect(instance.name).to eq attributes[:name] }
  end # describe
  
  describe :name= do
    let :name do instance.name.gsub(/region/i,'Field'); end
    
    specify { expect(instance).to respond_to(:name=).with(1).arguments }
    
    specify 'updates the value' do
      instance.name = name
      expect(instance.name).to eq name
    end # specify
  end # describe
  
  describe "has many nodes" do
    describe :nodes do
      specify { expect(instance).to respond_to(:nodes).with(0).arguments }
    end # describe
    
    context 'with nodes added' do
      let :nodes do
        [].tap do |ary| 3.times do ary << FactoryGirl.create(:explore_node, :region => instance); end; end
      end # let
      
      specify "region has nodes" do
        nodes.each do |node|
          expect(instance.nodes).to include node
          expect(node.region).to eq instance
        end # end
      end # specify
    end # context
  end # describe
end # describe
