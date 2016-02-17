FactoryGirl.define do
  factory :loan_request do
    association :creator, factory: :user
    amount_requested { Faker::Commerce.price }
  end
end
