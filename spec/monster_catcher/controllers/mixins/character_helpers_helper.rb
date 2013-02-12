# spec/monster_catcher/controllers/mixins/character_helpers_helper.rb

require 'monster_catcher/controllers/mixins/character_helpers'

shared_examples_for MonsterCatcher::Controllers::Mixins::CharacterHelpers do
  describe :current_character do
    specify { expect(instance).to respond_to(:current_character).with(0).arguments }
  end # describe
  
  context 'with no character id' do
    before :each do request.session.delete :character_id; end
    
    specify { expect(instance.current_character).to be nil }
  end # context
  
  context 'with an invalid charater id' do
    let :character do FactoryGirl.build :character; end
    
    before :each do request.session.update :charater_id => character.id; end
    
    specify { expect(instance.current_character).to be nil }
  end # context

    context 'with a valid user id' do
      let :character do FactoryGirl.create :character; end

      before :each do request.session.update :character_id => character.id; end

      specify { expect(instance.current_character).to eq character }
    end # context
end # shared_examples_for
