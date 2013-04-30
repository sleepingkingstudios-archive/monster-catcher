# spec/monster_catcher/models/monsters/monster_spec.rb

require 'monster_catcher/spec_helper'

require 'monster_catcher/models/monsters/monster'

describe MonsterCatcher::Models::Monsters::Monster do
  specify { expect(described_class).to construct.with(0..1).arguments }
  
  def self.has_attribute attribute_key
    specify { expect(instance).to have_accessor :"#{attribute_key}" }
    specify { expect(instance).to have_accessor :"base_#{attribute_key}" }
    specify { expect(instance).to have_mutator  :"base_#{attribute_key}" }
  end # class method has_attribute
  
  def self.fields
    [ :hit_points, :physical_attack, :physical_defense, :special_attack,
      :special_defense, :speed ]
  end # class method fields
  
  describe "Monster.attribute" do
    def self.attribute_key; :perspicacity; end
    
    let :described_class do Class.new super(); end
    let :attribute_key   do self.class.attribute_key; end
    
    specify { expect(described_class).to respond_to(:attribute).with(1).arguments }
    specify { expect { described_class.attribute attribute_key }.not_to raise_error }
    
    context 'with an attribute defined' do
      before :each do described_class.attribute attribute_key; end
      
      has_attribute attribute_key
    end # context
  end # describe
  
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
  
  fields.each do |attribute_key|
    has_attribute attribute_key
  end # each
  
  describe :species do
    let :new_species do FactoryGirl.create :monster_species; end
    
    specify { expect(instance).to have_accessor(:species).with(attributes[:species]) }
    specify { expect(instance).to have_mutator(:species).with(new_species) }
  end # describe user
  
  describe :level do
    specify { expect(instance).to have_accessor(:level).with(attributes[:level]) }
    specify { expect(instance).to have_mutator(:level).with(50) }
  end # describe
  
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
  
  describe 'belongs to trainer' do
    let :trainer_class do
      Class.new do
        include Mongoid::Document
        
        has_many :monsters, :as => :mock_trainer,
          :class_name => "MonsterCatcher::Models::Monsters::Monster"
      end # class
    end # let
    let :trainer do trainer_class.new; end
    
    specify { expect(instance).to have_accessor(:trainer).with(nil) }
    specify { expect(instance).to have_mutator(:trainer).with(trainer) }
  end # describe
  
  describe 'embeds many monster techniques' do
    let :techniques do [*0..2].map { FactoryGirl.create :monster_technique }; end
    let :monster_techniques do techniques.map { |technique|
      MonsterCatcher::Models::Monsters::MonsterTechnique.new({ :technique => technique })
    }; end # let
    
    specify { expect(instance).to have_accessor(:monster_techniques).with([]) }
    specify { expect(instance).to have_mutator(:monster_techniques=).with(monster_techniques) }
    
    specify { expect(instance).to have_accessor(:techniques).with([]) }
    specify { expect(instance).to have_mutator(:techniques=).with(techniques) }
    
    context 'with techniques indirectly set' do
      before :each do instance.monster_techniques = monster_techniques; end
      
      specify { expect(instance.techniques).to be == techniques }
      
      specify 'sets the monster in the join model' do
        monster_techniques.each do |monster_technique|
          expect(monster_technique.monster).to be == instance
        end # each
      end # specify
    end # context
  end # describe
end # describe
