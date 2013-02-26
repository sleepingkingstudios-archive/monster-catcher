# spec/monster_catcher/models/monsters/monster_spec.rb

require 'monster_catcher/spec_helper'

require 'monster_catcher/models/monsters/monster'

describe MonsterCatcher::Models::Monsters::Monster do
  specify { expect(described_class).to construct.with(0..1).arguments }
  
  def self.fields
    [ :level, :hit_points, :physical_attack, :physical_defense,
      :special_attack, :special_defense ]
  end # class method fields
  
  describe "validation" do
    specify { expect(described_class.new attributes).to be_valid }
    
    describe 'requires a species' do
      let :attributes do super().tap { |hsh| hsh.delete :species }; end
      
      specify { expect(instance).not_to be_valid }
      specify { expect(instance).to have_errors.on(:species).
        with_message(/can't be blank/i) }
    end # describe
  end # describe validation
  
  let :species do FactoryGirl.create :monster_species; end
  let :attributes do
    FactoryGirl.attributes_for(:monster).update :species => species
  end # let
  let :instance do described_class.new attributes; end
  
  describe :species do
    let :new_species do FactoryGirl.create :monster_species; end
    
    specify { expect(instance).to have_accessor(:species).with(attributes[:species]) }
    specify { expect(instance).to have_mutator(:species).with(new_species) }
  end # describe user
  
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
    let :types do [%w(fire dragon)]; end
    
    specify { expect(instance).to have_accessor(:types).with(attributes[:types]) }
    specify { expect(instance).to have_mutator(:types).with(types) }
  end # describe
end # describe
