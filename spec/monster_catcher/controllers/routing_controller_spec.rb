# spec/controllers/routing_controller_spec.rb

require 'monster_catcher/spec_helper'
require 'mithril/controllers/proxy_controller_helper'

require 'monster_catcher/controllers/routing_controller'

describe MonsterCatcher::Controllers::RoutingController do
  let :request do FactoryGirl.build :request; end
  let :described_class do Class.new super(); end
  let :instance do described_class.new request; end
  
  it_behaves_like Mithril::Controllers::ProxyController
end # describe
