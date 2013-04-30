# spec/monster_catcher/models/monsters/monster_technique_spec.rb

require 'monster_catcher/spec_helper'
require 'monster_catcher/models/monsters/monster_technique'

describe MonsterCatcher::Models::Monsters::MonsterTechnique do
  let :monster do FactoryGirl.create :monster; end
  let :technique do FactoryGirl.create :monster_technique; end
  let :attributes do { :monster => monster, :technique => technique }; end
  let :instance do described_class.new attributes; end
  
  describe 'embedded in monster' do
    let :new_monster do FactoryGirl.create :monster; end
    
    specify { expect(instance).to have_accessor(:monster).with(monster) }
    specify { expect(instance).to have_mutator(:monster).with(new_monster) }
  end # describe
  
  describe 'belongs to technique' do
    let :new_technique do FactoryGirl.create :monster_technique; end
    
    specify { expect(instance).to have_accessor(:technique).with(technique) }
    specify { expect(instance).to have_mutator(:technique).with(new_technique) }
  end # describe
  
  describe 'validation' do
    describe 'monster must not be nil' do
      let :monster do nil; end
      
      specify { expect(instance).to have_errors.on(:monster).with_message("can't be blank") }
    end # describe
    
    describe 'technique must not be nil' do
      let :technique do nil; end
      
      specify { expect(instance).to have_errors.on(:technique).with_message("can't be blank") }
    end # describe
  end # describe
end # describe