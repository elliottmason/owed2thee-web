FactoryGirl.define do
  factory :payment do
    association :creator, factory: :confirmed_user
    association :payee,   factory: :confirmed_user
    payer { creator }
    amount_cents 100
  end
end
