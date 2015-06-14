FactoryGirl.define do
  factory :payment do
    association :creator
    payer { creator }
    loan
  end
end
