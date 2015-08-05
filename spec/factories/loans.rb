FactoryGirl.define do
  factory :loan, traits: %i(loan) do
    association :creator, factory: :confirmed_user
    amount { Faker::Commerce.price }

    factory :debt, traits: %i(debt)
    factory :published_debt, traits: %i(debt published)
    factory :published_loan, traits: %i(published)
    factory :unpublished_loan

    trait :debt do
      association :sender, factory: :unconfirmed_user
      recipient { creator }
    end

    trait :loan do
      association :recipient, factory: :confirmed_user
      sender { creator }
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
  end
end
