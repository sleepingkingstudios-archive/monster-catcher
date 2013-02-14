# spec/monster_catcher/controllers/mixins/character_helpers_helper.rb

require 'monster_catcher/controllers/mixins/character_helpers'

shared_examples_for MonsterCatcher::Controllers::Mixins::CharacterHelpers do
  describe :current_character do
    specify { expect(instance).to respond_to(:current_character).with(0).arguments }
  end # describe
  
  context 'when does not respond to current_user' do
    before :each do
      described_class.send(:undef_method, :current_user) if instance.respond_to?(:current_user)
    end # before each
    
    context 'with no character id' do
      before :each do request.session.delete :character_id; end
    
      specify { expect(instance.current_character).to be nil }
    end # context
  
    context 'with an invalid character id' do
      let :character do FactoryGirl.build :character; end
    
      before :each do request.session.update :charater_id => character.id; end
    
      specify { expect(instance.current_character).to be nil }
    end # context

    context 'with a valid user id' do
      let :character do FactoryGirl.create :character; end

      before :each do request.session.update :character_id => character.id; end

      specify { expect(instance.current_character).to eq character }
    end # context
  end # context
  
  context 'when responds to current_user' do
    let :user do nil; end
    let :character do FactoryGirl.create :character; end
    let :request do super().tap do |req| req.session.update :character_id => character.id; end; end
    let :instance do super().tap do |obj| obj.stub :current_user do user; end; end; end
    
    context 'with no user' do
      specify { expect(instance.current_character).to be nil }
    end # context
    
    context 'with an invalid user' do
      let :user do FactoryGirl.build :user; end
      
      specify { expect(instance.current_character).to be nil }
    end # specify

    context 'with a valid user' do
      let :user do FactoryGirl.create :user; end

      context 'not matching character.user' do
        specify { expect(instance.current_character).to be nil }
      end # context
            
      context 'matching character.user' do
        let :character do FactoryGirl.create :character, :user_id => user.id; end
        
        specify { expect(instance.current_character).to eq character }
      end # context
    end # specify
  end # context
end # shared_examples_for
