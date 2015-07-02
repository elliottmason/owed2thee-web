FactoryGirl.define do
  factory :loan do
    association :creator,   factory: :user_with_email
    association :recipient, factory: :user_with_email
    sender { creator }
    amount 10

    factory :published_loan, traits: %i(published)
    factory :unpublished_loan

    trait :published do
      after(:create) do |loan, _|
        loan.publish!
      end
    end

    after(:build) do |loan, _|
      loan.borrowers << FactoryGirl.create(:user_with_email)
      loan.lenders << loan.creator
    end
  end
end
