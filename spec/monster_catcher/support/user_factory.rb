# spec/monster_catcher/support/factories/user_factory.rb

require 'monster_catcher/models/user'

FactoryGirl.define do
  sequence :user_name do |index| "user_#{index}" end
  sequence :user_password do |index|
    chars = [*"0".."9", *"a".."z"]
    [*0..rand(6..18)].inject("") {|m, n| m + chars[rand(36)] }
  end # sequence
  
  factory :user, :class => MonsterCatcher::Models::User do
    name { generate :user_name }
    password { generate :user_password }
  end # factory
end # define
