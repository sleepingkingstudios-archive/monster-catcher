# spec/monster_catcher/matchers/have_errors_spec.rb

require 'monster_catcher/spec_helper'

describe MonsterCatcher::Support::Matchers::HaveErrors do
  describe :constructor do
    specify { expect(described_class).to construct.with(0).arguments }
  end # describe
  
  let :instance do described_class.new; end
  
  context "with a non-record object" do
    let :record do Object.new; end
    
    specify { expect(instance.matches? record).to be false }
    
    specify { expect(record).not_to have_errors }
    
    specify "failure message expects record to respond to valid?" do
      instance.matches?(record)
      expect(instance.failure_message).to match /respond to valid/i
    end # specify
  end # context
  
  context "with a record" do
    let :model do
      klass = Class.new do
        include ActiveModel::Validations
        
        def initialize(params = nil)
          (params || {}).each do |key, value|
            self.send :"#{key}=", value
          end # each
        end # method initialize
        
        attr_accessor :foo, :bar, :baz
        
        validates_each :foo, :bar do |record, attr, value|
          record.errors.add attr, 'not to be nil' if value.nil?
        end # validates
        
        validates_each :foo do |record, attr, value|
          record.errors.add attr, 'to be 1s and 0s' if
            value.nil? || value != value.gsub(/[^01]/,'')
        end # validates
      end # anonymous class
    end # let
    let :record do model.new; end
    let :valid_record do model.new :foo => "10010011101", :bar => "bar"; end
    
    specify { expect(instance.matches? record).to be true }
    
    specify { expect(record).to have_errors }
    specify { expect(valid_record).not_to have_errors }
    
    describe :on do
      specify { expect(instance).to respond_to(:on).with(1).arguments }
      specify { expect(instance.on(:foo)).to be instance }
      
      specify { expect(instance.on(:foo).matches?(record)).to be true }
      specify { expect(instance.on(:baz).matches?(record)).to be false }
      
      specify { expect(instance.on(:foo).matches?(valid_record)).to be false }
      
      specify "failure message names attribute" do
        instance
        expect(instance.on(:baz).matches?(record)).to be false
        expect(instance.failure_message).to match /on :baz/
      end # specify

      specify "negative failure message names attribute" do
        instance
        expect(instance.on(:foo).matches?(record)).to be true
        expect(instance.negative_failure_message).to match /on :foo/
      end # specify
      
      specify { expect(record).to have_errors.on(:foo) }
      specify { expect(record).to have_errors.on(:bar) }
      specify { expect(record).to have_errors.on(:foo).on(:bar) }
      specify { expect(record).not_to have_errors.on(:baz) }
      specify { expect(record).not_to have_errors.on(:wibble) }
      
      specify { expect(valid_record).not_to have_errors.on(:foo) }
      specify { expect(valid_record).not_to have_errors.on(:bar) }
      specify { expect(valid_record).not_to have_errors.on(:baz) }
      specify { expect(valid_record).not_to have_errors.on(:foo).on(:bar).on(:baz) }
      specify { expect(record).not_to have_errors.on(:wibble) }
    end # describe
    
    describe :with_message do
      specify { expect(instance).to respond_to(:with_message).with(1).arguments }
      specify { expect(instance).to respond_to(:with_messages).with(1..9001).arguments }
      
      specify { expect { instance.with_message "foo"}.to raise_error ArgumentError,
        /no attribute specified/i }
      specify { expect { instance.with_messages "foo", "bar"}.to raise_error ArgumentError,
        /no attribute specified/i }
      
      specify { expect(instance.on(:foo).with_message "foo").to be instance }
      specify { expect(instance.on(:foo).with_messages "foo", "bar").to be instance }
      
      specify { expect(instance.on(:foo).with_message("not to be nil").
        matches?(record)).to be true }
      specify { expect(instance.on(:foo).with_message(/to be 1s and 0s/i).
        matches?(record)).to be true }
      specify { expect(instance.on(:foo).with_message(/to be or not to be/i).
        matches?(record)).to be false }
      specify { expect(instance.on(:bar).with_message("not to be nil").
        matches?(record)).to be true }
      specify { expect(instance.on(:bar).with_message(/to be 1s and 0s/i).
        matches?(record)).to be false }
      specify { expect(instance.on(:bar).with_message(/to be or not to be/i).
        matches?(record)).to be false }
      specify { expect(instance.on(:baz).with_message("not to be nil").
        matches?(record)).to be false }
      specify { expect(instance.on(:baz).with_message(/to be 1s and 0s/i).
        matches?(record)).to be false }
      specify { expect(instance.on(:baz).with_message(/to be or not to be/i).
        matches?(record)).to be false }
        
      specify { expect(instance.on(:bar).with_message("not to be nil").
        matches?(valid_record)).to be false }
      specify { expect(instance.on(:foo).with_message(/to be 1s and 0s/i).
        matches?(valid_record)).to be false }
      specify { expect(instance.on(:baz).with_message(/to be or not to be/i).
        matches?(valid_record)).to be false }
    end # describe
  end # context
end # describe
