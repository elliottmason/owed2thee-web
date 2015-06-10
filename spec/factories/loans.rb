FactoryGirl.define do
  factory :loan do
    association :creator, factory: :user_with_email
    amount 10

    after(:build) do |loan, _|
      loan.borrowers << FactoryGirl.create(:user_with_email)
      loan.lenders << loan.creator
    end
  end
end
