# spec/monster_catcher/support/matchers/have_errors.rb

require 'monster_catcher/support/matchers'

module MonsterCatcher::Support::Matchers
  class HaveErrors
    def matches?(actual)
      @actual = actual
      
      return false unless @validates = actual.respond_to?(:valid?)
      
      actual.invalid? && attributes_have_errors
    end # method matches
    
    def on(attribute)
      expected_errors.update(attribute => []) unless
        expected_errors.has_key?(attribute)
      
      self
    end # method on
    
    def with_message(message)
      raise ArgumentError.new "no attribute specified for error message" if
        expected_errors.empty?
        
      key = expected_errors.keys.last
      expected_errors[key] << message
      
      self
    end # method with_message
    
    def with_messages(*messages)
      messages.each do |message| self.with_message(message); end
      
      self
    end # method with_message
    
    #=# End Public API #=#
    
    def expected_errors
      @expected_errors ||= ActiveSupport::OrderedHash.new
    end # method expected_errors
    
    def unexpected_errors
      @unexpected_errors ||= ActiveSupport::OrderedHash.new
    end # method unexpected_errors
    
    def attributes_have_errors
      expected_errors.each do |attribute, patterns|
        unexpected_errors[attribute] ||= []
        
        next unless @actual.errors.include?(attribute)
        
        messages = @actual.errors.messages[attribute]
        patterns.each do |pattern|
          messages.each do |message|
            if (pattern.is_a?(Regexp) && message =~ pattern) || message == pattern
              unexpected_errors[attribute] << pattern
              patterns.delete pattern and next
            end # if
          end # each
        end # each
        
        expected_errors.delete attribute if patterns.empty?
      end # each
      
      expected_errors.empty?
    end # method attributes_have_errors
    
    def failure_message
      return "expected #{@actual} to respond to valid?" unless @validates
      
      "expected #{@actual} to have errors" + expected_errors.map { |attribute, messages|
        " on #{attribute.inspect}"
      }.compact.join(" and")
    end # method failure_message
    
    def negative_failure_message
      "expected #{@actual} not to have errors" + unexpected_errors.map { |attribute, messages|
        " on #{attribute.inspect}"
      }.compact.join(" and")
    end # method negative_failure_message
    
    def failure_message_for_attribute(attribute)
      return nil unless expected_errors.has_key? attribute
      
      str = " on #{attribute.inspect}"
    end # method failure_message_for_attribute
    
    def failure_message_for_attributes
      
      expected_errors.keys.map { |attribute|
        failure_message_for_attribute(attribute)
      }.compact.join(" and")
    end # method failure_message_for_attributes
    private :failure_message_for_attributes
  end # class
  
  def have_errors
    HaveErrors.new
  end # method have_errors
end # module
