require 'faker'

FactoryGirl.define do
  factory :location do 
    sequence(:name) {|n| "name#{n}"}
    lat  1.45678
    lng  12.5688
    user_id 1
  end
end


