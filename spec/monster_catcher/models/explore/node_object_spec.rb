# spec/monster_catcher/models/explore/node_object_spec.rb

require 'monster_catcher/spec_helper'
require 'monster_catcher/models/explore/node_object_helper'

require 'monster_catcher/models/explore/node_object'

describe MonsterCatcher::Models::Explore::NodeObject do
  describe :constructor do
    specify { expect(described_class).to construct.with(0..1).arguments }
  end # describe
  
  let :node do FactoryGirl.create :explore_node; end
  let :attributes do
    attrs = FactoryGirl.attributes_for :explore_node_object
    attrs.update :node => node
  end # let
  
  let :instance do described_class.new attributes; end
  it_behaves_like MonsterCatcher::Models::Explore::NodeObject
  
  describe "validation" do
    specify { expect(instance).to be_valid }
  end # describe
  
  describe "creation" do
    let :instance do super().tap { |rec| rec.save! }; end
    
    it_behaves_like "MonsterCatcher::Models::InteractiveObject#creation"
  end # describe
end # describe
