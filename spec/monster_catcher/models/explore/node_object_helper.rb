# spec/monster_catcher/models/explore/node_object_helper.rb

require 'monster_catcher/models/interactive_object_helper'

require 'monster_catcher/models/explore/node_object'

shared_examples_for MonsterCatcher::Models::Explore::NodeObject do
  it_behaves_like MonsterCatcher::Models::InteractiveObject
  
  describe "embedded in node" do
    specify { expect(instance).to respond_to(:node).with(0).arguments }
    
    specify { expect(instance.node).not_to be nil }
  end # describe
end # shared examples
