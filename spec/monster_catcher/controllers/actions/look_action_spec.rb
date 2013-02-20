# spec/monster_catcher/controllers/actions/look_action_spec.rb

require 'monster_catcher/spec_helper'
require 'monster_catcher/controllers/actions/look_action_helper'

require 'monster_catcher/controllers/interactive_controller'
require 'monster_catcher/controllers/actions/look_action'

describe MonsterCatcher::Controllers::Actions::LookAction do
  let :request do FactoryGirl.build :request; end
  let :described_class do
    klass = Class.new MonsterCatcher::Controllers::InteractiveController
    klass.send :mixin, super();
    klass
  end # let
  let :instance do described_class.new request; end
  
  it_behaves_like MonsterCatcher::Controllers::Actions::LookAction
end # describe
