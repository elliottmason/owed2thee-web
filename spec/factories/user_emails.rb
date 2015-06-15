FactoryGirl.define do
  factory :user_email do
    email { Faker::Internet.email }
  end
end
