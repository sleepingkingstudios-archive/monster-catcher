# spec/monster_catcher/controllers/interactive_controller_spec.rb

require 'monster_catcher/spec_helper'
require 'monster_catcher/controllers/interactive_controller_helper'

require 'monster_catcher/controllers/interactive_controller'

describe MonsterCatcher::Controllers::InteractiveController do
  let :request do FactoryGirl.build :request; end
  let :described_class do Class.new super(); end
  let :instance do described_class.new request; end
  
  it_behaves_like MonsterCatcher::Controllers::InteractiveController
end # describe
