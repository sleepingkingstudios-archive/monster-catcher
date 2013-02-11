# spec/monster_catcher/models/user_spec.rb

require 'monster_catcher/spec_helper'

require 'monster_catcher/models/user'

describe MonsterCatcher::Models::User do
  describe :constructor do
    specify { expect(described_class).to construct.with(0).arguments }
  end # describe
  
  describe "validation" do
    let :params do FactoryGirl.attributes_for :user; end

    specify { expect(described_class.new params).to be_valid }
    
    describe "requires a name" do
      let :instance do
        instance = described_class.new(params.tap { |hsh| hsh.delete :name })
      end # instance
      
      specify { expect(instance).not_to be_valid }
      specify { expect(instance).to have_errors.on(:name).
        with_message(/can't be blank/i) }
    end # describe
    
    describe "requires a password" do
      let :instance do
        instance = described_class.new(params.tap { |hsh| hsh.delete :password })
      end # let
      
      specify { expect(instance).not_to be_valid }
      specify { expect(instance).to have_errors.on(:password).
        with_message(/can't be blank/i) }
    end # describe
  end # describe
  
  describe "creation" do
    let :params do FactoryGirl.attributes_for :user; end
    let :instance do described_class.new params; end
    
    specify "encrypts the password" do
      instance.save
      expect(instance.crypt).not_to be nil
    end # specify
  end # describe
  
  let :instance do FactoryGirl.build :user; end
  
  describe :name do
    specify { expect(instance).to respond_to(:name).with(0).arguments }
  end # specify
  
  describe :name= do
    specify { expect(instance).to respond_to(:name=).with(1).arguments }
    
    specify "changes value when set" do
      instance.name = "alan bradley"
      expect(instance.name).to eq "alan bradley"
    end # specify
  end # specify
  
  describe :encrypt_password do
    let :params do
      FactoryGirl.attributes_for(:user).tap do |params| params.delete :password; end
    end # let
    let :instance do described_class.new params; end
    
    specify { expect(instance.crypt).to be nil }
    
    specify { expect(instance).not_to respond_to :encrypt_password }
    
    specify "does not encrypt an empty password" do
      instance.send :encrypt_password
      expect(instance.crypt).to be nil
    end # specify
    
    context "with a password" do
      let :password do FactoryGirl.generate :user_password; end

      specify "encrypts the password" do
        instance.password = password
        instance.send :encrypt_password
        expect(instance.crypt).not_to be nil
      end # specify
      
      specify "clears the plaintext password" do
        instance.password = password
        instance.send :encrypt_password
        expect(instance.password).to be nil
      end # specify
    end # context
  end # describe
  
  context "created" do
    let :params do FactoryGirl.attributes_for :user; end
    let :instance do described_class.create! params; end
    
    describe :authentication do
      specify "authenticates with a valid password" do
        expect(instance.authenticate params[:password]).to be true
      end # specify
      
      specify "does not authenticate with an invalid password" do
        expect(instance.authenticate FactoryGirl.generate(:user_password)).to be false
      end # specify
    end # describe
  end # context
end # describe
