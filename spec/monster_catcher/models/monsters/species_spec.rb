# spec/monster_catcher/models/monsters/species_spec.rb

require 'monster_catcher/spec_helper'

require 'monster_catcher/models/monsters/species'

describe MonsterCatcher::Models::Monsters::Species do
  describe :constructor do
    specify { expect(described_class).to construct.with(0..1).arguments }
  end # describe
  
  def self.fields
    [ :hit_points, :physical_attack, :physical_defense, :special_attack,
      :special_defense, :speed ]
  end # class method fields
  
  let :attributes do FactoryGirl.attributes_for :monster_species; end
  let :instance do described_class.new attributes; end
  
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
  
  describe :attribute_keys do
    specify { expect(instance).to have_accessor(:attribute_keys).with(self.class.fields.map(&:to_s)) }
  end # describe
  
  fields.each do |field|
    specify { expect(instance).to have_accessor(field).with(attributes[field]) }
    specify { expect(instance).to have_mutator(field).with(1.50) }
  end # each
  
  describe :build do
    specify { expect(instance).to respond_to(:build).with(1..2).arguments }
    
    context 'built' do
      let :level   do 5; end
      let :monster do instance.build level; end
      
      specify { expect(monster).to be_a MonsterCatcher::Models::Monsters::Monster }
      
      specify { expect(monster.species).to eq instance }
      specify { expect(monster.name).to eq instance.name }
      specify { expect(monster.types).to eq instance.types }
      specify { expect(monster.level).to eq level }
    end # context
  end # describe build
end # describe
