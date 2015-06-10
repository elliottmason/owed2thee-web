FactoryGirl.define do
  factory :user do
    password { SecureRandom.hex(8) }
    trait :with_email do
      before(:create) do |user, evaluator|
        user.emails << build(:user_email, user: user)
      end
    end
  end
end
