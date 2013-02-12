# spec/monster_catcher/controllers/mixins/user_helpers_helper.rb

require 'monster_catcher/controllers/mixins/user_helpers'

shared_examples_for MonsterCatcher::Controllers::Mixins::UserHelpers do
  describe :current_user do
    specify { expect(instance).to respond_to(:current_user).with(0).arguments }
  end # describe
  
  context 'with no user id' do
    before :each do request.session.delete :user_id; end
    
    specify { expect(instance.current_user).to be nil }
  end # context
  
  context 'with an invalid user id' do
    let :user do FactoryGirl.build :user; end
    
    before :each do request.session.update :user_id => user.id; end
    
    specify { expect(instance.current_user).to be nil }
  end # context

    context 'with a valid user id' do
      let :user do FactoryGirl.create :user; end

      before :each do request.session.update :user_id => user.id; end

      specify { expect(instance.current_user).to eq user }
    end # context
end # shared_examples_for
