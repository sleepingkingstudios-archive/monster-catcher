# spec/monster_catcher/controllers/mixins/user_helpers_spec.rb

require 'monster_catcher/spec_helper'
require 'mithril/mixin'
require 'monster_catcher/controllers/mixins/user_helpers_helper'

require 'monster_catcher/controllers/mixins/user_helpers'

describe MonsterCatcher::Controllers::Mixins::UserHelpers do
  let :request do FactoryGirl.build :request; end
  let :described_class do
    klass = Class.new
    klass.extend Mithril::Mixin
    klass.send :mixin, super()
    klass
  end # let 
  let :instance do
    instance = described_class.new
    instance.stub :request do request; end
    instance
  end # let
  
  it_behaves_like MonsterCatcher::Controllers::Mixins::UserHelpers
end # describe
