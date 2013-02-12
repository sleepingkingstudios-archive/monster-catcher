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
  end # describe
  
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
  end # describe
end # describe
