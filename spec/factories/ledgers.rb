FactoryGirl.define do
  factory :ledger do
    association :user_a, factory: :user_with_email
    association :user_b, factory: :user_with_email
  end
end
