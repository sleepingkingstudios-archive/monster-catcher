# spec/monster_catcher/models/monsters/species_spec.rb

require 'monster_catcher/spec_helper'

require 'monster_catcher/models/monsters/species'

describe MonsterCatcher::Models::Monsters::Species do
  describe :constructor do
    specify { expect(described_class).to construct.with(0..1).arguments }
  end # describe
  
  def self.fields
    [ :hit_points, :physical_attack, :physical_defense, :special_attack,
      :special_defense ]
  end # class method fields
  
  let :attributes do FactoryGirl.attributes_for :monster_species; end
  let :instance do described_class.new attributes; end
  
  fields.each do |field|
    specify { expect(instance).to have_accessor(field).with(attributes[field]) }
    specify { expect(instance).to have_mutator(field).with(150) }
  end # each
  
  describe :name do
    let :name do FactoryGirl.generate :monster_species_name; end
    
    specify { expect(instance).to have_accessor(:name).with(attributes[:name]) }
    specify { expect(instance).to have_mutator(:name).with(name) }
  end # describe
  
  describe :types do
    let :types do %w(fire dragon); end
    
    specify { expect(instance).to have_accessor(:types).with(attributes[:types]) }
    specify { expect(instance).to have_mutator(:types).with(types) }
  end # describe
end # describe
