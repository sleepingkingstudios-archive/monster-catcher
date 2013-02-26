# spec/monster_catcher/models/monsters/technique_spec.rb

require 'monster_catcher/spec_helper'

require 'monster_catcher/models/monsters/technique'

describe MonsterCatcher::Models::Monsters::Technique do
  specify { expect(described_class).to construct.with(0..1).arguments }
  
  let :attributes do FactoryGirl.attributes_for :monster_technique; end
  let :instance do described_class.new attributes; end
  
  describe :name do
    let :name do FactoryGirl.generate :monster_technique_name; end
    
    specify { expect(instance).to have_accessor(:name).with(attributes[:name]) }
    specify { expect(instance).to have_mutator(:name).with(name) }
  end # describe

  describe :types do
    let :types do [%w(leaf water)]; end

    specify { expect(instance).to have_accessor(:types).with(attributes[:types]) }
    specify { expect(instance).to have_mutator(:types).with(types) }
  end # describe
  
  [:damage, :accuracy].each do |field|
    specify { expect(instance).to have_accessor(field).with(attributes[field]) }
    specify { expect(instance).to have_mutator(field).with(150) }
  end # each
end # describe
