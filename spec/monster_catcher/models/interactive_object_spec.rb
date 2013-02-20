# spec/monster_catcher/models/interactive_object_spec.rb

require 'monster_catcher/spec_helper'
require 'monster_catcher/models/interactive_object_helper'

require 'monster_catcher/models/interactive_object'

describe MonsterCatcher::Models::InteractiveObject do
  describe :constructor do
    specify { expect(described_class).to construct.with(0..1).arguments }
  end # describe
  
  let :attributes do
    Hash.new
  end # let attributes
  
  let :instance do described_class.new attributes; end
  
  it_behaves_like MonsterCatcher::Models::InteractiveObject
  
  describe "validation" do
    specify { expect(instance).to be_valid }
  end # describe
  
  describe "creation" do
    let :instance do super().tap { |rec| rec.save! }; end
    
    it_behaves_like "MonsterCatcher::Models::InteractiveObject#creation"
  end # describe
end # describe
