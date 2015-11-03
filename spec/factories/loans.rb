FactoryGirl.define do
  factory :loan, traits: %i(loan) do
    association :creator, factory: :confirmed_user
    amount { Faker::Commerce.price }

    factory :confirmed_loan, traits: %i(confirmed recordable)
    factory :debt, traits: %i(debt)
    factory :published_debt, traits: %i(debt published recordable)
    factory :published_loan, traits: %i(published recordable) do
      factory :unconfirmed_loan
    end
    factory :unpublished_loan

    trait :confirmed do
      after(:create) do |loan, _|
        loan.publish!
        loan.participants.each(&:confirm!)
        loan.confirm!
      end
    end

    trait :debt do
      association :lender, factory: :unconfirmed_user
      borrower { creator }
    end

    trait :loan do
      association :borrower, factory: :confirmed_user
      lender { creator }
    end

    trait :published do
      after(:create) do |loan, _|
        loan.publish!
      end
    end

    after :build do |loan, _|
      loan.borrowers << loan.recipient
      loan.lenders << loan.sender
    end

    trait :recordable do
      after(:create) do |loan, _|
        RecordTransferActivity.with(loan, :created)
      end
    end
  end
end
