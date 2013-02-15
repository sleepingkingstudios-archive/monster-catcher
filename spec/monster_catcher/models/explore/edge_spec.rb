# spec/monster_catcher/models/explore/edge_spec.rb

require 'monster_catcher/spec_helper'

require 'monster_catcher/models/explore/edge'

describe MonsterCatcher::Models::Explore::Edge do
  describe :constructor do
    specify { expect(described_class).to construct.with(0..1).arguments }
  end # describe
  
  let :attributes do FactoryGirl.attributes_for :explore_edge; end
  
  describe "validation" do
    let :instance do described_class.new attributes; end
    
    specify { expect(instance).to be_valid }
    
    describe "requires a name or a direction" do
      context 'with neither a name or a direction' do
        let :attributes do super().tap { |hsh| hsh.delete :name; hsh.delete :direction }; end
        
        specify { expect(instance).not_to be_valid }
        specify { expect(instance).to have_errors.on(:name).
          with_message(/can't be blank/i) }
        specify { expect(instance).to have_errors.on(:direction).
          with_message(/can't be blank/i) }
      end # context
      
      let :instance do
        instance = described_class.new(attributes.tap { |hsh| hsh.delete :name })
      end # instance
      
      specify { expect(instance).not_to be_valid }
      specify { expect(instance).to have_errors.on(:name).
        with_message(/can't be blank/i) }
    end # describe

    describe "requires a path" do
      let :instance do
        instance = described_class.new(attributes.tap { |hsh| hsh.delete :path })
      end # instance

      specify { expect(instance).not_to be_valid }
      specify { expect(instance).to have_errors.on(:path).
        with_message(/can't be blank/i) }
    end # describe

    describe "requires a node" do
      let :instance do
        instance = described_class.new(attributes.tap { |hsh| hsh.delete :node })
      end # instance

      specify { expect(instance).not_to be_valid }
      specify { expect(instance).to have_errors.on(:node).
        with_message(/can't be blank/i) }
    end # describe
  end # describe

  describe "creation" do
    let :instance do described_class.new attributes; end
    
    specify { expect { instance.save }.not_to raise_error }
  end # describe
  
  let :instance do described_class.create attributes; end
  
  describe :name do
    specify { expect(instance).to respond_to(:name).with(0).arguments }
    
    specify { expect(instance.name).to eq attributes[:name] }
  end # describe
  
  describe :name= do
    let :name do FactoryGirl.generate(:explore_node_key).gsub('_',' '); end
    
    specify { expect(instance).to respond_to(:name=).with(1).arguments }
    
    specify 'updates the value' do
      instance.name = name
      expect(instance.name).to eq name
    end # specify
  end # describe
  
  describe :direction do
    specify { expect(instance).to respond_to(:direction).with(0).arguments }
    
    specify { expect(instance.direction).to be nil }
    
    context 'set during initialization' do
      let :direction do "east"; end
      let :attributes do super().update :direction => direction; end
      
      specify { expect(instance.direction).to be attributes[:direction] }
    end # context
  end # describe
  
  describe :direction= do
    let :direction do "east"; end
    
    specify { expect(instance).to respond_to(:direction=).with(1).arguments }
    
    specify 'updates the value' do
      instance.direction = direction
      expect(instance.direction).to eq direction
    end # specify
  end # describe

  describe :path do
    specify { expect(instance).to respond_to(:path).with(0).arguments }

    specify { expect(instance.path).to eq attributes[:path] }
  end # describe

  describe :path= do
    let :path do FactoryGirl.generate :explore_node_key; end

    specify { expect(instance).to respond_to(:path=).with(1).arguments }

    specify 'updates the value' do
      instance.path = path
      expect(instance.path).to eq path
    end # specify
  end # describe
  
  describe "embedded in node" do
    specify { expect(instance).to respond_to(:node).with(0).arguments }
    
    specify { expect(instance.node).not_to be nil }
  end # describe
end # describe