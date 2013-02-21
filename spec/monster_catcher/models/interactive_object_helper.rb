# spec/monster_catcher/models/interactive_object_helper.rb

require 'monster_catcher/models/interactive_object'

shared_examples_for MonsterCatcher::Models::InteractiveObject do
  describe :actions do
    specify { expect(instance).to respond_to(:actions).with(0).arguments }
    specify { expect(instance.actions).to be_a Hash }
    
    context 'when set at creation' do
      let :attributes do super().update :actions => {}; end
      
      specify { expect(instance.actions).to eq attributes[:actions] }
    end # context
  end # describe actions
  
  describe :actions= do
    specify { expect(instance).to respond_to(:actions=).with(1).arguments }
    
    specify "updates the value" do
      new_actions = Hash.new
      instance.actions = new_actions
      expect(instance.actions).to eq new_actions
    end # specify
  end # describe actions=
  
  describe :key do
    specify { expect(instance).to respond_to(:key).with(0).arguments }
    
    specify { expect(instance.key).to eq attributes[:key] }
  end # describe
  
  describe :key= do
    let :key do FactoryGirl.generate :explore_node_key; end
    
    specify { expect(instance).to respond_to(:key=).with(1).arguments }
    
    specify 'updates the value' do
      instance.key = key
      expect(instance.key).to eq key
    end # specify
  end # describe
  
  describe :aliases do
    specify { expect(instance).to respond_to(:aliases).with(0).arguments }
    
    specify { expect(instance.aliases).to be_a [Array, nil] }
  end # describe
  
  describe :aliases= do
    let :aliases do [*0..2].map do FactoryGirl.generate :explore_node_object_key; end; end
    
    specify { expect(instance).to respond_to(:aliases=).with(1).arguments }
    
    specify 'sets the value' do
      instance.aliases = aliases
      aliases.each do |name| expect(instance.aliases).to include name; end
    end # specify
  end # describe
end # shared examples

shared_examples_for "MonsterCatcher::Models::InteractiveObject#creation" do
  context 'with packed actions' do
    let :packed_actions do {}.tap do |hsh|
      3.times do
        key   = FactoryGirl.generate(:action_key).to_s
        value = key.gsub('_',' ').capitalize
        hsh[key] = value
      end # times
      2.times do
        key   = "_" + FactoryGirl.generate(:action_key).to_s
        value = key.gsub('_',' ').capitalize
        hsh[key] = value
      end # times
    end; end # tap, let
    
    let :attributes do super().update packed_actions; end
    
    specify 'unpacks any extra attributes into actions' do
      packed_actions.each do |key, value|
        expect(instance.actions[key]).to eq(key =~ /^_/ ? nil : value)
      end # each
    end # specify
    
    specify 'removes unpacked actions from attributes' do
      packed_actions.each do |key, value|
        expect(instance[key]).to eq(key =~ /^_/ ? value : nil)
      end # each
    end # specify
  end # context
end # shared_examples_for
