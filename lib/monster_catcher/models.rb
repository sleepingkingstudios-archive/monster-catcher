# lib/monster_catcher/models.rb

require 'mongoid'
require 'yaml'

require 'monster_catcher'

module MonsterCatcher
  module Models
    module YAMLDocument
      def initialize(attrs = nil, options = nil)
        if attrs.is_a?(String) && attrs =~ /^---/
          attrs = YAML::load attrs
        end # if
        
        super(attrs, options)
      end # method initialize
    end # module
  end # module
end # module
