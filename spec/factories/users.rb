
require 'faker'

FactoryGirl.define do
  factory :user do
    email "user@user.pl"
    password "123456"
    password_confirmation "123456"
  end
end
