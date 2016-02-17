FactoryGirl.define do
  factory :loan_request do
    association :creator, factory: :user
  end
end
