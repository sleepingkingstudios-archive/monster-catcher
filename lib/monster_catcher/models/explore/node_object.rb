# lib/monster_catcher/models/explore/node_object.rb

require 'monster_catcher/models/interactive_object'
require 'monster_catcher/models/explore/node'

module MonsterCatcher::Models::Explore
  class NodeObject < MonsterCatcher::Models::InteractiveObject
    # Relations
    embedded_in :node, :class_name => "MonsterCatcher::Models::Explore::Node",
      :inverse_of => :objects
  end # class
end # module
