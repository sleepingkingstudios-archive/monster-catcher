# spec/monster_catcher/controllers/interactive_controller_helper.rb

require 'mithril/controllers/abstract_controller_helper'

require 'mithril/parsers/contextual_parser'
require 'monster_catcher/controllers/interactive_controller'
require 'monster_catcher/models/interactive_object'

shared_examples_for MonsterCatcher::Controllers::InteractiveController do
  it_behaves_like Mithril::Controllers::AbstractController
  
  describe :parser do
    specify { expect(instance.parser).to be_a Mithril::Parsers::ContextualParser }
  end # describe
  
  describe :interactive_objects do
    specify { expect(instance).to respond_to(:interactive_objects).with(0).arguments }
    
    specify { expect(instance.interactive_objects).to be_a Array }
  end # describe
  
  describe :object_actions do
    specify { expect(instance).to respond_to(:object_actions).with(0).arguments }
    
    specify { expect(instance.object_actions).to be_a Hash }
    
    context 'with objects defined' do
      let! :objects do [].tap do |ary|
        shared_key  = FactoryGirl.generate(:action_key).to_s
        
        3.times do
          key  = FactoryGirl.generate(:action_key).to_s
          data = key.gsub('_',' ').gsub(/action/,'data').capitalize
          ary << MonsterCatcher::Models::InteractiveObject.create({
            :key => data.gsub(/data/i,'object'),
            :actions => { key => data, shared_key => data }
          }) # end obj
        end # times
      end; end # tap, let
      
      before :each do instance.stub :interactive_objects do objects; end; end
      
      specify 'maps the object actions to the objects and data' do
        hsh = instance.object_actions
        objects.each do |object|
          object.actions.each do |action, data|
            expect(hsh).to have_key action
            expect(hsh[action]).to have_key object.key
            expect(hsh[action][object.key]).to eq object.actions[action]
          end # each
        end # each
      end # specify
    end # context
  end # describe
end # shared examples
