FactoryGirl.define do
  factory :payment do
    creator { payable.borrowers.first }
    association :payable, factory: :loan
    payees  { payable.lenders }
    payer   { creator }
    payers  { [payable.borrowers.first] }
    amount_cents 100
  end
end
