# lib/monster_catcher/extensions/object.rb

class Object
  def metaclass
    class << self; self; end
  end # method metaclass
end # class Object
