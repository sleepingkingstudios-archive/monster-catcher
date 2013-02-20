# spec/monster_catcher/controllers/actions/look_action_helper.rb

require 'mithril/controllers/mixins/actions_base_helper'

require 'monster_catcher/controllers/actions/look_action'

shared_examples_for MonsterCatcher::Controllers::Actions::LookAction do
  it_behaves_like Mithril::Controllers::Mixins::ActionsBase
  
  describe "look action" do
    let :text do "look"; end
    
    specify { expect(instance).to have_action :look }
    specify { expect(instance).to have_command "look" }
    specify { expect(instance.can_invoke? text).to be true }
    
    context 'with "help"' do
      let :text do "look help"; end
      
      specify { expect(instance.invoke_command text).to match /the look command/i }
    end # context
    
    context 'with no current node' do
      before :each do instance.stub :current_node do nil; end; end
      
      specify { expect(instance.invoke_command text).
        to match /an echoing, timeless void/i }
    end # context
    
    context 'with a current node' do
      let :node do FactoryGirl.create :explore_node; end
      
      before :each do instance.stub :current_node do node; end; end
      
      context 'with no arguments' do
        specify { expect(instance.invoke_command text).to match /#{node.description}/ }
      end # context
      
      context 'with an invalid object' do
        let :text do "look at #{FactoryGirl.generate :explore_node_object_key}"; end
        
        specify { expect(instance.invoke_command text).
          to match(/i'm sorry, I don't see/i) }
      end # context
      
      context 'with a valid object' do
        let :object do
          obj = FactoryGirl.create :explore_node_object, :node => node
          obj.actions = { "look" => obj.key.to_s.gsub(/object/i, 'Data') }
          obj
        end # let object
        let :text do "look at #{object.key}"; end
        
        before :each do instance.stub :interactive_objects do [object]; end; end
        
        specify { expect(instance.invoke_command text).
          to match(/#{object.actions["look"]}/) }
      end # context
    end # context
  end # describe
end # shared examples
