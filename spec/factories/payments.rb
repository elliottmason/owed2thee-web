FactoryGirl.define do
  factory :payment do
    association :creator, factory: :confirmed_user
    association :payable, factory: :loan
    payees  { [FactoryGirl.create(:confirmed_user)] }
    payer   { creator }
    payers  { [creator] }
    amount_cents 1
  end
end
