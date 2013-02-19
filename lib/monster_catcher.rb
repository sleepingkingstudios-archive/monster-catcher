# lib/monster_catcher.rb

require 'pathname'

module MonsterCatcher
  def self.root
    Pathname.new File.dirname(__FILE__).gsub('/lib','')
  end # class method root
end # module
