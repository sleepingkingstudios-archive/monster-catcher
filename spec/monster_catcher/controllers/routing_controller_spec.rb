# spec/controllers/routing_controller_spec.rb

require 'monster_catcher/spec_helper'
require 'mithril/controllers/proxy_controller_helper'
require 'mithril/controllers/mixins/help_actions_helper'

require 'monster_catcher/controllers/routing_controller'

describe MonsterCatcher::Controllers::RoutingController do
  let :request do FactoryGirl.build :request; end
  let :described_class do Class.new super(); end
  let :instance do described_class.new request; end
  
  it_behaves_like Mithril::Controllers::ProxyController
  it_behaves_like Mithril::Controllers::Mixins::HelpActions
  
  describe :current_user do
    specify { expect(instance).to respond_to(:current_user).with(0).arguments }
  end # describe
  
  context 'with no user logged in' do
    specify { expect(instance.current_user).to be nil }
    
    specify { expect(instance.proxy).to be_a MonsterCatcher::Controllers::UserController }
    
    describe "registration" do
      before :each do
        instance.proxy.stub :allow_registration? do true; end
      end # before each
      
      let :attributes do FactoryGirl.attributes_for :user; end
      let :text do "register #{attributes[:name]} #{attributes[:password]}"; end
      
      specify { expect(instance.can_invoke? text).to be true }
      
      specify { expect(instance.invoke_command text)
        .to match /now logged in as #{attributes[:name]}/i }
      
      specify 'creates a new user' do
        instance.invoke_command text
        user = MonsterCatcher::Models::User.where(:name => attributes[:name]).first
        expect(user).not_to be nil
        expect(user.name).to eq attributes[:name]
        expect(user.authenticate attributes[:password]).to be true
      end # specify
      
      specify 'updates the session with the new user\'s id' do
        instance.invoke_command text
        user = MonsterCatcher::Models::User.where(:name => attributes[:name]).first
        expect(user).not_to be nil
        expect(request.session[:user_id]).to eq user.id
      end # specify
    end # describe registration
    
    describe "logging in" do
      let :attributes do FactoryGirl.attributes_for :user; end
      let :text do "login #{attributes[:name]} #{attributes[:password]}"; end
      
      before :each do FactoryGirl.create :user, attributes; end
      
      specify { expect(instance.can_invoke? text).to be true }
      
      specify { expect(instance.invoke_command text)
        .to match /now logged in as #{attributes[:name]}/i }
      
      specify 'updates the session with the new user\'s id' do
        instance.invoke_command text
        user = MonsterCatcher::Models::User.where(:name => attributes[:name]).first
        expect(user).not_to be nil
        expect(request.session[:user_id]).to eq user.id
      end # specify
    end # describe
  end # context
end # describe
