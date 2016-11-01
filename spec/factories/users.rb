FactoryGirl.define do
  factory :user do
    name_first "Test User"
    email "user@example.com"
    password "password"
    password_confirmation "password"
  end
end
